import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Real photo/logo/gallery for a named institution, resolved from the free,
/// keyless Wikidata + Wikipedia (MediaWiki) APIs — no Google Places, no API
/// key, no billing. Coverage is best-effort: most small local schools and
/// coaching branches won't have a Wikidata/Wikipedia entry at all, in which
/// case every field is null/empty and callers fall back to the existing
/// gradient+icon placeholder, exactly like a missing OSM tag.
class InstitutionMedia {
  const InstitutionMedia({
    this.photoUrl,
    this.logoUrl,
    this.galleryUrls = const [],
  });

  final String? photoUrl;
  final String? logoUrl;
  final List<String> galleryUrls;

  static const empty = InstitutionMedia();
}

class InstitutionMediaService {
  InstitutionMediaService._();

  static const _userAgent = 'EduNavigateAI/1.0 (student career guidance app)';

  /// Session-only cache keyed by wikidata id or "lang:Title" — avoids
  /// re-fetching the same institution's media every time a card rebuilds.
  static final Map<String, InstitutionMedia> _cache = {};

  /// [wikidataId] e.g. `"Q12345"`. [wikipediaTitle] e.g. `"en:Allen Career
  /// Institute"` (lang-prefixed, same convention as OSM's `wikipedia` tag).
  /// Pass whichever is known — at least one non-empty value is required for
  /// a lookup to happen, otherwise this resolves immediately to
  /// [InstitutionMedia.empty] with no network call.
  static Future<InstitutionMedia> fetch({
    String? wikidataId,
    String? wikipediaTitle,
  }) async {
    final key = (wikidataId != null && wikidataId.isNotEmpty)
        ? wikidataId
        : wikipediaTitle;
    if (key == null || key.trim().isEmpty) return InstitutionMedia.empty;
    final cached = _cache[key];
    if (cached != null) return cached;
    final media = await _fetchUncached(
      wikidataId: wikidataId,
      wikipediaTitle: wikipediaTitle,
    );
    _cache[key] = media;
    return media;
  }

  static Future<InstitutionMedia> _fetchUncached({
    String? wikidataId,
    String? wikipediaTitle,
  }) async {
    try {
      String? lang;
      String? title;
      if (wikipediaTitle != null && wikipediaTitle.contains(':')) {
        final i = wikipediaTitle.indexOf(':');
        lang = wikipediaTitle.substring(0, i).trim();
        title = wikipediaTitle.substring(i + 1).trim();
        if (lang.isEmpty || title.isEmpty) {
          lang = null;
          title = null;
        }
      }

      String? photoUrl;
      String? logoUrl;

      if (wikidataId != null && wikidataId.isNotEmpty) {
        final entity = await _wikidataEntity(wikidataId);
        photoUrl = _imageFromClaims(entity, 'P18');
        logoUrl = _imageFromClaims(entity, 'P154');
        if (lang == null) {
          final sitelinks = entity?['sitelinks'] as Map<String, dynamic>?;
          final enwiki = sitelinks?['enwiki'] as Map<String, dynamic>?;
          final sitelinkTitle = enwiki?['title'] as String?;
          if (sitelinkTitle != null && sitelinkTitle.isNotEmpty) {
            lang = 'en';
            title = sitelinkTitle;
          }
        }
      }

      var gallery = <String>[];
      if (lang != null && title != null) {
        photoUrl ??= await _wikipediaSummaryThumbnail(lang, title);
        gallery = await _wikipediaPageImages(lang, title);
      }

      photoUrl ??= gallery.isNotEmpty ? gallery.first : null;

      return InstitutionMedia(
          photoUrl: photoUrl, logoUrl: logoUrl, galleryUrls: gallery);
    } catch (_) {
      return InstitutionMedia.empty;
    }
  }

  static Future<Map<String, dynamic>?> _wikidataEntity(
      String wikidataId) async {
    try {
      final uri = Uri.parse('https://www.wikidata.org/w/api.php').replace(
        queryParameters: {
          'action': 'wbgetentities',
          'ids': wikidataId,
          'props': 'claims|sitelinks',
          'sitefilter': 'enwiki',
          'format': 'json',
          'origin': '*',
        },
      );
      final res = await http.get(uri, headers: {
        'User-Agent': _userAgent
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final entities = json['entities'] as Map<String, dynamic>?;
      return entities?[wikidataId] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  static String? _imageFromClaims(
      Map<String, dynamic>? entity, String property) {
    final claims = entity?['claims'] as Map<String, dynamic>?;
    final list = claims?[property] as List?;
    if (list == null || list.isEmpty) return null;
    final mainsnak = (list.first as Map)['mainsnak'] as Map?;
    final dataValue = mainsnak?['datavalue'] as Map?;
    final fileName = dataValue?['value'] as String?;
    if (fileName == null || fileName.isEmpty) return null;
    return _commonsFilePath(fileName);
  }

  static String _commonsFilePath(String fileName) {
    final encoded = Uri.encodeComponent(fileName.replaceAll(' ', '_'));
    return 'https://commons.wikimedia.org/wiki/Special:FilePath/$encoded?width=800';
  }

  static Future<String?> _wikipediaSummaryThumbnail(
      String lang, String title) async {
    try {
      final uri = Uri.parse(
          'https://$lang.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(title)}');
      final res = await http.get(uri, headers: {
        'User-Agent': _userAgent
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final thumbnail = json['thumbnail'] as Map<String, dynamic>?;
      return thumbnail?['source'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Commons file-name substrings that mark an image as a wiki-chrome icon
  /// (edit pencils, flags, locks…) rather than an actual campus/building
  /// photo, so the gallery doesn't fill up with UI cruft.
  static const _excludedFilePatterns = [
    'commons-logo',
    'wiktionary',
    'wikidata-logo',
    'question_book',
    'edit-',
    'ambox',
    'folder',
    'flag_of',
    'symbol_',
    'blue_pog',
    'red_pog',
    'location_dot',
    'octicons',
    'padlock',
    'text_document',
    'crystal_clear',
    'p_vip',
    'wiki_letter',
  ];

  static Future<List<String>> _wikipediaPageImages(
      String lang, String title) async {
    try {
      final uri = Uri.parse('https://$lang.wikipedia.org/w/api.php').replace(
        queryParameters: {
          'action': 'query',
          'titles': title,
          'generator': 'images',
          'gimlimit': '20',
          'prop': 'imageinfo',
          'iiprop': 'url|mime',
          'format': 'json',
          'origin': '*',
        },
      );
      final res = await http.get(uri, headers: {
        'User-Agent': _userAgent
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return const [];
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final pages = (json['query'] as Map<String, dynamic>?)?['pages']
          as Map<String, dynamic>?;
      if (pages == null) return const [];
      final urls = <String>[];
      for (final page in pages.values) {
        final imageInfo = (page as Map<String, dynamic>)['imageinfo'] as List?;
        if (imageInfo == null || imageInfo.isEmpty) continue;
        final info = imageInfo.first as Map<String, dynamic>;
        final mime = info['mime'] as String? ?? '';
        final url = info['url'] as String?;
        if (url == null) continue;
        if (mime != 'image/jpeg' && mime != 'image/png') continue;
        final lower = url.toLowerCase();
        if (_excludedFilePatterns.any((p) => lower.contains(p))) continue;
        urls.add(url);
      }
      return urls.take(8).toList();
    } catch (_) {
      return const [];
    }
  }
}

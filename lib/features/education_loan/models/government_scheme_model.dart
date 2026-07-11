/// A government education-financing scheme (interest subsidy, portal, etc).
class GovtSchemeModel {
  final String id;
  final String name;
  final String about;
  final List<String> benefits;
  final String eligibility;
  final String applyUrl;

  const GovtSchemeModel({
    required this.id,
    required this.name,
    required this.about,
    this.benefits = const [],
    required this.eligibility,
    this.applyUrl = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'about': about,
        'benefits': benefits,
        'eligibility': eligibility,
        'applyUrl': applyUrl,
      };

  factory GovtSchemeModel.fromMap(Map<String, dynamic> map) => GovtSchemeModel(
        id: map['id'] as String,
        name: map['name'] as String,
        about: map['about'] as String? ?? '',
        benefits: (map['benefits'] as List?)?.cast<String>() ?? const [],
        eligibility: map['eligibility'] as String? ?? '',
        applyUrl: map['applyUrl'] as String? ?? '',
      );
}

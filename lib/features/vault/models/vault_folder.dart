import 'package:flutter/material.dart';

/// The 7 spec-defined folder groups, plus custom (user-created) folders.
enum VaultFolderKind {
  identity,
  academic,
  entranceExams,
  scholarships,
  placements,
  finance,
  other,
  custom,
}

/// A EduVault folder — one of the 7 curated preset categories (with their
/// suggested document types for upload/OCR matching) or a user-created
/// custom folder.
class VaultFolder {
  const VaultFolder({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.kind,
    this.suggestedTypes = const [],
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final VaultFolderKind kind;

  /// Preset document-type labels shown as quick-pick chips on upload (e.g.
  /// "Aadhaar Card", "PAN Card" for the Identity folder) — also used to seed
  /// OCR document-type matching. Empty for Other/custom folders.
  final List<String> suggestedTypes;

  bool get isCustom => kind == VaultFolderKind.custom;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconKey': VaultFolderIcons.keyOf(icon),
        'colorValue': color.toARGB32(),
      };

  factory VaultFolder.fromMap(Map<String, dynamic> map) {
    return VaultFolder(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: VaultFolderIcons.iconOf(map['iconKey'] as String?),
      color: Color(map['colorValue'] as int? ?? 0xFF64748B),
      kind: VaultFolderKind.custom,
    );
  }
}

/// A small, fixed set of icons a student can pick for a custom folder —
/// stored as a string key (not a raw codepoint) so the icon survives
/// Flutter's icon tree-shaking in release builds.
class VaultFolderIcons {
  VaultFolderIcons._();

  static const Map<String, IconData> options = {
    'folder': Icons.folder_rounded,
    'star': Icons.star_rounded,
    'book': Icons.menu_book_rounded,
    'briefcase': Icons.work_rounded,
    'heart': Icons.favorite_rounded,
    'home': Icons.home_rounded,
    'shield': Icons.shield_rounded,
    'flag': Icons.flag_rounded,
    'gift': Icons.card_giftcard_rounded,
    'plane': Icons.flight_rounded,
    'health': Icons.health_and_safety_rounded,
    'family': Icons.family_restroom_rounded,
  };

  static IconData iconOf(String? key) => options[key] ?? Icons.folder_rounded;

  static String keyOf(IconData icon) {
    for (final entry in options.entries) {
      if (entry.value.codePoint == icon.codePoint) return entry.key;
    }
    return 'folder';
  }
}

/// The 7 curated preset folders from the spec. Custom folders created by the
/// student are stored separately (see `VaultRepository.watchCustomFolders`)
/// and always rendered after these.
class VaultFolders {
  VaultFolders._();

  static const identity = VaultFolder(
    id: 'identity',
    name: 'Identity Documents',
    icon: Icons.badge_rounded,
    color: Color(0xFF3B82F6),
    kind: VaultFolderKind.identity,
    suggestedTypes: [
      'Aadhaar Card',
      'PAN Card',
      'Passport',
      'Driving Licence',
      'Voter ID',
    ],
  );

  static const academic = VaultFolder(
    id: 'academic',
    name: 'Academic',
    icon: Icons.school_rounded,
    color: Color(0xFF22C55E),
    kind: VaultFolderKind.academic,
    suggestedTypes: [
      'Class 10 Marksheet',
      'Class 12 Marksheet',
      'Graduation Marksheet',
      'Degree',
      'Provisional Certificate',
      'Character Certificate',
      'Migration Certificate',
      'Transfer Certificate',
    ],
  );

  static const entranceExams = VaultFolder(
    id: 'entrance_exams',
    name: 'Entrance Exams',
    icon: Icons.edit_document,
    color: Color(0xFF8B5CF6),
    kind: VaultFolderKind.entranceExams,
    suggestedTypes: ['Admit Card', 'Rank Card', 'Score Card'],
  );

  static const scholarships = VaultFolder(
    id: 'scholarships',
    name: 'Scholarships',
    icon: Icons.volunteer_activism_rounded,
    color: Color(0xFFF97316),
    kind: VaultFolderKind.scholarships,
    suggestedTypes: [
      'Income Certificate',
      'Caste Certificate',
      'EWS Certificate',
      'Domicile Certificate',
      'Disability Certificate',
    ],
  );

  static const placements = VaultFolder(
    id: 'placements',
    name: 'Placements',
    icon: Icons.work_rounded,
    color: Color(0xFFEC4899),
    kind: VaultFolderKind.placements,
    suggestedTypes: ['Resume', 'CV', 'Cover Letter'],
  );

  static const finance = VaultFolder(
    id: 'finance',
    name: 'Finance',
    icon: Icons.account_balance_wallet_rounded,
    color: Color(0xFFEAB308),
    kind: VaultFolderKind.finance,
    suggestedTypes: ['Bank Passbook', 'Cancelled Cheque', 'Loan Documents'],
  );

  static const other = VaultFolder(
    id: 'other',
    name: 'Other',
    icon: Icons.folder_rounded,
    color: Color(0xFF64748B),
    kind: VaultFolderKind.other,
  );

  /// The 7 curated presets, in display order.
  static const List<VaultFolder> presets = [
    identity,
    academic,
    entranceExams,
    scholarships,
    placements,
    finance,
    other,
  ];

  static VaultFolder? presetById(String id) {
    for (final f in presets) {
      if (f.id == id) return f;
    }
    return null;
  }

  /// All document-type suggestions across every preset folder — used by OCR
  /// document-type detection to match against a known label.
  static List<String> get allSuggestedTypes =>
      presets.expand((f) => f.suggestedTypes).toList();
}

/// Mirrors the Firestore `/users/{userId}` document (spec §8).
///
/// This is the canonical profile every later module reads from. The AI Digital
/// Twin (§4.9) and assessment results live in sub-documents and are
/// intentionally NOT mixed in here — this document stays focused on
/// user-entered identity data plus a few routing flags.
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String phone;
  final String dob;
  final String gender;
  final String state;
  final String? district;
  final String? city;
  final String schoolOrCollege;
  final String educationLevel;
  final String classOrYear;
  final String branch;
  final List<String> preferredCities;
  final String? budget;
  final String preferredMode; // "online" | "offline" | "hybrid"
  final String careerGoal;

  /// True once the user has finished the self-assessment at least once. Drives
  /// post-login routing (assessment vs. dashboard) so splash and login agree.
  final bool assessmentCompleted;

  /// Top category keys from the last completed assessment (e.g. ['coding', 'creativity']).
  /// Persisted so Career Explorer can rank paths even after the controller is disposed.
  final List<String> assessmentStrengths;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.state,
    this.district,
    this.city,
    required this.schoolOrCollege,
    required this.educationLevel,
    required this.classOrYear,
    required this.branch,
    this.preferredCities = const [],
    this.budget,
    this.preferredMode = 'offline',
    required this.careerGoal,
    this.assessmentCompleted = false,
    this.assessmentStrengths = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// True when the core onboarding fields are present. Used to decide whether a
  /// returning user still needs to finish setup.
  bool get isComplete =>
      name.trim().isNotEmpty &&
      classOrYear.trim().isNotEmpty &&
      educationLevel.trim().isNotEmpty;

  UserProfile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? phone,
    String? dob,
    String? gender,
    String? state,
    String? district,
    String? city,
    String? schoolOrCollege,
    String? educationLevel,
    String? classOrYear,
    String? branch,
    List<String>? preferredCities,
    String? budget,
    String? preferredMode,
    String? careerGoal,
    bool? assessmentCompleted,
    List<String>? assessmentStrengths,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      district: district ?? this.district,
      city: city ?? this.city,
      schoolOrCollege: schoolOrCollege ?? this.schoolOrCollege,
      educationLevel: educationLevel ?? this.educationLevel,
      classOrYear: classOrYear ?? this.classOrYear,
      branch: branch ?? this.branch,
      preferredCities: preferredCities ?? this.preferredCities,
      budget: budget ?? this.budget,
      preferredMode: preferredMode ?? this.preferredMode,
      careerGoal: careerGoal ?? this.careerGoal,
      assessmentCompleted: assessmentCompleted ?? this.assessmentCompleted,
      assessmentStrengths: assessmentStrengths ?? this.assessmentStrengths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'state': state,
      'district': district,
      'city': city,
      'schoolOrCollege': schoolOrCollege,
      'educationLevel': educationLevel,
      'classOrYear': classOrYear,
      'branch': branch,
      'preferredCities': preferredCities,
      'budget': budget,
      'preferredMode': preferredMode,
      'careerGoal': careerGoal,
      'assessmentCompleted': assessmentCompleted,
      'assessmentStrengths': assessmentStrengths,
      // createdAt/updatedAt are set with server timestamps in the repository.
    };
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      phone: map['phone'] as String? ?? '',
      dob: map['dob'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      state: map['state'] as String? ?? '',
      district: map['district'] as String?,
      city: map['city'] as String?,
      schoolOrCollege: map['schoolOrCollege'] as String? ?? '',
      educationLevel: map['educationLevel'] as String? ?? '',
      classOrYear: map['classOrYear'] as String? ?? '',
      branch: map['branch'] as String? ?? '',
      preferredCities:
          (map['preferredCities'] as List?)?.cast<String>() ?? const [],
      budget: map['budget'] as String?,
      preferredMode: map['preferredMode'] as String? ?? 'offline',
      careerGoal: map['careerGoal'] as String? ?? '',
      assessmentCompleted: map['assessmentCompleted'] as bool? ?? false,
      assessmentStrengths:
          (map['assessmentStrengths'] as List?)?.cast<String>() ?? const [],
    );
  }
}

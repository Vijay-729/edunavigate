/// Static option lists used across onboarding and (later) discovery filters.
/// Kept out of widgets so they are reused, not re-declared per screen.
class AppOptions {
  AppOptions._();

  static const List<String> genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  static const List<String> schoolClasses = [
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];

  static const List<String> careerGoals = [
    'Software Engineer',
    'AI / ML Engineer',
    'Data Scientist',
    'Cyber Security Engineer',
    'Web Developer',
    'App Developer',
    'Cloud Engineer',
    'UI/UX Designer',
    'Entrepreneur',
    'Government Jobs',
    'UPSC',
    'Research Scientist',
    'Professor',
    'Doctor',
    'Lawyer',
    'CA',
    'Higher Studies',
    'Undecided',
  ];

  static const List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];
}

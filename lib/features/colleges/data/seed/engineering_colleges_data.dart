import '../../models/college_model.dart';
import '../../models/course_model.dart';

/// Representative seed data for PCM-stream colleges: Engineering, B.Arch,
/// BCA and allied science/design programs. Approximate, illustrative
/// figures (fees/placement/cutoffs) — replace with a live Firestore feed
/// per college once the backend is wired up; the [CollegeRepository]
/// abstraction is what makes that swap a one-file change.
class EngineeringCollegesData {
  EngineeringCollegesData._();

  static const List<CollegeModel> all = [
    CollegeModel(
      id: 'iit_bombay',
      name: 'Indian Institute of Technology Bombay',
      city: 'Mumbai',
      state: 'Maharashtra',
      type: CollegeType.government,
      nirfRank: 3,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1958,
      about:
          'IIT Bombay is one of India\'s premier engineering institutes, known '
          'for its rigorous academics, strong research output, and one of the '
          'most competitive placement seasons in the country.',
      courses: [
        CourseModel(
          id: 'iitb_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
        CourseModel(
          id: 'iitb_mech',
          name: 'B.Tech in Mechanical Engineering',
          shortName: 'Mechanical',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
      ],
      admissionProcess:
          'JEE Main → JEE Advanced → JoSAA counselling based on category rank.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitb_cse',
            category: 'general',
            closingRank: 68),
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitb_mech',
            category: 'general',
            closingRank: 1450),
      ],
      fees: CollegeFees(tuitionPerYear: 231000, hostelPerYear: 65000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Merit-cum-means scholarship; full fee waiver for family income under ₹5L.',
      placement: PlacementStats(
        averagePackageLpa: 25.0,
        highestPackageLpa: 220.0,
        placementPercentage: 95,
        topRecruiters: [
          'Google',
          'Microsoft',
          'Goldman Sachs',
          'Qualcomm',
          'Sprinklr'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym,
      ],
      facultyInfo:
          'Faculty-student ratio ~1:9; majority hold PhDs from top global universities.',
      reviews: [
        CollegeReview(
            author: 'Aarav S.',
            rating: 4.8,
            comment: 'Unmatched peer group and research exposure.'),
      ],
      faqs: [
        FaqEntry(
            question: 'Does IIT Bombay accept CUET?',
            answer: 'No, UG admission is via JEE Advanced only.'),
      ],
      website: 'https://www.iitb.ac.in',
      contactEmail: 'admissions@iitb.ac.in',
      contactPhone: '022-2572-2545',
      latitude: 19.1334,
      longitude: 72.9133,
      tags: [
        'Government',
        'NAAC A++',
        'NBA',
        'Hostel',
        'High Placement',
        'AI Recommended'
      ],
      popularityScore: 99,
    ),
    CollegeModel(
      id: 'iit_delhi',
      name: 'Indian Institute of Technology Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 2,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1961,
      about:
          'IIT Delhi combines strong core-engineering fundamentals with a growing '
          'startup and research ecosystem, and consistently ranks among India\'s top two institutes.',
      courses: [
        CourseModel(
          id: 'iitd_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
        CourseModel(
          id: 'iitd_electrical',
          name: 'B.Tech in Electrical Engineering',
          shortName: 'Electrical',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
      ],
      admissionProcess:
          'JEE Main → JEE Advanced → JoSAA counselling based on category rank.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitd_cse',
            category: 'general',
            closingRank: 118),
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitd_electrical',
            category: 'general',
            closingRank: 1800),
      ],
      fees: CollegeFees(tuitionPerYear: 231000, hostelPerYear: 68000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit-cum-means scholarship for income under ₹5L/year.',
      placement: PlacementStats(
        averagePackageLpa: 24.0,
        highestPackageLpa: 210.0,
        placementPercentage: 94,
        topRecruiters: [
          'Microsoft',
          'Amazon',
          'Uber',
          'Rubrik',
          'Da Vinci Derivatives'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:8.',
      reviews: [
        CollegeReview(
            author: 'Diya M.',
            rating: 4.7,
            comment: 'Excellent research labs and internship pipeline.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is hostel guaranteed?',
            answer: 'Yes, for all four years of the UG programme.')
      ],
      website: 'https://home.iitd.ac.in',
      contactEmail: 'admissions@iitd.ac.in',
      contactPhone: '011-2659-1717',
      latitude: 28.5450,
      longitude: 77.1926,
      tags: [
        'Government',
        'NAAC A++',
        'NBA',
        'Hostel',
        'High Placement',
        'AI Recommended'
      ],
      popularityScore: 98,
    ),
    CollegeModel(
      id: 'iit_madras',
      name: 'Indian Institute of Technology Madras',
      city: 'Chennai',
      state: 'Tamil Nadu',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1959,
      about:
          'IIT Madras has topped India\'s NIRF Overall ranking for multiple consecutive '
          'years, backed by a large research park and strong industry collaboration.',
      courses: [
        CourseModel(
          id: 'iitm_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
        CourseModel(
          id: 'iitm_civil',
          name: 'B.Tech in Civil Engineering',
          shortName: 'Civil',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Advanced qualified, 12th PCM with 75%+',
          examIds: ['jee_advanced'],
        ),
      ],
      admissionProcess:
          'JEE Main → JEE Advanced → JoSAA counselling based on category rank.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitm_cse',
            category: 'general',
            closingRank: 95),
        CutoffEntry(
            examId: 'jee_advanced',
            courseId: 'iitm_civil',
            category: 'general',
            closingRank: 4200),
      ],
      fees: CollegeFees(tuitionPerYear: 225000, hostelPerYear: 60000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Fee concession for family income under ₹5L; freeships available.',
      placement: PlacementStats(
        averagePackageLpa: 23.5,
        highestPackageLpa: 200.0,
        placementPercentage: 93,
        topRecruiters: [
          'Google',
          'Texas Instruments',
          'Zoho',
          'Sprinklr',
          'Bank of America'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym
      ],
      facultyInfo: 'Faculty-student ratio ~1:8, strong research supervision.',
      reviews: [
        CollegeReview(
            author: 'Karthik R.',
            rating: 4.9,
            comment: 'Best research culture among Indian engineering colleges.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does IIT Madras offer online degrees too?',
            answer:
                'Yes, a separate BS in Data Science is offered online, distinct from the on-campus B.Tech.')
      ],
      website: 'https://www.iitm.ac.in',
      contactEmail: 'admissions@iitm.ac.in',
      contactPhone: '044-2257-8890',
      latitude: 12.9915,
      longitude: 80.2336,
      tags: [
        'Government',
        'NAAC A++',
        'NBA',
        'Hostel',
        'High Placement',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 99,
    ),
    CollegeModel(
      id: 'nit_trichy',
      name: 'National Institute of Technology Tiruchirappalli',
      city: 'Tiruchirappalli',
      state: 'Tamil Nadu',
      type: CollegeType.government,
      nirfRank: 9,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1964,
      about:
          'NIT Trichy is consistently the top-ranked NIT in India, offering a strong '
          'core-engineering curriculum with an active on-campus placement drive.',
      courses: [
        CourseModel(
          id: 'nitt_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility:
              'JEE Main qualified, 12th PCM with 75%+ (65% for reserved)',
          examIds: ['jee_main'],
        ),
        CourseModel(
          id: 'nitt_ece',
          name: 'B.Tech in Electronics & Communication Engineering',
          shortName: 'ECE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main qualified, 12th PCM with 75%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'JEE Main → JoSAA/CSAB counselling; 50% seats under home-state quota.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nitt_cse',
            category: 'general',
            closingRank: 2800),
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nitt_cse',
            category: 'general',
            homeStateQuota: true,
            closingRank: 4200),
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nitt_ece',
            category: 'general',
            closingRank: 6500),
      ],
      fees: CollegeFees(tuitionPerYear: 156000, hostelPerYear: 55000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Central-sector scholarship and fee waiver for income under ₹5L.',
      placement: PlacementStats(
        averagePackageLpa: 16.5,
        highestPackageLpa: 92.0,
        placementPercentage: 90,
        topRecruiters: [
          'Microsoft',
          'Amazon',
          'Cisco',
          'Texas Instruments',
          'Goldman Sachs'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:15.',
      reviews: [
        CollegeReview(
            author: 'Priya V.',
            rating: 4.6,
            comment: 'Great campus, strong alumni network.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is home-state quota available?',
            answer:
                'Yes, 50% seats are reserved for Tamil Nadu domicile students.')
      ],
      website: 'https://www.nitt.edu',
      contactEmail: 'admissions@nitt.edu',
      contactPhone: '0431-250-3000',
      latitude: 10.7605,
      longitude: 78.8152,
      tags: [
        'Government',
        'NAAC A++',
        'NBA',
        'Hostel',
        'High Placement',
        'Top Ranked'
      ],
      popularityScore: 92,
    ),
    CollegeModel(
      id: 'nit_surathkal',
      name: 'National Institute of Technology Karnataka, Surathkal',
      city: 'Surathkal',
      state: 'Karnataka',
      type: CollegeType.government,
      nirfRank: 17,
      naacGrade: 'A+',
      nbaAccredited: true,
      establishedYear: 1960,
      about:
          'NITK Surathkal offers a scenic coastal campus with strong programmes '
          'in computer science, electronics, and mechanical engineering.',
      courses: [
        CourseModel(
          id: 'nitk_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main qualified, 12th PCM with 75%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'JEE Main → JoSAA/CSAB counselling; 50% home-state quota.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nitk_cse',
            category: 'general',
            closingRank: 4600),
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nitk_cse',
            category: 'general',
            homeStateQuota: true,
            closingRank: 6800),
      ],
      fees: CollegeFees(tuitionPerYear: 150000, hostelPerYear: 50000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Central-sector scholarship for income under ₹8L.',
      placement: PlacementStats(
        averagePackageLpa: 15.0,
        highestPackageLpa: 80.0,
        placementPercentage: 88,
        topRecruiters: ['Samsung', 'Qualcomm', 'Adobe', 'Deloitte', 'Cisco'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:16.',
      reviews: [
        CollegeReview(
            author: 'Rohan K.',
            rating: 4.5,
            comment: 'Beautiful beachside campus, solid academics.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is the campus residential?',
            answer:
                'Yes, fully residential with separate hostels for all years.')
      ],
      website: 'https://www.nitk.ac.in',
      contactEmail: 'admissions@nitk.edu.in',
      contactPhone: '0824-247-3000',
      latitude: 13.0108,
      longitude: 74.7942,
      tags: ['Government', 'NAAC A+', 'NBA', 'Hostel', 'High Placement'],
      popularityScore: 87,
    ),
    CollegeModel(
      id: 'iiit_hyderabad',
      name: 'International Institute of Information Technology, Hyderabad',
      city: 'Hyderabad',
      state: 'Telangana',
      type: CollegeType.deemed,
      nirfRank: 51,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1998,
      about:
          'IIIT Hyderabad is a research-focused, deemed university specialising '
          'purely in computer science and information technology.',
      courses: [
        CourseModel(
          id: 'iiith_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main rank + UGEE entrance test',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'Own UGEE entrance test or JEE Main rank based shortlisting, followed by interview.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'iiith_cse',
            category: 'general',
            closingRank: 1600),
      ],
      fees: CollegeFees(tuitionPerYear: 396000, hostelPerYear: 90000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Need-based fee waivers up to 100% for income under ₹8L.',
      placement: PlacementStats(
        averagePackageLpa: 28.0,
        highestPackageLpa: 180.0,
        placementPercentage: 96,
        topRecruiters: ['Google', 'Microsoft', 'Adobe', 'Sprinklr', 'Rubrik'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Faculty-student ratio ~1:10, research-heavy culture.',
      reviews: [
        CollegeReview(
            author: 'Sneha P.',
            rating: 4.7,
            comment: 'Pure-CS focus with excellent research opportunities.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does IIIT-H accept CUET?',
            answer:
                'No, admission is via UGEE or JEE Main rank plus institute-specific process.')
      ],
      website: 'https://www.iiit.ac.in',
      contactEmail: 'admissions@iiit.ac.in',
      contactPhone: '040-6653-1000',
      latitude: 17.4457,
      longitude: 78.3489,
      tags: ['Private', 'NAAC A', 'Hostel', 'High Placement', 'AI Recommended'],
      popularityScore: 90,
    ),
    CollegeModel(
      id: 'dtu_delhi',
      name: 'Delhi Technological University',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 29,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1941,
      about: 'DTU is Delhi\'s oldest and most prominent state technological '
          'university, popular for its strong placement record and central location.',
      courses: [
        CourseModel(
          id: 'dtu_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main qualified, 12th PCM with 75%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess: 'JEE Main rank via JAC Delhi counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'dtu_cse',
            category: 'general',
            closingRank: 3200),
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'dtu_cse',
            category: 'general',
            homeStateQuota: true,
            closingRank: 5100),
      ],
      fees: CollegeFees(tuitionPerYear: 180000, hostelPerYear: 45000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Delhi government merit scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 13.0,
        highestPackageLpa: 70.0,
        placementPercentage: 85,
        topRecruiters: [
          'Microsoft',
          'Adobe',
          'Samsung',
          'American Express',
          'Deloitte'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:18.',
      reviews: [
        CollegeReview(
            author: 'Ishaan G.',
            rating: 4.3,
            comment:
                'Great placements for a state university, central Delhi location.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is DTU only for Delhi students?',
            answer: 'No, 15% seats are open to all-India candidates.')
      ],
      website: 'https://www.dtu.ac.in',
      contactEmail: 'admissions@dtu.ac.in',
      contactPhone: '011-2787-1018',
      latitude: 28.7500,
      longitude: 77.1180,
      tags: ['Government', 'NAAC A++', 'NBA', 'Hostel', 'High Placement'],
      popularityScore: 84,
    ),
    CollegeModel(
      id: 'bits_pilani',
      name: 'Birla Institute of Technology and Science, Pilani',
      city: 'Pilani',
      state: 'Rajasthan',
      type: CollegeType.private,
      nirfRank: 25,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1964,
      about: 'BITS Pilani is a leading private deemed university known for its '
          'flexible curriculum, no-reservation merit admission, and strong industry brand.',
      courses: [
        CourseModel(
          id: 'bits_cse',
          name: 'B.E. in Computer Science',
          shortName: 'CSE',
          degree: 'B.E.',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'BITSAT score, 12th PCM with 75%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'BITSAT entrance exam (own test), merit-based, no reservation.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'bits_cse',
            category: 'general',
            closingScore: 327),
      ],
      fees: CollegeFees(tuitionPerYear: 500000, hostelPerYear: 120000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Merit scholarships covering 25–100% of tuition for top BITSAT scorers.',
      placement: PlacementStats(
        averagePackageLpa: 19.0,
        highestPackageLpa: 110.0,
        placementPercentage: 92,
        topRecruiters: [
          'Microsoft',
          'Goldman Sachs',
          'Texas Instruments',
          'ZS Associates',
          'Deutsche Bank'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym
      ],
      facultyInfo: 'Faculty-student ratio ~1:14; flexible dual-degree options.',
      reviews: [
        CollegeReview(
            author: 'Manav T.',
            rating: 4.5,
            comment: 'Best private option if you miss IIT/NIT cutoffs.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does BITS accept JEE Main?',
            answer: 'No, admission is purely via the BITSAT entrance test.')
      ],
      website: 'https://www.bits-pilani.ac.in',
      contactEmail: 'admissions@pilani.bits-pilani.ac.in',
      contactPhone: '01596-242-210',
      latitude: 28.3670,
      longitude: 75.5880,
      tags: ['Private', 'NAAC A', 'Hostel', 'High Placement', 'AI Recommended'],
      popularityScore: 89,
    ),
    CollegeModel(
      id: 'vit_vellore',
      name: 'Vellore Institute of Technology',
      city: 'Vellore',
      state: 'Tamil Nadu',
      type: CollegeType.private,
      nirfRank: 11,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1984,
      about:
          'VIT Vellore is one of India\'s largest private universities, popular '
          'for its wide course choice, industry tie-ups, and large placement drive.',
      courses: [
        CourseModel(
          id: 'vit_cse',
          name: 'B.Tech in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'VITEEE score, 12th PCM with 60%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'VITEEE entrance exam (own test), merit-based counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'vit_cse',
            category: 'general',
            closingRank: 6500),
      ],
      fees: CollegeFees(tuitionPerYear: 245000, hostelPerYear: 130000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'VITEEE rank-based tuition fee waivers up to 100%.',
      placement: PlacementStats(
        averagePackageLpa: 8.5,
        highestPackageLpa: 45.0,
        placementPercentage: 87,
        topRecruiters: ['TCS', 'Infosys', 'Amazon', 'Cognizant', 'Zoho'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Faculty-student ratio ~1:20.',
      reviews: [
        CollegeReview(
            author: 'Ananya D.',
            rating: 4.2,
            comment: 'Huge campus with great clubs and internship cell.')
      ],
      faqs: [
        FaqEntry(
            question: 'Can I get admission with only JEE Main?',
            answer:
                'VIT primarily uses its own VITEEE score, though some quota seats consider board merit.')
      ],
      website: 'https://vit.ac.in',
      contactEmail: 'admission@vit.ac.in',
      contactPhone: '0416-220-2020',
      latitude: 12.9692,
      longitude: 79.1559,
      tags: ['Private', 'NAAC A++', 'NBA', 'Hostel', 'Low Fees'],
      popularityScore: 88,
    ),
    CollegeModel(
      id: 'srm_chennai',
      name: 'SRM Institute of Science and Technology',
      city: 'Chennai',
      state: 'Tamil Nadu',
      type: CollegeType.private,
      nirfRank: 27,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1985,
      about: 'SRM is a large private deemed university with a strong emphasis '
          'on industry-aligned specialisations like AI, data science, and cybersecurity.',
      courses: [
        CourseModel(
          id: 'srm_cse_ai',
          name: 'B.Tech in CSE (AI & Machine Learning)',
          shortName: 'CSE - AI/ML',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'SRMJEEE score, 12th PCM with 60%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'SRMJEEE entrance exam (own test), merit-based counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'srm_cse_ai',
            category: 'general',
            closingRank: 8200),
      ],
      fees: CollegeFees(tuitionPerYear: 285000, hostelPerYear: 140000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'SRMJEEE rank-based scholarships up to 100% tuition waiver.',
      placement: PlacementStats(
        averagePackageLpa: 7.8,
        highestPackageLpa: 40.0,
        placementPercentage: 83,
        topRecruiters: ['TCS', 'Cognizant', 'Amazon', 'Accenture', 'Wipro'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym
      ],
      facultyInfo: 'Faculty-student ratio ~1:20.',
      reviews: [
        CollegeReview(
            author: 'Vivek N.',
            rating: 4.0,
            comment: 'Great specialisations but large batch sizes.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is hostel compulsory?',
            answer: 'No, day-scholar options are available for local students.')
      ],
      website: 'https://www.srmist.edu.in',
      contactEmail: 'admissions@srmist.edu.in',
      contactPhone: '044-2745-5510',
      latitude: 12.8230,
      longitude: 80.0444,
      tags: ['Private', 'NAAC A++', 'NBA', 'Hostel', 'Low Fees'],
      popularityScore: 80,
    ),
    CollegeModel(
      id: 'manipal_mit',
      name: 'Manipal Institute of Technology',
      city: 'Manipal',
      state: 'Karnataka',
      type: CollegeType.private,
      nirfRank: 38,
      naacGrade: 'A++',
      nbaAccredited: true,
      establishedYear: 1957,
      about: 'MIT Manipal, part of MAHE, offers a vibrant residential campus '
          'experience with strong international exchange programmes.',
      courses: [
        CourseModel(
          id: 'manipal_cse',
          name: 'B.Tech in Computer & Communication Engineering',
          shortName: 'CCE',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'MET score, 12th PCM with 50%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess: 'Manipal Entrance Test (MET), merit-based counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'manipal_cse',
            category: 'general',
            closingRank: 9500),
      ],
      fees: CollegeFees(tuitionPerYear: 480000, hostelPerYear: 150000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Dean\'s merit scholarship for top MET rankers.',
      placement: PlacementStats(
        averagePackageLpa: 9.2,
        highestPackageLpa: 50.0,
        placementPercentage: 85,
        topRecruiters: [
          'Microsoft',
          'Oracle',
          'Deloitte',
          'Cognizant',
          'Cisco'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Faculty-student ratio ~1:18.',
      reviews: [
        CollegeReview(
            author: 'Tanvi J.',
            rating: 4.4,
            comment: 'Vibrant campus life with global exposure.')
      ],
      faqs: [
        FaqEntry(
            question: 'Are international exchange programmes available?',
            answer: 'Yes, MAHE has tie-ups with several universities abroad.')
      ],
      website: 'https://manipal.edu',
      contactEmail: 'admissions@manipal.edu',
      contactPhone: '0820-292-2000',
      latitude: 13.3467,
      longitude: 74.7869,
      tags: ['Private', 'NAAC A++', 'NBA', 'Hostel'],
      popularityScore: 78,
    ),
    CollegeModel(
      id: 'spa_delhi',
      name: 'School of Planning and Architecture, Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 2,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1955,
      about: 'SPA Delhi is India\'s top-ranked institute for architecture and '
          'planning, offering an intensive design-studio based curriculum.',
      courses: [
        CourseModel(
          id: 'spa_barch',
          name: 'Bachelor of Architecture',
          shortName: 'B.Arch',
          degree: 'B.Arch',
          category: CourseCategory.architecture,
          durationYears: 5,
          eligibility: 'NATA/JEE Main Paper 2, 12th PCM with 50%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'JEE Main Paper 2 (B.Arch) rank, followed by JoSAA counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'spa_barch',
            category: 'general',
            closingRank: 450),
      ],
      fees: CollegeFees(tuitionPerYear: 45000, hostelPerYear: 30000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Central-sector scholarship for income under ₹8L.',
      placement: PlacementStats(
        averagePackageLpa: 8.0,
        highestPackageLpa: 22.0,
        placementPercentage: 75,
        topRecruiters: [
          'HCP Design',
          'CP Kukreja Architects',
          'Larsen & Toubro',
          'Edifice Consultants'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:10, studio-based mentorship.',
      reviews: [
        CollegeReview(
            author: 'Naina B.',
            rating: 4.6,
            comment: 'The best architecture pedigree in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is NATA required?',
            answer:
                'JEE Main Paper 2 score is used for admission; NATA is an alternate route at some other B.Arch colleges.')
      ],
      website: 'https://www.spa.ac.in',
      contactEmail: 'admissions@spa.ac.in',
      contactPhone: '011-2673-0490',
      latitude: 28.5921,
      longitude: 77.1867,
      tags: ['Government', 'NAAC A', 'Hostel', 'Low Fees', 'Top Ranked'],
      popularityScore: 76,
    ),
    CollegeModel(
      id: 'cept_ahmedabad',
      name: 'CEPT University',
      city: 'Ahmedabad',
      state: 'Gujarat',
      type: CollegeType.private,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1962,
      about:
          'CEPT University specialises in architecture, planning, design, and '
          'the built environment, with a strong studio culture and faculty practice.',
      courses: [
        CourseModel(
          id: 'cept_barch',
          name: 'Bachelor of Architecture',
          shortName: 'B.Arch',
          degree: 'B.Arch',
          category: CourseCategory.architecture,
          durationYears: 5,
          eligibility: 'CEPT entrance test, 12th PCM with 50%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess:
          'CEPT\'s own entrance test (CEED-style aptitude test) plus portfolio review.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'cept_barch',
            category: 'general',
            closingRank: 5000),
      ],
      fees: CollegeFees(tuitionPerYear: 320000, hostelPerYear: 95000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Need-based fee assistance for select students.',
      placement: PlacementStats(
        averagePackageLpa: 7.0,
        highestPackageLpa: 18.0,
        placementPercentage: 70,
        topRecruiters: ['Studio Lotus', 'HCP Design', 'Sanjay Puri Architects'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Faculty are practicing architects and planners.',
      reviews: [
        CollegeReview(
            author: 'Yash P.',
            rating: 4.5,
            comment: 'Design-forward, faculty are working professionals.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is a portfolio required?',
            answer:
                'Yes, along with the entrance test for shortlisted candidates.')
      ],
      website: 'https://cept.ac.in',
      contactEmail: 'admissions@cept.ac.in',
      contactPhone: '079-2630-2470',
      latitude: 23.0338,
      longitude: 72.5304,
      tags: ['Private', 'NAAC A', 'Hostel'],
      popularityScore: 70,
    ),
    CollegeModel(
      id: 'nsut_delhi',
      name: 'Netaji Subhas University of Technology',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 45,
      naacGrade: 'A+',
      nbaAccredited: true,
      establishedYear: 1983,
      about:
          'NSUT (formerly NSIT) is a well-regarded Delhi state university known '
          'for its compact campus and strong core-branch placements.',
      courses: [
        CourseModel(
          id: 'nsut_it',
          name: 'B.Tech in Information Technology',
          shortName: 'IT',
          degree: 'B.Tech',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main qualified, 12th PCM with 75%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess: 'JEE Main rank via JAC Delhi counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nsut_it',
            category: 'general',
            closingRank: 5200),
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'nsut_it',
            category: 'general',
            homeStateQuota: true,
            closingRank: 8000),
      ],
      fees: CollegeFees(tuitionPerYear: 175000, hostelPerYear: 42000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Delhi government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 11.5,
        highestPackageLpa: 60.0,
        placementPercentage: 84,
        topRecruiters: ['Adobe', 'Samsung', 'American Express', 'Cognizant'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty-student ratio ~1:18.',
      reviews: [
        CollegeReview(
            author: 'Kabir S.',
            rating: 4.2,
            comment: 'Good option within the Delhi quota.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is NSUT the same as NSIT?',
            answer:
                'Yes, NSIT was granted university status and renamed NSUT in 2018.')
      ],
      website: 'https://nsut.ac.in',
      contactEmail: 'admissions@nsut.ac.in',
      contactPhone: '011-2545-1050',
      latitude: 28.6096,
      longitude: 77.0365,
      tags: ['Government', 'NAAC A+', 'NBA', 'Hostel'],
      popularityScore: 79,
    ),
    CollegeModel(
      id: 'thapar_patiala',
      name: 'Thapar Institute of Engineering and Technology',
      city: 'Patiala',
      state: 'Punjab',
      type: CollegeType.deemed,
      nirfRank: 33,
      naacGrade: 'A+',
      nbaAccredited: true,
      establishedYear: 1956,
      about:
          'Thapar Institute is a well-regarded deemed university in North India '
          'with strong core-engineering and computer science departments.',
      courses: [
        CourseModel(
          id: 'thapar_cse',
          name: 'B.E. in Computer Science & Engineering',
          shortName: 'CSE',
          degree: 'B.E.',
          category: CourseCategory.engineering,
          durationYears: 4,
          eligibility: 'JEE Main score, 12th PCM with 60%+',
          examIds: ['jee_main'],
        ),
      ],
      admissionProcess: 'JEE Main score based direct admission/counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'thapar_cse',
            category: 'general',
            closingRank: 12000),
      ],
      fees: CollegeFees(tuitionPerYear: 310000, hostelPerYear: 110000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit scholarships based on JEE Main percentile.',
      placement: PlacementStats(
        averagePackageLpa: 10.0,
        highestPackageLpa: 55.0,
        placementPercentage: 88,
        topRecruiters: ['Microsoft', 'Amazon', 'Adobe', 'Samsung R&D'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.sports,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.gym
      ],
      facultyInfo: 'Faculty-student ratio ~1:16.',
      reviews: [
        CollegeReview(
            author: 'Simran K.',
            rating: 4.3,
            comment: 'Solid placements, calm green campus.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does it accept JEE Advanced?',
            answer:
                'Admission is based on JEE Main percentile, not JEE Advanced.')
      ],
      website: 'https://www.thapar.edu',
      contactEmail: 'admissions@thapar.edu',
      contactPhone: '0175-239-3021',
      latitude: 30.3550,
      longitude: 76.3660,
      tags: ['Private', 'NAAC A+', 'NBA', 'Hostel'],
      popularityScore: 77,
    ),
  ];
}

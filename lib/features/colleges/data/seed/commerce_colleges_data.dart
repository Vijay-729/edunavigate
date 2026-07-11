import '../../models/college_model.dart';
import '../../models/course_model.dart';

/// Representative seed data for Commerce-stream colleges: B.Com, BBA,
/// Economics, and integrated management programmes. Approximate,
/// illustrative figures — see [EngineeringCollegesData] header note.
class CommerceCollegesData {
  CommerceCollegesData._();

  static const List<CollegeModel> all = [
    CollegeModel(
      id: 'srcc_delhi',
      name: 'Shri Ram College of Commerce',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1926,
      about:
          'SRCC is India\'s most prestigious commerce college, a constituent '
          'college of University of Delhi with an outstanding placement and alumni record.',
      courses: [
        CourseModel(
          id: 'srcc_bcom_hons',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'CUET score, 12th Commerce with 75%+',
          examIds: ['cuet'],
        ),
        CourseModel(
          id: 'srcc_economics',
          name: 'B.A. (Honours) Economics',
          shortName: 'Economics Hons',
          degree: 'BA',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'CUET score, 12th with 75%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score → Delhi University CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'srcc_bcom_hons',
            category: 'general',
            closingScore: 780),
      ],
      fees: CollegeFees(tuitionPerYear: 22000, hostelPerYear: 0),
      scholarshipsAvailable: true,
      scholarshipInfo: 'DU merit scholarships and need-based fee concessions.',
      placement: PlacementStats(
        averagePackageLpa: 11.0,
        highestPackageLpa: 60.0,
        placementPercentage: 90,
        topRecruiters: ['Goldman Sachs', 'Deloitte', 'EY', 'ITC', 'HUL'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Senior DU faculty with strong industry & academic ties.',
      reviews: [
        CollegeReview(
            author: 'Arjun P.',
            rating: 4.8,
            comment: 'The best commerce brand name in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does SRCC have hostel facilities?',
            answer:
                'No, SRCC does not have an on-campus hostel; most students find PG accommodation nearby.')
      ],
      website: 'https://www.srcc.edu',
      contactEmail: 'admissions@srcc.du.ac.in',
      contactPhone: '011-2766-7853',
      latitude: 28.6879,
      longitude: 77.2106,
      tags: [
        'Government',
        'NAAC A++',
        'High Placement',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 96,
    ),
    CollegeModel(
      id: 'lsr_delhi',
      name: 'Lady Shri Ram College for Women',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 3,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1956,
      about:
          'LSR is one of DU\'s most sought-after women\'s colleges, renowned '
          'for its Economics and Commerce programmes plus a vibrant campus culture.',
      courses: [
        CourseModel(
          id: 'lsr_bcom_hons',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'CUET score, 12th Commerce with 75%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score → Delhi University CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'lsr_bcom_hons',
            category: 'general',
            closingScore: 760),
      ],
      fees: CollegeFees(tuitionPerYear: 20000, hostelPerYear: 65000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'DU merit scholarships and need-based fee concessions.',
      placement: PlacementStats(
        averagePackageLpa: 9.5,
        highestPackageLpa: 42.0,
        placementPercentage: 87,
        topRecruiters: ['Deloitte', 'KPMG', 'ICICI Bank', 'HDFC Bank'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo:
          'Strong faculty in Economics, Commerce and Political Science.',
      reviews: [
        CollegeReview(
            author: 'Kavya R.',
            rating: 4.7,
            comment: 'Amazing societies and a very supportive faculty.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is LSR only for women?',
            answer:
                'Yes, LSR is a women\'s constituent college of Delhi University.')
      ],
      website: 'https://lsr.edu.in',
      contactEmail: 'admissions@lsr.edu.in',
      contactPhone: '011-2435-4085',
      latitude: 28.5605,
      longitude: 77.2432,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked'
      ],
      popularityScore: 88,
    ),
    CollegeModel(
      id: 'ssbcs_delhi',
      name: 'Shaheed Sukhdev College of Business Studies',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 15,
      naacGrade: 'A+',
      nbaAccredited: false,
      establishedYear: 1987,
      about:
          'SSCBS is a specialised business-studies college of Delhi University, '
          'known for its BMS programme and strong corporate placement cell.',
      courses: [
        CourseModel(
          id: 'sscbs_bms',
          name: 'Bachelor of Management Studies',
          shortName: 'BMS',
          degree: 'BMS',
          category: CourseCategory.management,
          durationYears: 3,
          eligibility: 'CUET score, 12th with 75%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score → Delhi University CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'sscbs_bms',
            category: 'general',
            closingScore: 740),
      ],
      fees: CollegeFees(tuitionPerYear: 35000, hostelPerYear: 0),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit-based fee waivers for top CUET scorers.',
      placement: PlacementStats(
        averagePackageLpa: 10.0,
        highestPackageLpa: 32.0,
        placementPercentage: 92,
        topRecruiters: ['EY', 'Deloitte', 'American Express', 'ITC'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Small batch sizes with strong industry mentorship.',
      reviews: [
        CollegeReview(
            author: 'Nikhil S.',
            rating: 4.6,
            comment: 'Best BMS programme with excellent placement stats.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is there a hostel?',
            answer: 'No, SSCBS does not offer on-campus hostel accommodation.')
      ],
      website: 'https://sscbsdu.ac.in',
      contactEmail: 'admissions@sscbsdu.ac.in',
      contactPhone: '011-2725-4832',
      latitude: 28.6890,
      longitude: 77.1650,
      tags: ['Government', 'NAAC A+', 'High Placement'],
      popularityScore: 80,
    ),
    CollegeModel(
      id: 'christ_bangalore',
      name: 'Christ University',
      city: 'Bengaluru',
      state: 'Karnataka',
      type: CollegeType.deemed,
      nirfRank: 34,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1969,
      about:
          'Christ University is a large, popular deemed university known for '
          'its disciplined campus culture and broad commerce/management portfolio.',
      courses: [
        CourseModel(
          id: 'christ_bcom',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility:
              'Christ University entrance test + interview, 12th Commerce with 60%+',
          examIds: ['cuet'],
        ),
        CourseModel(
          id: 'christ_bba',
          name: 'Bachelor of Business Administration',
          shortName: 'BBA',
          degree: 'BBA',
          category: CourseCategory.management,
          durationYears: 3,
          eligibility:
              'Christ University entrance test + interview, 12th with 60%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'Own entrance test + personal interview, merit-based.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'christ_bcom',
            category: 'general',
            closingScore: 620),
      ],
      fees: CollegeFees(tuitionPerYear: 210000, hostelPerYear: 130000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit scholarships for top entrance-test scorers.',
      placement: PlacementStats(
        averagePackageLpa: 6.5,
        highestPackageLpa: 24.0,
        placementPercentage: 85,
        topRecruiters: ['Deloitte', 'Accenture', 'ICICI Bank', 'EY'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.gym,
        CollegeFacility.cafeteria
      ],
      facultyInfo:
          'Structured, discipline-focused pedagogy across departments.',
      reviews: [
        CollegeReview(
            author: 'Sanya M.',
            rating: 4.3,
            comment: 'Very disciplined campus with good industry tie-ups.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does Christ accept CUET scores?',
            answer:
                'Christ conducts its own entrance test; CUET scores are not the primary admission route.')
      ],
      website: 'https://christuniversity.in',
      contactEmail: 'admissions@christuniversity.in',
      contactPhone: '080-4012-9100',
      latitude: 12.9345,
      longitude: 77.6068,
      tags: ['Private', 'NAAC A++', 'Hostel', 'High Placement'],
      popularityScore: 84,
    ),
    CollegeModel(
      id: 'nmims_mumbai',
      name: 'NMIMS Anil Surendra Modi School of Commerce',
      city: 'Mumbai',
      state: 'Maharashtra',
      type: CollegeType.deemed,
      nirfRank: 41,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 2015,
      about: 'NMIMS ASMSOC is a leading private commerce school in Mumbai with '
          'strong finance/analytics electives and a modern campus.',
      courses: [
        CourseModel(
          id: 'nmims_bcom_hons',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'NPAT score, 12th Commerce with 70%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'NPAT (NMIMS Programs After Twelfth) entrance test.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'nmims_bcom_hons',
            category: 'general',
            closingScore: 210),
      ],
      fees: CollegeFees(tuitionPerYear: 285000, hostelPerYear: 140000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'NPAT rank-based merit scholarships.',
      placement: PlacementStats(
        averagePackageLpa: 7.5,
        highestPackageLpa: 22.0,
        placementPercentage: 88,
        topRecruiters: ['EY', 'KPMG', 'JP Morgan', 'Kotak Mahindra'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.cafeteria
      ],
      facultyInfo:
          'Industry-linked faculty with strong finance specialisation.',
      reviews: [
        CollegeReview(
            author: 'Rhea D.',
            rating: 4.4,
            comment: 'Great finance electives and internship support.')
      ],
      faqs: [
        FaqEntry(
            question: 'What entrance test does NMIMS use?',
            answer: 'NPAT — NMIMS Programs After Twelfth.')
      ],
      website: 'https://www.nmims.edu',
      contactEmail: 'admissions@nmims.edu',
      contactPhone: '022-4235-5555',
      latitude: 19.1075,
      longitude: 72.8263,
      tags: ['Private', 'NAAC A++', 'Hostel', 'High Placement'],
      popularityScore: 79,
    ),
    CollegeModel(
      id: 'symbiosis_pune',
      name: 'Symbiosis College of Arts and Commerce',
      city: 'Pune',
      state: 'Maharashtra',
      type: CollegeType.autonomous,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1980,
      about:
          'SCAC Pune, part of Symbiosis International, offers a well-rounded '
          'commerce and BBA curriculum in one of India\'s most popular student cities.',
      courses: [
        CourseModel(
          id: 'scac_bba',
          name: 'Bachelor of Business Administration',
          shortName: 'BBA',
          degree: 'BBA',
          category: CourseCategory.management,
          durationYears: 3,
          eligibility: 'SET entrance test, 12th with 55%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'Symbiosis Entrance Test (SET) + merit list.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'scac_bba',
            category: 'general',
            closingScore: 55),
      ],
      fees: CollegeFees(tuitionPerYear: 195000, hostelPerYear: 120000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit-based fee concessions for top SET scorers.',
      placement: PlacementStats(
        averagePackageLpa: 5.8,
        highestPackageLpa: 14.0,
        placementPercentage: 80,
        topRecruiters: ['Cognizant', 'ICICI Bank', 'Axis Bank', 'Deloitte'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Well-rounded faculty with strong co-curricular focus.',
      reviews: [
        CollegeReview(
            author: 'Aisha F.',
            rating: 4.2,
            comment: 'Fun campus life alongside a solid BBA curriculum.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is SET the only entry route?',
            answer:
                'Yes, admission is via the Symbiosis Entrance Test followed by a merit-based process.')
      ],
      website: 'https://www.symbiosiscollege.edu.in',
      contactEmail: 'admissions@symbiosiscollege.edu.in',
      contactPhone: '020-2565-1400',
      latitude: 18.5236,
      longitude: 73.8478,
      tags: ['Private', 'NAAC A', 'Hostel'],
      popularityScore: 75,
    ),
    CollegeModel(
      id: 'hansraj_delhi',
      name: 'Hansraj College',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 8,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1948,
      about:
          'Hansraj College is a well-known Delhi University constituent college '
          'offering strong Commerce, Economics and Science programmes.',
      courses: [
        CourseModel(
          id: 'hansraj_bcom',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'CUET score, 12th Commerce with 70%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score → Delhi University CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'hansraj_bcom',
            category: 'general',
            closingScore: 700),
      ],
      fees: CollegeFees(tuitionPerYear: 18000, hostelPerYear: 55000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'DU merit scholarships and need-based fee concessions.',
      placement: PlacementStats(
        averagePackageLpa: 7.0,
        highestPackageLpa: 20.0,
        placementPercentage: 82,
        topRecruiters: ['Deloitte', 'KPMG', 'HDFC Bank', 'ITC'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Long-established Commerce and Economics departments.',
      reviews: [
        CollegeReview(
            author: 'Yuvraj B.',
            rating: 4.5,
            comment: 'Excellent college for both academics and sports.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does Hansraj offer a hostel?',
            answer:
                'Yes, limited hostel seats are available for outstation students.')
      ],
      website: 'https://www.hansrajcollege.ac.in',
      contactEmail: 'admissions@hansrajcollege.ac.in',
      contactPhone: '011-2766-7061',
      latitude: 28.6889,
      longitude: 77.2076,
      tags: ['Government', 'NAAC A++', 'Hostel'],
      popularityScore: 81,
    ),
    CollegeModel(
      id: 'loyola_chennai',
      name: 'Loyola College, Chennai',
      city: 'Chennai',
      state: 'Tamil Nadu',
      type: CollegeType.autonomous,
      nirfRank: 11,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1925,
      about: 'Loyola College is an autonomous Jesuit institution renowned for '
          'its Commerce and Economics departments and vibrant campus culture.',
      courses: [
        CourseModel(
          id: 'loyola_bcom',
          name: 'B.Com (Honours)',
          shortName: 'B.Com Hons',
          degree: 'B.Com',
          category: CourseCategory.commerce,
          durationYears: 3,
          eligibility: 'CUET/board merit, 12th Commerce with 70%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess:
          'Board merit + CUET (for certain seats) → institution counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'loyola_bcom',
            category: 'general',
            closingScore: 650),
      ],
      fees: CollegeFees(tuitionPerYear: 45000, hostelPerYear: 60000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Need-based fee assistance for economically weaker students.',
      placement: PlacementStats(
        averagePackageLpa: 6.2,
        highestPackageLpa: 18.0,
        placementPercentage: 85,
        topRecruiters: ['TCS', 'Deloitte', 'HDFC Bank', 'Cognizant'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo:
          'Strong mentorship culture rooted in Jesuit educational values.',
      reviews: [
        CollegeReview(
            author: 'Joel A.',
            rating: 4.6,
            comment: 'Fantastic commerce faculty and campus community.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is Loyola affiliated to a university?',
            answer:
                'It is autonomous, affiliated to the University of Madras for degree conferral.')
      ],
      website: 'https://www.loyolacollege.edu',
      contactEmail: 'admissions@loyolacollege.edu',
      contactPhone: '044-2817-8200',
      latitude: 13.0524,
      longitude: 80.2350,
      tags: ['Private', 'NAAC A++', 'Hostel'],
      popularityScore: 76,
    ),
  ];
}

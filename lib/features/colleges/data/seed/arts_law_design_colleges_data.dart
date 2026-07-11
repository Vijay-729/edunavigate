import '../../models/college_model.dart';
import '../../models/course_model.dart';

/// Representative seed data for Humanities-stream colleges: BA, Law,
/// Design, Journalism, Psychology, Political Science, History and Social
/// Sciences. Approximate, illustrative figures — see
/// [EngineeringCollegesData] header note.
class ArtsLawDesignCollegesData {
  ArtsLawDesignCollegesData._();

  static const List<CollegeModel> all = [
    CollegeModel(
      id: 'nlsiu_bangalore',
      name: 'National Law School of India University',
      city: 'Bengaluru',
      state: 'Karnataka',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1987,
      about: 'NLSIU Bangalore is India\'s first and most prestigious National '
          'Law University, consistently ranked #1 for law nationwide.',
      courses: [
        CourseModel(
          id: 'nls_ballb',
          name: 'B.A. LL.B. (Honours)',
          shortName: 'BA LLB',
          degree: 'BA LLB',
          category: CourseCategory.law,
          durationYears: 5,
          eligibility: 'CLAT rank, 12th with 45%+',
          examIds: ['clat'],
        ),
      ],
      admissionProcess:
          'CLAT rank → NLU counselling (NLSIU uses its own CLAT-based merit list).',
      cutoffs: [
        CutoffEntry(
            examId: 'clat',
            courseId: 'nls_ballb',
            category: 'general',
            closingRank: 45),
      ],
      fees: CollegeFees(tuitionPerYear: 280000, hostelPerYear: 90000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Need-based scholarships and fee waivers for economically weaker students.',
      placement: PlacementStats(
        averagePackageLpa: 18.0,
        highestPackageLpa: 40.0,
        placementPercentage: 96,
        topRecruiters: [
          'AZB & Partners',
          'Cyril Amarchand Mangaldas',
          'Trilegal',
          'Supreme Court chambers'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Distinguished legal academics and visiting practitioners.',
      reviews: [
        CollegeReview(
            author: 'Advika R.',
            rating: 4.9,
            comment: 'The Harvard of Indian law schools.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is CLAT the only entry route?',
            answer: 'Yes, admission is entirely through the CLAT merit rank.')
      ],
      website: 'https://www.nls.ac.in',
      contactEmail: 'admissions@nls.ac.in',
      contactPhone: '080-2316-0532',
      latitude: 12.9037,
      longitude: 77.5820,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 95,
    ),
    CollegeModel(
      id: 'nalsar_hyderabad',
      name: 'NALSAR University of Law',
      city: 'Hyderabad',
      state: 'Telangana',
      type: CollegeType.government,
      nirfRank: 3,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1998,
      about:
          'NALSAR Hyderabad is a top-tier National Law University with strong '
          'placement records in litigation, corporate law, and policy research.',
      courses: [
        CourseModel(
          id: 'nalsar_ballb',
          name: 'B.A. LL.B. (Honours)',
          shortName: 'BA LLB',
          degree: 'BA LLB',
          category: CourseCategory.law,
          durationYears: 5,
          eligibility: 'CLAT rank, 12th with 45%+',
          examIds: ['clat'],
        ),
      ],
      admissionProcess: 'CLAT rank → NLU counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'clat',
            courseId: 'nalsar_ballb',
            category: 'general',
            closingRank: 130),
      ],
      fees: CollegeFees(tuitionPerYear: 250000, hostelPerYear: 85000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit and need-based scholarships available.',
      placement: PlacementStats(
        averagePackageLpa: 16.0,
        highestPackageLpa: 32.0,
        placementPercentage: 94,
        topRecruiters: [
          'Cyril Amarchand Mangaldas',
          'Khaitan & Co',
          'JSA',
          'Luthra & Luthra'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Strong constitutional law and IP law faculty.',
      reviews: [
        CollegeReview(
            author: 'Rehan Q.',
            rating: 4.8,
            comment: 'Excellent mooting culture and faculty support.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is hostel compulsory?',
            answer:
                'Hostel is available and recommended, though not compulsory for local students.')
      ],
      website: 'https://www.nalsar.ac.in',
      contactEmail: 'admissions@nalsar.ac.in',
      contactPhone: '040-2349-8104',
      latitude: 17.3427,
      longitude: 78.5497,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked'
      ],
      popularityScore: 90,
    ),
    CollegeModel(
      id: 'symbiosis_law_pune',
      name: 'Symbiosis Law School, Pune',
      city: 'Pune',
      state: 'Maharashtra',
      type: CollegeType.autonomous,
      nirfRank: 9,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1977,
      about: 'Symbiosis Law School Pune is one of India\'s leading private law '
          'schools with strong corporate law and moot court traditions.',
      courses: [
        CourseModel(
          id: 'slsp_ballb',
          name: 'B.A. LL.B.',
          shortName: 'BA LLB',
          degree: 'BA LLB',
          category: CourseCategory.law,
          durationYears: 5,
          eligibility: 'SLAT entrance test, 12th with 45%+',
          examIds: ['clat'],
        ),
      ],
      admissionProcess: 'Symbiosis Law Admission Test (SLAT) + merit list.',
      cutoffs: [
        CutoffEntry(
            examId: 'clat',
            courseId: 'slsp_ballb',
            category: 'general',
            closingRank: 3200),
      ],
      fees: CollegeFees(tuitionPerYear: 280000, hostelPerYear: 130000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit scholarships for top SLAT scorers.',
      placement: PlacementStats(
        averagePackageLpa: 8.5,
        highestPackageLpa: 20.0,
        placementPercentage: 82,
        topRecruiters: [
          'Khaitan & Co',
          'Cyril Amarchand Mangaldas',
          'Corporate legal teams'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports,
        CollegeFacility.cafeteria
      ],
      facultyInfo:
          'Practitioner-faculty mix with a strong moot court programme.',
      reviews: [
        CollegeReview(
            author: 'Ira C.',
            rating: 4.4,
            comment: 'Great alternative to NLUs with a livelier campus.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does SLS Pune accept CLAT scores?',
            answer: 'No, admission is through its own SLAT entrance test.')
      ],
      website: 'https://symlaw.ac.in',
      contactEmail: 'admissions@symlaw.ac.in',
      contactPhone: '020-6621-2400',
      latitude: 18.5626,
      longitude: 73.8078,
      tags: ['Private', 'NAAC A++', 'Hostel'],
      popularityScore: 78,
    ),
    CollegeModel(
      id: 'ststephens_delhi',
      name: 'St. Stephen\'s College, Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 5,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1881,
      about: 'St. Stephen\'s is one of Delhi University\'s oldest and most '
          'prestigious colleges, famous for its History, English and Political Science programmes.',
      courses: [
        CourseModel(
          id: 'ststephens_ba_polsci',
          name: 'B.A. (Honours) Political Science',
          shortName: 'Political Science Hons',
          degree: 'BA',
          category: CourseCategory.arts,
          durationYears: 3,
          eligibility: 'CUET score + interview, 12th with 75%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess:
          'CUET score → college-specific interview → DU CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'ststephens_ba_polsci',
            category: 'general',
            closingScore: 790),
      ],
      fees: CollegeFees(tuitionPerYear: 25000, hostelPerYear: 70000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Merit and need-based scholarships for outstanding students.',
      placement: PlacementStats(
        averagePackageLpa: 6.0,
        highestPackageLpa: 20.0,
        placementPercentage: 70,
        topRecruiters: [
          'Civil Services aspirants',
          'Consulting firms',
          'Media houses'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Legendary faculty across Humanities disciplines.',
      reviews: [
        CollegeReview(
            author: 'Tara L.',
            rating: 4.9,
            comment: 'Unmatched legacy and debating culture.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is an interview mandatory?',
            answer:
                'Yes, St. Stephen\'s holds its own interview in addition to CUET scores.')
      ],
      website: 'https://www.ststephens.edu',
      contactEmail: 'admissions@ststephens.edu',
      contactPhone: '011-2766-6188',
      latitude: 28.6889,
      longitude: 77.2100,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Top Ranked'],
      popularityScore: 89,
    ),
    CollegeModel(
      id: 'miranda_house_delhi',
      name: 'Miranda House',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1948,
      about:
          'Miranda House is India\'s top-ranked women\'s college (NIRF), with '
          'strong programmes across Humanities, Sciences and Psychology.',
      courses: [
        CourseModel(
          id: 'mirandahouse_psych',
          name: 'B.A. (Honours) Psychology',
          shortName: 'Psychology Hons',
          degree: 'BA',
          category: CourseCategory.arts,
          durationYears: 3,
          eligibility: 'CUET score, 12th with 75%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score → Delhi University CSAS counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'mirandahouse_psych',
            category: 'general',
            closingScore: 785),
      ],
      fees: CollegeFees(tuitionPerYear: 20000, hostelPerYear: 60000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'DU merit scholarships and need-based fee concessions.',
      placement: PlacementStats(
        averagePackageLpa: 5.5,
        highestPackageLpa: 16.0,
        placementPercentage: 68,
        topRecruiters: [
          'Counselling practices',
          'HR firms',
          'Research institutes'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'India\'s top-ranked Psychology and Humanities faculty.',
      reviews: [
        CollegeReview(
            author: 'Zara H.',
            rating: 4.8,
            comment: 'Best women\'s college in India, hands down.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is Miranda House only for women?',
            answer:
                'Yes, it is a women\'s constituent college of Delhi University.')
      ],
      website: 'https://mirandahouse.ac.in',
      contactEmail: 'admissions@mirandahouse.ac.in',
      contactPhone: '011-2766-6675',
      latitude: 28.6975,
      longitude: 77.2094,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Top Ranked'],
      popularityScore: 86,
    ),
    CollegeModel(
      id: 'jamia_millia_delhi',
      name: 'Jamia Millia Islamia',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 3,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1920,
      about: 'Jamia Millia Islamia is a central university with a nationally '
          'ranked mass communication programme (AJK MCRC) and broad Humanities offerings.',
      courses: [
        CourseModel(
          id: 'jamia_ba_journalism',
          name: 'B.A. Journalism & Mass Communication',
          shortName: 'BJMC',
          degree: 'BA',
          category: CourseCategory.arts,
          durationYears: 3,
          eligibility: 'JMI entrance test, 12th with 50%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'Jamia\'s own entrance test, merit + written test.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'jamia_ba_journalism',
            category: 'general',
            closingRank: 800),
      ],
      fees: CollegeFees(tuitionPerYear: 18000, hostelPerYear: 25000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Central university scholarships for minority and EWS students.',
      placement: PlacementStats(
        averagePackageLpa: 5.5,
        highestPackageLpa: 14.0,
        placementPercentage: 78,
        topRecruiters: [
          'NDTV',
          'India Today Group',
          'The Hindu',
          'PR agencies'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo:
          'AJK Mass Communication Research Centre is nationally renowned.',
      reviews: [
        CollegeReview(
            author: 'Farhan I.',
            rating: 4.6,
            comment: 'Best journalism programme for the money.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is JMI open to non-Muslim students?',
            answer:
                'Yes, Jamia Millia Islamia is open to students of all backgrounds.')
      ],
      website: 'https://jmi.ac.in',
      contactEmail: 'admissions@jmi.ac.in',
      contactPhone: '011-2698-1717',
      latitude: 28.5622,
      longitude: 77.2822,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Low Fees'],
      popularityScore: 77,
    ),
    CollegeModel(
      id: 'nid_ahmedabad',
      name: 'National Institute of Design, Ahmedabad',
      city: 'Ahmedabad',
      state: 'Gujarat',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1961,
      about: 'NID Ahmedabad is India\'s premier design institute, offering '
          'undergraduate design education across product, communication and textile design.',
      courses: [
        CourseModel(
          id: 'nid_bdes',
          name: 'Bachelor of Design',
          shortName: 'B.Des',
          degree: 'B.Des',
          category: CourseCategory.design,
          durationYears: 4,
          eligibility: 'DAT Prelims + Mains, 12th any stream with 50%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess:
          'Design Aptitude Test (DAT) Prelims → Mains (studio test + interview).',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'nid_bdes',
            category: 'general',
            closingRank: 250),
      ],
      fees: CollegeFees(tuitionPerYear: 400000, hostelPerYear: 80000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Need-based scholarships and education loans facilitation.',
      placement: PlacementStats(
        averagePackageLpa: 9.0,
        highestPackageLpa: 24.0,
        placementPercentage: 90,
        topRecruiters: ['Tata Group', 'Samsung Design', 'Titan', 'Godrej'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Studio-based mentorship from practicing designers.',
      reviews: [
        CollegeReview(
            author: 'Ira D.',
            rating: 4.8,
            comment: 'The most prestigious design degree in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Can PCM students apply to NID?',
            answer: 'Yes, NID accepts students from any Class 12 stream.')
      ],
      website: 'https://www.nid.edu',
      contactEmail: 'admissions@nid.edu',
      contactPhone: '079-2662-3692',
      latitude: 23.0403,
      longitude: 72.5432,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 91,
    ),
    CollegeModel(
      id: 'nift_delhi',
      name: 'National Institute of Fashion Technology, Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1986,
      about: 'NIFT Delhi is India\'s leading fashion and design institute, '
          'offering programmes across fashion design, textile design and management.',
      courses: [
        CourseModel(
          id: 'nift_bdes_fashion',
          name: 'Bachelor of Design (Fashion Design)',
          shortName: 'B.Des Fashion',
          degree: 'B.Des',
          category: CourseCategory.design,
          durationYears: 4,
          eligibility: 'NIFT entrance exam, 12th any stream with 50%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess:
          'NIFT entrance exam (GAT + CAT) → group discussion/interview.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'nift_bdes_fashion',
            category: 'general',
            closingRank: 600),
      ],
      fees: CollegeFees(tuitionPerYear: 285000, hostelPerYear: 75000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'GOI scholarships for SC/ST/EWS students; means-based fee waivers.',
      placement: PlacementStats(
        averagePackageLpa: 7.5,
        highestPackageLpa: 18.0,
        placementPercentage: 85,
        topRecruiters: [
          'Zara',
          'H&M',
          'Levi\'s',
          'Raymond',
          'Aditya Birla Fashion'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.cafeteria
      ],
      facultyInfo: 'Industry-linked faculty with strong fashion-house tie-ups.',
      reviews: [
        CollegeReview(
            author: 'Myra V.',
            rating: 4.5,
            comment: 'Great industry exposure and internship placements.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is NIFT only for fashion design?',
            answer:
                'No, NIFT also offers textile design, accessory design, and fashion management.')
      ],
      website: 'https://www.nift.ac.in',
      contactEmail: 'admissions@nift.ac.in',
      contactPhone: '011-2618-4340',
      latitude: 28.5610,
      longitude: 77.1900,
      tags: ['Government', 'NAAC A', 'Hostel', 'High Placement'],
      popularityScore: 82,
    ),
    CollegeModel(
      id: 'tiss_mumbai',
      name: 'Tata Institute of Social Sciences, Mumbai',
      city: 'Mumbai',
      state: 'Maharashtra',
      type: CollegeType.deemed,
      nirfRank: 12,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1936,
      about:
          'TISS Mumbai is India\'s leading institute for social work, social '
          'sciences and policy research, with strong field-work integration.',
      courses: [
        CourseModel(
          id: 'tiss_ba_social_work',
          name: 'B.A. in Social Sciences',
          shortName: 'BA Social Sciences',
          degree: 'BA',
          category: CourseCategory.arts,
          durationYears: 3,
          eligibility: 'TISS-BAT entrance test, 12th with 50%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess:
          'TISS Bachelor\'s Admission Test (TISS-BAT) + personal interview.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'tiss_ba_social_work',
            category: 'general',
            closingRank: 900),
      ],
      fees: CollegeFees(tuitionPerYear: 45000, hostelPerYear: 30000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Government of India post-matric scholarships and need-based aid.',
      placement: PlacementStats(
        averagePackageLpa: 6.0,
        highestPackageLpa: 14.0,
        placementPercentage: 80,
        topRecruiters: [
          'UNICEF',
          'NGOs',
          'Government policy bodies',
          'CSR divisions of corporates'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Faculty deeply engaged in field-based social research.',
      reviews: [
        CollegeReview(
            author: 'Neha W.',
            rating: 4.7,
            comment: 'Life-changing exposure to grassroots social work.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is TISS only for postgraduates?',
            answer:
                'No, TISS also runs a dedicated BA programme with its own entrance test.')
      ],
      website: 'https://www.tiss.edu',
      contactEmail: 'admissions@tiss.edu',
      contactPhone: '022-2552-5000',
      latitude: 19.0459,
      longitude: 72.8697,
      tags: ['Private', 'NAAC A++', 'Hostel', 'Low Fees'],
      popularityScore: 74,
    ),
    CollegeModel(
      id: 'jadavpur_kolkata',
      name: 'Jadavpur University',
      city: 'Kolkata',
      state: 'West Bengal',
      type: CollegeType.government,
      nirfRank: 12,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1955,
      about: 'Jadavpur University is a highly-regarded state university with '
          'strong Arts, Comparative Literature and International Relations departments.',
      courses: [
        CourseModel(
          id: 'ju_ba_history',
          name: 'B.A. (Honours) History',
          shortName: 'History Hons',
          degree: 'BA',
          category: CourseCategory.arts,
          durationYears: 3,
          eligibility: 'CUET/board merit, 12th with 60%+',
          examIds: ['cuet'],
        ),
      ],
      admissionProcess: 'CUET score / state merit → university counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'cuet',
            courseId: 'ju_ba_history',
            category: 'general',
            closingScore: 640),
      ],
      fees: CollegeFees(tuitionPerYear: 12000, hostelPerYear: 18000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'West Bengal state scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 5.0,
        highestPackageLpa: 12.0,
        placementPercentage: 65,
        topRecruiters: [
          'Civil Services aspirants',
          'Academia',
          'Publishing houses'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Renowned faculty in comparative literature and history.',
      reviews: [
        CollegeReview(
            author: 'Debolina S.',
            rating: 4.6,
            comment: 'Intellectually vibrant, low fees, strong legacy.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is Jadavpur University only for Bengal residents?',
            answer:
                'No, it accepts students from across India through CUET/merit-based admission.')
      ],
      website: 'https://www.jaduniv.edu.in',
      contactEmail: 'admissions@jaduniv.edu.in',
      contactPhone: '033-2414-6666',
      latitude: 22.4991,
      longitude: 88.3639,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Low Fees'],
      popularityScore: 79,
    ),
  ];
}

import '../../models/college_model.dart';
import '../../models/course_model.dart';

/// Representative seed data for PCB-stream colleges: MBBS, BDS, AYUSH,
/// nursing, pharmacy, biotechnology and veterinary science. Approximate,
/// illustrative figures — see [EngineeringCollegesData] header note.
class MedicalCollegesData {
  MedicalCollegesData._();

  static const List<CollegeModel> all = [
    CollegeModel(
      id: 'aiims_delhi',
      name: 'All India Institute of Medical Sciences, Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1956,
      about: 'AIIMS Delhi is India\'s top-ranked medical institute, offering '
          'near-free MBBS education alongside world-class clinical exposure.',
      courses: [
        CourseModel(
          id: 'aiims_mbbs',
          name: 'Bachelor of Medicine, Bachelor of Surgery',
          shortName: 'MBBS',
          degree: 'MBBS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank → AIQ counselling by MCC.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'aiims_mbbs',
            category: 'general',
            closingRank: 62),
      ],
      fees: CollegeFees(tuitionPerYear: 6000, hostelPerYear: 12000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Merit-cum-means scholarship for income under ₹2.5L.',
      placement: PlacementStats(
        averagePackageLpa: 10.0,
        highestPackageLpa: 30.0,
        placementPercentage: 98,
        topRecruiters: [
          'AIIMS Hospitals',
          'Apollo',
          'Fortis',
          'Max Healthcare'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical,
        CollegeFacility.sports
      ],
      facultyInfo:
          'Faculty are leading clinicians and researchers across specialities.',
      reviews: [
        CollegeReview(
            author: 'Ritika A.',
            rating: 4.9,
            comment: 'The single best clinical exposure in the country.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is the fee really this low?',
            answer: 'Yes, AIIMS is a fully government-subsidised institute.')
      ],
      website: 'https://www.aiims.edu',
      contactEmail: 'admissions@aiims.edu',
      contactPhone: '011-2658-8500',
      latitude: 28.5672,
      longitude: 77.2100,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 99,
    ),
    CollegeModel(
      id: 'jipmer_puducherry',
      name: 'Jawaharlal Institute of Postgraduate Medical Education & Research',
      city: 'Puducherry',
      state: 'Puducherry',
      type: CollegeType.government,
      nirfRank: 4,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1823,
      about: 'JIPMER is a premier government medical institute with a large '
          'multi-specialty hospital attached for hands-on clinical training.',
      courses: [
        CourseModel(
          id: 'jipmer_mbbs',
          name: 'Bachelor of Medicine, Bachelor of Surgery',
          shortName: 'MBBS',
          degree: 'MBBS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank → AIQ counselling by MCC.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'jipmer_mbbs',
            category: 'general',
            closingRank: 340),
      ],
      fees: CollegeFees(tuitionPerYear: 8000, hostelPerYear: 15000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Central-sector scholarship for income under ₹4.5L.',
      placement: PlacementStats(
        averagePackageLpa: 9.5,
        highestPackageLpa: 25.0,
        placementPercentage: 97,
        topRecruiters: ['JIPMER Hospital', 'Apollo', 'CMC Vellore'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo: 'Strong emphasis on research alongside clinical training.',
      reviews: [
        CollegeReview(
            author: 'Aditya M.',
            rating: 4.8,
            comment: 'Second only to AIIMS Delhi for clinical exposure.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is JIPMER separate from NEET counselling?',
            answer:
                'No, since 2020 JIPMER admissions are through NEET UG and AIQ counselling.')
      ],
      website: 'https://jipmer.edu.in',
      contactEmail: 'admissions@jipmer.edu.in',
      contactPhone: '0413-229-6202',
      latitude: 11.9416,
      longitude: 79.8083,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'High Placement',
        'Top Ranked'
      ],
      popularityScore: 95,
    ),
    CollegeModel(
      id: 'cmc_vellore',
      name: 'Christian Medical College, Vellore',
      city: 'Vellore',
      state: 'Tamil Nadu',
      type: CollegeType.private,
      nirfRank: 2,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1900,
      about:
          'CMC Vellore is India\'s top-ranked private medical college, run by '
          'a Christian mission trust with a strong service-oriented ethos.',
      courses: [
        CourseModel(
          id: 'cmc_mbbs',
          name: 'Bachelor of Medicine, Bachelor of Surgery',
          shortName: 'MBBS',
          degree: 'MBBS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess:
          'NEET UG rank; majority seats reserved for church/community nominees, minority open merit seats.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'cmc_mbbs',
            category: 'general',
            closingRank: 1500),
      ],
      fees: CollegeFees(tuitionPerYear: 55000, hostelPerYear: 25000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Bursary support for economically weaker students.',
      placement: PlacementStats(
        averagePackageLpa: 9.0,
        highestPackageLpa: 22.0,
        placementPercentage: 96,
        topRecruiters: [
          'CMC Hospital',
          'Christian Mission Hospitals nationwide'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo: 'Strong mentorship culture with a service-first philosophy.',
      reviews: [
        CollegeReview(
            author: 'Grace J.',
            rating: 4.8,
            comment: 'Incredible community feel and clinical rigor.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is CMC open to all students?',
            answer:
                'A portion of seats are open merit; most are community/church nominated.')
      ],
      website: 'https://www.cmch-vellore.edu',
      contactEmail: 'admissions@cmcvellore.ac.in',
      contactPhone: '0416-228-1000',
      latitude: 12.9226,
      longitude: 79.1354,
      tags: ['Private', 'NAAC A++', 'Hostel', 'High Placement', 'Top Ranked'],
      popularityScore: 91,
    ),
    CollegeModel(
      id: 'kgmu_lucknow',
      name: 'King George\'s Medical University, Lucknow',
      city: 'Lucknow',
      state: 'Uttar Pradesh',
      type: CollegeType.government,
      nirfRank: 12,
      naacGrade: 'A+',
      nbaAccredited: false,
      establishedYear: 1911,
      about: 'KGMU is one of Uttar Pradesh\'s oldest and largest government '
          'medical universities, with a very large attached hospital network.',
      courses: [
        CourseModel(
          id: 'kgmu_mbbs',
          name: 'Bachelor of Medicine, Bachelor of Surgery',
          shortName: 'MBBS',
          degree: 'MBBS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank; 85% state-quota seats + 15% AIQ.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'kgmu_mbbs',
            category: 'general',
            closingRank: 4200),
        CutoffEntry(
            examId: 'neet',
            courseId: 'kgmu_mbbs',
            category: 'general',
            homeStateQuota: true,
            closingRank: 9500),
      ],
      fees: CollegeFees(tuitionPerYear: 15000, hostelPerYear: 18000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'UP state government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 7.5,
        highestPackageLpa: 18.0,
        placementPercentage: 92,
        topRecruiters: ['KGMU Hospital', 'SGPGI Lucknow', 'Apollo'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical,
        CollegeFacility.sports
      ],
      facultyInfo: 'Very high patient volume gives strong practical exposure.',
      reviews: [
        CollegeReview(
            author: 'Devansh R.',
            rating: 4.4,
            comment: 'Massive hospital, tons of case exposure.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is home-state quota significant here?',
            answer:
                'Yes, 85% of seats are reserved for UP domicile candidates.')
      ],
      website: 'https://www.kgmu.org',
      contactEmail: 'admissions@kgmu.org',
      contactPhone: '0522-225-7450',
      latitude: 26.8705,
      longitude: 80.9223,
      tags: ['Government', 'NAAC A+', 'Hostel', 'High Placement'],
      popularityScore: 82,
    ),
    CollegeModel(
      id: 'grant_medical_mumbai',
      name: 'Grant Government Medical College, Mumbai',
      city: 'Mumbai',
      state: 'Maharashtra',
      type: CollegeType.government,
      nirfRank: 24,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1845,
      about: 'GGMC (attached to Sir J.J. Hospital) is one of India\'s oldest '
          'medical colleges, offering low-fee MBBS with strong clinical volume.',
      courses: [
        CourseModel(
          id: 'ggmc_mbbs',
          name: 'Bachelor of Medicine, Bachelor of Surgery',
          shortName: 'MBBS',
          degree: 'MBBS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank; Maharashtra state quota + AIQ.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'ggmc_mbbs',
            category: 'general',
            homeStateQuota: true,
            closingRank: 7200),
      ],
      fees: CollegeFees(tuitionPerYear: 21000, hostelPerYear: 20000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Maharashtra state government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 7.0,
        highestPackageLpa: 16.0,
        placementPercentage: 90,
        topRecruiters: ['J.J. Hospital', 'KEM Hospital', 'Tata Memorial'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo:
          'Faculty draw on one of India\'s highest patient-volume hospitals.',
      reviews: [
        CollegeReview(
            author: 'Om S.',
            rating: 4.3,
            comment: 'Old-world charm with excellent clinical training.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is this the same as J.J. Hospital?',
            answer:
                'GGMC is the medical college attached to Sir J.J. Group of Hospitals.')
      ],
      website: 'https://ggmc.edu.in',
      contactEmail: 'dean@ggmc.edu.in',
      contactPhone: '022-2373-5555',
      latitude: 18.9633,
      longitude: 72.8311,
      tags: ['Government', 'NAAC A', 'Hostel', 'Low Fees'],
      popularityScore: 78,
    ),
    CollegeModel(
      id: 'manipal_dental',
      name: 'Manipal College of Dental Sciences',
      city: 'Manipal',
      state: 'Karnataka',
      type: CollegeType.private,
      nirfRank: 6,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1993,
      about:
          'MCODS Manipal is one of India\'s top-ranked private dental colleges '
          'with modern clinical labs and strong post-graduate pathways.',
      courses: [
        CourseModel(
          id: 'mcods_bds',
          name: 'Bachelor of Dental Surgery',
          shortName: 'BDS',
          degree: 'BDS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank based direct/management counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'mcods_bds',
            category: 'general',
            closingRank: 42000),
      ],
      fees: CollegeFees(tuitionPerYear: 620000, hostelPerYear: 110000),
      scholarshipsAvailable: false,
      scholarshipInfo: '',
      placement: PlacementStats(
        averagePackageLpa: 5.5,
        highestPackageLpa: 12.0,
        placementPercentage: 80,
        topRecruiters: [
          'Clove Dental',
          'Apollo White Dental',
          'Private practice'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo: 'Modern simulation labs for clinical dentistry.',
      reviews: [
        CollegeReview(
            author: 'Meera K.',
            rating: 4.2,
            comment: 'Excellent labs, higher fees than government colleges.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is NEET compulsory for BDS?',
            answer:
                'Yes, NEET UG is mandatory for all BDS admissions in India.')
      ],
      website: 'https://manipal.edu/mcods-manipal.html',
      contactEmail: 'dental.admissions@manipal.edu',
      contactPhone: '0820-292-2000',
      latitude: 13.3467,
      longitude: 74.7869,
      tags: ['Private', 'NAAC A++', 'Hostel'],
      popularityScore: 68,
    ),
    CollegeModel(
      id: 'nia_jaipur',
      name: 'National Institute of Ayurveda, Jaipur',
      city: 'Jaipur',
      state: 'Rajasthan',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1976,
      about: 'NIA Jaipur is a deemed-to-be-university and India\'s foremost '
          'institute for Ayurvedic medical education and research.',
      courses: [
        CourseModel(
          id: 'nia_bams',
          name: 'Bachelor of Ayurvedic Medicine and Surgery',
          shortName: 'BAMS',
          degree: 'BAMS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank → AACCC/state AYUSH counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'nia_bams',
            category: 'general',
            closingRank: 28000),
      ],
      fees: CollegeFees(tuitionPerYear: 45000, hostelPerYear: 20000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'AYUSH ministry scholarships for meritorious students.',
      placement: PlacementStats(
        averagePackageLpa: 4.5,
        highestPackageLpa: 9.0,
        placementPercentage: 75,
        topRecruiters: [
          'Patanjali',
          'Government Ayurveda Hospitals',
          'Private clinics'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo:
          'Faculty specialise across all Ayurveda departments (Panchakarma, Kayachikitsa, etc.).',
      reviews: [
        CollegeReview(
            author: 'Bhavya T.',
            rating: 4.1,
            comment: 'The gold-standard for Ayurveda education in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is NEET required for BAMS?',
            answer: 'Yes, NEET UG is mandatory for all AYUSH courses too.')
      ],
      website: 'https://nia.nic.in',
      contactEmail: 'admissions@nia.nic.in',
      contactPhone: '0141-263-5816',
      latitude: 26.8890,
      longitude: 75.8156,
      tags: ['Government', 'NAAC A', 'Hostel', 'Low Fees'],
      popularityScore: 60,
    ),
    CollegeModel(
      id: 'nih_kolkata',
      name: 'National Institute of Homoeopathy, Kolkata',
      city: 'Kolkata',
      state: 'West Bengal',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'B++',
      nbaAccredited: false,
      establishedYear: 1975,
      about: 'NIH Kolkata is a premier government institute for homoeopathic '
          'medical education under the Ministry of AYUSH.',
      courses: [
        CourseModel(
          id: 'nih_bhms',
          name: 'Bachelor of Homoeopathic Medicine and Surgery',
          shortName: 'BHMS',
          degree: 'BHMS',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess: 'NEET UG rank → AYUSH state/central counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'nih_bhms',
            category: 'general',
            closingRank: 65000),
      ],
      fees: CollegeFees(tuitionPerYear: 30000, hostelPerYear: 15000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'AYUSH ministry scholarships for meritorious students.',
      placement: PlacementStats(
        averagePackageLpa: 3.8,
        highestPackageLpa: 7.5,
        placementPercentage: 70,
        topRecruiters: ['Government Homoeopathic Hospitals', 'Private clinics'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo: 'Faculty are AYUSH-registered homoeopathic practitioners.',
      reviews: [
        CollegeReview(
            author: 'Sohom D.',
            rating: 4.0,
            comment: 'Well-regarded government homoeopathy option.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is BHMS recognised nationwide?',
            answer:
                'Yes, it is recognised by the National Commission for Homoeopathy.')
      ],
      website: 'https://nih.nic.in',
      contactEmail: 'admissions@nih.nic.in',
      contactPhone: '033-2321-4903',
      latitude: 22.4991,
      longitude: 88.3714,
      tags: ['Government', 'Hostel', 'Low Fees'],
      popularityScore: 52,
    ),
    CollegeModel(
      id: 'madras_veterinary',
      name: 'Madras Veterinary College',
      city: 'Chennai',
      state: 'Tamil Nadu',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A+',
      nbaAccredited: false,
      establishedYear: 1903,
      about: 'Madras Veterinary College, part of TANUVAS, is one of India\'s '
          'oldest and most respected veterinary science institutes.',
      courses: [
        CourseModel(
          id: 'mvc_bvsc',
          name: 'Bachelor of Veterinary Science & Animal Husbandry',
          shortName: 'B.V.Sc & AH',
          degree: 'B.V.Sc',
          category: CourseCategory.medical,
          durationYears: 5,
          eligibility: 'NEET UG qualified, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess:
          'NEET UG rank → state veterinary counselling (ICAR quota for a few seats).',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'mvc_bvsc',
            category: 'general',
            homeStateQuota: true,
            closingRank: 18500),
      ],
      fees: CollegeFees(tuitionPerYear: 25000, hostelPerYear: 16000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Tamil Nadu state scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 5.5,
        highestPackageLpa: 12.0,
        placementPercentage: 82,
        topRecruiters: [
          'Government Veterinary Dept.',
          'Dairy & Poultry Corporations',
          'Zoos & wildlife boards'
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
          'Attached veterinary hospital gives strong clinical case exposure.',
      reviews: [
        CollegeReview(
            author: 'Harini V.',
            rating: 4.3,
            comment: 'Best veterinary college in South India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Can students from other states apply?',
            answer:
                'A limited number of seats are available under the ICAR All-India quota.')
      ],
      website: 'https://tanuvas.ac.in',
      contactEmail: 'admissions@tanuvas.ac.in',
      contactPhone: '044-2536-1310',
      latitude: 13.0836,
      longitude: 80.2467,
      tags: ['Government', 'NAAC A+', 'Hostel', 'Low Fees'],
      popularityScore: 58,
    ),
    CollegeModel(
      id: 'niper_mohali',
      name:
          'National Institute of Pharmaceutical Education and Research, Mohali',
      city: 'Mohali',
      state: 'Punjab',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1998,
      about:
          'NIPER Mohali is India\'s top-ranked pharmacy institute, focused on '
          'pharmaceutical sciences research alongside its professional B.Pharm-equivalent programmes.',
      courses: [
        CourseModel(
          id: 'niper_bpharm',
          name: 'Bachelor of Pharmacy',
          shortName: 'B.Pharm',
          degree: 'B.Pharm',
          category: CourseCategory.medical,
          durationYears: 4,
          eligibility: 'NEET UG or JEE Main percentile, 12th PCB/PCM with 50%+',
          examIds: ['neet', 'jee_main'],
        ),
      ],
      admissionProcess:
          'NIPER JEE / state pharmacy counselling based on merit.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'niper_bpharm',
            category: 'general',
            closingRank: 21000),
      ],
      fees: CollegeFees(tuitionPerYear: 100000, hostelPerYear: 35000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'GATE/NIPER JEE merit scholarships and assistantships for PG, need-based for UG.',
      placement: PlacementStats(
        averagePackageLpa: 8.0,
        highestPackageLpa: 24.0,
        placementPercentage: 88,
        topRecruiters: ['Sun Pharma', 'Dr. Reddy\'s', 'Cipla', 'Biocon'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo:
          'Research-intensive faculty across pharmaceutical disciplines.',
      reviews: [
        CollegeReview(
            author: 'Jaspreet K.',
            rating: 4.5,
            comment: 'Best pharmacy research ecosystem in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is this only for postgraduates?',
            answer:
                'NIPER primarily focuses on PG/PhD, with a small integrated UG-PG track available at some campuses.')
      ],
      website: 'https://niper.gov.in',
      contactEmail: 'admissions@niper.ac.in',
      contactPhone: '0172-221-4682',
      latitude: 30.6673,
      longitude: 76.7285,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Top Ranked'],
      popularityScore: 72,
    ),
    CollegeModel(
      id: 'aiims_nursing',
      name: 'AIIMS College of Nursing, Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1956,
      about: 'AIIMS College of Nursing offers India\'s most sought-after B.Sc '
          'Nursing programme, attached to the AIIMS Delhi hospital network.',
      courses: [
        CourseModel(
          id: 'aiims_bsc_nursing',
          name: 'B.Sc. Nursing (Honours)',
          shortName: 'B.Sc Nursing',
          degree: 'B.Sc',
          category: CourseCategory.medical,
          durationYears: 4,
          eligibility: 'AIIMS Nursing entrance / NEET UG, 12th PCB with 50%+',
          examIds: ['neet'],
        ),
      ],
      admissionProcess:
          'AIIMS Nursing entrance exam / NEET-based state counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'neet',
            courseId: 'aiims_bsc_nursing',
            category: 'general',
            closingRank: 9800),
      ],
      fees: CollegeFees(tuitionPerYear: 5000, hostelPerYear: 8000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Fee waivers for economically weaker candidates.',
      placement: PlacementStats(
        averagePackageLpa: 5.0,
        highestPackageLpa: 12.0,
        placementPercentage: 95,
        topRecruiters: [
          'AIIMS Hospitals',
          'Fortis',
          'Max Healthcare',
          'NHS (UK) recruitment drives'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.medical
      ],
      facultyInfo: 'Clinical postings across all AIIMS specialty departments.',
      reviews: [
        CollegeReview(
            author: 'Fatima N.',
            rating: 4.7,
            comment:
                'Best nursing programme in the country, guaranteed exposure.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is this only for women?',
            answer: 'No, the programme is open to all genders.')
      ],
      website: 'https://www.aiimsexams.ac.in',
      contactEmail: 'nursing@aiims.edu',
      contactPhone: '011-2658-8663',
      latitude: 28.5672,
      longitude: 77.2100,
      tags: ['Government', 'NAAC A++', 'Hostel', 'Low Fees', 'Top Ranked'],
      popularityScore: 74,
    ),
  ];
}

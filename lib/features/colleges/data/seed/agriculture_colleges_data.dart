import '../../models/college_model.dart';
import '../../models/course_model.dart';

/// Representative seed data for Agriculture-stream colleges: B.Sc
/// Agriculture, Forestry, Horticulture and Food Technology. Approximate,
/// illustrative figures — see [EngineeringCollegesData] header note.
class AgricultureCollegesData {
  AgricultureCollegesData._();

  static const List<CollegeModel> all = [
    CollegeModel(
      id: 'iari_delhi',
      name: 'ICAR – Indian Agricultural Research Institute',
      city: 'New Delhi',
      state: 'Delhi',
      type: CollegeType.government,
      nirfRank: 1,
      naacGrade: 'A++',
      nbaAccredited: false,
      establishedYear: 1905,
      about:
          'IARI (Pusa Institute) is India\'s top-ranked agricultural research '
          'institute, offering rigorous UG/PG programmes with strong field-research exposure.',
      courses: [
        CourseModel(
          id: 'iari_bsc_agri',
          name: 'B.Sc. (Honours) Agriculture',
          shortName: 'B.Sc Agriculture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'ICAR AIEEA UG rank, 12th PCB/PCM with 50%+',
          examIds: ['icar'],
        ),
      ],
      admissionProcess:
          'ICAR AIEEA UG rank → ICAR counselling (15% all-India quota seats).',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'iari_bsc_agri',
            category: 'general',
            closingRank: 250),
      ],
      fees: CollegeFees(tuitionPerYear: 30000, hostelPerYear: 20000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'ICAR merit scholarships for top AIEEA rankers.',
      placement: PlacementStats(
        averagePackageLpa: 7.0,
        highestPackageLpa: 16.0,
        placementPercentage: 85,
        topRecruiters: [
          'ICAR institutes',
          'FCI',
          'NABARD',
          'Agri-biotech companies'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Home to some of India\'s leading agricultural scientists.',
      reviews: [
        CollegeReview(
            author: 'Ankit R.',
            rating: 4.7,
            comment: 'The best agricultural research exposure in India.')
      ],
      faqs: [
        FaqEntry(
            question: 'What is the ICAR AIEEA quota?',
            answer:
                'ICAR AIEEA UG fills 15% all-India quota seats across all state agricultural universities plus IARI\'s own seats.')
      ],
      website: 'https://www.iari.res.in',
      contactEmail: 'admissions@iari.res.in',
      contactPhone: '011-2584-3375',
      latitude: 28.6398,
      longitude: 77.1591,
      tags: [
        'Government',
        'NAAC A++',
        'Hostel',
        'Top Ranked',
        'AI Recommended'
      ],
      popularityScore: 84,
    ),
    CollegeModel(
      id: 'pau_ludhiana',
      name: 'Punjab Agricultural University',
      city: 'Ludhiana',
      state: 'Punjab',
      type: CollegeType.government,
      nirfRank: 3,
      naacGrade: 'A+',
      nbaAccredited: false,
      establishedYear: 1962,
      about:
          'PAU Ludhiana was central to India\'s Green Revolution and remains '
          'one of the country\'s top state agricultural universities.',
      courses: [
        CourseModel(
          id: 'pau_bsc_agri',
          name: 'B.Sc. (Honours) Agriculture',
          shortName: 'B.Sc Agriculture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'ICAR AIEEA / state quota, 12th PCB/PCM with 50%+',
          examIds: ['icar', 'state_cet'],
        ),
      ],
      admissionProcess: 'State quota merit + ICAR AIEEA all-India quota seats.',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'pau_bsc_agri',
            category: 'general',
            homeStateQuota: true,
            closingRank: 1400),
      ],
      fees: CollegeFees(tuitionPerYear: 42000, hostelPerYear: 22000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Punjab state government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 5.5,
        highestPackageLpa: 12.0,
        placementPercentage: 78,
        topRecruiters: [
          'Punjab Agro',
          'Nestlé',
          'ITC Agri-business',
          'State agriculture department'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Deep expertise in crop science and agronomy.',
      reviews: [
        CollegeReview(
            author: 'Gurpreet S.',
            rating: 4.4,
            comment: 'Legacy institute for agriculture in North India.')
      ],
      faqs: [
        FaqEntry(
            question: 'Are non-Punjab students eligible?',
            answer:
                'Yes, through the ICAR AIEEA all-India quota (15% of seats).')
      ],
      website: 'https://www.pau.edu',
      contactEmail: 'admissions@pau.edu',
      contactPhone: '0161-240-1960',
      latitude: 30.9010,
      longitude: 75.8073,
      tags: ['Government', 'NAAC A+', 'Hostel', 'Low Fees', 'Top Ranked'],
      popularityScore: 70,
    ),
    CollegeModel(
      id: 'gbpuat_pantnagar',
      name: 'G.B. Pant University of Agriculture & Technology',
      city: 'Pantnagar',
      state: 'Uttarakhand',
      type: CollegeType.government,
      nirfRank: 6,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1960,
      about:
          'GBPUAT was India\'s first agricultural university, modelled on the '
          'US land-grant system, and remains a top choice for agri-sciences.',
      courses: [
        CourseModel(
          id: 'gbpuat_bsc_agri',
          name: 'B.Sc. (Honours) Agriculture',
          shortName: 'B.Sc Agriculture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'ICAR AIEEA / state quota, 12th PCB/PCM with 50%+',
          examIds: ['icar', 'state_cet'],
        ),
      ],
      admissionProcess: 'State quota merit + ICAR AIEEA all-India quota seats.',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'gbpuat_bsc_agri',
            category: 'general',
            homeStateQuota: true,
            closingRank: 2100),
      ],
      fees: CollegeFees(tuitionPerYear: 38000, hostelPerYear: 20000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Uttarakhand state scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 5.2,
        highestPackageLpa: 11.0,
        placementPercentage: 75,
        topRecruiters: [
          'ICAR institutes',
          'Agri-input companies',
          'State agriculture department'
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
          'India\'s first land-grant-style agricultural faculty model.',
      reviews: [
        CollegeReview(
            author: 'Vidhi N.',
            rating: 4.3,
            comment: 'Historic institute with a large experimental farm.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is this India\'s oldest agricultural university?',
            answer:
                'Yes, GBPUAT (1960) was India\'s first agricultural university.')
      ],
      website: 'https://www.gbpuat.ac.in',
      contactEmail: 'admissions@gbpuat.ac.in',
      contactPhone: '05944-233-338',
      latitude: 29.0222,
      longitude: 79.4908,
      tags: ['Government', 'NAAC A', 'Hostel', 'Low Fees'],
      popularityScore: 66,
    ),
    CollegeModel(
      id: 'tnau_coimbatore',
      name: 'Tamil Nadu Agricultural University',
      city: 'Coimbatore',
      state: 'Tamil Nadu',
      type: CollegeType.government,
      nirfRank: 4,
      naacGrade: 'A+',
      nbaAccredited: false,
      establishedYear: 1971,
      about:
          'TNAU Coimbatore is South India\'s leading agricultural university, '
          'with strong horticulture and agri-biotechnology departments.',
      courses: [
        CourseModel(
          id: 'tnau_bsc_agri',
          name: 'B.Sc. (Honours) Agriculture',
          shortName: 'B.Sc Agriculture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'State quota / ICAR AIEEA, 12th PCB/PCM with 50%+',
          examIds: ['icar', 'state_cet'],
        ),
        CourseModel(
          id: 'tnau_bsc_horti',
          name: 'B.Sc. (Honours) Horticulture',
          shortName: 'B.Sc Horticulture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'State quota / ICAR AIEEA, 12th PCB/PCM with 50%+',
          examIds: ['icar', 'state_cet'],
        ),
      ],
      admissionProcess:
          'Tamil Nadu state agriculture counselling + ICAR AIEEA all-India quota.',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'tnau_bsc_agri',
            category: 'general',
            homeStateQuota: true,
            closingRank: 1800),
      ],
      fees: CollegeFees(tuitionPerYear: 28000, hostelPerYear: 18000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Tamil Nadu state government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 5.8,
        highestPackageLpa: 13.0,
        placementPercentage: 80,
        topRecruiters: [
          'ITC Agri-business',
          'Rallis India',
          'State horticulture department'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo: 'Strong horticulture and agri-biotech research groups.',
      reviews: [
        CollegeReview(
            author: 'Dhanush M.',
            rating: 4.4,
            comment: 'Great horticulture specialisation options.')
      ],
      faqs: [
        FaqEntry(
            question: 'Does TNAU offer Horticulture separately?',
            answer:
                'Yes, B.Sc. Horticulture is offered as a distinct programme alongside B.Sc. Agriculture.')
      ],
      website: 'https://www.tnau.ac.in',
      contactEmail: 'admissions@tnau.ac.in',
      contactPhone: '0422-666-1200',
      latitude: 11.0245,
      longitude: 76.9349,
      tags: ['Government', 'NAAC A+', 'Hostel', 'Low Fees'],
      popularityScore: 68,
    ),
    CollegeModel(
      id: 'fri_dehradun',
      name: 'Forest Research Institute, Dehradun',
      city: 'Dehradun',
      state: 'Uttarakhand',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: false,
      establishedYear: 1878,
      about:
          'FRI Dehradun (deemed university) is India\'s foremost institute for '
          'forestry education and research, set on a heritage colonial-era campus.',
      courses: [
        CourseModel(
          id: 'fri_bsc_forestry',
          name: 'B.Sc. Forestry',
          shortName: 'B.Sc Forestry',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'ICAR AIEEA / entrance test, 12th PCB/PCM with 50%+',
          examIds: ['icar'],
        ),
      ],
      admissionProcess: 'ICAR AIEEA / FRI\'s own entrance test, merit-based.',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'fri_bsc_forestry',
            category: 'general',
            closingRank: 3200),
      ],
      fees: CollegeFees(tuitionPerYear: 35000, hostelPerYear: 20000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Ministry of Environment scholarships for select students.',
      placement: PlacementStats(
        averagePackageLpa: 5.0,
        highestPackageLpa: 10.0,
        placementPercentage: 70,
        topRecruiters: [
          'Forest Departments',
          'Wildlife Institute of India',
          'NGOs in conservation'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo:
          'Faculty with deep field-research experience in Indian forests.',
      reviews: [
        CollegeReview(
            author: 'Rudra P.',
            rating: 4.5,
            comment: 'Gorgeous heritage campus, unique specialisation.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is FRI only for forestry?',
            answer:
                'FRI specialises in forestry and allied environmental sciences.')
      ],
      website: 'https://fri.icfre.gov.in',
      contactEmail: 'admissions@icfre.org',
      contactPhone: '0135-275-6002',
      latitude: 30.3421,
      longitude: 77.9999,
      tags: ['Government', 'NAAC A', 'Hostel', 'Low Fees'],
      popularityScore: 58,
    ),
    CollegeModel(
      id: 'niftem_haryana',
      name:
          'National Institute of Food Technology Entrepreneurship and Management',
      city: 'Kundli',
      state: 'Haryana',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'A',
      nbaAccredited: true,
      establishedYear: 2006,
      about:
          'NIFTEM is India\'s premier food-technology institute, blending food '
          'science with entrepreneurship and food business management.',
      courses: [
        CourseModel(
          id: 'niftem_btech_food',
          name: 'B.Tech in Food Technology',
          shortName: 'Food Technology',
          degree: 'B.Tech',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'JEE Main percentile, 12th PCM/PCB with 60%+',
          examIds: ['jee_main', 'icar'],
        ),
      ],
      admissionProcess: 'JEE Main percentile based counselling.',
      cutoffs: [
        CutoffEntry(
            examId: 'jee_main',
            courseId: 'niftem_btech_food',
            category: 'general',
            closingRank: 32000),
      ],
      fees: CollegeFees(tuitionPerYear: 150000, hostelPerYear: 40000),
      scholarshipsAvailable: true,
      scholarshipInfo: 'Ministry of Food Processing Industries scholarships.',
      placement: PlacementStats(
        averagePackageLpa: 6.5,
        highestPackageLpa: 15.0,
        placementPercentage: 82,
        topRecruiters: ['Nestlé', 'ITC Foods', 'PepsiCo', 'Britannia', 'Amul'],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi,
        CollegeFacility.sports
      ],
      facultyInfo:
          'Faculty spans food science, processing tech, and business management.',
      reviews: [
        CollegeReview(
            author: 'Ojas K.',
            rating: 4.3,
            comment: 'Unique blend of tech and food-business focus.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is this only for PCB students?',
            answer:
                'No, both PCM and PCB students with JEE Main scores are eligible.')
      ],
      website: 'https://niftem.ac.in',
      contactEmail: 'admissions@niftem.ac.in',
      contactPhone: '0130-228-4200',
      latitude: 29.1492,
      longitude: 77.0328,
      tags: ['Government', 'NAAC A', 'NBA', 'Hostel'],
      popularityScore: 62,
    ),
    CollegeModel(
      id: 'aau_anand',
      name: 'Anand Agricultural University',
      city: 'Anand',
      state: 'Gujarat',
      type: CollegeType.government,
      nirfRank: null,
      naacGrade: 'B++',
      nbaAccredited: false,
      establishedYear: 2004,
      about:
          'AAU Anand, in the heart of India\'s "Milk Capital," is known for its '
          'dairy science and agri-business programmes alongside core agriculture.',
      courses: [
        CourseModel(
          id: 'aau_bsc_agri',
          name: 'B.Sc. (Honours) Agriculture',
          shortName: 'B.Sc Agriculture',
          degree: 'B.Sc',
          category: CourseCategory.agriculture,
          durationYears: 4,
          eligibility: 'State quota / ICAR AIEEA, 12th PCB/PCM with 50%+',
          examIds: ['icar', 'state_cet'],
        ),
      ],
      admissionProcess:
          'Gujarat state agriculture counselling + ICAR AIEEA all-India quota.',
      cutoffs: [
        CutoffEntry(
            examId: 'icar',
            courseId: 'aau_bsc_agri',
            category: 'general',
            homeStateQuota: true,
            closingRank: 4500),
      ],
      fees: CollegeFees(tuitionPerYear: 26000, hostelPerYear: 16000),
      scholarshipsAvailable: true,
      scholarshipInfo:
          'Gujarat state government scholarships for domicile students.',
      placement: PlacementStats(
        averagePackageLpa: 4.8,
        highestPackageLpa: 9.5,
        placementPercentage: 72,
        topRecruiters: [
          'Amul (GCMMF)',
          'State agriculture department',
          'Agri-input companies'
        ],
      ),
      facilities: [
        CollegeFacility.library,
        CollegeFacility.labs,
        CollegeFacility.hostel,
        CollegeFacility.wifi
      ],
      facultyInfo:
          'Strong dairy-science and agri-business linkages via Amul/NDDB.',
      reviews: [
        CollegeReview(
            author: 'Krisha P.',
            rating: 4.1,
            comment: 'Great dairy and agri-business exposure near Amul.')
      ],
      faqs: [
        FaqEntry(
            question: 'Is there a dairy specialisation?',
            answer:
                'Yes, AAU has close ties with the Amul/NDDB dairy ecosystem in Anand.')
      ],
      website: 'https://www.aau.in',
      contactEmail: 'admissions@aau.in',
      contactPhone: '02692-261-273',
      latitude: 22.5645,
      longitude: 72.9289,
      tags: ['Government', 'Hostel', 'Low Fees'],
      popularityScore: 52,
    ),
  ];
}

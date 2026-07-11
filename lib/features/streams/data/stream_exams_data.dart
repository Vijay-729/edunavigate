import '../models/stream_exam.dart';

/// Master list of entrance exams referenced across all four streams.
/// Cutoffs/registration windows are realistic *sample* figures for a typical
/// recent year — always confirm current numbers on the official exam site.
class StreamExamsData {
  StreamExamsData._();

  static const List<StreamExam> all = [
    StreamExam(
      id: 'jee_main',
      name: 'JEE Main',
      fullName: 'Joint Entrance Examination (Main)',
      description:
          'National-level exam for admission to NITs, IIITs, and other '
          'centrally funded engineering colleges, and the qualifier for JEE '
          'Advanced.',
      eligibility: 'Class 12 with Physics, Chemistry, Mathematics (PCM).',
      syllabusHighlights: [
        'Physics: Mechanics, Electromagnetism, Modern Physics',
        'Chemistry: Physical, Organic, Inorganic',
        'Mathematics: Algebra, Calculus, Coordinate Geometry, Trigonometry',
      ],
      difficulty: 'High',
      registration:
          'Held twice a year (Jan & Apr sessions) via jeemain.nta.nic.in.',
      previousYearCutoffs:
          'Sample: General category ~90+ percentile for NIT-tier colleges; '
          'varies significantly by branch and college.',
      preparationTips: [
        'Master NCERT thoroughly before moving to reference books',
        'Practice previous 10 years\' papers under timed conditions',
        'Focus on speed and accuracy for numerical problems',
        'Revise formulas weekly instead of cramming before the exam',
      ],
      bestBooks: [
        'NCERT Physics, Chemistry, Maths (Class 11 & 12)',
        'HC Verma — Concepts of Physics',
        'RD Sharma — Mathematics',
        'OP Tandon — Physical & Organic Chemistry',
      ],
      timeline:
          'Registration: Nov & Feb • Exam: Jan & Apr • Result: ~2 weeks after',
    ),
    StreamExam(
      id: 'jee_advanced',
      name: 'JEE Advanced',
      fullName: 'Joint Entrance Examination (Advanced)',
      description:
          'The gateway to the 23 IITs — only the top scorers from JEE Main '
          'qualify to attempt this exam.',
      eligibility: 'Must rank among the top ~2.5 lakh in JEE Main.',
      syllabusHighlights: [
        'Same subjects as JEE Main but with deeper conceptual, multi-step problems',
        'Strong emphasis on application over memorisation',
      ],
      difficulty: 'Very High',
      registration: 'Opens right after JEE Main results, via jeeadv.ac.in.',
      previousYearCutoffs:
          'Sample: qualifying cutoff typically ~90 marks out of 360 for '
          'General category — verify on the official site each year.',
      preparationTips: [
        'Solve IIT-level problems, not just JEE Main-level ones',
        'Time-bound mock tests are essential — the paper is long and tricky',
        'Strengthen weak chapters instead of over-revising strong ones',
      ],
      bestBooks: [
        'Irodov — Problems in General Physics',
        'Cengage Series (Physics/Chemistry/Maths)',
        'Previous 15 years JEE Advanced papers',
      ],
      timeline: 'Registration: May • Exam: May/Jun • Result: Jun',
    ),
    StreamExam(
      id: 'bitsat',
      name: 'BITSAT',
      fullName: 'Birla Institute of Technology and Science Admission Test',
      description:
          'Computer-based entrance test for admission to BITS Pilani, Goa, '
          'and Hyderabad campuses.',
      eligibility: 'Class 12 with PCM and minimum 75% aggregate (varies).',
      syllabusHighlights: [
        'Physics, Chemistry, Mathematics, English Proficiency, Logical Reasoning',
      ],
      difficulty: 'High',
      registration: 'Via bitsadmission.com, typically Jan–May window.',
      previousYearCutoffs:
          'Sample: ~320+/390 for popular branches at Pilani campus.',
      preparationTips: [
        'Practice speed-based MCQs — BITSAT rewards quick, accurate solving',
        'Attempt the English & Logical Reasoning sections seriously — they add easy marks',
        'Use the bonus-question strategy (extra questions if you finish early)',
      ],
      bestBooks: [
        'NCERT + JEE Main-level books',
        'BITSAT previous year papers and mock tests',
      ],
      timeline: 'Registration: Jan–May • Exam: May/Jun • Result: Jun',
    ),
    StreamExam(
      id: 'viteee',
      name: 'VITEEE',
      fullName: 'VIT Engineering Entrance Examination',
      description:
          'Entrance exam for admission to VIT Vellore, Chennai, and other campuses.',
      eligibility: 'Class 12 with PCM and minimum 60% aggregate (varies).',
      syllabusHighlights: [
        'Physics, Chemistry, Mathematics/Biology, Aptitude, English',
      ],
      difficulty: 'Moderate',
      registration: 'Via viteee.vit.ac.in, typically Nov–Mar window.',
      previousYearCutoffs:
          'Sample: top branches need a rank within the first few thousand.',
      preparationTips: [
        'NCERT-level prep is usually sufficient',
        'Practice previous years\' papers for the aptitude section',
      ],
      bestBooks: ['NCERT Class 11 & 12', 'VITEEE previous year papers'],
      timeline: 'Registration: Nov–Mar • Exam: Apr • Result: Apr/May',
    ),
    StreamExam(
      id: 'srmjeee',
      name: 'SRMJEEE',
      fullName: 'SRM Joint Engineering Entrance Examination',
      description:
          'Entrance exam for SRM Institute of Science and Technology campuses.',
      eligibility: 'Class 12 with PCM.',
      syllabusHighlights: ['Physics, Chemistry, Mathematics/Biology, Aptitude'],
      difficulty: 'Moderate',
      registration: 'Via srmist.edu.in admissions portal.',
      previousYearCutoffs: 'Sample: varies widely by campus and branch.',
      preparationTips: [
        'Focus on NCERT fundamentals',
        'Practice mock tests for time management',
      ],
      bestBooks: ['NCERT Class 11 & 12', 'SRMJEEE sample papers'],
      timeline:
          'Registration: Dec–Apr • Exam: Apr (multiple slots) • Result: within weeks',
    ),
    StreamExam(
      id: 'nda',
      name: 'NDA',
      fullName: 'National Defence Academy Examination',
      description:
          'UPSC-conducted exam for entry into the Army, Navy, and Air Force '
          'wings of the NDA — a direct path into the armed forces after Class 12.',
      eligibility:
          'Class 12 (PCM for Air Force/Navy; any stream for Army), unmarried, age 16.5–19.5.',
      syllabusHighlights: [
        'Mathematics (Class 11–12 level)',
        'General Ability Test: English + General Knowledge (Physics, Chemistry, History, Geography, Current Affairs)',
      ],
      difficulty: 'Moderate to High',
      registration: 'Via upsc.gov.in, exam held twice a year.',
      previousYearCutoffs:
          'Sample: written cutoff ~340/900; final (with SSB) ~700/1800.',
      preparationTips: [
        'Physical fitness matters as much as academics — start training early',
        'Strengthen Maths basics thoroughly',
        'Follow current affairs daily for the GK section',
        'Prepare for the SSB interview well in advance — it tests personality, not just knowledge',
      ],
      bestBooks: [
        'NCERT Maths (Class 11 & 12)',
        'Pathfinder NDA/NA by Arihant',
        'Manorama Yearbook (GK)',
      ],
      timeline:
          'Registration: Dec & Jun • Exam: Apr & Sep • SSB: months after written result',
    ),
    StreamExam(
      id: 'nata',
      name: 'NATA',
      fullName: 'National Aptitude Test in Architecture',
      description:
          'Entrance exam for admission to B.Arch programmes across India.',
      eligibility: 'Class 12 with Mathematics as a subject.',
      syllabusHighlights: [
        'Mathematics, General Aptitude, Drawing & Observation skills',
      ],
      difficulty: 'Moderate',
      registration: 'Via nata.in, held in multiple sessions.',
      previousYearCutoffs:
          'Sample: ~85–100/200 for reputed government colleges.',
      preparationTips: [
        'Practice freehand sketching daily — speed and proportion matter',
        'Build a portfolio of observational drawings',
        'Revise Class 11–12 Maths for the aptitude section',
      ],
      bestBooks: [
        'NATA & B.Arch study guide by Ar. Shadan Usmani',
        'A Visual Dictionary of Architecture',
      ],
      timeline:
          'Registration: Jan–Mar • Exam: Apr–Jul (multiple sessions) • Result: within weeks',
    ),
    StreamExam(
      id: 'cuet',
      name: 'CUET',
      fullName: 'Common University Entrance Test',
      description:
          'Single entrance test for admission to undergraduate programmes at '
          'Central Universities and many other participating universities, '
          'across all streams.',
      eligibility:
          'Class 12 in any stream, subject choices depend on target course.',
      syllabusHighlights: [
        'Domain-specific subjects (chosen based on target course)',
        'General Test: Reasoning, General Knowledge, Numeracy',
        'Language proficiency paper',
      ],
      difficulty: 'Moderate',
      registration: 'Via cuet.nta.nic.in, applications typically Feb–Mar.',
      previousYearCutoffs:
          'Sample: varies hugely by university and course — check each university\'s cutoff list.',
      preparationTips: [
        'Pick domain subjects that match your Class 12 subjects for easier prep',
        'NCERT is the primary source for domain papers',
        'Practice speed for the General Test\'s reasoning section',
      ],
      bestBooks: [
        'NCERT (Class 12) for chosen domains',
        'CUET previous year papers'
      ],
      timeline: 'Registration: Feb–Mar • Exam: May • Result: Jun/Jul',
    ),
    StreamExam(
      id: 'neet',
      name: 'NEET',
      fullName: 'National Eligibility cum Entrance Test',
      description:
          'The single national entrance exam for all MBBS, BDS, AYUSH, and '
          'veterinary courses in India.',
      eligibility: 'Class 12 with Physics, Chemistry, Biology (PCB).',
      syllabusHighlights: [
        'Physics & Chemistry (Class 11–12 NCERT)',
        'Biology — the highest-weightage section, entirely NCERT-based',
      ],
      difficulty: 'Very High',
      registration: 'Via neet.nta.nic.in, once a year.',
      previousYearCutoffs:
          'Sample: General category qualifying ~140+/720; govt. MBBS admission '
          'typically needs 600+/720 — varies by state and category.',
      preparationTips: [
        'NCERT Biology should be memorised almost word-for-word',
        'Attempt full-length mocks weekly closer to the exam',
        'Don\'t neglect Physics — it\'s usually the lowest-scoring section for PCB students',
      ],
      bestBooks: [
        'NCERT Biology, Physics, Chemistry (Class 11 & 12)',
        'MTG NCERT at your Fingertips',
        'DC Pandey (Physics), MS Chouhan (Organic Chemistry)',
      ],
      timeline: 'Registration: Feb–Mar • Exam: May • Result: Jun',
    ),
    StreamExam(
      id: 'aiims',
      name: 'AIIMS MBBS',
      fullName: 'AIIMS MBBS Entrance (historical)',
      description:
          'Previously a separate entrance for AIIMS New Delhi and other AIIMS '
          'campuses.',
      eligibility: 'Class 12 with PCB.',
      syllabusHighlights: ['Physics, Chemistry, Biology — similar to NEET'],
      difficulty: 'Very High',
      registration: 'No longer held separately — see official note.',
      previousYearCutoffs: 'Not applicable since the merger with NEET.',
      preparationTips: [
        'Prepare for NEET — AIIMS admissions now go entirely through NEET All India Rank',
      ],
      bestBooks: ['Same as NEET preparation books'],
      timeline: 'Not applicable — admission is via NEET counselling.',
      officialNote:
          'Since 2020, the separate AIIMS MBBS entrance exam has been '
          'discontinued and merged into NEET. All AIIMS MBBS seats are now '
          'filled through NEET-UG All India Quota counselling.',
    ),
    StreamExam(
      id: 'icar',
      name: 'ICAR AIEEA',
      fullName: 'ICAR All India Entrance Examination for Admission',
      description: 'Entrance exam for undergraduate agriculture, horticulture, '
          'fisheries, and forestry programmes across agricultural universities.',
      eligibility: 'Class 12 with PCB or PCM depending on the course.',
      syllabusHighlights: [
        'Physics, Chemistry, Biology/Mathematics (Class 11–12 level)'
      ],
      difficulty: 'Moderate',
      registration: 'Via icar.nta.nic.in.',
      previousYearCutoffs: 'Sample: varies by university and category.',
      preparationTips: [
        'NCERT-level preparation is generally sufficient',
        'Focus on Biology/Agriculture-relevant chapters',
      ],
      bestBooks: [
        'NCERT Class 11 & 12 (PCB/PCM)',
        'ICAR AIEEA previous papers'
      ],
      timeline: 'Registration: Mar–Apr • Exam: Jun • Result: within weeks',
    ),
    StreamExam(
      id: 'ca_foundation',
      name: 'CA Foundation',
      fullName: 'Chartered Accountancy Foundation Course',
      description:
          'The entry-level exam conducted by ICAI to begin the Chartered '
          'Accountancy qualification.',
      eligibility:
          'Passed Class 12 (any stream); can register right after Class 10.',
      syllabusHighlights: [
        'Principles & Practice of Accounting',
        'Business Laws',
        'Quantitative Aptitude',
        'Business Economics',
      ],
      difficulty: 'Moderate',
      registration: 'Via icai.org, exams held twice a year.',
      previousYearCutoffs:
          'Sample: pass mark is 40% per paper and 50% aggregate.',
      preparationTips: [
        'Start early — many students register right after Class 10',
        'Practice numerical accounting problems daily',
        'Use ICAI\'s own study material as the primary source',
      ],
      bestBooks: [
        'ICAI Study Material (official)',
        'Scanner/Reference books by Padhuka or D.G. Sharma'
      ],
      timeline:
          'Registration: ongoing • Exam: May & Nov • Result: ~6 weeks after',
    ),
    StreamExam(
      id: 'cseet',
      name: 'CSEET',
      fullName: 'Company Secretary Executive Entrance Test',
      description:
          'Entry-level test conducted by ICSI to begin the Company Secretary course.',
      eligibility: 'Passed Class 12 (any stream).',
      syllabusHighlights: [
        'Business Communication',
        'Legal Aptitude & Logical Reasoning',
        'Economic & Business Environment',
        'Current Affairs, Presentation & Communication Skills',
      ],
      difficulty: 'Moderate',
      registration: 'Via icsi.edu, held every 2 months (bi-monthly).',
      previousYearCutoffs:
          'Sample: pass mark is 40% per subject and 50% aggregate.',
      preparationTips: [
        'ICSI provides official e-learning material — use it as the base',
        'Practice mock tests for the reasoning and legal aptitude sections',
      ],
      bestBooks: ['ICSI CSEET study material (official)'],
      timeline:
          'Registration: ongoing • Exam: bi-monthly (Jan, May, Jul, Nov, etc.)',
    ),
    StreamExam(
      id: 'cma_foundation',
      name: 'CMA Foundation',
      fullName: 'Cost and Management Accountancy Foundation',
      description:
          'Entry-level exam by ICMAI to begin the Cost & Management Accountant course.',
      eligibility: 'Passed Class 12 (any stream).',
      syllabusHighlights: [
        'Fundamentals of Business Laws & Business Communication',
        'Fundamentals of Financial & Cost Accounting',
        'Fundamentals of Business Mathematics & Statistics',
        'Fundamentals of Business Economics & Management',
      ],
      difficulty: 'Moderate',
      registration: 'Via icmai.in, exams held twice a year.',
      previousYearCutoffs:
          'Sample: pass mark is 40% per paper and 50% aggregate.',
      preparationTips: [
        'Use ICMAI study material as the core resource',
        'Practice cost accounting numericals regularly',
      ],
      bestBooks: ['ICMAI Foundation Study Material (official)'],
      timeline:
          'Registration: ongoing • Exam: Jun & Dec • Result: ~2 months after',
    ),
    StreamExam(
      id: 'ipmat',
      name: 'IPMAT',
      fullName: 'Integrated Programme in Management Aptitude Test',
      description:
          'Entrance exam for the 5-year Integrated MBA programmes at IIM '
          'Indore, Rohtak, and other IIMs — a direct path into an IIM after '
          'Class 12.',
      eligibility:
          'Class 12 (any stream) with strong aptitude in Maths and English.',
      syllabusHighlights: [
        'Quantitative Ability (both MCQ and short-answer)',
        'Verbal Ability',
        'Logical Reasoning (at some IIMs)',
      ],
      difficulty: 'High',
      registration: 'Via respective IIM websites, typically Jan–May window.',
      previousYearCutoffs:
          'Sample: top percentile candidates called for the WAT/PI round.',
      preparationTips: [
        'Practice CAT/MBA-level quant and verbal questions early',
        'Short-answer quant sections need strong calculation speed',
      ],
      bestBooks: [
        'Quantitative Aptitude by R.S. Aggarwal',
        'IPMAT previous year papers'
      ],
      timeline: 'Registration: Jan–May • Exam: May/Jun • Result: Jun/Jul',
    ),
    StreamExam(
      id: 'clat',
      name: 'CLAT',
      fullName: 'Common Law Admission Test',
      description: 'National entrance exam for admission to the National Law '
          'Universities (NLUs) for 5-year integrated law programmes.',
      eligibility: 'Class 12 (any stream) with minimum 45% aggregate (varies).',
      syllabusHighlights: [
        'English Language',
        'Current Affairs including General Knowledge',
        'Legal Reasoning',
        'Logical Reasoning',
        'Quantitative Techniques',
      ],
      difficulty: 'High',
      registration: 'Via consortiumofnlus.ac.in, once a year.',
      previousYearCutoffs:
          'Sample: top NLUs like NLSIU/NALSAR need a rank within the first few hundred.',
      preparationTips: [
        'Read editorials daily to build reading speed and current affairs knowledge',
        'Practice passage-based legal reasoning questions extensively',
        'Time management is critical — the paper rewards quick, accurate reading',
      ],
      bestBooks: [
        'Universal\'s CLAT Guide',
        'Legal Reasoning by AP Bhardwaj',
        'Word Power Made Easy (vocabulary)',
      ],
      timeline: 'Registration: Jul–Nov • Exam: Dec • Result: Dec/Jan',
    ),
    StreamExam(
      id: 'upsc_cse',
      name: 'UPSC CSE',
      fullName: 'UPSC Civil Services Examination',
      description:
          'India\'s most prestigious exam for recruitment to IAS, IPS, IFS, '
          'and other central civil services — attempted after graduation, '
          'but the groundwork often starts in school.',
      eligibility:
          'Graduation in any discipline; age 21–32 (relaxations apply).',
      syllabusHighlights: [
        'Prelims: General Studies + CSAT',
        'Mains: 9 papers including Essay, GS I–IV, optional subject, languages',
        'Interview: Personality Test',
      ],
      difficulty: 'Very High',
      registration: 'Via upsc.gov.in, once a year.',
      previousYearCutoffs:
          'Sample: Prelims cutoff ~90–100/200 for General category (varies yearly).',
      preparationTips: [
        'Start with NCERT Class 6–12 for foundational knowledge',
        'Read a national newspaper daily and maintain notes',
        'Choose an optional subject aligned with your academic background',
        'Practice answer writing for Mains from early in the preparation',
      ],
      bestBooks: [
        'NCERT Class 6–12 (History, Geography, Polity, Economy)',
        'Laxmikanth — Indian Polity',
        'Spectrum — Modern Indian History',
      ],
      timeline:
          'Notification: Feb • Prelims: Jun • Mains: Sep • Interview: Mar–Apr next year',
    ),
    StreamExam(
      id: 'nid_dat',
      name: 'NID DAT',
      fullName: 'National Institute of Design – Design Aptitude Test',
      description:
          'Entrance exam for undergraduate and postgraduate design programmes at NID campuses.',
      eligibility: 'Class 12 (any stream) for B.Des; graduation for M.Des.',
      syllabusHighlights: [
        'Prelims: Drawing, visual perception, creative thinking, general knowledge',
        'Mains: Studio test, situation test, interview',
      ],
      difficulty: 'Moderate to High',
      registration: 'Via admissions.nid.edu.',
      previousYearCutoffs:
          'Sample: shortlisting ratio is roughly 1 in 10 applicants for Mains.',
      preparationTips: [
        'Build a strong sketching and observation practice',
        'Stay updated on design trends and everyday product design',
        'Practice previous years\' Prelims papers for the aptitude pattern',
      ],
      bestBooks: [
        'NID/NIFT/UCEED entrance guide by Bloomsbury or Arihant',
        'Logo Design Love (for visual thinking)',
      ],
      timeline: 'Registration: Oct–Dec • Prelims: Jan • Mains: Apr–May',
    ),
    StreamExam(
      id: 'nift_entrance',
      name: 'NIFT Entrance Exam',
      fullName: 'National Institute of Fashion Technology Entrance Exam',
      description:
          'Entrance exam for fashion design, textile design, and fashion management programmes.',
      eligibility: 'Class 12 (any stream).',
      syllabusHighlights: [
        'General Ability Test (English, quantitative, communication, GK)',
        'Creative Ability Test (for design programmes)',
        'Situation Test & Interview (for shortlisted candidates)',
      ],
      difficulty: 'Moderate',
      registration: 'Via nift.ac.in.',
      previousYearCutoffs: 'Sample: varies by campus and programme.',
      preparationTips: [
        'Practice sketching people, garments, and everyday objects',
        'Stay current with fashion trends and pop culture',
        'Work on GK and quantitative sections alongside creative prep',
      ],
      bestBooks: [
        'NIFT/NID entrance guide by Arihant',
        'Fashion illustration practice books'
      ],
      timeline: 'Registration: Nov–Jan • Exam: Feb • Result: Mar/Apr',
    ),
  ];

  static StreamExam? byId(String id) {
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }
}

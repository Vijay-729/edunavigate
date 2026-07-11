import 'package:flutter/material.dart';

import '../../models/stream_career.dart';

/// Humanities career options. Fees/salary figures are realistic *sample*
/// ranges — shown in the UI with a note to verify current numbers.
const List<StreamCareer> humanitiesCareers = [
  StreamCareer(
    id: 'civil_services',
    streamCode: 'humanities',
    name: 'Civil Services (IAS/IPS/IFS)',
    icon: Icons.account_balance_rounded,
    overview:
        'Shapes national policy and administration as an officer of the IAS, IPS, IFS, or allied central services.',
    eligibility:
        'Graduation in any discipline, then UPSC Civil Services Examination.',
    requiredSkills: [
      'General Studies',
      'Essay & Answer Writing',
      'Current Affairs',
      'Leadership',
      'Ethics & Integrity'
    ],
    entranceExamIds: ['upsc_cse'],
    bestColleges: [
      'Any graduation college (any discipline accepted)',
      'Delhi University (popular feeder for UPSC prep)'
    ],
    courseDuration: '3 years (graduation) + 1–3 years UPSC preparation',
    expectedFees: '₹50k–₹5L total for coaching/self-study (sample range)',
    scholarships:
        'State government UPSC coaching scholarships for reserved categories',
    averageSalary:
        '₹56,100–₹2,50,000/month (7th Pay Commission scale) + govt perks',
    highestSalary:
        'Cabinet Secretary-level pay scale (top of the civil services hierarchy)',
    futureScope:
        'Prestigious, stable career with structured promotions and significant influence on public policy.',
    topRecruiters: ['Government of India', 'State Governments'],
    workLifeBalance:
        'Demanding — high responsibility, especially in field postings',
    govtPrivateOpportunities: 'Exclusively government',
    higherStudyOptions: [
      'Mid-career sabbaticals for higher studies',
      'Executive programmes at LBSNAA'
    ],
  ),
  StreamCareer(
    id: 'lawyer',
    streamCode: 'humanities',
    name: 'Advocate / Lawyer',
    icon: Icons.gavel_rounded,
    overview:
        'Represents clients, argues cases, and advises on legal matters across criminal, civil, or corporate law.',
    eligibility:
        'Class 12 (any stream) → CLAT/AILET for a 5-year integrated law degree.',
    requiredSkills: [
      'Legal Research',
      'Argumentation',
      'Writing',
      'Negotiation',
      'Ethics'
    ],
    entranceExamIds: ['clat'],
    bestColleges: [
      'NLSIU Bangalore',
      'NALSAR Hyderabad',
      'National Law University Delhi'
    ],
    courseDuration: '5 years (BA LLB integrated)',
    expectedFees: '₹5L–₹18L total (sample range)',
    scholarships:
        'NLU merit and need-based scholarships, state government scholarships',
    averageSalary: '₹6L–₹15L/year (top law firm associates)',
    highestSalary: '₹50L+/year (senior litigators, corporate law partners)',
    futureScope:
        'Corporate law and litigation remain strong; growing demand in cyber law and IP law.',
    topRecruiters: [
      'AZB & Partners',
      'Cyril Amarchand Mangaldas',
      'Trilegal',
      'Corporate legal teams'
    ],
    workLifeBalance:
        'Demanding — corporate law firms especially involve long hours',
    govtPrivateOpportunities:
        'Strong private sector (firms, in-house); government via judicial services exams',
    higherStudyOptions: [
      'LLM (India or abroad)',
      'Judicial services exam',
      'Corporate law specialization'
    ],
  ),
  StreamCareer(
    id: 'journalist',
    streamCode: 'humanities',
    name: 'Journalist / News Reporter',
    icon: Icons.newspaper_rounded,
    overview:
        'Investigates, writes, and reports news across print, TV, digital, and podcast media.',
    eligibility:
        'B.A. Journalism & Mass Communication, or any degree + strong writing portfolio.',
    requiredSkills: [
      'Writing & Editing',
      'Research',
      'Interviewing',
      'Fact-Checking',
      'Multimedia Storytelling'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Indian Institute of Mass Communication (IIMC)',
      'Symbiosis Institute of Media',
      'Xavier Institute of Communications'
    ],
    courseDuration: '3 years (BA) + optional 1-year PG diploma',
    expectedFees: '₹1L–₹10L total (sample range)',
    scholarships:
        'Institute merit scholarships, media house internship stipends',
    averageSalary: '₹3L–₹7L/year',
    highestSalary:
        '₹30L+/year (senior editors, anchors, established columnists)',
    futureScope:
        'Traditional media is shrinking, but digital journalism, newsletters, and independent media are growing.',
    topRecruiters: ['NDTV', 'The Hindu', 'Indian Express', 'Digital newsrooms'],
    workLifeBalance:
        'Demanding — irregular hours, especially in breaking news roles',
    govtPrivateOpportunities:
        'Mostly private; Doordarshan/All India Radio offer government options',
    higherStudyOptions: [
      'M.A. Journalism/Mass Communication',
      'Specialized data/investigative journalism courses'
    ],
  ),
  StreamCareer(
    id: 'psychologist_counsellor',
    streamCode: 'humanities',
    name: 'Psychologist / Counsellor',
    icon: Icons.favorite_rounded,
    overview:
        'Helps individuals manage mental health, relationships, and life decisions through counselling and therapy.',
    eligibility:
        'B.A. Psychology → M.A. → M.Phil (for RCI registration to practice clinically).',
    requiredSkills: [
      'Active Listening',
      'Empathy',
      'Counselling Techniques',
      'Research',
      'Report Writing'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi University',
      'Tata Institute of Social Sciences (TISS)',
      'Christ University Bangalore'
    ],
    courseDuration: '3 (BA) + 2 (MA) + 2 (M.Phil) years',
    expectedFees: '₹1L–₹8L total across degrees (sample range)',
    scholarships:
        'UGC fellowships for postgraduate research, institute merit scholarships',
    averageSalary: '₹4L–₹8L/year',
    highestSalary: '₹20L+/year (established private practice)',
    futureScope:
        'Rapid growth as mental health awareness increases in India\'s schools, workplaces, and society.',
    topRecruiters: [
      'Schools',
      'Corporate wellness programmes',
      'NGOs',
      'Private practice/teletherapy platforms'
    ],
    workLifeBalance:
        'Good — mostly consultation-based, can be emotionally demanding',
    govtPrivateOpportunities:
        'Government schools/hospitals hire counsellors; large private wellness industry demand',
    higherStudyOptions: [
      'Ph.D. in Psychology',
      'Specialized therapy certifications (CBT, family therapy)'
    ],
  ),
  StreamCareer(
    id: 'historian_archaeologist',
    streamCode: 'humanities',
    name: 'Historian / Archaeologist',
    icon: Icons.museum_rounded,
    overview:
        'Researches and preserves historical records, artifacts, and heritage sites.',
    eligibility:
        'B.A. History/Archaeology, then M.A. and often a Ph.D. for research roles.',
    requiredSkills: [
      'Historical Research',
      'Academic Writing',
      'Field Excavation Techniques',
      'Critical Analysis',
      'Documentation'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi University',
      'Jawaharlal Nehru University (JNU)',
      'Deccan College Pune'
    ],
    courseDuration: '3 (BA) + 2 (MA) + optional Ph.D.',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships:
        'UGC-NET/JRF fellowships, ASI (Archaeological Survey of India) training stipends',
    averageSalary: '₹3.5L–₹7L/year (museum/ASI roles); academia varies',
    highestSalary: '₹15L+/year (senior professors, ASI directors)',
    futureScope:
        'Niche but stable field — steady demand from heritage conservation, museums, and academia.',
    topRecruiters: [
      'Archaeological Survey of India (ASI)',
      'Museums',
      'Universities',
      'UNESCO heritage projects'
    ],
    workLifeBalance: 'Good — mix of fieldwork and academic/office research',
    govtPrivateOpportunities:
        'Predominantly government (ASI, state archaeology departments) and academia',
    higherStudyOptions: [
      'Ph.D. in History/Archaeology',
      'International heritage conservation programmes'
    ],
  ),
  StreamCareer(
    id: 'political_scientist',
    streamCode: 'humanities',
    name: 'Political Scientist / Policy Analyst',
    icon: Icons.how_to_vote_rounded,
    overview:
        'Studies political systems, governance, and public policy to advise governments, think tanks, or media.',
    eligibility: 'B.A. Political Science, then M.A. for research/policy roles.',
    requiredSkills: [
      'Political Theory',
      'Research & Analysis',
      'Writing',
      'Public Policy Frameworks',
      'Data Interpretation'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'St. Stephen\'s College Delhi',
      'Jawaharlal Nehru University (JNU)',
      'Presidency University Kolkata'
    ],
    courseDuration: '3 (BA) + 2 (MA) years',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'UGC fellowships, institute merit scholarships',
    averageSalary: '₹4L–₹8L/year',
    highestSalary:
        '₹25L+/year (senior policy consultants, think tank directors)',
    futureScope:
        'Growing demand in policy think tanks, political consulting, and international relations bodies.',
    topRecruiters: [
      'NITI Aayog',
      'Think tanks (ORF, CPR)',
      'Political consulting firms',
      'International organizations'
    ],
    workLifeBalance: 'Good — mostly research and office-based work',
    govtPrivateOpportunities:
        'Strong government/policy roles alongside growing private political consulting sector',
    higherStudyOptions: [
      'M.A./Ph.D. Political Science',
      'Public Policy programmes (e.g. LKY School, TISS)'
    ],
  ),
  StreamCareer(
    id: 'social_worker',
    streamCode: 'humanities',
    name: 'Social Worker',
    icon: Icons.volunteer_activism_rounded,
    overview:
        'Works with communities and individuals to address social issues — poverty, education, health, and welfare.',
    eligibility: 'B.A. Social Work (BSW), then M.A. (MSW) for senior roles.',
    requiredSkills: [
      'Community Engagement',
      'Empathy',
      'Project Management',
      'Communication',
      'Crisis Intervention'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Tata Institute of Social Sciences (TISS)',
      'Delhi University',
      'Christ University Bangalore'
    ],
    courseDuration: '3 (BSW) + 2 (MSW) years',
    expectedFees: '₹50k–₹6L total (sample range)',
    scholarships: 'TISS need-based scholarships, NGO-sponsored fellowships',
    averageSalary: '₹3L–₹6L/year',
    highestSalary:
        '₹18L+/year (senior NGO directors, UN/international agency roles)',
    futureScope:
        'Steady demand from NGOs, CSR programmes, and government welfare schemes.',
    topRecruiters: [
      'UNICEF',
      'Save the Children',
      'CSR foundations',
      'Government welfare departments'
    ],
    workLifeBalance:
        'Moderate — fieldwork can be demanding but generally regular hours',
    govtPrivateOpportunities:
        'Strong government welfare-scheme roles alongside large NGO/CSR sector',
    higherStudyOptions: [
      'M.A. Social Work (MSW)',
      'Public Health/Policy postgraduate programmes'
    ],
  ),
  StreamCareer(
    id: 'teacher_professor',
    streamCode: 'humanities',
    name: 'Teacher / Professor',
    icon: Icons.school_rounded,
    overview:
        'Educates students at school or university level, shaping the next generation across subjects.',
    eligibility:
        'B.A. + B.Ed for school teaching; M.A. + NET/Ph.D. for college/university teaching.',
    requiredSkills: [
      'Subject Expertise',
      'Communication',
      'Patience',
      'Classroom Management',
      'Curriculum Design'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi University',
      'Jamia Millia Islamia',
      'Regional Institutes of Education (NCERT)'
    ],
    courseDuration:
        '3 (BA) + 2 (B.Ed) years for school; + M.A./Ph.D. for higher education',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships:
        'Government B.Ed scholarships, UGC-NET/JRF fellowships for academia',
    averageSalary:
        '₹3L–₹7L/year (school); ₹6L–₹12L/year (assistant professors)',
    highestSalary:
        '₹20L+/year (senior professors, principals of premier institutions)',
    futureScope:
        'Stable, essential profession with consistent demand across government and private education.',
    topRecruiters: [
      'Government & private schools',
      'Universities',
      'EdTech companies (content/teaching roles)'
    ],
    workLifeBalance: 'Good — structured hours with academic-year breaks',
    govtPrivateOpportunities:
        'Strong government teaching posts (via TET/state exams) alongside large private school sector',
    higherStudyOptions: [
      'M.A./M.Ed.',
      'Ph.D. + UGC-NET for university faculty positions'
    ],
  ),
  StreamCareer(
    id: 'fashion_designer',
    streamCode: 'humanities',
    name: 'Fashion Designer',
    icon: Icons.checkroom_rounded,
    overview:
        'Designs clothing and accessories, blending creativity with an understanding of fabric, fit, and trends.',
    eligibility:
        'Class 12 (any stream), then B.Des in Fashion Design via NIFT entrance.',
    requiredSkills: [
      'Sketching',
      'Fabric & Textile Knowledge',
      'Trend Forecasting',
      'Pattern Making',
      'Creativity'
    ],
    entranceExamIds: ['nift_entrance'],
    bestColleges: [
      'National Institute of Fashion Technology (NIFT)',
      'Pearl Academy',
      'National Institute of Design (NID)'
    ],
    courseDuration: '4 years (B.Des)',
    expectedFees: '₹2L–₹15L total (sample range)',
    scholarships: 'NIFT need-based and merit scholarships',
    averageSalary: '₹3L–₹8L/year',
    highestSalary: '₹40L+/year (established designers, own label owners)',
    futureScope:
        'Growing fashion and e-commerce industry, plus rising demand for sustainable fashion design.',
    topRecruiters: [
      'Fashion houses',
      'E-commerce fashion brands',
      'Own label/independent practice'
    ],
    workLifeBalance:
        'Moderate to demanding — collection deadlines and fashion weeks mean crunch periods',
    govtPrivateOpportunities: 'Almost entirely private/independent practice',
    higherStudyOptions: [
      'M.Des Fashion Design',
      'International fashion design programmes (e.g. Parsons, Central Saint Martins)'
    ],
  ),
  StreamCareer(
    id: 'interior_product_designer',
    streamCode: 'humanities',
    name: 'Interior / Product Designer',
    icon: Icons.chair_rounded,
    isEmerging: true,
    overview:
        'Designs functional and aesthetic spaces or everyday products, blending creativity with usability.',
    eligibility:
        'Class 12 (any stream), then B.Des via NID DAT or similar design entrance.',
    requiredSkills: [
      'Spatial/Product Design',
      'Sketching & CAD',
      'Material Knowledge',
      'User-Centered Design',
      'Creativity'
    ],
    entranceExamIds: ['nid_dat', 'nift_entrance'],
    bestColleges: [
      'National Institute of Design (NID)',
      'CEPT University',
      'Srishti Manipal Institute'
    ],
    courseDuration: '4 years (B.Des)',
    expectedFees: '₹2L–₹15L total (sample range)',
    scholarships: 'NID need-based and merit scholarships',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹35L+/year (senior/lead designers, design studio founders)',
    futureScope:
        'Growing demand from real estate, D2C product companies, and the broader design economy.',
    topRecruiters: [
      'Design studios',
      'Real estate/interior firms',
      'D2C product companies'
    ],
    workLifeBalance: 'Moderate — project-based deadlines',
    govtPrivateOpportunities: 'Almost entirely private/independent practice',
    higherStudyOptions: [
      'M.Des specialization',
      'International design programmes'
    ],
  ),
  StreamCareer(
    id: 'foreign_service_officer',
    streamCode: 'humanities',
    name: 'Foreign Service Officer (IFS)',
    icon: Icons.public_rounded,
    overview:
        'Represents India\'s diplomatic and foreign policy interests abroad as an Indian Foreign Service officer.',
    eligibility:
        'Graduation in any discipline, then UPSC Civil Services Examination (IFS cadre).',
    requiredSkills: [
      'International Relations Knowledge',
      'Diplomacy',
      'Languages',
      'Negotiation',
      'Cultural Sensitivity'
    ],
    entranceExamIds: ['upsc_cse'],
    bestColleges: [
      'Any graduation college',
      'Jawaharlal Nehru University (strong IR/political science programmes)'
    ],
    courseDuration: '3 years (graduation) + 1–3 years UPSC preparation',
    expectedFees: '₹50k–₹5L total for coaching/self-study (sample range)',
    scholarships:
        'State government UPSC coaching scholarships for reserved categories',
    averageSalary:
        '₹56,100–₹2,50,000/month (7th Pay Commission scale) + diplomatic perks',
    highestSalary:
        'Foreign Secretary-level pay scale (top of the IFS hierarchy)',
    futureScope:
        'Prestigious, stable career with postings across Indian embassies and international organizations.',
    topRecruiters: ['Ministry of External Affairs, Government of India'],
    workLifeBalance:
        'Moderate to demanding — frequent international relocations',
    govtPrivateOpportunities: 'Exclusively government',
    higherStudyOptions: [
      'Foreign Service Institute training',
      'International relations postgraduate study'
    ],
  ),
  StreamCareer(
    id: 'content_writer',
    streamCode: 'humanities',
    name: 'Content Writer / Copywriter',
    icon: Icons.edit_note_rounded,
    isEmerging: true,
    overview:
        'Writes content for websites, brands, marketing campaigns, and publications across digital and print media.',
    eligibility:
        'Any graduation (English/Journalism preferred) + strong writing portfolio.',
    requiredSkills: [
      'Writing & Editing',
      'SEO Basics',
      'Research',
      'Creativity',
      'Adaptability across tones/formats'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Any graduation with strong English/Literature foundation',
      'IIMC (for journalism-adjacent content roles)'
    ],
    courseDuration: '3 years (graduation)',
    expectedFees: '₹50k–₹6L total (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹3L–₹6L/year',
    highestSalary:
        '₹20L+/year (senior content strategists, creative directors)',
    futureScope:
        'Strong demand from content marketing, D2C brands, and the creator economy.',
    topRecruiters: [
      'Content marketing agencies',
      'D2C brands',
      'Media & publishing houses'
    ],
    workLifeBalance:
        'Good — mostly regular hours, freelancing offers flexibility',
    govtPrivateOpportunities: 'Almost entirely private sector',
    higherStudyOptions: [
      'M.A. in English/Journalism',
      'Specialized copywriting/UX writing courses'
    ],
  ),
  StreamCareer(
    id: 'pr_specialist',
    streamCode: 'humanities',
    name: 'Public Relations Specialist',
    icon: Icons.record_voice_over_rounded,
    overview:
        'Manages public image and communication strategy for brands, celebrities, or organizations.',
    eligibility:
        'Any graduation (Mass Communication preferred) + PR/communications training.',
    requiredSkills: [
      'Media Relations',
      'Crisis Communication',
      'Writing',
      'Networking',
      'Strategic Thinking'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Indian Institute of Mass Communication (IIMC)',
      'MICA Ahmedabad',
      'Xavier Institute of Communications'
    ],
    courseDuration: '3 years (BA) + optional 1-year PG diploma',
    expectedFees: '₹1L–₹10L total (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹4L–₹8L/year',
    highestSalary: '₹30L+/year (senior PR heads, agency partners)',
    futureScope:
        'Steady demand as brands and public figures increasingly invest in reputation management.',
    topRecruiters: [
      'PR agencies (Edelman, Weber Shandwick)',
      'Corporate communications teams'
    ],
    workLifeBalance:
        'Moderate — crisis situations can require urgent availability',
    govtPrivateOpportunities:
        'Mostly private; government press/information officer roles exist',
    higherStudyOptions: [
      'M.A. Mass Communication',
      'Specialized crisis communication certifications'
    ],
  ),
  StreamCareer(
    id: 'sociologist',
    streamCode: 'humanities',
    name: 'Sociologist / Researcher',
    icon: Icons.diversity_3_rounded,
    overview:
        'Studies human society, social behavior, and cultural patterns to inform research, policy, or academia.',
    eligibility:
        'B.A. Sociology, then M.A. and often Ph.D. for research/academic roles.',
    requiredSkills: [
      'Research Methodology',
      'Data Analysis (qualitative & quantitative)',
      'Academic Writing',
      'Fieldwork',
      'Critical Thinking'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi School of Economics',
      'Jawaharlal Nehru University (JNU)',
      'Tata Institute of Social Sciences (TISS)'
    ],
    courseDuration: '3 (BA) + 2 (MA) + optional Ph.D.',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'UGC-NET/JRF fellowships, institute merit scholarships',
    averageSalary: '₹3.5L–₹7L/year',
    highestSalary: '₹20L+/year (senior researchers, professors)',
    futureScope:
        'Steady demand from research organizations, policy think tanks, and academia.',
    topRecruiters: [
      'Research institutes',
      'NGOs',
      'Universities',
      'Policy think tanks'
    ],
    workLifeBalance: 'Good — mostly research and fieldwork based',
    govtPrivateOpportunities:
        'Government research bodies and academia; growing private social-research consultancies',
    higherStudyOptions: [
      'Ph.D. in Sociology',
      'Public Policy/Development Studies programmes'
    ],
  ),
  StreamCareer(
    id: 'filmmaker',
    streamCode: 'humanities',
    name: 'Filmmaker / Director',
    icon: Icons.movie_creation_rounded,
    overview:
        'Creates films, documentaries, or digital video content — from concept and script to final edit.',
    eligibility:
        'Any graduation + film school training (FTII, SRFTI) or self-taught with a strong portfolio.',
    requiredSkills: [
      'Storytelling',
      'Direction & Cinematography Basics',
      'Editing',
      'Leadership',
      'Creativity'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Film and Television Institute of India (FTII)',
      'Satyajit Ray Film and Television Institute (SRFTI)',
      'Whistling Woods International'
    ],
    courseDuration: '3 years (graduation) + 2–3 years (film school, optional)',
    expectedFees: '₹1L–₹15L total (sample range)',
    scholarships:
        'FTII/SRFTI merit scholarships, limited government cultural grants',
    averageSalary: '₹3L–₹10L/year (assistant director/early career)',
    highestSalary:
        'Highly variable — successful directors can earn significantly more per project',
    futureScope:
        'Expanding rapidly with OTT platforms creating huge demand for original content.',
    topRecruiters: [
      'OTT platforms (Netflix, Prime Video)',
      'Production houses',
      'Independent/freelance projects'
    ],
    workLifeBalance:
        'Demanding — production schedules involve long, irregular hours',
    govtPrivateOpportunities:
        'Almost entirely private/independent, with some government cultural grants (NFDC)',
    higherStudyOptions: [
      'Specialized filmmaking programmes abroad',
      'Screenwriting/editing certifications'
    ],
  ),
];

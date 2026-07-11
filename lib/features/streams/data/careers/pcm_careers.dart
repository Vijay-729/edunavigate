import 'package:flutter/material.dart';

import '../../models/stream_career.dart';

/// PCM career options. Fees/salary figures are realistic *sample* ranges —
/// shown in the UI with a note to verify current numbers.
const List<StreamCareer> pcmCareers = [
  StreamCareer(
    id: 'software_engineer',
    streamCode: 'pcm',
    name: 'Software Engineer',
    icon: Icons.code_rounded,
    overview:
        'Designs, builds, and maintains software applications and systems '
        'across web, mobile, cloud, and embedded platforms.',
    eligibility:
        'B.Tech/B.E. in CS, IT, or ECE (or self-taught + strong portfolio).',
    requiredSkills: [
      'Data Structures & Algorithms',
      'Programming (Python/Java/C++)',
      'System Design',
      'Git & Testing',
      'Problem Solving'
    ],
    entranceExamIds: [
      'jee_main',
      'jee_advanced',
      'bitsat',
      'viteee',
      'srmjeee'
    ],
    bestColleges: [
      'IITs',
      'NITs',
      'BITS Pilani',
      'IIIT Hyderabad',
      'VIT Vellore'
    ],
    courseDuration: '4 years (B.Tech)',
    expectedFees: '₹2L–₹18L total (govt vs private, sample range)',
    scholarships:
        'Merit-cum-means, JEE-rank based fee waivers at NITs/IIITs, private scholarships',
    averageSalary: '₹6L–₹15L/year',
    highestSalary: '₹40L+/year (product companies, top performers)',
    futureScope:
        'Consistently high demand across startups, product, and service companies; strong remote/global opportunities.',
    topRecruiters: [
      'Google',
      'Microsoft',
      'Amazon',
      'Flipkart',
      'Infosys',
      'TCS'
    ],
    workLifeBalance:
        'Moderate — deadline-driven sprints, generally better than core engineering shifts',
    govtPrivateOpportunities:
        'Private sector dominant; government roles via PSU IT wings and GATE-based PSU recruitment',
    higherStudyOptions: [
      'M.Tech / MS in CS (India or abroad)',
      'MBA for tech leadership',
      'Specialized certifications (Cloud, AI/ML)'
    ],
  ),
  StreamCareer(
    id: 'ai_ml_engineer',
    streamCode: 'pcm',
    name: 'AI / ML Engineer',
    icon: Icons.psychology_rounded,
    isEmerging: true,
    overview:
        'Builds intelligent systems — from recommendation engines to generative AI models — that learn from data.',
    eligibility:
        'B.Tech CS/IT/ECE, often followed by an M.Tech/M.S. specialization in AI-ML.',
    requiredSkills: [
      'Python',
      'TensorFlow/PyTorch',
      'Statistics & Linear Algebra',
      'MLOps',
      'Data Engineering'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat'],
    bestColleges: [
      'IIT Madras/Bombay/Delhi (AI programmes)',
      'IIIT Hyderabad',
      'IISc Bangalore (postgrad)'
    ],
    courseDuration: '4 years (B.Tech) + optional 2-year M.Tech/MS',
    expectedFees: '₹2L–₹20L total across degrees (sample range)',
    scholarships:
        'Institute merit scholarships, GATE stipend for M.Tech, research assistantships',
    averageSalary: '₹10L–₹20L/year',
    highestSalary: '₹60L+/year (research labs, global tech firms)',
    futureScope:
        'One of the fastest-growing fields globally; demand expected to keep rising with generative AI adoption.',
    topRecruiters: [
      'Google DeepMind',
      'Microsoft',
      'NVIDIA',
      'OpenAI',
      'Indian startups (Ola, Jio)'
    ],
    workLifeBalance:
        'Moderate — research-heavy roles can involve long experimentation cycles',
    govtPrivateOpportunities:
        'Mostly private/research; government via DRDO, ISRO AI initiatives, and academia',
    higherStudyOptions: [
      'M.S./Ph.D. in AI/ML abroad',
      'M.Tech at IITs/IISc',
      'Research fellowships'
    ],
  ),
  StreamCareer(
    id: 'data_scientist',
    streamCode: 'pcm',
    name: 'Data Scientist',
    icon: Icons.bar_chart_rounded,
    isEmerging: true,
    overview:
        'Analyses large datasets to extract insights and build predictive models that guide business decisions.',
    eligibility: 'B.Tech, B.Sc. Statistics/Maths, or any quantitative degree.',
    requiredSkills: [
      'Python/R',
      'SQL',
      'Statistics',
      'Data Visualization',
      'Machine Learning'
    ],
    entranceExamIds: ['jee_main', 'cuet'],
    bestColleges: [
      'IITs',
      'ISI Kolkata',
      'CMI Chennai',
      'Delhi University (Statistics)'
    ],
    courseDuration: '3–4 years (B.Sc./B.Tech)',
    expectedFees: '₹1L–₹15L total (sample range)',
    scholarships:
        'Merit scholarships, INSPIRE scholarship for science students',
    averageSalary: '₹8L–₹16L/year',
    highestSalary: '₹35L+/year',
    futureScope:
        'Strong and growing demand across e-commerce, fintech, and healthcare analytics.',
    topRecruiters: ['Amazon', 'Flipkart', 'Paytm', 'Zomato', 'Mu Sigma'],
    workLifeBalance: 'Good to moderate — project-based deadlines',
    govtPrivateOpportunities:
        'Primarily private; growing government demand in public policy analytics',
    higherStudyOptions: [
      'M.Sc. Statistics/Data Science',
      'MBA Analytics',
      'Ph.D. for research roles'
    ],
  ),
  StreamCareer(
    id: 'mechanical_engineer',
    streamCode: 'pcm',
    name: 'Mechanical Engineer',
    icon: Icons.settings_rounded,
    overview:
        'Designs and builds mechanical systems across automotive, aerospace, manufacturing, and energy sectors.',
    eligibility: 'B.Tech/B.E. in Mechanical Engineering.',
    requiredSkills: [
      'CAD (AutoCAD/CATIA/SolidWorks)',
      'Thermodynamics',
      'Material Science',
      'Manufacturing Processes',
      'FEA/Simulation'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat', 'viteee'],
    bestColleges: ['IITs', 'NITs', 'BITS Pilani', 'VIT Vellore'],
    courseDuration: '4 years (B.Tech)',
    expectedFees: '₹2L–₹16L total (sample range)',
    scholarships: 'Institute merit scholarships, JEE-rank based fee waivers',
    averageSalary: '₹4.5L–₹10L/year',
    highestSalary: '₹25L+/year (core R&D, PSU senior roles)',
    futureScope:
        'Steady demand in automotive, EV, renewable energy, and manufacturing automation.',
    topRecruiters: ['ISRO', 'DRDO', 'Tata Motors', 'L&T', 'Mahindra', 'HAL'],
    workLifeBalance:
        'Moderate — plant/site roles can involve shifts; design roles are steadier',
    govtPrivateOpportunities:
        'Strong government presence via GATE-based PSU recruitment (BHEL, ONGC, ISRO)',
    higherStudyOptions: [
      'M.Tech (Thermal/Design/Manufacturing)',
      'MS abroad',
      'MBA for management roles'
    ],
  ),
  StreamCareer(
    id: 'civil_engineer',
    streamCode: 'pcm',
    name: 'Civil Engineer',
    icon: Icons.foundation_rounded,
    overview:
        'Plans, designs, and oversees construction of infrastructure — buildings, roads, bridges, and dams.',
    eligibility: 'B.Tech/B.E. in Civil Engineering.',
    requiredSkills: [
      'Structural Analysis',
      'AutoCAD/STAAD Pro',
      'Site Management',
      'Surveying',
      'Project Planning'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat'],
    bestColleges: ['IITs', 'NITs', 'College of Engineering Pune (COEP)'],
    courseDuration: '4 years (B.Tech)',
    expectedFees: '₹2L–₹14L total (sample range)',
    scholarships:
        'Institute merit scholarships, state government engineering scholarships',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹20L+/year (large infra project leads)',
    futureScope:
        'Strong long-term demand driven by India\'s infrastructure and urbanization growth.',
    topRecruiters: [
      'L&T Construction',
      'Shapoorji Pallonji',
      'DLF',
      'NHAI',
      'PWD'
    ],
    workLifeBalance:
        'Moderate to demanding — site-based roles require on-ground presence',
    govtPrivateOpportunities:
        'Strong government opportunities via GATE (PSUs) and state PWD/engineering services',
    higherStudyOptions: [
      'M.Tech (Structural/Transportation/Geotechnical)',
      'MS abroad',
      'MBA in Infrastructure Management'
    ],
  ),
  StreamCareer(
    id: 'electrical_engineer',
    streamCode: 'pcm',
    name: 'Electrical Engineer',
    icon: Icons.electrical_services_rounded,
    overview:
        'Works on power systems, electrical machines, and control systems across energy and manufacturing sectors.',
    eligibility: 'B.Tech/B.E. in Electrical Engineering.',
    requiredSkills: [
      'Circuit Design',
      'Power Systems',
      'MATLAB/Simulink',
      'Control Systems',
      'PLC Programming'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat'],
    bestColleges: ['IITs', 'NITs', 'BITS Pilani'],
    courseDuration: '4 years (B.Tech)',
    expectedFees: '₹2L–₹14L total (sample range)',
    scholarships: 'Institute merit scholarships, JEE-rank based fee waivers',
    averageSalary: '₹4.5L–₹10L/year',
    highestSalary: '₹22L+/year',
    futureScope:
        'Growing demand from renewable energy, EVs, and smart grid infrastructure.',
    topRecruiters: ['NTPC', 'Siemens', 'ABB', 'Tata Power', 'BHEL'],
    workLifeBalance: 'Moderate — plant/field roles can involve shift work',
    govtPrivateOpportunities:
        'Strong government presence via GATE (PSUs like NTPC, PGCIL)',
    higherStudyOptions: [
      'M.Tech (Power Systems/Control)',
      'MS abroad',
      'MBA for management track'
    ],
  ),
  StreamCareer(
    id: 'aerospace_engineer',
    streamCode: 'pcm',
    name: 'Aerospace Engineer',
    icon: Icons.flight_takeoff_rounded,
    overview:
        'Designs aircraft, spacecraft, satellites, and related systems for aviation and space industries.',
    eligibility: 'B.Tech in Aerospace/Aeronautical Engineering.',
    requiredSkills: [
      'Aerodynamics',
      'Propulsion Systems',
      'CAD/CFD Tools',
      'Structural Analysis',
      'Materials Science'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat'],
    bestColleges: [
      'IIT Bombay/Kanpur/Madras',
      'IIST Thiruvananthapuram',
      'Anna University'
    ],
    courseDuration: '4 years (B.Tech)',
    expectedFees: '₹2L–₹15L total (sample range)',
    scholarships:
        'Institute merit scholarships, ISRO/DRDO project stipends for top performers',
    averageSalary: '₹5L–₹12L/year',
    highestSalary: '₹25L+/year (ISRO/private space sector seniors)',
    futureScope:
        'Rapidly expanding with India\'s growing private space sector (satellites, launch vehicles).',
    topRecruiters: ['ISRO', 'HAL', 'DRDO', 'Boeing India', 'Skyroot Aerospace'],
    workLifeBalance:
        'Moderate — mission-critical phases can mean intense periods',
    govtPrivateOpportunities:
        'Strong government presence (ISRO, DRDO, HAL); growing private space startups',
    higherStudyOptions: [
      'M.Tech/MS in Aerospace',
      'Ph.D. for research roles',
      'IIST/ISRO fellowships'
    ],
  ),
  StreamCareer(
    id: 'architect',
    streamCode: 'pcm',
    name: 'Architect',
    icon: Icons.architecture_rounded,
    overview:
        'Designs buildings and spaces that balance functionality, aesthetics, and safety.',
    eligibility: 'B.Arch (5-year programme) with Mathematics in Class 12.',
    requiredSkills: [
      'Sketching & Drafting',
      'AutoCAD/Revit/SketchUp',
      'Spatial Design',
      'Building Codes',
      'Project Management'
    ],
    entranceExamIds: ['nata', 'jee_main'],
    bestColleges: [
      'School of Planning and Architecture (SPA) Delhi',
      'IIT Roorkee',
      'CEPT University'
    ],
    courseDuration: '5 years (B.Arch)',
    expectedFees: '₹3L–₹20L total (sample range)',
    scholarships: 'Institute merit scholarships, state government scholarships',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹25L+/year (established/independent practice)',
    futureScope:
        'Steady demand from real estate, urban planning, and sustainable/green building design.',
    topRecruiters: [
      'DLF',
      'HCP Design',
      'L&T Construction',
      'Government Urban Development Bodies'
    ],
    workLifeBalance: 'Moderate — project deadlines and site visits required',
    govtPrivateOpportunities:
        'Government roles via urban development authorities; strong private practice/consultancy scope',
    higherStudyOptions: [
      'M.Arch (Urban Design/Planning)',
      'M.Des',
      'MBA in Real Estate'
    ],
  ),
  StreamCareer(
    id: 'commercial_pilot',
    streamCode: 'pcm',
    name: 'Commercial Pilot',
    icon: Icons.flight_rounded,
    overview:
        'Flies commercial aircraft for airlines, requiring rigorous flight training and licensing.',
    eligibility:
        'Class 12 with PCM; Commercial Pilot License (CPL) training thereafter.',
    requiredSkills: [
      'Flight Handling',
      'Quick Decision-Making',
      'Physical Fitness',
      'Communication',
      'Stress Management'
    ],
    entranceExamIds: [],
    bestColleges: [
      'Indira Gandhi Rashtriya Uran Akademi (IGRUA)',
      'CAE Flight Academy',
      'Bombay Flying Club'
    ],
    courseDuration: '1.5–2 years (CPL training)',
    expectedFees:
        '₹35L–₹60L total (flight training is expensive — sample range)',
    scholarships:
        'Limited; some state government aviation scholarships and airline-sponsored cadet programmes',
    averageSalary: '₹8L–₹20L/year (first officer)',
    highestSalary: '₹1Cr+/year (senior captains at major airlines)',
    futureScope:
        'Growing demand as Indian aviation expands, though hiring is cyclical with airline growth.',
    topRecruiters: ['IndiGo', 'Air India', 'Vistara', 'SpiceJet'],
    workLifeBalance:
        'Irregular hours and travel-heavy, but structured duty-time regulations',
    govtPrivateOpportunities:
        'Mostly private airlines; government opportunities via Air India and Indian Air Force (different entry route)',
    higherStudyOptions: [
      'ATPL (Airline Transport Pilot License) upgrade',
      'Type ratings for specific aircraft'
    ],
  ),
  StreamCareer(
    id: 'robotics_engineer',
    streamCode: 'pcm',
    name: 'Robotics Engineer',
    icon: Icons.smart_toy_rounded,
    isEmerging: true,
    overview:
        'Designs and builds robots and automated systems for manufacturing, healthcare, and consumer applications.',
    eligibility:
        'B.Tech in Mechanical/Electronics/Robotics/Mechatronics Engineering.',
    requiredSkills: [
      'Embedded Systems',
      'ROS (Robot Operating System)',
      'Control Theory',
      'Python/C++',
      'Sensor Integration'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced', 'bitsat'],
    bestColleges: [
      'IIT Kanpur/Bombay (Robotics)',
      'IIIT Hyderabad',
      'BITS Pilani'
    ],
    courseDuration: '4 years (B.Tech) + optional specialization',
    expectedFees: '₹2L–₹16L total (sample range)',
    scholarships:
        'Institute merit scholarships, robotics competition sponsorships',
    averageSalary: '₹6L–₹14L/year',
    highestSalary: '₹30L+/year',
    futureScope:
        'Rapidly growing with automation, warehouse robotics, and healthcare robotics adoption.',
    topRecruiters: [
      'Bosch',
      'Siemens',
      'ABB Robotics',
      'Indian robotics startups'
    ],
    workLifeBalance: 'Moderate — R&D-heavy roles with project cycles',
    govtPrivateOpportunities:
        'Growing in both; DRDO robotics labs and private automation companies',
    higherStudyOptions: [
      'M.Tech/MS in Robotics or Mechatronics',
      'Ph.D. for research'
    ],
  ),
  StreamCareer(
    id: 'actuary',
    streamCode: 'pcm',
    name: 'Actuary',
    icon: Icons.calculate_outlined,
    overview:
        'Uses mathematics, statistics, and financial theory to assess risk for insurance and finance industries.',
    eligibility:
        'Any graduation (strong Maths background); qualify via Institute of Actuaries of India (IAI) exams.',
    requiredSkills: [
      'Probability & Statistics',
      'Financial Mathematics',
      'Risk Modelling',
      'Excel/Programming',
      'Analytical Thinking'
    ],
    entranceExamIds: [],
    bestColleges: [
      'Institute of Actuaries of India (professional body, not a college)',
      'St. Xavier\'s College (feeder for actuarial science)'
    ],
    courseDuration:
        '4–6 years to become a Fellow (IAI exams, alongside a day job)',
    expectedFees: '₹2L–₹5L total for exams and study material (sample range)',
    scholarships: 'Limited; some IAI exam fee concessions for students',
    averageSalary: '₹6L–₹15L/year (trainee to qualified actuary)',
    highestSalary: '₹50L+/year (senior/chief actuaries)',
    futureScope:
        'High demand with limited supply of qualified actuaries in India — strong long-term prospects.',
    topRecruiters: [
      'LIC',
      'ICICI Prudential',
      'HDFC Life',
      'Deloitte',
      'Milliman'
    ],
    workLifeBalance:
        'Good — structured corporate hours, exam study is the main time pressure',
    govtPrivateOpportunities:
        'LIC and other public insurers hire; strong private insurance/consulting demand',
    higherStudyOptions: [
      'Continue IAI Fellowship exams',
      'MSc Actuarial Science abroad'
    ],
  ),
  StreamCareer(
    id: 'cybersecurity_analyst',
    streamCode: 'pcm',
    name: 'Cybersecurity Analyst',
    icon: Icons.security_rounded,
    isEmerging: true,
    overview:
        'Protects computer systems and networks from cyber threats, breaches, and attacks.',
    eligibility:
        'B.Tech in CS/IT, or specialized cybersecurity certifications after any technical degree.',
    requiredSkills: [
      'Network Security',
      'Ethical Hacking',
      'Penetration Testing',
      'Cryptography',
      'Incident Response'
    ],
    entranceExamIds: ['jee_main', 'bitsat'],
    bestColleges: [
      'IIIT Hyderabad',
      'IIT Kanpur (interdisciplinary cybersecurity)',
      'DSCI-recognized institutes'
    ],
    courseDuration: '4 years (B.Tech) + certifications (CEH, CISSP)',
    expectedFees:
        '₹2L–₹15L total (degree) + ₹50k–₹2L for certifications (sample range)',
    scholarships:
        'Institute merit scholarships; some certification bodies offer student discounts',
    averageSalary: '₹5L–₹14L/year',
    highestSalary: '₹35L+/year (security architects, CISOs)',
    futureScope:
        'Very high growth as cyberattacks increase — one of the fastest-growing IT sub-fields.',
    topRecruiters: [
      'TCS',
      'Wipro',
      'Deloitte Cyber',
      'Indian banks',
      'Global tech firms'
    ],
    workLifeBalance:
        'Moderate — incident response can require on-call availability',
    govtPrivateOpportunities:
        'Strong government demand (CERT-In, defence cyber units) alongside private sector',
    higherStudyOptions: [
      'M.Tech in Cybersecurity',
      'Global certifications (OSCP, CISSP)',
      'MS abroad'
    ],
  ),
  StreamCareer(
    id: 'research_scientist_pcm',
    streamCode: 'pcm',
    name: 'Research Scientist (Physics/Maths)',
    icon: Icons.science_rounded,
    overview:
        'Conducts fundamental or applied research in physics, mathematics, or engineering sciences.',
    eligibility: 'B.Sc./B.Tech → M.Sc. → Ph.D. (typically 8–10 years total).',
    requiredSkills: [
      'Scientific Writing',
      'Advanced Mathematics',
      'Lab/Computational Techniques',
      'Critical Thinking',
      'Collaboration'
    ],
    entranceExamIds: ['jee_main', 'jee_advanced'],
    bestColleges: ['IISc Bangalore', 'IITs', 'TIFR Mumbai'],
    courseDuration: '5–6 years after graduation (M.Sc. + Ph.D.)',
    expectedFees:
        '₹1L–₹8L total (many research programmes offer stipends, sample range)',
    scholarships:
        'INSPIRE Fellowship, CSIR-UGC NET/JRF stipend, institute research assistantships',
    averageSalary: '₹6L–₹18L/year (academia); higher in industry R&D',
    highestSalary: '₹30L+/year (senior scientists, industry R&D heads)',
    futureScope:
        'Steady demand in space research, defence R&D, and semiconductor/materials research.',
    topRecruiters: [
      'ISRO',
      'DRDO',
      'BARC',
      'IITs/IISc (academia)',
      'Semiconductor companies'
    ],
    workLifeBalance:
        'Flexible but research-intensive — driven by project deadlines and publications',
    govtPrivateOpportunities:
        'Predominantly government/academic; growing private R&D in semiconductors and materials',
    higherStudyOptions: [
      'Postdoctoral research',
      'Faculty positions',
      'Industry R&D leadership'
    ],
  ),
];

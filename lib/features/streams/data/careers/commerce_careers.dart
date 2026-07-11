import 'package:flutter/material.dart';

import '../../models/stream_career.dart';

/// Commerce career options. Fees/salary figures are realistic *sample*
/// ranges — shown in the UI with a note to verify current numbers.
const List<StreamCareer> commerceCareers = [
  StreamCareer(
    id: 'chartered_accountant',
    streamCode: 'commerce',
    name: 'Chartered Accountant (CA)',
    icon: Icons.calculate_rounded,
    overview:
        'India\'s premier finance professional, handling audits, taxation, and financial advisory for organizations.',
    eligibility:
        'Class 12 (any stream), then CA Foundation → Intermediate → Final + 3-year articleship.',
    requiredSkills: [
      'Accounting',
      'Taxation',
      'Auditing',
      'Financial Analysis',
      'Corporate Law'
    ],
    entranceExamIds: ['ca_foundation'],
    bestColleges: [
      'ICAI (professional body — not a college)',
      'Shri Ram College of Commerce (feeder)',
      'Narsee Monjee College (feeder)'
    ],
    courseDuration: '4.5–5 years (Foundation to Final + articleship)',
    expectedFees: '₹1.5L–₹3L total for ICAI exams and coaching (sample range)',
    scholarships: 'ICAI merit scholarships, need-based fee concessions',
    averageSalary: '₹8L–₹12L/year (freshly qualified)',
    highestSalary: '₹1Cr+/year (Big 4 partners, CFOs)',
    futureScope:
        'Consistently strong demand — every company needs financial compliance and audit expertise.',
    topRecruiters: ['Deloitte', 'PwC', 'EY', 'KPMG', 'Corporate finance teams'],
    workLifeBalance:
        'Demanding during articleship and audit season; better once established',
    govtPrivateOpportunities:
        'Private sector dominant (Big 4, corporates); government roles via PSU finance departments',
    higherStudyOptions: [
      'CFA for investment finance',
      'MBA Finance',
      'International equivalents (ACCA, CPA)'
    ],
  ),
  StreamCareer(
    id: 'company_secretary',
    streamCode: 'commerce',
    name: 'Company Secretary (CS)',
    icon: Icons.description_rounded,
    overview:
        'Ensures legal and regulatory compliance for companies, and advises boards on corporate governance.',
    eligibility:
        'Class 12 (any stream), then CSEET → Executive → Professional + training.',
    requiredSkills: [
      'Corporate Law',
      'Compliance Management',
      'Corporate Governance',
      'Drafting & Documentation',
      'Communication'
    ],
    entranceExamIds: ['cseet'],
    bestColleges: ['ICSI (professional body — not a college)'],
    courseDuration: '3–4 years (CSEET to Professional + training)',
    expectedFees:
        '₹1L–₹2L total for ICSI exams and study material (sample range)',
    scholarships: 'ICSI merit scholarships and fee concessions',
    averageSalary: '₹6L–₹10L/year (freshly qualified)',
    highestSalary:
        '₹50L+/year (senior compliance officers, company secretaries at large firms)',
    futureScope:
        'Steady demand driven by increasing corporate governance and compliance requirements.',
    topRecruiters: [
      'Corporate legal/compliance departments',
      'Law firms',
      'Listed companies'
    ],
    workLifeBalance:
        'Good — mostly regular corporate hours with periodic compliance deadlines',
    govtPrivateOpportunities:
        'Mostly private corporate roles; some government PSU compliance positions',
    higherStudyOptions: [
      'LLB for dual qualification',
      'MBA',
      'Advanced corporate law certifications'
    ],
  ),
  StreamCareer(
    id: 'cost_accountant',
    streamCode: 'commerce',
    name: 'Cost & Management Accountant (CMA)',
    icon: Icons.receipt_long_rounded,
    overview:
        'Specializes in cost control, budgeting, and management accounting to improve business efficiency.',
    eligibility:
        'Class 12 (any stream), then CMA Foundation → Intermediate → Final + training.',
    requiredSkills: [
      'Cost Accounting',
      'Budgeting',
      'Financial Planning',
      'Data Analysis',
      'Strategic Management'
    ],
    entranceExamIds: ['cma_foundation'],
    bestColleges: ['ICMAI (professional body — not a college)'],
    courseDuration: '3–4 years (Foundation to Final + training)',
    expectedFees: '₹1L–₹2L total for ICMAI exams (sample range)',
    scholarships: 'ICMAI merit scholarships and fee concessions',
    averageSalary: '₹6L–₹10L/year (freshly qualified)',
    highestSalary: '₹40L+/year (senior finance controllers)',
    futureScope:
        'Strong demand in manufacturing and large enterprises for cost optimization expertise.',
    topRecruiters: [
      'Manufacturing companies',
      'PSUs',
      'Corporate finance departments'
    ],
    workLifeBalance: 'Good — mostly regular corporate hours',
    govtPrivateOpportunities:
        'Strong PSU demand alongside private manufacturing/corporate roles',
    higherStudyOptions: [
      'MBA Finance',
      'CFA',
      'Advanced cost management certifications'
    ],
  ),
  StreamCareer(
    id: 'investment_banker',
    streamCode: 'commerce',
    name: 'Investment Banker',
    icon: Icons.trending_up_rounded,
    overview:
        'Advises companies on raising capital, mergers & acquisitions, and large financial transactions.',
    eligibility:
        'B.Com/BBA + MBA Finance (top-tier B-school strongly preferred).',
    requiredSkills: [
      'Financial Modelling',
      'Valuation',
      'Excel & PowerPoint',
      'Market Analysis',
      'Negotiation'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: [
      'IIM Ahmedabad/Bangalore/Calcutta',
      'FMS Delhi',
      'XLRI Jamshedpur'
    ],
    courseDuration: '3 years (B.Com) + 2 years (MBA)',
    expectedFees: '₹5L–₹25L total across degrees (sample range)',
    scholarships: 'Institute merit scholarships, need-based MBA fee waivers',
    averageSalary: '₹15L–₹30L/year (post-MBA analyst/associate)',
    highestSalary: '₹1Cr+/year (senior bankers, managing directors)',
    futureScope:
        'High-paying but highly competitive; demand tied to capital markets and M&A activity.',
    topRecruiters: [
      'Goldman Sachs',
      'Morgan Stanley',
      'JP Morgan',
      'Kotak Investment Banking'
    ],
    workLifeBalance:
        'Demanding — long hours are the norm, especially early career',
    govtPrivateOpportunities: 'Almost entirely private sector',
    higherStudyOptions: ['CFA charter', 'Executive MBA for career switchers'],
  ),
  StreamCareer(
    id: 'financial_analyst',
    streamCode: 'commerce',
    name: 'Financial Analyst',
    icon: Icons.query_stats_rounded,
    overview:
        'Analyzes financial data to guide investment decisions, budgeting, and business strategy.',
    eligibility: 'B.Com/BBA (CFA or MBA Finance adds significant value).',
    requiredSkills: [
      'Financial Modelling',
      'Excel',
      'Accounting Standards',
      'Market Research',
      'Presentation Skills'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: [
      'Shri Ram College of Commerce',
      'Narsee Monjee College of Commerce',
      'Christ University Bangalore'
    ],
    courseDuration: '3 years (B.Com) + optional MBA/CFA',
    expectedFees: '₹1L–₹15L total (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹5L–₹10L/year',
    highestSalary: '₹30L+/year (senior analysts, portfolio managers)',
    futureScope:
        'Consistent demand across banking, corporates, and the growing fintech/analytics sector.',
    topRecruiters: [
      'ICICI Bank',
      'HDFC',
      'Deloitte',
      'Corporate finance teams'
    ],
    workLifeBalance:
        'Good to moderate — deadline-driven during reporting cycles',
    govtPrivateOpportunities:
        'Mostly private sector; some PSU bank/finance roles',
    higherStudyOptions: ['CFA', 'MBA Finance', 'FRM (Financial Risk Manager)'],
  ),
  StreamCareer(
    id: 'business_analyst',
    streamCode: 'commerce',
    name: 'Business Analyst',
    icon: Icons.analytics_rounded,
    isEmerging: true,
    overview:
        'Bridges business needs and technology solutions by analyzing processes, data, and requirements.',
    eligibility: 'B.Com/BBA (any graduation with strong analytical skills).',
    requiredSkills: [
      'Data Analysis',
      'SQL & Excel',
      'Process Mapping',
      'Stakeholder Communication',
      'Problem Solving'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: ['NMIMS Mumbai', 'Christ University', 'Symbiosis Pune'],
    courseDuration: '3 years (B.Com/BBA) + optional MBA',
    expectedFees: '₹1L–₹15L total (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹6L–₹12L/year',
    highestSalary: '₹30L+/year (senior/lead business analysts)',
    futureScope:
        'Growing demand across IT, banking, and e-commerce as businesses become more data-driven.',
    topRecruiters: [
      'Accenture',
      'Deloitte',
      'Amazon',
      'Banking & fintech firms'
    ],
    workLifeBalance: 'Good — mostly regular hours with project deadlines',
    govtPrivateOpportunities: 'Predominantly private sector',
    higherStudyOptions: [
      'MBA Business Analytics',
      'Certifications (CBAP, Six Sigma)'
    ],
  ),
  StreamCareer(
    id: 'entrepreneur_commerce',
    streamCode: 'commerce',
    name: 'Entrepreneur / Founder',
    icon: Icons.rocket_launch_rounded,
    overview:
        'Builds and runs a business, identifying market opportunities and leading a team to execute on them.',
    eligibility:
        'No fixed requirement — a commerce background helps with finance and operations understanding.',
    requiredSkills: [
      'Business Planning',
      'Financial Management',
      'Marketing',
      'Leadership',
      'Risk-Taking'
    ],
    entranceExamIds: ['ipmat', 'cuet'],
    bestColleges: [
      'Any (execution and networks matter more than pedigree)',
      'IIMs (for MBA-based founders)'
    ],
    courseDuration: 'Variable — no fixed duration',
    expectedFees: 'Variable — depends on business type and funding',
    scholarships:
        'Government schemes: Startup India, MUDRA loans, state startup grants',
    averageSalary: 'Variable — bootstrapped to unicorn-scale outcomes',
    highestSalary: 'Unlimited upside (equity-based, highly variable)',
    futureScope:
        'India\'s startup ecosystem is among the world\'s largest and continues to grow.',
    topRecruiters: [
      'Self-funded',
      'Venture Capital firms',
      'Angel investor networks'
    ],
    workLifeBalance:
        'Demanding, especially in early stages — highly variable by business',
    govtPrivateOpportunities:
        'Government support via Startup India, MSME schemes; private VC/angel funding ecosystem',
    higherStudyOptions: [
      'MBA for structured business knowledge',
      'Startup accelerator programmes (Y Combinator, Sequoia Surge)'
    ],
  ),
  StreamCareer(
    id: 'economist',
    streamCode: 'commerce',
    name: 'Economist',
    icon: Icons.insights_rounded,
    overview:
        'Studies economic trends and data to advise governments, businesses, or research institutions on policy and strategy.',
    eligibility:
        'B.A./B.Sc. Economics, often followed by a Master\'s for research/policy roles.',
    requiredSkills: [
      'Economic Theory',
      'Statistics & Econometrics',
      'Research Writing',
      'Data Modelling',
      'Policy Analysis'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi School of Economics',
      'St. Stephen\'s College',
      'Madras School of Economics'
    ],
    courseDuration: '3 years (B.A.) + 2 years (M.A. recommended)',
    expectedFees: '₹1L–₹10L total (sample range)',
    scholarships:
        'Institute merit scholarships, UGC fellowships for postgraduate research',
    averageSalary: '₹5L–₹10L/year',
    highestSalary:
        '₹30L+/year (senior policy economists, RBI/international bodies)',
    futureScope:
        'Steady demand in policy think tanks, RBI, and corporate strategy/research roles.',
    topRecruiters: [
      'RBI',
      'NITI Aayog',
      'World Bank/IMF (with advanced degrees)',
      'Corporate research teams'
    ],
    workLifeBalance: 'Good — mostly research/office-based work',
    govtPrivateOpportunities:
        'Strong government/policy roles (RBI, NITI Aayog) alongside private research and consulting',
    higherStudyOptions: [
      'M.A./Ph.D. Economics',
      'Civil Services (Indian Economic Service)',
      'MS abroad'
    ],
  ),
  StreamCareer(
    id: 'marketing_manager',
    streamCode: 'commerce',
    name: 'Marketing Manager',
    icon: Icons.campaign_rounded,
    overview:
        'Plans and executes strategies to promote products/services and build brand value.',
    eligibility: 'BBA/B.Com, ideally followed by MBA Marketing.',
    requiredSkills: [
      'Market Research',
      'Brand Strategy',
      'Digital Marketing',
      'Communication',
      'Creativity'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: [
      'IIM (Marketing specialization)',
      'MICA Ahmedabad',
      'NMIMS Mumbai'
    ],
    courseDuration: '3 years (BBA) + 2 years (MBA)',
    expectedFees: '₹2L–₹25L total across degrees (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹8L–₹15L/year (post-MBA)',
    highestSalary: '₹50L+/year (CMOs, senior brand heads)',
    futureScope:
        'Strong demand as brands invest heavily in digital and performance marketing.',
    topRecruiters: ['HUL', 'ITC', 'P&G', 'Startups', 'D2C brands'],
    workLifeBalance:
        'Moderate — campaign cycles and launches can mean crunch periods',
    govtPrivateOpportunities: 'Almost entirely private sector',
    higherStudyOptions: [
      'MBA Marketing',
      'Digital marketing certifications (Google, Meta)'
    ],
  ),
  StreamCareer(
    id: 'hr_manager',
    streamCode: 'commerce',
    name: 'HR Manager',
    icon: Icons.groups_rounded,
    overview:
        'Manages recruitment, employee relations, performance, and organizational culture within a company.',
    eligibility: 'BBA/B.Com, ideally followed by MBA HR.',
    requiredSkills: [
      'Recruitment & Talent Management',
      'Communication',
      'Conflict Resolution',
      'Labour Law Basics',
      'Empathy'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: [
      'XLRI Jamshedpur (HR specialization)',
      'TISS Mumbai',
      'IIM Ranchi'
    ],
    courseDuration: '3 years (BBA) + 2 years (MBA)',
    expectedFees: '₹2L–₹20L total across degrees (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹7L–₹14L/year (post-MBA)',
    highestSalary: '₹40L+/year (CHROs, senior HR business partners)',
    futureScope:
        'Steady demand as organizations invest more in employee experience and retention.',
    topRecruiters: [
      'TCS',
      'Deloitte',
      'Corporate HR departments',
      'Consulting firms'
    ],
    workLifeBalance:
        'Good — mostly regular hours with occasional recruitment drives',
    govtPrivateOpportunities:
        'Mostly private; some PSU HR/personnel officer roles',
    higherStudyOptions: ['MBA HR', 'SHRM/labour law certifications'],
  ),
  StreamCareer(
    id: 'stock_broker_trader',
    streamCode: 'commerce',
    name: 'Stock Broker / Trader',
    icon: Icons.candlestick_chart_rounded,
    overview:
        'Trades securities in financial markets on behalf of clients or independently.',
    eligibility: 'B.Com/BBA + NISM/NSE certifications.',
    requiredSkills: [
      'Market Analysis',
      'Risk Management',
      'Technical & Fundamental Analysis',
      'Discipline',
      'Quick Decision-Making'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Any commerce degree + NISM certifications',
      'NSE Academy programmes'
    ],
    courseDuration: '3 years (B.Com) + certification courses (a few months)',
    expectedFees:
        '₹1L–₹8L total (degree) + ₹20k–₹1L (certifications, sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary:
        '₹4L–₹10L/year (salaried roles); trading income highly variable',
    highestSalary:
        'Highly variable — successful independent traders can earn significantly more',
    futureScope:
        'Growing retail participation in Indian stock markets is expanding demand for brokers and advisors.',
    topRecruiters: [
      'Zerodha',
      'ICICI Securities',
      'Motilal Oswal',
      'Independent trading'
    ],
    workLifeBalance: 'Moderate to demanding — market hours plus research time',
    govtPrivateOpportunities: 'Almost entirely private sector',
    higherStudyOptions: ['CFA', 'NISM advanced certifications', 'MBA Finance'],
  ),
  StreamCareer(
    id: 'digital_marketer',
    streamCode: 'commerce',
    name: 'Digital Marketer',
    icon: Icons.tap_and_play_rounded,
    isEmerging: true,
    overview:
        'Plans and runs online marketing campaigns across search, social media, and content platforms.',
    eligibility:
        'Any graduation (B.Com/BBA common) + digital marketing certifications.',
    requiredSkills: [
      'SEO/SEM',
      'Social Media Strategy',
      'Content Marketing',
      'Analytics Tools',
      'Creativity'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Any graduation + Google/Meta certifications',
      'MICA Ahmedabad (for specialized PG programmes)'
    ],
    courseDuration: '3 years (graduation) + a few months of certification',
    expectedFees:
        '₹1L–₹8L total (degree) + ₹10k–₹50k (certifications, sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹25L+/year (senior digital marketing heads, growth leads)',
    futureScope:
        'Very high growth as businesses continue shifting ad spend to digital channels.',
    topRecruiters: [
      'Digital agencies',
      'D2C brands',
      'E-commerce companies',
      'Startups'
    ],
    workLifeBalance: 'Good — mostly regular hours, campaign-driven peaks',
    govtPrivateOpportunities: 'Almost entirely private sector',
    higherStudyOptions: [
      'MBA Marketing',
      'Advanced certifications (Google Ads, HubSpot, Meta Blueprint)'
    ],
  ),
  StreamCareer(
    id: 'supply_chain_manager',
    streamCode: 'commerce',
    name: 'Supply Chain Manager',
    icon: Icons.local_shipping_rounded,
    overview:
        'Manages the flow of goods from production to delivery, optimizing logistics, procurement, and inventory.',
    eligibility:
        'B.Com/BBA, ideally followed by MBA in Operations/Supply Chain.',
    requiredSkills: [
      'Logistics Planning',
      'Inventory Management',
      'Negotiation',
      'Data Analysis',
      'ERP Systems (SAP)'
    ],
    entranceExamIds: ['cuet', 'ipmat'],
    bestColleges: [
      'IIM (Operations specialization)',
      'NITIE Mumbai',
      'SCMHRD Pune'
    ],
    courseDuration: '3 years (BBA) + 2 years (MBA)',
    expectedFees: '₹2L–₹20L total across degrees (sample range)',
    scholarships: 'Institute merit scholarships',
    averageSalary: '₹7L–₹14L/year (post-MBA)',
    highestSalary: '₹40L+/year (senior supply chain heads)',
    futureScope:
        'Strong growth driven by e-commerce, quick-commerce, and manufacturing expansion in India.',
    topRecruiters: [
      'Amazon',
      'Flipkart',
      'Reliance Retail',
      'Manufacturing companies'
    ],
    workLifeBalance:
        'Moderate — can involve travel and coordination across time zones',
    govtPrivateOpportunities:
        'Mostly private; some PSU logistics/procurement roles',
    higherStudyOptions: [
      'MBA Operations/Supply Chain',
      'Certified Supply Chain Professional (CSCP)'
    ],
  ),
  StreamCareer(
    id: 'hotel_management',
    streamCode: 'commerce',
    name: 'Hotel Management (BHM)',
    icon: Icons.hotel_rounded,
    overview:
        'Manages hospitality operations — front office, food & beverage, housekeeping — across hotels and resorts.',
    eligibility:
        'Class 12 (any stream), then BHM (Bachelor of Hotel Management).',
    requiredSkills: [
      'Customer Service',
      'Operations Management',
      'Communication',
      'Multitasking',
      'Culinary/Hospitality Basics'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Institute of Hotel Management (IHM) Mumbai/Delhi',
      'Welcomgroup Graduate School of Hotel Administration'
    ],
    courseDuration: '3–4 years (BHM)',
    expectedFees: '₹1L–₹10L total (sample range)',
    scholarships:
        'State government scholarships, hotel-sponsored trainee programmes',
    averageSalary: '₹3L–₹6L/year (entry-level management trainee)',
    highestSalary: '₹30L+/year (general managers at luxury hotel chains)',
    futureScope:
        'Strong rebound and growth in India\'s tourism and hospitality sector.',
    topRecruiters: ['Taj Hotels', 'Oberoi Group', 'Marriott', 'ITC Hotels'],
    workLifeBalance:
        'Demanding — shift work and guest-facing hours are standard',
    govtPrivateOpportunities:
        'Predominantly private; some government tourism department roles',
    higherStudyOptions: [
      'MBA in Hospitality Management',
      'International hotel management postgraduate diplomas'
    ],
  ),
];

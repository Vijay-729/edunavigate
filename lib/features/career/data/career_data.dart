import 'package:flutter/material.dart';

import '../models/career_path.dart';

class CareerData {
  CareerData._();

  static const List<CareerPath> all = [
    CareerPath(
      id: 'software_engineer',
      title: 'Software Engineer',
      domain: 'Technology',
      shortDescription:
          'Design, develop and maintain software systems used by millions.',
      fullDescription:
          'Software engineers build applications, systems, and platforms across '
          'web, mobile, cloud, and embedded domains. The role demands strong '
          'problem-solving, clean code habits, and continuous learning as tech '
          'evolves rapidly.',
      keySkills: [
        'Data Structures',
        'Algorithms',
        'System Design',
        'Git',
        'Testing'
      ],
      minimumQualification: 'B.Tech / B.E. in CS, IT, or ECE',
      topExamsOrPaths:
          'JEE → NIT/IIT, GATE (for PSU/M.Tech), Coding competitions',
      salaryRange: '₹6L – ₹40L+ per year',
      topRecruiters: [
        'Google',
        'Microsoft',
        'Amazon',
        'Flipkart',
        'Infosys',
        'TCS'
      ],
      icon: Icons.code_rounded,
      accent: Color(0xFF3B82F6),
      relatedCategories: [
        'coding',
        'technology',
        'problem_solving',
        'mathematics'
      ],
    ),
    CareerPath(
      id: 'ai_ml_engineer',
      title: 'AI / ML Engineer',
      domain: 'Technology',
      shortDescription:
          'Build intelligent systems that learn from data and automate decisions.',
      fullDescription:
          'AI/ML engineers design machine learning models, train neural networks, '
          'and deploy intelligent systems. The field spans NLP, computer vision, '
          'reinforcement learning, and generative AI.',
      keySkills: [
        'Python',
        'TensorFlow/PyTorch',
        'Statistics',
        'Linear Algebra',
        'MLOps'
      ],
      minimumQualification: 'B.Tech CS/IT or M.Tech/M.S. in AI-ML',
      topExamsOrPaths: 'JEE, GATE CS, M.S. abroad (GRE + TOEFL)',
      salaryRange: '₹10L – ₹60L+ per year',
      topRecruiters: [
        'Google DeepMind',
        'OpenAI',
        'Microsoft',
        'NVIDIA',
        'Ola',
        'Jio'
      ],
      icon: Icons.psychology_rounded,
      accent: Color(0xFF8B5CF6),
      relatedCategories: ['coding', 'mathematics', 'technology', 'research'],
    ),
    CareerPath(
      id: 'data_scientist',
      title: 'Data Scientist',
      domain: 'Analytics',
      shortDescription:
          'Extract actionable insights from large datasets to drive business strategy.',
      fullDescription:
          'Data scientists work with structured and unstructured data to uncover '
          'patterns, build predictive models, and present findings to stakeholders. '
          'The role blends statistics, programming, and domain knowledge.',
      keySkills: [
        'Python/R',
        'SQL',
        'Statistics',
        'Tableau/Power BI',
        'Machine Learning'
      ],
      minimumQualification:
          'B.Tech, B.Sc. Statistics, or MBA with analytics focus',
      topExamsOrPaths: 'JEE, CAT (for MBA-analytics), GRE for M.S. abroad',
      salaryRange: '₹8L – ₹35L per year',
      topRecruiters: ['Amazon', 'Walmart Labs', 'Paytm', 'Zomato', 'Mu Sigma'],
      icon: Icons.bar_chart_rounded,
      accent: Color(0xFF06B6D4),
      relatedCategories: [
        'mathematics',
        'research',
        'technology',
        'problem_solving'
      ],
    ),
    CareerPath(
      id: 'doctor',
      title: 'Doctor (MBBS / MD)',
      domain: 'Healthcare',
      shortDescription:
          'Diagnose and treat patients, one of the most respected professions in India.',
      fullDescription:
          'Medical doctors spend 5.5 years in MBBS followed by optional 3-year MD '
          'or MS specialisation. The path demands dedication, empathy, and lifelong '
          'learning. Specialists and surgeons command high respect and compensation.',
      keySkills: [
        'Biology',
        'Clinical Reasoning',
        'Patient Communication',
        'Research'
      ],
      minimumQualification: 'MBBS (5.5 years) → MD/MS optional',
      topExamsOrPaths: 'NEET UG → MBBS, NEET PG → MD/MS',
      salaryRange: '₹10L – ₹1Cr+ per year (specialists)',
      topRecruiters: [
        'AIIMS',
        'Fortis',
        'Apollo',
        'Max Healthcare',
        'Private Practice'
      ],
      icon: Icons.medical_services_rounded,
      accent: Color(0xFF22C55E),
      relatedCategories: ['science', 'medical', 'teamwork', 'communication'],
    ),
    CareerPath(
      id: 'civil_services',
      title: 'Civil Services (IAS/IPS)',
      domain: 'Government',
      shortDescription:
          'Shape national policy and governance as an IAS, IPS, or IFS officer.',
      fullDescription:
          'Civil servants are the backbone of Indian administration. The UPSC CSE '
          'selects candidates for IAS, IPS, IFS and allied services. The journey '
          'demands broad academic knowledge, analytical writing, and persistence.',
      keySkills: [
        'General Studies',
        'Essay Writing',
        'Current Affairs',
        'Leadership',
        'Ethics'
      ],
      minimumQualification: 'Any graduation (any stream)',
      topExamsOrPaths: 'UPSC CSE (Prelims → Mains → Interview)',
      salaryRange: '₹56,100 – ₹2,50,000/month + perks',
      topRecruiters: ['Government of India', 'State Governments', 'PSUs'],
      icon: Icons.account_balance_rounded,
      accent: Color(0xFFF97316),
      relatedCategories: [
        'humanities',
        'leadership',
        'communication',
        'career'
      ],
    ),
    CareerPath(
      id: 'chartered_accountant',
      title: 'Chartered Accountant (CA)',
      domain: 'Finance',
      shortDescription:
          'Elite finance professional managing audits, taxation, and corporate finance.',
      fullDescription:
          'CAs are India\'s premier finance professionals, qualifying through ICAI\'s '
          '3-stage exam (Foundation → Intermediate → Final) + 3 years of articleship. '
          'They serve corporations, government, and individual clients.',
      keySkills: [
        'Accounting',
        'Taxation',
        'Auditing',
        'Financial Analysis',
        'Law'
      ],
      minimumQualification: 'Class 12 (any stream), then CA Foundation',
      topExamsOrPaths: 'ICAI CA Foundation → Intermediate → Final',
      salaryRange: '₹7L – ₹40L per year (partners earn more)',
      topRecruiters: ['Big 4 (Deloitte, PwC, EY, KPMG)', 'Banks', 'Corporates'],
      icon: Icons.calculate_rounded,
      accent: Color(0xFFEAB308),
      relatedCategories: ['commerce', 'mathematics', 'problem_solving'],
    ),
    CareerPath(
      id: 'lawyer',
      title: 'Advocate / Lawyer',
      domain: 'Law',
      shortDescription:
          'Represent clients, argue cases, and uphold justice in courts and tribunals.',
      fullDescription:
          'Lawyers specialise in criminal, civil, corporate, or constitutional law. '
          'They may practice independently, join law firms, or work in-house at '
          'corporations. Top litigators and corporate lawyers command premium fees.',
      keySkills: [
        'Legal Research',
        'Argumentation',
        'Writing',
        'Negotiation',
        'Ethics'
      ],
      minimumQualification: 'LLB (3-year) after graduation, or BA LLB (5-year)',
      topExamsOrPaths: 'CLAT → NLU, AILET → NLU Delhi, State Bar enrollment',
      salaryRange: '₹5L – ₹50L+ per year (varies widely)',
      topRecruiters: [
        'AZB & Partners',
        'Cyril Amarchand',
        'Trilegal',
        'In-house Legal Teams'
      ],
      icon: Icons.gavel_rounded,
      accent: Color(0xFF64748B),
      relatedCategories: [
        'communication',
        'humanities',
        'leadership',
        'problem_solving'
      ],
    ),
    CareerPath(
      id: 'entrepreneur',
      title: 'Entrepreneur / Founder',
      domain: 'Business',
      shortDescription:
          'Build your own company, solve real problems, and create jobs.',
      fullDescription:
          'Entrepreneurs identify market gaps and build businesses around solutions. '
          'India\'s startup ecosystem is one of the world\'s largest. The path '
          'requires risk tolerance, resilience, and the ability to lead teams through '
          'uncertainty.',
      keySkills: [
        'Product Thinking',
        'Marketing',
        'Finance Basics',
        'Leadership',
        'Networking'
      ],
      minimumQualification:
          'No fixed requirement — knowledge and execution matter',
      topExamsOrPaths:
          'CAT → MBA, or build directly. Accelerators: Y-Combinator, Sequoia Surge',
      salaryRange: 'Variable — bootstrapped to Unicorn valuations',
      topRecruiters: [
        'Self-funded',
        'VC Firms',
        'Angel Networks',
        'Govt. Startup India'
      ],
      icon: Icons.rocket_launch_rounded,
      accent: Color(0xFFF43F5E),
      relatedCategories: [
        'entrepreneurship',
        'leadership',
        'creativity',
        'problem_solving'
      ],
    ),
    CareerPath(
      id: 'ux_designer',
      title: 'UI/UX Designer',
      domain: 'Design',
      shortDescription:
          'Design intuitive, beautiful digital experiences that users love.',
      fullDescription:
          'UX designers research user needs, create wireframes, and prototype '
          'interfaces. UI designers handle the visual layer — color, typography, '
          'components. Both roles are increasingly valued as companies compete on '
          'product experience.',
      keySkills: [
        'Figma',
        'User Research',
        'Prototyping',
        'Design Systems',
        'CSS basics'
      ],
      minimumQualification: 'B.Des or any graduation + design portfolio',
      topExamsOrPaths: 'NID DAT, NIFT, CEED (for M.Des), Online bootcamps',
      salaryRange: '₹5L – ₹30L per year',
      topRecruiters: [
        'Google',
        'Razorpay',
        'PhonePe',
        'Meesho',
        'Design Studios'
      ],
      icon: Icons.palette_rounded,
      accent: Color(0xFFEC4899),
      relatedCategories: [
        'creativity',
        'technology',
        'communication',
        'problem_solving'
      ],
    ),
    CareerPath(
      id: 'research_scientist',
      title: 'Research Scientist',
      domain: 'Research',
      shortDescription:
          'Push the frontiers of science and technology through rigorous investigation.',
      fullDescription:
          'Research scientists work in academia, government labs (ISRO, DRDO, BARC), '
          'or corporate R&D. They design experiments, publish findings, and mentor '
          'students. The path typically requires a Ph.D.',
      keySkills: [
        'Scientific Writing',
        'Statistics',
        'Lab Techniques',
        'Critical Thinking',
        'Collaboration'
      ],
      minimumQualification:
          'B.Sc. → M.Sc. → Ph.D. (5–6 years after graduation)',
      topExamsOrPaths: 'CSIR-NET/JRF, GATE, JEST, IISc/IIT Ph.D. entrance',
      salaryRange: '₹6L – ₹25L per year (academia), Higher in industry R&D',
      topRecruiters: [
        'IISc',
        'IITs',
        'ISRO',
        'DRDO',
        'BARC',
        'Biocon',
        'AstraZeneca'
      ],
      icon: Icons.science_rounded,
      accent: Color(0xFF10B981),
      relatedCategories: ['research', 'science', 'mathematics', 'technology'],
    ),
    CareerPath(
      id: 'product_manager',
      title: 'Product Manager',
      domain: 'Product',
      shortDescription:
          'Define the vision, roadmap, and success metrics for digital products.',
      fullDescription:
          'PMs are the CEO of a product — they align engineering, design, marketing, '
          'and business teams around a shared goal. The role requires strong analytical '
          'thinking, empathy for users, and excellent communication.',
      keySkills: [
        'Roadmapping',
        'SQL/Analytics',
        'User Research',
        'Stakeholder Management',
        'Agile'
      ],
      minimumQualification:
          'Any graduation (CS/MBA preferred). Experience often matters more.',
      topExamsOrPaths:
          'CAT → IIM MBA, or directly via engineering + 2–3 years experience',
      salaryRange: '₹15L – ₹60L per year',
      topRecruiters: ['Google', 'Amazon', 'Uber', 'CRED', 'Swiggy', 'Razorpay'],
      icon: Icons.dashboard_rounded,
      accent: Color(0xFF3B82F6),
      relatedCategories: [
        'leadership',
        'teamwork',
        'problem_solving',
        'communication'
      ],
    ),
    CareerPath(
      id: 'content_creator',
      title: 'Content Creator / Journalist',
      domain: 'Media',
      shortDescription:
          'Tell compelling stories through writing, video, audio, or social media.',
      fullDescription:
          'Content creators range from digital influencers to print journalists to '
          'documentary filmmakers. The field rewards creativity, strong voice, and '
          'consistency. Digital journalism and YouTube/podcast monetization have '
          'democratised the space.',
      keySkills: [
        'Writing/Script',
        'Video Editing',
        'SEO',
        'Social Media',
        'Storytelling'
      ],
      minimumQualification:
          'B.A. Journalism, Mass Communication, or any degree + portfolio',
      topExamsOrPaths:
          'IIMC entrance, FTII, Symbiosis MCom, Content internships',
      salaryRange: '₹3L – ₹50L+ per year (creators can earn exponentially)',
      topRecruiters: [
        'NDTV',
        'The Hindu',
        'YouTube monetisation',
        'Brand deals'
      ],
      icon: Icons.videocam_rounded,
      accent: Color(0xFFF97316),
      relatedCategories: ['creativity', 'communication', 'entrepreneurship'],
    ),
    CareerPath(
      id: 'mechanical_engineer',
      title: 'Mechanical Engineer',
      domain: 'Engineering',
      shortDescription:
          'Design and build mechanical systems — from cars and turbines to robotics.',
      fullDescription:
          'Mechanical engineers work across automotive, aerospace, manufacturing, '
          'energy, and robotics. The role involves CAD design, simulation, material '
          'selection, and production optimisation.',
      keySkills: [
        'CAD (AutoCAD/CATIA)',
        'Thermodynamics',
        'Material Science',
        'Manufacturing',
        'FEA'
      ],
      minimumQualification: 'B.Tech / B.E. in Mechanical Engineering',
      topExamsOrPaths: 'JEE → IIT/NIT, GATE (for PSU/M.Tech)',
      salaryRange: '₹4L – ₹20L per year',
      topRecruiters: ['ISRO', 'DRDO', 'Tata Motors', 'L&T', 'Mahindra', 'HAL'],
      icon: Icons.settings_rounded,
      accent: Color(0xFF64748B),
      relatedCategories: [
        'science',
        'mathematics',
        'problem_solving',
        'technology'
      ],
    ),
    CareerPath(
      id: 'psychologist',
      title: 'Psychologist / Counsellor',
      domain: 'Social Sciences',
      shortDescription:
          'Help people understand and manage their mental health and behaviour.',
      fullDescription:
          'Psychologists work in clinical settings, schools, corporates, and research. '
          'Counsellors guide individuals through life transitions, mental health '
          'challenges, and career decisions. India faces a large shortage of mental '
          'health professionals.',
      keySkills: [
        'Active Listening',
        'CBT',
        'Research',
        'Report Writing',
        'Empathy'
      ],
      minimumQualification:
          'B.Sc. / B.A. Psychology → M.Sc. → M.Phil (for RCI registration)',
      topExamsOrPaths: 'NIMHANS entrance, University M.Sc. entrances',
      salaryRange: '₹4L – ₹20L per year (private practice varies)',
      topRecruiters: [
        'NIMHANS',
        'Hospitals',
        'Schools',
        'Corporate HR',
        'NGOs'
      ],
      icon: Icons.favorite_rounded,
      accent: Color(0xFFF43F5E),
      relatedCategories: [
        'humanities',
        'communication',
        'research',
        'teamwork'
      ],
    ),
    CareerPath(
      id: 'finance_analyst',
      title: 'Finance Analyst / Investment Banker',
      domain: 'Finance',
      shortDescription:
          'Analyse investments, structure deals, and drive financial decisions for firms.',
      fullDescription:
          'Finance analysts and investment bankers work with capital markets, '
          'mergers & acquisitions, private equity, and corporate treasury. '
          'High compensation but demanding hours — especially in IB.',
      keySkills: [
        'Excel/Financial Modelling',
        'Valuation',
        'CFA',
        'Accounting',
        'Presentation'
      ],
      minimumQualification:
          'B.Com / B.Tech + MBA Finance (IIM/FMS/XLRI preferred)',
      topExamsOrPaths: 'CAT → IIM, CFA Institute exams, NSE certifications',
      salaryRange: '₹8L – ₹80L per year',
      topRecruiters: [
        'Goldman Sachs',
        'Morgan Stanley',
        'JP Morgan',
        'ICICI',
        'Kotak'
      ],
      icon: Icons.trending_up_rounded,
      accent: Color(0xFFEAB308),
      relatedCategories: [
        'commerce',
        'mathematics',
        'leadership',
        'problem_solving'
      ],
    ),
  ];
}

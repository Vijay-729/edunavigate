import 'package:flutter/material.dart';

import '../models/stream_info.dart';

class StreamsData {
  StreamsData._();

  static const StreamInfo pcm = StreamInfo(
    code: 'pcm',
    name: 'PCM',
    tagline: 'Physics, Chemistry, Mathematics',
    icon: Icons.functions_rounded,
    gradientColors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
    overview:
        'PCM (Physics, Chemistry, Mathematics) is the traditional gateway to '
        'engineering, architecture, defence, and pure sciences. It builds '
        'strong analytical and quantitative thinking through core physical '
        'sciences and mathematics, keeping the widest range of technical '
        'careers open.',
    subjects: [
      'Physics',
      'Chemistry',
      'Mathematics',
      'English',
      'Computer Science / Physical Education (optional)',
    ],
    skillsRequired: [
      'Logical & analytical thinking',
      'Comfort with numbers and formulas',
      'Problem-solving patience',
      'Spatial visualization',
      'Consistency in practice',
    ],
    whoShouldChoose: [
      'Enjoys solving numerical and logical problems',
      'Curious about how machines, structures, and natural phenomena work',
      'Comfortable with abstract mathematical concepts',
      'Interested in engineering, defence, architecture, or research',
      'Willing to put in consistent daily practice for Maths and Physics',
    ],
    pros: [
      'Opens the widest range of technical career paths (engineering, defence, architecture, research, data science)',
      'Strong foundation for competitive exams like JEE, NDA, and CUET',
      'Analytical skills transfer well to finance, consulting, and product roles later',
      'High demand across both government and private sectors',
    ],
    cons: [
      'Heavy, formula-intensive syllabus that demands consistent daily practice',
      'Highly competitive entrance exams with limited seats at top colleges',
      'Less room for creative/humanities electives',
      'Can feel repetitive for students who prefer working with people over numbers',
    ],
    futureOpportunities:
        'PCM graduates go into engineering (software, mechanical, civil, '
        'electrical, aerospace), architecture, defence services, data '
        'science, actuarial science, and pure research (physics, maths). '
        'It also keeps the door open for an MBA or civil services later.',
    salaryExpectation:
        'Entry-level: ₹3.5L–₹10L/year (varies hugely by branch and college). '
        'Mid-career engineers/specialists: ₹10L–₹40L+/year. Top-tier tech '
        'and research roles can go well beyond this.',
    growthOpportunities:
        'Strong vertical growth from engineer → senior/lead → architect/manager '
        '→ director, or a pivot into product management, entrepreneurship, or '
        'an MBA for business leadership roles.',
    personalityTraits: [
      'Analytical',
      'Detail-oriented',
      'Patient with complexity',
      'Curious',
      'Persistent',
    ],
    industriesHiring: [
      'IT & Software',
      'Core Engineering (Automotive, Aerospace, Energy)',
      'Defence & Aerospace',
      'Construction & Infrastructure',
      'Research & Academia',
      'Finance & Analytics',
    ],
    skillsToBuild: [
      'Coding',
      'Robotics',
      'Advanced Mathematics',
      'CAD/Design Tools',
      'Data Analysis'
    ],
    examIds: [
      'jee_main',
      'jee_advanced',
      'bitsat',
      'viteee',
      'srmjeee',
      'nda',
      'nata',
      'cuet'
    ],
  );

  static const StreamInfo pcb = StreamInfo(
    code: 'pcb',
    name: 'PCB',
    tagline: 'Physics, Chemistry, Biology',
    icon: Icons.biotech_outlined,
    gradientColors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
    overview:
        'PCB (Physics, Chemistry, Biology) is the foundation for medicine, '
        'life sciences, biotechnology, and allied health careers. It suits '
        'students drawn to living systems, healthcare, and research into '
        'life and the human body.',
    subjects: [
      'Physics',
      'Chemistry',
      'Biology',
      'English',
      'Psychology / Physical Education (optional)',
    ],
    skillsRequired: [
      'Strong memory for biological processes and terminology',
      'Attention to detail',
      'Patience for lab work and long study hours',
      'Empathy and communication (especially for medical careers)',
      'Scientific curiosity',
    ],
    whoShouldChoose: [
      'Fascinated by the human body, plants, animals, or ecosystems',
      'Interested in becoming a doctor, researcher, or healthcare professional',
      'Comfortable with heavy memorization alongside conceptual understanding',
      'Enjoys lab work and hands-on experiments',
      'Has patience for a long academic path (medicine especially)',
    ],
    pros: [
      'Direct path into medicine, dentistry, and allied healthcare — respected, stable careers',
      'Wide scope in biotechnology, research, and pharmaceuticals beyond just MBBS',
      'Growing demand in genomics, healthcare-tech, and life sciences research',
      'Meaningful, service-oriented career options',
    ],
    cons: [
      'NEET is extremely competitive with a very high aspirant-to-seat ratio',
      'Medical education is long (5.5+ years) and demanding',
      'Private medical/dental college fees can be very high without a good NEET rank',
      'Heavy content to memorize alongside numerical Physics and Chemistry',
    ],
    futureOpportunities:
        'PCB opens paths into MBBS, BDS, BAMS/BHMS, nursing, physiotherapy, '
        'pharmacy, biotechnology, microbiology, genetics, agriculture, and '
        'veterinary science — plus research careers in the life sciences.',
    salaryExpectation:
        'Entry-level: ₹3L–₹8L/year for allied health roles; resident doctors '
        'often start lower during training. Established doctors/specialists: '
        '₹10L–₹50L+/year, with top specialists earning significantly more.',
    growthOpportunities:
        'Doctors grow from general practice into specialization (MD/MS), '
        'then consultancy or private practice. Life-science graduates can '
        'move into research leadership, healthcare management, or biotech '
        'entrepreneurship.',
    personalityTraits: [
      'Empathetic',
      'Detail-oriented',
      'Patient',
      'Resilient under pressure',
      'Service-minded',
    ],
    industriesHiring: [
      'Hospitals & Healthcare',
      'Pharmaceuticals',
      'Biotechnology',
      'Research Institutes',
      'Agriculture & Food Science',
      'Wellness & Nutrition',
    ],
    skillsToBuild: [
      'Biology Lab Skills',
      'Scientific Research',
      'Communication',
      'Data Interpretation',
      'First Aid & Clinical Basics'
    ],
    examIds: ['neet', 'aiims', 'icar', 'cuet'],
  );

  static const StreamInfo commerce = StreamInfo(
    code: 'commerce',
    name: 'Commerce',
    tagline: 'Accountancy, Business Studies, Economics',
    icon: Icons.show_chart_rounded,
    gradientColors: [Color(0xFFF97316), Color(0xFFFB923C)],
    overview:
        'Commerce builds a foundation in business, finance, and economics — '
        'ideal for students interested in how businesses, markets, and money '
        'work. It leads to careers in finance, accounting, management, and '
        'entrepreneurship.',
    subjects: [
      'Accountancy',
      'Business Studies',
      'Economics',
      'English',
      'Mathematics / Informatics Practices (optional)',
    ],
    skillsRequired: [
      'Numerical aptitude',
      'Logical reasoning',
      'Interest in business and current affairs',
      'Organizational skills',
      'Communication for client/team interaction',
    ],
    whoShouldChoose: [
      'Interested in how businesses, markets, and the economy function',
      'Enjoys working with numbers, budgets, and financial data',
      'Wants to become a CA, CS, banker, entrepreneur, or business leader',
      'Comfortable with both quantitative and conceptual subjects',
      'Interested in starting their own business someday',
    ],
    pros: [
      'Direct, well-defined paths into CA, CS, CMA, and finance careers',
      'Strong foundation for an MBA and corporate leadership roles',
      'Highly relevant to entrepreneurship and running a business',
      'Comparatively shorter/clearer professional qualification timelines (e.g. CA)',
    ],
    cons: [
      'Professional courses like CA have a long, demanding preparation cycle',
      'Can be seen as less prestigious than PCM/PCB in some communities (unfairly)',
      'Requires strong self-discipline for self-study heavy courses like CA/CS',
      'Job market for entry-level commerce roles can be more competitive on pay',
    ],
    futureOpportunities:
        'Commerce leads to Chartered Accountancy, Company Secretary, Cost '
        'Accountancy, investment banking, business analytics, entrepreneurship, '
        'economics research, and general management via an MBA.',
    salaryExpectation:
        'Entry-level: ₹3L–₹8L/year for graduates; qualified CAs/CS often '
        'start higher (₹7L–₹12L+). Mid-career finance professionals and '
        'CAs: ₹15L–₹40L+/year, with investment banking going much higher.',
    growthOpportunities:
        'Clear vertical growth from analyst → manager → director → CFO/partner, '
        'or a pivot into entrepreneurship at any stage using the same financial '
        'and business fundamentals.',
    personalityTraits: [
      'Numerically minded',
      'Organized',
      'Business-curious',
      'Persuasive',
      'Detail-oriented',
    ],
    industriesHiring: [
      'Banking & Financial Services',
      'Consulting',
      'Big 4 Accounting Firms',
      'Corporate Finance',
      'E-commerce & Startups',
      'Stock Markets & Trading',
    ],
    skillsToBuild: [
      'Accounting',
      'Excel & Financial Modelling',
      'Finance Fundamentals',
      'Business Communication',
      'Basic Coding/Data Tools'
    ],
    examIds: [
      'cuet',
      'ca_foundation',
      'cseet',
      'cma_foundation',
      'ipmat',
      'clat'
    ],
  );

  static const StreamInfo humanities = StreamInfo(
    code: 'humanities',
    name: 'Humanities',
    tagline: 'History, Political Science, Psychology, Literature',
    icon: Icons.gavel_outlined,
    gradientColors: [Color(0xFFA855F7), Color(0xFFC084FC)],
    overview:
        'Humanities (also called Arts) explores society, human behaviour, '
        'law, governance, culture, and communication. It suits students who '
        'enjoy reading, writing, debating, and understanding people and '
        'society — and it opens some of the most respected careers in India, '
        'including civil services and law.',
    subjects: [
      'History',
      'Political Science',
      'Economics/Psychology/Sociology',
      'English',
      'Geography / Fine Arts (optional)',
    ],
    skillsRequired: [
      'Strong reading and writing ability',
      'Critical thinking and argumentation',
      'Curiosity about society, culture, and current affairs',
      'Public speaking confidence',
      'Empathy and interpersonal understanding',
    ],
    whoShouldChoose: [
      'Enjoys reading, writing, and debating ideas',
      'Curious about history, governance, psychology, or society',
      'Wants to pursue civil services, law, journalism, or design',
      'Prefers open-ended, interpretive subjects over rigid formulas',
      'Interested in public speaking, writing, or creative expression',
    ],
    pros: [
      'Direct path to some of India\'s most prestigious careers — IAS/IPS, law, diplomacy',
      'Widest flexibility — humanities graduates can pursue almost any postgraduate field',
      'Strong fit for creative fields like design, journalism, and content',
      'CUET keeps university options open across streams',
    ],
    cons: [
      'Often unfairly stereotyped as a "fallback" stream, despite strong prospects',
      'Civil services and top law entrances (UPSC, CLAT) are extremely competitive',
      'Career paths can feel less clearly defined than engineering/medicine early on',
      'Requires strong self-motivation for reading-heavy, less structured subjects',
    ],
    futureOpportunities:
        'Humanities leads to civil services (IAS/IPS/IFS), law, journalism and '
        'mass communication, psychology and counselling, design (NID/NIFT), '
        'social work, academia, and public policy — plus an MBA or CUET-based '
        'university programme in almost any field.',
    salaryExpectation:
        'Entry-level: ₹3L–₹7L/year for most graduate roles. Civil servants '
        'start around ₹56,100–₹2,50,000/month with government perks. Lawyers '
        'and designers range widely — ₹5L to ₹50L+/year depending on '
        'specialization and reputation.',
    growthOpportunities:
        'Civil servants grow through fixed government promotion cadres; '
        'lawyers grow from associate → partner or independent practice; '
        'designers and writers grow through portfolio reputation and '
        'leadership roles in studios or media houses.',
    personalityTraits: [
      'Articulate',
      'Empathetic',
      'Curious about society',
      'Persuasive',
      'Creative',
    ],
    industriesHiring: [
      'Government & Public Administration',
      'Law Firms & Judiciary',
      'Media & Journalism',
      'Design Studios',
      'NGOs & Social Sector',
      'Education & Academia',
    ],
    skillsToBuild: [
      'Writing',
      'Public Speaking',
      'Critical Thinking',
      'Current Affairs Awareness',
      'Research & Analysis'
    ],
    examIds: ['cuet', 'clat', 'upsc_cse', 'nid_dat', 'nift_entrance'],
  );

  static const List<StreamInfo> all = [pcm, pcb, commerce, humanities];

  static StreamInfo byCode(String code) {
    return all.firstWhere((s) => s.code == code, orElse: () => pcm);
  }
}

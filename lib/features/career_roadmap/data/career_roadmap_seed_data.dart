import 'package:flutter/material.dart';

import '../../../core/models/faq_item.dart';
import '../models/career_roadmap_model.dart';

/// Representative seed data for 18 popular careers (spec §Feature 3).
/// Approximate, illustrative figures — swap for a live `careerRoadmaps`
/// Firestore feed later via [CareerRoadmapRepository].
class CareerRoadmapSeedData {
  CareerRoadmapSeedData._();

  static List<CareerRoadmapStep> _roadmap({
    required String exam,
    required String degree,
    required String entryJob,
    required String seniorJob,
    required String leadershipJob,
  }) {
    return [
      const CareerRoadmapStep(
          title: '12th Grade',
          subtitle: 'Choose the right stream & subjects',
          detail:
              'Pick the stream that keeps this career open, and start building foundational subject strength early.'),
      CareerRoadmapStep(
          title: 'Entrance Exam',
          subtitle: exam,
          detail:
              'Prepare for $exam — the primary gateway exam(s) for this career\'s degree programmes.'),
      CareerRoadmapStep(
          title: 'College Admission',
          subtitle: 'Get into a strong, accredited institute',
          detail:
              'Use College Explorer/Predictor to shortlist colleges by rank, fees, and placement record.'),
      CareerRoadmapStep(
          title: 'Degree',
          subtitle: degree,
          detail:
              'Complete your $degree with strong fundamentals — grades matter for early recruiters and higher studies both.'),
      const CareerRoadmapStep(
          title: 'Core Skills',
          subtitle: 'Build the technical/professional skill stack',
          detail:
              'Go beyond the syllabus — build the specific skills recruiters in this field actually screen for.'),
      const CareerRoadmapStep(
          title: 'Projects',
          subtitle: 'Apply skills to real, demonstrable work',
          detail:
              'Build a portfolio of projects/case studies that prove your skills to recruiters and interviewers.'),
      const CareerRoadmapStep(
          title: 'Internship',
          subtitle: 'Get real workplace exposure',
          detail:
              'An internship (or equivalent clinical/court/lab attachment) is often the strongest predictor of a full-time offer.'),
      const CareerRoadmapStep(
          title: 'Placement',
          subtitle: 'Convert your preparation into an offer',
          detail:
              'Campus placements, direct applications, or exam-based recruitment — target multiple channels.'),
      CareerRoadmapStep(
          title: 'Entry Job',
          subtitle: entryJob,
          detail:
              'Your first 2-3 years as $entryJob build the foundation — focus on learning fast and delivering consistently.'),
      CareerRoadmapStep(
          title: 'Senior Position',
          subtitle: seniorJob,
          detail:
              'After demonstrable impact, you move into a $seniorJob role with more ownership and specialization.'),
      CareerRoadmapStep(
          title: 'Leadership Position',
          subtitle: leadershipJob,
          detail:
              'At the top of this path, you take on a $leadershipJob role, shaping strategy and mentoring others.'),
    ];
  }

  static final List<CareerRoadmapModel> all = [
    CareerRoadmapModel(
      id: 'software_engineer',
      title: 'Software Engineer',
      domain: 'Technology',
      icon: Icons.code_rounded,
      accent: const Color(0xFF3B82F6),
      shortDescription:
          'Design, build and maintain the software that powers apps, websites, and systems.',
      overview:
          'Software engineers write, test, and maintain code across web, mobile, cloud, and embedded systems, working in teams using modern engineering practices.',
      dailyWork:
          'Writing and reviewing code, debugging issues, attending stand-ups, designing system architecture, and collaborating with product/design teams.',
      requiredSkills: const [
        'Data Structures & Algorithms',
        'Programming languages (Python/Java/JS)',
        'System Design',
        'Git & version control',
        'Problem solving'
      ],
      eligibility:
          'B.Tech/B.E. in CS/IT/ECE (or a strong self-taught portfolio for some product companies).',
      bestDegrees: const [
        'B.Tech Computer Science',
        'B.Tech IT',
        'BCA + M.Sc Computer Science'
      ],
      bestColleges: const ['IITs', 'NITs', 'IIITs', 'BITS Pilani'],
      topRecruiters: const [
        'Google',
        'Microsoft',
        'Amazon',
        'Flipkart',
        'Infosys',
        'TCS'
      ],
      indiaSalaryRange: '₹6L – ₹40L+ per year',
      internationalSalaryRange: '\$70K – \$180K+ per year (US)',
      futureScope:
          'Continued high demand across every industry as software eats more of the economy; AI-assisted coding is changing tools, not eliminating the role.',
      growthRate: 'Very High — 15-20% YoY hiring growth in product companies',
      demandLevel: DemandLevel.veryHigh,
      aiImpact:
          'AI coding assistants speed up routine work; engineers who can design systems and reason about tradeoffs remain highly valued.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.6,
      pros: const [
        'High salary ceiling',
        'Remote-friendly',
        'Huge job market',
        'Transferable skills globally'
      ],
      cons: const [
        'Constant need to upskill',
        'Can involve long hours during releases',
        'High interview competition at top firms'
      ],
      requiredCertifications: const [
        'AWS/GCP/Azure Cloud Certifications',
        'System Design courses'
      ],
      resources: const [
        'LeetCode',
        'freeCodeCamp',
        'The Odin Project',
        'System Design Primer (GitHub)'
      ],
      roadmapSteps: _roadmap(
          exam: 'JEE Main/Advanced',
          degree: 'B.Tech in Computer Science',
          entryJob: 'Software Development Engineer (SDE-1)',
          seniorJob: 'Senior SDE / Tech Lead',
          leadershipJob: 'Engineering Manager / VP Engineering'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Programming fundamentals (Python/C++)',
          'Basic DSA',
          'Git basics'
        ],
        intermediateSkills: [
          'Advanced DSA & problem solving',
          'Web/mobile frameworks',
          'Databases (SQL/NoSQL)'
        ],
        advancedSkills: [
          'System design at scale',
          'Distributed systems',
          'Performance optimization'
        ],
        projects: [
          'Full-stack web app',
          'Open-source contribution',
          'A scalable backend API'
        ],
        certificates: [
          'AWS Certified Developer',
          'Google Cloud Associate Engineer'
        ],
        books: [
          'Cracking the Coding Interview',
          'Designing Data-Intensive Applications'
        ],
        courses: ['CS50 (Harvard)', 'DSA specialization on Coursera/Udemy'],
      ),
      faqs: const [
        FaqItem(
            question: 'Is a CS degree mandatory?',
            answer:
                'It helps significantly for campus placements, but many product companies also hire strong self-taught engineers with solid portfolios.')
      ],
      tags: const ['tech', 'coding', 'analytical', 'remote_friendly'],
      popularityScore: 98,
    ),
    CareerRoadmapModel(
      id: 'doctor',
      title: 'Doctor (MBBS/MD)',
      domain: 'Healthcare',
      icon: Icons.local_hospital_outlined,
      accent: const Color(0xFF22C55E),
      shortDescription:
          'Diagnose and treat patients — one of India\'s most respected professions.',
      overview:
          'Doctors examine, diagnose, and treat patients across general practice or specializations, requiring years of rigorous medical training and lifelong learning.',
      dailyWork:
          'Patient consultations, diagnosis, prescribing treatment, ward rounds (if hospital-based), and continuous medical education.',
      requiredSkills: const [
        'Clinical reasoning',
        'Patient communication',
        'Attention to detail',
        'Stress resilience',
        'Ethics'
      ],
      eligibility:
          'MBBS (5.5 years including internship) via NEET UG; MD/MS for specialization via NEET PG.',
      bestDegrees: const ['MBBS', 'MD/MS (specialization)'],
      bestColleges: const [
        'AIIMS Delhi',
        'CMC Vellore',
        'JIPMER',
        'Maulana Azad Medical College'
      ],
      topRecruiters: const [
        'Government Hospitals',
        'Apollo',
        'Fortis',
        'Max Healthcare',
        'Private practice'
      ],
      indiaSalaryRange: '₹6L – ₹30L+ per year (higher for specialists)',
      internationalSalaryRange:
          '\$180K – \$350K+ per year (US, post-licensing)',
      futureScope:
          'Stable, high-respect demand forever; growing need for specialists in oncology, cardiology, and geriatric care as India ages.',
      growthRate:
          'Steady — consistent demand, seat expansion slower than aspirant growth',
      demandLevel: DemandLevel.veryHigh,
      aiImpact:
          'AI assists diagnostics and imaging, but clinical judgement, empathy, and hands-on care remain irreplaceable.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 2.8,
      pros: const [
        'Highly respected profession',
        'Stable, recession-proof demand',
        'Deeply meaningful work'
      ],
      cons: const [
        'Long, expensive education path (5.5+ years)',
        'High-stress, long hours especially early career',
        'NEET is extremely competitive'
      ],
      requiredCertifications: const [
        'MCI/NMC registration',
        'Specialization board certification (post-MD/MS)'
      ],
      resources: const [
        'NEET/MBBS prep platforms',
        'Medical journals (NEJM, Lancet)',
        'Clinical rotation mentorship'
      ],
      roadmapSteps: _roadmap(
          exam: 'NEET UG',
          degree: 'MBBS',
          entryJob: 'Resident Doctor / House Surgeon',
          seniorJob: 'Specialist / Consultant (post MD/MS)',
          leadershipJob: 'Senior Consultant / Hospital Medical Director'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Anatomy & Physiology fundamentals',
          'Basic clinical skills',
          'Patient history taking'
        ],
        intermediateSkills: [
          'Diagnostic reasoning',
          'Specialty rotations',
          'Procedural skills'
        ],
        advancedSkills: [
          'Specialization expertise (MD/MS)',
          'Surgical/procedural mastery',
          'Research & publications'
        ],
        projects: ['Clinical case presentations', 'Research paper/thesis'],
        certificates: [
          'BLS/ACLS certification',
          'Specialty board certification'
        ],
        books: [
          'Harrison\'s Principles of Internal Medicine',
          'Gray\'s Anatomy'
        ],
        courses: ['NEET PG prep courses', 'Specialty fellowship programmes'],
      ),
      faqs: const [
        FaqItem(
            question: 'How long until I can practice independently?',
            answer:
                'MBBS (5.5 years) qualifies you as a general physician; most doctors pursue MD/MS (3 more years) for specialization before independent specialist practice.')
      ],
      tags: const ['healthcare', 'biology', 'helping_people'],
      popularityScore: 96,
    ),
    CareerRoadmapModel(
      id: 'data_scientist',
      title: 'Data Scientist',
      domain: 'Technology',
      icon: Icons.bar_chart_rounded,
      accent: const Color(0xFF06B6D4),
      shortDescription:
          'Extract insights from data to drive business decisions using statistics and ML.',
      overview:
          'Data scientists analyze structured and unstructured data, build predictive models, and communicate findings to guide business strategy.',
      dailyWork:
          'Cleaning data, exploratory analysis, building/validating ML models, and presenting insights to stakeholders.',
      requiredSkills: const [
        'Python/R',
        'SQL',
        'Statistics & probability',
        'Machine Learning',
        'Data visualization'
      ],
      eligibility:
          'B.Tech/B.Sc in CS, Statistics, Mathematics, or related quantitative field.',
      bestDegrees: const [
        'B.Tech CSE',
        'B.Sc Statistics/Mathematics',
        'M.Sc Data Science'
      ],
      bestColleges: const [
        'IITs',
        'ISI Kolkata',
        'IIITs',
        'Chennai Mathematical Institute'
      ],
      topRecruiters: const [
        'Amazon',
        'Walmart Labs',
        'Flipkart',
        'Swiggy',
        'Mu Sigma'
      ],
      indiaSalaryRange: '₹8L – ₹35L per year',
      internationalSalaryRange: '\$90K – \$160K+ per year (US)',
      futureScope:
          'Strong long-term demand as more industries adopt data-driven decision-making; overlaps increasingly with AI/ML engineering.',
      growthRate: 'High — 12-18% YoY hiring growth',
      demandLevel: DemandLevel.high,
      aiImpact:
          'Generative AI automates some routine analysis, but framing the right business question and validating models remains human-led.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.7,
      pros: const [
        'High pay',
        'Cross-industry applicability',
        'Intellectually engaging work'
      ],
      cons: const [
        'Requires continuous learning of new tools',
        'Can involve messy, unglamorous data cleaning work'
      ],
      requiredCertifications: const [
        'Google/IBM Data Science Certificate',
        'Microsoft Certified: Azure Data Scientist'
      ],
      resources: const [
        'Kaggle',
        'Coursera Data Science Specialization',
        'DataCamp'
      ],
      roadmapSteps: _roadmap(
          exam: 'JEE Main / CUET',
          degree: 'B.Tech/B.Sc in a quantitative field',
          entryJob: 'Junior Data Analyst / Data Scientist',
          seniorJob: 'Senior Data Scientist',
          leadershipJob: 'Head of Data Science / Chief Data Officer'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Python & SQL basics',
          'Statistics fundamentals',
          'Excel/data cleaning'
        ],
        intermediateSkills: [
          'Machine Learning algorithms',
          'Data visualization (Tableau/PowerBI)',
          'A/B testing'
        ],
        advancedSkills: [
          'Deep learning',
          'MLOps & model deployment',
          'Causal inference'
        ],
        projects: [
          'Kaggle competition submission',
          'End-to-end ML pipeline project'
        ],
        certificates: [
          'IBM Data Science Professional Certificate',
          'TensorFlow Developer Certificate'
        ],
        books: [
          'An Introduction to Statistical Learning',
          'Python for Data Analysis'
        ],
        courses: ['Andrew Ng — Machine Learning Specialization'],
      ),
      faqs: const [
        FaqItem(
            question: 'Is a Master\'s degree required?',
            answer:
                'Not mandatory — a strong portfolio (Kaggle, projects) plus a quantitative UG degree can get you hired, though an M.Sc helps for research-heavy roles.')
      ],
      tags: const ['tech', 'data', 'analytical', 'ai_ml', 'remote_friendly'],
      popularityScore: 90,
    ),
    CareerRoadmapModel(
      id: 'lawyer',
      title: 'Lawyer',
      domain: 'Law',
      icon: Icons.gavel_outlined,
      accent: const Color(0xFFA855F7),
      shortDescription:
          'Represent clients, interpret law, and uphold justice in courts and corporations.',
      overview:
          'Lawyers advise clients, draft legal documents, negotiate settlements, and represent clients in litigation or advisory capacities across firms, companies, or independent practice.',
      dailyWork:
          'Legal research, drafting contracts/briefs, client meetings, court appearances (for litigators), and negotiation.',
      requiredSkills: const [
        'Legal research & writing',
        'Analytical reasoning',
        'Public speaking',
        'Negotiation',
        'Attention to detail'
      ],
      eligibility:
          '5-year integrated LL.B. (via CLAT/AILET) after 12th, or 3-year LL.B. after any bachelor\'s degree.',
      bestDegrees: const [
        'BA LLB (Hons)',
        'BBA LLB (Hons)',
        'LLM (specialization)'
      ],
      bestColleges: const [
        'NLSIU Bangalore',
        'NALSAR Hyderabad',
        'NLU Delhi',
        'Symbiosis Law School'
      ],
      topRecruiters: const [
        'AZB & Partners',
        'Cyril Amarchand Mangaldas',
        'Trilegal',
        'Corporate legal teams',
        'Judiciary'
      ],
      indiaSalaryRange:
          '₹6L – ₹40L+ per year (Tier-1 firms); much higher for senior counsel',
      internationalSalaryRange:
          '\$100K – \$250K+ per year (US/UK, qualified lawyers)',
      futureScope:
          'Steady demand in corporate law, IP, and litigation; growing niches in tech law, data privacy, and ESG compliance.',
      growthRate: 'Moderate to High — especially in corporate/tech law niches',
      demandLevel: DemandLevel.high,
      aiImpact:
          'AI tools speed up contract review and research, but courtroom advocacy, negotiation, and judgement remain human-centred.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 2.9,
      pros: const [
        'Prestigious, intellectually demanding career',
        'Strong earning potential at top firms',
        'Diverse specialization options'
      ],
      cons: const [
        'Long, demanding work hours especially early career',
        'Litigation income can be unpredictable initially',
        'CLAT/NLU admission is highly competitive'
      ],
      requiredCertifications: const [
        'Bar Council enrollment (mandatory to practice)',
        'LLM specialization (optional, for niche practice)'
      ],
      resources: const [
        'SCC Online',
        'Manupatra',
        'Legal internships at law firms/chambers'
      ],
      roadmapSteps: _roadmap(
          exam: 'CLAT / AILET',
          degree: 'BA LLB (Hons)',
          entryJob: 'Associate at a law firm / Junior Counsel',
          seniorJob: 'Senior Associate / Independent Counsel',
          leadershipJob: 'Partner / Senior Advocate'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Legal research basics',
          'Constitutional law fundamentals',
          'Legal writing'
        ],
        intermediateSkills: [
          'Contract drafting',
          'Moot court advocacy',
          'Case analysis'
        ],
        advancedSkills: [
          'Courtroom litigation strategy',
          'Specialized practice area mastery',
          'Client & firm management'
        ],
        projects: [
          'Moot court competitions',
          'Law journal publication',
          'Legal aid clinic work'
        ],
        certificates: [
          'Bar Council enrollment',
          'Specialized certifications (IP law, cyber law, etc.)'
        ],
        books: [
          'Introduction to the Constitution of India — DD Basu',
          'Legal Research Methodology guides'
        ],
        courses: [
          'NUJS/NLU online certificate courses',
          'Coursera legal specializations'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Can I become a lawyer without CLAT?',
            answer:
                'Yes — you can pursue a 3-year LL.B. after any bachelor\'s degree via university-specific entrance tests instead of CLAT.')
      ],
      tags: const ['law', 'writing', 'analytical', 'communication'],
      popularityScore: 75,
    ),
    CareerRoadmapModel(
      id: 'biotechnologist',
      title: 'Biotechnologist',
      domain: 'Science',
      icon: Icons.biotech_outlined,
      accent: const Color(0xFF14B8A6),
      shortDescription:
          'Apply biological systems to develop products in medicine, agriculture, and industry.',
      overview:
          'Biotechnologists work in labs and industry researching and developing solutions in pharmaceuticals, agriculture, food science, and genetic engineering.',
      dailyWork:
          'Lab experiments, data analysis, research documentation, and collaboration with cross-functional R&D teams.',
      requiredSkills: const [
        'Molecular biology & genetics',
        'Lab techniques',
        'Data analysis',
        'Scientific writing',
        'Attention to detail'
      ],
      eligibility:
          'B.Sc/B.Tech in Biotechnology; M.Sc/PhD for research-heavy roles.',
      bestDegrees: const [
        'B.Tech Biotechnology',
        'B.Sc Biotechnology (Hons)',
        'M.Sc/PhD Biotechnology'
      ],
      bestColleges: const [
        'IIT Delhi/Kharagpur (Biotech)',
        'Delhi University',
        'ICGEB New Delhi'
      ],
      topRecruiters: const [
        'Biocon',
        'Serum Institute of India',
        'Dr. Reddy\'s',
        'Research institutes',
        'Pharma MNCs'
      ],
      indiaSalaryRange: '₹4L – ₹18L per year',
      internationalSalaryRange: '\$60K – \$120K+ per year (US/EU)',
      futureScope:
          'Rapid growth in genomics, personalized medicine, and agri-biotech; India\'s biotech sector is expanding fast.',
      growthRate: 'High — especially in genomics and biopharma',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI accelerates drug discovery and genomic analysis, creating new hybrid roles at the intersection of biology and computation.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.4,
      pros: const [
        'Meaningful, impactful research work',
        'Growing sector with government support',
        'Diverse application areas'
      ],
      cons: const [
        'Research roles often require a PhD for progression',
        'Entry-level salaries are modest compared to tech',
        'Lab-based work, limited remote options'
      ],
      requiredCertifications: const [
        'GAT-B / DBT-JRF (for research fellowships)',
        'GLP/GMP lab certifications (industry roles)'
      ],
      resources: const ['DBT India resources', 'BioTecNika', 'ResearchGate'],
      roadmapSteps: _roadmap(
          exam: 'CUET / University entrance',
          degree: 'B.Tech/B.Sc Biotechnology',
          entryJob: 'Research Associate / Junior Scientist',
          seniorJob: 'Senior Scientist / Team Lead (R&D)',
          leadershipJob: 'Head of R&D / Principal Scientist'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Molecular biology basics',
          'Lab safety & techniques',
          'Genetics fundamentals'
        ],
        intermediateSkills: [
          'Bioinformatics tools',
          'Cell culture techniques',
          'Research methodology'
        ],
        advancedSkills: [
          'Genetic engineering & CRISPR',
          'Clinical trial design',
          'Grant writing & publication'
        ],
        projects: [
          'Undergraduate research project/thesis',
          'Lab internship at a research institute'
        ],
        certificates: ['GAT-B', 'Good Laboratory Practice (GLP) training'],
        books: [
          'Molecular Biology of the Cell — Alberts',
          'Biotechnology — B.D. Singh'
        ],
        courses: [
          'NPTEL Biotechnology courses',
          'Coursera Genomics specializations'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need NEET for biotechnology?',
            answer:
                'No, B.Sc/B.Tech Biotechnology admissions are via CUET or university-specific tests, not NEET.')
      ],
      tags: const ['science', 'biology', 'research', 'healthcare'],
      popularityScore: 58,
    ),
    CareerRoadmapModel(
      id: 'ias_officer',
      title: 'IAS Officer',
      domain: 'Government & Public Service',
      icon: Icons.account_balance_outlined,
      accent: const Color(0xFFEAB308),
      shortDescription:
          'Administer government policy and public services as an elite civil servant.',
      overview:
          'IAS officers implement government policy, manage districts/departments, and serve as the administrative backbone of Indian governance.',
      dailyWork:
          'Policy implementation, public grievance redressal, inter-departmental coordination, and field visits.',
      requiredSkills: const [
        'Public administration',
        'Decision-making under pressure',
        'Communication',
        'Ethics & integrity',
        'General awareness'
      ],
      eligibility:
          'Any bachelor\'s degree; clear UPSC Civil Services Examination (Prelims, Mains, Interview).',
      bestDegrees: const ['Any bachelor\'s degree (BA/B.Sc/B.Tech, etc.)'],
      bestColleges: const [
        'Any recognised university — degree stream doesn\'t restrict UPSC eligibility'
      ],
      topRecruiters: const ['Government of India (Union & State Cadres)'],
      indiaSalaryRange:
          '₹56,100 – ₹2,50,000/month (7th Pay Commission) plus government perks',
      internationalSalaryRange:
          'Not applicable — India-specific government service',
      futureScope:
          'Consistently prestigious and stable; scope for postings across ministries, districts, and international deputation (UN, embassies).',
      growthRate: 'Stable — fixed cadre growth via seniority and performance',
      demandLevel: DemandLevel.high,
      aiImpact:
          'AI supports data-driven governance and e-governance systems, but on-ground administration and judgement remain officer-led.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.0,
      pros: const [
        'Extremely prestigious',
        'Direct impact on public welfare',
        'Job security and government benefits'
      ],
      cons: const [
        'Exceptionally competitive (lakhs of aspirants, few hundred selected)',
        'Frequent transfers across postings',
        'Long preparation timeline (1-3+ years typical)'
      ],
      requiredCertifications: const [
        'None formal — UPSC CSE itself is the qualifying exam'
      ],
      resources: const [
        'NCERT textbooks (foundation)',
        'Standard UPSC reference books',
        'Daily newspaper reading (The Hindu)'
      ],
      roadmapSteps: _roadmap(
          exam: 'UPSC Civil Services Examination',
          degree: 'Any bachelor\'s degree',
          entryJob: 'Sub-Divisional Magistrate / Assistant Secretary',
          seniorJob: 'District Magistrate / Joint Secretary',
          leadershipJob:
              'Secretary to Government of India / Cabinet Secretary'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'NCERT-level GK & polity foundation',
          'Current affairs reading habit',
          'Basic essay writing'
        ],
        intermediateSkills: [
          'Optional subject mastery',
          'Answer writing practice',
          'Analytical & ethical reasoning'
        ],
        advancedSkills: [
          'Interview & personality test preparation',
          'Mains-level in-depth subject expertise'
        ],
        projects: ['Daily answer writing practice', 'Mock interview sessions'],
        certificates: [
          'Not applicable — no certification substitutes for clearing UPSC CSE'
        ],
        books: [
          'NCERT Class 6-12 (foundation)',
          'Indian Polity — M. Laxmikanth',
          'Standard optional subject references'
        ],
        courses: [
          'UPSC foundation & optional subject coaching (offline/online)'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Does my degree stream matter for UPSC?',
            answer:
                'No — any bachelor\'s degree from a recognised university makes you eligible to appear for the UPSC Civil Services Examination.')
      ],
      tags: const [
        'government',
        'govt_job',
        'leadership',
        'helping_people',
        'communication'
      ],
      popularityScore: 82,
    ),
    CareerRoadmapModel(
      id: 'professor',
      title: 'Professor / Academic',
      domain: 'Education & Research',
      icon: Icons.school_outlined,
      accent: const Color(0xFF6366F1),
      shortDescription:
          'Teach, mentor, and conduct research at the university level.',
      overview:
          'Professors teach undergraduate/postgraduate courses, guide student research, publish academic work, and contribute to their field\'s body of knowledge.',
      dailyWork:
          'Lectures, student mentoring, research, paper writing, and departmental/administrative responsibilities.',
      requiredSkills: const [
        'Subject mastery',
        'Communication & teaching ability',
        'Research methodology',
        'Academic writing',
        'Patience'
      ],
      eligibility:
          'Master\'s degree + NET/SET qualification for Assistant Professor; PhD required for most university/research positions.',
      bestDegrees: const [
        'Master\'s degree in chosen subject',
        'PhD (essential for career progression)'
      ],
      bestColleges: const [
        'IITs/IISc (for STEM)',
        'JNU/DU (for Humanities/Social Sciences)',
        'Central & State Universities'
      ],
      topRecruiters: const [
        'Central & State Universities',
        'IITs/IIMs/IISERs',
        'Private universities',
        'Research institutes'
      ],
      indiaSalaryRange:
          '₹6L – ₹25L+ per year (varies by institute prestige & seniority)',
      internationalSalaryRange:
          '\$70K – \$150K+ per year (US/EU tenured faculty)',
      futureScope:
          'Growing private university sector is expanding academic job openings; research funding is also increasing in priority areas (AI, climate, biotech).',
      growthRate:
          'Moderate — steady but competitive, especially for permanent/tenured posts',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI aids research literature review and even some grading, but teaching, mentorship, and original research direction stay human-led.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.8,
      pros: const [
        'Intellectually fulfilling work',
        'Long-term job stability (post-tenure)',
        'Flexible schedule outside teaching hours',
        'Respected in society'
      ],
      cons: const [
        'Long path to a PhD (5-6+ years post-Master\'s)',
        'Highly competitive for permanent positions',
        'Publish-or-perish pressure in research-focused roles'
      ],
      requiredCertifications: const [
        'UGC-NET/SET (India)',
        'PhD (mandatory for most university roles)'
      ],
      resources: const [
        'Google Scholar',
        'ResearchGate',
        'UGC-NET prep resources'
      ],
      roadmapSteps: _roadmap(
          exam: 'CUET PG / University entrance + NET',
          degree: 'Master\'s + PhD',
          entryJob: 'Assistant Professor / Postdoctoral Researcher',
          seniorJob: 'Associate Professor',
          leadershipJob: 'Professor & Head of Department / Dean'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Strong subject fundamentals',
          'Academic writing basics',
          'Public speaking/teaching practice'
        ],
        intermediateSkills: [
          'Research methodology',
          'Thesis/dissertation writing',
          'Grant proposal writing'
        ],
        advancedSkills: [
          'Independent research leadership',
          'Peer-reviewed publication track record',
          'Mentoring PhD scholars'
        ],
        projects: [
          'Master\'s thesis',
          'PhD dissertation',
          'Published research papers'
        ],
        certificates: ['UGC-NET/SET', 'PhD'],
        books: [
          'Subject-specific advanced textbooks',
          'How to Write a Better Thesis'
        ],
        courses: ['NPTEL advanced courses', 'Research methodology MOOCs'],
      ),
      faqs: const [
        FaqItem(
            question: 'Is a PhD compulsory to become a professor?',
            answer:
                'For Assistant Professor entry, NET/SET with a Master\'s can suffice at some institutes, but a PhD is essential for career progression and most university-level roles today.')
      ],
      tags: const ['research', 'teaching', 'communication', 'analytical'],
      popularityScore: 55,
    ),
    CareerRoadmapModel(
      id: 'psychologist',
      title: 'Psychologist',
      domain: 'Healthcare',
      icon: Icons.psychology_outlined,
      accent: const Color(0xFFEC4899),
      shortDescription:
          'Study behavior and mental processes to help individuals improve well-being.',
      overview:
          'Psychologists assess, diagnose, and treat emotional and behavioral issues through counselling, therapy, and psychological testing across clinical, organizational, or educational settings.',
      dailyWork:
          'Client sessions, psychological assessments, case documentation, and (for clinical roles) treatment planning.',
      requiredSkills: const [
        'Active listening',
        'Empathy',
        'Psychological assessment',
        'Confidentiality & ethics',
        'Analytical thinking'
      ],
      eligibility:
          'BA/B.Sc Psychology (Hons) followed by M.A./M.Sc Psychology; M.Phil in Clinical Psychology for licensed clinical practice.',
      bestDegrees: const [
        'BA/B.Sc Psychology (Hons)',
        'M.A./M.Sc Psychology',
        'M.Phil Clinical Psychology'
      ],
      bestColleges: const [
        'Delhi University',
        'TISS Mumbai',
        'Christ University Bangalore',
        'NIMHANS Bangalore'
      ],
      topRecruiters: const [
        'Hospitals & wellness centres',
        'Schools & universities',
        'Corporate HR/wellness teams',
        'Private practice'
      ],
      indiaSalaryRange:
          '₹3L – ₹15L per year (private practice can exceed this significantly)',
      internationalSalaryRange:
          '\$50K – \$100K+ per year (US licensed psychologists)',
      futureScope:
          'Rapidly growing awareness of mental health is driving demand in clinical, corporate wellness, and school counselling roles.',
      growthRate: 'High — mental health awareness driving strong sector growth',
      demandLevel: DemandLevel.high,
      aiImpact:
          'AI-powered mental health apps supplement but don\'t replace licensed therapy — human trust and nuance remain central.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.9,
      pros: const [
        'Meaningful, people-centred work',
        'Growing demand across settings',
        'Can build a flexible private practice'
      ],
      cons: const [
        'Clinical licensure (M.Phil) path is long and competitive (NIMHANS-level seats are few)',
        'Emotionally demanding work',
        'Entry-level pay can be modest'
      ],
      requiredCertifications: const [
        'RCI (Rehabilitation Council of India) license for clinical practice',
        'M.Phil Clinical Psychology (for licensed therapy)'
      ],
      resources: const [
        'American Psychological Association resources',
        'Indian Association of Clinical Psychologists'
      ],
      roadmapSteps: _roadmap(
          exam: 'CUET',
          degree: 'BA/B.Sc Psychology (Hons)',
          entryJob: 'Counsellor / Assistant Psychologist',
          seniorJob: 'Clinical Psychologist / Senior Counsellor',
          leadershipJob: 'Head of Wellness / Private Practice Owner'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Psychology fundamentals',
          'Active listening & rapport building',
          'Basic assessment tools'
        ],
        intermediateSkills: [
          'Therapeutic techniques (CBT, etc.)',
          'Psychological testing & report writing',
          'Case management'
        ],
        advancedSkills: [
          'Specialized therapy modalities',
          'Clinical supervision',
          'Research & publication'
        ],
        projects: [
          'Supervised counselling internship',
          'Research thesis in a specialization area'
        ],
        certificates: [
          'RCI license',
          'Certification in specific therapy modalities (CBT, DBT, etc.)'
        ],
        books: [
          'Abnormal Psychology — Barlow & Durand',
          'Cognitive Behavior Therapy — Judith Beck'
        ],
        courses: [
          'NIMHANS short-term courses',
          'Coursera/edX psychology specializations'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Can I practice as a therapist right after a Master\'s?',
            answer:
                'For licensed clinical practice you typically need an M.Phil in Clinical Psychology and RCI registration; a Master\'s alone suits counselling/wellness roles.')
      ],
      tags: const [
        'healthcare',
        'psychology',
        'helping_people',
        'communication'
      ],
      popularityScore: 62,
    ),
    CareerRoadmapModel(
      id: 'pilot',
      title: 'Commercial Pilot',
      domain: 'Aviation',
      icon: Icons.flight_takeoff_outlined,
      accent: const Color(0xFF0EA5E9),
      shortDescription:
          'Fly commercial aircraft, ensuring safe and efficient air travel for passengers.',
      overview:
          'Commercial pilots operate aircraft for airlines, requiring rigorous flight training, licensing, and continuous recurrent training.',
      dailyWork:
          'Pre-flight checks, flying scheduled routes, coordinating with air traffic control, and post-flight reporting.',
      requiredSkills: const [
        'Situational awareness',
        'Quick decision-making',
        'Technical aircraft knowledge',
        'Communication',
        'Physical & mental fitness'
      ],
      eligibility:
          '12th with Physics & Mathematics; Commercial Pilot License (CPL) from a DGCA-approved flying school.',
      bestDegrees: const [
        'CPL (Commercial Pilot License) — not a traditional degree, but flying-school certification'
      ],
      bestColleges: const [
        'Indira Gandhi Rashtriya Uran Akademi (IGRUA)',
        'CAE Gondia',
        'Bombay Flying Club'
      ],
      topRecruiters: const [
        'Air India',
        'IndiGo',
        'Vistara',
        'SpiceJet',
        'International airlines'
      ],
      indiaSalaryRange:
          '₹10L – ₹80L+ per year (Captain-level significantly higher)',
      internationalSalaryRange:
          '\$100K – \$250K+ per year (international airlines)',
      futureScope:
          'India\'s aviation sector is among the fastest-growing globally, driving strong long-term pilot demand.',
      growthRate: 'High — fleet expansion across Indian carriers',
      demandLevel: DemandLevel.high,
      aiImpact:
          'Autopilot and AI-assisted systems support flying, but licensed human pilots remain mandatory for commercial aviation safety and regulation.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.0,
      pros: const [
        'High salary potential',
        'Travel-intensive, dynamic career',
        'Strong growth in Indian aviation sector'
      ],
      cons: const [
        'Very expensive training (₹35-50L+ for CPL)',
        'Irregular hours & jet lag',
        'Strict medical fitness requirements throughout career'
      ],
      requiredCertifications: const [
        'DGCA Commercial Pilot License (CPL)',
        'Type Rating for specific aircraft',
        'Class 1 Medical Certificate'
      ],
      resources: const [
        'DGCA official guidelines',
        'Flying school ground school materials'
      ],
      roadmapSteps: _roadmap(
          exam: 'DGCA CPL ground exams',
          degree: 'CPL flight training',
          entryJob: 'First Officer / Co-Pilot',
          seniorJob: 'Captain',
          leadershipJob: 'Chief Pilot / Head of Flight Operations'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Aviation theory (meteorology, navigation)',
          'Basic flight training hours',
          'Radio telephony'
        ],
        intermediateSkills: [
          'Instrument flying rating',
          'Multi-engine aircraft handling',
          'CPL ground exams'
        ],
        advancedSkills: [
          'Type rating on commercial aircraft',
          'Airline-specific simulator training',
          'Command experience (Captaincy)'
        ],
        projects: [
          'Logged flight hours (solo & dual)',
          'Simulator check-rides'
        ],
        certificates: [
          'DGCA CPL',
          'Type Rating certificate',
          'ATPL (Airline Transport Pilot License, for Captaincy)'
        ],
        books: [
          'DGCA CAR (Civil Aviation Requirements) documents',
          'Aviation meteorology & navigation guides'
        ],
        courses: ['DGCA-approved flying school ground classes'],
      ),
      faqs: const [
        FaqItem(
            question: 'Is pilot training very expensive?',
            answer:
                'Yes, CPL training in India typically costs ₹35-50 lakh; some students opt for education loans or airline-sponsored cadet programmes to fund it.')
      ],
      tags: const ['hands_on', 'analytical', 'high_budget_ok'],
      popularityScore: 60,
    ),
    CareerRoadmapModel(
      id: 'architect',
      title: 'Architect',
      domain: 'Design & Construction',
      icon: Icons.architecture_outlined,
      accent: const Color(0xFFF97316),
      shortDescription:
          'Design buildings and spaces balancing aesthetics, function, and safety.',
      overview:
          'Architects design residential, commercial, and public buildings, balancing client needs, structural feasibility, and environmental considerations.',
      dailyWork:
          'Design drafting (CAD/BIM), client meetings, site visits, and coordination with structural/interior teams.',
      requiredSkills: const [
        'Design & spatial visualization',
        'CAD/BIM software (AutoCAD, Revit)',
        'Structural awareness',
        'Client communication',
        'Creativity'
      ],
      eligibility:
          '12th with Physics, Chemistry, Mathematics; 5-year B.Arch via NATA/JEE Main Paper 2.',
      bestDegrees: const [
        'B.Arch (5-year)',
        'M.Arch (specialization, optional)'
      ],
      bestColleges: const [
        'SPA Delhi',
        'CEPT Ahmedabad',
        'IIT Roorkee (Architecture)'
      ],
      topRecruiters: const [
        'Architecture firms',
        'Construction & real estate companies',
        'Government urban planning bodies',
        'Independent practice'
      ],
      indiaSalaryRange:
          '₹4L – ₹20L+ per year (independent practice can exceed significantly)',
      internationalSalaryRange: '\$60K – \$110K+ per year (US/UK/Middle East)',
      futureScope:
          'Growing urbanization and smart-city projects in India are expanding demand for skilled architects and urban planners.',
      growthRate:
          'Moderate to High — driven by real estate & infrastructure growth',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI-assisted design tools speed up drafting and visualization, but creative design judgement and client relationships stay architect-led.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.3,
      pros: const [
        'Creative, visible impact on cities/spaces',
        'Path to independent practice/entrepreneurship',
        'Diverse specialization options (urban, interior, landscape)'
      ],
      cons: const [
        '5-year degree is longer than most UG programmes',
        'Entry-level salaries can be modest',
        'Building/project timelines can be slow and client-dependent'
      ],
      requiredCertifications: const [
        'Council of Architecture (CoA) registration — mandatory to practice as "Architect" in India'
      ],
      resources: const [
        'ArchDaily',
        'Autodesk learning resources',
        'CoA guidelines'
      ],
      roadmapSteps: _roadmap(
          exam: 'NATA / JEE Main Paper 2',
          degree: 'B.Arch',
          entryJob: 'Junior Architect / Design Associate',
          seniorJob: 'Senior Architect / Project Lead',
          leadershipJob: 'Principal Architect / Firm Partner'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Freehand sketching & drafting',
          'Basic CAD software',
          'Design theory fundamentals'
        ],
        intermediateSkills: [
          '3D modelling (SketchUp/Revit)',
          'Building codes & structural basics',
          'Site planning'
        ],
        advancedSkills: [
          'BIM & sustainable design',
          'Urban planning integration',
          'Project & client management'
        ],
        projects: [
          'Design studio portfolio (thesis project)',
          'Internship with a practicing firm'
        ],
        certificates: [
          'Council of Architecture (CoA) registration',
          'Autodesk Certified Professional (Revit/AutoCAD)'
        ],
        books: [
          'A Pattern Language — Christopher Alexander',
          'Architecture: Form, Space & Order — Francis Ching'
        ],
        courses: [
          'Autodesk Revit/BIM courses',
          'Sustainable design certifications'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need NATA and JEE both?',
            answer:
                'Centrally funded institutes (IITs, NITs, SPAs) require JEE Main Paper 2, while most other B.Arch colleges accept NATA alone.')
      ],
      tags: const ['design', 'creative', 'hands_on'],
      popularityScore: 56,
    ),
    CareerRoadmapModel(
      id: 'journalist',
      title: 'Journalist',
      domain: 'Media & Communication',
      icon: Icons.newspaper_outlined,
      accent: const Color(0xFFEF4444),
      shortDescription:
          'Research, write, and report news across print, digital, and broadcast media.',
      overview:
          'Journalists investigate stories, interview sources, write/report news, and hold power accountable across print, TV, digital, and broadcast media.',
      dailyWork:
          'Story research, interviews, writing/editing copy, and (for broadcast) on-camera reporting.',
      requiredSkills: const [
        'Writing & storytelling',
        'Research & fact-checking',
        'Interviewing',
        'Media ethics',
        'Adaptability under deadlines'
      ],
      eligibility:
          'BA/BJMC in Journalism & Mass Communication (any stream in 12th accepted).',
      bestDegrees: const [
        'BA Journalism & Mass Communication',
        'BJMC',
        'PG Diploma in Journalism'
      ],
      bestColleges: const [
        'IIMC Delhi',
        'Jamia Millia Islamia (AJK MCRC)',
        'Xavier Institute of Communications'
      ],
      topRecruiters: const [
        'NDTV',
        'India Today Group',
        'The Hindu',
        'Digital news platforms',
        'PR agencies'
      ],
      indiaSalaryRange:
          '₹3L – ₹15L+ per year (senior editors/anchors significantly higher)',
      internationalSalaryRange: '\$45K – \$90K+ per year (US/UK)',
      futureScope:
          'Traditional print is shrinking, but digital journalism, podcasts, and independent content creation are expanding opportunities.',
      growthRate: 'Moderate — shifting from print to digital-first roles',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI assists research and drafting, but original reporting, investigation, and on-ground trust-building remain human-led.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 2.9,
      pros: const [
        'Dynamic, never-repetitive work',
        'Ability to shape public discourse',
        'Growing digital/independent creator opportunities'
      ],
      cons: const [
        'Entry-level pay is often modest',
        'Irregular hours, high-pressure deadlines',
        'Print media job market is shrinking'
      ],
      requiredCertifications: const [
        'None mandatory — portfolio and clips matter most'
      ],
      resources: const [
        'Poynter Institute resources',
        'The Journalist\'s Toolbox',
        'Internships at news organizations'
      ],
      roadmapSteps: _roadmap(
          exam: 'CUET / Institute entrance',
          degree: 'BA Journalism & Mass Communication',
          entryJob: 'Trainee Reporter / Sub-editor',
          seniorJob: 'Senior Correspondent / Editor',
          leadershipJob: 'Editor-in-Chief / Bureau Chief'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'News writing basics',
          'Grammar & style fundamentals',
          'Media law & ethics'
        ],
        intermediateSkills: [
          'Investigative research techniques',
          'Multimedia storytelling',
          'Interview skills'
        ],
        advancedSkills: [
          'Data journalism',
          'Editorial leadership',
          'Building a personal brand/beat expertise'
        ],
        projects: [
          'Campus/college newspaper contributions',
          'Personal blog or YouTube/podcast beat'
        ],
        certificates: [
          'PG Diploma in Journalism',
          'Google News Initiative training'
        ],
        books: [
          'The Elements of Journalism — Kovach & Rosenstiel',
          'On Writing Well — William Zinsser'
        ],
        courses: [
          'Reuters Journalism training',
          'Coursera journalism specializations'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Can arts/commerce students become journalists?',
            answer:
                'Yes, journalism programmes accept students from any 12th stream — a strong command of language and curiosity matter more than the stream.')
      ],
      tags: const ['writing', 'communication', 'creative'],
      popularityScore: 50,
    ),
    CareerRoadmapModel(
      id: 'entrepreneur',
      title: 'Entrepreneur',
      domain: 'Business',
      icon: Icons.rocket_launch_outlined,
      accent: const Color(0xFFF59E0B),
      shortDescription:
          'Build and scale your own venture, taking on risk to create something new.',
      overview:
          'Entrepreneurs identify problems worth solving, build products/services, raise resources, and lead teams to grow a business from scratch.',
      dailyWork:
          'Strategy, fundraising conversations, product decisions, team management, and constant problem-solving.',
      requiredSkills: const [
        'Risk tolerance',
        'Leadership',
        'Sales & persuasion',
        'Financial literacy',
        'Resilience'
      ],
      eligibility:
          'No fixed degree requirement — BBA/B.Com/B.Tech backgrounds are common; an MBA can help but isn\'t essential.',
      bestDegrees: const [
        'BBA',
        'B.Com',
        'B.Tech (for tech startups)',
        'MBA (optional)'
      ],
      bestColleges: const [
        'Any strong college — network and hands-on experience matter more than pedigree'
      ],
      topRecruiters: const ['Self-employment — building your own company'],
      indiaSalaryRange:
          'Highly variable — ₹0 (bootstrapping years) to crores (successful exits/scale)',
      internationalSalaryRange:
          'Highly variable — dependent on venture success and geography',
      futureScope:
          'India\'s startup ecosystem continues to grow rapidly across fintech, D2C, AI, and climate-tech sectors.',
      growthRate: 'Highly variable — high risk, high potential reward',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI tools dramatically lower the cost of building and testing products, making solo/small-team entrepreneurship more viable than ever.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 2.3,
      pros: const [
        'Unlimited upside potential',
        'Full autonomy and creative control',
        'Directly build something meaningful'
      ],
      cons: const [
        'High failure rate (most startups don\'t succeed)',
        'Financially and emotionally risky, especially early on',
        'No fixed income or job security'
      ],
      requiredCertifications: const [
        'None mandatory — though incubator/accelerator programmes (Y Combinator, T-Hub, etc.) help significantly'
      ],
      resources: const [
        'Y Combinator Startup School',
        'Paul Graham essays',
        'Indian startup ecosystem reports (Nasscom, Inc42)'
      ],
      roadmapSteps: _roadmap(
          exam: 'Not exam-gated',
          degree: 'Any (BBA/B.Tech/B.Com common)',
          entryJob: 'Founder / Co-founder (early stage)',
          seniorJob: 'CEO of a scaling company',
          leadershipJob: 'Serial Entrepreneur / Angel Investor'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Idea validation & customer discovery',
          'Basic business/financial literacy',
          'MVP building'
        ],
        intermediateSkills: [
          'Fundraising & pitching',
          'Team building & hiring',
          'Go-to-market strategy'
        ],
        advancedSkills: [
          'Scaling operations',
          'Investor relations & board management',
          'Strategic pivoting'
        ],
        projects: [
          'Launch a small side-project/business',
          'Participate in a startup incubator/accelerator'
        ],
        certificates: [
          'Not mandatory — incubator/accelerator completion is a strong signal instead'
        ],
        books: ['Zero to One — Peter Thiel', 'The Lean Startup — Eric Ries'],
        courses: [
          'Y Combinator Startup School (free)',
          'Stanford CS183B: How to Start a Startup'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need an MBA to start a company?',
            answer:
                'No — many successful founders never did an MBA; hands-on building, customer discovery, and resilience matter far more than the degree.')
      ],
      tags: const [
        'business',
        'entrepreneurship',
        'leadership',
        'high_budget_ok'
      ],
      popularityScore: 70,
    ),
    CareerRoadmapModel(
      id: 'scientist',
      title: 'Research Scientist',
      domain: 'Science & Research',
      icon: Icons.science_outlined,
      accent: const Color(0xFF8B5CF6),
      shortDescription:
          'Conduct original research to expand human knowledge in physics, chemistry, or biology.',
      overview:
          'Research scientists design experiments, analyze data, and publish findings at research institutes, universities, or R&D labs (ISRO, DRDO, CSIR, private R&D).',
      dailyWork:
          'Experiment design, data collection/analysis, lab work, and academic writing/publication.',
      requiredSkills: const [
        'Deep subject expertise',
        'Experimental design',
        'Data analysis',
        'Scientific writing',
        'Patience & persistence'
      ],
      eligibility:
          'B.Sc/Integrated M.Sc in a pure science; PhD required for independent research roles.',
      bestDegrees: const [
        'B.Sc/Integrated M.Sc (Physics/Chemistry/Biology)',
        'PhD (essential for research leadership)'
      ],
      bestColleges: const [
        'IISc Bangalore',
        'NISER Bhubaneswar',
        'IITs (Science departments)',
        'TIFR Mumbai'
      ],
      topRecruiters: const [
        'ISRO',
        'DRDO',
        'CSIR labs',
        'Universities',
        'Private R&D (pharma, materials, tech)'
      ],
      indiaSalaryRange:
          '₹5L – ₹20L+ per year (government scientist scales; private R&D can be higher)',
      internationalSalaryRange:
          '\$70K – \$140K+ per year (US/EU research positions)',
      futureScope:
          'Strong government investment in space, defence, and materials research; growing private R&D in biotech and clean energy.',
      growthRate:
          'Moderate — steady growth in government & private R&D funding',
      demandLevel: DemandLevel.medium,
      aiImpact:
          'AI accelerates simulation, literature review, and data analysis, freeing scientists to focus on hypothesis generation and experimental design.',
      remoteWorkFriendly: false,
      workLifeBalanceRating: 3.5,
      pros: const [
        'Deeply intellectually satisfying work',
        'Contribute to national/global scientific progress',
        'Strong government lab stability (ISRO/DRDO/CSIR)'
      ],
      cons: const [
        'Long PhD timeline (5-6 years)',
        'Research funding can be competitive',
        'Slower career/salary growth vs. private tech sector'
      ],
      requiredCertifications: const [
        'CSIR-NET/GATE (for research fellowships)',
        'PhD (for most research scientist roles)'
      ],
      resources: const [
        'CSIR & DST research portals',
        'Google Scholar',
        'NPTEL advanced courses'
      ],
      roadmapSteps: _roadmap(
          exam: 'NEST / CUET / IISER Aptitude Test',
          degree: 'B.Sc/Integrated M.Sc + PhD',
          entryJob: 'Research Fellow / Junior Scientist',
          seniorJob: 'Scientist / Senior Research Fellow',
          leadershipJob: 'Principal Scientist / Lab Director'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Strong fundamentals in chosen science',
          'Lab safety & basic techniques',
          'Scientific method understanding'
        ],
        intermediateSkills: [
          'Research methodology',
          'Data analysis tools (Python/R/MATLAB)',
          'Academic writing'
        ],
        advancedSkills: [
          'Independent research design',
          'Grant writing',
          'Peer-reviewed publication & peer review'
        ],
        projects: [
          'Undergraduate research project',
          'PhD dissertation research'
        ],
        certificates: ['CSIR-NET / GATE', 'PhD'],
        books: [
          'Subject-specific advanced textbooks',
          'How to Write a Scientific Paper'
        ],
        courses: [
          'NPTEL advanced science courses',
          'Research methodology MOOCs'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Is a PhD mandatory to be called a "scientist"?',
            answer:
                'For independent research leadership roles yes, though research associate/technician roles are open to B.Sc/M.Sc graduates without a PhD.')
      ],
      tags: const ['science', 'research', 'analytical'],
      popularityScore: 54,
    ),
    CareerRoadmapModel(
      id: 'digital_marketer',
      title: 'Digital Marketer',
      domain: 'Marketing',
      icon: Icons.campaign_outlined,
      accent: const Color(0xFFF43F5E),
      shortDescription:
          'Grow brands online through SEO, social media, ads, and content strategy.',
      overview:
          'Digital marketers plan and execute campaigns across search, social, and content channels to drive brand awareness, leads, and sales.',
      dailyWork:
          'Campaign planning, ad performance analysis, content calendars, and cross-channel strategy meetings.',
      requiredSkills: const [
        'SEO & SEM',
        'Social media strategy',
        'Analytics (Google Analytics)',
        'Content creation',
        'A/B testing'
      ],
      eligibility:
          'Any bachelor\'s degree (BBA/B.Com/BA common); certifications matter more than the specific degree.',
      bestDegrees: const [
        'BBA Marketing',
        'B.Com',
        'Any degree + digital marketing certification'
      ],
      bestColleges: const [
        'Not certification/portfolio-dependent — any recognised university works'
      ],
      topRecruiters: const [
        'E-commerce companies',
        'Digital marketing agencies',
        'D2C brands',
        'Corporate marketing teams'
      ],
      indiaSalaryRange: '₹3L – ₹18L+ per year (senior/growth roles higher)',
      internationalSalaryRange: '\$45K – \$90K+ per year (US/UK)',
      futureScope:
          'Every business is shifting ad spend online — strong, sustained demand for performance marketers and content strategists.',
      growthRate: 'High — continued shift of ad spend to digital channels',
      demandLevel: DemandLevel.high,
      aiImpact:
          'AI tools automate ad copy, targeting, and analytics, shifting the role toward strategy, brand judgement, and creative direction.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.5,
      pros: const [
        'Low barrier to entry (skills > degree)',
        'Remote-friendly & freelance-friendly',
        'Fast-growing, in-demand skill set'
      ],
      cons: const [
        'Highly saturated entry-level market',
        'Constant need to keep up with platform algorithm changes',
        'Performance-pressure (ROI-driven metrics)'
      ],
      requiredCertifications: const [
        'Google Ads/Analytics Certification',
        'Meta Blueprint Certification',
        'HubSpot Content Marketing Certification'
      ],
      resources: const [
        'Google Digital Garage',
        'HubSpot Academy',
        'Neil Patel blog/courses'
      ],
      roadmapSteps: _roadmap(
          exam: 'CUET / Direct admission',
          degree: 'BBA/B.Com + certifications',
          entryJob: 'Digital Marketing Executive',
          seniorJob: 'Digital Marketing Manager',
          leadershipJob: 'Head of Growth / CMO'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'SEO basics',
          'Social media platform fundamentals',
          'Content writing'
        ],
        intermediateSkills: [
          'Google/Meta Ads campaign management',
          'Analytics & reporting',
          'Email marketing automation'
        ],
        advancedSkills: [
          'Growth strategy & funnel optimization',
          'Marketing analytics & attribution modelling',
          'Brand strategy leadership'
        ],
        projects: [
          'Run a small business/personal brand social campaign',
          'Freelance client project'
        ],
        certificates: [
          'Google Ads Certification',
          'Meta Blueprint Certification',
          'HubSpot Inbound Marketing'
        ],
        books: ['Hooked — Nir Eyal', 'Influence — Robert Cialdini'],
        courses: ['Google Digital Garage', 'HubSpot Academy free courses'],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need an MBA for digital marketing?',
            answer:
                'No — a bachelor\'s degree plus recognised certifications (Google, Meta, HubSpot) and a strong portfolio matter far more for entry-level roles.')
      ],
      tags: const ['business', 'creative', 'communication', 'remote_friendly'],
      popularityScore: 68,
    ),
    CareerRoadmapModel(
      id: 'ui_ux_designer',
      title: 'UI/UX Designer',
      domain: 'Design & Technology',
      icon: Icons.design_services_outlined,
      accent: const Color(0xFFD946EF),
      shortDescription:
          'Design intuitive, delightful digital product experiences for apps and websites.',
      overview:
          'UI/UX designers research user needs, wireframe and prototype interfaces, and collaborate closely with product and engineering teams to ship usable, beautiful products.',
      dailyWork:
          'User research, wireframing/prototyping (Figma), design reviews, and collaborating with developers on implementation.',
      requiredSkills: const [
        'User research',
        'Wireframing & prototyping (Figma)',
        'Visual design principles',
        'Interaction design',
        'Empathy for users'
      ],
      eligibility:
          'Any bachelor\'s degree (Design/CS/any) + a strong design portfolio; formal design degrees (B.Des) help but aren\'t mandatory.',
      bestDegrees: const [
        'B.Des (Design)',
        'B.Tech + self-taught UX skills',
        'Any degree + UX bootcamp/certification'
      ],
      bestColleges: const [
        'NID Ahmedabad',
        'IIT Bombay (IDC)',
        'Srishti Manipal Institute'
      ],
      topRecruiters: const [
        'Product companies (Google, Microsoft, Flipkart)',
        'Design agencies',
        'Startups',
        'Freelance/consulting'
      ],
      indiaSalaryRange:
          '₹5L – ₹25L+ per year (senior product designers higher)',
      internationalSalaryRange: '\$70K – \$140K+ per year (US)',
      futureScope:
          'Every digital product needs design — demand keeps growing alongside the broader tech/product sector.',
      growthRate: 'High — tracks overall product/tech industry growth',
      demandLevel: DemandLevel.high,
      aiImpact:
          'AI design tools speed up asset generation and prototyping, shifting designers toward research, strategy, and systems thinking.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.8,
      pros: const [
        'Creative + analytical blend of work',
        'Remote/freelance-friendly',
        'Strong demand across every industry going digital'
      ],
      cons: const [
        'Portfolio-dependent hiring can be tough to break into initially',
        'Design decisions can face heavy stakeholder pushback',
        'Requires continuous tool/trend learning'
      ],
      requiredCertifications: const [
        'Google UX Design Certificate',
        'Interaction Design Foundation (IDF) certification'
      ],
      resources: const [
        'Figma Community',
        'Nielsen Norman Group articles',
        'Dribbble/Behance for inspiration'
      ],
      roadmapSteps: _roadmap(
          exam: 'UCEED / CEED / Direct portfolio review',
          degree: 'B.Des or any degree + portfolio',
          entryJob: 'Junior UI/UX Designer',
          seniorJob: 'Senior Product Designer',
          leadershipJob: 'Design Lead / Head of Design'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Design fundamentals (color, typography, layout)',
          'Figma basics',
          'Basic user research methods'
        ],
        intermediateSkills: [
          'Prototyping & interaction design',
          'Usability testing',
          'Design systems'
        ],
        advancedSkills: [
          'Design strategy & leadership',
          'Cross-functional stakeholder management',
          'Advanced research methods'
        ],
        projects: [
          'Redesign an existing app (case study)',
          'End-to-end product design portfolio piece'
        ],
        certificates: [
          'Google UX Design Certificate',
          'Interaction Design Foundation courses'
        ],
        books: [
          'Don\'t Make Me Think — Steve Krug',
          'The Design of Everyday Things — Don Norman'
        ],
        courses: [
          'Google UX Design Professional Certificate (Coursera)',
          'Figma Academy'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need to know how to code?',
            answer:
                'No, coding isn\'t required, though basic understanding of HTML/CSS and how developers build products helps you collaborate better.')
      ],
      tags: const ['design', 'creative', 'tech', 'remote_friendly'],
      popularityScore: 72,
    ),
    CareerRoadmapModel(
      id: 'cybersecurity_expert',
      title: 'Cybersecurity Expert',
      domain: 'Technology',
      icon: Icons.security_outlined,
      accent: const Color(0xFF10B981),
      shortDescription:
          'Protect systems, networks, and data from cyber threats and breaches.',
      overview:
          'Cybersecurity experts identify vulnerabilities, respond to security incidents, and design defensive systems to protect organizations from cyberattacks.',
      dailyWork:
          'Vulnerability scanning, monitoring security alerts, incident response, and security architecture reviews.',
      requiredSkills: const [
        'Networking fundamentals',
        'Ethical hacking / penetration testing',
        'Security tools (SIEM, firewalls)',
        'Scripting (Python/Bash)',
        'Analytical thinking'
      ],
      eligibility:
          'B.Tech in CS/IT (or any degree + strong certifications); specialized cybersecurity degrees also available.',
      bestDegrees: const [
        'B.Tech CSE (Cybersecurity specialization)',
        'B.Tech IT',
        'Any degree + industry certifications'
      ],
      bestColleges: const [
        'IIITs (Cybersecurity specializations)',
        'Amrita Vishwa Vidyapeetham',
        'NITs'
      ],
      topRecruiters: const [
        'Big 4 consulting firms',
        'Banks & fintechs',
        'Tech companies',
        'Government cybersecurity agencies (CERT-In)'
      ],
      indiaSalaryRange:
          '₹5L – ₹30L+ per year (specialized penetration testers/CISOs higher)',
      internationalSalaryRange: '\$85K – \$160K+ per year (US)',
      futureScope:
          'Cyberattacks are increasing in frequency and sophistication — near-universal, sustained demand across every sector.',
      growthRate: 'Very High — global cybersecurity talent shortage',
      demandLevel: DemandLevel.veryHigh,
      aiImpact:
          'AI powers both new attack vectors and new defensive tools — creating growing demand for AI-security specialists specifically.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.2,
      pros: const [
        'Severe global talent shortage = strong job security',
        'High pay ceiling with specialization',
        'Intellectually engaging, constantly evolving field'
      ],
      cons: const [
        'On-call/incident response can mean irregular hours',
        'High-stakes, high-pressure during active breaches',
        'Requires continuous certification/upskilling'
      ],
      requiredCertifications: const [
        'CEH (Certified Ethical Hacker)',
        'CISSP',
        'CompTIA Security+',
        'OSCP'
      ],
      resources: const ['TryHackMe', 'Hack The Box', 'OWASP resources'],
      roadmapSteps: _roadmap(
          exam: 'JEE Main / CUET',
          degree: 'B.Tech CSE/IT',
          entryJob: 'Security Analyst / SOC Analyst',
          seniorJob: 'Penetration Tester / Security Engineer',
          leadershipJob: 'CISO (Chief Information Security Officer)'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Networking fundamentals (TCP/IP)',
          'Linux basics',
          'Basic scripting (Python/Bash)'
        ],
        intermediateSkills: [
          'Ethical hacking & penetration testing',
          'Security tools (Wireshark, Metasploit)',
          'Incident response'
        ],
        advancedSkills: [
          'Advanced threat hunting',
          'Security architecture design',
          'Compliance & governance (ISO 27001)'
        ],
        projects: [
          'Capture The Flag (CTF) competitions',
          'Home lab penetration testing setup',
          'Bug bounty submissions'
        ],
        certificates: [
          'CompTIA Security+',
          'CEH',
          'OSCP',
          'CISSP (senior level)'
        ],
        books: [
          'The Web Application Hacker\'s Handbook',
          'Hacking: The Art of Exploitation'
        ],
        courses: [
          'TryHackMe learning paths',
          'Offensive Security courses (OSCP prep)'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Is a specialized cybersecurity degree necessary?',
            answer:
                'Not strictly — a general CS/IT degree plus recognised certifications (CEH, Security+, OSCP) and a demonstrated skillset (CTFs, bug bounties) can get you hired.')
      ],
      tags: const ['tech', 'security', 'analytical', 'remote_friendly'],
      popularityScore: 78,
    ),
    CareerRoadmapModel(
      id: 'ai_engineer',
      title: 'AI Engineer',
      domain: 'Technology',
      icon: Icons.smart_toy_outlined,
      accent: const Color(0xFF8B5CF6),
      shortDescription:
          'Build and deploy AI systems and applications powered by large models.',
      overview:
          'AI engineers build production systems that integrate and deploy AI models — from generative AI applications to intelligent automation — bridging research and real-world products.',
      dailyWork:
          'Building AI-powered features, integrating LLM APIs, fine-tuning models, and optimizing inference pipelines for production.',
      requiredSkills: const [
        'Python',
        'Machine Learning fundamentals',
        'LLM/API integration',
        'MLOps',
        'System design'
      ],
      eligibility:
          'B.Tech in CS/IT/AI-ML specialization (or strong self-taught portfolio in ML engineering).',
      bestDegrees: const [
        'B.Tech CSE (AI/ML specialization)',
        'B.Tech IT + ML certifications'
      ],
      bestColleges: const ['IITs', 'IIITs (AI specializations)', 'BITS Pilani'],
      topRecruiters: const [
        'OpenAI/Anthropic-adjacent startups',
        'Google DeepMind',
        'Microsoft',
        'Indian AI startups',
        'Every major tech company'
      ],
      indiaSalaryRange: '₹10L – ₹45L+ per year',
      internationalSalaryRange: '\$100K – \$220K+ per year (US)',
      futureScope:
          'Among the fastest-growing tech roles globally as every company integrates AI into its products.',
      growthRate: 'Very High — one of the fastest-growing tech specializations',
      demandLevel: DemandLevel.veryHigh,
      aiImpact:
          'This role IS the AI wave — AI engineers build the systems that apply AI to real products, a role created by and central to the AI shift.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.4,
      pros: const [
        'Extremely high demand and pay growth',
        'Working at the cutting edge of technology',
        'Remote-friendly, globally transferable skillset'
      ],
      cons: const [
        'Fast-moving field requires constant learning',
        'High competition for top AI-lab roles',
        'Can blur into long hours at fast-moving startups'
      ],
      requiredCertifications: const [
        'DeepLearning.AI TensorFlow/ML certifications',
        'AWS/GCP Machine Learning certifications'
      ],
      resources: const [
        'Hugging Face documentation',
        'DeepLearning.AI courses',
        'Papers With Code'
      ],
      roadmapSteps: _roadmap(
          exam: 'JEE Main/Advanced',
          degree: 'B.Tech CSE (AI/ML)',
          entryJob: 'AI/ML Engineer (Junior)',
          seniorJob: 'Senior AI Engineer',
          leadershipJob: 'Head of AI / VP of Engineering (AI)'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Python programming',
          'ML fundamentals (supervised/unsupervised learning)',
          'Basic neural networks'
        ],
        intermediateSkills: [
          'Deep learning frameworks (PyTorch/TensorFlow)',
          'LLM APIs & prompt engineering',
          'Model fine-tuning'
        ],
        advancedSkills: [
          'MLOps & production deployment',
          'Distributed training',
          'Custom model architecture design'
        ],
        projects: [
          'Build and deploy an LLM-powered app',
          'Fine-tune an open-source model for a specific task'
        ],
        certificates: [
          'DeepLearning.AI Specializations',
          'AWS Certified Machine Learning – Specialty'
        ],
        books: [
          'Deep Learning — Ian Goodfellow',
          'Hands-On Machine Learning — Aurélien Géron'
        ],
        courses: [
          'Andrew Ng — Deep Learning Specialization',
          'Fast.ai Practical Deep Learning'
        ],
      ),
      faqs: const [
        FaqItem(
            question:
                'What\'s the difference between AI Engineer and ML Engineer?',
            answer:
                'AI Engineer typically focuses on applying and integrating existing models (especially LLMs) into products; ML Engineer often focuses more on building/training custom models from scratch — the roles overlap heavily and titles vary by company.')
      ],
      tags: const ['tech', 'ai_ml', 'coding', 'analytical', 'remote_friendly'],
      popularityScore: 92,
    ),
    CareerRoadmapModel(
      id: 'ml_engineer',
      title: 'Machine Learning Engineer',
      domain: 'Technology',
      icon: Icons.hub_outlined,
      accent: const Color(0xFF6366F1),
      shortDescription:
          'Design, train, and deploy machine learning models at production scale.',
      overview:
          'ML engineers build the data pipelines, training infrastructure, and deployment systems that turn machine learning research into reliable, scalable products.',
      dailyWork:
          'Feature engineering, model training/evaluation, building ML pipelines, and monitoring models in production.',
      requiredSkills: const [
        'Python & ML frameworks',
        'Statistics & linear algebra',
        'Data engineering',
        'MLOps',
        'Software engineering fundamentals'
      ],
      eligibility:
          'B.Tech in CS/IT/Mathematics (or strong quantitative background with an ML portfolio).',
      bestDegrees: const [
        'B.Tech CSE',
        'B.Tech Mathematics & Computing',
        'M.Sc Data Science / ML'
      ],
      bestColleges: const ['IITs', 'IIITs', 'ISI Kolkata', 'IISc Bangalore'],
      topRecruiters: const [
        'Google',
        'Meta',
        'Amazon',
        'Indian AI/ML startups',
        'Fintech & e-commerce companies'
      ],
      indiaSalaryRange: '₹10L – ₹42L+ per year',
      internationalSalaryRange: '\$110K – \$210K+ per year (US)',
      futureScope:
          'Sustained high demand as ML moves from research labs into core infrastructure of every major product.',
      growthRate: 'Very High — foundational role across the AI/tech industry',
      demandLevel: DemandLevel.veryHigh,
      aiImpact:
          'ML engineers build the underlying systems that make modern AI possible — the role is central to, not threatened by, the AI shift.',
      remoteWorkFriendly: true,
      workLifeBalanceRating: 3.5,
      pros: const [
        'Very high pay and demand',
        'Deeply technical, intellectually rewarding work',
        'Broad applicability across industries'
      ],
      cons: const [
        'Steep learning curve (maths + software engineering both required)',
        'Competitive hiring bar at top companies',
        'Fast-evolving tools and frameworks'
      ],
      requiredCertifications: const [
        'TensorFlow Developer Certificate',
        'AWS/GCP Machine Learning certifications'
      ],
      resources: const ['Kaggle', 'Papers With Code', 'Fast.ai courses'],
      roadmapSteps: _roadmap(
          exam: 'JEE Main/Advanced',
          degree: 'B.Tech CSE / Mathematics & Computing',
          entryJob: 'ML Engineer (Junior)',
          seniorJob: 'Senior ML Engineer',
          leadershipJob: 'Principal ML Engineer / Head of ML'),
      skillRoadmap: const CareerSkillRoadmap(
        beginnerSkills: [
          'Python & data structures',
          'Linear algebra & statistics',
          'Basic ML algorithms'
        ],
        intermediateSkills: [
          'Deep learning (PyTorch/TensorFlow)',
          'Feature engineering & data pipelines',
          'Model evaluation techniques'
        ],
        advancedSkills: [
          'Large-scale distributed training',
          'ML system design & MLOps',
          'Research paper implementation'
        ],
        projects: [
          'End-to-end ML pipeline (data → model → deployment)',
          'Kaggle competition (top rankings)'
        ],
        certificates: [
          'TensorFlow Developer Certificate',
          'AWS Certified Machine Learning – Specialty'
        ],
        books: [
          'Pattern Recognition and Machine Learning — Bishop',
          'Deep Learning — Ian Goodfellow'
        ],
        courses: [
          'Andrew Ng — Machine Learning Specialization',
          'MIT 6.036 Introduction to Machine Learning'
        ],
      ),
      faqs: const [
        FaqItem(
            question: 'Do I need a Master\'s degree for ML engineering?',
            answer:
                'Not always — a strong B.Tech background plus a demonstrated ML project portfolio (Kaggle, GitHub) can secure entry-level roles, though an M.Sc/M.Tech helps for research-heavy positions.')
      ],
      tags: const ['tech', 'ai_ml', 'data', 'analytical', 'remote_friendly'],
      popularityScore: 88,
    ),
  ];
}

import 'package:flutter/material.dart';

import '../../colleges/models/student_stream.dart';
import '../models/career_resource.dart';

/// Curated, hand-picked career-readiness content. These are stable, widely used
/// platforms and official portals. Kept as static data (no backend) exactly like
/// the Scholarship Engine's seed list — the UI renders entirely from here.
class ResourceData {
  ResourceData._();

  // ---------------------------------------------------------------------------
  // Coding & DSA
  // ---------------------------------------------------------------------------
  static const ResourceHub codingDsa = ResourceHub(
    id: 'coding_dsa',
    title: 'Coding & DSA',
    subtitle: 'Master problem solving',
    icon: Icons.code,
    accent: Color(0xFFA855F7),
    intro:
        'Data Structures & Algorithms decide most software interviews. Pick one '
        'practice platform, follow a structured sheet, and solve consistently.',
    groups: [
      ResourceGroup(
        heading: 'Practice Platforms',
        items: [
          ResourceItem(
            title: 'LeetCode',
            description:
                'The standard for interview prep — 3000+ problems sorted by '
                'company, topic, and difficulty.',
            source: 'LeetCode',
            url: 'https://leetcode.com/problemset/',
            tag: 'Freemium',
          ),
          ResourceItem(
            title: 'GeeksforGeeks DSA',
            description:
                'Tutorials, practice problems, and company-wise interview '
                'archives — strong for Indian placements.',
            source: 'GeeksforGeeks',
            url: 'https://www.geeksforgeeks.org/data-structures/',
            tag: 'Free',
          ),
          ResourceItem(
            title: 'Codeforces',
            description:
                'Competitive programming contests to build speed and pattern '
                'recognition under time pressure.',
            source: 'Codeforces',
            url: 'https://codeforces.com/',
            tag: 'Free',
          ),
          ResourceItem(
            title: 'HackerRank',
            description:
                'Skill tracks with certificates; many companies use it for '
                'their first online screening round.',
            source: 'HackerRank',
            url: 'https://www.hackerrank.com/dashboard',
            tag: 'Free',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Structured Sheets',
        items: [
          ResourceItem(
            title: "Striver's A2Z DSA Course",
            description:
                'A complete, ordered DSA path from basics to advanced — the '
                'most-followed free sheet in India.',
            source: 'takeUforward',
            url:
                'https://takeuforward.org/strivers-a2z-dsa-course/strivers-a2z-dsa-course-sheet-2/',
            tag: 'Free',
          ),
          ResourceItem(
            title: 'NeetCode 150',
            description:
                '150 hand-picked problems covering every core pattern, each '
                'with a clear video explanation.',
            source: 'NeetCode',
            url: 'https://neetcode.io/practice',
            tag: 'Free',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Foundations',
        items: [
          ResourceItem(
            title: 'CS50 — Intro to Computer Science',
            description:
                "Harvard's legendary free course. Best starting point if you "
                'are new to programming.',
            source: 'Harvard / edX',
            url: 'https://cs50.harvard.edu/x/',
            tag: 'Free',
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Placement Prep
  // ---------------------------------------------------------------------------
  static const ResourceHub placement = ResourceHub(
    id: 'placement',
    title: 'Placement Prep',
    subtitle: 'Aptitude, resume & interviews',
    icon: Icons.work_outline,
    accent: Color(0xFF3B82F6),
    intro:
        'Campus placements test aptitude, coding, and communication. Prepare '
        'each pillar in parallel and practice mock interviews early.',
    groups: [
      ResourceGroup(
        heading: 'Aptitude & Reasoning',
        items: [
          ResourceItem(
            title: 'IndiaBix',
            description:
                'Topic-wise quantitative, logical, and verbal aptitude with '
                'thousands of solved questions.',
            source: 'IndiaBix',
            url: 'https://www.indiabix.com/',
            tag: 'Free',
          ),
          ResourceItem(
            title: 'PrepInsta Placement Prep',
            description:
                'Company-specific aptitude patterns and previous-year papers '
                'for TCS, Infosys, Wipro, and more.',
            source: 'PrepInsta',
            url: 'https://prepinsta.com/',
            tag: 'Freemium',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Interview Practice',
        items: [
          ResourceItem(
            title: 'InterviewBit',
            description:
                'Guided interview prep track with timed problems and mock '
                'interviews, tailored to Indian product companies.',
            source: 'InterviewBit',
            url: 'https://www.interviewbit.com/',
            tag: 'Free',
          ),
          ResourceItem(
            title: 'Pramp — Peer Mock Interviews',
            description:
                'Free live mock interviews with peers. Practice explaining your '
                'thinking out loud before the real thing.',
            source: 'Pramp',
            url: 'https://www.pramp.com/',
            tag: 'Free',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Resume',
        items: [
          ResourceItem(
            title: 'Resume Worded',
            description:
                'Instant AI feedback that scores your resume against recruiter '
                'and ATS criteria.',
            source: 'Resume Worded',
            url: 'https://resumeworded.com/',
            tag: 'Freemium',
          ),
          ResourceItem(
            title: 'Overleaf Resume Templates',
            description:
                'Clean, professional LaTeX resume templates favored by tech '
                'recruiters.',
            source: 'Overleaf',
            url: 'https://www.overleaf.com/gallery/tagged/cv',
            tag: 'Free',
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Internships
  // ---------------------------------------------------------------------------
  static const ResourceHub internships = ResourceHub(
    id: 'internships',
    title: 'Internships',
    subtitle: 'Find & track internships',
    icon: Icons.badge_outlined,
    accent: Color(0xFF22C55E),
    intro: 'Internships convert into pre-placement offers and build real-world '
        'experience. Apply early and widely across these portals.',
    groups: [
      ResourceGroup(
        heading: 'Apply Here',
        items: [
          ResourceItem(
            title: 'Internshala',
            description:
                "India's largest internship platform across tech, design, "
                'marketing, and more — with stipends and certificates.',
            source: 'Internshala',
            url: 'https://internshala.com/internships/',
            tag: 'Free',
            icon: Icons.explore_outlined,
          ),
          ResourceItem(
            title: 'AICTE Internship Portal',
            description:
                'Government internship portal connecting students with industry '
                'and government bodies nationwide.',
            source: 'AICTE',
            url: 'https://internship.aicte-india.org/',
            tag: 'Official',
            icon: Icons.account_balance,
          ),
          ResourceItem(
            title: 'Unstop (formerly Dare2Compete)',
            description:
                'Internships, competitions, and hackathons run by top companies '
                'to scout talent.',
            source: 'Unstop',
            url: 'https://unstop.com/internships',
            tag: 'Free',
            icon: Icons.emoji_events_outlined,
          ),
          ResourceItem(
            title: 'LinkedIn Jobs',
            description:
                'Filter internships by location and role, and apply directly '
                'while building your professional network.',
            source: 'LinkedIn',
            url: 'https://www.linkedin.com/jobs/internship-jobs/',
            tag: 'Free',
            icon: Icons.business_center_outlined,
          ),
          ResourceItem(
            title: 'Naukri',
            description:
                "One of India's largest job portals, with a dedicated filter "
                'for internships across every industry.',
            source: 'Naukri.com',
            url: 'https://www.naukri.com/internship-jobs',
            tag: 'Free',
            icon: Icons.work_outline,
          ),
          ResourceItem(
            title: 'Indeed',
            description:
                'Global job search engine aggregating internship listings from '
                'thousands of company career pages.',
            source: 'Indeed',
            url: 'https://in.indeed.com/q-Internship-jobs.html',
            tag: 'Free',
            icon: Icons.search,
          ),
          ResourceItem(
            title: 'Wellfound (AngelList)',
            description:
                'Internships and early-career roles at startups, with visible '
                'salary/stipend ranges and direct founder contact.',
            source: 'Wellfound',
            url: 'https://wellfound.com/jobs',
            tag: 'Free',
            icon: Icons.rocket_launch_outlined,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Top Companies',
        items: [
          ResourceItem(
            title: 'Microsoft Careers',
            description: 'Student and early-career internship programs across '
                'engineering, product, and business roles.',
            source: 'Microsoft',
            url: 'https://careers.microsoft.com/students/us/en',
            tag: 'Official',
            icon: Icons.window,
          ),
          ResourceItem(
            title: 'Google Careers',
            description:
                'STEP, Software Engineering, and other internship programs for '
                'students, including remote-friendly roles.',
            source: 'Google',
            url: 'https://careers.google.com/students/',
            tag: 'Official',
            icon: Icons.g_mobiledata,
          ),
          ResourceItem(
            title: 'TCS Careers',
            description:
                "Tata Consultancy Services' internship and entry-level hiring, "
                'including the National Qualifier Test (TCS iON NQT).',
            source: 'TCS',
            url: 'https://www.tcs.com/careers',
            tag: 'Official',
            icon: Icons.apartment,
          ),
          ResourceItem(
            title: 'Infosys Careers',
            description:
                "Infosys' internship and campus hiring programs, including the "
                'InfyTQ upskilling and placement track.',
            source: 'Infosys',
            url: 'https://www.infosys.com/careers.html',
            tag: 'Official',
            icon: Icons.apartment,
          ),
          ResourceItem(
            title: 'Wipro Careers',
            description:
                "Wipro's internship and graduate hiring programs across "
                'engineering, consulting, and business roles.',
            source: 'Wipro',
            url: 'https://careers.wipro.com/',
            tag: 'Official',
            icon: Icons.apartment,
          ),
          ResourceItem(
            title: 'IBM Careers',
            description:
                'Internship and early professional programs in software, '
                'cloud, data, and consulting.',
            source: 'IBM',
            url: 'https://www.ibm.com/careers/student',
            tag: 'Official',
            icon: Icons.developer_board,
          ),
          ResourceItem(
            title: 'Cisco Careers',
            description:
                "Cisco's student internship program spanning networking, "
                'security, and software engineering.',
            source: 'Cisco',
            url: 'https://jobs.cisco.com/students',
            tag: 'Official',
            icon: Icons.router_outlined,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Government & Research',
        items: [
          ResourceItem(
            title: 'DRDO Internship',
            description: 'Internships at the Defence Research and Development '
                'Organisation for engineering and science students.',
            source: 'DRDO',
            url: 'https://www.drdo.gov.in/',
            tag: 'Official',
            icon: Icons.security,
          ),
          ResourceItem(
            title: 'ISRO Internship',
            description:
                'Training and internship opportunities at ISRO centres for '
                'students in engineering and applied sciences.',
            source: 'ISRO',
            url: 'https://www.isro.gov.in/InternshipTraining.html',
            tag: 'Official',
            icon: Icons.satellite_alt_outlined,
          ),
          ResourceItem(
            title: 'BARC Internship',
            description:
                'Internship and training programs at the Bhabha Atomic '
                'Research Centre in nuclear science and engineering.',
            source: 'BARC',
            url: 'https://www.barc.gov.in/',
            tag: 'Official',
            icon: Icons.science_outlined,
          ),
          ResourceItem(
            title: 'IIT Internship Portals',
            description:
                'IIT career development cells run summer internship programs '
                'open to students from other colleges too.',
            source: 'IIT Bombay CDC',
            url: 'https://www.cdc.iitb.ac.in/',
            tag: 'Official',
            icon: Icons.account_balance_outlined,
          ),
          ResourceItem(
            title: 'NITI Aayog Internship',
            description: "Internships at India's policy think tank, working on "
                'research and government policy projects.',
            source: 'NITI Aayog',
            url: 'https://www.niti.gov.in/',
            tag: 'Official',
            icon: Icons.policy_outlined,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'International Organizations',
        items: [
          ResourceItem(
            title: 'UNICEF Internship',
            description:
                'Internships with the UN Children\'s Fund across research, '
                'communications, and program work worldwide.',
            source: 'UNICEF',
            url: 'https://www.unicef.org/careers/internships',
            tag: 'Official',
            icon: Icons.diversity_3_outlined,
          ),
          ResourceItem(
            title: 'WHO Internship',
            description:
                'Internships with the World Health Organization in public '
                'health, policy, and global health research.',
            source: 'WHO',
            url: 'https://www.who.int/careers/internship-programme',
            tag: 'Official',
            icon: Icons.health_and_safety_outlined,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Virtual Experience',
        items: [
          ResourceItem(
            title: 'Forage Virtual Internships',
            description:
                'Free job simulations from real companies (Deloitte, JPMorgan, '
                'and more) you can add to your resume.',
            source: 'Forage',
            url: 'https://www.theforage.com/',
            tag: 'Free',
            icon: Icons.laptop_mac_outlined,
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Certifications
  // ---------------------------------------------------------------------------
  static const ResourceHub certifications = ResourceHub(
    id: 'certifications',
    title: 'Certifications',
    subtitle: 'Industry-recognized credentials',
    icon: Icons.verified_outlined,
    accent: Color(0xFF14B8A6),
    intro: 'The right certificate signals job-ready skills. Prioritize free, '
        'recognized programs first, then specialize in cloud, data, or a '
        'platform relevant to your target role.',
    groups: [
      ResourceGroup(
        heading: 'Government',
        items: [
          ResourceItem(
            title: 'NPTEL Courses',
            description:
                'IIT/IISc certified courses across engineering and science. '
                'Government-backed and respected by Indian recruiters.',
            source: 'NPTEL',
            url: 'https://nptel.ac.in/courses',
            tag: 'Official',
            icon: Icons.account_balance,
          ),
          ResourceItem(
            title: 'SWAYAM',
            description:
                "Government of India's MOOC platform offering free courses "
                'from school level to postgraduate, with paid certification.',
            source: 'SWAYAM',
            url: 'https://swayam.gov.in/',
            tag: 'Freemium',
            icon: Icons.account_balance,
          ),
          ResourceItem(
            title: 'AICTE',
            description:
                'All India Council for Technical Education runs approved '
                'skilling and internship schemes recognized by AICTE colleges.',
            source: 'AICTE',
            url: 'https://www.aicte-india.org/',
            tag: 'Official',
            icon: Icons.account_balance,
          ),
          ResourceItem(
            title: 'IIT MOOCs',
            description:
                'Self-paced courses from IITs on edX, covering engineering, '
                'computer science, and management fundamentals.',
            source: 'IITBombayX / edX',
            url: 'https://www.edx.org/school/iitbombayx',
            tag: 'Freemium',
            icon: Icons.account_balance,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Technology',
        items: [
          ResourceItem(
            title: 'Google Career Certificates',
            description:
                'Job-ready certificates in Data Analytics, IT Support, UX, and '
                'Project Management on Coursera.',
            source: 'Google / Coursera',
            url: 'https://grow.google/certificates/',
            tag: 'Freemium',
            icon: Icons.g_mobiledata,
          ),
          ResourceItem(
            title: 'Microsoft Learn',
            description:
                'Free, self-paced learning paths across Azure, Power Platform, '
                'and Microsoft 365, with official certification exams.',
            source: 'Microsoft',
            url: 'https://learn.microsoft.com/en-us/training/',
            tag: 'Freemium',
            icon: Icons.window,
          ),
          ResourceItem(
            title: 'AWS Skill Builder',
            description:
                'Free and paid training for AWS certifications, starting with '
                'the foundational Cloud Practitioner path.',
            source: 'Amazon Web Services',
            url: 'https://skillbuilder.aws/',
            tag: 'Freemium',
            icon: Icons.cloud_outlined,
          ),
          ResourceItem(
            title: 'Azure Certifications',
            description: 'Official Microsoft Azure certification paths, from '
                'Fundamentals (AZ-900) to Solutions Architect Expert.',
            source: 'Microsoft',
            url:
                'https://learn.microsoft.com/en-us/credentials/certifications/browse/?products=azure',
            tag: 'Official',
            icon: Icons.cloud_outlined,
          ),
          ResourceItem(
            title: 'Oracle Academy',
            description: "Oracle's free program for database, Java, and cloud "
                'certifications for students and educators.',
            source: 'Oracle',
            url: 'https://academy.oracle.com/',
            tag: 'Free',
            icon: Icons.storage_outlined,
          ),
          ResourceItem(
            title: 'Cisco Networking Academy',
            description:
                'Free networking, cybersecurity, and IT courses, including the '
                'widely recognized CCNA certification path.',
            source: 'Cisco',
            url: 'https://www.netacad.com/',
            tag: 'Free',
            icon: Icons.router_outlined,
          ),
          ResourceItem(
            title: 'IBM SkillsBuild',
            description:
                'Free courses and badges in AI, cloud, cybersecurity, and data '
                'analytics, aimed at students and job seekers.',
            source: 'IBM',
            url: 'https://skillsbuild.org/',
            tag: 'Free',
            icon: Icons.developer_board,
          ),
          ResourceItem(
            title: 'Salesforce Trailhead',
            description:
                "Salesforce's free, gamified learning platform for CRM, "
                'admin, and developer certifications.',
            source: 'Salesforce',
            url: 'https://trailhead.salesforce.com/',
            tag: 'Free',
            icon: Icons.terrain_outlined,
          ),
          ResourceItem(
            title: 'Red Hat',
            description: 'Enterprise Linux and OpenShift training, with the '
                'industry-respected RHCSA/RHCE certifications.',
            source: 'Red Hat',
            url:
                'https://www.redhat.com/en/services/training-and-certification',
            tag: 'Paid',
            icon: Icons.terminal,
          ),
          ResourceItem(
            title: 'VMware',
            description:
                'Virtualization and cloud infrastructure certifications, '
                'widely recognized in enterprise IT roles.',
            source: 'VMware',
            url: 'https://www.vmware.com/learning/certification.html',
            tag: 'Paid',
            icon: Icons.dns_outlined,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Programming',
        items: [
          ResourceItem(
            title: 'freeCodeCamp Certifications',
            description:
                'Free, project-based certifications in web development, data '
                'analysis, and machine learning.',
            source: 'freeCodeCamp',
            url: 'https://www.freecodecamp.org/learn/',
            tag: 'Free',
            icon: Icons.code,
          ),
          ResourceItem(
            title: 'HackerRank',
            description:
                'Skill certification badges in programming languages, SQL, '
                'and problem solving, recognized by recruiters.',
            source: 'HackerRank',
            url: 'https://www.hackerrank.com/skills-verification',
            tag: 'Free',
            icon: Icons.code,
          ),
          ResourceItem(
            title: 'Codecademy',
            description: 'Interactive coding courses with a Pro-tier career '
                'certification track across web, data, and CS fundamentals.',
            source: 'Codecademy',
            url: 'https://www.codecademy.com/certificates',
            tag: 'Freemium',
            icon: Icons.code,
          ),
          ResourceItem(
            title: 'Coursera',
            description:
                'University and industry professional certificates across '
                'every domain, with financial aid available.',
            source: 'Coursera',
            url: 'https://www.coursera.org/professional-certificates',
            tag: 'Freemium',
            icon: Icons.menu_book,
          ),
          ResourceItem(
            title: 'edX',
            description:
                'University-backed courses and verified certificates from '
                'MIT, Harvard, and other top institutions.',
            source: 'edX',
            url: 'https://www.edx.org/certificates',
            tag: 'Freemium',
            icon: Icons.menu_book,
          ),
          ResourceItem(
            title: 'Udemy',
            description: 'Large marketplace of paid courses with completion '
                'certificates across programming, design, and business.',
            source: 'Udemy',
            url: 'https://www.udemy.com/courses/certification/',
            tag: 'Paid',
            icon: Icons.play_circle_outline,
          ),
          ResourceItem(
            title: 'Simplilearn',
            description:
                'Bootcamp-style certification courses in tech and management, '
                'often co-branded with universities.',
            source: 'Simplilearn',
            url: 'https://www.simplilearn.com/',
            tag: 'Paid',
            icon: Icons.school_outlined,
          ),
          ResourceItem(
            title: 'Great Learning',
            description:
                'Certificate and degree programs in data science, AI, and '
                'management, including free short courses.',
            source: 'Great Learning',
            url: 'https://www.mygreatlearning.com/',
            tag: 'Freemium',
            icon: Icons.school_outlined,
          ),
          ResourceItem(
            title: 'GeeksforGeeks',
            description:
                'Certification courses in DSA, web development, and CS '
                'fundamentals, alongside its free tutorials.',
            source: 'GeeksforGeeks',
            url: 'https://www.geeksforgeeks.org/courses/',
            tag: 'Freemium',
            icon: Icons.code,
          ),
        ],
      ),
      ResourceGroup(
        heading: 'AI & Data',
        items: [
          ResourceItem(
            title: 'DeepLearning.AI',
            description:
                "Andrew Ng's courses on deep learning, machine learning, and "
                'generative AI, with shareable certificates.',
            source: 'DeepLearning.AI',
            url: 'https://www.deeplearning.ai/',
            tag: 'Freemium',
            icon: Icons.psychology_outlined,
          ),
          ResourceItem(
            title: 'Kaggle Learn',
            description:
                'Free micro-courses and certificates in Python, ML, and deep '
                'learning, with hands-on notebooks.',
            source: 'Kaggle',
            url: 'https://www.kaggle.com/learn',
            tag: 'Free',
            icon: Icons.query_stats,
          ),
          ResourceItem(
            title: 'NVIDIA Deep Learning Institute',
            description:
                'Hands-on training and certification in GPU-accelerated '
                'computing, deep learning, and generative AI.',
            source: 'NVIDIA',
            url: 'https://www.nvidia.com/en-us/training/',
            tag: 'Paid',
            icon: Icons.memory,
          ),
          ResourceItem(
            title: 'DataCamp',
            description:
                'Interactive data science and analytics courses with a '
                'career-track certification for Python, R, and SQL.',
            source: 'DataCamp',
            url: 'https://www.datacamp.com/certification',
            tag: 'Freemium',
            icon: Icons.query_stats,
          ),
        ],
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Higher Studies
  // ---------------------------------------------------------------------------
  static const ResourceHub higherStudies = ResourceHub(
    id: 'higher_studies',
    title: 'Higher Studies',
    subtitle: 'GATE, GRE, MBA & abroad',
    icon: Icons.school_outlined,
    accent: Color(0xFF06B6D4),
    intro:
        'Planning a masters, MBA, or PG programme? Identify your target exam '
        'early — most need 3–12 months of preparation — and shortlist '
        'programs in parallel. Shown below: exams most relevant to your '
        'stream.',
    streamAware: true,
    groups: [
      ResourceGroup(
        heading: 'PCM — Engineering & Science',
        streamKey: StudentStream.pcm,
        items: [
          ResourceItem(
            title: 'GATE — Graduate Aptitude Test',
            description:
                'Gateway to M.Tech at IITs/NITs and PSU recruitment. Tests core '
                'engineering/science subjects.',
            source: 'IIT GATE',
            url: 'https://gate2026.iitg.ac.in/',
            tag: 'Official',
            icon: Icons.engineering_outlined,
            eligibility: "B.E./B.Tech/B.Sc (final year or graduate)",
            prepTimeline: '8–12 months',
          ),
          ResourceItem(
            title: 'CAT — MBA Admissions',
            description:
                'The main entrance for IIMs and top B-schools. Tests quant, '
                'verbal, and data interpretation.',
            source: 'IIM CAT',
            url: 'https://iimcat.ac.in/',
            tag: 'Official',
            icon: Icons.business_center_outlined,
            eligibility: "Bachelor's degree (any stream), min 50% marks",
            prepTimeline: '6–9 months',
          ),
          ResourceItem(
            title: 'GRE — General Test',
            description:
                'Required by most masters programs abroad, especially in the '
                'US. Tests verbal, quant, and analytical writing.',
            source: 'ETS',
            url: 'https://www.ets.org/gre.html',
            tag: 'Official',
            icon: Icons.language,
            eligibility: "Bachelor's degree or final-year student",
            prepTimeline: '2–4 months',
          ),
          ResourceItem(
            title: 'GMAT',
            description:
                'Preferred for MBA admissions abroad and at top Indian '
                'B-schools like ISB. Tests quant, verbal, and reasoning.',
            source: 'GMAC',
            url: 'https://www.mba.com/exams/gmat-exam',
            tag: 'Official',
            icon: Icons.insights,
            eligibility: "Bachelor's degree",
            prepTimeline: '3–5 months',
          ),
          ResourceItem(
            title: 'IIT JAM',
            description:
                'Gateway to M.Sc/integrated Ph.D at IITs and IISc in core '
                'sciences.',
            source: 'IIT JAM',
            url: 'https://jam.iitm.ac.in/',
            tag: 'Official',
            icon: Icons.science_outlined,
            eligibility: 'B.Sc/B.Tech in the relevant science subject',
            prepTimeline: '6–8 months',
          ),
          ResourceItem(
            title: 'CEED',
            description:
                'Entrance for M.Des at IITs/IISc — tests design aptitude, '
                'sketching, and visual reasoning.',
            source: 'IIT Bombay CEED',
            url: 'https://www.ceed.iitb.ac.in/',
            tag: 'Official',
            icon: Icons.design_services_outlined,
            eligibility: "Bachelor's degree/diploma in any discipline",
            prepTimeline: '4–6 months',
          ),
          ResourceItem(
            title: 'TOEFL iBT',
            description:
                'English proficiency test preferred by many US universities '
                'for admissions.',
            source: 'ETS',
            url: 'https://www.ets.org/toefl.html',
            tag: 'Official',
            icon: Icons.translate,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
          ResourceItem(
            title: 'IELTS',
            description:
                'English proficiency test accepted worldwide for admissions '
                'and visas.',
            source: 'British Council / IDP',
            url: 'https://www.ielts.org/',
            tag: 'Official',
            icon: Icons.record_voice_over_outlined,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'PCB — Medical & Life Sciences',
        streamKey: StudentStream.pcb,
        items: [
          ResourceItem(
            title: 'NEET PG',
            description:
                'Entrance for MD/MS and PG diploma courses at Indian medical '
                'colleges.',
            source: 'NBE',
            url: 'https://nbe.edu.in/',
            tag: 'Official',
            icon: Icons.local_hospital_outlined,
            eligibility: 'MBBS degree with completed internship',
            prepTimeline: '8–12 months',
          ),
          ResourceItem(
            title: 'AIAPGET',
            description: 'Entrance for MD/MS in Ayurveda, Unani, Siddha, and '
                'Homoeopathy PG courses.',
            source: 'NTA',
            url: 'https://exams.nta.ac.in/AIAPGET/',
            tag: 'Official',
            icon: Icons.spa_outlined,
            eligibility: 'BAMS/BUMS/BSMS/BHMS degree with internship',
            prepTimeline: '6–8 months',
          ),
          ResourceItem(
            title: 'GPAT',
            description:
                'Entrance for M.Pharm admissions and eligibility for pharmacy '
                'scholarships/stipends.',
            source: 'NTA',
            url: 'https://exams.nta.ac.in/GPAT/',
            tag: 'Official',
            icon: Icons.medication_outlined,
            eligibility: 'B.Pharm degree or final-year student',
            prepTimeline: '4–6 months',
          ),
          ResourceItem(
            title: 'GAT-B',
            description:
                'Entrance for M.Sc/Ph.D in Biotechnology at DBT-supported '
                'institutes, with fellowship funding.',
            source: 'Regional Centre for Biotechnology',
            url: 'https://rcb.res.in/',
            tag: 'Official',
            icon: Icons.biotech_outlined,
            eligibility: 'B.Sc/B.Tech/B.E. in Life Sciences or Biotechnology',
            prepTimeline: '4–6 months',
          ),
          ResourceItem(
            title: 'GRE — General Test',
            description:
                'Required by most masters programs abroad, especially in the '
                'US. Tests verbal, quant, and analytical writing.',
            source: 'ETS',
            url: 'https://www.ets.org/gre.html',
            tag: 'Official',
            icon: Icons.language,
            eligibility: "Bachelor's degree or final-year student",
            prepTimeline: '2–4 months',
          ),
          ResourceItem(
            title: 'TOEFL iBT',
            description:
                'English proficiency test preferred by many US universities '
                'for admissions.',
            source: 'ETS',
            url: 'https://www.ets.org/toefl.html',
            tag: 'Official',
            icon: Icons.translate,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
          ResourceItem(
            title: 'IELTS',
            description:
                'English proficiency test accepted worldwide for admissions '
                'and visas.',
            source: 'British Council / IDP',
            url: 'https://www.ielts.org/',
            tag: 'Official',
            icon: Icons.record_voice_over_outlined,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Commerce — Business & Finance',
        streamKey: StudentStream.commerce,
        items: [
          ResourceItem(
            title: 'CAT — MBA Admissions',
            description:
                'The main entrance for IIMs and top B-schools. Tests quant, '
                'verbal, and data interpretation.',
            source: 'IIM CAT',
            url: 'https://iimcat.ac.in/',
            tag: 'Official',
            icon: Icons.business_center_outlined,
            eligibility: "Bachelor's degree (any stream), min 50% marks",
            prepTimeline: '6–9 months',
          ),
          ResourceItem(
            title: 'XAT',
            description:
                'Entrance for XLRI and 150+ other B-schools, known for its '
                'analytical and decision-making section.',
            source: 'XLRI',
            url: 'https://xatonline.in/',
            tag: 'Official',
            icon: Icons.account_balance_outlined,
            eligibility: "Bachelor's degree in any discipline",
            prepTimeline: '6–9 months',
          ),
          ResourceItem(
            title: 'MAT',
            description:
                'Widely accepted MBA entrance conducted multiple times a '
                'year — a good backup to CAT/XAT.',
            source: 'AIMA',
            url: 'https://mat.aima.in/',
            tag: 'Official',
            icon: Icons.calculate_outlined,
            eligibility: "Bachelor's degree in any discipline",
            prepTimeline: '3–4 months',
          ),
          ResourceItem(
            title: 'CMAT',
            description:
                'NTA-conducted MBA entrance accepted by AICTE-approved '
                'B-schools nationwide.',
            source: 'NTA',
            url: 'https://exams.nta.ac.in/CMAT/',
            tag: 'Official',
            icon: Icons.school_outlined,
            eligibility: "Bachelor's degree in any discipline",
            prepTimeline: '3–4 months',
          ),
          ResourceItem(
            title: 'SNAP',
            description:
                "Entrance for Symbiosis Institutes' MBA programs across "
                'India.',
            source: 'Symbiosis International',
            url: 'https://snaptest.org/',
            tag: 'Official',
            icon: Icons.trending_up,
            eligibility: "Bachelor's degree with min 50% marks",
            prepTimeline: '4–5 months',
          ),
          ResourceItem(
            title: 'GMAT',
            description:
                'Preferred for MBA admissions abroad and at top Indian '
                'B-schools like ISB. Tests quant, verbal, and reasoning.',
            source: 'GMAC',
            url: 'https://www.mba.com/exams/gmat-exam',
            tag: 'Official',
            icon: Icons.insights,
            eligibility: "Bachelor's degree",
            prepTimeline: '3–5 months',
          ),
          ResourceItem(
            title: 'CFA',
            description:
                'Global finance credential for careers in investment banking, '
                'equity research, and portfolio management.',
            source: 'CFA Institute',
            url: 'https://www.cfainstitute.org/en/programs/cfa',
            tag: 'Official',
            icon: Icons.currency_exchange,
            eligibility: "Bachelor's degree or final-year student (Level I)",
            prepTimeline: '6+ months per level',
          ),
          ResourceItem(
            title: 'FRM',
            description:
                'Globally recognized certification for risk management '
                'careers in banking and finance.',
            source: 'GARP',
            url: 'https://www.garp.org/frm',
            tag: 'Official',
            icon: Icons.shield_outlined,
            eligibility: 'Open to all; bachelor\'s recommended',
            prepTimeline: '4–6 months per part',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Humanities — Law, Arts & Design',
        streamKey: StudentStream.humanities,
        items: [
          ResourceItem(
            title: 'CUET PG',
            description: 'Common entrance for master\'s programs at central '
                'universities across India.',
            source: 'NTA',
            url: 'https://exams.nta.ac.in/CUET-PG/',
            tag: 'Official',
            icon: Icons.menu_book_outlined,
            eligibility: "Bachelor's degree in the relevant discipline",
            prepTimeline: '3–5 months',
          ),
          ResourceItem(
            title: 'CLAT PG',
            description:
                'Entrance for LLM programs at National Law Universities.',
            source: 'Consortium of NLUs',
            url: 'https://consortiumofnlus.ac.in/',
            tag: 'Official',
            icon: Icons.gavel_outlined,
            eligibility: 'LLB/law degree',
            prepTimeline: '4–6 months',
          ),
          ResourceItem(
            title: 'UGC NET',
            description:
                'Qualifies candidates for Assistant Professor roles and JRF '
                'fellowships in Indian universities.',
            source: 'UGC / NTA',
            url: 'https://ugcnet.nta.nic.in/',
            tag: 'Official',
            icon: Icons.workspace_premium_outlined,
            eligibility: "Master's degree with min 55% marks",
            prepTimeline: '4–6 months',
          ),
          ResourceItem(
            title: 'GRE — General Test',
            description:
                'Required by most masters programs abroad, especially in the '
                'US. Tests verbal, quant, and analytical writing.',
            source: 'ETS',
            url: 'https://www.ets.org/gre.html',
            tag: 'Official',
            icon: Icons.language,
            eligibility: "Bachelor's degree or final-year student",
            prepTimeline: '2–4 months',
          ),
          ResourceItem(
            title: 'IELTS',
            description:
                'English proficiency test accepted worldwide for admissions '
                'and visas.',
            source: 'British Council / IDP',
            url: 'https://www.ielts.org/',
            tag: 'Official',
            icon: Icons.record_voice_over_outlined,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
          ResourceItem(
            title: 'TOEFL iBT',
            description:
                'English proficiency test preferred by many US universities '
                'for admissions.',
            source: 'ETS',
            url: 'https://www.ets.org/toefl.html',
            tag: 'Official',
            icon: Icons.translate,
            eligibility: 'Open to all; no formal eligibility',
            prepTimeline: '1–2 months',
          ),
        ],
      ),
      ResourceGroup(
        heading: 'Funding',
        items: [
          ResourceItem(
            title: 'Vidya Lakshmi Education Loans',
            description:
                'Government portal to compare and apply for education loans '
                'from multiple banks in one place.',
            source: 'Govt. of India',
            url: 'https://www.vidyalakshmi.co.in/',
            tag: 'Official',
            icon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    ],
  );

  /// All hubs, for any screen that wants to list them.
  static const List<ResourceHub> all = [
    codingDsa,
    placement,
    internships,
    certifications,
    higherStudies,
  ];
}

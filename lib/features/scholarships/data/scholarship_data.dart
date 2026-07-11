import 'package:flutter/material.dart';

import '../models/scholarship.dart';

/// Curated catalogue of major Indian scholarships — government (central +
/// state) and private. In production this would be served from the
/// `/scholarships` Firestore collection (read-only to clients per the
/// security rules); the static list keeps the MVP self-contained and
/// offline-capable.
///
/// Amounts, dates and eligibility figures are indicative — always shown with
/// a "confirm on the official website" disclaimer on the details page, since
/// real cycles/criteria change year to year and this dataset isn't wired to
/// a live feed.
class ScholarshipData {
  ScholarshipData._();

  static final List<Scholarship> all = [
    // ── Government · Central ──────────────────────────────────────────────
    Scholarship(
      id: 'nsp_pre_matric',
      title: 'Pre-Matric Scholarship',
      organization: 'National Scholarship Portal (NSP)',
      provider: ScholarshipProvider.government,
      icon: Icons.menu_book_rounded,
      maxFamilyIncome: 250000,
      eligibility:
          'Class 9–10 students from minority / SC / ST / OBC families.',
      description:
          'A central sector scheme to support students from Class 9 and 10 '
          'belonging to SC, ST, OBC and minority communities, and children '
          'of manual scavengers, in continuing their school education without '
          'dropping out due to financial constraints.',
      benefits: [
        'Covers admission and tuition fees',
        'Maintenance allowance for day scholars and hostellers',
        'Additional allowance for students with disabilities',
      ],
      amount: 'Up to ₹10,000 / year',
      deadline: '31 Oct 2026',
      applicationOpenDate: DateTime(2026, 8, 1),
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Aadhaar Card',
        'Previous year marksheet',
        'Income Certificate',
        'Caste/Category Certificate',
        'Bank passbook (Aadhaar-linked)',
      ],
      selectionProcess:
          'Merit-cum-means basis on documents submitted via the NSP portal; '
          'no separate entrance exam.',
      renewalRules: 'Renewed each year on minimum 75% attendance and passing '
          'the previous class.',
      categoryEligibility: ['SC', 'ST', 'OBC', 'Minority'],
      classLevels: ['Class 10'],
      incomeBased: true,
      tags: ['Class 9', 'Class 10', 'Income based'],
    ),
    Scholarship(
      id: 'nsp_post_matric',
      title: 'Post-Matric Scholarship',
      organization: 'National Scholarship Portal (NSP)',
      provider: ScholarshipProvider.government,
      icon: Icons.menu_book_rounded,
      maxFamilyIncome: 250000,
      eligibility: 'Class 11 onwards for SC / ST / OBC / minority students.',
      description:
          'Central sector scheme supporting SC/ST/OBC/minority students from '
          'Class 11 through postgraduate studies with tuition reimbursement '
          'and a monthly maintenance allowance.',
      benefits: [
        'Full tuition fee reimbursement',
        'Monthly maintenance allowance',
        'Additional study/reader allowance for disabled students',
      ],
      amount: 'Tuition + ₹1,200 / month',
      deadline: '15 Nov 2026',
      applicationOpenDate: DateTime(2026, 8, 1),
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Aadhaar Card',
        'Previous year marksheet',
        'Income Certificate',
        'Caste/Category Certificate',
        'Institution fee receipt',
        'Bank passbook (Aadhaar-linked)',
      ],
      selectionProcess:
          'Merit-cum-means basis via NSP; institution verifies and forwards '
          'applications for disbursal.',
      renewalRules:
          'Renewed yearly on regular attendance and passing the previous year.',
      categoryEligibility: ['SC', 'ST', 'OBC', 'Minority'],
      classLevels: ['Class 12', 'UG', 'PG'],
      incomeBased: true,
      tags: ['Class 11', 'Class 12', 'Income based'],
    ),
    Scholarship(
      id: 'nmms',
      title: 'National Means-cum-Merit Scholarship (NMMS)',
      organization: 'Ministry of Education',
      provider: ScholarshipProvider.government,
      icon: Icons.stars_rounded,
      maxFamilyIncome: 350000,
      minPercentage: 55,
      eligibility: 'Class 8 students clearing the NMMS state exam.',
      description:
          'Awarded to meritorious students of economically weaker sections to '
          'arrest their drop-out at the Class 8 stage and encourage them to '
          'continue education up to Class 12, via a state-level selection '
          'test (MAT + SAT).',
      benefits: [
        'Fixed scholarship amount paid directly to the student',
        'Continues from Class 9 through Class 12 subject to renewal',
      ],
      amount: '₹12,000 / year',
      deadline: '30 Sep 2026',
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Class 7 marksheet',
        'Income Certificate',
        'Aadhaar Card',
        'Bank passbook',
      ],
      selectionProcess:
          'State-conducted NMMS Selection Test (Mental Ability Test + '
          'Scholastic Aptitude Test); merit list published state-wise.',
      renewalRules:
          'Renewed yearly on minimum 55% marks (50% for SC/ST) and 75% '
          'attendance.',
      classLevels: ['Class 10', 'Class 12'],
      meritBased: true,
      incomeBased: true,
      tags: ['Class 8', 'Merit', 'Income based'],
    ),
    Scholarship(
      id: 'inspire_she',
      title: 'INSPIRE SHE Scholarship',
      organization: 'Department of Science & Technology',
      provider: ScholarshipProvider.government,
      icon: Icons.science_rounded,
      minPercentage: 90,
      eligibility:
          'Top 1% in Class 12 boards pursuing B.Sc / Int. M.Sc in sciences.',
      description:
          'Innovation in Science Pursuit for Inspired Research (INSPIRE) '
          'Scholarship for Higher Education — identifies and nurtures talent '
          'in basic and natural sciences among top-performing Class 12 '
          'students who enrol in a science degree.',
      benefits: [
        'Annual scholarship for the full duration of the science degree',
        'Eligibility for INSPIRE Fellowship for a subsequent PhD',
      ],
      amount: '₹80,000 / year',
      deadline: '31 Dec 2026',
      applyUrl: 'https://online-inspire.gov.in',
      requiredDocuments: [
        'Class 12 marksheet',
        'Admission proof for B.Sc/Integrated M.Sc',
        'Aadhaar Card',
        'Bank passbook',
      ],
      selectionProcess:
          'Automatic eligibility for top 1% board rankers, or via the state-'
          'level exam merit list / national exams (JEE, NEET) top rankers who '
          'take up science.',
      renewalRules: 'Renewed yearly on maintaining 60%+ aggregate in the '
          'science degree.',
      classLevels: ['Class 12', 'UG'],
      meritBased: true,
      tags: ['Class 12', 'Science', 'Merit'],
    ),
    Scholarship(
      id: 'pm_yasasvi',
      title: 'PM YASASVI Scholarship',
      organization: 'Ministry of Social Justice',
      provider: ScholarshipProvider.government,
      icon: Icons.diversity_3_rounded,
      maxFamilyIncome: 250000,
      eligibility: 'OBC / EBC / DNT students of Class 9 and 11.',
      description:
          'Young Achievers\' Scholarship Award Scheme for Vibrant India '
          '(YASASVI) supports OBC, EBC and DNT (De-notified, Nomadic and '
          'Semi-Nomadic Tribes) students through a national entrance test for '
          'Class 9 and Class 11 admissions into top schools, plus a top-class '
          'scheme for higher education.',
      benefits: [
        'Full school/hostel fee coverage for selected Class 9/11 entrants',
        'Top-Class scholarship for undergraduate study at listed institutes',
      ],
      amount: 'Up to ₹1,25,000 / year',
      deadline: '20 Oct 2026',
      applyUrl: 'https://yet.nta.ac.in',
      requiredDocuments: [
        'Caste Certificate (OBC/EBC/DNT)',
        'Income Certificate',
        'Previous marksheet',
        'Aadhaar Card',
      ],
      selectionProcess:
          'National-level YASASVI Entrance Test (YET) conducted by NTA; '
          'merit-based selection.',
      renewalRules: 'Renewed yearly on satisfactory academic performance.',
      categoryEligibility: ['OBC', 'EWS'],
      classLevels: ['Class 10', 'Class 12'],
      incomeBased: true,
      tags: ['Class 9', 'Class 11', 'Income based'],
    ),
    Scholarship(
      id: 'pm_usp',
      title: 'PM-USP Central Sector Scholarship',
      organization: 'Department of Higher Education',
      provider: ScholarshipProvider.government,
      icon: Icons.account_balance_rounded,
      minPercentage: 80,
      eligibility:
          'Top 20 percentile Class 12 passouts joining UG/professional '
          'courses; family income under ₹4.5L.',
      description:
          'Pradhan Mantri Uchchatar Shiksha Protsahan (PM-USP) Yojana — the '
          'umbrella central scheme (encompassing the earlier Central Sector '
          'Scheme of Scholarship) for meritorious students from low-income '
          'families to pursue college education without financial worry.',
      benefits: [
        'Scholarship for the full duration of the degree',
        'Higher amount in the first three years, reduced slightly for the '
            'final year',
      ],
      amount: '₹20,000 / year',
      deadline: '31 Oct 2026',
      applicationOpenDate: DateTime(2026, 8, 1),
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'College admission/bonafide certificate',
        'Aadhaar-linked bank passbook',
      ],
      selectionProcess:
          'Automatic shortlisting by Class 12 board percentile; no separate '
          'exam.',
      renewalRules: 'Renewed yearly on 50%+ aggregate and regular attendance.',
      maxFamilyIncome: 450000,
      classLevels: ['UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Undergraduate', 'Merit', 'Income based'],
    ),
    Scholarship(
      id: 'csss',
      title: 'Central Sector Scheme of Scholarship (CSSS)',
      organization: 'Department of Higher Education',
      provider: ScholarshipProvider.government,
      icon: Icons.account_balance_rounded,
      minPercentage: 80,
      eligibility: 'Top 20 percentile Class 12 passouts; income under ₹4.5L.',
      description:
          'Predecessor/parallel scheme to PM-USP, still referenced widely — '
          'grants scholarships to meritorious students from families with '
          'modest income to meet a part of their day-to-day expenses while '
          'pursuing higher studies.',
      benefits: [
        'Fixed annual scholarship for degree duration',
        'Direct bank transfer, no separate renewal exam',
      ],
      amount: '₹10,000 / year',
      deadline: '31 Oct 2026',
      applicationOpenDate: DateTime(2026, 8, 1),
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'College bonafide certificate',
      ],
      selectionProcess: 'Merit list by Class 12 board percentile, via NSP.',
      renewalRules: 'Renewed yearly on 50%+ aggregate.',
      maxFamilyIncome: 450000,
      classLevels: ['UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Undergraduate', 'Merit', 'Income based'],
    ),
    Scholarship(
      id: 'nsp_portal',
      title: 'National Scholarship Portal — All Central & State Schemes',
      organization: 'Ministry of Electronics & IT / DoSJE',
      provider: ScholarshipProvider.government,
      icon: Icons.hub_rounded,
      eligibility:
          'One-stop portal aggregating 50+ central and state scholarship '
          'schemes for Class 1 through PhD.',
      description:
          'The National Scholarship Portal (NSP) is a one-stop platform where '
          'students can discover, apply for and track disbursal of nearly all '
          'central and most state government scholarships — including all '
          'NSP-hosted entries in this list — through a single registration.',
      benefits: [
        'Single application for multiple eligible schemes',
        'Direct benefit transfer (DBT) to the student\'s bank account',
      ],
      amount: 'Varies by scheme',
      deadline: 'Rolling',
      applyUrl: 'https://scholarships.gov.in',
      selectionProcess: 'Varies by the specific scheme applied for.',
      classLevels: ['Class 10', 'Class 12', 'UG', 'PG'],
      tags: ['All classes', 'Portal'],
    ),
    Scholarship(
      id: 'aicte_saksham',
      title: 'AICTE Saksham Scholarship',
      organization: 'AICTE',
      provider: ScholarshipProvider.government,
      icon: Icons.accessible_forward_rounded,
      wikipediaTitle: 'en:All India Council for Technical Education',
      eligibility:
          'Specially-abled (40%+ disability) students in AICTE-approved '
          'technical diploma/degree programs.',
      description:
          'Supports specially-abled students pursuing technical education so '
          'that a disability never becomes a barrier to an engineering or '
          'technical degree.',
      benefits: [
        'Full tuition fee reimbursement (up to a cap)',
        'Additional allowance for books and incidentals',
      ],
      amount: '₹50,000 / year',
      deadline: '15 Jan 2027',
      applicationOpenDate: DateTime(2026, 9, 1),
      applyUrl: 'https://www.aicte-india.org',
      requiredDocuments: [
        'Disability Certificate (40%+)',
        'Class 12/diploma marksheet',
        'Admission proof',
        'Income Certificate',
      ],
      selectionProcess: 'Merit-cum-eligibility basis via AICTE\'s portal.',
      renewalRules: 'Renewed yearly on passing the previous year.',
      disabledOnly: true,
      classLevels: ['UG'],
      tags: ['Undergraduate', 'Disability', 'Technical'],
    ),
    Scholarship(
      id: 'aicte_swanath',
      title: 'AICTE Swanath Scholarship',
      organization: 'AICTE',
      provider: ScholarshipProvider.government,
      icon: Icons.family_restroom_rounded,
      wikipediaTitle: 'en:All India Council for Technical Education',
      eligibility:
          'Orphan students, or those who lost a parent, in AICTE-approved '
          'technical programs.',
      description:
          'A welfare scheme for orphan students (including those who lost '
          'parents to COVID-19) studying in AICTE-approved technical diploma '
          'or degree institutions.',
      benefits: [
        'Tuition fee support',
        'Priority processing for COVID-orphaned applicants',
      ],
      amount: '₹50,000 / year',
      deadline: '15 Jan 2027',
      applicationOpenDate: DateTime(2026, 9, 1),
      applyUrl: 'https://www.aicte-india.org',
      requiredDocuments: [
        'Death certificate of parent(s)',
        'Class 12/diploma marksheet',
        'Admission proof',
        'Guardian/orphanage certificate (if applicable)',
      ],
      selectionProcess: 'Eligibility-based selection via AICTE\'s portal.',
      renewalRules: 'Renewed yearly on passing the previous year.',
      classLevels: ['UG'],
      tags: ['Undergraduate', 'Technical'],
    ),
    Scholarship(
      id: 'ugc_pg_scholarship',
      title: 'UGC PG Scholarship for University Rank Holders',
      organization: 'University Grants Commission (UGC)',
      provider: ScholarshipProvider.government,
      icon: Icons.school_rounded,
      wikipediaTitle: 'en:University Grants Commission (India)',
      minPercentage: 60,
      eligibility:
          'First/second rank holders at the UG level pursuing a regular PG '
          'course.',
      description:
          'Recognises university-level academic excellence by supporting the '
          'top two rank holders of each recognised university\'s UG '
          'convocation as they pursue postgraduate studies.',
      benefits: ['Monthly scholarship for two years of PG study'],
      amount: '₹3,100 / month',
      deadline: '31 Oct 2026',
      applyUrl: 'https://www.ugc.gov.in',
      requiredDocuments: [
        'UG rank certificate from the university',
        'PG admission proof',
        'Bank passbook',
      ],
      selectionProcess: 'Nominated by the university based on UG rank.',
      renewalRules: 'Continues into the second PG year on satisfactory '
          'performance.',
      classLevels: ['PG'],
      meritBased: true,
      tags: ['Postgraduate', 'Merit'],
    ),
    Scholarship(
      id: 'pmss',
      title: "Prime Minister's Scholarship Scheme (PMSS)",
      organization: 'Kendriya Sainik Board / Ministry of Defence',
      provider: ScholarshipProvider.government,
      icon: Icons.military_tech_rounded,
      eligibility: 'Wards of ex-servicemen, serving personnel, and CAPF/police '
          'personnel, pursuing professional degrees.',
      description:
          'Honours the service of India\'s armed and paramilitary forces by '
          'funding professional degree education (engineering, medical, MBA, '
          'and more) for the wards of serving and ex-servicemen.',
      benefits: [
        'Fixed monthly scholarship for the full degree duration',
        'Separate quota/scheme streams for Army, Navy, Air Force and CAPF '
            'wards',
      ],
      amount: '₹2,500 – ₹3,000 / month',
      deadline: '30 Oct 2026',
      applyUrl: 'https://ksb.gov.in',
      requiredDocuments: [
        'Service/discharge certificate of parent',
        'Class 12 marksheet',
        'Admission proof for professional course',
      ],
      selectionProcess: 'Merit list among applicants from defence/CAPF '
          'families, via the respective service\'s portal.',
      renewalRules: 'Renewed yearly on passing the previous year.',
      classLevels: ['UG'],
      tags: ['Undergraduate', 'Professional courses'],
    ),
    Scholarship(
      id: 'pm_cares',
      title: 'PM CARES for Children Scholarship',
      organization: 'PM CARES Fund',
      provider: ScholarshipProvider.government,
      icon: Icons.favorite_rounded,
      eligibility:
          'Children who lost both parents/legal guardian/surviving parent to '
          'COVID-19, from Class 1 through graduation.',
      description:
          'Ensures comprehensive support — school and higher education fees, '
          'a monthly stipend from age 18, and a lump sum at age 23 — for '
          'children orphaned by the COVID-19 pandemic, administered together '
          'with state welfare departments.',
      benefits: [
        'School/college fees covered end-to-end',
        'Monthly stipend from age 18',
        'Health insurance cover under Ayushman Bharat',
        'Lump-sum corpus of ₹10 lakh at age 23',
      ],
      amount: 'Full education support',
      deadline: 'Rolling',
      applyUrl: 'https://pmcaresforchildren.in',
      requiredDocuments: [
        'Death certificate(s) of parent(s)/guardian',
        'Guardian/custody proof',
        'Aadhaar Card',
      ],
      selectionProcess:
          'District Child Protection Unit identifies and registers eligible '
          'children on the PM CARES portal.',
      classLevels: ['Class 10', 'Class 12', 'UG', 'PG'],
      tags: ['All classes'],
    ),
    Scholarship(
      id: 'ishan_uday',
      title: 'Ishan Uday Special Scholarship Scheme',
      organization: 'Ministry of Education',
      provider: ScholarshipProvider.government,
      icon: Icons.terrain_rounded,
      states: [
        'Assam',
        'Arunachal Pradesh',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Sikkim',
        'Tripura',
      ],
      maxFamilyIncome: 450000,
      eligibility:
          'Students domiciled in the North Eastern Region joining UG courses '
          'anywhere in India.',
      description:
          'Encourages students from the eight North Eastern states to pursue '
          'undergraduate education across India by covering tuition and '
          'monthly maintenance costs.',
      benefits: [
        'Full tuition fee reimbursement',
        'Monthly maintenance allowance',
      ],
      amount: '₹5,000 / month',
      deadline: '31 Oct 2026',
      applyUrl: 'https://scholarships.gov.in',
      requiredDocuments: [
        'Domicile Certificate (NE state)',
        'Class 12 marksheet',
        'Income Certificate',
        'College admission proof',
      ],
      selectionProcess: 'Merit-cum-means basis via NSP.',
      renewalRules: 'Renewed yearly on regular attendance and passing.',
      classLevels: ['UG'],
      incomeBased: true,
      tags: ['Undergraduate', 'Income based', 'State'],
    ),
    Scholarship(
      id: 'merit_cum_means_technical',
      title: 'Central Sector Merit-cum-Means Scholarship',
      organization: 'AICTE',
      provider: ScholarshipProvider.government,
      icon: Icons.engineering_rounded,
      wikipediaTitle: 'en:All India Council for Technical Education',
      maxFamilyIncome: 450000,
      minPercentage: 50,
      eligibility:
          'Meritorious students from low-income families in professional/'
          'technical UG courses.',
      description:
          'Supports economically weaker but academically strong students '
          'pursuing AICTE-approved professional and technical degree '
          'programs with full fee reimbursement.',
      benefits: [
        'Full tuition fee reimbursement (up to ₹20,000/year)',
        'Additional maintenance allowance for hostellers',
      ],
      amount: 'Tuition + ₹2,000 / month',
      deadline: '15 Jan 2027',
      applyUrl: 'https://www.aicte-india.org',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'Admission proof',
      ],
      selectionProcess: 'Merit-cum-means basis via AICTE\'s portal.',
      renewalRules: 'Renewed yearly on 50%+ aggregate.',
      classLevels: ['UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Undergraduate', 'Merit', 'Income based', 'Technical'],
    ),

    // ── Government · State ────────────────────────────────────────────────
    Scholarship(
      id: 'mh_mahadbt',
      title: 'MahaDBT Scholarship',
      organization: 'Government of Maharashtra',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Maharashtra'],
      maxFamilyIncome: 800000,
      eligibility: 'Maharashtra-domiciled students, post-matric.',
      description:
          'Maharashtra\'s unified DBT (Direct Benefit Transfer) portal for '
          'all state post-matric scholarship and freeship schemes across '
          'categories.',
      benefits: ['Tuition fee waiver/reimbursement', 'Maintenance allowance'],
      amount: 'Tuition + maintenance',
      deadline: '30 Nov 2026',
      applyUrl: 'https://mahadbt.maharashtra.gov.in',
      requiredDocuments: [
        'Domicile Certificate (Maharashtra)',
        'Income Certificate',
        'Caste Certificate (if applicable)',
        'Previous marksheet',
      ],
      selectionProcess: 'Eligibility-based, verified by the college via '
          'MahaDBT.',
      classLevels: ['Class 12', 'UG'],
      incomeBased: true,
      tags: ['State', 'Class 11', 'Class 12'],
    ),
    Scholarship(
      id: 'up_scholarship',
      title: 'UP Scholarship',
      organization: 'Government of Uttar Pradesh',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Uttar Pradesh'],
      maxFamilyIncome: 200000,
      eligibility: 'UP-domiciled pre- and post-matric students.',
      description:
          'Uttar Pradesh\'s state scholarship scheme for SC/ST/OBC/General/'
          'minority students at both the pre-matric and post-matric stages.',
      benefits: ['Tuition fee reimbursement', 'Maintenance allowance'],
      amount: 'Tuition + fees',
      deadline: '31 Oct 2026',
      applyUrl: 'https://scholarship.up.gov.in',
      requiredDocuments: [
        'Domicile Certificate (UP)',
        'Income Certificate',
        'Caste Certificate (if applicable)',
      ],
      selectionProcess: 'Eligibility-based via the state scholarship portal.',
      classLevels: ['Class 10', 'Class 12'],
      incomeBased: true,
      tags: ['State', 'Income based'],
    ),
    Scholarship(
      id: 'kar_epass',
      title: 'ePASS Karnataka',
      organization: 'Government of Karnataka',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Karnataka'],
      maxFamilyIncome: 250000,
      eligibility: 'Karnataka SC/ST/OBC post-matric students.',
      description: 'Karnataka\'s Electronic Payment and Application System of '
          'Scholarships (ePASS) for post-matric SC/ST/OBC/minority students, '
          'covering tuition and hostel/maintenance costs.',
      benefits: ['Tuition fee reimbursement', 'Hostel/maintenance allowance'],
      amount: 'Tuition + maintenance',
      deadline: '28 Feb 2027',
      applyUrl: 'https://ssp.postmatric.karnataka.gov.in',
      requiredDocuments: [
        'Caste Certificate',
        'Income Certificate',
        'Domicile Certificate (Karnataka)',
      ],
      selectionProcess: 'Eligibility-based via the ePASS portal.',
      categoryEligibility: ['SC', 'ST', 'OBC'],
      classLevels: ['UG'],
      incomeBased: true,
      tags: ['State', 'Income based'],
    ),
    Scholarship(
      id: 'bihar_scholarship',
      title: 'Bihar Post Matric Scholarship',
      organization: 'Government of Bihar',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Bihar'],
      maxFamilyIncome: 250000,
      eligibility: 'Bihar-domiciled post-matric SC/ST/OBC/EBC students.',
      description:
          'Bihar\'s post-matric scholarship for SC, ST, OBC and Economically '
          'Backward Class students, applied for via the state\'s dedicated '
          'scholarship portal.',
      benefits: ['Tuition reimbursement', 'Maintenance allowance'],
      amount: 'Tuition + maintenance',
      deadline: '30 Nov 2026',
      applyUrl: 'https://state.bih.nic.in',
      requiredDocuments: [
        'Domicile Certificate (Bihar)',
        'Caste Certificate',
        'Income Certificate',
      ],
      selectionProcess: 'Eligibility-based via the state portal.',
      categoryEligibility: ['SC', 'ST', 'OBC', 'EWS'],
      classLevels: ['Class 12', 'UG'],
      incomeBased: true,
      tags: ['State', 'Income based'],
    ),
    Scholarship(
      id: 'delhi_scholarship',
      title: 'Delhi Government Merit Scholarship',
      organization: 'Government of NCT of Delhi',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Delhi'],
      minPercentage: 60,
      eligibility: 'Delhi-domiciled meritorious Class 12 passouts.',
      description:
          'Merit scholarship (including the Dr. B.R. Ambedkar Scheme) for '
          'Delhi-domiciled students securing high marks in Class 12 boards '
          'and continuing into undergraduate study.',
      benefits: [
        'One-time/annual merit award',
        'Fee reimbursement for SC/ST '
            'students under the Ambedkar scheme'
      ],
      amount: 'Up to ₹24,000 / year',
      deadline: '31 Dec 2026',
      applyUrl: 'https://edudel.nic.in',
      requiredDocuments: [
        'Domicile Certificate (Delhi)',
        'Class 12 marksheet',
      ],
      selectionProcess: 'Merit list by Class 12 board percentage.',
      classLevels: ['Class 12', 'UG'],
      meritBased: true,
      tags: ['State', 'Merit'],
    ),
    Scholarship(
      id: 'rajasthan_scholarship',
      title: 'Rajasthan SJE Scholarship',
      organization: 'Social Justice & Empowerment Dept., Rajasthan',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Rajasthan'],
      maxFamilyIncome: 250000,
      eligibility: 'Rajasthan-domiciled SC/ST/OBC/EWS/minority students.',
      description: 'Rajasthan\'s Social Justice and Empowerment Department '
          'scholarship covering pre- and post-matric students across '
          'reserved categories, applied for through the SJMS portal.',
      benefits: ['Tuition reimbursement', 'Maintenance allowance'],
      amount: 'Tuition + maintenance',
      deadline: '31 Oct 2026',
      applyUrl: 'https://sso.rajasthan.gov.in',
      requiredDocuments: [
        'Domicile Certificate (Rajasthan)',
        'Caste Certificate',
        'Income Certificate',
      ],
      selectionProcess: 'Eligibility-based via the SJMS/SSO portal.',
      categoryEligibility: ['SC', 'ST', 'OBC', 'EWS', 'Minority'],
      classLevels: ['Class 10', 'Class 12', 'UG'],
      incomeBased: true,
      tags: ['State', 'Income based'],
    ),
    Scholarship(
      id: 'tn_scholarship',
      title: 'Tamil Nadu e-Grantz Scholarship',
      organization: 'Government of Tamil Nadu',
      provider: ScholarshipProvider.government,
      icon: Icons.location_city_rounded,
      states: ['Tamil Nadu'],
      maxFamilyIncome: 250000,
      eligibility: 'Tamil Nadu-domiciled post-matric students.',
      description:
          'Tamil Nadu\'s e-Grantz platform disburses post-matric scholarships '
          'to SC/ST/MBC/BC/minority students studying in the state.',
      benefits: ['Tuition fee reimbursement', 'Maintenance allowance'],
      amount: 'Tuition + maintenance',
      deadline: '30 Jun 2026',
      applyUrl: 'https://tnegrantz.tn.gov.in',
      requiredDocuments: [
        'Domicile Certificate (Tamil Nadu)',
        'Community Certificate',
        'Income Certificate',
      ],
      selectionProcess: 'Eligibility-based via the e-Grantz portal.',
      classLevels: ['Class 12', 'UG'],
      incomeBased: true,
      tags: ['State', 'Income based'],
    ),

    // ── Private ──────────────────────────────────────────────────────────
    Scholarship(
      id: 'kvpy_now_inspire',
      title: 'Reliance Foundation Scholarship',
      organization: 'Reliance Foundation',
      provider: ScholarshipProvider.private,
      icon: Icons.bolt_rounded,
      wikipediaTitle: 'en:Reliance Foundation',
      maxFamilyIncome: 1500000,
      eligibility: 'Undergraduate students across India; merit + need based.',
      description:
          'Supports high-achieving undergraduate students from across India '
          '— including the Reliance Foundation Undergraduate and '
          'Postgraduate Scholarships — with financial aid plus mentorship '
          'and networking opportunities.',
      benefits: [
        'One-time or annual scholarship',
        'Access to Reliance Foundation mentorship programs',
      ],
      amount: 'Up to ₹2,00,000',
      deadline: '30 Nov 2026',
      applyUrl: 'https://www.reliancefoundation.org',
      requiredDocuments: [
        'Class 12 marksheet',
        'College admission proof',
        'Income proof',
      ],
      selectionProcess:
          'Online application, academic merit review, followed by shortlist '
          'verification.',
      renewalRules: 'Some tracks renew yearly on maintaining academic '
          'standing.',
      classLevels: ['UG'],
      meritBased: true,
      tags: ['Undergraduate', 'Merit'],
    ),
    Scholarship(
      id: 'tata_trust',
      title: 'Tata Trusts Education Grant',
      organization: 'Tata Trusts',
      provider: ScholarshipProvider.private,
      icon: Icons.business_rounded,
      wikipediaTitle: 'en:Tata Trusts',
      maxFamilyIncome: 400000,
      eligibility: 'Undergraduate & postgraduate students with financial '
          'need.',
      description:
          'One of India\'s oldest philanthropies, Tata Trusts runs multiple '
          'education grant programs for meritorious students from '
          'economically weaker backgrounds pursuing UG/PG studies.',
      benefits: [
        'Partial to full tuition support depending on need '
            'assessment'
      ],
      amount: 'Need based',
      deadline: 'Rolling',
      applyUrl: 'https://www.tatatrusts.org',
      requiredDocuments: [
        'Income proof',
        'Admission letter',
        'Academic records',
      ],
      selectionProcess: 'Application review and need assessment by the '
          'Trust.',
      classLevels: ['UG', 'PG'],
      incomeBased: true,
      tags: ['Undergraduate', 'Postgraduate', 'Income based'],
    ),
    Scholarship(
      id: 'tata_scholarship',
      title: 'Tata Capital Pankh Scholarship',
      organization: 'Tata Capital',
      provider: ScholarshipProvider.private,
      icon: Icons.flight_takeoff_rounded,
      wikipediaTitle: 'en:Tata Capital',
      maxFamilyIncome: 600000,
      minPercentage: 60,
      eligibility: 'Class 12 passouts and UG students from low-income '
          'families.',
      description:
          'Tata Capital\'s Pankh scholarship helps meritorious students from '
          'financially weaker families pursue higher education without '
          'having to compromise on their choice of course or college.',
      benefits: ['Annual scholarship for the duration of the degree'],
      amount: 'Up to ₹1,00,000 / year',
      deadline: '31 Aug 2026',
      applyUrl:
          'https://www.tatacapital.com/csr/pankh-scholarship-program.html',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'Admission proof',
      ],
      selectionProcess: 'Online application, document verification and '
          'merit-cum-means shortlisting.',
      renewalRules: 'Renewed yearly on 60%+ aggregate.',
      classLevels: ['Class 12', 'UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Class 12', 'Undergraduate', 'Merit', 'Income based'],
    ),
    Scholarship(
      id: 'hdfc_ecss',
      title: 'HDFC Bank Parivartan ECSS',
      organization: 'HDFC Bank',
      provider: ScholarshipProvider.private,
      icon: Icons.account_balance_wallet_rounded,
      wikipediaTitle: 'en:HDFC Bank',
      maxFamilyIncome: 250000,
      eligibility: 'Students Class 1 to postgraduate facing personal/financial '
          'crisis.',
      description:
          'Educational Crisis Scholarship Support (ECSS) under HDFC Bank\'s '
          'Parivartan CSR program — one-time emergency financial support for '
          'students whose education is at risk due to a sudden family crisis.',
      benefits: ['One-time grant to cover tuition/fees'],
      amount: 'Up to ₹75,000',
      deadline: '15 Dec 2026',
      applyUrl: 'https://www.hdfcbank.com/personal/about-us/csr',
      requiredDocuments: [
        'Income proof',
        'Proof of crisis (medical/death certificate etc.)',
        'Admission/fee receipt',
      ],
      selectionProcess: 'Application review by the Parivartan team.',
      classLevels: ['Class 10', 'Class 12', 'UG', 'PG'],
      incomeBased: true,
      tags: ['All classes', 'Income based'],
    ),
    Scholarship(
      id: 'aditya_birla_scholarship',
      title: 'Aditya Birla Scholarship',
      organization: 'Aditya Birla Group',
      provider: ScholarshipProvider.private,
      icon: Icons.diamond_rounded,
      wikipediaTitle: 'en:Aditya Birla Group',
      minPercentage: 85,
      eligibility:
          'Students admitted to IITs, IIMs, BITS Pilani, NLUs and other '
          'top-tier institutes.',
      description:
          'One of India\'s most prestigious private scholarships, awarded to '
          'academically outstanding students who have secured admission to a '
          'listed set of top engineering, management, law and science '
          'institutes.',
      benefits: [
        'One of the highest-value private scholarships in India',
        'Access to the Aditya Birla Scholars network and mentorship',
      ],
      amount: '₹1,75,000 – ₹10,00,000',
      deadline: '20 Jul 2026',
      applyUrl: 'https://www.adityabirlascholars.net',
      requiredDocuments: [
        'Admission proof at a listed institute',
        'Class 12/entrance exam scorecard',
      ],
      selectionProcess:
          'Shortlisting by academic record, followed by a personal interview '
          'panel.',
      renewalRules: 'Renewed yearly on maintaining top academic standing.',
      classLevels: ['UG', 'PG'],
      meritBased: true,
      tags: ['Undergraduate', 'Postgraduate', 'Merit'],
    ),
    Scholarship(
      id: 'lic_golden_jubilee',
      title: 'LIC Golden Jubilee Scholarship',
      organization: 'Life Insurance Corporation of India',
      provider: ScholarshipProvider.private,
      icon: Icons.shield_rounded,
      wikipediaTitle: 'en:Life Insurance Corporation',
      maxFamilyIncome: 200000,
      minPercentage: 60,
      eligibility: 'Class 12 passouts and full-time UG/professional students '
          'from low-income families.',
      description:
          'LIC\'s longstanding CSR scholarship for meritorious students from '
          'economically weaker families to pursue higher secondary, '
          'graduate, or professional courses.',
      benefits: ['Monthly scholarship for the course duration'],
      amount: '₹500 – ₹3,000 / month',
      deadline: '18 Jul 2026',
      applyUrl: 'https://licindia.in/golden-jubilee-foundation',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'Admission proof',
      ],
      selectionProcess: 'Online application and merit-cum-means review.',
      renewalRules: 'Renewed yearly on 50%+ aggregate.',
      classLevels: ['Class 12', 'UG'],
      incomeBased: true,
      tags: ['Class 12', 'Undergraduate', 'Income based'],
    ),
    Scholarship(
      id: 'sitaram_jindal',
      title: 'Sitaram Jindal Foundation Scholarship',
      organization: 'Sitaram Jindal Foundation',
      provider: ScholarshipProvider.private,
      icon: Icons.volunteer_activism_rounded,
      maxFamilyIncome: 300000,
      eligibility:
          'Class 11 onwards, including ITI/diploma/UG/PG, from low-income '
          'families.',
      description:
          'A broad-based scholarship covering Class 11/12, ITI, diploma, '
          'undergraduate and postgraduate students across disciplines, aimed '
          'at students who would otherwise struggle to continue their '
          'education.',
      benefits: ['Monthly scholarship for the full course duration'],
      amount: '₹500 – ₹1,500 / month',
      deadline: 'Rolling',
      applyUrl: 'https://www.sitaramjindalfoundation.org',
      requiredDocuments: [
        'Income Certificate',
        'Previous marksheet',
        'Admission proof',
      ],
      selectionProcess: 'Application review and interview at the '
          'Foundation\'s regional centres.',
      classLevels: ['Class 12', 'UG', 'PG'],
      incomeBased: true,
      tags: [
        'Class 11',
        'Class 12',
        'Undergraduate',
        'Postgraduate',
        'Income based'
      ],
    ),
    Scholarship(
      id: 'kotak_kanya',
      title: 'Kotak Kanya Scholarship',
      organization: 'Kotak Education Foundation',
      provider: ScholarshipProvider.private,
      icon: Icons.female_rounded,
      maxFamilyIncome: 600000,
      minPercentage: 60,
      eligibility: 'Girl students who passed Class 12 joining a full-time '
          'professional degree.',
      description:
          'Supports meritorious girl students from low- and middle-income '
          'families pursuing professional/technical degrees (engineering, '
          'medical, and more), aiming to close the gender gap in higher '
          'education.',
      benefits: ['Scholarship spread over the full duration of the degree'],
      amount: 'Up to ₹5,00,000 (over 4 years)',
      deadline: '15 Jun 2026',
      applyUrl: 'https://www.kotakeducationfoundation.org',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'Admission proof',
      ],
      selectionProcess: 'Online application, shortlisting and interview.',
      renewalRules: 'Renewed yearly on 60%+ aggregate.',
      girlsOnly: true,
      classLevels: ['Class 12', 'UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Class 12', 'Undergraduate', 'Girls', 'Merit', 'Income based'],
    ),
    Scholarship(
      id: 'santoor_scholarship',
      title: 'Santoor Women of Worth Scholarship',
      organization: 'Wipro Consumer Care (Santoor)',
      provider: ScholarshipProvider.private,
      icon: Icons.spa_rounded,
      eligibility: 'Women students pursuing UG/PG courses.',
      description: 'Recognises and supports academically driven women pursuing '
          'undergraduate or postgraduate education, celebrating everyday '
          '"women of worth" balancing studies and responsibilities.',
      benefits: ['One-time scholarship award'],
      amount: '₹15,000 – ₹50,000',
      deadline: '30 Sep 2026',
      applyUrl: 'https://www.santoorwow.com',
      requiredDocuments: ['Admission/enrolment proof', 'Academic records'],
      selectionProcess: 'Online application and essay/merit-based '
          'shortlisting.',
      girlsOnly: true,
      classLevels: ['UG', 'PG'],
      tags: ['Undergraduate', 'Postgraduate', 'Girls'],
    ),
    Scholarship(
      id: 'ongc_scholarship',
      title: 'ONGC Scholarship',
      organization: 'Oil and Natural Gas Corporation',
      provider: ScholarshipProvider.private,
      icon: Icons.factory_rounded,
      wikipediaTitle: 'en:Oil and Natural Gas Corporation',
      minPercentage: 60,
      eligibility:
          'SC/ST/OBC/EWS/PWD students in Engineering, Geology, Geophysics, '
          'MBA or MCA.',
      description:
          'ONGC\'s CSR scholarship for meritorious SC/ST/OBC/EWS and PWD '
          'students pursuing specific professional courses relevant to the '
          'energy sector, alongside a general-category "ONGC Scholarship for '
          'Meritorious Students".',
      benefits: ['Annual scholarship for the duration of the course'],
      amount: '₹48,000 – ₹60,000 / year',
      deadline: '30 Sep 2026',
      applyUrl: 'https://www.ongcindia.com/web/eng/csr/ongc-scholarship-scheme',
      requiredDocuments: [
        'Class 12/previous year marksheet',
        'Category Certificate (if applicable)',
        'Admission proof',
      ],
      selectionProcess: 'Merit-based shortlisting via the ONGC scholarship '
          'portal.',
      renewalRules: 'Renewed yearly on passing the previous year.',
      categoryEligibility: ['SC', 'ST', 'OBC', 'EWS'],
      classLevels: ['UG', 'PG'],
      disabledOnly: false,
      meritBased: true,
      tags: ['Undergraduate', 'Postgraduate', 'Merit', 'Technical'],
    ),
    Scholarship(
      id: 'ffe_scholarship',
      title: 'Foundation for Excellence (FFE) Scholarship',
      organization: 'Foundation for Excellence',
      provider: ScholarshipProvider.private,
      icon: Icons.emoji_events_rounded,
      maxFamilyIncome: 250000,
      minPercentage: 60,
      eligibility: 'Meritorious engineering/medical students from economically '
          'weaker sections.',
      description: 'Founded by NRI technology professionals, FFE supports high-'
          'achieving students from very low-income families through '
          'engineering and medical degrees, with an accompanying mentorship '
          'program.',
      benefits: [
        'Annual scholarship for the full degree duration',
        'One-on-one mentorship from industry volunteers',
      ],
      amount: '₹50,000 / year',
      deadline: '31 Aug 2026',
      applyUrl: 'https://www.ffe.org',
      requiredDocuments: [
        'Class 12 marksheet',
        'Income Certificate',
        'Admission proof (engineering/medical)',
      ],
      selectionProcess: 'Online application, document verification and '
          'merit-cum-means shortlisting.',
      renewalRules: 'Renewed yearly on 60%+ aggregate.',
      classLevels: ['UG'],
      meritBased: true,
      incomeBased: true,
      tags: ['Undergraduate', 'Merit', 'Income based', 'Technical'],
    ),
    Scholarship(
      id: 'vidyasaarathi',
      title: 'Vidyasaarathi Scholarship Platform',
      organization: 'NSDL e-Governance',
      provider: ScholarshipProvider.private,
      icon: Icons.hub_rounded,
      eligibility:
          'One-stop platform aggregating 100+ corporate/private scholarship '
          'schemes for Class 10 through PG/diploma.',
      description:
          'Vidyasaarathi is a private-sector counterpart to NSP — a single '
          'portal where students can discover and apply to scholarships '
          'funded by corporates, trusts and other private donors across all '
          'education levels.',
      benefits: [
        'Single application reused across multiple matching schemes',
        'Direct disbursal tracking',
      ],
      amount: 'Varies by scheme',
      deadline: 'Rolling',
      applyUrl: 'https://www.vidyasaarathi.co.in',
      selectionProcess: 'Varies by the specific scheme applied for.',
      classLevels: ['Class 10', 'Class 12', 'UG', 'PG'],
      tags: ['All classes', 'Portal'],
    ),
    Scholarship(
      id: 'lnt_build_india',
      title: 'L&T Build India Scholarship',
      organization: 'Larsen & Toubro',
      provider: ScholarshipProvider.private,
      icon: Icons.construction_rounded,
      wikipediaTitle: 'en:Larsen & Toubro',
      maxFamilyIncome: 300000,
      eligibility:
          'Diploma/degree Civil Engineering students from economically '
          'weaker families.',
      description:
          'L&T\'s CSR scholarship for students pursuing civil engineering '
          'diploma or degree courses, aimed at building a skilled workforce '
          'for India\'s infrastructure sector.',
      benefits: ['Tuition support', 'Hostel support for outstation students'],
      amount: 'Tuition + hostel support',
      deadline: '15 Sep 2026',
      applyUrl: 'https://www.larsentoubro.com/corporate/sustainability/csr/',
      requiredDocuments: [
        'Income Certificate',
        'Admission proof (Civil Engineering)',
        'Previous marksheet',
      ],
      selectionProcess: 'Application review and shortlisting by L&T\'s CSR '
          'team.',
      classLevels: ['UG'],
      incomeBased: true,
      tags: ['Undergraduate', 'Income based', 'Technical'],
    ),
    Scholarship(
      id: 'aicte_pragati',
      title: 'AICTE Pragati Scholarship for Girls',
      organization: 'AICTE',
      provider: ScholarshipProvider.government,
      icon: Icons.female_rounded,
      wikipediaTitle: 'en:All India Council for Technical Education',
      maxFamilyIncome: 800000,
      eligibility: 'Girl students in AICTE-approved technical diploma/'
          'degree.',
      description: 'Encourages technical education among girls by providing '
          'financial assistance to one girl child per family (max two per '
          'family) pursuing an AICTE-approved diploma or degree.',
      benefits: ['Annual scholarship for the course duration'],
      amount: '₹50,000 / year',
      deadline: '15 Jan 2027',
      applyUrl: 'https://www.aicte-india.org',
      requiredDocuments: [
        'Class 12/diploma marksheet',
        'Income Certificate',
        'Admission proof',
      ],
      selectionProcess: 'Merit-cum-eligibility basis via AICTE\'s portal.',
      renewalRules: 'Renewed yearly on passing the previous year.',
      girlsOnly: true,
      classLevels: ['UG'],
      incomeBased: true,
      tags: ['Undergraduate', 'Girls', 'Technical'],
    ),
  ];
}

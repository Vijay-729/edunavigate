import 'package:flutter/material.dart';

import '../../models/stream_career.dart';

/// PCB career options. Fees/salary figures are realistic *sample* ranges —
/// shown in the UI with a note to verify current numbers.
const List<StreamCareer> pcbCareers = [
  StreamCareer(
    id: 'doctor_mbbs',
    streamCode: 'pcb',
    name: 'Doctor (MBBS)',
    icon: Icons.medical_services_rounded,
    overview:
        'Diagnoses and treats patients as a licensed physician, with the option to specialize later.',
    eligibility: 'Class 12 PCB, qualify NEET-UG.',
    requiredSkills: [
      'Clinical Reasoning',
      'Biology & Anatomy',
      'Patient Communication',
      'Stress Resilience',
      'Attention to Detail'
    ],
    entranceExamIds: ['neet'],
    bestColleges: [
      'AIIMS New Delhi',
      'CMC Vellore',
      'Maulana Azad Medical College',
      'Government Medical Colleges (state-wise)'
    ],
    courseDuration: '5.5 years (MBBS incl. internship)',
    expectedFees: '₹10k–₹8L/year govt vs ₹15L–₹25L/year private (sample range)',
    scholarships:
        'Central/state government medical scholarships, minority scholarships, need-based aid',
    averageSalary: '₹6L–₹12L/year (resident/early career)',
    highestSalary:
        '₹1Cr+/year (senior specialists, surgeons in private practice)',
    futureScope:
        'Consistently high demand; specialization (MD/MS) significantly increases earning potential.',
    topRecruiters: [
      'AIIMS',
      'Fortis',
      'Apollo Hospitals',
      'Max Healthcare',
      'Government hospitals'
    ],
    workLifeBalance:
        'Demanding — long hours especially during residency/training',
    govtPrivateOpportunities:
        'Strong in both — government hospitals offer stability, private practice offers higher earning potential',
    higherStudyOptions: [
      'NEET PG → MD/MS specialization',
      'Super-specialization (DM/MCh)',
      'MBA in Hospital Administration'
    ],
  ),
  StreamCareer(
    id: 'dentist',
    streamCode: 'pcb',
    name: 'Dentist (BDS)',
    icon: Icons.medical_information_outlined,
    overview:
        'Diagnoses and treats dental and oral health conditions, often via private practice.',
    eligibility: 'Class 12 PCB, qualify NEET-UG (BDS counselling).',
    requiredSkills: [
      'Manual Dexterity',
      'Patient Care',
      'Attention to Detail',
      'Anatomy Knowledge',
      'Business Sense (for private practice)'
    ],
    entranceExamIds: ['neet'],
    bestColleges: [
      'Maulana Azad Institute of Dental Sciences',
      'Manipal College of Dental Sciences',
      'Government Dental Colleges'
    ],
    courseDuration: '5 years (BDS incl. internship)',
    expectedFees: '₹25k–₹5L/year govt vs ₹5L–₹12L/year private (sample range)',
    scholarships:
        'State government dental scholarships, minority and need-based aid',
    averageSalary: '₹4L–₹8L/year',
    highestSalary: '₹30L+/year (established private practice/specialists)',
    futureScope:
        'Steady demand; cosmetic and specialized dentistry (orthodontics, implants) growing fast.',
    topRecruiters: [
      'Private dental clinics',
      'Hospital dental departments',
      'Own practice'
    ],
    workLifeBalance:
        'Generally better than MBBS — more predictable clinic hours',
    govtPrivateOpportunities:
        'Government dental officer posts exist; majority build private practice',
    higherStudyOptions: [
      'MDS specialization (Orthodontics, Oral Surgery, etc.)',
      'Fellowship programmes abroad'
    ],
  ),
  StreamCareer(
    id: 'pharmacist',
    streamCode: 'pcb',
    name: 'Pharmacist',
    icon: Icons.local_pharmacy_outlined,
    overview:
        'Dispenses medication, advises on drug use, and works across retail, hospital, or pharmaceutical industry roles.',
    eligibility: 'Class 12 PCB (or PCM), then B.Pharm (4 years).',
    requiredSkills: [
      'Pharmacology',
      'Drug Interaction Knowledge',
      'Attention to Detail',
      'Customer Communication',
      'Regulatory Compliance'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'NIPER (National Institute of Pharmaceutical Education & Research)',
      'Jamia Hamdard',
      'Manipal College of Pharmaceutical Sciences'
    ],
    courseDuration: '4 years (B.Pharm)',
    expectedFees: '₹1L–₹8L total (sample range)',
    scholarships: 'State government scholarships, institute merit scholarships',
    averageSalary: '₹3L–₹6L/year',
    highestSalary: '₹15L+/year (pharma industry R&D/regulatory roles)',
    futureScope:
        'Strong demand from India\'s growing pharmaceutical and generic drug manufacturing industry.',
    topRecruiters: [
      'Sun Pharma',
      'Cipla',
      'Dr. Reddy\'s',
      'Retail pharmacy chains',
      'Hospitals'
    ],
    workLifeBalance:
        'Good — mostly regular hours except in 24-hour retail/hospital settings',
    govtPrivateOpportunities:
        'Government drug inspector/regulatory roles exist; majority in private pharma industry',
    higherStudyOptions: [
      'M.Pharm specialization',
      'MBA Pharma Management',
      'Ph.D. for drug research'
    ],
  ),
  StreamCareer(
    id: 'physiotherapist',
    streamCode: 'pcb',
    name: 'Physiotherapist',
    icon: Icons.accessibility_new_rounded,
    overview:
        'Helps patients recover movement and manage pain through physical rehabilitation techniques.',
    eligibility: 'Class 12 PCB, then BPT (Bachelor of Physiotherapy).',
    requiredSkills: [
      'Human Anatomy',
      'Manual Therapy Techniques',
      'Patient Communication',
      'Patience',
      'Exercise Prescription'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'AIIMS New Delhi (Physiotherapy)',
      'Manipal College of Health Professions',
      'Jamia Millia Islamia'
    ],
    courseDuration: '4.5 years (BPT incl. internship)',
    expectedFees: '₹1L–₹8L total (sample range)',
    scholarships: 'State government scholarships, institute-specific aid',
    averageSalary: '₹3L–₹6L/year',
    highestSalary: '₹15L+/year (sports physiotherapists, own clinics)',
    futureScope:
        'Growing demand from sports medicine, elderly care, and post-surgical rehabilitation.',
    topRecruiters: [
      'Hospitals',
      'Sports teams/academies',
      'Rehabilitation centres',
      'Private practice'
    ],
    workLifeBalance: 'Good — mostly clinic-hours based',
    govtPrivateOpportunities:
        'Government hospital posts exist; strong private/sports sector demand',
    higherStudyOptions: [
      'MPT (Master of Physiotherapy) specialization',
      'Sports medicine certifications'
    ],
  ),
  StreamCareer(
    id: 'nurse',
    streamCode: 'pcb',
    name: 'Nurse (B.Sc. Nursing)',
    icon: Icons.health_and_safety_outlined,
    overview:
        'Provides direct patient care, supports doctors, and manages critical health monitoring in hospitals.',
    eligibility: 'Class 12 PCB, then B.Sc. Nursing (4 years).',
    requiredSkills: [
      'Patient Care',
      'Clinical Procedures',
      'Empathy',
      'Stress Management',
      'Attention to Detail'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'AIIMS College of Nursing',
      'CMC Vellore',
      'PGIMER Chandigarh'
    ],
    courseDuration: '4 years (B.Sc. Nursing)',
    expectedFees: '₹50k–₹6L total (sample range)',
    scholarships:
        'Government nursing scholarships, hospital-sponsored training programmes',
    averageSalary: '₹3L–₹6L/year (India); significantly higher abroad',
    highestSalary:
        '₹15L+/year (senior nursing management, international postings)',
    futureScope:
        'High global demand — Indian nurses are widely recruited internationally (Gulf, UK, US, Australia).',
    topRecruiters: [
      'AIIMS',
      'Apollo Hospitals',
      'Fortis',
      'International hospitals'
    ],
    workLifeBalance: 'Demanding — shift work is standard in hospital settings',
    govtPrivateOpportunities:
        'Strong government hospital recruitment plus large private and international demand',
    higherStudyOptions: [
      'M.Sc. Nursing specialization',
      'Nurse Practitioner certifications abroad'
    ],
  ),
  StreamCareer(
    id: 'biotechnologist',
    streamCode: 'pcb',
    name: 'Biotechnologist',
    icon: Icons.biotech_rounded,
    isEmerging: true,
    overview:
        'Applies biological systems to develop products in medicine, agriculture, and industry — from vaccines to biofuels.',
    eligibility: 'Class 12 PCB, then B.Tech/B.Sc. Biotechnology.',
    requiredSkills: [
      'Molecular Biology',
      'Lab Techniques',
      'Genetic Engineering',
      'Data Analysis',
      'Research Writing'
    ],
    entranceExamIds: ['cuet', 'jee_main'],
    bestColleges: [
      'IIT Delhi/Kharagpur (Biotechnology)',
      'ICT Mumbai',
      'VIT Vellore'
    ],
    courseDuration: '4 years (B.Tech) or 3 years (B.Sc.)',
    expectedFees: '₹1L–₹12L total (sample range)',
    scholarships: 'INSPIRE scholarship, institute merit scholarships',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹25L+/year (biotech/pharma R&D leads)',
    futureScope:
        'Fast-growing field with India\'s expanding biotech, vaccine, and agri-biotech industries.',
    topRecruiters: [
      'Biocon',
      'Serum Institute of India',
      'Dr. Reddy\'s',
      'ICAR research institutes'
    ],
    workLifeBalance: 'Good — mostly lab/research hours, project-dependent',
    govtPrivateOpportunities:
        'Strong government research institutes (ICAR, DBT labs) alongside private biotech/pharma',
    higherStudyOptions: [
      'M.Sc./M.Tech Biotechnology',
      'Ph.D. for research careers',
      'MS abroad'
    ],
  ),
  StreamCareer(
    id: 'veterinarian',
    streamCode: 'pcb',
    name: 'Veterinarian',
    icon: Icons.pets_rounded,
    overview:
        'Diagnoses and treats animals — pets, livestock, and wildlife — and supports animal husbandry and public health.',
    eligibility: 'Class 12 PCB, qualify NEET/ICAR AIEEA for B.V.Sc & A.H.',
    requiredSkills: [
      'Animal Anatomy',
      'Clinical Diagnosis',
      'Surgical Skills',
      'Compassion',
      'Physical Stamina'
    ],
    entranceExamIds: ['neet', 'icar'],
    bestColleges: [
      'Indian Veterinary Research Institute (IVRI)',
      'Madras Veterinary College',
      'GB Pant University'
    ],
    courseDuration: '5.5 years (B.V.Sc & A.H. incl. internship)',
    expectedFees: '₹50k–₹6L total (sample range)',
    scholarships:
        'ICAR scholarships, state agriculture department scholarships',
    averageSalary: '₹3.5L–₹7L/year',
    highestSalary:
        '₹20L+/year (established private practice, wildlife specialists)',
    futureScope:
        'Growing demand from pet care industry, dairy/livestock sector, and wildlife conservation.',
    topRecruiters: [
      'Government Animal Husbandry Departments',
      'Private pet clinics',
      'Zoos & wildlife sanctuaries',
      'Dairy cooperatives'
    ],
    workLifeBalance: 'Moderate — field visits and emergency calls are common',
    govtPrivateOpportunities:
        'Strong government veterinary officer posts; growing urban private pet-care practice',
    higherStudyOptions: [
      'M.V.Sc. specialization',
      'Wildlife veterinary certifications'
    ],
  ),
  StreamCareer(
    id: 'dietician',
    streamCode: 'pcb',
    name: 'Nutritionist / Dietician',
    icon: Icons.restaurant_menu_rounded,
    isEmerging: true,
    overview:
        'Advises individuals and institutions on diet and nutrition for health, disease management, and wellness.',
    eligibility:
        'Class 12 PCB, then B.Sc. Food Science & Nutrition / Dietetics.',
    requiredSkills: [
      'Nutritional Science',
      'Diet Planning',
      'Communication',
      'Empathy',
      'Research Skills'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Lady Irwin College Delhi',
      'Institute of Home Economics Delhi',
      'SNDT Women\'s University'
    ],
    courseDuration: '3–4 years (B.Sc.)',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'Institute merit scholarships, state government scholarships',
    averageSalary: '₹3L–₹6L/year',
    highestSalary:
        '₹15L+/year (celebrity/clinical nutritionists, own practice)',
    futureScope:
        'Growing rapidly with rising health and wellness awareness in urban India.',
    topRecruiters: [
      'Hospitals',
      'Fitness & wellness startups',
      'Corporate wellness programmes',
      'Private practice'
    ],
    workLifeBalance:
        'Good — mostly consultation-based, flexible hours possible',
    govtPrivateOpportunities:
        'Government hospital dietician posts exist; large private wellness industry demand',
    higherStudyOptions: [
      'M.Sc. Clinical Nutrition/Dietetics',
      'Sports nutrition certifications'
    ],
  ),
  StreamCareer(
    id: 'microbiologist',
    streamCode: 'pcb',
    name: 'Microbiologist',
    icon: Icons.coronavirus_outlined,
    overview:
        'Studies microorganisms for applications in medicine, food safety, agriculture, and environmental science.',
    eligibility: 'Class 12 PCB, then B.Sc. Microbiology.',
    requiredSkills: [
      'Lab Techniques',
      'Microscopy',
      'Data Analysis',
      'Research Writing',
      'Attention to Detail'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Delhi University',
      'Fergusson College Pune',
      'Christ University Bangalore'
    ],
    courseDuration: '3 years (B.Sc.) + M.Sc. recommended',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'INSPIRE scholarship, institute merit scholarships',
    averageSalary: '₹3.5L–₹7L/year',
    highestSalary: '₹18L+/year (pharma/diagnostics R&D leads)',
    futureScope:
        'Steady demand from diagnostics labs, pharma quality control, and public health institutions.',
    topRecruiters: [
      'Diagnostic labs (Dr. Lal PathLabs, SRL)',
      'Pharma companies',
      'ICMR institutes'
    ],
    workLifeBalance: 'Good — mostly lab hours, occasional research deadlines',
    govtPrivateOpportunities:
        'Government research institutes (ICMR, NCDC) plus private diagnostics/pharma industry',
    higherStudyOptions: [
      'M.Sc. Microbiology',
      'Ph.D. for research',
      'Clinical microbiology certifications'
    ],
  ),
  StreamCareer(
    id: 'genetic_counselor',
    streamCode: 'pcb',
    name: 'Genetic Counselor',
    icon: Icons.family_restroom_rounded,
    isEmerging: true,
    overview:
        'Advises individuals and families on genetic conditions, hereditary risks, and reproductive decisions.',
    eligibility:
        'B.Sc. in Life Sciences/Genetics, then M.Sc. in Genetic Counselling.',
    requiredSkills: [
      'Genetics Knowledge',
      'Empathetic Communication',
      'Counselling Skills',
      'Data Interpretation',
      'Ethics'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'Sri Ramachandra Institute (Genetic Counselling)',
      'Kasturba Medical College Manipal'
    ],
    courseDuration: '3 years (B.Sc.) + 2 years (M.Sc. Genetic Counselling)',
    expectedFees: '₹1L–₹8L total (sample range)',
    scholarships: 'Limited; institute-specific merit aid',
    averageSalary: '₹4L–₹8L/year',
    highestSalary: '₹18L+/year (senior genomics/counselling roles)',
    futureScope:
        'Emerging field in India with growth expected alongside genomic medicine and prenatal screening adoption.',
    topRecruiters: [
      'Genomics companies (MedGenome, Strand Life Sciences)',
      'Hospitals with genetics departments'
    ],
    workLifeBalance: 'Good — consultation-based, mostly regular hours',
    govtPrivateOpportunities:
        'Still emerging in government hospitals; growing private genomics industry demand',
    higherStudyOptions: [
      'Ph.D. in Human Genetics',
      'International genetic counselling certification'
    ],
  ),
  StreamCareer(
    id: 'medical_lab_technologist',
    streamCode: 'pcb',
    name: 'Medical Lab Technologist',
    icon: Icons.science_outlined,
    overview:
        'Performs diagnostic lab tests (blood, pathology, microbiology) that support clinical diagnosis.',
    eligibility: 'Class 12 PCB, then B.Sc. Medical Lab Technology (MLT).',
    requiredSkills: [
      'Lab Equipment Handling',
      'Sample Analysis',
      'Accuracy & Precision',
      'Report Documentation',
      'Safety Protocols'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'AIIMS (MLT programme)',
      'Christian Medical College Vellore',
      'Manipal College of Health Professions'
    ],
    courseDuration: '3–4 years (B.Sc. MLT)',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'State government scholarships, institute-specific aid',
    averageSalary: '₹2.5L–₹5L/year',
    highestSalary: '₹12L+/year (senior lab managers, diagnostic chain roles)',
    futureScope:
        'Steady demand as diagnostic testing volumes grow across India.',
    topRecruiters: [
      'Dr. Lal PathLabs',
      'SRL Diagnostics',
      'Hospital laboratories'
    ],
    workLifeBalance: 'Good — mostly regular shift-based lab hours',
    govtPrivateOpportunities:
        'Government hospital lab posts plus large private diagnostics chain demand',
    higherStudyOptions: [
      'M.Sc. Medical Lab Technology',
      'Specialization in Histopathology/Microbiology labs'
    ],
  ),
  StreamCareer(
    id: 'psychologist_pcb',
    streamCode: 'pcb',
    name: 'Clinical Psychologist',
    icon: Icons.psychology_alt_rounded,
    overview:
        'Assesses and treats mental health conditions through therapy, counselling, and psychological testing.',
    eligibility:
        'B.Sc./B.A. Psychology → M.Sc./M.A. → M.Phil (for RCI registration to practice clinically).',
    requiredSkills: [
      'Active Listening',
      'CBT & Therapy Techniques',
      'Research Methods',
      'Report Writing',
      'Empathy'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'NIMHANS Bangalore',
      'Delhi University',
      'Tata Institute of Social Sciences (TISS)'
    ],
    courseDuration: '3 (B.A/B.Sc.) + 2 (M.A./M.Sc.) + 2 (M.Phil) years',
    expectedFees: '₹1L–₹8L total across degrees (sample range)',
    scholarships:
        'NIMHANS/university merit scholarships, UGC fellowships for M.Phil/Ph.D.',
    averageSalary: '₹4L–₹9L/year',
    highestSalary: '₹25L+/year (established private practice)',
    futureScope:
        'Strong growth as mental health awareness rises in India — significant shortage of qualified professionals.',
    topRecruiters: [
      'NIMHANS',
      'Hospitals',
      'Schools & corporates (wellness programmes)',
      'Private practice'
    ],
    workLifeBalance:
        'Good — mostly consultation-based, can be emotionally demanding',
    govtPrivateOpportunities:
        'Government mental health institutes plus fast-growing private counselling/teletherapy sector',
    higherStudyOptions: [
      'Ph.D. in Clinical Psychology',
      'Specialized therapy certifications (CBT, EMDR)'
    ],
  ),
  StreamCareer(
    id: 'agricultural_scientist',
    streamCode: 'pcb',
    name: 'Agricultural Scientist',
    icon: Icons.agriculture_rounded,
    overview:
        'Researches and develops methods to improve crop yield, soil health, and sustainable farming practices.',
    eligibility: 'Class 12 PCB, qualify ICAR AIEEA for B.Sc. Agriculture.',
    requiredSkills: [
      'Soil & Crop Science',
      'Research Methodology',
      'Data Analysis',
      'Field Work',
      'Sustainability Practices'
    ],
    entranceExamIds: ['icar', 'cuet'],
    bestColleges: [
      'Indian Agricultural Research Institute (IARI)',
      'Punjab Agricultural University',
      'GB Pant University'
    ],
    courseDuration: '4 years (B.Sc. Agriculture)',
    expectedFees: '₹50k–₹5L total (sample range)',
    scholarships: 'ICAR scholarships, state agriculture department aid',
    averageSalary: '₹3.5L–₹7L/year',
    highestSalary: '₹18L+/year (senior agri-scientists, agribusiness leads)',
    futureScope:
        'Growing importance with focus on food security, sustainable agriculture, and agri-tech innovation.',
    topRecruiters: [
      'ICAR institutes',
      'State Agriculture Departments',
      'Agri-input companies',
      'Agri-tech startups'
    ],
    workLifeBalance: 'Good — mix of field and office/research work',
    govtPrivateOpportunities:
        'Strong government research and extension roles; growing private agri-tech sector',
    higherStudyOptions: [
      'M.Sc./Ph.D. Agriculture specialization',
      'Agribusiness Management (MBA)'
    ],
  ),
  StreamCareer(
    id: 'forensic_scientist',
    streamCode: 'pcb',
    name: 'Forensic Scientist',
    icon: Icons.fingerprint_rounded,
    isEmerging: true,
    overview:
        'Applies scientific methods to analyze evidence and support criminal investigations and the justice system.',
    eligibility: 'Class 12 PCB, then B.Sc. Forensic Science.',
    requiredSkills: [
      'Lab Analysis',
      'Attention to Detail',
      'Chain-of-Custody Protocols',
      'Report Writing',
      'Courtroom Testimony'
    ],
    entranceExamIds: ['cuet'],
    bestColleges: [
      'LNJN National Institute of Criminology and Forensic Science',
      'Gujarat Forensic Sciences University'
    ],
    courseDuration: '3 years (B.Sc.) + M.Sc. recommended',
    expectedFees: '₹1L–₹6L total (sample range)',
    scholarships: 'Institute merit scholarships, state government aid',
    averageSalary: '₹3.5L–₹7L/year',
    highestSalary: '₹15L+/year (senior forensic lab experts)',
    futureScope:
        'Growing demand as forensic evidence plays a larger role in the Indian judicial process.',
    topRecruiters: [
      'State Forensic Science Laboratories',
      'CBI',
      'CFSL (Central Forensic Science Laboratory)'
    ],
    workLifeBalance:
        'Moderate — casework can involve irregular hours during active investigations',
    govtPrivateOpportunities:
        'Predominantly government (state/central forensic labs, police departments)',
    higherStudyOptions: [
      'M.Sc. Forensic Science specialization',
      'Digital forensics certifications'
    ],
  ),
];

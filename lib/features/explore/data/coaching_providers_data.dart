import 'package:flutter/material.dart';

import '../../colleges/models/student_stream.dart';
import '../models/coaching_provider.dart';

/// Curated, hand-maintained list of well-known Indian coaching institutes —
/// the "Top Coaching Institutes" feature deliberately does NOT search
/// OpenStreetMap for these (coverage there is too inconsistent); instead it
/// shows this seed list filtered/ranked by the student's stream, and only
/// touches live location data on demand via "Find Nearest Branch".
class CoachingProviders {
  CoachingProviders._();

  static const allen = CoachingProvider(
    id: 'allen',
    name: 'Allen',
    icon: Icons.emoji_events_outlined,
    about: "One of India's largest coaching institutes for JEE and NEET, "
        'known for its structured test series and Kota-based faculty.',
    coursesOffered: ['JEE Main & Advanced', 'NEET', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm, StudentStream.pcb],
    website: 'https://www.allen.ac.in/',
    popularExams: ['JEE Main', 'JEE Advanced', 'NEET'],
    recommendationReason: 'Best all-round results for JEE & NEET.',
    wikipediaTitle: 'en:Allen Career Institute',
    feeStructure: [
      'Classroom Program (2-yr, JEE/NEET): ₹1.4L – ₹2.2L / year',
      'Distance Learning Program (DLP): ₹25,000 – ₹60,000 / year',
      'Digital/Online batches: ₹15,000 – ₹45,000 / year',
    ],
    scholarshipInfo:
        'Allen Scholarship-cum-Admission Test (ASAT) offers up to 90% fee '
        'waiver for top scorers, plus additional scholarships for '
        'board-exam toppers and economically weaker students.',
    hasHostel: true,
    duration: '1–2 years (Foundation to Advanced)',
    rating: 4.4,
    popularResults: [
      'Consistently strong JEE & NEET selection numbers across its Kota '
          'and branch centres.',
      'Regularly produces top All-India Rank holders.',
    ],
  );

  static const fiitjee = CoachingProvider(
    id: 'fiitjee',
    name: 'FIITJEE',
    icon: Icons.functions_rounded,
    about: 'Long-running JEE-focused institute known for its rigorous problem '
        'sets and Advanced-level test series.',
    coursesOffered: ['JEE Main & Advanced', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm],
    website: 'https://www.fiitjee.com/',
    popularExams: ['JEE Main', 'JEE Advanced'],
    recommendationReason: 'Strong pick for JEE Advanced-focused prep.',
    wikipediaTitle: 'en:FIITJEE',
    feeStructure: [
      'Classroom Program (2-yr, JEE Advanced): ₹1.8L – ₹2.8L / year',
      'Integrated School Program: ₹1.2L – ₹2L / year',
    ],
    scholarshipInfo:
        'FIITJEE Talent Reward Exam (FTRE) offers merit scholarships and '
        'fee concessions for high scorers.',
    duration: '1–2 years (JEE Main & Advanced)',
    rating: 4.1,
    popularResults: [
      'Long history of IIT admits through its JEE Advanced-focused '
          'programs.',
    ],
  );

  static const pwJee = CoachingProvider(
    id: 'pw_jee',
    name: 'PW JEE',
    icon: Icons.bolt_outlined,
    about:
        "Physics Wallah's JEE vertical — affordable, app-first coaching with "
        'both online batches and offline Vidyapeeth centres.',
    coursesOffered: ['JEE Main & Advanced', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm],
    website: 'https://www.pw.live/',
    popularExams: ['JEE Main', 'JEE Advanced'],
    recommendationReason: 'Most affordable high-quality JEE prep.',
    wikipediaTitle: 'en:Physics Wallah',
    feeStructure: [
      'Online Batches: ₹5,000 – ₹20,000 / year',
      'Offline Vidyapeeth Centres: ₹60,000 – ₹1.2L / year',
    ],
    scholarshipInfo:
        "PW Scholarship Test (PWST) offers up to 100% scholarships for "
        'both online and offline batches based on merit.',
    hasHostel: true,
    duration: '1–2 years (JEE Main & Advanced)',
    rating: 4.5,
    popularResults: [
      'Fast-growing JEE selection numbers since its offline Vidyapeeth '
          'centres launched.',
    ],
  );

  static const pwNeet = CoachingProvider(
    id: 'pw_neet',
    name: 'PW NEET',
    icon: Icons.bolt_outlined,
    about: "Physics Wallah's NEET vertical — affordable, app-first coaching "
        'with both online batches and offline Vidyapeeth centres.',
    coursesOffered: ['NEET', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcb],
    website: 'https://www.pw.live/',
    popularExams: ['NEET'],
    recommendationReason: 'Best for NEET preparation on a budget.',
    wikipediaTitle: 'en:Physics Wallah',
    feeStructure: [
      'Online Batches: ₹5,000 – ₹20,000 / year',
      'Offline Vidyapeeth Centres: ₹60,000 – ₹1.2L / year',
    ],
    scholarshipInfo:
        'PW Scholarship Test (PWST) offers merit-based fee waivers for '
        'NEET batches, online and offline.',
    hasHostel: true,
    duration: '1–2 years (NEET)',
    rating: 4.5,
    popularResults: [
      'Fast-growing NEET selection numbers since its offline Vidyapeeth '
          'centres launched.',
    ],
  );

  static const pwCommerce = CoachingProvider(
    id: 'pw_commerce',
    name: 'PW Commerce',
    icon: Icons.bolt_outlined,
    about: "Physics Wallah's commerce vertical, covering CA Foundation and "
        'CUET Commerce with affordable online batches.',
    coursesOffered: ['CA Foundation', 'CUET Commerce', 'Class 11-12 Commerce'],
    supportedStreams: [StudentStream.commerce],
    website: 'https://www.pw.live/',
    popularExams: ['CA Foundation', 'CUET'],
    recommendationReason: 'Affordable commerce & CA Foundation prep.',
    wikipediaTitle: 'en:Physics Wallah',
    feeStructure: [
      'Online CA Foundation/CUET Batches: ₹4,000 – ₹15,000 / year'
    ],
    scholarshipInfo:
        'Merit-based scholarships available via the PW Scholarship Test '
        'for commerce batches.',
    offersOffline: false,
    duration: '6 months – 1 year',
    rating: 4.3,
    popularResults: [
      'Widely used by CA Foundation and CUET Commerce aspirants for '
          'affordable prep.',
    ],
  );

  static const motion = CoachingProvider(
    id: 'motion',
    name: 'Motion',
    icon: Icons.rocket_launch_outlined,
    about: 'Kota-based institute for JEE and NEET, offering classroom and '
        'distance-learning programs with a strong test-series focus.',
    coursesOffered: ['JEE Main & Advanced', 'NEET', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm, StudentStream.pcb],
    website: 'https://www.motion.ac.in/',
    popularExams: ['JEE Main', 'JEE Advanced', 'NEET'],
    recommendationReason: 'Solid Kota-style test series for JEE & NEET.',
    feeStructure: [
      'Classroom Program (Kota, 2-yr): ₹1.3L – ₹2L / year',
      'Distance Learning Program: ₹30,000 – ₹55,000 / year',
    ],
    scholarshipInfo: 'Motion Scholarship-cum-Admission Test (MSAT) offers fee '
        'concessions for top scorers.',
    hasHostel: true,
    duration: '1–2 years (JEE & NEET)',
    rating: 4.0,
    popularResults: [
      'Long-established Kota results across JEE and NEET batches.',
    ],
  );

  static const resonance = CoachingProvider(
    id: 'resonance',
    name: 'Resonance',
    icon: Icons.graphic_eq_rounded,
    about: 'Established Kota institute for JEE and NEET, known for its '
        'structured DLP (distance learning) material.',
    coursesOffered: ['JEE Main & Advanced', 'NEET', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm, StudentStream.pcb],
    website: 'https://www.resonance.ac.in/',
    popularExams: ['JEE Main', 'JEE Advanced', 'NEET'],
    recommendationReason: 'Well-regarded distance-learning material.',
    feeStructure: [
      'Classroom Program (Kota, 2-yr): ₹1.3L – ₹2.1L / year',
      'DLP Material: ₹25,000 – ₹50,000 / year',
    ],
    scholarshipInfo:
        'Resonance Scholarship-cum-Admission Test (RSAT) offers merit '
        'scholarships up to 90% fee waiver.',
    hasHostel: true,
    duration: '1–2 years (JEE & NEET)',
    rating: 4.1,
    popularResults: [
      'Well-regarded DLP material used by many successful JEE/NEET '
          'candidates over the years.',
    ],
  );

  static const narayana = CoachingProvider(
    id: 'narayana',
    name: 'Narayana',
    icon: Icons.hub_outlined,
    about: 'Large pan-India chain of schools and JEE/NEET coaching centres, '
        'popular for its integrated school + coaching programs.',
    coursesOffered: [
      'JEE Main & Advanced',
      'NEET',
      'Integrated School Program'
    ],
    supportedStreams: [StudentStream.pcm, StudentStream.pcb],
    website: 'https://www.narayanagroup.com/',
    popularExams: ['JEE Main', 'JEE Advanced', 'NEET'],
    recommendationReason: 'Wide branch network across India.',
    wikipediaTitle: 'en:Narayana Group',
    feeStructure: [
      'Integrated School + Coaching Program: ₹80,000 – ₹1.8L / year',
      'Standalone Coaching: ₹60,000 – ₹1.2L / year',
    ],
    scholarshipInfo:
        'Narayana Scholarship-cum-Admission Test (NSAT) offers scholarships '
        'up to 100% for top ranks.',
    hasHostel: true,
    duration: '1–2 years (Integrated Programs available)',
    rating: 3.9,
    popularResults: [
      'Consistent JEE/NEET results across its large pan-India branch '
          'network.',
    ],
  );

  static const unacademy = CoachingProvider(
    id: 'unacademy',
    name: 'Unacademy',
    icon: Icons.smart_display_outlined,
    about: "India's largest online learning platform, with live JEE classes "
        'from top educators and offline centres in major cities.',
    coursesOffered: ['JEE Main & Advanced', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcm],
    website: 'https://unacademy.com/',
    popularExams: ['JEE Main', 'JEE Advanced'],
    recommendationReason: 'Flexible live online classes with top educators.',
    wikipediaTitle: 'en:Unacademy',
    feeStructure: [
      'Live Online Batches (JEE): ₹8,000 – ₹35,000 / year',
      'Offline Centres: ₹40,000 – ₹90,000 / year',
    ],
    scholarshipInfo:
        'Unacademy runs periodic scholarship tests and referral discounts; '
        'exact scholarship % varies by batch.',
    duration: '6 months – 2 years (flexible)',
    rating: 4.2,
    popularResults: [
      'Large community of JEE qualifiers across its live-class educator '
          'network.',
    ],
  );

  static const aakash = CoachingProvider(
    id: 'aakash',
    name: 'Aakash',
    icon: Icons.local_hospital_outlined,
    about: "One of India's most trusted names for NEET coaching, with a large "
        'branch network and structured classroom + digital programs.',
    coursesOffered: ['NEET', 'Foundation (9-10)'],
    supportedStreams: [StudentStream.pcb],
    website: 'https://www.aakash.ac.in/',
    popularExams: ['NEET'],
    recommendationReason: 'Most trusted brand specifically for NEET.',
    wikipediaTitle: 'en:Aakash Educational Services Limited',
    feeStructure: [
      'Classroom Program (2-yr, NEET): ₹1.3L – ₹2L / year',
      'iACST Digital + Classroom: ₹70,000 – ₹1.4L / year',
    ],
    scholarshipInfo: 'Aakash National Talent Hunt Exam (ANTHE) and AIATS offer '
        'scholarships up to 90% fee waiver.',
    hasHostel: true,
    duration: '1–2 years (NEET Foundation to Advanced)',
    rating: 4.3,
    popularResults: [
      'One of the most trusted brands for NEET selections nationwide.',
    ],
  );

  static const ims = CoachingProvider(
    id: 'ims',
    name: 'IMS',
    icon: Icons.business_center_outlined,
    about: 'One of the oldest MBA entrance coaching institutes in India, '
        'known for its CAT test series and mock interviews.',
    coursesOffered: ['CAT', 'Other MBA Entrances', 'GMAT'],
    supportedStreams: [StudentStream.commerce],
    website: 'https://www.imsindia.com/',
    popularExams: ['CAT', 'MBA Entrances'],
    recommendationReason: 'Long-standing CAT prep with strong mocks.',
    feeStructure: [
      'CAT Classroom Program: ₹35,000 – ₹65,000',
      'Online CAT Program: ₹15,000 – ₹30,000',
    ],
    scholarshipInfo:
        'Early-bird and merit-based fee concessions offered each admission '
        'cycle — check with your nearest branch for current offers.',
    duration: '6–10 months (CAT cycle)',
    rating: 4.0,
    popularResults: [
      'Long-standing reputation for CAT prep, mock interviews and GD '
          'practice.',
    ],
  );

  static const time = CoachingProvider(
    id: 'time',
    name: 'TIME',
    icon: Icons.schedule_outlined,
    about: 'Nationwide MBA entrance coaching chain with an extensive CAT test '
        'series and branch network.',
    coursesOffered: ['CAT', 'Other MBA Entrances', 'Bank PO/Clerk'],
    supportedStreams: [StudentStream.commerce],
    website: 'https://www.time4education.com/',
    popularExams: ['CAT', 'MBA Entrances'],
    recommendationReason: 'Widest branch network for CAT prep.',
    feeStructure: [
      'CAT Classroom Program: ₹30,000 – ₹60,000',
      'Online CAT Program: ₹12,000 – ₹28,000',
    ],
    scholarshipInfo:
        "Merit-based scholarships for top scorers in TIME's own admission "
        'test — check your nearest branch for current offers.',
    duration: '6–10 months (CAT cycle)',
    rating: 4.1,
    popularResults: [
      'Widest branch network with a consistent CAT results track record.',
    ],
  );

  static const careerLauncher = CoachingProvider(
    id: 'career_launcher',
    name: 'Career Launcher',
    icon: Icons.trending_up_rounded,
    about: 'Coaching chain covering MBA and law entrances, with both classroom '
        'and online CAT/CLAT programs.',
    coursesOffered: ['CAT', 'CLAT', 'Other MBA Entrances'],
    supportedStreams: [StudentStream.commerce, StudentStream.humanities],
    website: 'https://www.careerlauncher.com/',
    popularExams: ['CAT', 'CLAT'],
    recommendationReason: 'Covers both CAT and CLAT prep.',
    wikipediaTitle: 'en:Career Launcher',
    feeStructure: [
      'CAT/CLAT Classroom Program: ₹30,000 – ₹65,000',
      'Online Program: ₹12,000 – ₹30,000',
    ],
    scholarshipInfo:
        'Scholarship tests held before each admission cycle offer fee '
        'concessions for top scorers.',
    duration: '6–10 months (CAT/CLAT cycle)',
    rating: 4.0,
    popularResults: [
      'Well-regarded for both CAT and CLAT preparation outcomes.',
    ],
  );

  static const vajiramAndRavi = CoachingProvider(
    id: 'vajiram_ravi',
    name: 'Vajiram & Ravi',
    icon: Icons.account_balance_outlined,
    about: "One of Delhi's most respected UPSC Civil Services coaching "
        'institutes, known for its comprehensive printed study material.',
    coursesOffered: ['UPSC CSE Prelims & Mains', 'Optional Subjects'],
    supportedStreams: [StudentStream.humanities],
    website: 'https://vajiramandravi.com/',
    popularExams: ['UPSC CSE'],
    recommendationReason: 'Gold-standard UPSC study material.',
    feeStructure: [
      'UPSC GS Foundation Course: ₹1.2L – ₹1.8L',
      'Optional Subject Course: ₹25,000 – ₹45,000',
    ],
    scholarshipInfo:
        'Limited need/merit-based fee concessions — confirm the current '
        'policy directly with the institute.',
    duration: '1 year (GS Foundation)',
    rating: 4.4,
    popularResults: [
      'One of the most respected names for UPSC CSE selections over the '
          'decades.',
    ],
  );

  static const visionIas = CoachingProvider(
    id: 'vision_ias',
    name: 'Vision IAS',
    icon: Icons.remove_red_eye_outlined,
    about: 'Large UPSC Civil Services coaching institute known for its test '
        'series and current affairs magazine.',
    coursesOffered: ['UPSC CSE Prelims & Mains', 'Test Series'],
    supportedStreams: [StudentStream.humanities],
    website: 'https://www.visionias.in/',
    popularExams: ['UPSC CSE'],
    recommendationReason: 'Strong current-affairs & test series coverage.',
    feeStructure: [
      'UPSC GS Foundation Course: ₹1.1L – ₹1.6L',
      'Test Series (Prelims + Mains): ₹8,000 – ₹18,000',
    ],
    scholarshipInfo:
        'Scholarship tests for economically weaker and meritorious '
        'candidates held periodically.',
    duration: '1 year (GS Foundation)',
    rating: 4.2,
    popularResults: [
      'Strong track record in UPSC CSE prelims and mains, with widely-used '
          'test series.',
    ],
  );

  static const drishtiIas = CoachingProvider(
    id: 'drishti_ias',
    name: 'Drishti IAS',
    icon: Icons.visibility_outlined,
    about: 'UPSC Civil Services coaching institute known for free Hindi and '
        'English study material and YouTube lectures.',
    coursesOffered: ['UPSC CSE Prelims & Mains', 'Hindi Medium Program'],
    supportedStreams: [StudentStream.humanities],
    website: 'https://www.drishtiias.com/',
    popularExams: ['UPSC CSE'],
    recommendationReason: 'Best free material for Hindi-medium aspirants.',
    feeStructure: [
      'UPSC GS Foundation Course (Hindi/English): ₹50,000 – ₹1L',
      'Test Series: ₹5,000 – ₹12,000',
    ],
    scholarshipInfo:
        'Free study material and YouTube lectures substantially reduce '
        'cost for self-study aspirants; paid courses also offer merit '
        'scholarships.',
    duration: '1 year (GS Foundation)',
    rating: 4.3,
    popularResults: [
      'Popular free-content brand with many UPSC CSE selections, '
          'especially among Hindi-medium aspirants.',
    ],
  );

  static const clatPossible = CoachingProvider(
    id: 'clat_possible',
    name: 'CLAT Possible',
    icon: Icons.gavel_outlined,
    about: 'Specialist CLAT and law entrance coaching institute with a focused '
        'test series for National Law Universities.',
    coursesOffered: ['CLAT', 'AILET', 'Other Law Entrances'],
    supportedStreams: [StudentStream.humanities],
    website: 'https://www.clatpossible.com/',
    popularExams: ['CLAT', 'AILET'],
    recommendationReason: 'Specialist focus purely on law entrances.',
    feeStructure: ['CLAT Classroom/Online Program: ₹60,000 – ₹1.1L'],
    scholarshipInfo:
        'Merit-based scholarship test conducted before each admission '
        'cycle.',
    duration: '10–12 months (CLAT cycle)',
    rating: 4.0,
    popularResults: [
      'Specialist CLAT coaching with a strong National Law University '
          'admission track record.',
    ],
  );

  /// Every provider, keyed by id — used to look one up regardless of stream.
  static const Map<String, CoachingProvider> byId = {
    'allen': allen,
    'fiitjee': fiitjee,
    'pw_jee': pwJee,
    'pw_neet': pwNeet,
    'pw_commerce': pwCommerce,
    'motion': motion,
    'resonance': resonance,
    'narayana': narayana,
    'unacademy': unacademy,
    'aakash': aakash,
    'ims': ims,
    'time': time,
    'career_launcher': careerLauncher,
    'vajiram_ravi': vajiramAndRavi,
    'vision_ias': visionIas,
    'drishti_ias': drishtiIas,
    'clat_possible': clatPossible,
  };

  /// Display order per stream — matches the order specified for each stream
  /// rather than re-deriving it from [supportedStreams], so the picker shows
  /// providers in the intended sequence.
  static const Map<StudentStream, List<String>> _order = {
    StudentStream.pcm: [
      'allen',
      'fiitjee',
      'pw_jee',
      'motion',
      'resonance',
      'narayana',
      'unacademy',
    ],
    StudentStream.pcb: [
      'allen',
      'aakash',
      'pw_neet',
      'motion',
      'resonance',
      'narayana',
    ],
    StudentStream.commerce: ['ims', 'time', 'career_launcher', 'pw_commerce'],
    StudentStream.humanities: [
      'vajiram_ravi',
      'vision_ias',
      'drishti_ias',
      'clat_possible',
      'career_launcher',
    ],
  };

  /// Providers for a stream, in the curated display order. Falls back to a
  /// broad cross-stream sample when the stream isn't known yet (Agriculture
  /// has no dedicated list, same as detection failing).
  static List<CoachingProvider> forStream(StudentStream? stream) {
    final ids = _order[stream];
    if (ids == null) {
      return const [allen, aakash, unacademy, careerLauncher];
    }
    return ids.map((id) => byId[id]!).toList();
  }

  /// Top picks shown under "Recommended for You" — the first three entries
  /// for the stream, which [_order] already lists best-first.
  static List<CoachingProvider> recommendedForStream(StudentStream? stream) =>
      forStream(stream).take(3).toList();
}

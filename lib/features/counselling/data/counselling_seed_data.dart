import '../models/counselling_model.dart';

/// Representative seed data for India's major Class-12-entry admission
/// counselling processes. Approximate, illustrative dates/cutoffs for the
/// 2026 admission cycle — swap for a live `counsellingPrograms` Firestore
/// feed later via [CounsellingRepository].
class CounsellingSeedData {
  CounsellingSeedData._();

  static const List<String> _standardMistakes = [
    'Filling too few choices and running out of options after Round 1',
    'Not reporting/accepting the seat within the deadline after allotment',
    'Uploading blurred or incorrectly named scanned documents',
    'Forgetting to freeze/float the seat before the choice-lock deadline',
    'Ignoring category/PwD certificate validity date requirements',
  ];

  static const List<String> _standardDocuments = [
    'Class 10 & 12 mark sheets and certificates',
    'Category certificate (SC/ST/OBC-NCL/EWS), if applicable',
    'Rank/scorecard and admit card of the qualifying exam',
    'Passport-size photographs (as per portal specification)',
    'Aadhaar card / valid photo ID proof',
    'Income certificate (for fee waiver/scholarship claims)',
    'PwD certificate, if applicable',
  ];

  static List<CounsellingTimelineStep> _standardTimelineSteps({
    required String body,
  }) {
    return [
      const CounsellingTimelineStep(
        title: 'Registration',
        subtitle: 'Create your counselling account',
        detail:
            'Register with your qualifying-exam roll number and basic details '
            'to receive a counselling login. Verify your mobile number and '
            'email — all further communication is sent here.',
      ),
      const CounsellingTimelineStep(
        title: 'Choice Filling',
        subtitle: 'Rank your preferred college + course combinations',
        detail: 'List every college-course combination you would accept, in '
            'strict order of preference. Add far more choices than you '
            'expect to need — an unfilled choice can never be allotted.',
      ),
      const CounsellingTimelineStep(
        title: 'Choice Locking',
        subtitle: 'Freeze your final preference order',
        detail: 'Once satisfied, lock your choice list before the deadline. '
            'Unlocked lists are still considered, but locking prevents '
            'accidental last-minute edits.',
      ),
      const CounsellingTimelineStep(
        title: 'Round 1 Allotment',
        subtitle: 'First seat offer based on rank & choices',
        detail: 'Seats are allotted by matching your rank against the choice '
            'list and seat matrix. You must respond — Freeze, Float, or '
            'Slide/Withdraw — within the response window.',
      ),
      const CounsellingTimelineStep(
        title: 'Round 2 Allotment',
        subtitle: 'Upgrade opportunity for floated candidates',
        detail: 'Candidates who chose Float are re-considered for a better '
            'option in this round. Freeze candidates already reporting are '
            'not disturbed.',
      ),
      const CounsellingTimelineStep(
        title: 'Round 3 Allotment',
        subtitle: 'Further vacancy-based allotment',
        detail: 'Remaining vacancies (from withdrawals/upgrades) are offered. '
            'This is typically the last round before spot rounds begin.',
      ),
      const CounsellingTimelineStep(
        title: 'Spot Round',
        subtitle: 'Fill leftover seats after regular rounds',
        detail:
            'Any seats still vacant are offered on a first-come, walk-in or '
            'fresh-choice basis. Spot rounds usually happen at the '
            'institute level and move fast.',
      ),
      CounsellingTimelineStep(
        title: 'Reporting',
        subtitle: 'Verify documents and confirm your seat',
        detail: body,
      ),
    ];
  }

  static final List<CounsellingProgram> all = [
    CounsellingProgram(
      id: 'josaa',
      name: 'JoSAA',
      fullName: 'Joint Seat Allocation Authority',
      category: CounsellingCategory.engineering,
      conductingBody: 'IITs & NITs (rotating chair)',
      about:
          'JoSAA conducts centralized counselling for admission to all IITs, '
          'NITs, IIITs and other GFTIs based on JEE Main/Advanced ranks. It '
          'runs 5-6 rounds followed by CSAB special rounds for leftover seats.',
      eligibility:
          'Valid JEE Main (NITs/IIITs/GFTIs) or JEE Advanced (IITs) rank; '
          'must have cleared 12th with required subjects and marks.',
      registrationProcess:
          'Register on josaa.nic.in using your JEE Main/Advanced roll number, '
          'pay the registration fee, and fill/lock your choices before each round.',
      choiceFillingInfo:
          'Choices are course+institute combinations, ordered strictly by '
          'preference. You can add, remove, or reorder any time before locking.',
      choiceLockingInfo:
          'Lock choices before the round deadline; unlocked lists auto-lock '
          'a few hours before result declaration.',
      seatAllotmentInfo:
          'Allotment uses your rank, category, and locked choice order '
          'against the seat matrix published for that round.',
      documentVerificationInfo:
          'Online document verification via portal upload, cross-checked at '
          'the reporting institute/help centre.',
      reportingInfo:
          'Report online (pay reporting fee, upload documents) or at a '
          'reporting centre depending on the round and your response.',
      admissionConfirmationInfo:
          'Admission is confirmed once fees are paid and documents are '
          'verified as "Fee Paid — Reporting Complete" on the portal.',
      importantInstructions: const [
        'Choose Freeze only when you are sure you want the current seat',
        'Float keeps you eligible for upgrade in later rounds',
        'Slide is only available within your already-allotted institute type',
        'Missing a response deadline can cancel your allotment',
        'Keep original documents ready even for online verification',
      ],
      reservationRules: const [
        'OBC-NCL: 27% (non-creamy layer certificate required)',
        'SC: 15%, ST: 7.5%',
        'EWS: 10% (income & asset certificate required)',
        'Home-state quota applies only at NITs (50% home-state seats)',
        'PwD: 5% horizontal reservation across all categories',
      ],
      seatMatrixNote:
          'Seat matrix is published separately for IITs, NITs, IIITs and '
          'GFTIs before Round 1 and may be revised each round.',
      previousYearCutoffs: const [
        'IIT Bombay CSE — closing rank ~68 (General, JEE Advanced)',
        'IIT Delhi CSE — closing rank ~118 (General, JEE Advanced)',
        'NIT Trichy CSE — closing rank ~2,800 (General, JEE Main)',
        'NIT Surathkal CSE — closing rank ~4,600 (General, JEE Main)',
      ],
      faqs: const [
        FaqItem(
          question: 'What happens if I don\'t respond in a round?',
          answer: 'Your allotment for that round is cancelled and you drop out '
              'of further rounds — always respond even if unsure, using Float.',
        ),
        FaqItem(
          question: 'Can I change my branch after Round 1?',
          answer:
              'Yes, if you chose Float or Slide, you remain in the pool for '
              'a better branch/institute in later rounds.',
        ),
        FaqItem(
          question: 'Is CSAB different from JoSAA?',
          answer: 'CSAB runs after JoSAA\'s rounds end, filling leftover NIT+ '
              'seats (Special rounds) and state quota seats (CSAB-ND).',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'JEE Main/Advanced admit card & scorecard',
        'Class 12 mark sheet',
        'Category/EWS/PwD certificate (if applicable)',
        'Provisional seat allotment letter (downloaded from portal)',
        'Passport photographs',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'JoSAA Counselling Process Explained',
            url: 'https://josaa.nic.in'),
      ],
      officialWebsite: 'https://josaa.nic.in',
      contactEmail: 'josaa2026@iitb.ac.in',
      contactPhone: '011-2676-7033',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to your allotted institute (or online) with original '
            'documents, pay the admission fee, and complete document '
            'verification to confirm your seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Registration & Choice Filling Begins',
            date: DateTime(2026, 6, 3)),
        CounsellingDateEvent(
            label: 'Choice Locking Round 1', date: DateTime(2026, 6, 26)),
        CounsellingDateEvent(
            label: 'Mock Seat Allotment', date: DateTime(2026, 6, 27)),
        CounsellingDateEvent(
            label: 'Round 1 Seat Allotment', date: DateTime(2026, 7, 3)),
        CounsellingDateEvent(
            label: 'Round 2 Seat Allotment', date: DateTime(2026, 7, 9)),
        CounsellingDateEvent(
            label: 'Round 3 Seat Allotment', date: DateTime(2026, 7, 15)),
        CounsellingDateEvent(
            label: 'Round 4 Seat Allotment', date: DateTime(2026, 7, 20)),
        CounsellingDateEvent(
            label: 'Round 5 Seat Allotment', date: DateTime(2026, 7, 25)),
        CounsellingDateEvent(
            label: 'CSAB Special Rounds', date: DateTime(2026, 8, 5)),
        CounsellingDateEvent(
            label: 'Final Reporting Deadline', date: DateTime(2026, 8, 12)),
      ],
      tags: const ['JEE Main', 'JEE Advanced', 'IIT', 'NIT', 'IIIT'],
      popularityScore: 98,
    ),
    CounsellingProgram(
      id: 'neet_mcc',
      name: 'NEET-UG MCC/AIQ',
      fullName: 'Medical Counselling Committee — All India Quota Counselling',
      category: CounsellingCategory.medical,
      conductingBody: 'Medical Counselling Committee (MCC), DGHS',
      about:
          'MCC conducts All India Quota (15%) counselling for MBBS/BDS seats '
          'in government colleges plus 100% seats at AIIMS/JIPMER/central '
          'universities, based on NEET-UG rank. State quota seats (85%) are '
          'counselled separately by respective state authorities.',
      eligibility:
          'Valid NEET-UG qualifying rank; 12th with Physics, Chemistry, '
          'Biology and English; minimum age 17 years by admission.',
      registrationProcess:
          'Register at mcc.nic.in with NEET roll number, pay the counselling '
          'fee/security deposit, and fill choices for each round.',
      choiceFillingInfo:
          'Choices are college+course (MBBS/BDS) combinations across AIQ '
          'seats; order strictly by preference across all rounds.',
      choiceLockingInfo:
          'Choices can be edited anytime before the round deadline; there is '
          'no separate manual "lock" step — the list auto-freezes at the cutoff time.',
      seatAllotmentInfo:
          'Allotment is rank-and-choice based against the AIQ seat matrix, '
          'published category-wise (including EWS, PwD, and defence quotas).',
      documentVerificationInfo:
          'Document verification happens at the allotted college on '
          'reporting — originals plus self-attested photocopies are required.',
      reportingInfo:
          'Physically report to the allotted college within the notified '
          'window with all original documents and the allotment letter.',
      admissionConfirmationInfo:
          'Admission is confirmed once the college verifies documents and '
          'collects fees; failure to report cancels the allotment.',
      importantInstructions: const [
        'AIQ Round 1 and 2 are compulsory rounds — no withdrawal without penalty after reporting',
        'State quota and AIQ counselling run on independent, overlapping schedules',
        'Mop-up/Stray vacancy round is the last chance for leftover AIQ seats',
        'NRI/Management quota seats are NOT part of MCC counselling',
        'Always check your state\'s counselling authority for the 85% state quota seats',
      ],
      reservationRules: const [
        'OBC-NCL: 27%, SC: 15%, ST: 7.5%, EWS: 10% (AIQ seats)',
        'PwD: 5% horizontal reservation with valid disability certificate',
        'Deemed/Central universities may have separate reservation policies',
      ],
      seatMatrixNote:
          'AIQ seat matrix (15% of state govt. medical college seats + 100% '
          'central institute seats) is released before Round 1 by MCC.',
      previousYearCutoffs: const [
        'AIIMS Delhi MBBS — closing rank ~62 (General, AIQ)',
        'Maulana Azad Medical College MBBS — closing rank ~350 (General, AIQ)',
        'Government Medical College (state quota, Maharashtra) — closing rank ~7,200 (General)',
      ],
      faqs: const [
        FaqItem(
          question: 'What is the difference between AIQ and state quota?',
          answer:
              'AIQ (15%) is counselled centrally by MCC for all states; state '
              'quota (85%) is counselled by each state\'s own authority for '
              'candidates domiciled there.',
        ),
        FaqItem(
          question: 'Can I participate in both AIQ and state counselling?',
          answer:
              'Yes, most states allow simultaneous participation, but check '
              'your specific state\'s rules on exit/withdrawal penalties.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'NEET-UG admit card & rank letter',
        'Class 10 & 12 mark sheets (proof of age & subjects)',
        'Category/EWS/PwD certificate, if applicable',
        'Provisional allotment letter',
        'Migration certificate (if applicable)',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'MCC AIQ Counselling Explained', url: 'https://mcc.nic.in'),
      ],
      officialWebsite: 'https://mcc.nic.in',
      contactEmail: 'mcc-dghs@gov.in',
      contactPhone: '011-2306-1783',
      timelineSteps: _standardTimelineSteps(
        body: 'Report physically to the allotted medical/dental college with '
            'original documents within the reporting window to confirm your seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'AIQ Registration Begins', date: DateTime(2026, 7, 18)),
        CounsellingDateEvent(
            label: 'Choice Filling Round 1', date: DateTime(2026, 7, 22)),
        CounsellingDateEvent(
            label: 'Round 1 Seat Allotment', date: DateTime(2026, 7, 29)),
        CounsellingDateEvent(
            label: 'Round 1 Reporting Deadline', date: DateTime(2026, 8, 4)),
        CounsellingDateEvent(
            label: 'Round 2 Seat Allotment', date: DateTime(2026, 8, 12)),
        CounsellingDateEvent(
            label: 'Round 2 Reporting Deadline', date: DateTime(2026, 8, 18)),
        CounsellingDateEvent(
            label: 'Mop-up Round Allotment', date: DateTime(2026, 8, 28)),
        CounsellingDateEvent(
            label: 'Stray Vacancy Round', date: DateTime(2026, 9, 8)),
      ],
      tags: const ['NEET', 'MBBS', 'BDS', 'AIIMS'],
      popularityScore: 97,
    ),
    CounsellingProgram(
      id: 'cuet_csas',
      name: 'CUET UG CSAS (DU)',
      fullName: 'Common Seat Allocation System — Delhi University',
      category: CounsellingCategory.cuet,
      conductingBody: 'University of Delhi',
      about:
          'CSAS is Delhi University\'s centralized admission portal for all UG '
          'programmes across its constituent colleges, seat allocation is '
          'purely based on CUET UG scores.',
      eligibility:
          'Valid CUET UG score in the required subject combination; 12th '
          'pass from a recognised board.',
      registrationProcess:
          'Register once on the CSAS portal, fill your programme+college '
          'preferences, and pay the one-time registration fee.',
      choiceFillingInfo:
          'List programme-college combinations in order of preference — DU '
          'allows unlimited preference ordering across all colleges at once.',
      choiceLockingInfo:
          'Preferences can be reordered until the allocation round deadline; '
          'there is no separate freeze step before each round.',
      seatAllotmentInfo:
          'A merit-cum-preference algorithm allots one seat per round based '
          'on CUET percentile and category, matched against your preference order.',
      documentVerificationInfo:
          'Fully online — upload scanned documents; DU colleges verify '
          'digitally before confirming admission.',
      reportingInfo:
          'Accept the allotted seat online and pay the admission fee within '
          'the reporting window for that round.',
      admissionConfirmationInfo:
          'Seat is confirmed once fees are paid; you may still upgrade in '
          'later rounds if a higher preference becomes available.',
      importantInstructions: const [
        'CSAS runs multiple allocation rounds; keep responding each round',
        'Upgradation is automatic if you get a higher preference later',
        'CSAS Phase 2 is where actual seat allocation happens (Phase 1 is only registration)',
        'Spot rounds fill any seats left vacant after regular rounds',
      ],
      reservationRules: const [
        'OBC-NCL: 27%, SC: 15%, ST: 7.5%, EWS: 10%',
        'Sports/ECA/CW quota seats have a separate, parallel process',
        'PwD: 5% horizontal reservation',
      ],
      seatMatrixNote:
          'Each DU college publishes its own programme-wise intake, updated '
          'before each allocation round on the CSAS dashboard.',
      previousYearCutoffs: const [
        'Hindu College B.A. Economics (Hons) — ~99.5 percentile (General)',
        'SRCC B.Com (Hons) — ~99.8 percentile (General)',
        'Miranda House Psychology (Hons) — ~99 percentile (General, Women)',
      ],
      faqs: const [
        FaqItem(
          question: 'Do I need to fill choices separately for each college?',
          answer:
              'No — CSAS lets you rank programme+college combinations across '
              'the entire university in one unified preference list.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'CUET UG scorecard',
        'Class 10 & 12 mark sheets',
        'Category/EWS/PwD/Sports certificate, if applicable',
        'Passport photograph & signature scan',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'DU CSAS Admission Walkthrough',
            url: 'https://admission.uod.ac.in'),
      ],
      officialWebsite: 'https://admission.uod.ac.in',
      contactEmail: 'admissions@du.ac.in',
      contactPhone: '011-2766-7853',
      timelineSteps: _standardTimelineSteps(
        body: 'Accept the seat online, pay the admission fee, and complete '
            'e-verification of documents within the deadline to confirm admission.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'CSAS Registration (Phase 1)', date: DateTime(2026, 6, 5)),
        CounsellingDateEvent(
            label: 'Preference Filling (Phase 2)', date: DateTime(2026, 6, 20)),
        CounsellingDateEvent(
            label: 'Round 1 Allocation', date: DateTime(2026, 7, 1)),
        CounsellingDateEvent(
            label: 'Round 2 Allocation', date: DateTime(2026, 7, 10)),
        CounsellingDateEvent(
            label: 'Round 3 Allocation', date: DateTime(2026, 7, 18)),
        CounsellingDateEvent(label: 'Spot Round', date: DateTime(2026, 7, 28)),
        CounsellingDateEvent(
            label: 'Classes Commence', date: DateTime(2026, 8, 1)),
      ],
      tags: const ['CUET', 'Delhi University', 'B.A.', 'B.Com', 'B.Sc'],
      popularityScore: 88,
    ),
    CounsellingProgram(
      id: 'clat_nlu',
      name: 'CLAT Counselling',
      fullName: 'Consortium of National Law Universities Counselling',
      category: CounsellingCategory.law,
      conductingBody: 'Consortium of NLUs',
      about: 'A single CLAT counselling process allots seats across all 24 '
          'National Law Universities for the 5-year integrated LL.B. and '
          'LL.M. programmes, based on CLAT merit rank.',
      eligibility:
          '12th pass with 45% marks (40% for SC/ST) and a valid CLAT UG rank.',
      registrationProcess:
          'Pay the counselling fee on the Consortium portal after CLAT '
          'results and fill your NLU preference order.',
      choiceFillingInfo:
          'Rank all 24 NLUs (and course, if a university offers more than '
          'one) in your true order of preference.',
      choiceLockingInfo:
          'Preferences can be revised until the seat acceptance deadline of '
          'the ongoing round.',
      seatAllotmentInfo:
          'Seats are allotted purely by CLAT rank against your preference '
          'list and each NLU\'s seat matrix, run over 2-3 rounds.',
      documentVerificationInfo:
          'Document verification is conducted by the allotted NLU directly, '
          'either online or on physical reporting.',
      reportingInfo:
          'Pay the seat-acceptance fee within the window, then report to the '
          'allotted NLU as instructed for final verification.',
      admissionConfirmationInfo:
          'Admission is confirmed once the NLU verifies documents and the '
          'balance fee is paid.',
      importantInstructions: const [
        'CLAT counselling has limited rounds (usually 2) — respond promptly',
        'Partial fee refund policy applies if you withdraw before the deadline',
        'NLU seat-acceptance and college-reporting deadlines can differ — check both',
      ],
      reservationRules: const [
        'Each NLU has its own state-domicile quota (typically 25-50% of seats)',
        'SC: 15%, ST: 7.5%, OBC-NCL and EWS reservations as per NLU-specific policy',
        'PwD: 5% horizontal reservation',
      ],
      seatMatrixNote:
          'Each NLU publishes its own intake and domicile-quota split before '
          'Round 1 on the Consortium portal.',
      previousYearCutoffs: const [
        'NLSIU Bangalore — closing rank ~45 (General)',
        'NALSAR Hyderabad — closing rank ~130 (General)',
        'NLU Delhi — admits via its own separate AILET, not CLAT',
      ],
      faqs: const [
        FaqItem(
          question: 'Is NLU Delhi part of CLAT counselling?',
          answer: 'No, NLU Delhi conducts its own entrance test (AILET) and '
              'counselling, separate from the CLAT Consortium process.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'CLAT scorecard/rank letter',
        'Class 10 & 12 mark sheets',
        'Domicile certificate (for state-quota claims)',
        'Category/EWS/PwD certificate, if applicable',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'CLAT Counselling Process',
            url: 'https://consortiumofnlus.ac.in'),
      ],
      officialWebsite: 'https://consortiumofnlus.ac.in',
      contactEmail: 'clat.admissions@consortiumofnlus.ac.in',
      contactPhone: '0821-251-5533',
      timelineSteps: _standardTimelineSteps(
        body: 'Pay the seat-acceptance fee, then report to the allotted NLU '
            'with original documents to complete admission.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Counselling Registration', date: DateTime(2026, 1, 5)),
        CounsellingDateEvent(
            label: 'Preference Filling', date: DateTime(2026, 1, 15)),
        CounsellingDateEvent(
            label: 'Round 1 Allotment', date: DateTime(2026, 1, 22)),
        CounsellingDateEvent(
            label: 'Round 2 Allotment', date: DateTime(2026, 2, 10)),
        CounsellingDateEvent(
            label: 'Final Reporting', date: DateTime(2026, 6, 15)),
      ],
      tags: const ['CLAT', 'NLU', 'BA LLB', 'Law'],
      popularityScore: 80,
    ),
    CounsellingProgram(
      id: 'cmat_mgmt',
      name: 'CMAT / State MBA Counselling',
      fullName: 'Common Management Admission Test — Institute Counselling',
      category: CounsellingCategory.management,
      conductingBody: 'NTA (exam) + State/Institute Admission Cells',
      about: 'CMAT scores feed into institute-level and state-level (e.g. '
          'MAH-MBA/MMS-CET) counselling for integrated/UG management '
          'programmes such as BBA and BMS at affiliated colleges.',
      eligibility:
          '12th pass with minimum required aggregate (varies by institute, '
          'typically 45-50%) and a valid CMAT/state-CET score.',
      registrationProcess:
          'Register on the respective state/institute counselling portal, '
          'upload documents, and fill college-course preferences.',
      choiceFillingInfo:
          'Rank institute+programme combinations (BBA/BMS/Integrated MBA) '
          'in order of preference across participating colleges.',
      choiceLockingInfo:
          'Preferences can be edited until the round-specific deadline '
          'published by the counselling authority.',
      seatAllotmentInfo:
          'Merit (percentile) and category based allotment against each '
          'institute\'s seat matrix, typically over 2-3 rounds plus CAP rounds.',
      documentVerificationInfo:
          'Document verification is done either online or at designated '
          'Facilitation Centres before seat confirmation.',
      reportingInfo:
          'Report to the allotted institute within the window, pay fees, '
          'and submit verified documents.',
      admissionConfirmationInfo:
          'Admission is confirmed on fee payment and institute-level '
          'document verification sign-off.',
      importantInstructions: const [
        'Institute-level and centralized state CAP rounds may run in parallel — track both',
        'Some private institutes also conduct a personal interview/GD round',
        'Check each college\'s specific minimum eligibility percentage before applying',
      ],
      reservationRules: const [
        'State-quota reservation follows local state government policy',
        'OBC/SC/ST/EWS reservation as per respective state GR',
        'PwD: 5% horizontal reservation',
      ],
      seatMatrixNote:
          'Seat matrix is published institute-wise; management colleges '
          'often have significant management-quota seats outside CAP.',
      previousYearCutoffs: const [
        'NMIMS BBA — CMAT/NPAT percentile ~95+ (General)',
        'Symbiosis BBA (SET) — merit rank within top 2,000 (General)',
      ],
      faqs: const [
        FaqItem(
          question: 'Is CMAT compulsory for all BBA admissions?',
          answer: 'No, many private universities run their own entrance test '
              '(e.g. NPAT, SET) instead of or alongside CMAT.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'CMAT/CET scorecard',
        'Class 10 & 12 mark sheets',
        'Category/EWS certificate, if applicable',
        'Domicile certificate (for state-quota seats)',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'CMAT Counselling Overview', url: 'https://cmat.nta.nic.in'),
      ],
      officialWebsite: 'https://cmat.nta.nic.in',
      contactEmail: 'cmat@nta.ac.in',
      contactPhone: '011-4075-9000',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to the allotted institute with original documents and '
            'pay fees to confirm your management programme seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Counselling Registration', date: DateTime(2026, 6, 15)),
        CounsellingDateEvent(
            label: 'Choice Filling', date: DateTime(2026, 6, 25)),
        CounsellingDateEvent(label: 'CAP Round 1', date: DateTime(2026, 7, 8)),
        CounsellingDateEvent(label: 'CAP Round 2', date: DateTime(2026, 7, 20)),
        CounsellingDateEvent(
            label: 'Institute-level Round', date: DateTime(2026, 8, 1)),
      ],
      tags: const ['CMAT', 'BBA', 'BMS', 'Management'],
      popularityScore: 70,
    ),
    CounsellingProgram(
      id: 'icar_aieea',
      name: 'ICAR AIEEA Counselling',
      fullName: 'All India Entrance Examination for Admission — Counselling',
      category: CounsellingCategory.agriculture,
      conductingBody: 'ICAR (Indian Council of Agricultural Research)',
      about: 'ICAR AIEEA counselling allots the 15% all-India-quota seats in '
          'B.Sc. Agriculture, Horticulture, and allied programmes across '
          'state agricultural universities plus IARI\'s own seats.',
      eligibility:
          '12th with Physics, Chemistry and Biology/Mathematics; valid ICAR '
          'AIEEA UG rank.',
      registrationProcess:
          'Register on the ICAR counselling portal, pay the fee, and fill '
          'university+course preferences.',
      choiceFillingInfo:
          'Rank participating agricultural universities and courses '
          '(Agriculture, Horticulture, Forestry, etc.) by preference.',
      choiceLockingInfo:
          'Choices can be reordered until the round-specific lock deadline.',
      seatAllotmentInfo:
          'Rank-based allotment against the 15% all-India-quota seat matrix '
          'published for each participating university.',
      documentVerificationInfo:
          'Verification is done online with physical verification at the '
          'reporting university.',
      reportingInfo:
          'Report to the allotted university within the deadline with all '
          'original documents.',
      admissionConfirmationInfo:
          'Confirmed once fees are paid and the university completes '
          'document verification.',
      importantInstructions: const [
        'Only 15% of seats at each university are under the ICAR all-India quota',
        'Remaining 85% are filled by respective state counselling',
        'Check individual university reporting deadlines carefully',
      ],
      reservationRules: const [
        'OBC-NCL: 27%, SC: 15%, ST: 7.5%, EWS: 10%',
        'PwD: 5% horizontal reservation',
      ],
      seatMatrixNote:
          'All-India quota matrix is published university-wise before '
          'Round 1 by ICAR.',
      previousYearCutoffs: const [
        'IARI New Delhi B.Sc. Agriculture — closing rank ~250 (General)',
        'PAU Ludhiana B.Sc. Agriculture (AIQ) — closing rank ~1,400 (General)',
      ],
      faqs: const [
        FaqItem(
          question:
              'Can I get a state agricultural university seat without ICAR AIEEA?',
          answer:
              'Yes, 85% of seats are filled via each state\'s own counselling, '
              'often using the same AIEEA score or a separate state CET.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'ICAR AIEEA scorecard',
        'Class 10 & 12 mark sheets',
        'Category/EWS certificate, if applicable',
        'Domicile certificate (for state quota reference)',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'ICAR AIEEA Counselling Guide', url: 'https://icar.org.in'),
      ],
      officialWebsite: 'https://icar.org.in',
      contactEmail: 'aieea@icar.gov.in',
      contactPhone: '011-2584-3375',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to the allotted agricultural university with original '
            'documents to complete verification and confirm your seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Counselling Registration', date: DateTime(2026, 7, 10)),
        CounsellingDateEvent(
            label: 'Choice Filling', date: DateTime(2026, 7, 18)),
        CounsellingDateEvent(
            label: 'Round 1 Allotment', date: DateTime(2026, 7, 26)),
        CounsellingDateEvent(
            label: 'Round 2 Allotment', date: DateTime(2026, 8, 5)),
        CounsellingDateEvent(
            label: 'Reporting Deadline', date: DateTime(2026, 8, 12)),
      ],
      tags: const ['ICAR', 'Agriculture', 'B.Sc Agriculture'],
      popularityScore: 62,
    ),
    CounsellingProgram(
      id: 'biotech_counselling',
      name: 'Biotechnology Admission Counselling',
      fullName: 'GAT-B / University Biotechnology Programme Counselling',
      category: CounsellingCategory.biotechnology,
      conductingBody: 'DBT & participating universities',
      about: 'Admission to undergraduate Biotechnology programmes typically '
          'follows either a university\'s own merit list (board marks/CUET) '
          'or state-level counselling; GAT-B itself is mainly a PG-entry exam '
          'referenced here for students planning ahead.',
      eligibility:
          '12th with Physics, Chemistry, Biology (PCB) or Mathematics (PCM); '
          'minimum aggregate as per the university (typically 50-60%).',
      registrationProcess:
          'Apply directly through each university\'s admission portal or '
          'through CUET-based centralized counselling where applicable.',
      choiceFillingInfo:
          'Where centralized (e.g. via CUET), rank university+course '
          'combinations by preference; where direct, apply to each '
          'university\'s own portal individually.',
      choiceLockingInfo:
          'Direct-admission universities typically do not have a lock step — '
          'merit lists are released and seats confirmed on a first-eligible basis.',
      seatAllotmentInfo:
          'Merit-list based (board percentage/CUET score) allotment against '
          'each university\'s Biotechnology seat intake.',
      documentVerificationInfo:
          'Document verification is usually conducted directly by the '
          'university admission office, online or in person.',
      reportingInfo:
          'Report to the university within the merit-list response window '
          'to confirm admission.',
      admissionConfirmationInfo:
          'Confirmed once fees are paid and documents verified by the '
          'university.',
      importantInstructions: const [
        'Track each target university\'s own merit-list release dates separately',
        'Some universities require a basic aptitude/interview round for Biotech',
        'Compare curriculum focus — pure Biotech vs. Biomedical vs. Industrial Biotech',
      ],
      reservationRules: const [
        'Follows each university\'s own reservation policy (state or central)',
        'EWS/PwD reservation as per governing university statute',
      ],
      seatMatrixNote:
          'Typically 30-120 seats per university depending on institute size; '
          'check individual prospectus for exact intake.',
      previousYearCutoffs: const [
        'Delhi University B.Sc. Biotechnology — ~97 CUET percentile (General)',
        'Panjab University B.Sc. Biotech (Hons) — ~90% aggregate merit (General)',
      ],
      faqs: const [
        FaqItem(
          question: 'Is NEET required for a Biotechnology degree?',
          answer: 'No, most B.Sc. Biotechnology programmes accept PCB or PCM '
              'students via board merit or CUET — NEET is not required.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'Class 10 & 12 mark sheets',
        'CUET scorecard, if the university uses it',
        'Category/EWS certificate, if applicable',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'Choosing a Biotechnology Programme',
            url: 'https://dbtindia.gov.in'),
      ],
      officialWebsite: 'https://dbtindia.gov.in',
      contactEmail: 'info@dbt.nic.in',
      contactPhone: '011-2436-2950',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to the university admission office with original '
            'documents to confirm your Biotechnology programme seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Application Window Opens', date: DateTime(2026, 6, 20)),
        CounsellingDateEvent(label: 'Merit List 1', date: DateTime(2026, 7, 5)),
        CounsellingDateEvent(
            label: 'Merit List 2', date: DateTime(2026, 7, 16)),
        CounsellingDateEvent(
            label: 'Final Reporting', date: DateTime(2026, 7, 30)),
      ],
      tags: const ['Biotechnology', 'GAT-B', 'CUET'],
      popularityScore: 55,
    ),
    CounsellingProgram(
      id: 'design_counselling',
      name: 'NID/UCEED Design Counselling',
      fullName: 'National Institute of Design & UCEED Seat Allotment',
      category: CounsellingCategory.design,
      conductingBody: 'NID Ahmedabad / IIT Bombay (UCEED)',
      about: 'Design counselling allots B.Des seats at NID campuses and '
          'UCEED-accepting institutes (like IIT Bombay/Guwahati/Hyderabad) '
          'based on DAT/UCEED rank plus studio-test performance.',
      eligibility:
          '12th pass (any stream) with minimum 50% aggregate; valid DAT '
          'Mains or UCEED rank.',
      registrationProcess:
          'Register on the respective counselling portal after DAT/UCEED '
          'results, pay the seat-acceptance fee when allotted.',
      choiceFillingInfo:
          'Rank campus+specialisation (Product/Communication/Textile/ '
          'Interaction Design, etc.) combinations by preference.',
      choiceLockingInfo:
          'Preferences can be revised until the round-specific deadline.',
      seatAllotmentInfo:
          'Rank-based allotment against each campus\'s specialisation-wise '
          'seat matrix, typically over 2-3 rounds.',
      documentVerificationInfo:
          'Document verification is conducted online followed by physical '
          'verification at reporting.',
      reportingInfo:
          'Report to the allotted campus within the window with original '
          'documents and portfolio (if applicable).',
      admissionConfirmationInfo:
          'Confirmed once fees are paid and verification is complete.',
      importantInstructions: const [
        'NID and UCEED-affiliated institutes run separate, independent counselling',
        'Studio test/interview performance can affect final specialisation allotment',
        'Confirm campus-specific hostel and fee structures before reporting',
      ],
      reservationRules: const [
        'OBC-NCL: 27%, SC: 15%, ST: 7.5%, EWS: 10%',
        'PwD: 5% horizontal reservation',
      ],
      seatMatrixNote:
          'Seat matrix varies by campus and specialisation — published '
          'ahead of Round 1 on each institute\'s portal.',
      previousYearCutoffs: const [
        'NID Ahmedabad B.Des — closing rank ~250 (General)',
        'IIT Bombay UCEED B.Des — closing rank ~180 (General)',
      ],
      faqs: const [
        FaqItem(
          question: 'Do I need a portfolio for design counselling?',
          answer:
              'Some institutes request a portfolio or conduct a studio test '
              'as part of final specialisation allotment — check your '
              'specific institute\'s process.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'DAT/UCEED scorecard',
        'Class 10 & 12 mark sheets',
        'Category/EWS/PwD certificate, if applicable',
        'Portfolio (if requested by the institute)',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'NID/UCEED Counselling Explained',
            url: 'https://www.nid.edu'),
      ],
      officialWebsite: 'https://www.nid.edu',
      contactEmail: 'admissions@nid.edu',
      contactPhone: '079-2662-3692',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to the allotted design campus with original documents '
            'to complete verification and confirm your seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Counselling Registration', date: DateTime(2026, 6, 1)),
        CounsellingDateEvent(
            label: 'Round 1 Allotment', date: DateTime(2026, 6, 15)),
        CounsellingDateEvent(
            label: 'Round 2 Allotment', date: DateTime(2026, 7, 1)),
        CounsellingDateEvent(
            label: 'Final Reporting', date: DateTime(2026, 7, 15)),
      ],
      tags: const ['NID', 'UCEED', 'B.Des', 'Design'],
      popularityScore: 65,
    ),
    CounsellingProgram(
      id: 'architecture_counselling',
      name: 'B.Arch Counselling (JoSAA/CoA)',
      fullName: 'Architecture Seat Allotment via JEE Main Paper 2 / NATA',
      category: CounsellingCategory.architecture,
      conductingBody: 'JoSAA (for centrally funded institutes) / State CAPs',
      about: 'B.Arch admission to IITs/NITs/SPAs runs through JoSAA using JEE '
          'Main Paper 2 ranks, while most state/private colleges use NATA '
          'scores through state-level or institute counselling.',
      eligibility:
          '12th with Physics, Chemistry, Mathematics and 50%+ aggregate; '
          'valid JEE Main Paper 2 or NATA score.',
      registrationProcess:
          'Register on JoSAA (for centrally funded institutes) or the '
          'relevant state counselling portal for other B.Arch colleges.',
      choiceFillingInfo:
          'Rank institute preferences by campus and reputation; B.Arch '
          'typically has far fewer seats than B.Tech at the same institute.',
      choiceLockingInfo:
          'Lock preferences before the round deadline, same process as '
          'engineering JoSAA counselling.',
      seatAllotmentInfo:
          'Rank-based allotment against each institute\'s (small) B.Arch '
          'seat matrix, over 5-6 rounds plus CSAB/spot rounds.',
      documentVerificationInfo:
          'Online verification, physical/online reporting depending on '
          'institute.',
      reportingInfo:
          'Report to the allotted institute within the deadline with '
          'original documents and drawing/aptitude scorecards.',
      admissionConfirmationInfo:
          'Confirmed once fees are paid and documents verified.',
      importantInstructions: const [
        'B.Arch seats are limited — even top NITs may have only 10-20 seats',
        'NATA scores are mandatory alongside JEE Main Paper 2 at many institutes',
        'Check whether your target college needs a separate drawing test',
      ],
      reservationRules: const [
        'Same reservation structure as JoSAA (OBC-NCL 27%, SC 15%, ST 7.5%, EWS 10%)',
        'Home-state quota applies at NITs (50% of seats)',
      ],
      seatMatrixNote:
          'B.Arch seat counts are far smaller than B.Tech — often under 40 '
          'seats per institute nationally.',
      previousYearCutoffs: const [
        'SPA Delhi B.Arch — closing rank ~450 (General, JEE Main Paper 2)',
        'NIT Trichy B.Arch — closing rank ~2,600 (General)',
      ],
      faqs: const [
        FaqItem(
          question: 'Is NATA compulsory even if I clear JEE Main Paper 2?',
          answer: 'Many institutes (especially state/private ones) require a '
              'valid NATA score in addition to or instead of JEE Main Paper 2 '
              '— always check the specific institute\'s requirement.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'JEE Main Paper 2 / NATA scorecard',
        'Class 10 & 12 mark sheets',
        'Category/EWS/PwD certificate, if applicable',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'B.Arch Counselling via JoSAA', url: 'https://josaa.nic.in'),
      ],
      officialWebsite: 'https://josaa.nic.in',
      contactEmail: 'josaa2026@iitb.ac.in',
      contactPhone: '011-2676-7033',
      timelineSteps: _standardTimelineSteps(
        body: 'Report to the allotted architecture programme with original '
            'documents and scorecards to confirm your seat.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Registration & Choice Filling',
            date: DateTime(2026, 6, 10)),
        CounsellingDateEvent(
            label: 'Round 1 Allotment', date: DateTime(2026, 7, 4)),
        CounsellingDateEvent(
            label: 'Round 2 Allotment', date: DateTime(2026, 7, 12)),
        CounsellingDateEvent(
            label: 'Round 3 Allotment', date: DateTime(2026, 7, 20)),
        CounsellingDateEvent(
            label: 'Final Reporting', date: DateTime(2026, 8, 3)),
      ],
      tags: const ['B.Arch', 'NATA', 'JEE Main Paper 2'],
      popularityScore: 58,
    ),
    CounsellingProgram(
      id: 'maharashtra_cet',
      name: 'Maharashtra CAP (State Counselling)',
      fullName: 'Maharashtra Centralized Admission Process — MHT-CET',
      category: CounsellingCategory.stateCounselling,
      conductingBody: 'State CET Cell, Maharashtra',
      about: 'A representative example of state-level engineering/pharmacy '
          'counselling: Maharashtra\'s CAP allots seats at state, university '
          'and private engineering colleges based on MHT-CET percentile. '
          'Most states (Gujarat ACPC, UP JEECUP, TN TNEA, etc.) follow a '
          'broadly similar CAP-round structure.',
      eligibility:
          '12th with Physics, Mathematics + Chemistry/Biology and 45%+ '
          'aggregate (40% for reserved categories); valid MHT-CET percentile.',
      registrationProcess:
          'Register on the CET Cell portal, complete document verification '
          'at a Facilitation Centre (online or in person), then fill choices.',
      choiceFillingInfo:
          'Rank college+branch combinations across the state by preference — '
          'home-university and home-district preferences can affect priority.',
      choiceLockingInfo:
          'Confirm/lock your choice list before each CAP round deadline.',
      seatAllotmentInfo:
          'Percentile and category based allotment against the state seat '
          'matrix, run over multiple CAP rounds plus an institute-level round.',
      documentVerificationInfo:
          'Mandatory document verification at a Facilitation Centre before '
          'the first CAP round — either online or in person.',
      reportingInfo:
          'Confirm the allotted seat online and report to the college '
          'within the window with original documents.',
      admissionConfirmationInfo:
          'Confirmed once fees are paid and the college verifies documents.',
      importantInstructions: const [
        'Facilitation Centre (FC) verification is mandatory before Round 1',
        'Home University/Regional preference can influence allotment priority',
        'Institute-level quota rounds happen after CAP rounds for private colleges',
      ],
      reservationRules: const [
        'Maharashtra state reservation: OBC 19%, SC 13%, ST 7%, VJ/NT categories, EWS 10%',
        'Home-university and home-district quotas apply at many colleges',
        'PwD: 4% horizontal reservation (state policy)',
      ],
      seatMatrixNote:
          'Seat matrix is published college+branch wise before each CAP '
          'round by the State CET Cell.',
      previousYearCutoffs: const [
        'VJTI Mumbai CSE — ~99.7 percentile (General, MHT-CET)',
        'COEP Pune CSE — ~99.5 percentile (General, MHT-CET)',
      ],
      faqs: const [
        FaqItem(
          question: 'Do other states follow the same process?',
          answer:
              'Most states run a similar Facilitation-Centre → choice filling '
              '→ CAP rounds → institute-level round structure (e.g. Gujarat '
              'ACPC, UP JEECUP, TN TNEA), though exact names and dates differ.',
        ),
      ],
      requiredDocuments: _standardDocuments,
      documentChecklist: const [
        'MHT-CET scorecard',
        'Class 10 & 12 mark sheets',
        'Domicile & category certificate, if applicable',
        'Facilitation Centre verification receipt',
      ],
      commonMistakes: _standardMistakes,
      videoResources: const [
        VideoResource(
            title: 'Maharashtra CAP Process',
            url: 'https://cetcell.mahacet.org'),
      ],
      officialWebsite: 'https://cetcell.mahacet.org',
      contactEmail: 'cetcell@mahacet.org',
      contactPhone: '022-2265-9303',
      timelineSteps: _standardTimelineSteps(
        body: 'Confirm the allotted seat online, then report to the college '
            'with original documents within the deadline to complete admission.',
      ),
      dateEvents: [
        CounsellingDateEvent(
            label: 'Facilitation Centre Verification',
            date: DateTime(2026, 6, 25)),
        CounsellingDateEvent(
            label: 'Choice Filling', date: DateTime(2026, 7, 2)),
        CounsellingDateEvent(label: 'CAP Round 1', date: DateTime(2026, 7, 11)),
        CounsellingDateEvent(label: 'CAP Round 2', date: DateTime(2026, 7, 22)),
        CounsellingDateEvent(label: 'CAP Round 3', date: DateTime(2026, 8, 1)),
        CounsellingDateEvent(
            label: 'Institute-level Round', date: DateTime(2026, 8, 10)),
      ],
      tags: const ['MHT-CET', 'State Counselling', 'Maharashtra'],
      popularityScore: 68,
    ),
  ];
}

import '../models/assessment_question.dart';
import '../models/assessment_type.dart';

class QuestionBank {
  static List<AssessmentQuestion> getQuestions(AssessmentType type) {
    switch (type) {
      case AssessmentType.class8to10:
        return _class8to10Questions;
      case AssessmentType.class11:
        return _class11Questions;
      case AssessmentType.class12:
        return _class12Questions;
    }
  }

  // ---------------------------------------------------------------------
  // Class 8-10 Questions (15)
  // Focus: interests, stream discovery, hobbies, learning style, future goals
  // ---------------------------------------------------------------------
  static final List<AssessmentQuestion> _class8to10Questions = [
    const AssessmentQuestion(
      id: 'c810_q1',
      question: 'Which subject do you enjoy studying the most?',
      options: [
        'Mathematics',
        'Science',
        'Social Studies / History',
        'Languages / Literature',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c810_q2',
      question: 'Do you enjoy solving puzzles, riddles, or brain teasers?',
      options: [
        'Yes, I love them',
        'Sometimes',
        'Not really',
      ],
      category: 'problem_solving',
    ),
    const AssessmentQuestion(
      id: 'c810_q3',
      question:
          'Are you curious about how machines, gadgets, or computers work?',
      options: [
        'Yes',
        'A little',
        'No',
      ],
      category: 'technology',
    ),
    const AssessmentQuestion(
      id: 'c810_q4',
      question:
          'Do you enjoy drawing, painting, music, or other creative activities?',
      options: [
        'Yes, very much',
        'Occasionally',
        'Not my thing',
      ],
      category: 'creativity',
    ),
    const AssessmentQuestion(
      id: 'c810_q5',
      question:
          'Which stream are you currently leaning towards after Class 10?',
      options: [
        'Science',
        'Commerce',
        'Humanities/Arts',
        'Not sure yet',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c810_q6',
      question: 'Do you like conducting small experiments or science projects?',
      options: [
        'Yes',
        'Sometimes',
        'No',
      ],
      category: 'science',
    ),
    const AssessmentQuestion(
      id: 'c810_q7',
      question: 'How do you prefer to learn new topics?',
      options: [
        'Reading books and notes',
        'Watching videos',
        'Hands-on practice',
        'Group discussions',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c810_q8',
      question: 'Do you enjoy leading group projects or activities at school?',
      options: [
        'Yes, I like to lead',
        'I prefer supporting the leader',
        'I like working alone',
      ],
      category: 'leadership',
    ),
    const AssessmentQuestion(
      id: 'c810_q9',
      question: 'Are you comfortable speaking in front of your class?',
      options: [
        'Yes, very comfortable',
        'A bit nervous but okay',
        'I avoid it if possible',
      ],
      category: 'communication',
    ),
    const AssessmentQuestion(
      id: 'c810_q10',
      question: 'What kind of hobbies do you enjoy the most?',
      options: [
        'Reading and writing',
        'Building/fixing things',
        'Sports and outdoor activities',
        'Art, music, or design',
      ],
      category: 'creativity',
    ),
    const AssessmentQuestion(
      id: 'c810_q11',
      question: 'Do you enjoy working with numbers and calculations?',
      options: [
        'Yes, a lot',
        'Sometimes',
        'Not really',
      ],
      category: 'mathematics',
    ),
    const AssessmentQuestion(
      id: 'c810_q12',
      question:
          'Would you be interested in starting your own small business or selling something someday?',
      options: [
        'Yes, definitely',
        'Maybe',
        'Not interested',
      ],
      category: 'entrepreneurship',
    ),
    const AssessmentQuestion(
      id: 'c810_q13',
      question: 'Do you enjoy working in a team rather than alone?',
      options: [
        'Yes, I enjoy teamwork',
        'Depends on the task',
        'I prefer working alone',
      ],
      category: 'teamwork',
    ),
    const AssessmentQuestion(
      id: 'c810_q14',
      question: 'What do you imagine yourself doing in the future?',
      options: [
        'Working in a scientific or technical field',
        'Running my own business',
        'Working in government, law, or social service',
        'Not sure yet, still exploring',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c810_q15',
      question:
          'Are you interested in current affairs, history, or how society works?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not particularly',
      ],
      category: 'humanities',
    ),
  ];

  // ---------------------------------------------------------------------
  // Class 11 Questions (15)
  // Focus: JEE, NEET, Commerce, Humanities, CUET
  // ---------------------------------------------------------------------
  static final List<AssessmentQuestion> _class11Questions = [
    const AssessmentQuestion(
      id: 'c11_q1',
      question:
          'Are you preparing for or interested in JEE (Engineering entrance)?',
      options: [
        'Yes, actively preparing',
        'Considering it',
        'Not interested',
      ],
      category: 'mathematics',
    ),
    const AssessmentQuestion(
      id: 'c11_q2',
      question:
          'Are you preparing for or interested in NEET (Medical entrance)?',
      options: [
        'Yes, actively preparing',
        'Considering it',
        'Not interested',
      ],
      category: 'medical',
    ),
    const AssessmentQuestion(
      id: 'c11_q3',
      question:
          'How comfortable are you with Physics and Mathematics problem-solving?',
      options: [
        'Very comfortable',
        'Moderately comfortable',
        'I struggle with it',
      ],
      category: 'problem_solving',
    ),
    const AssessmentQuestion(
      id: 'c11_q4',
      question: 'How interested are you in Biology and life sciences?',
      options: [
        'Very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'science',
    ),
    const AssessmentQuestion(
      id: 'c11_q5',
      question:
          'Are you interested in Commerce subjects like Accountancy, Business Studies, or Economics?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'commerce',
    ),
    const AssessmentQuestion(
      id: 'c11_q6',
      question:
          'Would you like to pursue a career in finance, business, or management?',
      options: [
        'Yes',
        'Maybe',
        'No',
      ],
      category: 'commerce',
    ),
    const AssessmentQuestion(
      id: 'c11_q7',
      question:
          'Are you interested in Humanities subjects like Political Science, Psychology, or Sociology?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'humanities',
    ),
    const AssessmentQuestion(
      id: 'c11_q8',
      question:
          'Do you enjoy writing essays, analyzing texts, or debating ideas?',
      options: [
        'Yes, I enjoy this a lot',
        'Sometimes',
        'Not really',
      ],
      category: 'communication',
    ),
    const AssessmentQuestion(
      id: 'c11_q9',
      question: 'Are you planning to take CUET for university admissions?',
      options: [
        'Yes, definitely',
        'Possibly',
        'Not planning to',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c11_q10',
      question: 'Do you enjoy coding or building small programs/apps?',
      options: [
        'Yes, regularly',
        'I have tried it a little',
        'Never tried it',
      ],
      category: 'coding',
    ),
    const AssessmentQuestion(
      id: 'c11_q11',
      question: 'Are you interested in scientific research as a career path?',
      options: [
        'Yes, very interested',
        'Possibly in the future',
        'Not interested',
      ],
      category: 'research',
    ),
    const AssessmentQuestion(
      id: 'c11_q12',
      question:
          'How do you handle competitive exam pressure and long study hours?',
      options: [
        'I manage it well',
        'It is challenging but manageable',
        'I find it quite stressful',
      ],
      category: 'problem_solving',
    ),
    const AssessmentQuestion(
      id: 'c11_q13',
      question:
          'Do you see yourself starting your own venture someday instead of a regular job?',
      options: [
        'Yes, definitely',
        'Maybe later',
        'Prefer a stable job',
      ],
      category: 'entrepreneurship',
    ),
    const AssessmentQuestion(
      id: 'c11_q14',
      question:
          'Do you take initiative in group activities, clubs, or student bodies?',
      options: [
        'Yes, often',
        'Sometimes',
        'Rarely',
      ],
      category: 'leadership',
    ),
    const AssessmentQuestion(
      id: 'c11_q15',
      question: 'Which entrance exam track best matches your current focus?',
      options: [
        'JEE (Engineering)',
        'NEET (Medical)',
        'CUET (General/Commerce/Humanities)',
        'Still undecided',
      ],
      category: 'career',
    ),
  ];

  // ---------------------------------------------------------------------
  // Class 12 Questions (15)
  // Focus: college planning, entrance exams, career planning
  // ---------------------------------------------------------------------
  static final List<AssessmentQuestion> _class12Questions = [
    const AssessmentQuestion(
      id: 'c12_q1',
      question:
          'Have you finalized which entrance exams you are appearing for?',
      options: [
        'Yes, fully finalized',
        'Mostly decided, some flexibility',
        'Still exploring options',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c12_q2',
      question: 'Which type of college/course are you targeting?',
      options: [
        'Engineering (B.Tech/B.E.)',
        'Medical (MBBS/BDS)',
        'Commerce/Management (B.Com/BBA)',
        'Humanities/Arts/Law',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c12_q3',
      question: 'How confident are you about your performance in board exams?',
      options: [
        'Very confident',
        'Fairly confident',
        'A bit worried',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c12_q4',
      question: 'Are you considering studying abroad for higher education?',
      options: [
        'Yes, actively planning',
        'Considering it as an option',
        'Prefer to study in India',
      ],
      category: 'education',
    ),
    const AssessmentQuestion(
      id: 'c12_q5',
      question: 'How important is college ranking/brand name in your decision?',
      options: [
        'Very important',
        'Somewhat important',
        'Not a major factor',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c12_q6',
      question:
          'Are you interested in technology fields like Computer Science or AI?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'technology',
    ),
    const AssessmentQuestion(
      id: 'c12_q7',
      question: 'Do you have a clear long-term career goal in mind?',
      options: [
        'Yes, very clear',
        'A rough idea',
        'No, still figuring it out',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c12_q8',
      question:
          'Are you interested in pursuing research-oriented programs (e.g., BS-MS, integrated PhD)?',
      options: [
        'Yes, very interested',
        'Open to it',
        'Prefer professional/applied courses',
      ],
      category: 'research',
    ),
    const AssessmentQuestion(
      id: 'c12_q9',
      question: 'How do you feel about coding-intensive courses?',
      options: [
        'Excited about it',
        'Neutral, willing to learn',
        'Would rather avoid heavy coding',
      ],
      category: 'coding',
    ),
    const AssessmentQuestion(
      id: 'c12_q10',
      question:
          'Are you interested in commerce-based careers like CA, CS, or Investment Banking?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'commerce',
    ),
    const AssessmentQuestion(
      id: 'c12_q11',
      question:
          'Are you interested in careers in law, public policy, or civil services?',
      options: [
        'Yes, very interested',
        'Somewhat interested',
        'Not interested',
      ],
      category: 'humanities',
    ),
    const AssessmentQuestion(
      id: 'c12_q12',
      question: 'How do you plan to choose your final college/course?',
      options: [
        'Based on entrance exam rank/score',
        'Based on personal interest and passion',
        'Based on family or mentor advice',
        'Based on job/placement prospects',
      ],
      category: 'career',
    ),
    const AssessmentQuestion(
      id: 'c12_q13',
      question:
          'Would you consider an entrepreneurial path instead of a traditional degree-job route?',
      options: [
        'Yes, strongly considering it',
        'Open to it after gaining experience',
        'Prefer the traditional path',
      ],
      category: 'entrepreneurship',
    ),
    const AssessmentQuestion(
      id: 'c12_q14',
      question:
          'How well do you handle the stress of exam results and admission uncertainty?',
      options: [
        'I handle it calmly',
        'It is manageable with effort',
        'I find it quite stressful',
      ],
      category: 'problem_solving',
    ),
    const AssessmentQuestion(
      id: 'c12_q15',
      question:
          'Have you started researching colleges, cutoffs, and application processes?',
      options: [
        'Yes, thoroughly researched',
        'Started but not finished',
        'Not yet started',
      ],
      category: 'education',
    ),
  ];
}

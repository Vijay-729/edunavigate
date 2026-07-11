import '../models/career_assessment_model.dart';

/// 8 quick-pick questions (interests, subjects, skills, goals, budget,
/// location, work style, personality) used to rank careers by tag overlap.
/// Deliberately separate from the onboarding self-assessment — this one
/// asks budget/location questions the general assessment doesn't.
class CareerAssessmentQuestions {
  CareerAssessmentQuestions._();

  static const List<CareerAssessmentQuestion> all = [
    CareerAssessmentQuestion(
      id: 'favourite_subject',
      question: 'Which subject do you enjoy the most?',
      options: [
        AssessmentOption(
            label: 'Maths & Physics', tags: ['tech', 'analytical', 'ai_ml']),
        AssessmentOption(
            label: 'Biology', tags: ['healthcare', 'biology', 'research']),
        AssessmentOption(
            label: 'Business & Economics',
            tags: ['business', 'entrepreneurship']),
        AssessmentOption(
            label: 'History & Civics', tags: ['government', 'law', 'writing']),
        AssessmentOption(label: 'Art & Design', tags: ['design', 'creative']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'excitement',
      question: 'What excites you most about a career?',
      options: [
        AssessmentOption(
            label: 'Building products & apps', tags: ['tech', 'coding']),
        AssessmentOption(
            label: 'Helping people directly',
            tags: ['healthcare', 'helping_people', 'psychology']),
        AssessmentOption(
            label: 'Solving mysteries through research',
            tags: ['science', 'research']),
        AssessmentOption(
            label: 'Leading & organizing people',
            tags: ['leadership', 'business']),
        AssessmentOption(
            label: 'Creative expression', tags: ['creative', 'design']),
        AssessmentOption(
            label: 'Serving the nation', tags: ['government', 'law']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'strongest_skill',
      question: 'Which skill do you feel strongest in?',
      options: [
        AssessmentOption(
            label: 'Logical & analytical thinking',
            tags: ['analytical', 'tech', 'ai_ml']),
        AssessmentOption(
            label: 'Communication & empathy',
            tags: ['communication', 'helping_people', 'psychology']),
        AssessmentOption(
            label: 'Creativity & visualization', tags: ['creative', 'design']),
        AssessmentOption(
            label: 'Persuasion & leadership', tags: ['leadership', 'business']),
        AssessmentOption(
            label: 'Attention to detail', tags: ['analytical', 'research']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'goal',
      question: 'What is your long-term goal?',
      options: [
        AssessmentOption(
            label: 'Build cutting-edge technology', tags: ['tech', 'ai_ml']),
        AssessmentOption(
            label: 'Get a stable government job',
            tags: ['government', 'govt_job']),
        AssessmentOption(
            label: 'Run my own business',
            tags: ['entrepreneurship', 'business']),
        AssessmentOption(
            label: 'Make scientific discoveries',
            tags: ['science', 'research']),
        AssessmentOption(
            label: 'Serve society & help people',
            tags: ['helping_people', 'law']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'budget',
      question: 'What is your budget comfort for higher education?',
      options: [
        AssessmentOption(
            label: 'Government college (low cost)',
            tags: ['low_budget', 'govt_job']),
        AssessmentOption(
            label: 'Private college is fine', tags: ['high_budget_ok']),
        AssessmentOption(
            label: 'I need scholarships/loans', tags: ['low_budget']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'location',
      question: 'What is your preferred work location?',
      options: [
        AssessmentOption(
            label: 'Anywhere in India (posting-based)', tags: ['govt_job']),
        AssessmentOption(
            label: 'Metro cities / tech hubs', tags: ['tech', 'business']),
        AssessmentOption(
            label: 'Remote / work-from-anywhere',
            tags: ['remote_friendly', 'tech']),
        AssessmentOption(label: 'Hospitals / clinics', tags: ['healthcare']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'work_style',
      question: 'What is your preferred work style?',
      options: [
        AssessmentOption(
            label: 'Independent, deep-focus work',
            tags: ['tech', 'research', 'analytical']),
        AssessmentOption(
            label: 'Team collaboration', tags: ['business', 'leadership']),
        AssessmentOption(
            label: 'Field / hands-on work', tags: ['hands_on', 'healthcare']),
        AssessmentOption(
            label: 'Public-facing role',
            tags: ['communication', 'helping_people']),
      ],
    ),
    CareerAssessmentQuestion(
      id: 'personality',
      question: 'How would you describe your personality?',
      options: [
        AssessmentOption(
            label: 'Analytical & curious',
            tags: ['analytical', 'science', 'tech']),
        AssessmentOption(
            label: 'Empathetic & caring',
            tags: ['helping_people', 'healthcare', 'psychology']),
        AssessmentOption(
            label: 'Bold & persuasive',
            tags: ['leadership', 'business', 'entrepreneurship']),
        AssessmentOption(
            label: 'Creative & expressive',
            tags: ['creative', 'design', 'writing']),
      ],
    ),
  ];
}

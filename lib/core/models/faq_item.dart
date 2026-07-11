/// A single question/answer pair — reused across Exam Universe, Career
/// Roadmap and Education Loan detail pages.
class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});

  Map<String, dynamic> toMap() => {'question': question, 'answer': answer};
  factory FaqItem.fromMap(Map<String, dynamic> map) => FaqItem(
        question: map['question'] as String? ?? '',
        answer: map['answer'] as String? ?? '',
      );
}

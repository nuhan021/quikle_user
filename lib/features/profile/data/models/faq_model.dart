class FaqModel {
  final String id;
  final String question;
  final String answer;
  final bool isExpanded;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FaqModel copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

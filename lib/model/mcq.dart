class MCQ {
  String question;
  List<String> choices;
  int answerIndex;
  String explanation;

  MCQ({required this.question, required this.choices, required this.answerIndex, required this.explanation});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'choices': choices,
      'answerIndex': answerIndex,
      'explanation':explanation,
    };
  }
}
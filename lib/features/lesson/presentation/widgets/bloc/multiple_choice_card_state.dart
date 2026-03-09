class MultipleChoiceCardState {
  const MultipleChoiceCardState({
    required this.selectedOptionIndex,
    required this.isAnswerCorrect,
    required this.feedbackMessage,
  });

  const MultipleChoiceCardState.initial()
    : selectedOptionIndex = null,
      isAnswerCorrect = null,
      feedbackMessage = null;

  final int? selectedOptionIndex;
  final bool? isAnswerCorrect;
  final String? feedbackMessage;

  bool get isLocked => isAnswerCorrect == true;
  bool get canCheck => selectedOptionIndex != null && !isLocked;

  MultipleChoiceCardState copyWith({
    int? selectedOptionIndex,
    bool clearSelectedOptionIndex = false,
    bool? isAnswerCorrect,
    bool clearIsAnswerCorrect = false,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return MultipleChoiceCardState(
      selectedOptionIndex: clearSelectedOptionIndex
          ? null
          : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswerCorrect: clearIsAnswerCorrect
          ? null
          : (isAnswerCorrect ?? this.isAnswerCorrect),
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }
}

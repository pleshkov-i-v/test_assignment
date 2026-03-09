sealed class MultipleChoiceCardEvent {
  const MultipleChoiceCardEvent();
}

final class MultipleChoiceOptionSelected extends MultipleChoiceCardEvent {
  const MultipleChoiceOptionSelected({required this.optionIndex});

  final int optionIndex;
}

final class MultipleChoiceAnswerChecked extends MultipleChoiceCardEvent {
  const MultipleChoiceAnswerChecked();
}

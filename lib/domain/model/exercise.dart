sealed class Exercise {
  const Exercise({required this.id});

  final String id;
}

class MultipleChoiceExercise extends Exercise {
  const MultipleChoiceExercise({
    required super.id,
    required this.phrase,
    required this.options,
    required this.correctOptionIndex,
  });

  final String phrase;
  final List<String> options;
  final int correctOptionIndex;
}

class ReadOutLoudExercise extends Exercise {
  const ReadOutLoudExercise({required super.id, required this.textToRead});

  final String textToRead;
}

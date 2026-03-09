sealed class SpeechToTextCardEvent {
  const SpeechToTextCardEvent();
}

final class SpeechRecognitionInitialized extends SpeechToTextCardEvent {
  const SpeechRecognitionInitialized();
}

final class SpeechRecognitionStarted extends SpeechToTextCardEvent {
  const SpeechRecognitionStarted();
}

final class SpeechRecognitionStopped extends SpeechToTextCardEvent {
  const SpeechRecognitionStopped();
}

final class SpeechRecognitionResultUpdated extends SpeechToTextCardEvent {
  const SpeechRecognitionResultUpdated({
    required this.recognizedText,
    required this.isFinalResult,
  });

  final String recognizedText;
  final bool isFinalResult;
}

final class SpeechRecognitionStatusChanged extends SpeechToTextCardEvent {
  const SpeechRecognitionStatusChanged({required this.status});

  final String status;
}

final class SpeechRecognitionErrorOccurred extends SpeechToTextCardEvent {
  const SpeechRecognitionErrorOccurred({
    required this.errorMessage,
    required this.isPermanent,
  });

  final String errorMessage;
  final bool isPermanent;
}

class SpeechToTextCardState {
  const SpeechToTextCardState({
    required this.isRecognizerReady,
    required this.isListening,
    required this.lastStatus,
    required this.recognizedText,
    required this.isRecognitionCorrect,
    required this.feedbackMessage,
  });

  const SpeechToTextCardState.initial()
    : isRecognizerReady = false,
      isListening = false,
      lastStatus = null,
      recognizedText = null,
      isRecognitionCorrect = null,
      feedbackMessage = null;

  final bool isRecognizerReady;
  final bool isListening;
  final String? lastStatus;
  final String? recognizedText;
  final bool? isRecognitionCorrect;
  final String? feedbackMessage;

  bool get canContinue => isRecognitionCorrect == true;
  bool get canStartListening => isRecognizerReady && !isListening;

  SpeechToTextCardState copyWith({
    bool? isRecognizerReady,
    bool? isListening,
    String? lastStatus,
    bool clearLastStatus = false,
    String? recognizedText,
    bool clearRecognizedText = false,
    bool? isRecognitionCorrect,
    bool clearRecognitionCorrect = false,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return SpeechToTextCardState(
      isRecognizerReady: isRecognizerReady ?? this.isRecognizerReady,
      isListening: isListening ?? this.isListening,
      lastStatus: clearLastStatus ? null : (lastStatus ?? this.lastStatus),
      recognizedText: clearRecognizedText
          ? null
          : (recognizedText ?? this.recognizedText),
      isRecognitionCorrect: clearRecognitionCorrect
          ? null
          : (isRecognitionCorrect ?? this.isRecognitionCorrect),
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }
}

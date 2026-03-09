import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_event.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_state.dart';

class SpeechToTextCardBloc
    extends Bloc<SpeechToTextCardEvent, SpeechToTextCardState> {
  SpeechToTextCardBloc({
    required String expectedText,
    SpeechToText? speechToText,
  }) : _expectedText = expectedText,
       _speechToText = speechToText ?? SpeechToText(),
       super(const SpeechToTextCardState.initial()) {
    on<SpeechRecognitionInitialized>(_onSpeechRecognitionInitialized);
    on<SpeechRecognitionStarted>(_onSpeechRecognitionStarted);
    on<SpeechRecognitionStopped>(_onSpeechRecognitionStopped);
    on<SpeechRecognitionResultUpdated>(_onSpeechRecognitionResultUpdated);
    on<SpeechRecognitionStatusChanged>(_onSpeechRecognitionStatusChanged);
    on<SpeechRecognitionErrorOccurred>(_onSpeechRecognitionErrorOccurred);

    add(const SpeechRecognitionInitialized());
  }

  final String _expectedText;
  final SpeechToText _speechToText;

  Future<void> _onSpeechRecognitionInitialized(
    SpeechRecognitionInitialized event,
    Emitter<SpeechToTextCardState> emit,
  ) async {
    final bool isAvailable = await _speechToText.initialize(
      onStatus: (String status) {
        add(SpeechRecognitionStatusChanged(status: status));
      },
      onError: (SpeechRecognitionError error) {
        add(
          SpeechRecognitionErrorOccurred(
            errorMessage: error.errorMsg,
            isPermanent: error.permanent,
          ),
        );
      },
    );

    emit(
      state.copyWith(
        isRecognizerReady: isAvailable,
        feedbackMessage: isAvailable
            ? null
            : 'Speech recognition is unavailable. Check microphone permissions.',
      ),
    );
  }

  Future<void> _onSpeechRecognitionStarted(
    SpeechRecognitionStarted event,
    Emitter<SpeechToTextCardState> emit,
  ) async {
    if (!state.canStartListening) {
      return;
    }

    emit(
      state.copyWith(
        isListening: true,
        clearRecognizedText: true,
        clearRecognitionCorrect: true,
        clearFeedbackMessage: true,
      ),
    );

    final locales = await _speechToText.locales();
    final localeId =
        locales
            .where((LocaleName locale) => locale.localeId.contains('es'))
            .firstOrNull
            ?.localeId ??
        locales.first.localeId;

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        add(
          SpeechRecognitionResultUpdated(
            recognizedText: result.recognizedWords,
            isFinalResult: result.finalResult,
          ),
        );
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
      localeId: localeId,
    );
  }

  Future<void> _onSpeechRecognitionStopped(
    SpeechRecognitionStopped event,
    Emitter<SpeechToTextCardState> emit,
  ) async {
    if (!state.isListening) {
      return;
    }

    await _speechToText.stop();
    final String recognizedText = state.recognizedText ?? '';
    final bool recognizedCorrectly = _isExpectedPhrase(recognizedText);

    emit(
      state.copyWith(
        isListening: false,
        recognizedText: recognizedText,
        isRecognitionCorrect: recognizedCorrectly,
        feedbackMessage: recognizedCorrectly
            ? 'Recognized correctly! You can continue.'
            : 'Recognition mismatch. Hold and try again.',
      ),
    );
  }

  void _onSpeechRecognitionResultUpdated(
    SpeechRecognitionResultUpdated event,
    Emitter<SpeechToTextCardState> emit,
  ) {
    emit(state.copyWith(recognizedText: event.recognizedText));
  }

  void _onSpeechRecognitionStatusChanged(
    SpeechRecognitionStatusChanged event,
    Emitter<SpeechToTextCardState> emit,
  ) {
    emit(state.copyWith(lastStatus: event.status));
  }

  void _onSpeechRecognitionErrorOccurred(
    SpeechRecognitionErrorOccurred event,
    Emitter<SpeechToTextCardState> emit,
  ) {
    emit(
      state.copyWith(
        isListening: false,
        feedbackMessage: event.isPermanent
            ? 'Speech recognition error: ${event.errorMessage}.'
            : 'Temporary recognition issue: ${event.errorMessage}. Try again.',
      ),
    );
  }

  bool _isExpectedPhrase(String recognizedText) {
    final String normalizedExpected = _normalizeLettersOnly(_expectedText);
    final String normalizedRecognized = _normalizeLettersOnly(recognizedText);
    return normalizedRecognized.isNotEmpty &&
        normalizedExpected.toLowerCase() == normalizedRecognized.toLowerCase();
  }

  String _normalizeLettersOnly(String value) {
    // Keep only letters and lowercase them
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      final String ch = value[i];
      if (RegExp(r'[a-zA-Záéíóúüñ]').hasMatch(ch)) {
        buffer.write(ch.toLowerCase());
      }
    }
    return buffer.toString();
  }

  @override
  Future<void> close() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    return super.close();
  }
}

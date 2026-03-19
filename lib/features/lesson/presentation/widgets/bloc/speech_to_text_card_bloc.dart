import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:test_case/domain/model/language_entity.dart';
import 'package:test_case/domain/service/i_recognized_text_check_service.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_event.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_state.dart';

class SpeechToTextCardBloc
    extends Bloc<SpeechToTextCardEvent, SpeechToTextCardState> {
  SpeechToTextCardBloc({
    required LanguageEntity language,
    required IRecognizedTextCheckService recognizedTextCheckService,
    required String expectedText,
    SpeechToText? speechToText,
  }) : _expectedText = expectedText,
       _language = language,
       _recognizedTextCheckService = recognizedTextCheckService,
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
  final LanguageEntity _language;
  final IRecognizedTextCheckService _recognizedTextCheckService;
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
    final bool recognizedCorrectly = _recognizedTextCheckService
        .isExpectedPhrase(_language, _expectedText, recognizedText);

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

  @override
  Future<void> close() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    return super.close();
  }
}

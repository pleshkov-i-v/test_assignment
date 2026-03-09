import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_bloc.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_event.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/speech_to_text_card_state.dart';

class SpeechToTextExerciseCard extends StatelessWidget {
  const SpeechToTextExerciseCard({
    super.key,
    required this.textToRead,
    required this.onDone,
  });

  final String textToRead;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpeechToTextCardBloc>(
      create: (_) => SpeechToTextCardBloc(expectedText: textToRead),
      child: BlocBuilder<SpeechToTextCardBloc, SpeechToTextCardState>(
        builder: (BuildContext context, SpeechToTextCardState state) {
          final bool isSuccess = state.isRecognitionCorrect == true;
          final bool canUseRecognizer = state.isRecognizerReady;

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Speak this phrase',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textToRead,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    canUseRecognizer
                        ? 'Press and hold the microphone to speak.'
                        : 'Speech recognition is unavailable on this device.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onLongPressStart: canUseRecognizer
                          ? (_) {
                              context.read<SpeechToTextCardBloc>().add(
                                const SpeechRecognitionStarted(),
                              );
                            }
                          : null,
                      onLongPressEnd: canUseRecognizer
                          ? (_) {
                              context.read<SpeechToTextCardBloc>().add(
                                const SpeechRecognitionStopped(),
                              );
                            }
                          : null,
                      child: ElevatedButton.icon(
                        onPressed: canUseRecognizer ? () {} : null,
                        icon: Icon(
                          state.isListening ? Icons.hearing : Icons.mic,
                        ),
                        label: Text(
                          state.isListening
                              ? 'Listening... release to stop'
                              : 'Hold to speak',
                        ),
                      ),
                    ),
                  ),
                  if (state.lastStatus != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      'Recognizer status: ${state.lastStatus}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black45),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (state.recognizedText != null) ...<Widget>[
                    Text(
                      'Recognized text:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.recognizedText!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (state.feedbackMessage != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      state.feedbackMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSuccess ? const Color(0xFF2E7D32) : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.canContinue ? onDone : null,
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

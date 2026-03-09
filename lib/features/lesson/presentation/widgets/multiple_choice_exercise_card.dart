import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/multiple_choice_card_bloc.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/multiple_choice_card_event.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/multiple_choice_card_state.dart';

class MultipleChoiceExerciseCard extends StatelessWidget {
  const MultipleChoiceExerciseCard({
    super.key,
    required this.phrase,
    required this.options,
    required this.correctOptionIndex,
    required this.onContinue,
  });

  final String phrase;
  final List<String> options;
  final int correctOptionIndex;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MultipleChoiceCardBloc>(
      create: (_) =>
          MultipleChoiceCardBloc(correctOptionIndex: correctOptionIndex),
      child: BlocBuilder<MultipleChoiceCardBloc, MultipleChoiceCardState>(
        builder: (BuildContext context, MultipleChoiceCardState state) {
          final bool isCorrect = state.isAnswerCorrect ?? false;

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
                    'Select the correct translation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phrase,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.asMap().entries.map((MapEntry<int, String> entry) {
                    final int optionIndex = entry.key;
                    final String option = entry.value;
                    final bool isSelected =
                        state.selectedOptionIndex == optionIndex;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: state.isLocked
                              ? null
                              : () {
                                  context.read<MultipleChoiceCardBloc>().add(
                                    MultipleChoiceOptionSelected(
                                      optionIndex: optionIndex,
                                    ),
                                  );
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black26,
                              width: 1.3,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(option),
                        ),
                      ),
                    );
                  }),
                  if (state.feedbackMessage != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      state.feedbackMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isCorrect ? const Color(0xFF2E7D32) : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isCorrect
                          ? onContinue
                          : (state.canCheck
                                ? () {
                                    context.read<MultipleChoiceCardBloc>().add(
                                      const MultipleChoiceAnswerChecked(),
                                    );
                                  }
                                : null),
                      child: Text(isCorrect ? 'Continue' : 'Check'),
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

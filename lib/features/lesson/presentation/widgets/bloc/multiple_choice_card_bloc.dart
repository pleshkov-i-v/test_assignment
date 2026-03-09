import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/multiple_choice_card_event.dart';
import 'package:test_case/features/lesson/presentation/widgets/bloc/multiple_choice_card_state.dart';

class MultipleChoiceCardBloc
    extends Bloc<MultipleChoiceCardEvent, MultipleChoiceCardState> {
  MultipleChoiceCardBloc({required int correctOptionIndex})
    : _correctOptionIndex = correctOptionIndex,
      super(const MultipleChoiceCardState.initial()) {
    on<MultipleChoiceOptionSelected>(_onOptionSelected);
    on<MultipleChoiceAnswerChecked>(_onAnswerChecked);
  }

  final int _correctOptionIndex;

  void _onOptionSelected(
    MultipleChoiceOptionSelected event,
    Emitter<MultipleChoiceCardState> emit,
  ) {
    if (state.isLocked) {
      return;
    }

    emit(
      state.copyWith(
        selectedOptionIndex: event.optionIndex,
        clearFeedbackMessage: true,
        clearIsAnswerCorrect: true,
      ),
    );
  }

  void _onAnswerChecked(
    MultipleChoiceAnswerChecked event,
    Emitter<MultipleChoiceCardState> emit,
  ) {
    if (!state.canCheck) {
      return;
    }

    final bool isCorrect = state.selectedOptionIndex == _correctOptionIndex;
    emit(
      state.copyWith(
        isAnswerCorrect: isCorrect,
        feedbackMessage: isCorrect
            ? 'Correct answer!'
            : 'Not quite, try again.',
      ),
    );
  }
}

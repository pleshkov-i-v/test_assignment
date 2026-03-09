import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/core/di/service_locator.dart';
import 'package:test_case/domain/model/exercise.dart';
import 'package:test_case/domain/service/lesson_service.dart';
import 'package:test_case/features/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:test_case/features/lesson/presentation/bloc/lesson_event.dart';
import 'package:test_case/features/lesson/presentation/bloc/lesson_state.dart';
import 'package:test_case/features/lesson/presentation/widgets/multiple_choice_exercise_card.dart';
import 'package:test_case/features/lesson/presentation/widgets/speech_to_text_exercise_card.dart';

class LessonPageArgs {
  const LessonPageArgs({required this.lessonId});

  final String lessonId;
}

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, this.pageArgs});

  static const String routeName = '/lesson';
  final LessonPageArgs? pageArgs;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.pageArgs == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Lesson could not be opened.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final String lessonId = widget.pageArgs!.lessonId;

    return BlocProvider<LessonBloc>(
      create: (_) =>
          LessonBloc(lessonService: getIt<LessonService>())
            ..add(LessonStarted(lessonId: lessonId)),
      child: BlocListener<LessonBloc, LessonState>(
        listenWhen: (LessonState previous, LessonState current) =>
            previous.status != current.status &&
            current.status == LessonStatus.completed,
        listener: (BuildContext context, LessonState state) {
          // context.pop(state.lessonId);
        },
        child: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text(state.lessonTitle)),
              body: BlocBuilder<LessonBloc, LessonState>(
                builder: (BuildContext context, LessonState state) {
                  if (state.status == LessonStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.exercises.isEmpty) {
                    return _EmptyLessonView(onBackPressed: () => context.pop());
                  }

                  final currentExercise = state.currentExercise;
                  if (currentExercise == null) {
                    return _LessonCompletedView(
                      onBackPressed: () => context.pop(state.lessonId),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Exercise ${state.currentIndex + 1} of ${state.exercises.length}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Center(
                            child: _ExerciseSwitcher(exercise: currentExercise),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExerciseSwitcher extends StatelessWidget {
  const _ExerciseSwitcher({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final localExercise = exercise;
    return switch (localExercise) {
      ReadOutLoudExercise() => SpeechToTextExerciseCard(
        key: ValueKey<String>(localExercise.id),
        textToRead: localExercise.textToRead,
        onDone: () {
          context.read<LessonBloc>().add(const NextExerciseRequested());
        },
      ),
      MultipleChoiceExercise() => MultipleChoiceExerciseCard(
        key: ValueKey<String>(localExercise.id),
        phrase: localExercise.phrase,
        options: localExercise.options,
        correctOptionIndex: localExercise.correctOptionIndex,
        onContinue: () {
          context.read<LessonBloc>().add(const NextExerciseRequested());
        },
      ),
    };
  }
}

class _LessonCompletedView extends StatelessWidget {
  const _LessonCompletedView({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFC107),
            size: 54,
          ),
          const SizedBox(height: 12),
          Text(
            'Lesson Completed',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          const Text('Great job! You finished all exercises.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onBackPressed,
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}

class _EmptyLessonView extends StatelessWidget {
  const _EmptyLessonView({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.menu_book_rounded, size: 48, color: Colors.black45),
          const SizedBox(height: 12),
          const Text('This lesson has no exercises yet.'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onBackPressed,
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

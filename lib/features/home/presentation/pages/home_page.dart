import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/core/di/service_locator.dart';
import 'package:test_case/domain/model/home/course_lesson_item.dart';
import 'package:test_case/domain/service/course_service.dart';
import 'package:test_case/features/home/presentation/bloc/home_bloc.dart';
import 'package:test_case/features/home/presentation/bloc/home_event.dart';
import 'package:test_case/features/home/presentation/bloc/home_state.dart';
import 'package:test_case/features/lesson/presentation/pages/lesson_page.dart';
import 'package:test_case/features/login/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    if (!mounted) {
      return;
    }

    context.go(LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) =>
          HomeBloc(courseService: getIt<CourseService>())
            ..add(const HomeRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lessons'),
          actions: <Widget>[
            PopupMenuButton<_HomeMenuAction>(
              onSelected: (_HomeMenuAction action) async {
                if (action == _HomeMenuAction.logout) {
                  await _logout();
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<_HomeMenuAction>>[
                    const PopupMenuItem<_HomeMenuAction>(
                      value: _HomeMenuAction.logout,
                      child: Text('Logout'),
                    ),
                  ],
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState state) {
            if (state.status == HomeStatus.loading ||
                state.status == HomeStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HomeStatus.failure) {
              return _HomeErrorView(
                message:
                    state.message ??
                    'Could not load lessons. Please try again.',
              );
            }

            return _LessonsMapView(
              courseTitle: state.courseTitle,
              lessons: state.lessons,
            );
          },
        ),
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const HomeRequested());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonsMapView extends StatelessWidget {
  const _LessonsMapView({required this.courseTitle, required this.lessons});

  final String courseTitle;
  final List<CourseLessonItem> lessons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: lessons.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _CourseHeader(title: courseTitle);
        }

        final int lessonIndex = index - 1;
        final CourseLessonItem item = lessons[lessonIndex];
        final bool isLeftAligned = lessonIndex.isEven;
        final bool showConnector = lessonIndex < lessons.length - 1;

        return _LessonNode(
          item: item,
          isLeftAligned: isLeftAligned,
          showConnector: showConnector,
          onTap: () async {
            final Object? result = await context.push<Object?>(
              LessonPage.routeName,
              extra: LessonPageArgs(lessonId: item.id),
            );
            if (result is String && context.mounted) {
              context.read<HomeBloc>().add(LessonCompleted(lessonId: result));
            }
          },
        );
      },
    );
  }
}

class _CourseHeader extends StatelessWidget {
  const _CourseHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.auto_stories_rounded, color: Color(0xFF3A8C00)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonNode extends StatelessWidget {
  const _LessonNode({
    required this.item,
    required this.isLeftAligned,
    required this.showConnector,
    required this.onTap,
  });

  final CourseLessonItem item;
  final bool isLeftAligned;
  final bool showConnector;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLocked = item.isLocked;
    final bool isCompleted = item.isCompleted;
    final Color cardColor = isLocked ? const Color(0xFFF0F0F0) : Colors.white;
    final Color borderColor = isLocked
        ? const Color(0xFFD7D7D7)
        : isCompleted
        ? const Color(0xFF1CB0F6)
        : const Color(0xFF58CC02);
    final Color badgeColor = isLocked
        ? const Color(0xFFC9C9C9)
        : isCompleted
        ? const Color(0xFF1CB0F6)
        : const Color(0xFF58CC02);
    final Color textColor = isLocked ? const Color(0xFF777777) : Colors.black87;
    final IconData icon = isLocked
        ? Icons.lock_outline
        : isCompleted
        ? Icons.check_rounded
        : Icons.play_arrow_rounded;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            if (!isLeftAligned) const Spacer(),
            Flexible(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: isLocked ? null : onTap,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1.6),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: badgeColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Lesson ${item.order}',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: textColor.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isLeftAligned) const Spacer(),
          ],
        ),
        if (showConnector)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD8D8D8),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

enum _HomeMenuAction { logout }

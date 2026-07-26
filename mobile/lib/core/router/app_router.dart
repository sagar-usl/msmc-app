import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/documents/documents_screen.dart';
import '../../features/initiatives/initiatives_screen.dart';
import '../../features/schemes/schemes_screen.dart';
import '../../features/pm_scheme/pm_scheme_screen.dart';
import '../../features/education/education_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/feedback/feedback_screen.dart';
import '../../features/complaint/presentation/complaint_list_screen.dart';
import '../../features/complaint/presentation/new_complaint_screen.dart';
import '../../features/complaint/presentation/complaint_detail_screen.dart';
import 'app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
        GoRoute(path: '/documents', builder: (context, state) => const DocumentsScreen()),
        GoRoute(path: '/initiatives', builder: (context, state) => const InitiativesScreen()),
        GoRoute(path: '/schemes', builder: (context, state) => const SchemesScreen()),
        GoRoute(path: '/pm-scheme', builder: (context, state) => const PmSchemeScreen()),
        GoRoute(path: '/education', builder: (context, state) => const EducationScreen()),
        GoRoute(path: '/news', builder: (context, state) => const NewsScreen()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        GoRoute(path: '/feedback', builder: (context, state) => const FeedbackScreen()),
        GoRoute(path: '/complaint', builder: (context, state) => const ComplaintListScreen()),
        GoRoute(path: '/complaint/new', builder: (context, state) => const NewComplaintScreen()),
        GoRoute(
          path: '/complaint/:id',
          builder: (context, state) => ComplaintDetailScreen(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

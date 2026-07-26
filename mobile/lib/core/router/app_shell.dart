import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';

/// The persistent app frame: header on top, bottom nav always visible,
/// drawer reachable via the header's hamburger icon. `child` is whichever
/// screen the current route resolves to — mirrors the prototype's app shell
/// where every screen (bottom-nav tab or drawer item) renders inside the
/// same header+bottomnav frame.
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppHeader(onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer()),
      endDrawer: AppDrawer(
        onSelect: (route) {
          _scaffoldKey.currentState?.closeEndDrawer();
          context.go(route);
        },
      ),
      body: widget.child,
      bottomNavigationBar: AppBottomNavBar(
        currentLocation: location,
        onSelect: (route) => context.go(route),
      ),
    );
  }
}

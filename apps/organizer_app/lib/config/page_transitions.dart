// page_transitions.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Fade Transition for all routes
Page<dynamic> buildPageWithFadeTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

// No transition
Page<dynamic> buildPageWithNoTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // No transition, return the child directly
    },
  );
}

// Slide from Bottom (example for modals)
Page<dynamic> buildPageWithSlideFromBottomTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // Slide from bottom
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

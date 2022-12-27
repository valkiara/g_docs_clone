import 'package:flutter/material.dart';
import 'package:g_docs_clone/screens/document_screen.dart';
import 'package:g_docs_clone/screens/home_screen.dart';
import 'package:g_docs_clone/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(id: route.pathParameters['id'] ?? ''),
      ),
});

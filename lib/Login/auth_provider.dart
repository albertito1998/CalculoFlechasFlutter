import 'package:flutter/material.dart';
import 'auth.dart';

class AuthProvider extends InheritedWidget {
  final BaseAuth auth;

  const AuthProvider({
    super.key,
    required this.auth,
    required super.child,
  });

  static AuthProvider of(BuildContext context) {
    final AuthProvider? result =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(result != null, 'No AuthProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

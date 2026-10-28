import 'package:flutter/material.dart';

import '../models/user.dart';

/// View 2: user details, skills (level + percentage) and projects
/// (passed and failed).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile')));
  }
}

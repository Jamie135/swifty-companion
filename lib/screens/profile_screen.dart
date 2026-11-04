import 'package:flutter/material.dart';
import '../models/user.dart';

const _unavailable = 'Unavailable';

/// View 2: user details.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {

    final cursus = user.mainCursus;
    final skills = cursus?.skills ?? const <Skill>[];
    final projects = user.finishedProjects;

    return Scaffold(
      appBar: AppBar(title: Text(user.login ?? 'Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Avatar(url: user.imageUrl),
          const _SectionTitle('Details'),
          _Detail('Name', user.displayname),
          _Detail('Email', user.email),
          _Detail('Phone', user.phone),
          _Detail('Location', user.location),
          _Detail('Campus', user.campus),
          _Detail('Wallet', user.wallet?.toString()),
          _Detail('Correction points', user.correctionPoint?.toString()),
          const _SectionTitle('Level'),
          _LevelBar(label: cursus?.name ?? _unavailable, level: cursus?.level),
          const _SectionTitle('Skills'),
          if (skills.isEmpty) const Text(_unavailable),
          for (final skill in skills)
            _LevelBar(label: skill.name ?? _unavailable, level: skill.level),
          const _SectionTitle('Projects'),
          if (projects.isEmpty) const Text(_unavailable),
          for (final project in projects) _ProjectTile(project),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(Icons.person, size: 120);
    final imageUrl = url;

    return Center(
      child: ClipOval(
        child: imageUrl == null
            ? placeholder
            : Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value ?? _unavailable),
    );
  }
}

class _LevelBar extends StatelessWidget {
  const _LevelBar({required this.label, required this.level});

  final String label;
  final double? level;

  @override
  Widget build(BuildContext context) {
    final value = level;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(value == null
              ? _unavailable
              : 'Level ${value.level} - ${value.levelPercent}%'),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: (value?.levelPercent ?? 0) / 100),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        project.passed ? Icons.check_circle : Icons.cancel,
        color: project.passed ? Colors.green : Colors.red,
      ),
      title: Text(project.name ?? _unavailable),
      subtitle: Text(project.passed ? 'Passed' : 'Failed'),
      trailing: Text(project.finalMark?.toString() ?? _unavailable),
    );
  }
}


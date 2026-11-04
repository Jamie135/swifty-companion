/// Returns [value] if it has type T, otherwise null.
T? _as<T>(Object? value) => value is T ? value : null;

/// Converts a list of objects to a list of maps or an empty list if value is not a list.
List<Map<String, dynamic>> _maps(Object? value) =>
    value is List ? value.whereType<Map<String, dynamic>>().toList() : const [];

/// Level writing convention
extension LevelParts on double {
  int get level => (this * 100).round() ~/ 100;
  int get levelPercent => (this * 100).round() % 100;
}

class Skill {
  const Skill({this.id, this.name, this.level});

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: _as<int>(json['id']),
        name: _as<String>(json['name']),
        level: _as<num>(json['level'])?.toDouble(),
      );

  final int? id;
  final String? name;
  final double? level;
}

class CursusUser {
  const CursusUser({this.level, this.grade, this.name, this.slug, this.skills = const []});

  factory CursusUser.fromJson(Map<String, dynamic> json) {
    final cursus = _as<Map<String, dynamic>>(json['cursus']);

    return CursusUser(
      level: _as<num>(json['level'])?.toDouble(),
      grade: _as<String>(json['grade']),
      name: _as<String>(cursus?['name']),
      slug: _as<String>(cursus?['slug']),
      skills: _maps(json['skills']).map(Skill.fromJson).toList(),
    );
  }

  final double? level;
  final String? grade;
  final String? name;
  final String? slug;
  final List<Skill> skills;
}

class Project {
  const Project({this.name, this.status, this.finalMark, this.validated});

  factory Project.fromJson(Map<String, dynamic> json) {
    final project = _as<Map<String, dynamic>>(json['project']);

    return Project(
      name: _as<String>(project?['name']),
      status: _as<String>(json['status']),
      finalMark: _as<int>(json['final_mark']),
      validated: _as<bool>(json['validated?']),
    );
  }

  final String? name;
  final String? status;
  final int? finalMark;
  final bool? validated;

  bool get passed => validated == true;
}

class User {
  const User({
    this.id,
    this.login,
    this.email,
    this.displayname,
    this.phone,
    this.location,
    this.wallet,
    this.correctionPoint,
    this.campus,
    this.imageUrl,
    this.cursusUsers = const [],
    this.projectsUsers = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final image = _as<Map<String, dynamic>>(json['image']);
    final versions = _as<Map<String, dynamic>>(image?['versions']);
    final campuses = _maps(json['campus']);
    final phone = _as<String>(json['phone']);

    return User(
      id: _as<int>(json['id']),
      login: _as<String>(json['login']),
      email: _as<String>(json['email']),
      displayname: _as<String>(json['displayname']),
      phone: phone == 'hidden' ? null : phone,
      location: _as<String>(json['location']),
      wallet: _as<int>(json['wallet']),
      correctionPoint: _as<int>(json['correction_point']),
      campus: campuses.isEmpty ? null : _as<String>(campuses.first['name']),
      imageUrl: _as<String>(versions?['medium']) ?? _as<String>(image?['link']),
      cursusUsers: _maps(json['cursus_users']).map(CursusUser.fromJson).toList(),
      projectsUsers: _maps(json['projects_users']).map(Project.fromJson).toList(),
    );
  }

  final int? id;
  final String? login;
  final String? email;
  final String? displayname;
  final String? phone;
  final String? location;
  final int? wallet;
  final int? correctionPoint;
  final String? campus;
  final String? imageUrl;
  final List<CursusUser> cursusUsers;
  final List<Project> projectsUsers;

  /// The 42cursus entry, otherwise the last entry, or null if there are none.
  CursusUser? get mainCursus {
    if (cursusUsers.isEmpty) return null;
    for (final cursusUser in cursusUsers) {
      if (cursusUser.slug == '42cursus') return cursusUser;
    }
    return cursusUsers.last;
  }

  /// Finished projects, both passed and failed.
  List<Project> get finishedProjects =>
      projectsUsers.where((p) => p.status == 'finished').toList();
}

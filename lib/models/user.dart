/// Data classes for GET /v2/users/:login (see user_pbureera.json at repo root).

class User {
  // TODO: id, login, email, displayname, image (link), location,
  // wallet, correction_point, cursusUsers, projectsUsers
  // factory User.fromJson(Map<String, dynamic> json)
}

class CursusUser {
  // TODO: level, grade, skills, cursus name
}

class Skill {
  // TODO: id, name, level
}

class ProjectUser {
  // TODO: project name, status, final_mark, validated?
}

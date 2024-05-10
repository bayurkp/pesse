class Profile {
  final int id;
  final String email;
  final String name;

  Profile({
    required this.id,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}

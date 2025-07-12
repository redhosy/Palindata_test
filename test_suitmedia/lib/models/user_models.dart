// Model untuk User
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  String get fullName => '$firstName $lastName';
}

/// Model class untuk response dari API reqres.in
class UserResponse {
  final List<User> data;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponse({
    required this.data,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  /// Factory method untuk membuat UserResponse object dari JSON
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      data: (json['data'] as List).map((user) => User.fromJson(user)).toList(),
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}
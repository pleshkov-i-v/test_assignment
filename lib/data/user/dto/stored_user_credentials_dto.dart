class StoredUserCredentialsDto {
  const StoredUserCredentialsDto({
    required this.login,
    required this.passwordHash,
    required this.passwordSalt,
  });

  final String login;
  final String passwordHash;
  final String passwordSalt;

  factory StoredUserCredentialsDto.fromJson(Map<String, dynamic> json) {
    return StoredUserCredentialsDto(
      login: json['login'] as String,
      passwordHash: json['passwordHash'] as String,
      passwordSalt: json['passwordSalt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'login': login,
      'passwordHash': passwordHash,
      'passwordSalt': passwordSalt,
    };
  }
}

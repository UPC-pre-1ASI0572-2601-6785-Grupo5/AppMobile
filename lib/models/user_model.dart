
class User {
final String id;
final String companyName;
final String email;
final String role;
final DateTime createdAt;
final bool acceptedTerms;

User({
required this.id,
required this.companyName,
required this.email,
required this.role,
required this.createdAt,
required this.acceptedTerms,
});

Map<String, dynamic> toJson() {
return {
'id': id,
'companyName': companyName,
'email': email,
'role': role,
'createdAt': createdAt.toIso8601String(),
'acceptedTerms': acceptedTerms,
};
}

factory User.fromJson(Map<String, dynamic> json) {
return User(
id: json['id'],
companyName: json['companyName'],
email: json['email'],
role: json['role'],
createdAt: DateTime.parse(json['createdAt']),
acceptedTerms: json['acceptedTerms'],
);
}

User copyWith({
String? id,
String? companyName,
String? email,
String? role,
DateTime? createdAt,
bool? acceptedTerms,
}) {
return User(
id: id ?? this.id,
companyName: companyName ?? this.companyName,
email: email ?? this.email,
role: role ?? this.role,
createdAt: createdAt ?? this.createdAt,
acceptedTerms: acceptedTerms ?? this.acceptedTerms,
);
}
}

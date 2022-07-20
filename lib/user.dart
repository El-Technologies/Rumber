class User {
  String id, name;
  int score, phone;

  User({
    this.id = "",
    required this.name,
    required this.phone,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "score": score,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        score: json["score"],
      );
}

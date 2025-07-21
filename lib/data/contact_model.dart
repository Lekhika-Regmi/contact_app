class Contact {
  final int? id;
  final String name;
  final String phone;
  final String email;

  final bool isFavorite;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.isFavorite = false,
  });

  //fetching from db and keeping it as a Map (Contact Object)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  //converts contact object to map for inserting in db rows/ serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

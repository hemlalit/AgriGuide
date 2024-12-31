class Vendor {
  final String? id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String? password;
  final String? compName;
  final Address? address;
  final List<String> products;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vendor({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.password,
    this.compName,
    this.address,
    required this.products,
    this.createdAt,
    this.updatedAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      compName: json['compName'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      products: List<String>.from(json['products']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'compName': compName,
      'address': address?.toJson(),
      'products': products,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }
}

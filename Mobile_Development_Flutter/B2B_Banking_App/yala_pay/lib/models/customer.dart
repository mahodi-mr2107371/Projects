class Customer {
  final int _customerId;
  final String _companyName;
  final String _street;
  final String _city;
  final String _country;
  final String _contactFirstName;
  final String _contactLastName;
  final String _contactMobile;
  final String _contactEmail;

  Customer({
    required int customerId,
    required String companyName,
    required String street,
    required String city,
    required String country,
    required String contactFirstName,
    required String contactLastName,
    required String contactMobile,
    required String contactEmail,
  })  : _customerId = customerId,
        _companyName = companyName,
        _street = street,
        _city = city,
        _country = country,
        _contactFirstName = contactFirstName,
        _contactLastName = contactLastName,
        _contactMobile = contactMobile,
        _contactEmail = contactEmail;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: int.parse(json['id']),
      companyName: json['companyName'],
      street: json['address']['street'],
      city: json['address']['city'],
      country: json['address']['country'],
      contactFirstName: json['contactDetails']['firstName'],
      contactLastName: json['contactDetails']['lastName'],
      contactMobile: json['contactDetails']['mobile'],
      contactEmail: json['contactDetails']['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _customerId.toString(),
      'companyName': _companyName,
      'address': {
        'street': _street,
        'city': _city,
        'country': _country,
      },
      'contactDetails': {
        'firstName': _contactFirstName,
        'lastName': _contactLastName,
        'mobile': _contactMobile,
        'email': _contactEmail,
      },
    };
  }

  // Getters
  int get customerId => _customerId;
  String get companyName => _companyName;
  String get street => _street;
  String get city => _city;
  String get country => _country;
  String get contactFirstName => _contactFirstName;
  String get contactLastName => _contactLastName;
  String get contactMobile => _contactMobile;
  String get contactEmail => _contactEmail;
}

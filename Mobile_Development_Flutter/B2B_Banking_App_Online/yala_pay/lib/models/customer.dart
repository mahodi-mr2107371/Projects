
class Customer {
  String customerId;
  final String companyName;
  final String street;
  final String city;
  final String country;
  final String contactFirstName;
  final String contactLastName;
  final String contactMobile;
  final String contactEmail;

  Customer({
    required this.customerId,
    required this.companyName,
    required this.street,
    required this.city,
    required this.country,
    required this.contactFirstName,
    required this.contactLastName,
    required this.contactMobile,
    required this.contactEmail,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['id'],
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
      'id': customerId.toString(),
      'companyName': companyName,
      'address': {
        'street': street,
        'city': city,
        'country': country,
      },
      'contactDetails': {
        'firstName': contactFirstName,
        'lastName': contactLastName,
        'mobile': contactMobile,
        'email': contactEmail,
      },
    };
  }
}

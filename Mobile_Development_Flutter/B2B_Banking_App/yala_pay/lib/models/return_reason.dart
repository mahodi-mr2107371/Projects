class ReturnReason {
  final int _reasonId;
  final String _description;

  ReturnReason({
    required int reasonId,
    required String description,
  })  : _reasonId = reasonId,
        _description = description;

  factory ReturnReason.fromJson(Map<String, dynamic> json) {
    return ReturnReason(
      reasonId: json['reasonId'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reasonId': _reasonId,
      'description': _description,
    };
  }

  // Getters
  int get reasonId => _reasonId;
  String get description => _description;
}
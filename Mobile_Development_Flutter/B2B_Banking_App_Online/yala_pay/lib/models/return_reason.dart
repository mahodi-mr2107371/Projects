import 'package:floor/floor.dart';

@Entity(tableName: 'returnReasons')
class ReturnReason {
  @PrimaryKey(autoGenerate: true)
  int? reasonId;
  final String description;

  ReturnReason({
    required this.description,
    int? reasonId,
  });

  factory ReturnReason.fromJson(Map<String, dynamic> json) {
    return ReturnReason(
      reasonId: json['reasonId'] as int?,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reasonId': reasonId,
      'description': description,
    };
  }
}

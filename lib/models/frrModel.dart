import 'package:cloud_firestore/cloud_firestore.dart';

class Fusion820RiverResidential {
  double? billedRevenue;
  double? collectedRevenue;
  double? payroll;
  double? other;
  double? netIncome;
  String forDate;
  Timestamp updatedOn;

  Fusion820RiverResidential(
      {this.billedRevenue,
      this.collectedRevenue,
      this.payroll,
      this.other,
      this.netIncome,
      required this.forDate,
      required this.updatedOn});

  Fusion820RiverResidential.fromJson(Map<String, Object?> json)
      : this(
          billedRevenue: json['billedRevenue'] as double?,
          collectedRevenue: json['collectedRevenue'] as double?,
          payroll: json['payroll'] as double?,
          other: json['other'] as double?,
          netIncome: json['netIncome'] as double?,
          forDate: json['forDate'] as String,
          updatedOn: json['updatedOn'] as Timestamp,
        );

  Fusion820RiverResidential copyWith({
    double? billedRevenue,
    double? collectedRevenue,
    double? payroll,
    double? other,
    double? netIncome,
    String? forDate,
    Timestamp? updatedOn,
  }) {
    return Fusion820RiverResidential(
        billedRevenue: billedRevenue,
        collectedRevenue: collectedRevenue,
        payroll: payroll,
        other: other,
        netIncome: netIncome,
        forDate: forDate ?? this.forDate,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'billedRevenue': billedRevenue,
      'collectedRevenue': collectedRevenue,
      'payroll': payroll,
      'other': other,
      'netIncome': netIncome,
      'forDate': forDate,
      'updatedOn': updatedOn
    };
  }
}

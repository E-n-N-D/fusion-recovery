import 'package:cloud_firestore/cloud_firestore.dart';

class FusionRecoveryAlbany {
  double? billedRevenue;
  double? collectedRevenue;
  double? payroll;
  double? otherExpenses;
  double? netIncome;
  String forDate;
  Timestamp updatedOn;

  FusionRecoveryAlbany(
      {this.billedRevenue,
      this.collectedRevenue,
      this.payroll,
      this.otherExpenses,
      this.netIncome,
      required this.forDate,
      required this.updatedOn});

  FusionRecoveryAlbany.fromJson(Map<String, Object?> json)
      : this(
          billedRevenue: json['billedRevenue'] as double?,
          collectedRevenue: json['collectedRevenue'] as double?,
          payroll: json['payroll'] as double?,
          otherExpenses: json['otherExpenses'] as double?,
          netIncome: json['netIncome'] as double?,
          forDate: json['forDate'] as String,
          updatedOn: json['updatedOn'] as Timestamp,
        );

  FusionRecoveryAlbany copyWith({
    double? billedRevenue,
    double? collectedRevenue,
    double? payroll,
    double? otherExpenses,
    double? netIncome,
    String? forDate,
    Timestamp? updatedOn,
  }) {
    return FusionRecoveryAlbany(
        billedRevenue: billedRevenue,
        collectedRevenue: collectedRevenue,
        payroll: payroll,
        otherExpenses: otherExpenses,
        netIncome: netIncome,
        forDate: forDate ?? this.forDate,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'billedRevenue': billedRevenue,
      'collectedRevenue': collectedRevenue,
      'payroll': payroll,
      'otherExpenses': otherExpenses,
      'netIncome': netIncome,
      'forDate': forDate,
      'updatedOn': updatedOn
    };
  }
}

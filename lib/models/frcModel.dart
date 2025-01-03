import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fusion_recovery/models/fusionAbstract.dart';

class FusionRecoveryCentersModel {
  double? expenses;
  double? payroll;
  double? other;
  double? cashBalance;
  double? a_r;
  double? creditCardBalance;
  String forDate;
  Timestamp updatedOn;

  FusionRecoveryCentersModel(
      {this.expenses,
      this.payroll,
      this.other,
      this.cashBalance,
      this.a_r,
      this.creditCardBalance,
      required this.forDate,
      required this.updatedOn});

  FusionRecoveryCentersModel.fromJson(Map<String, Object?> json)
      : this(
          expenses: json['expenses'] as double?,
          payroll: json['payroll'] as double?,
          other: json['other'] as double?,
          cashBalance: json['cashBalance'] as double?,
          a_r: json['a_r'] as double?,
          creditCardBalance: json['creditCardBalance'] as double?,
          forDate: json['forDate'] as String,
          updatedOn: json['updatedOn'] as Timestamp,
        );

  FusionRecoveryCentersModel copyWith({
    double? expenses,
    double? payroll,
    double? other,
    double? cashBalance,
    double? a_r,
    double? creditCardBalance,
    String? forDate,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return FusionRecoveryCentersModel(
        expenses: expenses,
        payroll: payroll,
        other: other,
        cashBalance: cashBalance,
        a_r: a_r,
        creditCardBalance: creditCardBalance,
        forDate: forDate ?? this.forDate,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      'expenses': expenses,
      'payroll': payroll,
      'other': other,
      'cashBalance': cashBalance,
      'a_r': a_r,
      'creditCardBalance': creditCardBalance,
      'forDate': forDate,
      'updatedOn': updatedOn
    };
  }
}

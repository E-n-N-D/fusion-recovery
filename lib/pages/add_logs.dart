import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fusion_recovery/models/fraModel.dart';
import 'package:fusion_recovery/models/frcModel.dart';
import 'package:fusion_recovery/models/frrModel.dart';
import 'package:fusion_recovery/pages/home_page.dart';
import 'package:fusion_recovery/services/database_service.dart';
// import 'package:fusion_recovery/services/save_to_excel.dart';
import 'package:fusion_recovery/widgets/buttonWidget.dart';
import 'package:fusion_recovery/widgets/textFormBuilder.dart';

class AddLogs extends StatefulWidget {
  final String forDate;
  final bool isEdit;
  final Map<String, dynamic>? frcData;
  final Map<String, dynamic>? fraData;
  final Map<String, dynamic>? frrData;
  const AddLogs(
      {super.key,
      required this.forDate,
      required this.isEdit,
      this.frcData,
      this.fraData,
      this.frrData});

  @override
  State<AddLogs> createState() => _AddLogsState();
}

class _AddLogsState extends State<AddLogs> {
  final _formKey = GlobalKey<FormState>();

  final DatabaseService _databaseService = DatabaseService();

  final Map<String, TextEditingController> fusionRecoveryCenters = {
    'frcExpenses': TextEditingController(),
    'frcPayroll': TextEditingController(),
    'frcOther': TextEditingController(),
    'frcCashBalance': TextEditingController(),
    'frcA/R': TextEditingController(),
    'frcCreditCardBalance': TextEditingController(),
  };

  final Map<String, TextEditingController> fusionRecoveryAlbany = {
    'fraBilledRevenue': TextEditingController(),
    'fraCollectedRevenue': TextEditingController(),
    'fraPayroll': TextEditingController(),
    'fraOtherExpenses': TextEditingController(),
    'fraNetIncome': TextEditingController(),
  };

  final Map<String, TextEditingController> fusion820RiverResidential = {
    'frrBilledRevenue': TextEditingController(),
    'frrCollectedRevenue': TextEditingController(),
    'frrPayroll': TextEditingController(),
    'frrOther': TextEditingController(),
    'frrNetIncome': TextEditingController(),
  };

  // Fetch data from Firestore
  void fetchData() {
    if (widget.frcData != null) {
      // FusionRecoveryCentersModel? frc =
      //     await getOneData(widget.forDate, "frc");
      // FusionRecoveryAlbany? fra =
      //     await getOneData(widget.forDate, "fra");
      // Fusion820RiverResidential? frr =
      //     await getOneData(widget.forDate, 'frr');

      fusionRecoveryCenters['frcExpenses']!.text =
          widget.frcData!['expenses'].toString();
      fusionRecoveryCenters['frcPayroll']!.text =
          widget.frcData!['payroll'].toString();
      fusionRecoveryCenters['frcOther']!.text =
          widget.frcData!['other'].toString();
      fusionRecoveryCenters['frcCashBalance']!.text =
          widget.frcData!['cashBalance'].toString();
      fusionRecoveryCenters['frcA/R']!.text = widget.frcData!['a_r'].toString();
      fusionRecoveryCenters['frcCreditCardBalance']!.text =
          widget.frcData!['creditCardBalance'].toString();

      fusionRecoveryAlbany['fraBilledRevenue']!.text =
          widget.fraData!['billedRevenue'].toString();
      fusionRecoveryAlbany['fraCollectedRevenue']!.text =
          widget.fraData!['collectedRevenue'].toString();
      fusionRecoveryAlbany['fraPayroll']!.text =
          widget.fraData!['payroll'].toString();
      fusionRecoveryAlbany['fraOtherExpenses']!.text =
          widget.fraData!['otherExpenses'].toString();
      fusionRecoveryAlbany['fraNetIncome']!.text =
          widget.fraData!['netIncome'].toString();

      fusion820RiverResidential['frrBilledRevenue']!.text =
          widget.frrData!['billedRevenue'].toString();
      fusion820RiverResidential['frrCollectedRevenue']!.text =
          widget.frrData!['collectedRevenue'].toString();
      fusion820RiverResidential['frrPayroll']!.text =
          widget.frrData!['payroll'].toString();
      fusion820RiverResidential['frrOther']!.text =
          widget.frrData!['other'].toString();
      fusion820RiverResidential['frrNetIncome']!.text =
          widget.frrData!['other'].toString();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      fetchData();

      fusionRecoveryCenters.forEach((key, controller) {
        controller.addListener(() {});
      });

      fusionRecoveryAlbany.forEach((key, controller) {
        controller.addListener(() {});
      });

      fusion820RiverResidential.forEach((key, controller) {
        controller.addListener(() {});
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    fusionRecoveryCenters['frcExpenses']!.dispose();
    fusionRecoveryCenters['frcPayroll']!.dispose();
    fusionRecoveryCenters['frcOther']!.dispose();
    fusionRecoveryCenters['frcCashBalance']!.dispose();
    fusionRecoveryCenters['frcA/R']!.dispose();
    fusionRecoveryCenters['frcCreditCardBalance']!.dispose();

    fusionRecoveryAlbany['fraBilledRevenue']!.dispose();
    fusionRecoveryAlbany['fraCollectedRevenue']!.dispose();
    fusionRecoveryAlbany['fraPayroll']!.dispose();
    fusionRecoveryAlbany['fraOtherExpenses']!.dispose();
    fusionRecoveryAlbany['fraNetIncome']!.dispose();

    fusion820RiverResidential['frrBilledRevenue']!.dispose();
    fusion820RiverResidential['frrCollectedRevenue']!.dispose();
    fusion820RiverResidential['frrPayroll']!.dispose();
    fusion820RiverResidential['frrOther']!.dispose();
    fusion820RiverResidential['frrNetIncome']!.dispose();
    super.dispose();
  }

  var count = 0;

  double parseDouble(String value) {
    // Check if the value is empty or not a valid number
    if (value.isEmpty || double.tryParse(value) == null) {
      return 0.0; // Return 0 if the value is invalid
    }
    return double.parse(value); // Parse the value as a double if valid
  }

  @override
  Widget build(BuildContext context) {
    final double fntSize = MediaQuery.of(context).size.width * 0.05;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  constraints: const BoxConstraints(maxHeight: 100),
                  margin: const EdgeInsets.all(5),
                  child: const Center(
                      child: Image(
                    image: AssetImage('images/fusion-recovery.png'),
                    fit: BoxFit.fill,
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        count == 0
                            ? 'Fusion Recovery Centers'
                            : count == 1
                                ? "Fusion Recovery Albany"
                                : 'Fusion 820 River Residential',
                        style: TextStyle(
                            fontSize: fntSize,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFromBuilder(
                        formData: count == 0
                            ? fusionRecoveryCenters
                            : count == 1
                                ? fusionRecoveryAlbany
                                : fusion820RiverResidential,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (count != 0)
                            Buttonwidget(
                                bgColor: Colors.grey,
                                buttonLabel: "Back",
                                onClick: () {
                                  setState(() {
                                    count -= 1;
                                  });
                                }),
                          const SizedBox(
                            width: 20,
                          ),
                          Buttonwidget(
                              bgColor: count != 2 ? Colors.blue : Colors.green,
                              buttonLabel: count != 2 ? "Next" : "Save",
                              onClick: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  if (count == 2) {
                                    FusionRecoveryCentersModel frc = FusionRecoveryCentersModel(
                                        expenses: parseDouble(
                                            fusionRecoveryCenters['frcExpenses']!
                                                .text),
                                        payroll: parseDouble(
                                            fusionRecoveryCenters['frcPayroll']!
                                                .text),
                                        other: parseDouble(
                                            fusionRecoveryCenters['frcOther']!
                                                .text),
                                        cashBalance: parseDouble(
                                            fusionRecoveryCenters['frcCashBalance']!
                                                .text),
                                        creditCardBalance: parseDouble(
                                            fusionRecoveryCenters['frcCreditCardBalance']!
                                                .text),
                                        a_r: parseDouble(
                                            fusionRecoveryCenters['frcA/R']!.text),
                                        forDate: widget.forDate,
                                        updatedOn: Timestamp.now());
      
                                    FusionRecoveryAlbany fra = FusionRecoveryAlbany(
                                        billedRevenue: parseDouble(
                                            fusionRecoveryAlbany['fraBilledRevenue']!
                                                .text),
                                        collectedRevenue: parseDouble(
                                            fusionRecoveryAlbany[
                                                    'fraCollectedRevenue']!
                                                .text),
                                        payroll: parseDouble(
                                            fusionRecoveryAlbany['fraPayroll']!
                                                .text),
                                        otherExpenses: parseDouble(
                                            fusionRecoveryAlbany[
                                                    'fraOtherExpenses']!
                                                .text),
                                        netIncome: parseDouble(
                                            fusionRecoveryAlbany['fraNetIncome']!
                                                .text),
                                        forDate: widget.forDate,
                                        updatedOn: Timestamp.now());
      
                                    Fusion820RiverResidential frr = Fusion820RiverResidential(
                                        billedRevenue: parseDouble(
                                            fusion820RiverResidential[
                                                    'frrBilledRevenue']!
                                                .text),
                                        collectedRevenue: parseDouble(
                                            fusion820RiverResidential[
                                                    'frrCollectedRevenue']!
                                                .text),
                                        payroll: parseDouble(
                                            fusion820RiverResidential['frrPayroll']!
                                                .text),
                                        other: parseDouble(
                                            fusion820RiverResidential['frrOther']!
                                                .text),
                                        netIncome: parseDouble(
                                            fusion820RiverResidential['frrNetIncome']!
                                                .text),
                                        forDate: widget.forDate,
                                        updatedOn: Timestamp.now());
      
                                    widget.isEdit
                                        ? _databaseService.editAll(
                                            frc, fra, frr, widget.forDate)
                                        : _databaseService.addAll(frc, fra, frr);
      
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage()),
                                      (Route<dynamic> route) =>
                                          false, // This removes all previous routes
                                    );
                                  } else {
                                    setState(() {
                                      count += 1;
                                    });
                                  }
                                }
                              })
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

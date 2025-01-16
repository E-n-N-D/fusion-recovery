import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fusion_recovery/models/fraModel.dart';
import 'package:fusion_recovery/models/frcModel.dart';
import 'package:fusion_recovery/models/frrModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<dynamic> getOneData(String forDate, String collectionName) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('forDate', isEqualTo: forDate)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      if (collectionName == 'frc') {
        return FusionRecoveryCentersModel.fromJson(
            snapshot.docs.first.data() as Map<String, Object?>);
      } else if (collectionName == 'fra') {
        return FusionRecoveryAlbany.fromJson(
            snapshot.docs.first.data() as Map<String, Object?>);
      } else {
        return Fusion820RiverResidential.fromJson(
            snapshot.docs.first.data() as Map<String, Object?>);
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<void> saveToExcel(String forDate, BuildContext context) async {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  FusionRecoveryCentersModel? frc = await getOneData(forDate, "frc");
  FusionRecoveryAlbany? fra = await getOneData(forDate, "fra");
  Fusion820RiverResidential? frr = await getOneData(forDate, "frr");

  String convertToFormattedString(String input) {
    input = input.replaceAllMapped(RegExp(r'([a-zA-Z])_([a-zA-Z])'), (match) {
      return '${match.group(1)?.toUpperCase()}/${match.group(2)?.toUpperCase()}';
    });

    // Insert spaces before uppercase letters (camelCase)
    String result = input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    });

    // Replace underscores (snake_case) with spaces, if any are left
    result = result.replaceAll('_', ' ');

    // Capitalize the first letter of each word
    result = result.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    return result;
  }

  // Add headers
  sheet.appendRow(
      [TextCellValue(''), TextCellValue(''), TextCellValue(forDate)]);

  sheet.appendRow([TextCellValue(''), TextCellValue(''), TextCellValue("")]);

  sheet.appendRow([
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue("Item"),
    TextCellValue("Margin")
  ]);

  // Fusion Recovery Centers starts
  sheet.appendRow([TextCellValue('Fusion Recovery Centers')]);

  sheet.appendRow([TextCellValue("")]);

  // Add data
  frc!.toJson().forEach((key, value) {
    if (!["forDate", "createdOn", "updatedOn"].contains(key)) {
      sheet.appendRow([
        TextCellValue(convertToFormattedString(key)),
        TextCellValue(""),
        DoubleCellValue(double.tryParse(value.toString())!),
      ]);
    }
  });

  sheet.appendRow([TextCellValue("")]);
  sheet.appendRow([TextCellValue("")]);

  // Fusion Recovery Centers starts
  sheet.appendRow([TextCellValue('Fusion Recovery Albany')]);

  sheet.appendRow([TextCellValue("")]);

  // Add data
  fra!.toJson().forEach((key, value) {
    String margin = "";

    if (key == "collectedRevenue") {
      margin = (fra.collectedRevenue! / fra.billedRevenue!).toString();
    } else if (key == "billedRevenue") {
      sheet.appendRow([
        TextCellValue(convertToFormattedString(key)),
        TextCellValue(""),
        DoubleCellValue(double.tryParse(value.toString())!),
      ]);
    } else if (fra.toJson()[key] is double) {
      margin =
          (double.parse(fra.toJson()[key].toString()) / fra.collectedRevenue!)
              .toString();
    }

    margin.length > 5 ? margin.substring(0, 5) : margin;

    if (!["forDate", "createdOn", "updatedOn", "billedRevenue"].contains(key)) {
      sheet.appendRow([
        TextCellValue(convertToFormattedString(key)),
        TextCellValue(""),
        DoubleCellValue(double.tryParse(value.toString())!),
        DoubleCellValue(double.tryParse(margin)!)
      ]);
    }
  });

  sheet.appendRow([TextCellValue("")]);
  sheet.appendRow([TextCellValue("")]);

  // Fusion Recovery Centers starts
  sheet.appendRow([TextCellValue('Fusion 820 River Residential')]);

  sheet.appendRow([TextCellValue("")]);

  // Add data
  frr!.toJson().forEach((key, value) {
    String margin = "";
    if (key == "collectedRevenue") {
      margin = (frr.collectedRevenue! / frr.billedRevenue!).toString();
    } else if (key == "billedRevenue") {
      sheet.appendRow([
        TextCellValue(convertToFormattedString(key)),
        TextCellValue(""),
        DoubleCellValue(double.tryParse(value.toString())!),
      ]);
    } else if (frr.toJson()[key] is double) {
      margin =
          (double.parse(frr.toJson()[key].toString()) / frr.collectedRevenue!)
              .toString();
    }

    margin.length > 5 ? margin.substring(0, 5) : margin;
    if (!["forDate", "createdOn", "updatedOn", "billedRevenue"].contains(key)) {
      sheet.appendRow([
        TextCellValue(convertToFormattedString(key)),
        TextCellValue(""),
        DoubleCellValue(double.tryParse(value.toString())!),
        DoubleCellValue(double.tryParse(margin)!)
      ]);
    }
  });

  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Save the file
    // final directory = Directory('/storage/emulated/0/Download');

    Directory? directory;
    // Handle Android 10+ Scoped Storage
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download'); // Public Downloads folder
      } else {
        directory = await getApplicationDocumentsDirectory(); // For non-Android platforms
      }

      // Ensure the directory exists
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

    // final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$forDate.xlsx';
    final fileBytes = excel.encode();

    if (fileBytes != null) {
      // ignore: unused_local_variable
      final file = File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved at $filePath')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permission not granted')),
    );
  }
}

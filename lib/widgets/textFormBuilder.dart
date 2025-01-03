import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFromBuilder extends StatefulWidget {
  final Map<String, TextEditingController> formData;

  const TextFromBuilder({super.key, required this.formData});

  @override
  State<TextFromBuilder> createState() => _TextFromBuilderState();
}

class _TextFromBuilderState extends State<TextFromBuilder> {
  String convertToFormattedString(String input) {
    // Split the string after uppercase letters
    String result = input.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'), (Match m) => '${m.group(1)} ${m.group(2)}');

    // Capitalize the first letter of the resulting string
    return result.substring(3);
  }

  @override
  Widget build(BuildContext context) {
    double minHeight = MediaQuery.of(context).viewInsets.bottom != 0
        ? MediaQuery.sizeOf(context).height * 0.4
        : MediaQuery.sizeOf(context).height * 0.65;
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: minHeight),
        child: ListView(
            children: widget.formData.entries.map((entry) {
          String formLabel = convertToFormattedString(entry.key);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  formLabel,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              TextFormField(
                controller: entry.value,
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Validation logic
                  if (value == null || value.isEmpty) {
                    return '$formLabel cannot be empty'; // Error message
                  }
                  return null; // Valid input
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                decoration: InputDecoration(
                  hintText: "Enter$formLabel Value",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          );
        }).toList()),
      ),
    );
  }
}

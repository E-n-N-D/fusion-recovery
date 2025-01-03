import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  final Map<String, Object?> tableData;
  final int titleCount;

  const DashboardView(
      {super.key, required this.tableData, required this.titleCount});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    String convertToFormattedString(String input) {
      input = input.replaceAllMapped(RegExp(r'([a-zA-Z])_([a-zA-Z])'), (match) {
        return '${match.group(1)?.toUpperCase()}/${match.group(2)?.toUpperCase()}';
      });

      // Insert spaces before uppercase letters (camelCase)
      String result =
          input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: DataTable(
                border: TableBorder.all(color: Colors.white, width: 2),
                headingRowColor:
                    WidgetStateProperty.all<Color?>(Colors.deepOrange),
                columns: [
                  DataColumn(
                      label: ColoredBox(
                    color: Colors.grey.shade400,
                    child: const Text(''),
                  )),
                  const DataColumn(
                      label: ColoredBox(
                    color: Colors.deepOrange,
                    child: Text(
                      'Item',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
                  const DataColumn(
                      label: ColoredBox(
                    color: Colors.deepOrange,
                    child: Text(
                      'Margin',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )),
                ],
                rows: widget.tableData.entries
                    .map((entry) {
                      int index =
                          widget.tableData.keys.toList().indexOf(entry.key);
                      String margin = "";
                      if (widget.titleCount != 0) {
                        if (entry.key == "collectedRevenue") {
                          margin = (double.parse(widget
                                      .tableData['collectedRevenue']
                                      .toString()) /
                                  double.parse(widget.tableData['billedRevenue']
                                      .toString()))
                              .toString();
                        } else if (entry.key == "billedRevenue") {
                          margin = "";
                        } else if (widget.tableData[entry.key] is double) {
                          margin = widget.tableData['collectedRevenue'] != null
                              ? (double.parse(widget.tableData[entry.key]
                                          .toString()) /
                                      double.parse(widget
                                          .tableData['collectedRevenue']
                                          .toString()))
                                  .toString()
                              : "";
                        }
                      }

                      margin =
                          margin.length > 5 ? margin.substring(0, 5) : margin;

                      return entry.value is double
                          ? DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                return index.isEven
                                    ? Colors.white
                                    : Colors.green.shade100;
                              }),
                              cells: [
                                  DataCell(Text(
                                    convertToFormattedString(
                                        entry.key.toString()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                  DataCell(Text(entry.value.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))),
                                  DataCell(Text(margin)),
                                ])
                          : null;
                    })
                    .whereType<DataRow>()
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

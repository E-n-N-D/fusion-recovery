import 'package:flutter/material.dart';
import 'package:fusion_recovery/pages/add_logs.dart';
import 'package:fusion_recovery/services/database_service.dart';
import 'package:fusion_recovery/services/save_to_excel.dart';
import 'package:fusion_recovery/widgets/buttonWidget.dart';
import 'package:fusion_recovery/widgets/dashboard_view.dart';
import 'package:fusion_recovery/widgets/dateBtn.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> frcData = [];
  List<Map<String, dynamic>> fraData = [];
  List<Map<String, dynamic>> frrData = [];
  bool _isLoading = true;
  bool downloadWait = false;

  bool hasError = false;

  void showAlertDialog(BuildContext context) {
    // Create the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Error fetching data!"),
      actions: [
        TextButton(
          onPressed: () {
            fetchData();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Try again!"),
        ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>>? temp1 =
          await _databaseService.getDataJson("frc");
      if (temp1 == null) {
        setState(() {
          hasError = true;
          // print("Error occured");
          showAlertDialog(context);
        });
        return;
      }
      List<Map<String, dynamic>>? temp2 =
          await _databaseService.getDataJson('fra');
      List<Map<String, dynamic>>? temp3 =
          await _databaseService.getDataJson('frr');

      setState(() {
        frcData = temp1;
        fraData = temp2!;
        frrData = temp3!;
      });
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int titleCount = 0;
  int dateCount = 0;
  bool swiped = false;

  double dragThreshold = 50.0;
  double startDragPosition = 0.0;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: const Center(
                        child: Image(
                      image: AssetImage('images/fusion-recovery.png'),
                      fit: BoxFit.fill,
                    )),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.75,
                            child: _dataListView(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          frcData.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    dateCount == 0
                                        ? Buttonwidget(
                                            bgColor: Colors.red,
                                            buttonLabel: 'Delete Log',
                                            onClick: () async {
                                              await _databaseService.deleteAll(
                                                  frcData[dateCount]['forDate']);
                                              setState(() {
                                                frcData.removeAt(0);
                                                fraData.removeAt(0);
                                                frrData.removeAt(0);
                                              });
                                            })
                                        : const SizedBox.shrink(),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          downloadWait = true;
                                        });
                                        try {
                                          await saveToExcel(
                                              frcData[dateCount]['forDate']
                                                  .toString(),
                                              context);
                                        } finally {
                                          setState(() {
                                            downloadWait = false;
                                          });
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: 200,
                                          height: 50,
                                          color: Colors.blue,
                                          padding: const EdgeInsets.all(8),
                                          child: downloadWait
                                              ? const Center(
                                                child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                              )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      "Download as Excel",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.download,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _dataListView() {
    if (frcData.isEmpty) {
      DateTime dtNow = DateTime.now();
      String logAddingDate = DateFormat('yyyy-MM-dd').format(dtNow);
      return Center(
        child: Buttonwidget(
            bgColor: Colors.green,
            buttonLabel: "Add Log",
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddLogs(
                          forDate: logAddingDate,
                          isEdit: false,
                        )),
              );
            }),
      );
    } else {
      Map<String, dynamic> frModel = titleCount == 0
          ? frcData[dateCount]
          : titleCount == 1
              ? fraData[dateCount]
              : frrData[dateCount];

      DateTime dt = DateTime.parse(frModel['forDate'].toString());
      DateTime dtNew = dt.add(const Duration(days: 7));
      DateTime dtNow = DateTime.now();
      String logAddingDate =
          dateCount == 0 ? DateFormat('yyyy-MM-dd').format(dtNew) : "";
      bool isEdit = dtNow.isBefore(dt.add(const Duration(days: 1)));

      return Column(
        children: [
          logAddingDate != ""
              ? Buttonwidget(
                  bgColor: isEdit ? Colors.blue : Colors.green,
                  buttonLabel: isEdit ? "Edit Log" : "Add Log",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddLogs(
                                forDate: isEdit
                                    ? frModel['forDate'].toString()
                                    : logAddingDate,
                                isEdit: isEdit,
                                frcData: frcData[dateCount],
                                fraData: fraData[dateCount],
                                frrData: frrData[dateCount],
                              )),
                    );
                  })
              : const SizedBox(
                  height: 48,
                ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.blue.shade300, boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.3), // Shadow color with opacity
                offset:
                    const Offset(4, 4), // Shadow offset (horizontal, vertical)
                blurRadius: 8, // How much the shadow should be blurred
                spreadRadius: 2, // How much the shadow should spread
              ),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateBtn(
                    onClicked: () {
                      setState(() {
                        dateCount = dateCount == frcData.length - 1
                            ? dateCount
                            : dateCount += 1;
                      });
                    },
                    icnData: Icons.arrow_back_ios_outlined),
                Text(
                  frModel['forDate'].toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                DateBtn(
                    onClicked: () {
                      setState(() {
                        dateCount = dateCount == 0 ? dateCount : dateCount -= 1;
                      });
                    },
                    icnData: Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            titleCount == 0
                ? "Fusion Recovery Centers"
                : titleCount == 1
                    ? "Fusion Recovery Albany"
                    : "Fusion 820 River Residential",
            style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.05),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                startDragPosition = details.localPosition.dx;
              },
              onHorizontalDragUpdate: (details) {
                double dragDistance =
                    details.localPosition.dx - startDragPosition;

                // Only change titleCount if the distance is above the threshold.
                if (dragDistance > dragThreshold && !swiped) {
                  setState(() {
                    // Swipe to the left (next)
                    if (titleCount > 0) {
                      titleCount--;
                      swiped = true;
                    }
                  });
                } else if (dragDistance < -dragThreshold && !swiped) {
                  setState(() {
                    // Swipe to the right (previous)
                    if (titleCount < 2) {
                      titleCount++;
                      swiped = true;
                    }
                  });
                }
              },
              onHorizontalDragEnd: (details) {
                // Reset the drag position after the swipe is completed.
                startDragPosition = 0.0;
                setState(() {
                  swiped = false;
                });
              },
              child: DashboardView(
                tableData: frModel,
                titleCount: titleCount,
              ),
            ),
          ),
        ],
      );
    }
  }
}

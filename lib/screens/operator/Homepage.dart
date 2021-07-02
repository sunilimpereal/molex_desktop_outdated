import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/screens/utils/colorLoader.dart';
import 'package:molex_desktop/screens/widgets/drawer.dart';
import 'package:molex_desktop/screens/widgets/switchButton.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';
import 'materialPick.dart';

// Process 1 Auto Cut and Crimp
class Homepage extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Homepage({required this.employee, required this.machine});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Schedule schedule;
  int? type = 0;
  String? sameMachine = 'true';
  int? scheduleType = 0;
  late ApiService apiService;

  String? dropdownName = "FG part";

  var _chosenValue = "Order Id";

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();
    apiService.getScheduelarData(
        machId: widget.machine.machineNumber, type: type == 0 ? "A" : "B");
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        backwardsCompatibility: false,
        title: Text(
          '${widget.machine.category}',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
        elevation: 0,
        actions: [
          //typeselect

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3),
            decoration: BoxDecoration(),
            child: Row(
              children: [
                SwitchButton(
                  options: ['Auto', "Manual"],
                  onToggle: (index) {
                    print('switched to: $index');
                    type = index;

                    setState(() {
                      _searchController.clear();
                      type = index;
                    });
                  },
                ),
                // Container(
                //   height: 25,
                //   decoration: BoxDecoration(
                //     color: Colors.red.shade500,
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     border: Border.all(color: Colors.red.shade500, width: 1.5),
                //   ),
                //   child: ToggleSwitch(
                //     minWidth: 68.0,
                //     cornerRadius: 5.0,
                //     activeBgColor: Colors.red.shade500,
                //     activeFgColor: Colors.white,
                //     initialLabelIndex: type,
                //     inactiveBgColor: Colors.white,
                //     inactiveFgColor: Colors.red,
                //     fontSize: 12,
                //     fontWeight: FontWeight.normal,
                //     labels: ['Auto', 'Manual'],
                //     onToggle: (index) {
                //       print('switched to: $index');
                //       type = index;
                //       setState(() {
                //         _searchController.clear();
                //         type = index;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                SwitchButton(
                  options: ['Same MC', 'Other MC'],
                  onToggle: (index) {
                    print('switched to: $index');
                    scheduleType = index;
                    setState(() {
                      _searchController.clear();
                      scheduleType = index;
                    });
                  },
                ),
                // Container(
                //   height: 25,
                //   decoration: BoxDecoration(
                //     // color: Colors.red.shade500,
                //     borderRadius: BorderRadius.all(Radius.circular(50)),
                //     // border: Border.all(color: Colors.red.shade500),
                //   ),
                //   child: ToggleSwitch(
                //     minWidth: 75.0,
                //     cornerRadius: 5.0,
                //     activeBgColor: Colors.red.shade500,
                //     activeFgColor: Colors.white,
                //     initialLabelIndex: scheduleType,
                //     inactiveBgColor: Colors.white,
                //     inactiveFgColor: Colors.red,
                //     labels: ['Same MC', 'Other MC'],
                //     fontSize: 12,
                //     onToggle: (index) {
                //       print('switched to: $index');
                //       scheduleType = index;
                //       setState(() {
                //         _searchController.clear();
                //         scheduleType = index;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),

          //shift
          SizedBox(width: 10),
          //machine Id
          Container(
            padding: EdgeInsets.all(1),
            // width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            widget.employee.empId ?? '',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ),
                        ],
                      )),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.settings,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            widget.machine.machineNumber ?? "",
                            style: GoogleFonts.openSans(
                              textStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                )
              ],
            ),
          ),

          TimeDisplay(),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => NavPage(
          //                 schedule: schedule,
          //                 userId: widget.userId ??'',
          //                 machine: widget.machine,
          //               )),
          //     );
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Material(
          //       elevation: 4,
          //       shadowColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100.0)),
          //       child: Container(
          //         width: 40,
          //         decoration: BoxDecoration(
          //             color: Colors.amber,
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.white,
          //                 offset: const Offset(0.0, 0.0),
          //                 blurRadius: 0.0,
          //                 spreadRadius: 0.0,
          //               ), //Bo
          //             ],
          //             borderRadius: BorderRadius.all(Radius.circular(100)),
          //             image: DecorationImage(
          //                 image: AssetImage(
          //                   'assets/image/profile.jpg',
          //                 ),
          //                 fit: BoxFit.fill)),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
      drawer: Drawer(
        child: DrawerWidget(
            employee: widget.employee,
            machineDetails: widget.machine,
            type: "process"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Divider(
            //   color: Colors.redAccent,
            //   thickness: 2,
            // ),
            search(),
            SchudleTable(
              employee: widget.employee,
              machine: widget.machine,
              type: type == 0 ? "A" : "M",
              scheduleType: scheduleType == 0 ? "true" : "false",
              searchType: _chosenValue,
              query: _searchController.text,
              key: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget search() {
    if (type == 1) {
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SizedBox(width: 15),
            dropdown(
                options: ["Order Id", "FG Part No.", "Cable Part No"],
                name: "Order Id"),
            SizedBox(width: 10),
            Container(
              height: 38,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.red.shade500,
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 180,
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(fontSize: 16)),
                        onTap: () {},
                        decoration: new InputDecoration(
                          // suffix: _searchController.text.length > 1
                          //     ? GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //              SystemChannels.textInput
                          //         .invokeMethod('TextInput.hide');
                          //             _searchController.clear();
                          //           });
                          //         },
                          //         child: Icon(Icons.clear,
                          //             size: 16, color: Colors.red))
                          //     : Container(),
                          hintText: _chosenValue,
                          hintStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 13, top: 11, right: 0),
                          fillColor: Colors.white,
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget dropdown({required List<String?> options, String? name}) {
    return Container(
        child: DropdownButton<String?>(
      focusColor: Colors.red,
      value: _chosenValue,
      underline: Container(
        height: 2,
        color: Colors.red,
      ),
      isDense: false,
      isExpanded: false,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(color: Colors.white),
      ),
      iconSize: 28,
      iconEnabledColor: Colors.redAccent,
      items: options.map<DropdownMenuItem<String?>>((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(
            value!,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Text(name!,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          )),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value!;
        });
      },
    ));
  }
}

class SchudleTable extends StatefulWidget {
  Schedule? schedule;
  Employee employee;
  MachineDetails machine;
  String? scheduleType;
  String? type;
  String? searchType;
  String? query;
  SchudleTable(
      {required Key? key,
      this.schedule,
      required this.employee,
      this.type,
      this.searchType,
      this.query,
      required this.machine,
      this.scheduleType})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<Schedule> schedualrList = [];

  List<DataRow> datarows = [];
  late ApiService apiService;

  late PostStartProcessP1 postStartprocess;
  @override
  void initState() {
    apiService = new ApiService();

    super.initState();
  }

  List<Schedule> searchfilter(List<Schedule> scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList
            .where((element) => element.orderId!.startsWith(widget.query ?? ''))
            .toList();
      case "FG Part No.":
        return scheduleList
            .where((element) =>
                element.finishedGoodsNumber!.startsWith(widget.query ?? ''))
            .toList();
      case "Cable Part No":
        return scheduleList
            .where((element) =>
                element.cablePartNumber!.startsWith(widget.query ?? ''))
            .toList();
      default:
        return scheduleList;
    }
  }

  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              tableHeading(),
              SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height *
                        (widget.type == "M" ? 0.89 : 0.895),
                    // height: double ?.parse("${rowList.length*60}"),
                    child: FutureBuilder(
                      future: apiService.getScheduelarData(
                          machId: widget.machine.machineNumber,
                          type: widget.type,
                          sameMachine: widget.scheduleType),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // return  buildDataRow(schedule:widget.schedule,c:2);
                          List<Schedule> schedulelist =
                              searchfilter(snapshot.data as List<Schedule>);
                          schedulelist = schedulelist
                              .where((element) =>
                                  element.scheduledStatus!.toLowerCase() !=
                                  "complete".toLowerCase())
                              .toList();
                          if (schedulelist.length > 0) {
                            return ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: schedulelist.length,
                                itemBuilder: (context, index) {
                                  return buildDataRow(
                                      schedule: schedulelist[index],
                                      c: index + 1);
                                });
                          } else {
                            return Center(
                              child: Container(
                                  child: Text(
                                'No Schedule Found',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black)),
                              )),
                            );
                          }
                        } else {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Center(
                              child: Container(
                                  child: Text(
                                'No Schedule Found',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black)),
                              )),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // no data
  // empty list

  Widget tableHeading() {
    Widget cell(String? name, double? width, bool sort) {
      return Container(
        width: MediaQuery.of(context).size.width * width!,
        height: 40,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name!,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        // color: Color(0xffBF3947),
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Material(
        elevation: 4,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order ID", 0.07, true),
                  cell("FG Part", 0.07, true),
                  cell("Schedule ID", 0.07, false),
                  cell("Cable Part No.", 0.10, true),
                  cell("Process", 0.13, false),
                  cell("Cut Length(mm)", 0.10, true),
                  cell("Color", 0.06, false),
                  cell("Scheduled Qty", 0.085, true),
                  cell("Time", 0.06, true),
                  cell("Status", 0.08, true),
                  cell("Action", 0.08, true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataRow({required Schedule schedule, int? c}) {
    Widget cell(String? name, double? width) {
      return Container(
        width: MediaQuery.of(context).size.width * width!,
        height: 34,
        child: Center(
          child: Text(
            name!,
            style: GoogleFonts.openSans(
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 1,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: c! % 2 == 0 ? Colors.white : Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                color: schedule.scheduledStatus!.toLowerCase() ==
                        "Complete".toLowerCase()
                    ? Colors.green
                    : schedule.scheduledStatus!.toLowerCase() ==
                            "Partially".toLowerCase()
                        ? Colors.orange.shade100
                        : Colors.blue.shade100,
                width: 5,
              )),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell(schedule.orderId, 0.07),
                //Fg Part
                cell(schedule.finishedGoodsNumber, 0.07),

                //Schudule ID
                cell(schedule.scheduledId, 0.07),
                //Cable Part
                cell(schedule.cablePartNumber, 0.10),

                //Process
                cell(schedule.process, 0.13),
                // Cut length
                cell(schedule.length, 0.1),
                //Color
                cell(schedule.color, 0.06),
                //Scheduled Qty
                cell(schedule.scheduledQuantity, 0.085),
                Container(
                  width: MediaQuery.of(context).size.width * 0.06,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          "${schedule.shiftStart!.length > 4 ? schedule.shiftStart!.substring(0, 5) : schedule.shiftStart}",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                // color: Color(0xffBF3947),
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )),
                      Text(
                          "${schedule.shiftEnd!.length > 4 ? schedule.shiftEnd!.substring(0, 5) : schedule.shiftEnd}",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                // color: Color(0xffBF3947),
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ),

                //Status
                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: schedule.scheduledStatus!.toLowerCase() ==
                          "Partially Completed".toLowerCase()
                      ? 45
                      : 30,
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: schedule.scheduledStatus!.toLowerCase() ==
                                'Complete'.toLowerCase()
                            ? Colors.green.shade100
                            : schedule.scheduledStatus!.toLowerCase() ==
                                    "Partially Completed".toLowerCase()
                                ? Colors.red.shade100
                                : Colors.blue.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            schedule.scheduledStatus ?? '',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: schedule.scheduledStatus!
                                            .toLowerCase() ==
                                        'Complete'.toLowerCase()
                                    ? Colors.green
                                    : schedule.scheduledStatus!.toLowerCase() ==
                                            "Partially Completed".toLowerCase()
                                        ? Colors.red.shade400
                                        : Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: 55,
                  child: schedule.scheduledStatus!.toLowerCase() ==
                          "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shadowColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.white;
                                      return Colors
                                          .white; // Use the component's default.
                                    },
                                  ),
                                  elevation: MaterialStateProperty.resolveWith<
                                      double?>((Set<MaterialState> states) {
                                    return 10;
                                  }),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors.green; // Use the component's default.
                                    },
                                  ),
                                ),
                                child: Container(
                                    child: schedule.scheduledStatus!
                                                    .toLowerCase() ==
                                                "Allocated".toLowerCase() ||
                                            schedule.scheduledStatus!
                                                    .toLowerCase() ==
                                                "Open".toLowerCase() ||
                                            schedule.scheduledStatus!
                                                    .toLowerCase() ==
                                                "".toLowerCase() ||
                                            schedule.scheduledStatus == null
                                        ? Text(
                                            "Accept",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : schedule.scheduledStatus!
                                                        .toLowerCase() ==
                                                    "Pending".toLowerCase() ||
                                                schedule.scheduledStatus!
                                                        .toLowerCase() ==
                                                    "Partially Completed"
                                                        .toLowerCase()
                                            ? Text(
                                                'Continue',
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            : Text('')),
                                onPressed: () async {
                                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                                  postStartprocess = new PostStartProcessP1(
                                    cablePartNumber:
                                        schedule.cablePartNumber ?? "0",
                                    color: schedule.color,
                                    finishedGoodsNumber:
                                        schedule.finishedGoodsNumber ?? "0",
                                    lengthSpecificationInmm:
                                        schedule.length ?? "0",
                                    machineIdentification:
                                        widget.machine.machineNumber,
                                    orderIdentification:
                                        schedule.orderId ?? "0",
                                    scheduledIdentification:
                                        schedule.scheduledId ?? "0",
                                    scheduledQuantity:
                                        schedule.scheduledQuantity ?? "0",
                                    scheduleStatus: "started",
                                  );

                                  Fluttertoast.showToast(
                                      msg: "Loading",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  apiService
                                      .startProcess1(postStartprocess)
                                      .then((value) {
                                    if (value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MaterialPick(
                                                  schedule: schedule,
                                                  employee: widget.employee,
                                                  machine: widget.machine,
                                                  materialPickType:
                                                      MaterialPickType.newload,
                                                  reload: null,
                                                )),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Unable to Start Process",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                    return () {};
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

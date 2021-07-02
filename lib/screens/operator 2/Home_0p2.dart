import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/screens/operator/materialPick.dart';
import 'package:molex_desktop/screens/utils/colorLoader.dart';
import 'package:molex_desktop/screens/widgets/drawer.dart';
import 'package:molex_desktop/screens/widgets/switchButton.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';

import 'materialPick2.dart';

class HomePageOp2 extends StatefulWidget {
  final Employee employee;
  final MachineDetails machine;
  HomePageOp2({required this.employee, required this.machine});
  @override
  _HomePageOp2State createState() => _HomePageOp2State();
}

class _HomePageOp2State extends State<HomePageOp2> {
  int ? type = 0;
  late ApiService apiService;
  int ? scheduleType = 0;

  var _chosenValue = "Order Id";
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();
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
        title: Text('Crimping',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(color: Colors.red, fontSize: 18),
            )),
        elevation: 0,
        actions: [
          //typeselect
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3),
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
                //     labels: ['Auto', 'Manual'],
                //     onToggle: (index) {
                //       print('switched to: $index');
                //       type = index;

                //       setState(() {
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
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                SwitchButton(
                  options: [' Same MC ', ' Other MC '],
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
                //     color: Colors.red.shade500,
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     border: Border.all(color: Colors.red.shade500),
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
                //         scheduleType = index;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          //shift
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
                          Text(widget.employee.empId??'',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              )),
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
                          Text(widget.machine.machineNumber ?? "",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              )),
                        ],
                      )),
                    ),
                  ],
                )
              ],
            ),
          ),

          TimeDisplay(),
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
            Divider(
              color: Colors.redAccent,
              thickness: 2,
            ),
            search(),
            SchudleTable(
              employee: widget.employee,
              machine: widget.machine,
              type: type == 0 ? "A" : "M",
              scheduleType: scheduleType == 0 ? "true" : "false",
              searchType: _chosenValue,
              query: _searchController.text, schedule: null,
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
            SizedBox(width: 10),
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
                      color: Colors.red.shade400,
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
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget dropdown({required List<String ?> options, String ? name}) {
    return Container(
        child: DropdownButton<String ?>(
      focusColor: Colors.white,
      value: _chosenValue,
      underline: Container(),
      isDense: false,
      isExpanded: false,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(color: Colors.white),
      ),
      iconEnabledColor: Colors.redAccent,
      items: options.map<DropdownMenuItem<String ?>>((String ? value) {
        return DropdownMenuItem<String ?>(
          value: value,
          child: Text(
            value!,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Column(
        children: [
          Text(
            name!,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      onChanged: (String ? value) {
        setState(() {
          _chosenValue = value!;
        });
      },
    ));
  }
}

class SchudleTable extends StatefulWidget {
  final Schedule? schedule;
  final Employee employee;
  final MachineDetails machine;
  String ? scheduleType;
  String ? type;
  String ? searchType;
  String ? query;
  SchudleTable(
      {Key? key,
      required this.schedule,
      required this.employee,
      required this.machine,
      this.scheduleType,
      this.type,
      this.searchType,
      this.query})
      : super(key: key);

  @override
  _SchudleTableState createState() => _SchudleTableState();
}

class _SchudleTableState extends State<SchudleTable> {
  List<DataRow> datarows = [];
  late ApiService apiService;
  late List<CrimpingSchedule> crimpingSchedule;
  late PostStartProcessP1 postStartprocess;
  @override
  void initState() {
    apiService = new ApiService();

    super.initState();
  }

  List<CrimpingSchedule> searchfilter(List<CrimpingSchedule> scheduleList) {
    switch (widget.searchType) {
      case "Order Id":
        return scheduleList
            .where((element) =>
                element.purchaseOrder.toString().startsWith(widget.query??''))
            .toList();
      case "FG Part No.":
        return scheduleList
            .where((element) =>
                element.finishedGoods.toString().startsWith(widget.query??""))
            .toList();
      case "Cable Part No":
        return scheduleList
            .where((element) =>
                element.cablePartNo.toString().startsWith(widget.query??""))
            .toList();
      default:
        return scheduleList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          tableHeading(),
          SingleChildScrollView(
            child: Container(
                height: widget.type == "M" ? 430 : 490,
                // height: double ?.parse("${rowList.length*60}"),
                child: FutureBuilder(
                  future: apiService.getCrimpingSchedule(
                      scheduleType: "${widget.type}",
                      machineNo: widget.machine.machineNumber,
                      sameMachine: "${widget.scheduleType}"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CrimpingSchedule> schedulelist =
                          searchfilter(snapshot.data as List<CrimpingSchedule>);
                      schedulelist = schedulelist
                          .where(
                              (element) => element.schedulestatus!.toLowerCase() != "Complete".toLowerCase())
                          .toList();
                      log("aaa $schedulelist");
                      if (schedulelist.length > 0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: schedulelist.length,
                            itemBuilder: (context, index) {
                              return buildDataRow(
                                  schedule: schedulelist[index], c: index);
                            });
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(108.0),
                          child: Center(
                            child: Container(
                                child: Text(
                              'No Schedule Found',
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(color: Colors.black)),
                            )),
                          ),
                        );
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(108.0),
                        child: Center(
                          child: Container(
                              child: Text(
                            'No Schedule Found',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(color: Colors.black)),
                          )),
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget tableHeading() {
    Widget cell(String ? name, double ? width) {
      return Container(
        width: MediaQuery.of(context).size.width * width!,
        height: 40,
        child: Center(
          child: Text(
            name!,
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  // color: Color(0xffBF3947),
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 4,
        shadowColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order Id", 0.09),
                  cell("FG Part", 0.09),
                  cell("Schedule ID", 0.1),
                  cell("Cable Part No.", 0.1),
                  cell("Process", 0.12),
                  cell("Cut Length\n(mm)", 0.07),
                  cell("Color", 0.04),
                  cell("BIN Id", 0.09),
                  cell("Total \nBundles", 0.05),
                  cell("Total \nBundle Qty", 0.07),
                  // cell("Status", 0.09),
                  cell("Action", 0.1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataRow({required CrimpingSchedule schedule, int ? c}) {
    Widget cell(String ? name, double ? width) {
      return Container(
        width: MediaQuery.of(context).size.width * width!,
        height: 38,
        child: Center(
          child: Text(
            name!,
            style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)),
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
          height: 50,
          color: c! % 2 == 0 ? Colors.grey.shade50 : Colors.white,
          child: Container(
            decoration: BoxDecoration(
                // border: Border(
                //     left: BorderSide(
                //   color: schedule.scheduledStatus == "Complete"
                //       ? Colors.green
                //       : schedule.scheduledStatus == "Pending"
                //           ?  Colors.orange.shade100
                //           : Colors.blue.shade100,
                //   width: 5,
                // )),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell('${schedule.purchaseOrder}', 0.09),
                //Fg Part
                cell('${schedule.finishedGoods}', 0.09),
                //Schudule ID
                cell('${schedule.scheduleId}', 0.1),
                //Cable Part
                cell('${schedule.cablePartNo}', 0.1),
                //Process
                cell('${schedule.process}', 0.12),
                // Cut length
                cell('${schedule.length}', 0.07),
                //Color2
                cell('${schedule.wireColour}', 0.04),
                //Bin Id
                cell("${schedule.binIdentification}", 0.09),
                // Total bundles
                cell("${schedule.bundleIdentificationCount}", 0.05),
                //Total Bundle Qty
                cell("${schedule.bundleQuantityTotal}", 0.07),

                //Status
                // cell("${schedule.scheduledStatus}", 0.09),
                //Action
                Container(
                  width: 84,
                  height: 45,
                  child: schedule.schedulestatus!.toLowerCase() ==
                          "Complete".toLowerCase()
                      ? Center(child: Text("-"))
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ProgressButton(
                                color: schedule.schedulestatus!.toLowerCase() ==
                                        "Partially Completed".toLowerCase()
                                    ? Colors.green.shade500
                                    : Colors.green.shade500,
                                defaultWidget: Container(
                                    child: schedule.schedulestatus!
                                                    .toLowerCase() ==
                                                "Allocated".toLowerCase() ||
                                            schedule.schedulestatus!
                                                    .toLowerCase() ==
                                                "Open".toLowerCase() ||
                                            schedule.schedulestatus!
                                                    .toLowerCase() ==
                                                "".toLowerCase() ||
                                            schedule.schedulestatus == null
                                        ? Text(
                                            "Accept",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : schedule.schedulestatus!
                                                        .toLowerCase() ==
                                                    "Pending".toLowerCase() ||
                                                schedule.schedulestatus!
                                                        .toLowerCase() ==
                                                    "Partially Completed"
                                                        .toLowerCase()
                                            ? Text(
                                                'Continue',
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            : Text('')),
                                animate: true,
                                progressWidget: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(17.0),
                                    child: Container(
                                      height: 10,
                                      child: ColorLoader4(
                                        dotOneColor: Colors.white,
                                        dotThreeColor: Colors.white,
                                        dotTwoColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                width: 30,
                                height: 40,
                                onPressed: () async {
                                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                                  postStartprocess = new PostStartProcessP1(
                                    cablePartNumber:
                                        "${schedule.cablePartNo ?? "0"}",
                                    color: schedule.wireColour,
                                    finishedGoodsNumber:
                                        "${schedule.finishedGoods ?? "0"}",
                                    lengthSpecificationInmm:
                                        "${schedule.length ?? "0"}",
                                    machineIdentification:
                                        widget.machine.machineNumber,
                                    orderIdentification:
                                        "${schedule.purchaseOrder ?? "0"}",
                                    scheduledIdentification:
                                        "${schedule.scheduleId ?? "0"}",
                                    scheduledQuantity:
                                        schedule.schdeuleQuantity ?? "0",
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
                                            builder: (context) =>
                                                MaterialPickOp2(
                                                  schedule: schedule,
                                                  employee: widget.employee,
                                                  machine: widget.machine,
                                                  materialPickType:
                                                      MaterialPickType.newload, reload: null,
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
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.10,
                //   child: Center(
                //     child: false
                //         // schedule.scheduledStatus == "Complete"
                //         ? Text("-")
                //         : ElevatedButton(
                //             style: ButtonStyle(
                //               backgroundColor:
                //                   MaterialStateProperty.resolveWith<Color>(
                //                 (Set<MaterialState> states) {
                //                   if (states.contains(MaterialState.pressed))
                //                     return Colors.green;
                //                   return Colors.green;
                //                   //  schedule.scheduledStatus == "Pending"
                //                   //     ? Colors.red
                //                   //     : Colors
                //                   //         .green; // Use the component's default.
                //                 },
                //               ),
                //             ),
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => MaterialPickOp2(
                //                           schedule: schedule,
                //                           userId: widget.userId ??'',
                //                           machine: widget.machine,
                //                           materialPickType:
                //                               MaterialPickType.newload,
                //                         )),
                //               );
                //             },
                //             child: Container(
                //               child: Text('Accept'),
                //               //  child:
                //               //   schedule.scheduledStatus == "Allocated"|| schedule.scheduledStatus == "Open"||schedule.scheduledStatus == ""||schedule.scheduledStatus == null
                //               //       ? Text("Accept")
                //               //       : schedule.scheduledStatus == "Pending"
                //               //           ? Text('Continue')
                //               //           : Text(''),
                //             ),
                //           ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

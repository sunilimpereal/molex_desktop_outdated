import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/visualInspection/VI_scheduler_model.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';

import 'VI_WIP_home.dart';

class HomeVisualInspector extends StatefulWidget {
  Employee employee;
  String? machineId;
  HomeVisualInspector({required this.employee, this.machineId});
  @override
  _HomeVisualInspectorState createState() => _HomeVisualInspectorState();
}

class _HomeVisualInspectorState extends State<HomeVisualInspector> {
  String? _chosenValue = "Order ID";
  late ApiService apiService;

  TextEditingController _searchController = new TextEditingController();
  @override
  void initState() {
    apiService = new ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          backwardsCompatibility: false,
          leading: null,
          title: const Text(
            'Visual Inspector Dashboard',
            style: TextStyle(color: Colors.red),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              padding: EdgeInsets.all(1),
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
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.shade100,
                        offset: const Offset(
                          2.0,
                          2.0,
                        ),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //Bo
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/image/profile.jpg',
                        ),
                        fit: BoxFit.fill)),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Select
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    dropdown(options: [
                                      "Order ID",
                                      "FG No.",
                                      "Schedule ID",
                                    ], name: "Order ID"),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 38,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.grey.shade100,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 20,
                                              color: Colors.red.shade400,
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              width: 130,
                                              height: 30,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TextField(
                                                controller: _searchController,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                style: TextStyle(fontSize: 13),
                                                onTap: () {},
                                                decoration: new InputDecoration(
                                                  hintText: _chosenValue,
                                                  hintStyle:
                                                      GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 11,
                                                          top: 11,
                                                          right: 15),
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
                                Container(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  color: Colors.transparent))),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.green.shade200;
                                          return Colors
                                              .green; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    child: Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/image/scan.png"))),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Scan',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VIWIP_Home(
                                                  employee: widget.employee,
                                                )),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Scan
                          //Date
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.redAccent,
                thickness: 2,
              ),
              ViScheduleTable(
                query: _searchController.text,
                searchType: _chosenValue, schedule: null, viScheduleList: [],
              )
            ],
          ),
        ));
  }

  Widget dropdown({required List<String?> options, String? name}) {
    return Container(
        child: DropdownButton<String?>(
      focusColor: Colors.white,
      value: _chosenValue,
      style: TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: options.map<DropdownMenuItem<String?>>((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(
            value!,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Text(
        name!,
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value;
        });
      },
    ));
  }
}

class ViScheduleTable extends StatefulWidget {
  List<ViSchedule> viScheduleList;
  Schedule ?schedule;
  String? searchType;
  String? query;
  ViScheduleTable({
    required this.viScheduleList,
     this.schedule,
    this.searchType,
    this.query,
  });
  @override
  _ViScheduleTableState createState() => _ViScheduleTableState();
}

class ViSchedule {}

class _ViScheduleTableState extends State<ViScheduleTable> {
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  List<ViScheduler> searchfilter(List<ViScheduler> scheduleList) {
    switch (widget.searchType) {
      case "Order ID":
        return scheduleList
            .where((element) => element.orderId!.startsWith(widget.query ?? ''))
            .toList();
        break;
      case "FG No.":
        return scheduleList
            .where((element) => element.fgNo!.startsWith(widget.query ?? ''))
            .toList();
        break;
      case "Schedule Id":
        return scheduleList
            .where(
                (element) => element.scheduleId!.startsWith(widget.query ?? ''))
            .toList();
        break;
      default:
        return scheduleList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            tableHeading(),
            SingleChildScrollView(
              child: Container(
                height: 450,

                // height: double ?.parse("${rowList.length*60}"),
                child: FutureBuilder(
                    future: apiService.getviSchedule(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ViScheduler> vischedule =
                            searchfilter(snapshot.data as List<ViScheduler>);
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: vischedule.length,
                            itemBuilder: (context, index) {
                              return buildDataRow(
                                  viSchedule: vischedule[index], c: index + 1);
                            });
                      } else {
                        return Container();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

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
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cell("Order ID", 0.09, true),
                  cell("FG Part", 0.09, true),
                  cell("Schedule ID", 0.08, false),
                  cell("Bin ID", 0.08, true),
                  cell("Total Bundles", 0.10, false),

                  // cell("Action", 0.08, true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataRow({required ViScheduler viSchedule, int? c}) {
    Widget cell(String? name, double? width) {
      return Container(
        width: MediaQuery.of(context).size.width * width!,
        height: 30,
        child: Center(
          child: Text(
            name!,
            style: GoogleFonts.openSans(
              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
          height: 50,
          color: c! % 2 == 0 ? Colors.white : Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
                // border: Border(
                //     left: BorderSide(
                //   color: schedule.scheduledStatus == "Complete"
                //       ? Colors.green
                //       : schedule.scheduledStatus == "Pending"
                //           ? Colors.red
                //           : Colors.green.shade100,
                //   width: 5,
                // )),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // orderId
                cell(viSchedule.orderId, 0.09),
                //Fg Part
                cell(viSchedule.fgNo, 0.09),

                //Schudule ID
                cell(viSchedule.scheduleId, 0.08),
                // ToDo changed vin id and bundle id

                //Cable Part
                cell(viSchedule.totalBundles, 0.08),
                //Process
                cell(viSchedule.binId, 0.10),
                // Cut length

                //Color
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ApiService>('apiService', apiService));
  }
}

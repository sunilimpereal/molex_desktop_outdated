import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex_desktop/model_api/cableDetails_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/models/bundle_scan.dart';
import 'package:molex_desktop/screens/operator%202/materialPick2.dart';
import 'package:molex_desktop/screens/operator%202/process/partialCompletion.dart';
import 'package:molex_desktop/screens/operator%202/process/scanBundle.dart';
import 'package:molex_desktop/screens/operator/location.dart';
import 'package:molex_desktop/screens/operator/materialPick.dart';
import 'package:molex_desktop/screens/utils/showBundleDetail.dart';
import 'package:molex_desktop/screens/widgets/P2CrimpingScheduledetail.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';

import 'FullyCompleteP2.dart';
import 'multipleBundleScan.dart';

class ProcessPage2 extends StatefulWidget {
  final Employee employee;
  final MachineDetails machine;
  final CrimpingSchedule schedule;
  MatTrkPostDetail matTrkPostDetail;
  ProcessPage2(
      {required this.machine, required this.employee, required this.schedule, required this.matTrkPostDetail});
  @override
  _ProcessPage2State createState() => _ProcessPage2State();
}

class _ProcessPage2State extends State<ProcessPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Crimping',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          actions: [
            Container(
              width: 125,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.transparent))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red.shade100;
                        return Colors.red.shade500; // Use the component's default.
                      },
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red;
                        return Colors
                            .green.shade500; // Use the component's default.
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.system_security_update_warning_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        "Bundle",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                  onPressed: () {
                    showBundleDetail(context);
                  },
                ),
              ),
            ),
            //machineID
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
                              widget.employee.empId??'',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        )),
                      ),
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
          ],
        ),
        body: Column(
          children: [
            Detail(
              schedule: widget.schedule,
              employee: widget.employee,
              machine: widget.machine,
              matTrkPostDetail: widget.matTrkPostDetail,
            ),
          ],
        ));
  }
}

class Detail extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  CrimpingSchedule schedule;
  MatTrkPostDetail matTrkPostDetail;
  Detail({required this.schedule, required this.machine, required this.employee, required this.matTrkPostDetail});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String ? _chosenValue;
  String ? value;
  bool scanTap = false;
  FocusNode scanBundleFocus = new FocusNode();
  List<BundleScan> bundleScan = [];
  String ? scanId;
  TextEditingController _scanIdController = new TextEditingController();
  bool orderDetailExpanded = true;
  String ? rightside;
  String ? output = '';
  String ? _output = '';
  String ? mainb;
  late ApiService apiService;
  String ? method = 'a-b';
  String ? bundltype = 'single';
  @override
  void initState() {
    apiService = new ApiService();
    mainb = "scanBundle";
    super.initState();
  }

  void continueProcess(String ? name) {
    setState(() {
      mainb = name;
    });
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(children: [
          P2ScheduleDetailWIP(
            schedule: widget.schedule,
          ),
          // tableHeading(),
          // buildDataRow(schedule: widget.schedule),
          // fgDetails(),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            startProcess(),
          ],
        ),
        (() {
          if (_chosenValue != null) {
            return Column(children: [
              terminal(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: materialtable(),
                    ),

                    //buttons and num pad
                    Container(
                        width: 350,
                        height: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 330,
                                  child: Row(
                                    mainAxisAlignment: mainb == "partial"
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.spaceBetween,
                                    children: [
                                      //100% complete
                                      mainb != "100"
                                          ? Container(
                                              height: 40,
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .transparent))),
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Colors
                                                            .green.shade200;
                                                      return Colors.green; // Use the component's default.
                                                    },
                                                  ),
                                                  overlayColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Colors.green;
                                                      return Colors.green; // Use the component's default.
                                                    },
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    mainb = "100";
                                                  });
                                                },
                                                child: Text(
                                                  "100% complete",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      mainb != "partial"
                                          ? Container(
                                              height: 40,
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .transparent))),
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Colors.red.shade200;
                                                      return Colors.red; // Use the component's default.
                                                    },
                                                  ),
                                                  overlayColor:
                                                      MaterialStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .pressed))
                                                        return Colors.green;
                                                      return Colors.red; // Use the component's default.
                                                    },
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    mainb = "partial";
                                                  });
                                                },
                                                child: Text(
                                                  "Partially  complete",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 330,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Partially complete    //Transfer
                                      Container(
                                        height: 40,
                                        width: 160,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent))),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.white;
                                                  return Colors.blue; // Use the component's default.
                                                },
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.green;
                                                  return Colors.green; // Use the component's default.
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              'Transfer',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Location(
                                                          type: "process",
                                                          employee: widget.employee,
                                                          machine:
                                                              widget.machine, locationType: LocationType.partialTransfer,
                                                        )),
                                              );
                                            }),
                                      ),

                                      //Reload Material
                                      Container(
                                        height: 40,
                                        width: 160,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent))),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.white;
                                                  return Colors.blue; // Use the component's default.
                                                },
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.green;
                                                  return Colors.green; // Use the component's default.
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              'Reload Material',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MaterialPickOp2(
                                                    schedule: widget.schedule,
                                                    employee: widget.employee,
                                                    reload: reload,
                                                    machine: widget.machine,
                                                    materialPickType:
                                                        MaterialPickType.reload,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              mainBox(mainb),
            ]);
          } else {
            return Container();
          }
        }()),
      ]),
    );
  }

  Widget mainBox(String ? main) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (main == "scanBundle") {
      return bundltype == "single"
          ? ScanBundle(
              machineId: widget.machine.machineNumber,
              userId: widget.employee.empId,
              schedule: widget.schedule,
              method: method,
            )
          : MultipleBundleScan(
              machineId: widget.machine.machineNumber,
              userId: widget.employee.empId,
              schedule: widget.schedule,
              method: method,
            );
    }
    if (main == "100") {
      return FullCompleteP2(
        employee: widget.employee,
        machine: widget.machine,
        schedule: widget.schedule,
           continueProcess: (value) {
            setState(() {
              mainb = value;
            });
          }
      );
    }
    if (main == "partial") {
      return PartialCompletionP2(
          machine: widget.machine,
          employee: widget.employee,
          schedule: widget.schedule,
          continueProcess: (value) {
            setState(() {
              mainb = value;
            });
          });
    } else {
      return Container();
    }
  }

  Widget terminal() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // terminal A
            method!.contains('a')
                ? Container(
                    height: 97,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FutureBuilder(
                          future: apiService.getCableTerminalA(
                              fgpartNo: "${widget.schedule.finishedGoods}",
                              cablepartno:
                                  "${widget.schedule.cablePartNo.toString()}",
                              length: "${widget.schedule.length}",
                              color: widget.schedule.wireColour,
                              awg: int ?.parse(widget.schedule.awg ?? '0')),
                          builder: (context, snapshot) {
                            CableTerminalA terminalA = snapshot.data as CableTerminalA;
                            if (snapshot.hasData) {
                              return process(
                                  'From Process',
                                  '',
                                  // 'From Strip Length Spec(mm) - ${terminalA.fronStripLengthSpec}',
                                  'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                                  '(${terminalA.processType})(${terminalA.stripLength})(${terminalA.terminalPart})(${terminalA.specCrimpLength})(${terminalA.pullforce})(${terminalA.comment})',
                                  '',
                                  // 'From Unsheathing Length (mm) - 40',
                                  0.35);
                            } else {
                              return process(
                                  'From Process',
                                  '',
                                  'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                                  '(-)()(-)(-)(-)',
                                  '',
                                  // 'From Unsheathing Length (mm) - 40',
                                  0.325);
                            }
                          }),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: FutureBuilder(
                  future: apiService.getCableDetails(
                      fgpartNo: "${widget.schedule.finishedGoods}",
                      cablepartno: "${widget.schedule.cablePartNo}",
                      length: "${widget.schedule.length}",
                      color: widget.schedule.wireColour,
                      awg: int ?.parse(widget.schedule.awg ?? '0')),
                  builder: (context, snapshot) {
                    CableDetails cableDetail = snapshot.data  as CableDetails;
                    if (snapshot.hasData) {
                      return process(
                          'Cable',
                          'Cut Length Spec(mm) -${cableDetail.cutLengthSpec}',
                          'Cable Part Number(Description)',
                          '${cableDetail.cablePartNumber}(${cableDetail.description})',
                          'From Strip Length Spec(mm) ${cableDetail.stripLengthFrom} \n To Strip Length Spec(mm) ${cableDetail.stripLengthTo}',
                          0.28);
                    } else {
                      return process(
                          'Cable',
                          'Cut Length Spec(mm)  - ',
                          'Cable Part Number(Description)',
                          '(-)(-)(-)(-)',
                          'From Strip Length Spec(mm) (-) \n To Strip Length Spec(mm) (-)',
                          0.28);
                    }
                  }),
            ),

            method!.contains("b")
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 95,
                      child: FutureBuilder(
                          future: apiService.getCableTerminalB(
                              fgpartNo: "${widget.schedule.finishedGoods}",
                              cablepartno: "${widget.schedule.cablePartNo}",
                              length: "${widget.schedule.length}",
                              color: widget.schedule.wireColour,
                              awg: int ?.parse(widget.schedule.awg ?? '0')),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              CableTerminalB cableTerminalB = snapshot.data as CableTerminalB;
                              return process(
                                  'To Process',
                                  '',
                                  // 'To Strip Length Spec(mm) - ${cableTerminalB.stripLength}',
                                  'Process(Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                                  '(${cableTerminalB.processType})(${cableTerminalB.stripLength})(${cableTerminalB.terminalPart})(${cableTerminalB.specCrimpLength})(${cableTerminalB.pullforce})(${cableTerminalB.comment})',
                                  '',
                                  0.34);
                            } else {
                              return process(
                                  'To Process',
                                  'From Strip Length Spec(mm) - 40}',
                                  'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                                  '(-)()(-)(-)(-)',
                                  // 'From Unsheathing Length (mm) - 40',''
                                  '',
                                  0.325);
                            }
                          }),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget process(
      String ? p1, String ? p2, String ? p3, String ? p4, String ? p5, double ? width) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        width: MediaQuery.of(context).size.width * width!,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(.3),
          //     blurRadius: 20.0, // soften the shadow
          //     spreadRadius: 0.0, //extend the shadow
          //     offset: Offset(
          //       3.0, // Move to right 10  horizontally
          //       3.0, // Move to bottom 10 Vertically
          //     ),
          //   )
          // ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                // width: MediaQuery.of(context).size.width * 0.31,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          p1!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          p2!,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      p3!,
                      style: TextStyle(fontSize: 9),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * width,
                      child: Text(
                        p4!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      p5!,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget startProcess() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_chosenValue == null) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          child: Row(
            children: [
              DropdownButton<String ?>(
                focusColor: Colors.white,
                value: _chosenValue,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,

                items: <String ?>[
                  'Terminal From Crimping',
                  'Terminal To Crimping',
                  'Terminal From & To Crimping',
                  'Multiple Bundles',
                ].map<DropdownMenuItem<String ?>>((String ? value) {
                  return DropdownMenuItem<String ?>(
                    value: value,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value!,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              height: 30,
                              width: 130,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/image/$value.png"))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                hint: Text(
                  'Select Process',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String ? value) {
                  setState(() {
                    _chosenValue = value;
                    value = value;
                    setState(() {
                      _chosenValue = value;
                      if (value == "Terminal From Crimping") {
                        
                        method = 'a';
                      }
                      if (value == "Terminal To Crimping") {
                        method = 'b';
                      }
                      if (value == "Terminal From & To Crimping") {
                        method = 'a-b';
                      }
                      if (value == "Cutlength & both side stripping") {
                        method = 'c';
                      }
                      if (value == "Multiple Bundles") {
                        bundltype = "multiple";
                        method = 'a-b';
                      }
                      if (value == "CRIMP-TO") {
                        method = 'b';
                      }
                    });
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget materialtable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Process $_chosenValue",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Row(
          children: [
            table(),
           
          ],
        ),
      ],
    );
  }

  Widget table() {
    ApiService apiService = new ApiService();
    return FutureBuilder(
        future:
            apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MaterialDetail> matList = snapshot.data as List<MaterialDetail>;
            return Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    child: Column(children: [
                      row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                          Colors.blue.shade100),
                      Container(
                        height: 63,
                        child: ListView.builder(
                            itemCount: matList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return row(
                                  "${matList[index].cablePartNo}",
                                  "${matList[index].uom.toString()}",
                                  "${matList[index].requiredQty.toString()}",
                                  "${matList[index].loadedQty.toString()}",
                                  "${matList[index].availableQty.toString()}",
                                  Colors.grey.shade100);
                            }),
                      ),
                    ])),
                     Container(
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.transparent))),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.blue.shade200;
                              return Colors
                                  .blue.shade500; // Use the component's default.
                            },
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.blue;
                              return Colors
                                  .blue.shade500; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Return")),
                  ),
                ],
              ),
            )
              ],
            );
          } else {
            return Container(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                        Colors.blue.shade100),
                    Text("no stock found")
                  ],
                ));
          }
        });
  }

  Widget row(String ? partno, String ? uom, String ? require, String ? loaded,
      String ? available, Color color) {
    return Container(
      color: color,
      child: Row(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey.shade100)),
                height: 20,
                width: MediaQuery.of(context).size.width * 0.1,
                child: Center(
                    child: Text(partno!, style: TextStyle(fontSize: 12)))),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  uom!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  require!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.08,
              child: Center(
                child: Text(
                  loaded!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade100)),
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Text(
                  available!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 0.5, color: Colors.grey.shade100)),
            //   height: 20,
            //   width: MediaQuery.of(context).size.width * 0.08,
            //   child: Center(
            //     child: Text(
            //       pending,
            //       style: TextStyle(fontSize: 10),
            //     ),
            //   ),
            // ),
          ],
        )
      ]),
    );
  }
}

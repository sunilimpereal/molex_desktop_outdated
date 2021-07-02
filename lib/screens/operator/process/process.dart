import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex_desktop/model_api/cableDetails_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/fgDetail_model.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/models/bundle_print.dart';
import 'package:molex_desktop/screens/utils/showBundleDetail.dart';
import 'package:molex_desktop/screens/widgets/P1AutoCurScheduledetail.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';

import '../location.dart';
import '../materialPick.dart';
import '100complete.dart';
import 'generateLabel.dart';
import 'partiallyComplete.dart';


class ProcessPage extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Schedule schedule;
  MatTrkPostDetail matTrkPostDetail;
  ProcessPage(
      {required this.machine, required this.employee, required this.schedule, required this.matTrkPostDetail});
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        automaticallyImplyLeading: false,
        title: Text(
          '${widget.machine.category}',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
        elevation: 0,
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
                      return Colors.green.shade500; // Use the component's default.
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
                            style: TextStyle(fontSize: 13, color: Colors.black),
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
                            style: TextStyle(fontSize: 13, color: Colors.black),
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Detail(
                schedule: widget.schedule,
                employee :widget.employee,
                machine: widget.machine,
                matTrkPostDetail: widget.matTrkPostDetail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Detail extends StatefulWidget {
  Schedule schedule;
  String ? rightside;
  Employee employee;
  MachineDetails machine;
  MatTrkPostDetail matTrkPostDetail;
  Detail(
      {required this.schedule,
      this.rightside,
      required this.machine,
      required this.employee,
      required this.matTrkPostDetail});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String ? _chosenValue;
  String ? value;
  String ? output = '';
  String ? _output = '';
  TextEditingController _qtyController = new TextEditingController();
  List<BundlePrint> bundlePrint = [];
  static const platform = const MethodChannel('com.impereal.dev/tsc');
  String ? _printerStatus = 'Waiting';
  bool orderDetailExpanded = true;
  String ? rightside = 'label';
  late ApiService apiService;
  String ? method = 'a-b-c';
  late List<String ?> items;
  @override
  void initState() {
    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);

    items = widget.machine.category!.contains("Cutting")
        ? <String ?>['Cutlength & both side stripping']
        : <String ?>[
            'Crimp-From,Cutlength,Crimp-To',
            'Crimp-From,Cutlength',
            'Cutlength,Crimp-To',
            'Cutlength & both side stripping',
          ];
    super.initState();
  }

  void continueProcess(String ? name) {
    setState(() {
      rightside = name;
    });
  }

  void reload(MatTrkPostDetail matTrkPostDetail) {
    setState(() {
      widget.matTrkPostDetail = matTrkPostDetail;
    });
  }

  void reloadlabel() {
    setState(() {
      widget.matTrkPostDetail = widget.matTrkPostDetail;
    });
  }

  Future<void> _print({
    String ? ipaddress,
    String ? bq,
    String ? qr,
    String ? routenumber1,
    String ? fgPartNumber,
    String ? cutlength,
    String ? cablepart,
    String ? wireGauge,
    String ? terminalfrom,
    String ? terminalto,
  }) async {
    String ? printerStatus;

    try {
      final String ? result = await platform.invokeMethod('Print', {
        "ipaddress": ipaddress,
        "bundleQty": bq,
        "qr": qr,
        "routenumber1": routenumber1,
        "fgPartNumber": fgPartNumber,
        "cutlength": cutlength,
        "cutpart": cablepart,
        "wireGauge": wireGauge,
        "terminalfrom": terminalfrom,
        "terminalto": terminalto,
      });
      printerStatus = 'Printer status : $result % .';
    } on PlatformException catch (e) {
      printerStatus = "Failed to get printer: '${e.message}'.";
    }
    
         Fluttertoast.showToast(
        msg: "$printerStatus",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      _printerStatus = printerStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          P1ScheduleDetailWIP(schedule: widget.schedule),

          // terminal(),
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
                // P1ProcessDetail(cablePartNo: widget.schedule.cablePartNumber,fgpartNo: widget.schedule.finishedGoodsNumber),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    materialtable(),
                    // Process(
                    //   type: _chosenValue,
                    //   schedule: widget.schedule,
                    //   machine: widget.machine,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 350,
                        height: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //100% complete
                                Container(
                                  width: 330,
                                  child: Row(
                                    mainAxisAlignment: rightside == "partial"
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.spaceBetween,
                                    children: [
                                      //100% complete
                                      rightside != "complete"
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
                                                    rightside = 'complete';
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
                                      //partially complete
                                      rightside != 'partial'
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
                                                    rightside = "partial";
                                                  });
                                                },
                                                child: Text(
                                                  "Partially  Complete",
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
                                      //Transfer
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
                                                    return Colors.blue.shade200;
                                                  return Colors.blue; // Use the component's default.
                                                },
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.blue;
                                                  return Colors.blue; // Use the component's default.
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
                                                          locationType:
                                                              LocationType
                                                                  .partialTransfer,
                                                          type: "process",
                                                          employee: widget.employee,
                                                          machine:
                                                              widget.machine,
                                                        )),
                                              );
                                            }),
                                      ),

                                      //Reload material
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
                                                        MaterialPick(
                                                          schedule:
                                                              widget.schedule,
                                                          employee: widget.employee,
                                                          reload: reload,
                                                          machine:
                                                              widget.machine,
                                                          materialPickType:
                                                              MaterialPickType
                                                                  .reload,
                                                        )),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                //Relaod Material
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]);
            } else {
              return Container();
            }
          }()),
          (() {
            if (_chosenValue != null) {
              return Container(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: (() {
                              if (rightside == null) {
                                return Container();
                              } else if (rightside == "label") {
                                return GenerateLabel(
                                  reload: reloadlabel,
                                  schedule: widget.schedule,
                                  machine: widget.machine,
                                  userId: widget.employee.empId,
                                  method: method,
                                );
                              } else if (rightside == "complete") {
                                if (widget.machine.category ==
                                        "Manual Cutting" ||
                                    widget.schedule.process == "Cutting") {
                                  return FullyComplete(
                                    employee: widget.employee,
                                    machine: widget.machine,
                                    schedule: widget.schedule,
                                       continueProcess: continueProcess,
                                  );
                                } else {
                                  print("pushed");
                                  Future.delayed(Duration.zero, () {
                                    FullyCompleteModel fullyComplete =
                                        FullyCompleteModel(
                                      finishedGoodsNumber: int ?.parse(
                                          widget.schedule.finishedGoodsNumber??'0'),
                                      purchaseOrder:
                                          int ?.parse(widget.schedule.orderId??'0'),
                                      orderId:
                                          int ?.parse(widget.schedule.orderId??'0'),
                                      cablePartNumber: int ?.parse(
                                          widget.schedule.cablePartNumber??'0'),
                                      length: int ?.parse(widget.schedule.length??'0'),
                                      color: widget.schedule.color,
                                      scheduledStatus: "Complete",
                                      scheduledId: int ?.parse(
                                          widget.schedule.scheduledId??'0'),
                                      scheduledQuantity: int ?.parse(
                                          widget.schedule.scheduledQuantity??'0'),
                                      machineIdentification:
                                          widget.machine.machineNumber,
                                      //TODO bundle ID
                                    );
                                    apiService
                                        .post100Complete(fullyComplete)
                                        .then((value) {
                                      if (value) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Location(
                                                    type: "process",
                                                    employee: widget.employee,
                                                    machine: widget.machine, locationType: LocationType.finaTtransfer,
                                                  )),
                                        );
                                      } else {}
                                    });
                                  });
                                }
                              } else if (rightside == "partial") {
                                return PartiallyComplete(
                                    employee :widget.employee,
                                    machine: widget.machine,
                                    continueProcess: continueProcess,
                                    schedule: widget.schedule);
                              } else if (rightside == "bundle") {
                                return bundleTable();
                              } else {
                                return Container();
                              }
                            }()),
                          ),
                        ),
                      ],
                    ),
                    //buttons
                    // Table for bundles generated
                  ],
                ),
              );
            } else {
              return Container();
            }
          }())
        ],
      ),
    );
  }

  //Bundle table
  Widget bundleTable() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return DataTable(
        columnSpacing: 40,
        columns: const <DataColumn>[
          DataColumn(
            label: Text('No.'),
          ),
          DataColumn(
            label: Text('Bundle Id'),
          ),
          DataColumn(
            label: Text('Bundel Qty'),
          ),
          DataColumn(
            label: Text('Action'),
          ),
        ],
        rows: bundlePrint
            .map((e) => DataRow(cells: <DataCell>[
                  DataCell(Text("1")),
                  DataCell(Text(e.bundelId??"")),
                  DataCell(Text(e.bundleQty??'')),
                  DataCell(ElevatedButton(
                    onPressed: () {
                      _print();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.red))),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.redAccent;
                          return Colors.red; // Use the component's default.
                        },
                      ),
                    ),
                    child: Text(
                      "Print",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ))
                ]))
            .toList());
  }

  Future<void> _showConfirmationDialog() async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Transfer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Status ${_printerStatus}')],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Future.delayed(
                    const Duration(milliseconds: 50),
                    () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                  );
                },
                child: Text('Cancel Transfer')),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green),
                ),
                onPressed: () {},
                child: Text('Confirm Transfer')),
          ],
        );
      },
    );
  }

  //Material Sheet for qty

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
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FutureBuilder(
                          future: apiService.getCableTerminalA(
                              fgpartNo: widget.schedule.finishedGoodsNumber,
                              cablepartno: widget.schedule.cablePartNumber ??
                                  widget.schedule.finishedGoodsNumber,
                              length: widget.schedule.length,
                              color: widget.schedule.color,
                              awg: widget.schedule.awg),
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
                                  0.35);
                            } else {
                              return process(
                                  'From Process',
                                  '',
                                  'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                                  '(-)()(-)(-)(-)',
                                  '',
                                  0.325);
                            }
                          }),
                    ),
                  )
                : Container(),
            method!.contains('c')
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FutureBuilder(
                        future: apiService.getCableDetails(
                            fgpartNo: widget.schedule.finishedGoodsNumber,
                            cablepartno: widget.schedule.cablePartNumber ?? "0",
                            length: widget.schedule.length,
                            color: widget.schedule.color,
                            awg: widget.schedule.awg),
                        builder: (context, snapshot) {
                          CableDetails cableDetail = snapshot.data as CableDetails;
                          if (snapshot.hasData) {
                            return process(
                                'Cable',
                                'Cut Length Spec(mm) -${cableDetail.cutLengthSpec}',
                                'Cable Part Number(Description)',
                                '${cableDetail.cablePartNumber}(${cableDetail.description})',
                                'From Strip Length Spec(mm) ${cableDetail.stripLengthFrom} \n To Strip Length Spec(mm) ${cableDetail.stripLengthTo}',
                                0.28);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  )
                : Container(),
            method!.contains("b")
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FutureBuilder(
                        future: apiService.getCableTerminalB(
                            fgpartNo: widget.schedule.finishedGoodsNumber,
                            cablepartno: widget.schedule.cablePartNumber ??
                                widget.schedule.finishedGoodsNumber,
                            length: widget.schedule.length,
                            color: widget.schedule.color,
                            awg: widget.schedule.awg),
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
                                '',
                                0.325);
                          }
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  // "localhost:9090//molex/scheduler/get-req-material-detail?machId=EMU-m/c-006C&fgNo=367680784&schdId=1223445
  //       localhost:9090//molex/scheduler/get-req-material-detail-from?machId=EMU-m/c-006C&fgNo=367680784&schdId=1223445
  //       localhost:9090//molex/scheduler/get-req-material-detail-to?machId=EMU-m/c-006C&fgNo=367680784&schdId=1223445"

  Widget process(
      String ? p1, String ? p2, String ? p3, String ? p4, String ? p5, double ? width) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        // height: 91,
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
                              fontFamily: ''),
                        ),
                        SizedBox(width: 20),
                        Text(
                          p2!,
                          style: TextStyle(fontSize: 11, fontFamily: ''),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
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
                          fontFamily: '',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      p5!,
                      style: TextStyle(fontSize: 11, fontFamily: ''),
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

  Widget quantitycell(String ? title, int ? quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25 * 0.6,
              child: Text(title!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  )),
            ),
            Container(
              height: 20,
              width: 60,
              child: TextField(
                readOnly: true,
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: "Qty",
                  labelStyle: TextStyle(fontSize: 10),
                  fillColor: Colors.white,

                  //fillColor: Colors.green
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeading() {
    double ? width = MediaQuery.of(context).size.width;
    Widget cell(String ? name, double ? d) {
      return Container(
        color: Colors.white,
        width: width * d!,
        height: 15,
        child: Center(
          child: Text(
            name!,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      height: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cell("Order Id", 0.1),
              cell("FG Part", 0.1),
              cell("Schedule ID", 0.1),
              cell("Cable Part No.", 0.1),
              cell("Process", 0.1),
              cell("Cut Length(mm)", 0.1),
              cell("Color", 0.1),
              cell("Scheduled Qty", 0.1),
              cell("Schedule", 0.1)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDataRow({required Schedule schedule, int ? c}) {
    double ? width = MediaQuery.of(context).size.width;

    Widget cell(String ? name, double ? d) {
      return Container(
        width: width * d!,
        child: Center(
          child: Text(
            name!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      color: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
            color: schedule.scheduledStatus == "Complete"
                ? Colors.green
                : schedule.scheduledStatus == "Pending"
                    ? Colors.red
                    : Colors.green,
            width: 5,
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // orderId
            cell(schedule.orderId, 0.1),
            //Fg Part
            cell(schedule.finishedGoodsNumber, 0.1),
            //Schudule ID
            cell(schedule.scheduledId, 0.1),

            //Cable Part
            cell(schedule.cablePartNumber, 0.1),
            //Process
            cell(schedule.process, 0.1),
            // Cut length
            cell(schedule.length, 0.1),
            //Color
            cell(schedule.color, 0.1),
            //Scheduled Qty
            cell(schedule.scheduledQuantity, 0.1),
            //Schudule
            Container(
              width: width * 0.1,
              child: Center(
                child: Text(
                  "11:00 - 12:00",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fgDetails() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
          future: apiService.getFgDetails(widget.schedule.finishedGoodsNumber),
          builder: (context, snapshot) {
            print('fg number ${widget.schedule.finishedGoodsNumber}');
            if (snapshot.hasData) {
              FgDetails fgDetail = snapshot.data as FgDetails;
              return Container(
                decoration: BoxDecoration(),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          boxes("FG Description", fgDetail.fgDescription ?? ''),
                          boxes("FG Scheduled", fgDetail.fgScheduleDate ?? ''),
                          boxes("Customer", fgDetail.customer ?? ''),
                          boxes("Drg Rev", fgDetail.drgRev ?? ''),
                          boxes("Cable #", "${fgDetail.cableSerialNo ?? ''}"),
                          boxes('Tolerance ',
                              '± ${fgDetail.tolrance} / ±${fgDetail.tolrance}'),
                        ])),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget boxes(
    String ? str1,
    String ? str2,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            str1!,
            style: TextStyle(fontSize: 10),
          ),
          Text(str2!,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.black)),
        ]),
      ),
    );
  }

  //tearmial A b and cable
  Widget startProcess() {
    if (_chosenValue == null) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          child: Row(
            children: [
              DropdownButton<String ?>(
                dropdownColor: Colors.white,
                focusColor: Colors.white,
                value: _chosenValue,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,

                items: items.map<DropdownMenuItem<String ?>>((String ? value) {
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
                    if (value == "Crimp-From,Cutlength,Crimp-To") {
                      method = 'a-b-c';
                    }
                    if (value == "Crimp-From,Cutlength") {
                      method = 'a-c';
                    }
                    if (value == "Cutlength,Crimp-To") {
                      method = 'b-c';
                    }
                    if (value == "Cutlength & both side stripping") {
                      method = 'c';
                    }
                    if (value == "CRIMP-FROM") {
                      method = 'a';
                    }
                    if (value == "CRIMP-TO") {
                      method = 'b';
                    }
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
            if (matList.length > 0) {
              return Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: Column(children: [
                        row('Part No.', 'UOM', 'REQUIRED', 'LOADED',
                            'AVAILABLE', Colors.blue.shade100),
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
                        // row('884538504', 'uom', '5000m', '1000m', '1000m', '2500m',
                        //     Colors.grey.shade100),
                        // row('884538504', 'uom', '5000m', '1000m', '1000m', '2500m',
                        //     Colors.grey.shade100),
                        // row('884538504', 'uom', '5000m', '1000m', '1000m', '2500m',
                        //     Colors.grey.shade100),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.blue.shade200;
                                    return Colors.blue; // Use the component's default.
                                  },
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.blue;
                                    return Colors.blue; // Use the component's default.
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
                      SizedBox(height: 10),
                      Text(
                        "no stock found",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ));
            }
          } else {
            return Container(
                width: MediaQuery.of(context).size.width * 0.48,
                child: Column(
                  children: [
                    row('Part No.', 'UOM', 'REQUIRED', 'LOADED', 'AVAILABLE',
                        Colors.blue.shade100),
                    Text(
                      "no stock found",
                      style: TextStyle(color: Colors.black),
                    )
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/crimping/bundleDetail.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/crimping/postCrimprejectedDetail.dart';
import 'package:molex_desktop/models/bundle_scan.dart';
import 'package:molex_desktop/service/apiService.dart';

enum Status {
  scan,
  rejection,
  showbundle,
  scanBin,
  bundleDetail,
}

class ScanBundle extends StatefulWidget {
  int ? length;
  String ? userId;
  String ? machineId;
  String ? method;
  @required
  CrimpingSchedule schedule;
  ScanBundle(
      {this.length, this.machineId, this.method, this.userId, required this.schedule});
  @override
  _ScanBundleState createState() => _ScanBundleState();
}

class _ScanBundleState extends State<ScanBundle> {
  TextEditingController mainController = new TextEditingController();
  TextEditingController endTerminalController = new TextEditingController();
  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController =
      new TextEditingController();
  TextEditingController bellMouthLessController = new TextEditingController();
  TextEditingController bellMouthMoreController = new TextEditingController();
  TextEditingController cutoffBurrController = new TextEditingController();
  TextEditingController exposureStrands = new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessController = new TextEditingController();
  TextEditingController brushLengthMoreController1 =
      new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();
  TextEditingController setUpRejectionController = new TextEditingController();
  TextEditingController lockingTabOpenController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();
  TextEditingController copperMarkController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();
  //Quantity
  TextEditingController rejectedQtyController = new TextEditingController();
  TextEditingController bundlQtyController = new TextEditingController();
  FocusNode _scanfocus = new FocusNode();
  TextEditingController _scanIdController = new TextEditingController();
  bool next = false;
  bool showTable = false;
  List<BundleScan> bundleScan = [];
  Status status = Status.scan;

  String ? _output = '';

  TextEditingController _binController = new TextEditingController();

  late bool hasBin;
  bool loading = false;

  String ? binId;
  //to store the bundle Quantity fetched from api after scanning bundle Id
  String ? bundleQty = '';
  ApiService apiService = new ApiService();
  late CableTerminalA terminalA;
  late CableTerminalB terminalB;
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: "${widget.schedule.finishedGoods}",
            cablepartno: widget.schedule.cablePartNo.toString(),
            length: "${widget.schedule.length}",
            color: widget.schedule.wireColour,
            awg: int ?.parse(widget.schedule.awg ?? '0'))
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: "${widget.schedule.finishedGoods}",
              cablepartno: widget.schedule.cablePartNo.toString(),
              length: "${widget.schedule.length}",
              color: widget.schedule.wireColour,
              awg: int ?.parse(widget.schedule.awg ?? '0'))
          .then((termiB) {
        setState(() {
          terminalA = termiA!;
          terminalB = termiB!;
        });
      });
    });
  }

  @override
  void initState() {
    status = Status.scan;
    apiService = new ApiService();
    getTerminal();
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Row(
      children: [
        main(status),
        keypad(mainController),
      ],
    );
  }

  Widget main(Status status) {
    switch (status) {
      case Status.scan:
        return scanBundlePop();
        break;

      case Status.rejection:
        return rejectioncase();
      case Status.scanBin:
        return binScan();
      default:
        return Container();
    }
  }

  Widget keypad(TextEditingController controller) {
    // print('NickMark ${windowGapController.text}');
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // print('End wire ${endWireController.text}');
    buttonPressed(String ? buttonText) {
      setState(() {
        rejectedQtyController.text = total().toString();
      });
      if (buttonText == 'X') {
        _output = '';
      } else {
        _output = (_output! + buttonText!);
      }

      print(_output);
      setState(() {
        controller.text = _output!;
        setState(() {
          rejectedQtyController.text = total().toString();
        });
        // output = int ?.parse(_output).toStringAsFixed(2);
      });
    }

    Widget buildbutton(String ? buttonText) {
      return new Expanded(
          child: Container(
        decoration: new BoxDecoration(),
        width: 27,
        height: 50,
        child: new ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.grey.shade50))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.grey.shade100;

                return Colors.white; // Use the component's default.
              },
            ),
          ),
          child: buttonText == 'X'
              ? Container(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.red.shade400,
                    ),
                    onPressed: () => {buttonPressed(buttonText)},
                  ))
              : new Text(
                  buttonText!,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: buttonText == "X" ? Colors.red : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ),
          onPressed: () => {buttonPressed(buttonText)},
        ),
      ));
    }

    return Material(
      elevation: 2,
      shadowColor: Colors.grey.shade200,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.red.withOpacity(0.1),
          //     spreadRadius: 2,
          //     blurRadius: 2,
          //     offset: Offset(0, 0), // changes position of shadow
          //   ),
          // ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                buildbutton("7"),
                buildbutton('8'),
                buildbutton('9'),
              ],
            ),
            Row(
              children: [
                buildbutton('4'),
                buildbutton('5'),
                buildbutton('6'),
              ],
            ),
            Row(
              children: [
                buildbutton('1'),
                buildbutton('2'),
                buildbutton('3'),
              ],
            ),
            Row(
              children: [
                buildbutton('00'),
                buildbutton('0'),
                buildbutton('X'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bundleDetail() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: FutureBuilder(
          future: apiService.getBundleDetail(_scanIdController.text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              BundleData? bundleDetail = snapshot.data as BundleData;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Bundle Detail'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Bundle Id :  '),
                        Text('${bundleDetail.bundleIdentification}',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget scanedTable() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (showTable) {
      return Container(
        height: 250,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                  columnSpacing: 30,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('S No.'),
                    ),
                    DataColumn(
                      label: Text('Bundle ID'),
                    ),
                    DataColumn(
                      label: Text('Bundle Qty'),
                    ),
                    DataColumn(
                      label: Text('Process Qty'),
                    ),
                    DataColumn(
                      label: Text('Remove'),
                    ),
                  ],
                  rows: bundleScan
                      .map((e) => DataRow(cells: <DataCell>[
                            DataCell(Text("1")),
                            DataCell(Text(
                              e.bundleId??'',
                            )),
                            DataCell(Text(
                              e.bundleQty??'',
                            )),
                            DataCell(Text(
                              e.bundleProcessQty??'',
                            )),
                            DataCell(IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  bundleScan.remove(e);
                                });
                              },
                            )),
                          ]))
                      .toList()),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget scanBundlePop() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 100,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 200,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        controller: _scanIdController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        autofocus: true,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(fontSize: 14),
                        decoration: new InputDecoration(
                          suffix: _scanIdController.text.length > 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _scanIdController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red)),
                                )
                              : Container(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3),
                          labelText: "Scan Bundle",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.red))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.red.shade900;
                                    return Colors
                                        .red; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                if (_scanIdController.text.length > 0) {
                                  apiService
                                      .getBundleDetail(_scanIdController.text)
                                      .then((value) {
                                    BundleData bundleDetail = value!;
                                    // ignore: unnecessary_null_comparison
                                    if (value != null) {
                                      // if ("${bundleDetail.finishedGoodsPart}" ==
                                      //         "${widget.schedule.finishedGoods}" &&
                                      //     "${bundleDetail.cablePartNumber}" ==
                                      //         "${widget.schedule.cablePartNo}" &&
                                      //     "${bundleDetail.cutLengthSpecificationInmm}" ==
                                      //         "${widget.schedule.length}" &&
                                      //     "${bundleDetail.color}" ==
                                      //         "${widget.schedule.wireColour}" &&
                                      //     "${bundleDetail.orderId}" ==
                                      //         "${widget.schedule.purchaseOrder}") {
                                      if (true) {
                                        setState(() {
                                          clear();
                                          bundleQty =
                                              "${bundleDetail.bundleQuantity}";
                                          bundlQtyController.text =
                                              "${bundleDetail.bundleQuantity}";
                                          next = !next;
                                          status = Status.rejection;
                                        });
                                      } else {
                                        
                                             Fluttertoast.showToast(
        msg:
                                                "Bundle does not match FG Detials",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    } else {
                                      
                                           Fluttertoast.showToast(
        msg: "Bundle Not Found",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                } else {
                                  
                                       Fluttertoast.showToast(
        msg: "Scan Bundle to proceed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text('Scan Bundle  ')),
                        ),

                        // ElevatedButton(
                        //     style: ButtonStyle(
                        //       backgroundColor: MaterialStateProperty.resolveWith(
                        //           (states) => Colors.green),
                        //     ),
                        //     onPressed: () {
                        //       setState(() {
                        //         showTable = !showTable;
                        //       });
                        //     },
                        //     child: Text("${bundleScan.length}")),
                      ],
                    ),
                  ),
                ],
              )),
          scanedTable(),
        ],
      ),
    );
  }

  handleKey(RawKeyEventData key) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget rejectioncase() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.88,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Crimping Rejection Cases',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            )),
                        Text('Bundle Id : ${_scanIdController.text}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          quantitycell(
                            name: "End Termianl	",
                            textEditingController: endTerminalController,
                          ),
                          quantitycell(
                            name: "Terminal Damage",
                            textEditingController: terminalDamageController,
                          ),
                          quantitycell(
                            name: "Terminal Bend",
                            textEditingController: terminalBendController,
                          ),
                          quantitycell(
                            name: "Terminal Twist",
                            textEditingController: terminalTwistController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Window Gap",
                            textEditingController: windowGapController,
                          ),
                          quantitycell(
                            name: "Crimp On Insulation",
                            textEditingController: crimpOnInsulationController,
                          ),
                          quantitycell(
                            name: "Bellmouth less",
                            textEditingController: bellMouthLessController,
                          ),
                          quantitycell(
                            name: "Bellmouth More",
                            textEditingController: bellMouthMoreController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Cutt oFf Burr",
                            textEditingController: cutoffBurrController,
                          ),
                          quantitycell(
                            name: "Exposure Strands",
                            textEditingController: exposureStrands,
                          ),
                          quantitycell(
                            name: "Nick Mark",
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "Strands Cut",
                            textEditingController: strandsCutController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Brush Length Less",
                            textEditingController: brushLengthLessController,
                          ),
                          quantitycell(
                            name: "Brush Length More",
                            textEditingController: brushLengthMoreController1,
                          ),
                          quantitycell(
                              name: "Cable Damage",
                              textEditingController: cableDamageController),
                          quantitycell(
                            name: "Half Curling	",
                            textEditingController: halfCurlingController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Setup Rejections	",
                            textEditingController: setUpRejectionController,
                          ),
                          quantitycell(
                            name: "Locking Tab Open/Close	",
                            textEditingController: lockingTabOpenController,
                          ),
                          quantitycell(
                            name: "Wrong Terminal	",
                            textEditingController: wrongTerminalController,
                          ),
                          quantitycell(
                            name: "Copper Mark	",
                            textEditingController: copperMarkController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Seam Open",
                            textEditingController: seamOpenController,
                          ),
                          quantitycell(
                            name: "Miss Crimp",
                            textEditingController: missCrimpController,
                          ),
                          quantitycell(
                            name: "Extrusion Burr",
                            textEditingController: extrusionBurrController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    Text("Bundle Qty:   "),
                    Text(
                      bundlQtyController.text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ]),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Text("Rejected Qty:   "),
                      Text(
                        rejectedQtyController.text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  // quantitycell(
                  //   name: "Bundle Qty",
                  //
                  //   textEditingController: bundlQtyController,
                  // ),
                  // quantitycell(
                  //   name: "Rejected Qty",
                  //
                  //   textEditingController: rejectedQtyController,
                  // ),
                  // binScan(),
                  SizedBox(width: 30),
                  Container(
                    height: 48,
                    child: Center(
                      child: Container(
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side:
                                              BorderSide(color: Colors.green))),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.white;
                                      return Colors
                                          .white; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  Future.delayed(
                                    const Duration(milliseconds: 50),
                                    () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    },
                                  );
                                  setState(() {
                                    status = Status.scan;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.keyboard_arrow_left,
                                        color: Colors.green),
                                    Text(
                                      "Back",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                )),
                            SizedBox(width: 10),
                            ElevatedButton(
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
                                      return Colors.green.shade200;
                                    return Colors.green; // Use the component's default.
                                  },
                                ),
                              ),
                              child: loading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text("Save & Scan Next"),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  },
                                );
                                PostCrimpingRejectedDetail
                                    postCrimpingRejectedDetail =
                                    PostCrimpingRejectedDetail(
                                  bundleIdentification: _scanIdController.text,
                                  finishedGoods: widget.schedule.finishedGoods,
                                  cutLength: widget.schedule.length,
                                  color: widget.schedule.wireColour,
                                  cablePartNumber: widget.schedule.cablePartNo,
                                  processType: widget.schedule.process,
                                  method: "${widget.method}",
                                  status: "",
                                  machineIdentification: widget.machineId,
                                  binId: "",
                                  bundleQuantity: int ?.parse(bundleQty ?? '0'),
                                  passedQuantity:
                                      int ?.parse(bundleQty ?? '0') - total(),
                                  rejectedQuantity: total(),
                                  crimpInslation: int ?.parse(
                                      crimpOnInsulationController.text.length >
                                              0
                                          ? crimpOnInsulationController.text
                                          : "0"),
                                  burrOrCutOff: int ?.parse(
                                      cutoffBurrController.text.length > 0
                                          ? cutoffBurrController.text
                                          : '0'),
                                  terminalBendOrClosedOrDamage: int ?.parse(
                                      terminalBendController.text.length > 0
                                          ? terminalBendController.text
                                          : '0'),
                                  missCrimp: int ?.parse(
                                      missCrimpController.text.length > 0
                                          ? missCrimpController.text
                                          : '0'),
                                  terminalTwist: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  insulationSlug: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'), //TODO check if both are same
                                  windowGap: int ?.parse(
                                      windowGapController.text.length > 0
                                          ? windowGapController.text
                                          : '0'),
                                  exposedStrands: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  nickMarkOrStrandsCut: int ?.parse(
                                      "0"), //TODO check nick mark in Qty
                                  brushLength: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  seamOpen: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),

                                  frontBellMouth: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  backBellMouth: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  extrusionOnBurr: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),
                                  cableDamage: int ?.parse(
                                      terminalTwistController.text.length > 0
                                          ? terminalTwistController.text
                                          : '0'),

                                  orderId: widget.schedule.purchaseOrder,
                                  fgPart: widget.schedule.finishedGoods,
                                  scheduleId: widget.schedule.scheduleId,
                                  awg: widget.schedule.awg != null
                                      ? widget.schedule.awg.toString()
                                      : null,
                                  terminalFrom: int ?.parse(
                                      '${terminalA.terminalPart ?? '0'}'),
                                  terminalTo: int ?.parse(
                                      '${terminalB.terminalPart ?? '0'}'),
                                );

                                apiService
                                    .postCrimpRejectedQty(
                                        postCrimpingRejectedDetail)
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      loading = false;
                                    });
                                    setState(() {
                                      bundleScan.add(BundleScan(
                                          bundleId: _scanIdController.text,
                                          bundleQty: "$bundleQty"));

                                      Future.delayed(
                                          const Duration(milliseconds: 10), () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                      });
                                      status = Status.scanBin;
                                    });

                                    
                                       Fluttertoast.showToast(
        msg: "Saved Crimping Detail ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    Future.delayed(Duration(seconds: 5))
                                        .then((value) => 
                                               Fluttertoast.showToast(
        msg:
                                                  " Save Crimping Reject detail failed ",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            ));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int total() {
    log("brush :${brushLengthMoreController1.text}");
    int ? total = int ?.parse(endTerminalController.text.length > 0 ? endTerminalController.text : '0') +
        int ?.parse(terminalDamageController.text.length > 0
            ? terminalDamageController.text
            : '0') +
        int ?.parse(terminalBendController.text.length > 0
            ? terminalBendController.text
            : '0') +
        int ?.parse(terminalTwistController.text.length > 0
            ? terminalTwistController.text
            : '0') +
        int ?.parse(windowGapController.text.length > 0
            ? windowGapController.text
            : '0') +
        int ?.parse(crimpOnInsulationController.text.length > 0
            ? crimpOnInsulationController.text
            : '0') +
            
        int ?.parse(bellMouthLessController.text.length > 0
            ? bellMouthLessController.text
            : '0') +
              int ?.parse(bellMouthMoreController.text.length > 0
            ? bellMouthMoreController.text
            : '0') +
        int ?.parse(cutoffBurrController.text.length > 0
            ? cutoffBurrController.text
            : '0') +
        int ?.parse(
            exposureStrands.text.length > 0 ? exposureStrands.text : '0') +
        int ?.parse(nickMarkController.text.length > 0
            ? nickMarkController.text
            : '0') +
        int ?.parse(strandsCutController.text.length > 0
            ? strandsCutController.text
            : '0') +
        int ?.parse(brushLengthLessController.text.length > 0
            ? brushLengthLessController.text
            : '0') +
              int ?.parse(wrongTerminalController.text.length > 0
            ? wrongTerminalController.text
            : '0') +
        int ?.parse(
            brushLengthMoreController1.text.length > 0 ? brushLengthMoreController1.text : '0') +
        int ?.parse(cableDamageController.text.length > 0 ? cableDamageController.text : '0') +
        int ?.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int ?.parse(setUpRejectionController.text.length > 0 ? setUpRejectionController.text : '0') +
        int ?.parse(lockingTabOpenController.text.length > 0 ? lockingTabOpenController.text : '0') +
        int ?.parse(copperMarkController.text.length > 0 ? copperMarkController.text : '0') +
        int ?.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int ?.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int ?.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    //TODO nickMark
    return total;
  }

  Widget quantitycell(
      {String ? name,
      required TextEditingController textEditingController,
      FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 33,
                width: 140,
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onTap: () {
                    setState(() {
                      _output = '';
                      mainController = textEditingController;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  decoration: new InputDecoration(
                    labelText: name,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantity(String ? title, int ? quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.25 * 0.4,
            //   child: Text(title,
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 15,
            //       )),
            // ),
            Container(
              height: 35,
              width: 130,
              child: TextField(
                style: TextStyle(fontSize: 12),
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: title,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 15),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),

                //fillColor: Colors.green
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clear() {
    endTerminalController.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMouthLessController.clear();
    bellMouthMoreController.clear();
    cutoffBurrController.clear();
    exposureStrands.clear();
    nickMarkController.clear();
    strandsCutController.clear();
    brushLengthLessController.clear();
    brushLengthMoreController1.clear();
    cableDamageController.clear();
    halfCurlingController.clear();
    setUpRejectionController.clear();
    lockingTabOpenController.clear();
    wrongTerminalController.clear();
    wrongTerminalController.clear();
    copperMarkController.clear();
    seamOpenController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
    bundlQtyController.clear();
    rejectedQtyController.clear();
  }

  Widget binScan() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Container(
            width: 270,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) => handleKey(event.data),
                child: TextField(
                    controller: _binController,
                    onSubmitted: (value) {
                      hasBin = true;

                      // _bundleFocus.requestFocus();
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                      );
                    },
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    onChanged: (value) {
                      setState(() {
                        binId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _binController.text.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _binController.clear();
                                  });
                                },
                                child: Icon(Icons.clear,
                                    size: 18, color: Colors.red))
                            : Container(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        labelText: '    Scan bin    ',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          // Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: Colors.red))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red.shade200;
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '  Back   ',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          status = Status.rejection;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors
                                .red.shade400; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Scan Bin',
                        ),
                      ),
                      onPressed: () {
                        TransferBundleToBin bundleToBin = TransferBundleToBin(
                            userId: widget.userId ??'',
                            binIdentification: binId,
                            bundleId: _scanIdController.text);
                        apiService.postTransferBundletoBin(
                            transferBundleToBin: [bundleToBin]).then((value) {
                          if (value != null) {
                            BundleTransferToBin bundleTransferToBinTracking =
                                value[0];
                            
                                 Fluttertoast.showToast(
        msg:
                                    "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            
                               Fluttertoast.showToast(
        msg: "Unable to transfer Bundle to Bin",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        });
                        setState(() {
                          clear();
                          _scanIdController.clear();
                          binId = '';
                          bundlQtyController.clear();
                          status = Status.scan;
                        });
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

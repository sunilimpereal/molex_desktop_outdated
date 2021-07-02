import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/generateLabel_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/transferBundle_model.dart';
import 'package:molex_desktop/service/apiService.dart';

enum Status {
  quantity,
  generateLabel,
  scanBundle,
  scanBin,
}

class GenerateLabel extends StatefulWidget {
  Schedule schedule;
  MachineDetails machine;
  String ? userId;
  String ? method;
  Function reload;
  GenerateLabel(
      {required this.machine, required this.schedule, this.userId, this.method, required this.reload});
  @override
  _GenerateLabelState createState() => _GenerateLabelState();
}

class _GenerateLabelState extends State<GenerateLabel> {
  // Text Editing Controller for all rejection cases
  TextEditingController maincontroller = new TextEditingController();
  TextEditingController _bundleScanController = new TextEditingController();
  TextEditingController _binController = new TextEditingController();
  TextEditingController bundleQty = new TextEditingController();

  // All Quantity Contolle
  TextEditingController endWireController = new TextEditingController();
  TextEditingController bladeMarkController = new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController lengthvariationController = new TextEditingController();
  TextEditingController rollerMarkController = new TextEditingController();
  TextEditingController stripLengthVariationController =
      new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();
  TextEditingController endTerminalController = new TextEditingController();
  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController =
      new TextEditingController();
  TextEditingController bellMouthLessController = new TextEditingController();
  TextEditingController bellMouthMoreController = new TextEditingController();
  TextEditingController cutoffBarController = new TextEditingController();
  TextEditingController exposureStrandsController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessController = new TextEditingController();
  TextEditingController brushLEngthMoreController = new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();
  TextEditingController setupRejectionsController = new TextEditingController();
  TextEditingController cvmRejectionsController = new TextEditingController();
  TextEditingController cfmRejectionsController = new TextEditingController();
  TextEditingController copperMarkController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();
  TextEditingController wrongcableController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController wrongCutLengthController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();

  /// Main Content
  FocusNode keyboardFocus = new FocusNode();

  bool labelGenerated = false;
  String ? _output = '';
  String ? binState;
  String ? binId;
  String ? bundleId;
  bool hasBin = false;
  Status status = Status.quantity;
  TransferBundle transferBundle = new TransferBundle();
  late PostGenerateLabel postGenerateLabel;
  static const platform = const MethodChannel('com.impereal.dev/tsc');
  String ? _printerStatus = 'Waiting';
  List<GeneratedBundle> generatedBundleList = [];
  bool showtable = false;
  bool loading = false;

  Future<void> _print({
    String ? ipaddress,
    String ? bq,
    String ? qr,
    String ? routenumber1,
    String ? date,
    String ? orderId,
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
        "date": date,
        "orderId": orderId,
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

  late ApiService apiService;
  late CableTerminalA terminalA;
  late CableTerminalB terminalB;
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: widget.schedule.finishedGoodsNumber,
            cablepartno: widget.schedule.cablePartNumber ??
                widget.schedule.finishedGoodsNumber,
            length: widget.schedule.length,
            color: widget.schedule.color,
            awg: widget.schedule.awg)
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: widget.schedule.finishedGoodsNumber,
              cablepartno: widget.schedule.cablePartNumber ??
                  widget.schedule.finishedGoodsNumber,
              length: widget.schedule.length,
              color: widget.schedule.color,
              awg: widget.schedule.awg)
          .then((termiB) {
        setState(() {
          terminalA = termiA!;
          terminalB = termiB!;
        });
      });
    });
  }

  late GeneratedLabel label;
  @override
  void initState() {
    apiService = new ApiService();
    getTerminal();
    transferBundle = new TransferBundle();
    label = new GeneratedLabel();
    transferBundle.cablePartDescription = widget.schedule.cablePartNumber;
    transferBundle.scheduledQuantity =
        int ?.parse(widget.schedule.scheduledQuantity??'0');
    transferBundle.orderIdentification = int ?.parse(widget.schedule.orderId??'0');
    transferBundle.machineIdentification = widget.machine.machineNumber;
    transferBundle.scheduledId = widget.schedule.scheduledId == ''
        ? 0
        : int ?.parse(widget.schedule.scheduledId??'0');
    binState = "Scan Bin";
    super.initState();
  }

  void clear() {
    endWireController.clear();
    bladeMarkController.clear();
    cableDamageController.clear();
    lengthvariationController.clear();
    rollerMarkController.clear();
    stripLengthVariationController.clear();
    nickMarkController.clear();
    endTerminalController.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMouthLessController..clear();
    bellMouthMoreController.clear();
    cutoffBarController.clear();
    exposureStrandsController.clear();
    strandsCutController.clear();
    brushLEngthMoreController.clear();
    brushLengthLessController.clear();
    halfCurlingController.clear();
    setupRejectionsController.clear();
    cvmRejectionsController.clear();
    cfmRejectionsController.clear();
    copperMarkController.clear();
    wrongTerminalController.clear();
    wrongcableController.clear();
    seamOpenController.clear();
    wrongCutLengthController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: Row(
        children: [
          main(status),
          keypad(maincontroller),
        ],
      ),
    );
  }

  Widget main(Status status) {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    switch (status) {
      case Status.quantity:
        return Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              quantity(),
              showtable ? showBundles() : Container(),
            ],
          ),
        );
        break;
      case Status.generateLabel:
        return widget.machine.category == "Automatic Cut & Crimp"
            ? generateLabelAutoCut()
            : generateLabelMannualCut();
        break;
      case Status.scanBin:
        return binScan();
        break;
      case Status.scanBundle:
        return bundleScan();
      default:
        return Container();
    }
  }

  Widget keypad(TextEditingController controller) {
    print('NickMark ${windowGapController.text}');
    print('End wire ${endWireController.text}');
    buttonPressed(String ? buttonText) {
      if (buttonText == 'X') {
        _output = '';
      } else {
        _output = (_output! + buttonText!);
      }

      print(_output);
      setState(() {
        controller.text = _output!;
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
          child: buttonText == "X"
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
                      color: Colors.black,
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

  Widget quantity() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    maincontroller = bundleQty;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Column(
          children: [
            //Quantity Feild
            Container(
              width: 190,
              height: 50,
              child: TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                controller: bundleQty,
                onEditingComplete: () {
                  setState(() {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                    labelGenerated = !labelGenerated;
                    status = Status.generateLabel;
                  });
                },
                onTap: () {
                  setState(() {
                    _output = '';
                    maincontroller = bundleQty;
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  });
                },
                showCursor: false,
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: 15),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 3),
                  labelText: "  Bundle Qty (SPQ)",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
              ),
            ),
            Container(
              width: 190,
              height: 60,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.135,
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.transparent,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green.shade200;
                                return Colors
                                    .green.shade500; // Use the component's default.
                              },
                            ),
                          ),
                          child: Text(
                            'Generate Label',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              maincontroller = new TextEditingController();
                              labelGenerated = !labelGenerated;
                              status = Status.generateLabel;
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade200;
                              return Colors
                                  .red.shade500; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showtable = !showtable;
                          });
                        },
                        child: Text(
                          '${generatedBundleList.length > 0 ? generatedBundleList.length : "0"}',
                          // bundlePrint.length.toString(),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget generateLabelAutoCut() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('     WireCutting & Crimping Rejection Cases',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    )),
                // Text(' Rejecttion Quantity: ${total()}',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 12,
                //     ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                            name: "End Wire",
                            quantity: 10,
                            textEditingController: endWireController,
                          ),
                          quantitycell(
                            name: "Blade Mark	",
                            quantity: 10,
                            textEditingController: bladeMarkController,
                          ),
                          quantitycell(
                            name: "Cable Damage",
                            quantity: 10,
                            textEditingController: cableDamageController,
                          ),
                          quantitycell(
                            name: "Length Variation",
                            quantity: 10,
                            textEditingController: lengthvariationController,
                          ),
                          quantitycell(
                            name: "Roller Mark",
                            quantity: 10,
                            textEditingController: rollerMarkController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Strip Length Variation",
                            quantity: 10,
                            textEditingController:
                                stripLengthVariationController,
                          ),
                          quantitycell(
                            name: "Nick Mark",
                            quantity: 10,
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "End Terminal",
                            quantity: 10,
                            textEditingController: endTerminalController,
                          ),
                          quantitycell(
                            name: "Terminal Damage",
                            quantity: 10,
                            textEditingController: terminalDamageController,
                          ),
                          quantitycell(
                            name: "Teminal Bend	",
                            quantity: 10,
                            textEditingController: terminalBendController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                              name: "Terminal Twist",
                              quantity: 10,
                              textEditingController: terminalTwistController),
                          quantitycell(
                            name: "Window Gap",
                            quantity: 10,
                            textEditingController: windowGapController,
                          ),
                          quantitycell(
                            name: "Crimp On Insulation",
                            quantity: 10,
                            textEditingController: crimpOnInsulationController,
                          ),
                          quantitycell(
                            name: "Bellmouth Less",
                            quantity: 10,
                            textEditingController: bellMouthLessController,
                          ),
                          quantitycell(
                            name: "Bellmouth More",
                            quantity: 10,
                            textEditingController: bellMouthMoreController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Cut Off Bar",
                            quantity: 10,
                            textEditingController: cutoffBarController,
                          ),
                          quantitycell(
                            name: "Exposure Strands",
                            quantity: 10,
                            textEditingController: exposureStrandsController,
                          ),
                          quantitycell(
                            name: "Strands Cut",
                            quantity: 10,
                            textEditingController: strandsCutController,
                          ),
                          quantitycell(
                            name: "Brush Length Less",
                            quantity: 10,
                            textEditingController: brushLengthLessController,
                          ),
                          quantitycell(
                            name: "Brush Length More",
                            quantity: 10,
                            textEditingController: brushLEngthMoreController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Half Curling",
                            quantity: 10,
                            textEditingController: halfCurlingController,
                          ),
                          quantitycell(
                            name: "Setup Rejections",
                            quantity: 10,
                            textEditingController: setupRejectionsController,
                          ),
                          quantitycell(
                            name: "CVM Rejections",
                            quantity: 10,
                            textEditingController: cvmRejectionsController,
                          ),
                          quantitycell(
                            name: "CFM Rejections",
                            quantity: 10,
                            textEditingController: cfmRejectionsController,
                          ),
                          quantitycell(
                            name: "Copper Mark",
                            quantity: 10,
                            textEditingController: copperMarkController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Wrong terminal",
                            quantity: 10,
                            textEditingController: wrongTerminalController,
                          ),
                          quantitycell(
                            name: "Wrong Cable",
                            quantity: 10,
                            textEditingController: wrongcableController,
                          ),
                          quantitycell(
                            name: "Seam Open",
                            quantity: 10,
                            textEditingController: seamOpenController,
                          ),
                          quantitycell(
                            name: "Wrong Cut-length",
                            quantity: 10,
                            textEditingController: wrongCutLengthController,
                          ),
                          quantitycell(
                            name: "Miss Crimp",
                            quantity: 10,
                            textEditingController: missCrimpController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Extrusion Burr",
                            quantity: 10,
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
              height: 40,
              child: Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text("Bundle Qty :  "),
                                  Text(
                                    "${bundleQty.text}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Rejected Qty :  "),
                                  Text(
                                    "${total()}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.26,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  setState(() {
                                    status = Status.quantity;
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
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green.shade200;
                                      return Colors.green; // Use the component's default.
                                    },
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green.shade200;
                                      return Colors.green; // Use the component's default.
                                    },
                                  ),
                                ),
                                child: loading
                                    ? Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : Text("Generate Label"),
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (int ?.parse(total()??'0') <
                                      int ?.parse(bundleQty.text)) {
                                    log(postGenerateLabelToJson(getPostGeneratelabel())??'0');
                                    apiService
                                        .postGeneratelabel(
                                            getPostGeneratelabel(),
                                            bundleQty.text)
                                        .then((value) {
                                      if (value != null) {
                                        DateTime now = DateTime.now();
                                        GeneratedLabel label1 = value;
                                        _print(
                                            ipaddress:
                                                "${widget.machine.printerIp}",
                                            // ipaddress: "172.25.16.53",
                                            bq: bundleQty.text,
                                            qr: "${label1.bundleId}",
                                            routenumber1: "${label1.routeNo}",
                                            date: now.day.toString() +
                                                "-" +
                                                now.month.toString() +
                                                "-" +
                                                now.year.toString(),
                                            orderId:
                                                "${widget.schedule.orderId}",
                                            fgPartNumber:
                                                "${widget.schedule.finishedGoodsNumber}",
                                            cutlength:
                                                "${widget.schedule.length}",
                                            cablepart:
                                                "${widget.schedule.cablePartNumber}",
                                            wireGauge: "${label1.wireGauge}",
                                            terminalfrom:
                                                "${label1.terminalFrom}",
                                            terminalto: "${label1.terminalTo}");
                                        setState(() {
                                          loading = false;
                                        });

                                        setState(() {
                                          widget.reload();
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          labelGenerated = !labelGenerated;
                                          status = Status.scanBin;
                                          label = value;
                                        });
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                   
                                       Fluttertoast.showToast(
        msg:
                                          "Rejected Quantity is greater than Bundle Quantity",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget generateLabelMannualCut() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Cutting Rejection Cases',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                            name: "End Wire",
                            quantity: 10,
                            textEditingController: endWireController,
                          ),
                          quantitycell(
                            name: "blade Mark	",
                            quantity: 10,
                            textEditingController: bladeMarkController,
                          ),
                          quantitycell(
                            name: "Cable Damage",
                            quantity: 10,
                            textEditingController: cableDamageController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Length variation",
                            quantity: 10,
                            textEditingController: lengthvariationController,
                          ),
                          quantitycell(
                            name: "Roller Mark",
                            quantity: 10,
                            textEditingController: rollerMarkController,
                          ),
                          quantitycell(
                            name: "Strip Length Variation",
                            quantity: 10,
                            textEditingController:
                                stripLengthVariationController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Nick Mark",
                            quantity: 10,
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "Wrong Cable",
                            quantity: 10,
                            textEditingController: wrongcableController,
                          ),
                          quantitycell(
                            name: "Wrong Cut Length",
                            quantity: 10,
                            textEditingController: wrongCutLengthController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Strands Cut",
                            quantity: 10,
                            textEditingController: strandsCutController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              child: Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text("Bundle Qty :  "),
                                  Text(
                                    "${bundleQty.text}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Rejected Qty :  "),
                                  Text(
                                    "${total()}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.green))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.white;
                                    return Colors
                                        .white; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  status = Status.quantity;
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
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    )
                                  : Text("Generate Label"),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                if (int ?.parse(total()??'0') <
                                    int ?.parse(bundleQty.text)) {
                                  log(postGenerateLabelToJson(getPostGeneratelabel())??'');
                                  apiService
                                      .postGeneratelabel(getPostGeneratelabel(),
                                          bundleQty.text)
                                      .then((value) {
                                    if (value != null) {
                                      DateTime now = DateTime.now();
                                      GeneratedLabel label1 = value;
                                      _print(
                                          ipaddress:
                                              "${widget.machine.printerIp}",
                                          // ipaddress: "172.25.16.53",
                                          bq: bundleQty.text,
                                          qr: "${label1.bundleId}",
                                          routenumber1: "${label1.routeNo}",
                                          date: now.day.toString() +
                                              "-" +
                                              now.month.toString() +
                                              "-" +
                                              now.year.toString(),
                                          orderId: "${widget.schedule.orderId}",
                                          fgPartNumber:
                                              "${widget.schedule.finishedGoodsNumber}",
                                   cutlength:
                                              "${widget.schedule.length}",
                                          cablepart:
                                              "${widget.schedule.cablePartNumber}",
                                          wireGauge: "${label1.wireGauge}",
                                          terminalfrom:
                                              "${label1.terminalFrom}",
                                          terminalto: "${label1.terminalTo}");
                                            setState(() {
                                          loading = false;
                                        });

                                      setState(() {
                                        widget.reload();
                                        labelGenerated = !labelGenerated;
                                        status = Status.scanBin;
                                        label = value;
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                      });
                                    }else {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                  });
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  
                                     Fluttertoast.showToast(
        msg:
                                        "Rejected Quantity is greater than Bundle Quantity",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
      // emu-m/c-004w   

  PostGenerateLabel getPostGeneratelabel() {
    return PostGenerateLabel(
      //Schedule Detail
      cablePartNumber: int ?.parse(widget.schedule.cablePartNumber ?? '0'),
      purchaseorder: int ?.parse(widget.schedule.orderId ?? '0'),
      orderIdentification: int ?.parse(widget.schedule.orderId ?? '0'),
      finishedGoods: int ?.parse(widget.schedule.finishedGoodsNumber ?? '0'),
      color: widget.schedule.color??'',
      cutLength: int ?.parse(widget.schedule.length ?? '0'),
      scheduleIdentification: int ?.parse(widget.schedule.scheduledId ?? '0'),
      scheduledQuantity: int ?.parse(widget.schedule.scheduledQuantity ?? '0'),
      machineIdentification: widget.machine.machineNumber??'',
      operatorIdentification: widget.userId ??'',
      bundleIdentification: _bundleScanController.text,
      rejectedQuantity: int ?.parse(total()??"0"),
      // Quantitys
      crimpOnInsulation: int ?.parse(crimpOnInsulationController.text == ''
          ? "0"
          : crimpOnInsulationController.text),
      terminalBend: int ?.parse(terminalBendController.text == ''
          ? "0"
          : terminalBendController.text),
      terminalTwist: int ?.parse(terminalTwistController.text == ''
          ? "0"
          : terminalTwistController.text),
      windowGap: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      strandsCut: int ?.parse(
          strandsCutController.text == '' ? "0" : strandsCutController.text),
      terminalDamage: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      conductorCurlingUpDown: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      insulationCurlingUpDown: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      conductorBurr: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      improperCrimping: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      tabBendOrTabOpen: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      bellMouthLessOrMore: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      cutOffLessOrMore: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      cutOffBurr: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      cutOffBend: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      insulationDamage: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      exposureStrands: int ?.parse(exposureStrandsController.text == ''
          ? "0"
          : exposureStrandsController.text),
      brushLengthLessorMore: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      terminalCoppermark: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      setupRejections: int ?.parse(setupRejectionsController.text == ''
          ? "0"
          : setupRejectionsController.text),
      terminalBackOut: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      cableDamage: int ?.parse(
          cableDamageController.text == '' ? "0" : cableDamageController.text),
      crimpingPositionOutOrMissCrimp: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      terminalSeamOpen: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      rollerMark: int ?.parse(
          rollerMarkController.text == '' ? "0" : rollerMarkController.text),
      lengthLessOrLengthMore: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      gripperMark: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      endWire: int ?.parse(
          endWireController.text == '' ? "0" : endWireController.text),
      endTerminal: int ?.parse(
          endTerminalController.text == '' ? "0" : endTerminalController.text),
      entangledCable: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      troubleShootingRejections: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      wireOverLoadRejectionsJam: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      halfCurlingA: int ?.parse(
          halfCurlingController.text == '' ? "0" : halfCurlingController.text),
      brushLengthLessOrMoreC: int ?.parse(windowGapController.text == ''
          ? "0"
          : windowGapController.text), //TODO
      exposureStrandsD: int ?.parse(exposureStrandsController.text == ''
          ? "0"
          : exposureStrandsController.text),
      cameraPositionOutE: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      crimpOnInsulationF: int ?.parse(crimpOnInsulationController.text == ''
          ? "0"
          : crimpOnInsulationController.text),
      cablePositionMovementG: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      crimpOnInsulationC: int ?.parse(crimpOnInsulationController.text == ''
          ? "0"
          : crimpOnInsulationController.text), //TODO
      crimpingPositionOutOrMissCrimpD: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      crimpPositionOut: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      stripPositionOut: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      offCurling: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      cFmPfmRejections: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      incomingIssue: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      bladeMark: int ?.parse(
          bladeMarkController.text == '' ? "0" : bladeMarkController.text),
      crossCut: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      insulationBarrel: int ?.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      method: widget.method??"0",
      terminalFrom: int ?.parse('${terminalA.terminalPart ?? '0'}'),
      terminalTo: int ?.parse('${terminalB.terminalPart ?? '0'}'),
      awg: "${widget.schedule.awg}",
    );
  }
  // 8765607  500 900 RD 369100004 84671404

  PostGenerateLabel calculateTotal(PostGenerateLabel label) {
    int  total = label.terminalDamage +
        label.brushLengthLessOrMoreC +
        label.setupRejections +
        label.insulationDamage +
        label.improperCrimping +
        label.terminalBackOut +
        label.terminalSeamOpen +
        label.exposureStrands +
        label.crimpingPositionOutOrMissCrimp +
        label.terminalBend +
        label.cableDamage +
        label.bellMouthLessOrMore +
        label.tabBendOrTabOpen +
        label.exposureStrands +
        label.entangledCable +
        label.rollerMark +
        label.cameraPositionOutE +
        label.terminalTwist +
        label.halfCurlingA +
        label.conductorCurlingUpDown +
        label.cutOffLessOrMore +
        label.strandsCut +
        label.troubleShootingRejections +
        label.lengthLessOrLengthMore +
        label.windowGap +
        label.endWire +
        label.insulationCurlingUpDown +
        label.cutOffBurr +
        label.brushLengthLessOrMoreC +
        label.wireOverLoadRejectionsJam +
        label.gripperMark +
        label.cablePositionMovementG +
        label.endTerminal +
        label.conductorBurr +
        label.cutOffBend +
        label.terminalCoppermark +
        label.crimpingPositionOutOrMissCrimp +
        label.crimpOnInsulation +
        label.crimpPositionOut +
        label.stripPositionOut +
        label.offCurling +
        label.cFmPfmRejections +
        label.incomingIssue +
        label.crossCut +
        label.insulationBarrel;

    label.rejectedQuantity = total;
    return label;
  }

  Widget showBundles() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      height: 245,
      width: 400,
      child: SingleChildScrollView(
        child: DataTable(
            columnSpacing: 20,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Bundle Id',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'Qty',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'Print',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'info',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
            rows: generatedBundleList
                .map((e) => DataRow(cells: <DataCell>[
                      DataCell(Text(
                        e.transferBundleToBin.bundleId.toString(),
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(Text(
                        e.bundleQty??'',
                        style: TextStyle(fontSize: 12),
                      )),
                      DataCell(ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.green),
                        ),
                        onPressed: () {
                          DateTime now = DateTime.now();
                          //TODO
                          _print(
                              ipaddress: "${widget.machine.printerIp}",
                              // ipaddress: "172.26.59.14",
                              bq: e.bundleQty,
                              qr: "${e.label.bundleId}",
                              routenumber1: "${e.label.routeNo}",
                              date: now.day.toString() +
                                  "-" +
                                  now.month.toString() +
                                  "-" +
                                  now.year.toString(),
                              orderId: "${widget.schedule.orderId}",
                              fgPartNumber:
                                  "${widget.schedule.finishedGoodsNumber}",
                              cutlength: "${widget.schedule.length}",
                              cablepart: "${widget.schedule.cablePartNumber}",
                              wireGauge: "${e.label.wireGauge}",
                              terminalfrom: "${e.label.terminalFrom}",
                              terminalto: "${e.label.terminalTo}");
                        },
                        child: Text('Print'),
                      )),
                      DataCell(GestureDetector(
                          onTap: () {
                            showBundleDetail(e);
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ))),
                    ]))
                .toList()),
      ),
    );
  }

  Widget quantitycell({
    String ? name,
    int ? quantity,
    required TextEditingController textEditingController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 30,
                width: 140,
                child: TextFormField(
                  readOnly: true,
                  showCursor: false,
                  controller: textEditingController,
                  onTap: () {
                    setState(() {
                      _output = '';
                      maincontroller = textEditingController;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  keyboardType: TextInputType.multiline,
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

  Widget binScan() {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            width: 250,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: RawKeyboardListener(
                focusNode: keyboardFocus,
                onKey: (event) => handleKey(event.data),
                child: TextField(
                    autofocus: true,
                    controller: _binController,
                    onSubmitted: (value) {
                      hasBin = true;
                      binState = "Scan Next bin";
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
                      _binController.clear();
                      setState(() {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        binId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _binController.text.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
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
                        labelText: 'Scan bin',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          //Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                              return Colors.green.shade200;
                            return Colors
                                .red.shade400; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '  Scan Bin  ',
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
                        if (_binController.text.length > 0) {
                          setState(() {
                            status = Status.scanBundle;
                          });
                        } else {
                          
                             Fluttertoast.showToast(
        msg: "Bin not Scanned",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget bundleScan() {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          Container(
            width: 270,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RawKeyboardListener(
                focusNode: keyboardFocus,
                onKey: (event) => handleKey(event.data),
                child: TextField(
                    autofocus: true,
                    // focusNode: _bundleFocus,
                    controller: _bundleScanController,
                    onSubmitted: (value) {
                      setState(() {
                        hasBin = true;
                      });
                    },
                    onTap: () {
                      setState(() {});
                    },
                    onChanged: (value) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      setState(() {
                        bundleId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _bundleScanController.text.length > 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _bundleScanController.clear();
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
                        labelText: 'Scan Bundle',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: 270,
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
                              return Colors.green.shade200;
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          status = Status.scanBin;
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
                              return Colors.green.shade200;
                            return Colors.red; // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Save & Scan Next',
                        ),
                      ),
                      onPressed: () {
                        if (_bundleScanController.text.length > 0) {
                          if (_bundleScanController.text ==
                              getpostBundletoBin().bundleId) {
                            apiService.postTransferBundletoBin(
                                transferBundleToBin: [
                                  getpostBundletoBin()
                                ]).then((value) {
                              if (value != null) {
                                BundleTransferToBin
                                    bundleTransferToBinTracking = value[0];
                                
                                     Fluttertoast.showToast(
        msg:
                                        "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                setState(() {
                                  generatedBundleList.add(GeneratedBundle(
                                      bundleQty: bundleQty.text,
                                      label: label,
                                      transferBundleToBin: getpostBundletoBin(),
                                      rejectedQty: total()));
                                  clear();
                                  _bundleScanController.clear();
                                  _binController.clear();
                                  label = new GeneratedLabel();
                                  status = Status.quantity;
                                });
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
                          } else {
                            
                               Fluttertoast.showToast(
        msg: "Wrong Bundle Id",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        } else {
                          
                             Fluttertoast.showToast(
        msg: "Bundle Not Scanned",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  TransferBundleToBin getpostBundletoBin() {
    TransferBundleToBin bundleToBin = TransferBundleToBin(
        binIdentification: _binController.text, bundleId: label.bundleId);
    return bundleToBin;
  }

  String ? total() {
    int ? total = int ?.parse(
            endWireController.text.length > 0 ? endWireController.text : '0') +
        int ?.parse(bladeMarkController.text.length > 0
            ? bladeMarkController.text
            : '0') +
        int ?.parse(cableDamageController.text.length > 0
            ? cableDamageController.text
            : '0') +
        int ?.parse(lengthvariationController.text.length > 0
            ? lengthvariationController.text
            : '0') +
        int ?.parse(rollerMarkController.text.length > 0
            ? rollerMarkController.text
            : '0') +
        int ?.parse(stripLengthVariationController.text.length > 0
            ? stripLengthVariationController.text
            : '0') +
        int ?.parse(nickMarkController.text.length > 0
            ? nickMarkController.text
            : '0') +
        int ?.parse(endTerminalController.text.length > 0
            ? endTerminalController.text
            : '0') +
        int ?.parse(terminalDamageController.text.length > 0
            ? terminalDamageController.text
            : '0') +
        int ?.parse(terminalBendController.text.length > 0
            ? terminalBendController.text
            : '0') +
        int ?.parse(terminalTwistController.text.length > 0
            ? terminalTwistController.text
            : '0') +
        int ?.parse(
            windowGapController.text.length > 0 ? windowGapController.text : '0') +
        int ?.parse(crimpOnInsulationController.text.length > 0 ? crimpOnInsulationController.text : '0') +
        int ?.parse(bellMouthLessController.text.length > 0 ? bellMouthLessController.text : '0') +
        int ?.parse(bellMouthMoreController.text.length > 0 ? bellMouthMoreController.text : '0') +
        int ?.parse(cutoffBarController.text.length > 0 ? cutoffBarController.text : '0') +
        int ?.parse(exposureStrandsController.text.length > 0 ? exposureStrandsController.text : '0') +
        int ?.parse(strandsCutController.text.length > 0 ? strandsCutController.text : '0') +
        int ?.parse(brushLengthLessController.text.length > 0 ? brushLengthLessController.text : '0') +
        int ?.parse(brushLEngthMoreController.text.length > 0 ? brushLEngthMoreController.text : '0') +
        int ?.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int ?.parse(setupRejectionsController.text.length > 0 ? setupRejectionsController.text : '0') +
        int ?.parse(cvmRejectionsController.text.length > 0 ? cvmRejectionsController.text : '0') +
        int ?.parse(cfmRejectionsController.text.length > 0 ? cfmRejectionsController.text : '0') +
        int ?.parse(copperMarkController.text.length > 0 ? copperMarkController.text : '0') +
        int ?.parse(wrongTerminalController.text.length > 0 ? wrongTerminalController.text : '0') +
        int ?.parse(wrongcableController.text.length > 0 ? wrongcableController.text : '0') +
        int ?.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int ?.parse(wrongCutLengthController.text.length > 0 ? wrongCutLengthController.text : '0') +
        int ?.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int ?.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    //TODO nickMark
    // ignore: unnecessary_null_comparison
    return total == null ? '0' : total.toString();
  }

  Future<void> showBundleDetail(GeneratedBundle generatedBundle) async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Container(
                child: Row(
              children: [
                Container(
                  width: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("Bundle Detail",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Bundle Id : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Text(
                            '${generatedBundle.transferBundleToBin.bundleId}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Bin Id : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                          Text(
                            '${generatedBundle.transferBundleToBin.binIdentification}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Bundle Qty :',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                          Text(
                            " ${generatedBundle.label.bundleQuantity}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Rejected Qty : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Text(
                            '${generatedBundle.rejectedQty}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}

class GeneratedBundle {
  String ? bundleQty;
  TransferBundleToBin transferBundleToBin;
  GeneratedLabel label;
  String ? rejectedQty;
  GeneratedBundle(
      {this.rejectedQty, this.bundleQty, required this.label, required this.transferBundleToBin});
}

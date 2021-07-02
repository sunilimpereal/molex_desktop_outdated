import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/Preparation/getpreparationSchedule.dart';
import 'package:molex_desktop/model_api/Preparation/postPreparationDetail.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/cableDetails_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/crimping/bundleDetail.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/models/preparationScan.dart';
import 'package:molex_desktop/screens/operator/location.dart';
import 'package:molex_desktop/screens/visual%20Inspector/VI_locationTransfer.dart';
import 'package:molex_desktop/screens/widgets/P3scheduleDetaiLWIP.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/apiService.dart';

enum Status {
  dash,
  rejection,
  scanBin,
  scanBundle,
}

// ignore: must_be_immutable
class Preparationprocess extends StatefulWidget {
  Employee employee;
  String ? machineId;
  Preparationprocess({required this.employee, this.machineId});
  @override
  _PreparationprocessState createState() => _PreparationprocessState();
}

class _PreparationprocessState extends State<Preparationprocess> {
  TextEditingController _userScanController = new TextEditingController();
  FocusNode _userScanFocus = new FocusNode();
  TextEditingController _bundleIdScanController = new TextEditingController();
  FocusNode _bundleIdScanFocus = new FocusNode();
  late String  userId;
  List<PreparationScan> preparationList = [];
  late ApiService apiService;
  String ? _output = '';
  late String  bundleId;
  List<String ?> usersList = [];
  TextEditingController mainController = new TextEditingController();

  TextEditingController _binController = new TextEditingController();
  Status status = Status.dash;

  TextEditingController bundleQtyController = new TextEditingController();

  TextEditingController passedQtyController = new TextEditingController();

  TextEditingController rejectedQtyController = new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController cablecrosscutController = new TextEditingController();
  TextEditingController stripLengthController = new TextEditingController();
  TextEditingController stripNickController = new TextEditingController();
  TextEditingController unsheathingLengthController =
      new TextEditingController();
  TextEditingController drainWirecutController = new TextEditingController();
  TextEditingController trimmingCableWrongController =
      new TextEditingController();
  TextEditingController trimmingLengthlessController =
      new TextEditingController();
  TextEditingController hstImproperShrinkingController =
      new TextEditingController();
  TextEditingController hstDamageController = new TextEditingController();
  TextEditingController bootReverseController = new TextEditingController();
  TextEditingController wrongBootInsertionController =
      new TextEditingController();
  TextEditingController bootDamageController = new TextEditingController();

  int ? selectedindex = 0;
  getUser() async {
    apiService = new ApiService();
    apiService.getUserList().then((value) {
      setState(() {
        usersList = value!.map((e) => e.empId).toList();
      });
    });
  }

  late CableTerminalA terminalA;
  late CableTerminalB terminalB;
  getTerminal(
      {String ? fgNumber,
      String ? cablePtNo,
      String ? length,
      String ? color,
      int ? awg}) {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: fgNumber,
            cablepartno: cablePtNo,
            length: length,
            color: color,
            awg: awg)
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: fgNumber,
              cablepartno: cablePtNo,
              length: length,
              color: color,
              awg: awg)
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
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.red),
            color: Colors.red,
            onPressed: () {
              status == Status.dash
                  ? Navigator.pop(context)
                  : setState(() {
                      status = Status.dash;
                    });
            },
          ),
          title: const Text(
            'Preparation',
            style: TextStyle(color: Colors.red),
          ),
          elevation: 0,
          actions: [
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
                              widget.machineId ?? "",
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
        body: main(status));
  }

  Widget main(Status status) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    switch (status) {
      case Status.dash:
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [scanUserAndBundle(), table()],
          ),
        );

      case Status.rejection:
        return Column(
          children: [
            processDetailTop(selectedindex??0),
            scanbundleidpop(selectedindex??0),
          ],
        );
      case Status.scanBin:
        return scanBin();
      case Status.scanBundle:
        return Container();
        
      default:
        return Container();
    }
  }

  Widget processDetailTop(selectedindex) {
    return Column(
      children: [
        P3ScheduleDetailWIP(
          schedule: PreparationSchedule(
              orderId: preparationList[selectedindex??0]
                  .bundleDetail
                  .orderId
                  .toString(),
              finishedGoodsNumber: preparationList[selectedindex??0]
                  .bundleDetail
                  .finishedGoodsPart
                  .toString(),
              scheduledId: preparationList[selectedindex??0]
                  .bundleDetail
                  .scheduledId
                  .toString(),
              cablePartNumber: preparationList[selectedindex??0]
                  .bundleDetail
                  .cablePartNumber
                  .toString(),
              length: preparationList[selectedindex??0]
                  .bundleDetail
                  .cutLengthSpecificationInmm
                  .toString(),
              process:
                  preparationList[selectedindex??0].bundleDetail.updateFromProcess,
              color: preparationList[selectedindex??0].bundleDetail.color,
              scheduledQuantity: ""),
        ),
        terminal(selectedindex??0),
      ],
    );
  }

  Widget terminal(int  selectedindex) {
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // terminal A
            Container(
              child: FutureBuilder(
                  future: apiService.getCableTerminalA(
                      fgpartNo: preparationList[selectedindex]
                          .bundleDetail
                          .finishedGoodsPart
                          .toString(),
                      cablepartno: preparationList[selectedindex]
                              .bundleDetail
                              .cablePartNumber
                              .toString(),
                      length:
                          "${preparationList[selectedindex].bundleDetail.cutLengthSpecificationInmm}",
                      color:
                          "${preparationList[selectedindex].bundleDetail.color}",
                      awg: int ?.parse(
                        preparationList[selectedindex].bundleDetail.awg ?? '0',
                      )),
                  builder: (context, snapshot) {
                    CableTerminalA terminalA = snapshot.data as CableTerminalA;
                    if (snapshot.hasData) {
                      return process1(
                          'From Process Unsheathing Length : ${terminalA.unsheathingLength}',
                          0.30);
                    } else {
                      return process1(
                          'From Process Unsheathing Length :', 0.325);
                    }
                  }),
            ),
            FutureBuilder(
                future: apiService.getCableDetails(
                    fgpartNo: preparationList[selectedindex]
                        .bundleDetail
                        .finishedGoodsPart
                        .toString(),
                    cablepartno: preparationList[selectedindex]
                            .bundleDetail
                            .cablePartNumber
                            .toString(),
                    length:
                        "${preparationList[selectedindex].bundleDetail.cutLengthSpecificationInmm}",
                    color:
                        "${preparationList[selectedindex].bundleDetail.color}",
                    awg: int ?.parse(
                      preparationList[selectedindex].bundleDetail.awg ?? '0',
                    )),
                builder: (context, snapshot) {
                  CableDetails cableDetail = snapshot.data as CableDetails;
                  if (snapshot.hasData) {
                    return process(
                        'Cable',
                        'Cut Length Spec(mm) -${cableDetail.cutLengthSpec}',
                        'Cable Part Number(Description)',
                        '${cableDetail.cablePartNumber}(${cableDetail.description})',
                        'From Strip Length Spec(mm) ${cableDetail.stripLengthFrom} \n To Strip Length Spec(mm) ${cableDetail.stripLengthTo}',
                        0.36);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            FutureBuilder(
                future: apiService.getCableTerminalB(
                    fgpartNo: preparationList[selectedindex]
                        .bundleDetail
                        .finishedGoodsPart
                        .toString(),
                    cablepartno: preparationList[selectedindex]
                            .bundleDetail
                            .cablePartNumber
                            .toString(),
                    length:
                        "${preparationList[selectedindex].bundleDetail.cutLengthSpecificationInmm}",
                    color:
                        "${preparationList[selectedindex].bundleDetail.color}",
                    awg: int ?.parse(
                      preparationList[selectedindex].bundleDetail.awg ?? '0',
                    )),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CableTerminalB cableTerminalB = snapshot.data as CableTerminalB;
                    return process1(
                        'To Process Unsheathing Length : ${cableTerminalB.unsheathingLength} ',
                        0.30);
                  } else {
                    return process1('To Process Unsheathing Length : ', 0.325);
                  }
                })
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    Container(
                      width: MediaQuery.of(context).size.width * width,
                      child: Text(
                        p5 ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontFamily: '',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget process1(String ? p1, double ? width) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        height: 50,
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
                width: MediaQuery.of(context).size.width * width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          p1!,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: ''),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget scanUserAndBundle() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          color: Colors.transparent,
          height: 400,
          width: 300,
          child: Column(
            children: [userScan(), bundleScan(), button()],
          )),
    );
  }

  Widget scanbundleidpop(int selectedindex) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(20.0),
              color: Colors.grey.shade100,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: feild(
                            heading: "Bundle Id",
                            value: "${preparationList[selectedindex].bundleId}",
                            width: 0.12),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: feild(
                            heading: "Bundle Qty",
                            value:
                                "${preparationList[selectedindex].bundleDetail.bundleQuantity}",
                            width: 0.12),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: feild(
                            heading: "Rejected Qty",
                            value: "${rejectedQtyController.text}",
                            width: 0.12),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: feild1(
                      //       heading: "Bundle Qty",
                      //       value:
                      //           "${preparationList[selectedindex??0].bundleDetail.bundleQuantity}",
                      //       textEditingController: TextEditingController(),
                      //       width: 0.2),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: feild1(
                      //       heading: "Rejected Qty",
                      //       value: "",
                      //       width: 0.2,
                      //       textEditingController: rejectedQtyController),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(children: [
                              quantity(
                                  'Cable Damage', 10, cableDamageController),
                              quantity('Cable Cross Cut', 10,
                                  cablecrosscutController),
                              quantity(' Strip Length less / More', 10,
                                  stripLengthController),
                              quantity('Strip Nick mark / blade mark', 10,
                                  stripNickController),
                            ]),
                            Column(children: [
                              quantity('Unsheathing Length less / More', 10,
                                  unsheathingLengthController),
                              quantity(
                                  'Drain Wire Cut', 10, drainWirecutController),
                              quantity('Trimming cable Wrong', 10,
                                  trimmingCableWrongController),
                              quantity('Trimming Length less / More', 10,
                                  trimmingLengthlessController),
                            ]),
                            Column(children: [
                              quantity('HST Improper Shrinking', 10,
                                  hstImproperShrinkingController),
                              quantity('HST Damage', 10, hstDamageController),
                              quantity(
                                  'Boot Reverse', 10, bootReverseController),
                              quantity('Boot Damage', 10, bootDamageController),
                            ]),
                            Column(children: [
                              quantity('Wrong Boot Insertion', 10,
                                  wrongBootInsertionController),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: Colors.green, // background
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        PostPreparationDetail postPreparationDetail =
                            new PostPreparationDetail(
                          bundleIdentification: preparationList[selectedindex]
                              .bundleDetail
                              .bundleIdentification,
                          bundleQuantity: preparationList[selectedindex]
                              .bundleDetail
                              .bundleQuantity,
                          passedQuantity: (preparationList[selectedindex]
                                  .bundleDetail
                                  .bundleQuantity)! -
                              (rejectedQtyController.text == ""
                                  ? 0
                                  : int ?.parse(rejectedQtyController.text)),
                          rejectedQuantity: rejectedQtyController.text == ""
                              ? 0
                              : int ?.parse(rejectedQtyController.text),
                          crimpInslation: 0,
                          windowGap: 0,
                          exposedStrands: 0,
                          burrOrCutOff: 0,
                          terminalBendOrClosedOrDamage: 0,
                          nickMarkOrStrandsCut: 0,
                          seamOpen: 0,
                          missCrimp: 0,
                          frontBellMouth: 0,
                          backBellMouth: 0,
                          extrusionOnBurr: 0,
                          brushLength: 0,
                          cableDamage: 0,
                          terminalTwist: 0,
                          insulationSlug: 0,
                          orderId: int ?.parse(preparationList[selectedindex]
                              .bundleDetail
                              .orderId??''),
                          fgPart: preparationList[selectedindex]
                              .bundleDetail
                              .finishedGoodsPart,
                          scheduleId: preparationList[selectedindex]
                              .bundleDetail
                              .scheduledId,
                          binId: preparationList[selectedindex]
                              .bundleDetail
                              .binId
                              .toString(),

                              // TODO awg should be added

                          processType: "Preparation",
                          method: "",
                          status: "",
                          machineIdentification: widget.machineId,
                          cablePartNumber: preparationList[selectedindex]
                              .bundleDetail
                              .cablePartNumber,
                          cutLength: preparationList[selectedindex]
                              .bundleDetail
                              .cutLengthSpecificationInmm,
                          color:
                              preparationList[selectedindex].bundleDetail.color,
                          finishedGoods: preparationList[selectedindex]
                              .bundleDetail
                              .finishedGoodsPart,
                              terminalFrom: terminalA.terminalPart,
                              terminalTo: terminalB.terminalPart,
                              awg:   preparationList[selectedindex].bundleDetail.awg,
                        );
                        apiService
                            .postPreparationDetail(
                                postPreparationDetail: postPreparationDetail)
                            .then((value) {
                          if (value) {
                            showtoast(msg:  "Preparation Detail Saved");
                            setState(() {
                              status = Status.scanBin;
                            });
                          } else {}
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
            height: 300,
            padding: EdgeInsets.all(20),
            child: Center(child: keypad(mainController))),
      ],
    );
  }

  int ? total() {
    int ? total = int ?.parse(cableDamageController.text.length > 0
            ? cableDamageController.text
            : '0') +
        int ?.parse(cablecrosscutController.text.length > 0
            ? cablecrosscutController.text
            : '0') +
        int ?.parse(stripLengthController.text.length > 0
            ? stripLengthController.text
            : '0') +
        int ?.parse(unsheathingLengthController.text.length > 0
            ? unsheathingLengthController.text
            : '0') +
        int ?.parse(drainWirecutController.text.length > 0
            ? drainWirecutController.text
            : '0') +
        int ?.parse(hstImproperShrinkingController.text.length > 0
            ? hstImproperShrinkingController.text
            : '0') +
        int ?.parse(trimmingCableWrongController.text.length > 0
            ? trimmingCableWrongController.text
            : '0') +
        int ?.parse(trimmingLengthlessController.text.length > 0
            ? trimmingLengthlessController.text
            : '0') +
        int ?.parse(stripNickController.text.length > 0
            ? stripNickController.text
            : '0') +
        int ?.parse(hstDamageController.text.length > 0
            ? hstDamageController.text
            : '0') +
        int ?.parse(bootReverseController.text.length > 0
            ? bootReverseController.text
            : '0') +
        int ?.parse(
            bootDamageController.text.length > 0 ? bootDamageController.text : '0') +
        int ?.parse(wrongBootInsertionController.text.length > 0 ? wrongBootInsertionController.text : '0');

    return total;
  }

  showtoast({required String msg}) {
    
         Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget button() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.22,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Colors.green, // background
                onPrimary: Colors.white,
              ),
              onPressed: () {
                if (userId.length> 0 && bundleId.length > 0) {
                  setState(() {
                    print("userList $usersList ");
                    if (usersList.contains(userId)) {
                      apiService.getBundleDetail(bundleId).then((value) {
                        BundleData bundleData = value!;
                        // ignore: unnecessary_null_comparison
                        if (value != null) {
                          if (!preparationList
                              .map((e) => e.bundleId)
                              .toList()
                              .contains(bundleData.bundleIdentification)) {
                            if (bundleData.updateFromProcess != "Preparation") {
                              setState(() {
                                preparationList.add(PreparationScan(
                                    employeeId: userId,
                                    bundleId: bundleId,
                                    bundleDetail: value,
                                    status: 'Not Complete',
                                    binId: value.binId.toString()));
                                _bundleIdScanController.clear();
                                bundleId = '';
                              });
                            } else {
                              
                                   Fluttertoast.showToast(
        msg:
                                      "$bundleId Bundle preparation is Completed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            
                                 Fluttertoast.showToast(
        msg: "Bundle already added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          
                               Fluttertoast.showToast(
        msg: "Invalid Bundle Id",
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
        msg: "Invalid user",
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
        msg: "Invalid userId and Bundle Id",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.22,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Colors.green, // background
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                 final list = await  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViLocationTransfer(
                            employee: widget.employee,
                            type: "preparation",
                            locationType: LocationType.partialTransfer,
                            machine: MachineDetails(machineNumber: ""),
                          )),
                );
                  log("lilst : $list");

                setState(() {
                  for(String ? bundle in list){
                    try{
                     preparationList.remove(preparationList[
                        preparationList.indexWhere(
                            (element) => element.bundleId == bundle)]);
                    }catch(e){}
                  }
                  list.map((e) {
                    print('blahhh');
                   
                  });
                });
              },
              child: Text(
                'Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  Widget userScan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                          focusNode: _userScanFocus,
                          controller: _userScanController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            setState(() {
                              userId = value;
                            });
                          },
                          decoration: new InputDecoration(
                              suffix: _userScanController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _userScanController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 2.0),
                              ),
                              labelText: '  Scan User  ',
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5.0))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget bundleScan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                          focusNode: _bundleIdScanFocus,
                          controller: _bundleIdScanController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            setState(() {
                              bundleId = value;
                            });
                          },
                          decoration: new InputDecoration(
                              suffix: _bundleIdScanController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _bundleIdScanController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 2.0),
                              ),
                              labelText: '  Scan Bundle Id  ',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget table() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 600,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'Employee Id',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Text(
                    'Bundle ID',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),
                    ),
                  )),
                  DataColumn(
                    label: Text(
                      'Bin ID',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Text(
                    '',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 13),
                    ),
                  ))
                ],
                rows: preparationList
                    .map(
                      (e) => DataRow(cells: <DataCell>[
                        DataCell(Text(
                          e.employeeId??'',
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          e.bundleId??'',
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          e.binId ?? '-',
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          e.status??'',
                          style: TextStyle(fontSize: 12),
                        )),
                        DataCell(e.status == "Not Complete"
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedindex = preparationList.indexOf(e);
                                    status = Status.rejection;
                                    getTerminal(
        fgNumber: preparationList[selectedindex??0]
            .bundleDetail
            .finishedGoodsPart
            .toString(),
        cablePtNo: preparationList[selectedindex??0]
            .bundleDetail
            .cablePartNumber
            .toString(),
        length:
            "${preparationList[selectedindex??0].bundleDetail.cutLengthSpecificationInmm}",
        color: "${preparationList[selectedindex??0].bundleDetail.color}",
        awg: int ?.parse(
          preparationList[selectedindex??0].bundleDetail.awg ?? '0',
        ));
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: Colors.green, // background
                                  onPrimary: Colors.white,
                                ),
                                child: Text('Process'),
                              )
                            : Text("-")),
                      ]),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget scanBin() {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Container(
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
                          controller: _binController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(fontSize: 14),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 3),
                            labelText: "Scan Bin",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.redAccent),
                                ),
                                onPressed: () {
                                  if (_binController.text.length > 0) {
                                    apiService.postTransferBundletoBin(
                                        transferBundleToBin: [
                                          TransferBundleToBin(
                                            binIdentification:
                                                _binController.text,
                                            userId: widget.employee.empId,
                                            bundleId:
                                                preparationList[selectedindex??0]
                                                    .bundleId,
                                            locationId: "",
                                          )
                                        ]).then((value) {
                                      if (value != null) {
                                        BundleTransferToBin
                                            bundleTransferToBinTracking =
                                            value[0];
                                        showtoast(
                                          
        msg:
                                                "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text}");

                                        setState(() {
                                          clear();
                                          status = Status.dash;
                                          preparationList[selectedindex??0]
                                              .status = "Complete";
                                        });
                                      } else {
                                        showtoast(
                                             
        msg: "Unable to Transfer bundle");
                                      }
                                    });
                                  } else {
                                      showtoast(
        msg: "Scan Bin to Transfer");
                                  }
                                },
                                child: Text('Scan Bin ')),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                )),
            // scanedTable(),
          ],
        ),
      ),
    );
  }

  // To Show the bundle Id and  Bundle Qty and rejected Quantity
  Widget feild({String ? heading, String ? value, double ? width}) {
    width = MediaQuery.of(context).size.width * width!;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        // color: Colors.red.shade100,
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  heading!,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.normal,
                  )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                children: [
                  Text(
                    value ?? '',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget feild1(
      {String ? heading,
      String ? value,
      double ? width,
      required TextEditingController textEditingController}) {
    width = MediaQuery.of(context).size.width * width!;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        // color: Colors.red.shade100,
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  heading!,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.normal,
                  )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Container(
                      width: 100,
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: textEditingController,
                          style: TextStyle(fontSize: 14),
                          onTap: () {
                            _output = "";
                            mainController = textEditingController;
                          },
                          onChanged: (value) {
                            setState(() {
                              textEditingController.text = value;
                            });
                          },
                          decoration: new InputDecoration(
                            hintText: value,
                            hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w500),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            contentPadding:
                                EdgeInsets.only(bottom: 9, left: 5, right: 5),
                            fillColor: Colors.white,
                          ),
                        ),
                      ))
                  // Text(
                  //   value ?? '',
                  //   style: GoogleFonts.poppins(
                  //     textStyle:
                  //         TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget keypad(TextEditingController controller) {
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

  Widget quantity(
      String ? title, int ? quantity, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 140,
              child: TextField(
                controller: textEditingController,
                style: TextStyle(fontSize: 13),
                onTap: () {
                  setState(() {
                    _output = '';
                    mainController = textEditingController;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  labelText: title,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 13),
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

  clear() {
    cableDamageController.clear();
    unsheathingLengthController.clear();
    hstDamageController.clear();
    hstImproperShrinkingController.clear();
    cablecrosscutController.clear();
    drainWirecutController.clear();
    wrongBootInsertionController.clear();
    stripLengthController.clear();
    trimmingCableWrongController.clear();
    bootDamageController.clear();
    stripLengthController.clear();
    stripNickController.clear();
    bootReverseController.clear();
    rejectedQtyController.clear();
    _binController.clear();
  }
}

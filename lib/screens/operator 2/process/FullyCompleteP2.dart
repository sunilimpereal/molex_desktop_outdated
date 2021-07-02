import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/screens/operator/location.dart';
import 'package:molex_desktop/service/apiService.dart';


class FullCompleteP2 extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  CrimpingSchedule schedule;
    Function continueProcess;
  FullCompleteP2({required this.employee, required this.machine, required this.schedule,required this.continueProcess});
  @override
  _FullCompleteP2State createState() => _FullCompleteP2State();
}

class _FullCompleteP2State extends State<FullCompleteP2> {
  late PostStartProcessP1 postStartprocess;
  TextEditingController mainController = new TextEditingController();
  TextEditingController firsrPeicelastPieceController =
      new TextEditingController();
  TextEditingController crimpheightAdjController = new TextEditingController();
  TextEditingController airPressureLowController = new TextEditingController();
  TextEditingController noRawMaterialController = new TextEditingController();
  TextEditingController applicatorChangeOverController =
      new TextEditingController();
  TextEditingController terminalChangeOverController =
      new TextEditingController();
  TextEditingController technichianNotAvailableController =
      new TextEditingController();
  TextEditingController powerFailureController = new TextEditingController();
  TextEditingController machineCleaningController = new TextEditingController();
  TextEditingController noOperatorController = new TextEditingController();
  TextEditingController sensorNotWorkingController =
      new TextEditingController();
  TextEditingController meetingController = new TextEditingController();
  TextEditingController maintainanceMinorStopageController =
      new TextEditingController();
  TextEditingController minorToolingAjjustmentsController =
      new TextEditingController();

  String ? _output = '';
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      child: Row(
        children: [rejectioncase(), keypad(mainController)],
      ),
    );
  }

  Widget keypad(TextEditingController controller) {
    // print('NickMark ${windowGapController.text}');
    // print('End wire ${endWireController.text}');
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

  Widget rejectioncase() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Crimping Production Report',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ))
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
                            name: "First Piece & last Piece & Patrol",
                            quantity: 10,
                            textEditingController:
                                firsrPeicelastPieceController,
                          ),
                          quantitycell(
                            name: "Crimp Height Adjustment",
                            quantity: 10,
                            textEditingController: crimpheightAdjController,
                          ),
                          quantitycell(
                            name: "Air Pressure Low",
                            quantity: 10,
                            textEditingController: airPressureLowController,
                          ),
                          quantitycell(
                            name: "No Raw Material ",
                            quantity: 10,
                            textEditingController: noRawMaterialController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Applicator Change over	",
                            quantity: 10,
                            textEditingController:
                                applicatorChangeOverController,
                          ),
                          quantitycell(
                            name: "Terminal Change over",
                            quantity: 10,
                            textEditingController: terminalChangeOverController,
                          ),
                          quantitycell(
                            name: "Technician Not Available",
                            quantity: 10,
                            textEditingController:
                                technichianNotAvailableController,
                          ),
                          quantitycell(
                            name: "Power Failure",
                            quantity: 10,
                            textEditingController: powerFailureController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Machine Cleaning",
                            quantity: 10,
                            textEditingController: machineCleaningController,
                          ),
                          quantitycell(
                            name: "No Operator",
                            quantity: 10,
                            textEditingController: noOperatorController,
                          ),
                          quantitycell(
                            name: "Sensor Not Working		",
                            quantity: 10,
                            textEditingController: sensorNotWorkingController,
                          ),
                          quantitycell(
                            name: "Meeting",
                            quantity: 10,
                            textEditingController: meetingController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Maintenance Minor Stoppage",
                            quantity: 10,
                            textEditingController:
                                maintainanceMinorStopageController,
                          ),
                          quantitycell(
                            name: "Minor Tooling Adjustments",
                            quantity: 10,
                            textEditingController:
                                minorToolingAjjustmentsController,
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
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Center(
                      child: Container(
                        child: ElevatedButton(
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
                                ),
                            onPressed: () {
                                widget.continueProcess("scanBundle");
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width:10),
                  Container(
                    height: 50,
                    child: Center(
                      child: Container(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
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
                            child: Text("Save & Complete Process"),
                            onPressed: () {
                              Future.delayed(Duration.zero, () {
                                //    postStartprocess = new PostStartProcessP1(
                                //   cablePartNumber:
                                //       widget.schedule.cablePartNo ?? "0",
                                //   color: widget.schedule.wireColour,
                                //   finishedGoodsNumber:
                                //       widget.schedule.finishedGoods ?? "0",
                                //   lengthSpecificationInmm:
                                //       widget.schedule.length ?? "0",
                                //   machineIdentification: widget.machine.machineNumber,
                                //   orderIdentification: widget.schedule.purchaseOrder ?? "0",
                                //   scheduledIdentification:
                                //       widget.schedule.scheduleId ?? "0",
                                //   scheduledQuantity:
                                //       widget.schedule.bundleQuantityTotal ?? "0",
                                //   scheduleStatus: "complete",
                                // );
                                FullyCompleteModel fullyComplete =
                                    FullyCompleteModel(
                                  finishedGoodsNumber:
                                      widget.schedule.finishedGoods,
                                  orderId: widget.schedule.purchaseOrder,
                                  purchaseOrder: widget.schedule.purchaseOrder,

                                  cablePartNumber: widget.schedule.cablePartNo,
                                  length: widget.schedule.length,
                                  color: widget.schedule.wireColour,
                                  scheduledStatus: "Complete",
                                  scheduledId: widget.schedule.scheduleId,
                                  scheduledQuantity:
                                      widget.schedule.bundleQuantityTotal,
                                  machineIdentification:
                                      widget.machine.machineNumber,
                                  //TODO bundle ID
                                  firstPieceAndPatrol:
                                      firsrPeicelastPieceController.text == ''
                                          ? 0
                                          : int ?.parse(
                                              firsrPeicelastPieceController
                                                  .text),
                                  applicatorChangeover:
                                      firsrPeicelastPieceController.text == ''
                                          ? 0
                                          : int ?.parse(
                                              applicatorChangeOverController
                                                  .text),
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
                                                employee : widget.employee,
                                                machine: widget.machine, locationType: LocationType.finaTtransfer,
                                              )),
                                    );
                                  } else {}
                                });
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Location(
                              //             userId: widget.userId ??'',
                              //             machine: widget.machine,
                              //           )),
                              // );
                            }),
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

  Widget quantitycell(
      {String ? name,
      int ? quantity,
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
                  showCursor: false,
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

  Widget quantity(
      String ? title, int ? quantity, TextEditingController textEditingController) {
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
                onTap: () {
                  setState(() {
                    _output = '';
                    mainController = textEditingController;
                  });
                },
                style: TextStyle(fontSize: 12),
                controller: textEditingController,
                keyboardType: TextInputType.number,
                showCursor: false,
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
}

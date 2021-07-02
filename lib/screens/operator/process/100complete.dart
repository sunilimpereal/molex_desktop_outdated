import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/screens/operator/location.dart';
import 'package:molex_desktop/service/apiService.dart';


class FullyComplete extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Schedule schedule;
  String ? bundleId;
    Function continueProcess;
  FullyComplete({required this.employee, required this.machine, required this.schedule, this.bundleId,required this.continueProcess});
  @override
  _FullyCompleteState createState() => _FullyCompleteState();
}

class _FullyCompleteState extends State<FullyComplete> {
  late PostStartProcessP1 postStartprocess;
  //Text Eddititing Controller
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

  TextEditingController systemFaultController = new TextEditingController();
  var _output = '';
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 
    return Container(
      child: Row(
        children: [
          productionReport(),
          Column(
            children: [
              keypad(mainController),
              SizedBox(height: 5),
            ],
          ),
        ],
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
        _output = _output + buttonText!;
      }

      print(_output);
      setState(() {
        controller.text = _output;
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

  Widget productionReport() {
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
                Text('                  Production Report',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ))
              ]),
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
                            name: "FP,LP,Patrolling",
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
            Row(
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
                                widget.continueProcess("label");
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                Container(
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width * 0.24,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.transparent))),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return Colors
                                  .green.shade500; // Use the component's default.
                            },
                          ),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade600;
                              return Colors
                                  .green.shade300; // Use the component's default.
                            },
                          ),
                        ),
                        child: Text("Save & Complete Process"),
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            postStartprocess = new PostStartProcessP1(
                              cablePartNumber:
                                  widget.schedule.cablePartNumber ?? "0",
                              color: widget.schedule.color,
                              finishedGoodsNumber:
                                  widget.schedule.finishedGoodsNumber ?? "0",
                              lengthSpecificationInmm:
                                  widget.schedule.length ?? "0",
                              machineIdentification: widget.machine.machineNumber,
                              orderIdentification: widget.schedule.orderId ?? "0",
                              scheduledIdentification:
                                  widget.schedule.scheduledId ?? "0",
                              scheduledQuantity:
                                  widget.schedule.scheduledQuantity ?? "0",
                              scheduleStatus: "complete",
                            );
                            FullyCompleteModel fullyComplete = FullyCompleteModel(
                              finishedGoodsNumber:
                                  int ?.parse(widget.schedule.finishedGoodsNumber??''),
                              purchaseOrder: int ?.parse(widget.schedule.orderId??''),
                              orderId: int ?.parse(widget.schedule.orderId??''),
                              cablePartNumber:
                                  int ?.parse(widget.schedule.cablePartNumber??''),
                              length: int ?.parse(widget.schedule.length??''),
                              color: widget.schedule.color,
                              scheduledStatus: "Complete",
                              scheduledId: int ?.parse(widget.schedule.scheduledId??''),
                              scheduledQuantity:
                                  int ?.parse(widget.schedule.scheduledQuantity??''),
                              machineIdentification: widget.machine.machineNumber,
                              //TODO bundle ID
                              firstPieceAndPatrol: firsrPeicelastPieceController
                                          .text ==
                                      ''
                                  ? 0
                                  : int ?.parse(firsrPeicelastPieceController.text),
                              applicatorChangeover: applicatorChangeOverController
                                          .text ==
                                      ''
                                  ? 0
                                  : int ?.parse(applicatorChangeOverController.text),
                            );
                            apiService.post100Complete(fullyComplete).then((value) {
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
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
       FocusNode ?focusNode}) {
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
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  style: TextStyle(fontSize: 12),
                  keyboardType: TextInputType.name,
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
}

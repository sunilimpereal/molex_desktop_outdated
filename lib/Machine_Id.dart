import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:molex_desktop/screens/Crimping%20Patrol/CrimpingPartrolDash.dart';
import 'package:molex_desktop/screens/Preparation/preparationDash.dart';
import 'package:molex_desktop/screens/kitting_plan/kitting_plan_dash.dart';
import 'package:molex_desktop/screens/operator%202/Home_0p2.dart';
import 'package:molex_desktop/screens/operator/Homepage.dart';
import 'package:molex_desktop/screens/visual%20Inspector/Home_visual_inspector.dart';
import 'package:molex_desktop/service/apiService.dart';

import 'model_api/login_model.dart';
import 'model_api/machinedetails_model.dart';

// ignore: must_be_immutable
class MachineId extends StatefulWidget {
  Employee employee;
  MachineId({required this.employee});
  @override
  _MachineIdState createState() => _MachineIdState();
}

class _MachineIdState extends State<MachineId> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  String? machineId;
  late ApiService apiService;
  late bool loading;
  @override
  void initState() {
    loading = false;
    apiService = new ApiService();
    _textNode.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  handleKey(RawKeyEventData key) {
    //keyCode of key event(66 is return )

    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _textNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
        backgroundColor: Color(0xffE2BDA6),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Material(
                    elevation: 10,
                    shadowColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: []),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Scan Machine",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 30,
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            loading
                                ? Container(
                                    height: 3,
                                    width: 280,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey.shade50,
                                      color: Colors.red.shade600,
                                    ),
                                  )
                                : Container(
                                    width: 280,
                                  ),
                            Lottie.asset('assets/lottie/scan-barcode.json',
                                width: 280, fit: BoxFit.cover),
                            // Text(
                            //   'Scan Machine',
                            //   style: GoogleFonts.openSans(
                            //     textStyle: TextStyle(
                            //       fontSize: 20,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            machineId != ''
                                ? Text(
                                    machineId ?? '',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 10,
                                  ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: 230,
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
                                      return Colors
                                          .red; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  machinScan();
                                },
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            //INSPECTION
                            Container(
                              height: 40,
                              width: 230,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.green;
                                        return Colors
                                            .red; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: "logged In",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeVisualInspector(
                                                employee: widget.employee,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Visual Inspection',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            //Kitting
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: 230,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.green;
                                        return Colors
                                            .red; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg: "logged In",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => KittingDash(
                                                employee: widget.employee,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Kitting',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            //pREPARATION
                            SizedBox(height: 10),
                            Container(
                              child: RawKeyboardListener(
                                  focusNode: FocusNode(),
                                  onKey: (event) {
                                    if (event
                                        .isKeyPressed(LogicalKeyboardKey.tab)) {
                                      machinScan();
                                    }

                                    handleKey(event.data);
                                  },
                                  child: Container(
                                    height: 00,
                                    width: 0,
                                    child: TextField(
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (value) {
                                        machinScan();
                                      },
                                      onTap: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                      },
                                      controller: _textController,
                                      autofocus: true,
                                      onChanged: (value) {
                                        setState(() {
                                          machineId = value;
                                        });
                                      },
                                    ),
                                  )),
                            ),
                          ]),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height: 70,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/appiconbg.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 20,
                right: 30,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.employee.employeeName ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.employee.empId ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Material(
                          elevation: 5,
                          shadowColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }

  void machinScan() {
    setState(() {
      loading = true;
    });
    if (machineId!.trim() == "new") {
      Fluttertoast.showToast(
          msg: "logged In",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CrimpingPatrolDash(
                  userId: widget.employee.empId,
                  machineId: machineId,
                )),
      );
    }
    if (machineId!.trim() == "preparation") {
      Fluttertoast.showToast(
          msg: "logged In",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PreprationDash(
                  employee: widget.employee,
                  machineId: machineId,
                )),
      );
    } else {
      apiService.getmachinedetails(machineId).then((value) {
        if (value!.length > 0) {
          MachineDetails machineDetails = value[0];

          Fluttertoast.showToast(
              msg: machineId ?? '',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          print("machineID:$machineId");
          switch (machineDetails.category) {
            case "Manual Crimping":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePageOp2(
                          employee: widget.employee,
                          machine: machineDetails,
                        )),
              );
              break;
            case "Manual Cutting":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(
                    employee: widget.employee,
                    machine: machineDetails,
                  ),
                ),
              );
              break;
            case "Automatic Cut & Crimp":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(
                    employee: widget.employee,
                    machine: machineDetails,
                  ),
                ),
              );
              break;
            case "Semi Automatic Strip and Crimp Machine":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePageOp2(
                          employee: widget.employee,
                          machine: machineDetails,
                        )),
              );
              break;
            case "Automatic Cutting":
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Homepage(
                          employee: widget.employee,
                          machine: machineDetails,
                        )),
              );
              break;
            default:
              setState(() {
                loading = false;
              });

              Fluttertoast.showToast(
                  msg: "Machine not Found",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                machineId = null;
                _textController.clear();
              });
          }
        } else {
          setState(() {
            loading = false;
          });

          Fluttertoast.showToast(
              msg: "Machine not Found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            machineId = null;
            _textController.clear();
          });
        }
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/screens/Preparation/preparationDash.dart';
import 'package:molex_desktop/service/apiService.dart';


// ignore: must_be_immutable
class PrepMachine extends StatefulWidget {
   Employee employee;
   PrepMachine({required this.employee});
  @override
  _PrepMachineState createState() => _PrepMachineState();
}

class _PrepMachineState extends State<PrepMachine> {
    TextEditingController _textController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  String ? machineId;
  late ApiService apiService;
    @override
  void initState() {
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
   
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Scan Machine",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Lottie.asset('assets/lottie/scan-barcode.json',
                          width: 320, fit: BoxFit.cover),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          'Scan Machine ${machineId ?? ""}',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        width: 180,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green;
                                return Colors
                                    .red; // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                               Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PreprationDash(
                                                employee: widget.employee,
                                                machineId: machineId,
                                              )),
                                    );
                          },
                          child: Text('Next'),
                        ),
                      ),
                      Container(
                        child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (event) {
                              if (event.isKeyPressed(LogicalKeyboardKey.tab)) {}

                              handleKey(event.data);
                            },
                            child: Container(
                              height: 00,
                              width: 0,
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                onSubmitted: (value) {},
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
            ],
          ),
        ),
        Positioned(
            top: 50,
            right: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      widget.employee.employeeName ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.employee.empId ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade700,
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
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                )
              ],
            ))
      ],
    ));
  }

}
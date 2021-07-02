import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/service/apiService.dart';


class ReMapBin extends StatefulWidget {
  String ? userId;
  MachineDetails machine;
  ReMapBin({this.userId, required this.machine});

  @override
  _ReMapBinState createState() => _ReMapBinState();
}

class _ReMapBinState extends State<ReMapBin> {
  TextEditingController binIdController = new TextEditingController();
  TextEditingController bundleIdController = new TextEditingController();
  FocusNode _binFocus = new FocusNode();
  TextEditingController _binController = new TextEditingController();
  String ? binId;
  TextEditingController _bundleController = new TextEditingController();
  FocusNode _bundleFocus = new FocusNode();

  String ? bundleId;
  List<BundleTransferToBin> transferList = [];

  ApiService apiService = new ApiService();
  @override
  void initState() {
    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _bundleFocus.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              bundle(),
              bin(),
              confirmTransfer(),
            ]),
          ),
          Container(child: SingleChildScrollView(child: dataTable())),
        ],
      ),
    );
  }

  Widget bundle() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) => handleKey(event.data),
                        child: TextField(
                            focusNode: _bundleFocus,
                            autofocus: true,
                            controller: _bundleController,
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
                                suffix: _bundleController.text.length > 1
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _bundleController.clear();
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
                                labelText: 'Scan Bundle',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5.0))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }

  Widget bin() {
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
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (event) => handleKey(event.data),
                      child: TextField(
                          focusNode: _binFocus,
                          controller: _binController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              _binController.clear();
                              binId = null;
                            });
                          },
                          onSubmitted: (value) {},
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
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 2.0),
                              ),
                              labelText: 'Scan bin',
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

  Widget dataTable() {
    int  a = 1;
    return Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: DataTable(
              columnSpacing: 40,
              columns: <DataColumn>[
                DataColumn(
                  label: Text('No.',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(fontWeight: FontWeight.w600))),
                ),

                DataColumn(
                  label: Text('Location ID',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(fontWeight: FontWeight.w600))),
                ),
                DataColumn(
                  label: Text('Bin ID',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(fontWeight: FontWeight.w600))),
                ),
                DataColumn(
                  label: Text('Bundle ID',
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(fontWeight: FontWeight.w600))),
                ),
                // DataColumn(
                //   label: Text('Remove',
                //       style: GoogleFonts.openSans(
                //           textStyle: TextStyle(fontWeight: FontWeight.w600))),
                // ),
              ],
              rows: transferList
                  .map(
                    (e) => DataRow(cells: <DataCell>[
                      DataCell(Text("${a++}",
                          style: GoogleFonts.openSans(textStyle: TextStyle()))),
                      DataCell(Text("${e.locationId}",
                          style: GoogleFonts.openSans(textStyle: TextStyle()))),
                      DataCell(Text("${e.binId}",
                          style: GoogleFonts.openSans(textStyle: TextStyle()))),
                      DataCell(Text("${e.bundleIdentification}",
                          style: GoogleFonts.openSans(textStyle: TextStyle()))),
                      // DataCell(
                      //   IconButton(
                      //     icon: Icon(
                      //       Icons.delete,
                      //       color: Colors.red,
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         transferList.remove(e);
                      //       });
                      //     },
                      //   ),
                      // ),
                    ]),
                  )
                  .toList()),
        ));
  }

  Widget confirmTransfer() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.23,
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.green),
            ),
            onPressed: () {
              if (_bundleController.text.length > 0) {
                if (_bundleController.text == getpostBundletoBin().bundleId) {
                  apiService.postTransferBundletoBin(transferBundleToBin: [
                    getpostBundletoBin()
                  ]).then((value) {
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

                      setState(() {
                        transferList.add(bundleTransferToBinTracking);
                        _binController.clear();
                        _bundleController.clear();
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
            child: Text('Transfer')),
      ),
    );
  }

  TransferBundleToBin getpostBundletoBin() {
    TransferBundleToBin bundleToBin = TransferBundleToBin(
      binIdentification: _binController.text,
      bundleId: _bundleController.text,
      userId: widget.userId ??'',
    );
    return bundleToBin;
  }

  handleKey(RawKeyEventData key) {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }
}

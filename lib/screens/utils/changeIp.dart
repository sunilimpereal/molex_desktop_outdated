import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login.dart';

class ChangeIp extends StatefulWidget {
  @override
  _ChangeIpState createState() => _ChangeIpState();
}

class _ChangeIpState extends State<ChangeIp> {
  late SharedPreferences preferences;
  String ? baseip;
  List<String> ipList = [
    "http://justerp.in:8080/wipts/",
    "http://10.221.46.8:8080/wipts/",
    "http://192.168.1.252:8080/wipts/",
    "http://mlxbngvwqwip01.molex.com:8080/wipts/",
  ];
  String ? newIp;
  List<String ?> ipList1 = [];
  getSharedPref() async {
    SharedPreferences preferenc = await SharedPreferences.getInstance();
    setState(() {
      preferences = preferenc;
      baseip = preferences.getString('baseIp');
      try {
        ipList1 = preferences.getStringList('ipList')!;
        // ignore: unnecessary_null_comparison
        if (ipList1 == null) {
          preferences.setStringList('ipList', ipList);
          ipList = preferences.getStringList('ipList')!;
        } else {
          ipList = preferences.getStringList('ipList')!;
        }
      } catch (e) {
        preferences.setStringList('ipList', ipList);
      }
    });
  }

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    baseip = preferences.getString('baseIp');

    print(baseip);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Ip "),
        actions: [
          IconButton(
              onPressed: () {
              
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        child: Container(
          child: ListView.builder(
              itemCount: ipList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor:
                      baseip == ipList[index] ? Colors.red.shade200 : Colors.white,
                  title: Text(" ${ipList[index]}"),
                  onTap: () {
                    setState(() {
                      preferences.setString('baseIp', "${ipList[index]}");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScan()),
                      );
                    });
                  },
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            showaddip();
        },
        icon: Icon(Icons.add),
        label: Text("Add IP"),
      ),
    );
  }

  Future<void> showaddip() async {
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
        return Center(child: addIp(context));
      },
    );
  }

  Widget addIp(BuildContext context) {
    return AlertDialog(
        title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('Add URL '),
              ],
            ),
            Container(
              height: 50,
              width: 400,
              child: TextFormField(
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  setState(() {
                    newIp = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    if (newIp != null) {
                      setState(() {
                        ipList.add(newIp!);
                        preferences.setStringList('ipList', ipList);
                      });
                      Navigator.pop(context);
                    } else {
                      
                         Fluttertoast.showToast(
        msg: "url is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text("Save Ip")),
            ),
          ],
        ),
      ),
    ));
  }
}

// ListTile(
//   tileColor: baseip == "http://justerp.in:8080/wipts/"
//       ? Colors.red.shade200
//       : Colors.white,
//   title: Text("http://justerp.in:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://justerp.in:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://10.221.46.8:8080/wipts/"
//       ? Colors.red.shade200
//       : Colors.white,
//   title: Text("http://10.221.46.8:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://10.221.46.8:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://192.168.1.252:8080/wipts/"
//       ? Colors.red.shade200
//       : Colors.white,
//   title: Text("http://192.168.1.252:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://192.168.1.252:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://mlxbngvwqwip01.molex.com:8080/wipts/"
//       ? Colors.red.shade200
//       : Colors.white,
//   title: Text("http://mlxbngvwqwip01.molex.com:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://mlxbngvwqwip01.molex.com:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// )

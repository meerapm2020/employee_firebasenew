import 'package:employee_firebase/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Employee Form"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Name"),
              ),
              SizedBox(height: 15),
              TextField(
                controller: agecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Age"),
              ),
              SizedBox(height: 15),
              TextField(
                controller: locationcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Location"),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                  onPressed: () async {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> employeeInfoMap = {
                      "Name": namecontroller.text,
                      "Age": agecontroller.text,
                      "Id": id,
                      "Location": locationcontroller.text,
                    };
                    await DataBase.addEmployeeDetails(employeeInfoMap, id);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Employee details added successfully"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    namecontroller.clear();
                                    agecontroller.clear();
                                    locationcontroller.clear();
                                  },
                                  child: Text("OK")),
                            ],
                          );
                        });
                  },
                  child: Text("Add")),
            ],
          ),
        ));
  }
}

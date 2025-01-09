import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_firebase/firebase_services.dart';
import 'package:employee_firebase/second.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController location = TextEditingController();

  Stream<QuerySnapshot>? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DataBase.getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error:${snapshot.error}"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Employee Details Available."),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Name:" + (ds['Name'] ?? "N/A"),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  name.text = ds['Name'];
                                  age.text = ds['Age'];
                                  location.text = ds["Location"];
                                  EditEmployeeDetails(ds["Id"]);
                                },
                                child: Icon(Icons.edit)),
                            GestureDetector(
                                onTap: () async {
                                  await DataBase.deleteEmployeeDetails(
                                      ds['Id']);
                                },
                                child: Icon(Icons.delete)),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Age:" + (ds["Age"] ?? "N/A").toString(),
                          style: TextStyle(fontSize: 18, color: Colors.yellow),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Location:" + (ds["Location"] ?? "N/A"),
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Firebase"),
      ),
      body: Column(
        children: [Expanded(child: allEmployeeDetails())],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SecondScreen()));
          },
          child: Text("+")),
    );
  }

  Future EditEmployeeDetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Text('Edit'),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Details"),
                    ],
                  ),
                  Text("Name"),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Text("Age"),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: age,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Text("Location"),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: location,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateInfo = {
                          "Name": name.text,
                          "Age": age.text,
                          "Id": id,
                          "Location": location.text,
                        };
                        await DataBase.updateEmployeeDetails(id, updateInfo)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Update")),
                ],
              ),
            ),
          ));
}

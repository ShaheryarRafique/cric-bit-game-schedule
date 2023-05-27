import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GameSchedule extends StatefulWidget {
  const GameSchedule({super.key});

  @override
  State<GameSchedule> createState() => _GameScheduleState();
}

class _GameScheduleState extends State<GameSchedule> {
  dynamic teamOne, teamTwo, gameDateTime = DateTime.now().toString();
  String selectedTeamOne = "Select a Team One";
  String selectedTeamTwo = "Select a Team Two";
  bool isGameLive = false;
  dynamic isGame = 'No';

  //Firebase FireStore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> selectedValues = [];
  List<dynamic> dropdownItems = [];

  //Error message
  String? teamOneErrorMessage;
  String? teamTwoErrorMessage;
  String? dateTimeErrorMessage;
  String? channelErrorMessage;
  String? selectedErrorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('channel').get();
      final List data = querySnapshot.docs.map((doc) => doc['name']).toList();
      setState(() {
        dropdownItems = data;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  validateForm() {
    setState(() {
      if (selectedTeamOne == "Select a Team One") {
        teamOneErrorMessage = "Team One is required";
      } else {
        teamOneErrorMessage = null;
      }

      if (selectedTeamTwo == "Select a Team Two") {
        teamTwoErrorMessage = "Team Two is required";
      } else {
        teamTwoErrorMessage = null;
      }

      if (gameDateTime.isEmpty) {
        dateTimeErrorMessage = "Date Time is required";
      } else {
        dateTimeErrorMessage = null;
      }

      if (selectedValues.isEmpty) {
        selectedErrorMessage = "Select a Channel";
      } else {
        selectedErrorMessage = null;
      }

      if (selectedTeamOne != "Select a Team One" &&
          selectedTeamTwo != "Select a Team Two" &&
          selectedValues.isNotEmpty) {
        sendData();
        Fluttertoast.showToast(
            msg: "Game added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  fetchTeamOneName(teamid) async {
    final DocumentSnapshot docSnapshot =
        await _firestore.collection('teams').doc(teamid).get();
    selectedTeamOne = docSnapshot['name'];
  }

  fetchTeamTwoName(teamid) async {
    final DocumentSnapshot docSnapshot =
        await _firestore.collection('teams').doc(teamid).get();
    selectedTeamTwo = docSnapshot['name'];
  }

  sendData() async {
    Map<String, dynamic> newGameData = {
      "dateTime": gameDateTime,
      "isLive": isGameLive,
      "teamOne": '/teams/$teamOne',
      "teamTwo": '/teams/$teamTwo',
      "channel": selectedValues,
    };

    await FirebaseFirestore.instance.collection("schedule").add(newGameData);
    print("new game added");
    setState(() {
      selectedValues = [];
      selectedTeamTwo = "Select a Team Two";
      selectedTeamOne = "Select a Team One";
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 80, bottom: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Schedule Game",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Fill the data to add the game.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                SelectTeamOneDropDown(),
                const SizedBox(height: 30),
                SelectTeamTwoDropDown(),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Game Date Time:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    GameDateTimePicker(),
                  ],
                ),
                const SizedBox(height: 30),
                //Select is Live
                IsGameLiveSelect(),
                const SizedBox(height: 20),
                //Select multiple items
                DropDownMultiSelect(
                  options: dropdownItems,
                  selectedValues: selectedValues,
                  whenEmpty: "Select The Channels",
                  icon: const Icon(Icons.arrow_drop_up_sharp),
                  onChanged: (value) {
                    setState(() {
                      selectedValues = value as List<String>;
                    });
                  },
                  decoration: InputDecoration(errorText: selectedErrorMessage),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      validateForm();
                      // if (_formKey.currentState != null &&
                      //     _formKey.currentState!.validate()) {
                      //   sendData();
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //         content: Text('Please Fill all fields.')),
                      //   );
                      // }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column IsGameLiveSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Is Live:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 'Yes',
              groupValue: isGame,
              onChanged: (value) {
                setState(() {
                  isGame = value;
                  if (value == 'Yes') {
                    isGameLive = true;
                  }
                });
              },
            ),
            const Text('Yes'),
            const SizedBox(width: 50),
            Radio(
              value: 'No',
              groupValue: isGame,
              onChanged: (value) {
                setState(() {
                  isGame = value;
                  if (value == 'No') {
                    isGameLive = false;
                  }
                });
              },
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  DateTimePicker GameDateTimePicker() {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      decoration: InputDecoration(
        errorText: dateTimeErrorMessage,
      ),
      onChanged: (val) {
        setState(() {
          gameDateTime = DateTime.parse(val);
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  StreamBuilder<QuerySnapshot<Object?>> SelectTeamOneDropDown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("teams").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            List<DropdownMenuItem<String>> teamOneDropdownItems =
                snapshot.data!.docs.map((doc) {
              return DropdownMenuItem<String>(
                value: doc.id,
                child: Text(doc['name']),
              );
            }).toList();

            return DropdownButtonFormField<String>(
              items: teamOneDropdownItems,
              onChanged: (selectedValue) {
                // ignore: avoid_print
                teamOne = selectedValue;
                fetchTeamOneName(selectedValue);
              },
              hint: Text(selectedTeamOne),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                errorText: teamOneErrorMessage,
              ),
            );
          } else {
            return const Text("No Data Available");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  StreamBuilder<QuerySnapshot<Object?>> SelectTeamTwoDropDown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("teams").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            List<DropdownMenuItem<String>> teamOneDropdownItems =
                snapshot.data!.docs.map((doc) {
              return DropdownMenuItem<String>(
                value: doc.id,
                child: Text(doc['name']),
              );
            }).toList();

            return DropdownButtonFormField<String>(
              items: teamOneDropdownItems,
              onChanged: (selectedValue) {
                // ignore: avoid_print
                teamTwo = selectedValue;
                fetchTeamTwoName(selectedValue);
              },
              enableFeedback: true,
              hint: Text(selectedTeamTwo),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                errorText: teamTwoErrorMessage,
              ),
            );
          } else {
            return const Text("No Data Available");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> dropDownList = ["Admin", "Clinet", "Influencer"];

  String? selectedItem;
  String? isLiveController;

  late final DateTime dateTimeController;
  late final String teamOneController;
  late final String teamTwoController;

  List<String> selectedChannelValues = []; // List to store the selected values
  List<String> avaliableChannelItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  void _onItemChecked(String item, bool checked) {
    setState(() {
      if (checked) {
        selectedChannelValues.add(item);
      } else {
        selectedChannelValues.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              //Team One
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.black38,
                  ),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  elevation: 8,
                  hint: const Text("Select Team One"),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  value: selectedItem,
                  onChanged: (select) {
                    setState(() {
                      selectedItem = select;
                      teamOneController = selectedItem!;
                    });
                  },
                  items: dropDownList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              //Team Second
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.black38,
                  ),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  elevation: 8,
                  hint: const Text("Select Team Two"),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  value: selectedItem,
                  onChanged: (select) {
                    setState(() {
                      selectedItem = select;
                      teamTwoController = selectedItem!;
                    });
                  },
                  items: dropDownList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              //Select Date and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Game Date Time:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) {
                      setState(() {
                        dateTimeController = DateTime.parse(val);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //Select is Live
              Column(
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
                        groupValue: isLiveController,
                        onChanged: (value) {
                          setState(() {
                            isLiveController = value!;
                          });
                        },
                      ),
                      const Text('Yes'),
                      const SizedBox(width: 50),
                      Radio(
                        value: 'No',
                        groupValue: isLiveController,
                        onChanged: (value) {
                          setState(() {
                            isLiveController = value!;
                          });
                        },
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.black38,
                  ),
                ),
                child: DropdownButtonFormField<List<String>>(
                  items: avaliableChannelItems.map((String item) {
                    return DropdownMenuItem<List<String>>(
                      value: selectedChannelValues,
                      child: CheckboxListTile(
                        title: Text(item),
                        value: selectedChannelValues.contains(item),
                        onChanged: (checked) {
                          _onItemChecked(item, checked!);
                        },
                      ),
                    );
                  }).toList(),
                  onChanged: (selected) {
                    setState(() {
                      selectedChannelValues = selected!;
                    });
                  },
                  hint: const Text('Select options'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select at least one option.';
                    }
                    return null;
                  },
                ), 
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Save", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

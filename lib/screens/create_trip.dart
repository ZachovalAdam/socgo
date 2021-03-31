import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/globals.dart';

class CreateTripScreen extends StatefulWidget {
  CreateTripScreen(this.sight);

  var sight;
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState(this.sight);
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController participantLimitController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      helpText: "Select trip date",
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  var sight;

  _CreateTripScreenState(var s) {
    sight = s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Make a trip to " + sight["name"],
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Give people a little insight on how the trip is gonna go, maybe some info about your plan!",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                            maxLength: 250,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                            )),
                        SizedBox(height: 20),
                        Text(
                          "When are you planning to go?",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: InkWell(
                              onTap: () => {_selectDate(context), FocusScope.of(context).requestFocus(new FocusNode())},
                              child: Container(
                                color: Theme.of(context).cardTheme.color,
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(Moment.fromDate(selectedDate).format("EEEE, dd MMM yyyy"), style: Theme.of(context).textTheme.subtitle1),
                                      Row(
                                        children: [
                                          Container(width: 1, height: 20, color: Theme.of(context).textTheme.headline1.color.withOpacity(0.3)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            FeatherIcons.calendar,
                                            size: 20,
                                            color: Theme.of(context).textTheme.headline1.color.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Participant limit",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Maybe you only want 3 people coming with you, here you can pick how many people can join your trip.",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CustomNumRangeTextInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                            controller: participantLimitController,
                            decoration: InputDecoration(
                              labelText: "2 - 15 participants (including you)",
                            )),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              "Done",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                            ),
                            onPressed: () async {
                              int participantsAmt = participantLimitController.text == "" ? 15 : int.parse(participantLimitController.text);
                              int finalParticipantsAmt = participantLimitController.text == "" ? (15 - 1) : (int.parse(participantLimitController.text) - 1);
                              var crTrContext = context;
                              await createTrip(sight["id"], descriptionController.text.trim(), Timestamp.fromDate(selectedDate), participantsAmt);
                              await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("Success"),
                                        content: Text("Congratulations, you created a trip! Up to " +
                                            finalParticipantsAmt.toString() +
                                            " people can now send you requests to join your trip."),
                                        actions: [
                                          FlatButton(
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        ],
                                      ));
                              Navigator.pop(crTrContext, true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNumRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 2) return TextEditingValue().copyWith(text: '2');

    return int.parse(newValue.text) > 15 ? TextEditingValue().copyWith(text: '15') : newValue;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:socgo/globals.dart';
import 'package:socgo/screens/home.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController profilePicURLController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 36500)),
      lastDate: DateTime.now(),
      helpText: "Select date of birth",
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Lets get into it.", style: Theme.of(context).textTheme.headline4),
                Text(
                  "First, we'll need your real name. This is to prevent confusion while meeting up with others.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: firstNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Your first name cannot be empty.";
                    } else if (val.length > 100) {
                      return "This text has to be shorter than 100 characters.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "First Name",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: lastNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Your last name cannot be empty.";
                    } else if (val.length > 100) {
                      return "This text has to be shorter than 100 characters.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Last Name",
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Now a photo of yourself.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: profilePicURLController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    if (Uri.parse(val).isAbsolute) {
                      if (!(val.endsWith(".png") || val.endsWith(".jpg") || val.endsWith(".jpeg") || val.endsWith(".jfif"))) {
                        return "This is not an image URL.";
                      } else {
                        return null;
                      }
                    } else {
                      return "This is not an image URL.";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Profile Photo URL",
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "A profile picture is required. You know, people need to know how you look like when you meet up.",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "To make sure you're 18 or above, please fill in your date of birth. ",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextSpan(
                      text: "Why?",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Text("SocGo! is 18+ due to the nature of the app's topic. We forbid minors from using this app."),
                                  ));
                        },
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
                    ),
                  ]),
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
                SizedBox(height: 20),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate() && !selectedDate.add(Duration(days: 6570)).isAfter(DateTime.now())) {
                        try {
                          await FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).update({
                            "firstName": firstNameController.text.trim(),
                            "lastName": lastNameController.text.trim(),
                            "pictureUrl": profilePicURLController.text.trim(),
                            "birthDate": selectedDate,
                            "setup": true
                          }).then((a) async {
                            await FirebaseAuth.instance.currentUser.updateProfile(
                                displayName: firstNameController.text.trim() + " " + lastNameController.text.trim(),
                                photoURL: profilePicURLController.text.trim());
                            await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text("Success"),
                                      content: Text("You're nearly done! Please sign in again to finish the setup."),
                                      actions: [
                                        FlatButton(
                                          child: Text("Ok"),
                                          onPressed: () async {
                                            await FirebaseAuth.instance.signOut();
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    )).then((b) => Navigator.pop(context, true));
                          });
                        } catch (err) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("An error has occured"),
                                    content: Text(err.message),
                                  ));
                        }
                      } else if (selectedDate.add(Duration(days: 6570)).isAfter(DateTime.now())) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("An error has occured"),
                                  content: Text("You are not above 18 years of age."),
                                ));
                      }
                    },
                    child: Text("Finish setup"),
                  ),
                  width: double.infinity,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 80.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Your personal data will only be used in this app. ",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: "See what data we collect.",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("see_collected_data");
                            },
                          style:
                              Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }
}

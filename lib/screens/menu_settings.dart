import 'package:flutter/material.dart';
import 'package:socgo/globals.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsMenuScreen extends StatefulWidget {
  SettingsMenuScreen(this.userData);

  var userData;

  @override
  _SettingsMenuScreenState createState() => _SettingsMenuScreenState(this.userData);
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  var userData;

  _SettingsMenuScreenState(var uD) {
    userData = uD;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: 'General',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
                enabled: false,
              ),
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(Icons.fingerprint),
                switchValue: false,
                onToggle: (bool value) {},
                enabled: false,
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                title: 'Delete account',
                leading: Icon(Icons.person_remove_outlined),
                onPressed: (BuildContext settingsContext) async {
                  await showDialog(
                      context: settingsContext,
                      builder: (_) => AlertDialog(
                            title: Text("Delete account"),
                            content: Text("Are you sure you want to proceed? This action is irreversible."),
                            actions: [
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.pop(settingsContext, true);
                                },
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  Navigator.pop(settingsContext, true);
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("One last chance"),
                                      content: Text("This is your last chance, are you sure you want to delete your account?"),
                                      actions: [
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(settingsContext, true);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            deleteAccount(userData["id"]);
                                            auth.currentUser.delete();
                                            Navigator.pop(settingsContext, true);
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

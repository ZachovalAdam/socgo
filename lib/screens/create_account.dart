import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text("SocGo!", style: Theme.of(context).textTheme.headline5),
                  ),
                  SizedBox(
                    height: 120.0,
                  ),
                  Text("Hey!", style: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Create an account to begin your journey around the world!",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: pwController,
                    decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                          ),
                          onPressed: () {
                            _toggle();
                          },
                        )),
                    obscureText: _obscureText,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              context.read<AuthenticationService>().signInGoogle().then((m) => {
                                    if (m != "Success")
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text("Error while logging in"),
                                                  content: Text(m),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                    )
                                                  ],
                                                )),
                                        pwController.text = ""
                                      }
                                  });
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SvgPicture.asset(
                                "res/img/google_g.svg",
                                height: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Google"),
                            ]),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.background),
                              foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).textTheme.headline1.color),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AuthenticationService>()
                              .signUp(
                                email: emailController.text.trim(),
                                password: pwController.text.trim(),
                              )
                              .then((m) => {
                                    if (m != "Success")
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text("Error while signing up"),
                                                  content: Text(m),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                    )
                                                  ],
                                                )),
                                        pwController.text = ""
                                      }
                                    else
                                      {
                                        Navigator.pop(context, true),
                                      }
                                  });
                        },
                        child: Text("Sign up"),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 80.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "By proceeding, you agree to SocGo!'s Privacy Policy and Terms of Service. ",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          TextSpan(
                            text: "See more.",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("See more");
                              },
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

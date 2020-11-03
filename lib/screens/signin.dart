import 'package:flutter/material.dart';
import 'package:socgo/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: Placeholder(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Hey!", style: Theme.of(context).textTheme.headline4),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Sign in or create an account to begin your journey around the world!",
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot password?"),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Google"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Facebook"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signUp(
                              email: emailController.text.trim(),
                              password: pwController.text.trim(),
                            );
                      },
                      child: Text("Create account"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signIn(
                              email: emailController.text.trim(),
                              password: pwController.text.trim(),
                            );
                      },
                      child: Text("Sign in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

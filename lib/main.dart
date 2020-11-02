import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  analytics = FirebaseAnalytics();

  FirebaseCrashlytics.instance.enableInDevMode = false;

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SocGo!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _analyticsEvent() {
    analytics.logEvent(name: 'button_press');
    print('event logged');
  }

  _perfTrace() async {
    Trace trace = FirebasePerformance.instance.newTrace('trace_test');
    trace.start();
    await Future.delayed(const Duration(seconds: 5));
  }

  _crash() {
    throw FlutterError('This is a test');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white, systemNavigationBarColor: Colors.white));
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.title,
              style: TextStyle(color: Colors.black),
            ),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 1,
            leadingWidth: 65,
            leading: IconButton(
              icon: Icon(Icons.chat_bubble_outline),
              onPressed: () {},
              color: Colors.grey.shade600,
            ),
            actions: [
              IconButton(
                  icon: CircleAvatar(backgroundColor: Colors.red, radius: 17.0),
                  constraints: BoxConstraints(minWidth: 65),
                  onPressed: () {}),
            ],
            snap: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => {
                    analytics.logEvent(name: 'button_press'),
                    print('logged analytics event'),
                  },
                  color: Color(0xFF3B84F0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  elevation: 0.0,
                  child: const Text('Log Analytics Event'),
                ),
                RaisedButton(
                  onPressed: () => {_perfTrace, print('logged perf event')},
                  color: Color(0xFF3B84F0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  elevation: 0.0,
                  child: const Text('Log Performance Event'),
                ),
                RaisedButton(
                  onPressed: () => {
                    //FirebaseCrashlytics.instance.crash(),
                    throw Exception("Test exception"),
                  },
                  color: Color(0xFF3B84F0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  elevation: 0.0,
                  child: const Text('Throw error/Crash'),
                ),
              ],
            ),
          ),
        ],
      ),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => {
                analytics.logEvent(name: 'button_press'),
                print('logged analytics event'),
              },
              color: Color(0xFF3B84F0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              textColor: Colors.white,
              elevation: 0.0,
              child: const Text('Log Analytics Event'),

            ),
            RaisedButton(
              onPressed: () => {_perfTrace, print('logged perf event')},
              color: Color(0xFF3B84F0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              textColor: Colors.white,
              elevation: 0.0,
              child: const Text('Log Performance Event'),
            ),
            RaisedButton(
              onPressed: () => {_crash, print('thrown error')},
              color: Color(0xFF3B84F0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              textColor: Colors.white,
              elevation: 0.0,
              child: const Text('Throw error/Crash'),
            ),
          ],
        ),
      ),*/
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ubhacking/database.dart';
import 'package:ubhacking/push.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final push = Push(FirebaseMessaging.instance);
  await push.initialize();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'UB Hacking 2022 Spring'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _enabled = false;
  bool _triggered = false;

  void _toggleEnabled() {
    Database().setHouseEnabled('house1', !_enabled);
    setState(() { _enabled = !_enabled; });
  }

  void _reset() {
    Database().setHouseTriggered('house1', false);
  }

  void _setTriggered(state) {
    setState(() { _triggered = state; });
  }

  @override
  void initState() {
    Database().triggerSubscription('house1', _setTriggered);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _triggered
                  ? 'YOUR ALARM HAS BEEN TRIGGERED!!'
                  : 'Your house is secure.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            _triggered
              ? TextButton(
                onPressed: _reset,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ) : Container(),
            SizedBox(height: 20),
            Text(
              'Toggle Alarm System:',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            TextButton(
              onPressed: _toggleEnabled,
              child: Text(
                _enabled ? 'ENABLED' : 'DISABLED',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: _enabled ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

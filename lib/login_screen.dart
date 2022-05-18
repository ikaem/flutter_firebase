import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/happy_screen.dart';

import 'shared/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _message = "";
  bool _isLogin = true;
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  late FirebaseAuthentication auth;
  late final FirebaseMessaging messaging;

  @override
  void initState() {
    Firebase.initializeApp(
            // options: FirebaseOptions(
            //     apiKey: apiKey,
            //     appId: appId,
            //     messagingSenderId: messagingSenderId,
            //     projectId: projectId)
            )
        .whenComplete(() {
      print("are we here");
      auth = FirebaseAuthentication();
      messaging = FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageReceived);
      // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageReceived);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
          actions: <Widget>[
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(36),
          child: ListView(
            children: <Widget>[
              userInput(),
              passwordInput(),
              btnMain(),
              bntSecondary(),
              btnGoogle(),
              txtMessage(),
            ],
          ),
        ));
  }

  Widget userInput() {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: txtUserName,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "User Name",
          icon: Icon(Icons.verified_user),
        ),
        validator: (text) =>
            (text == null || text.isEmpty) ? "User Name is required" : "",
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(Icons.enhanced_encryption),
        ),
        validator: (text) =>
            (text == null || text.isEmpty) ? "Password is required" : "",
      ),
    );
  }

  Widget btnMain() {
    String btnText = _isLogin ? "Log in" : "Sign up";

    return Padding(
      padding: EdgeInsets.only(top: 128),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            _isLogin ? login() : register();
          },
          style: ButtonStyle(
              // i guess here, we set that backgtround color is taken from theme? for all states? what does that mean?
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColorLight),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: Colors.red),
              ))),
          child: Text(
            btnText,
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).primaryColorLight),
          ),
        ),
      ),
    );
  }

  Widget btnGoogle() {
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: Container(
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorLight),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          side: BorderSide(color: Colors.red)))),
              onPressed: () {
                auth.loginWithGoogle().then((value) {
                  if (value == null) {
                    setState(() {
                      _message = "Google Login Error";
                    });
                  } else {
                    setState(() {
                      _message =
                          "User $value successfully logged in with Google";
                    });
                  }
                });
              },
              child: Text("Log in with Google",
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).primaryColorDark)),
            )));
  }

  Widget bntSecondary() {
    String buttonText = _isLogin ? "Sign Up" : "Log In";

    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(buttonText),
    );
  }

  Widget txtMessage() {
    return Text(_message,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ));
  }

  void login() {
    String _userId = "";

    auth.loginUser(txtUserName.text, txtPassword.text).then((value) {
      if (value == null) {
        setState(() {
          _message = "Login Error";
        });
      } else {
        _userId = value;
        setState(() {
          _message = "User $_userId successfully logged in";
        });

        changeScreen();
      }
    });
  }

  void register() {
    String _userId = "";
    auth.createUser(txtUserName.text, txtPassword.text).then((value) {
      if (value == null) {
        setState(() {
          _message = "Registration Error";
        });
      } else {
        _userId = value;
        setState(() {
          _message = "User $_userId successfully registered";
        });
      }
    });
  }

  void logout() {
    auth.logoutUser().then((value) {
      if (value) {
        setState(() {
          _message = "User logged out";
        });
      } else {
        setState(() {
          _message = "Unable to log out";
        });
      }
    });
  }

  void changeScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HappyScreen()));
  }
}

Future firebaseBackgroundMessageReceived(RemoteMessage message) async {
  // print("Notification:!!!!!!!!!!!");

  // await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  if (message.notification != null) {
    print(message.notification?.title);
    print(message.notification?.body);
  }
}

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometric;
  String _authorized="Not Authorized";

  LocalAuthentication auth=LocalAuthentication();

  Future<void> _checkBiometric() async{
    bool canCheckBiometric;
    try{
      canCheckBiometric=await auth.canCheckBiometrics;
    }on PlatformException catch(e){
      print(e);
    }

    //preventing calling setState before checking
    // Whether this State object is currently in a tree.

    if(!mounted) return;

    setState(() {
      _canCheckBiometrics=canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async{
    List<BiometricType> availableBiometrics;
    try{
      availableBiometrics=await auth.getAvailableBiometrics();
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _availableBiometric=availableBiometrics;
    });
  }

  Future<void> _authenticate() async{
    bool authenticated=false;
    try{
      print("HELLO");
      authenticated= await auth.authenticateWithBiometrics(
        localizedReason:"Scan your finger",
        useErrorDialogs: true,
        stickyAuth: false,
      );
    }on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _authorized=authenticated?"Authorized":"Not Authorized";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Can Check Biometrics: $_canCheckBiometrics'
              ),
              RaisedButton(
                child: Text("Check Biometric"),
                onPressed:_checkBiometric ,
              ),
              Text(
                  'Available Biometric: $_availableBiometric'
              ),
              RaisedButton(
                child: Text("Get Available Biometrics"),
                onPressed:_getAvailableBiometric ,
              ),
              Text(
                  'Current state: $_authorized'
              ),
              RaisedButton(
                child: Text("Authenticate"),
                onPressed:_authenticate ,
              ),
            ],
          ),
        )

    );
  }
}

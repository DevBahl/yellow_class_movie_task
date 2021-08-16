import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          await _auth.currentUser.updateProfile(displayName: _name);
        }
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Color(0xffbF6713C),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 400,
              child: SvgPicture.asset('assets/icons/welcome.svg',
                  height: 200.0, width: 200.0),
            ),
            RichText(
                text: TextSpan(
                    text: 'Register! To get started',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff002A5D)))),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(top: 30),
                      child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) return 'Enter Name';
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                                  color: Color(0xff002A5D), width: 2.0),
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                          ),
                          onSaved: (input) => _name = input),
                    ),
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(top: 20),
                      child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(
                                    color: Color(0xff002A5D), width: 2.0),
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.white)),
                          onSaved: (input) => _email = input),
                    ),
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(top: 20),
                      child: TextFormField(
                          validator: (input) {
                            if (input.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                                  color: Color(0xff002A5D), width: 2.0),
                            ),
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: signUp,
                      child: Text('Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Color(0xff002A5D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}

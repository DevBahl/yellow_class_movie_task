import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class onStart extends StatefulWidget {
  @override
  _onStartState createState() => _onStartState();
}

class _onStartState extends State<onStart> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.pushReplacementNamed(context, "/");

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffbF6713C),
        child: Column(
          children: <Widget>[
            SizedBox(height: 0.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 50),
              height: 350,
              child: SvgPicture.asset('assets/icons/mv2.svg',
                  height: 300.0, width: 300.0),
            ),
            SizedBox(height: 0),
            RichText(
                text: TextSpan(
                    text: 'YCM! An app to keep',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff002A5D)))),
            SizedBox(height: 0.0),
            RichText(
                text: TextSpan(
                    text: 'your watched list updated',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff002A5D)))),
            SizedBox(height: 40.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.only(
                        left: 70, right: 70, top: 10, bottom: 10),
                    onPressed: navigateToLogin,
                    child: Text(
                      'Login',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Color(0xff002A5D)),
                SizedBox(height: 20.0),
                RaisedButton(
                    padding: EdgeInsets.only(
                        left: 65, right: 65, top: 10, bottom: 10),
                    onPressed: navigateToRegister,
                    child: Text(
                      'Signup',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Color(0xff002A5D)),
              ],
            ),
            /*SizedBox(height: 20.0),
            SignInButton(Buttons.Google,
                text: "Sign up with Google", onPressed: googleSignIn)*/
          ],
        ),
      ),
    );
  }
}

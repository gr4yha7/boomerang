import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextStyle _smallTextStyle = TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500);

  final TextStyle _inputHintTextStyle = TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoggedIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookLogin facebookSignIn = FacebookLogin();

  Future<FirebaseUser> _googleSignInUser() async
  {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;

  }

  void _signInWithEmailAndPassword() async {
    final AuthResult result = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text
    ));

    final FirebaseUser user = result.user;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
      });
      print(user.email);
      print(_isLoggedIn);
    }
  }

  void _loginWithFacebook() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        AuthCredential credential =  FacebookAuthProvider.getCredential(accessToken: accessToken.token);


        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
        print('''
         Logged in!
         Email: ${user.email}
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _signOut() async {
    await _auth.signOut();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.lightBlue
//              gradient: LinearGradient(
//                colors: [
//                  Colors.lightBlue,
//                Color(0xfff80f4e),
//                ],
//                begin: Alignment.topLeft,
//                end: Alignment.bottomRight
//              )
            ) 
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 120.0),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: GoogleFonts.pacifico(
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                      color: Colors.white,
                      textStyle: TextStyle(
                        decoration: TextDecoration.none
                      )
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: _smallTextStyle,
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 60.0,
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline, color: Colors.white,),
                              hintText: 'Email address',
                              hintStyle: _inputHintTextStyle,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 15.0, right: 5.0)
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (String value) {
                              return value.isEmpty ? 'Email address is required' : null;
                            },
                          ),
                          decoration: BoxDecoration(
                            // color: Color(0xFF6CA8F1),
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: _smallTextStyle,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key, color: Colors.white,),
                            hintText: 'Password',
                            hintStyle: _inputHintTextStyle,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 15.0, right: 5.0)
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: (String value) {
                            return value.isEmpty ? 'Password is required' : null;
                          },
                        ),
                        decoration: BoxDecoration(
                          // color: Color(0xFF6CA8F1),
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Forgot Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                        color: Colors.white,
                      ),
                     ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        height: 50.0,
                        minWidth: 250.0,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0)
                        ),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Text(
                            'Login',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              "LOGIN USING:",
                            style: _smallTextStyle,
                          ),
                          MaterialButton(
                              onPressed: () {
                                _loginWithFacebook();
                              },
                            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                            height: 50.0,
                            minWidth: 80.0,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/facebook-icon.png',
                              height: 50.0,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _googleSignInUser().then((FirebaseUser user) =>
                                print(user.email)).catchError((err) => print(err));
                            },
                            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                            height: 50.0,
                            minWidth: 80.0,
                            color: Colors.white,
                            child: Image.asset(
                                'assets/images/google-logo.png',
                              height: 30.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: _smallTextStyle
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Color(0xff3c579e)
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
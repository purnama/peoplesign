import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:peoplesign/services/auth.dart';
import 'package:peoplesign/shared/loading.dart';
import 'package:peoplesign/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in to PeopleSign'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () => widget.toggleView(),
                    icon: Icon(Icons.person),
                    label: Text('Register')),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() {
                          this.email = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6
                          ? 'Enter password 6+ chars long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          this.password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            this.loading = true;
                          });
                          dynamic result = await _authService
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              this.loading = false;
                              this.error =
                                  'could not sign in with those credentials';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        setState(() {
                          this.loading = true;
                        });
                        dynamic result = await _authService.signInWithGoogle();
                        if (result == null) {
                          setState(() {
                            this.loading = false;
                            this.error =
                                'could not sign in with those credentials';
                          });
                        }
                      },
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () async {
                        setState(() {
                          this.loading = true;
                        });
                        dynamic result =
                            await _authService.signInWithFacebook();
                        if (result == null) {
                          setState(() {
                            this.loading = false;
                            this.error =
                                'could not sign in with those credentials';
                          });
                        }
                      },
                    ),
                    SignInButton(
                      Buttons.Twitter,
                      onPressed: () async {
                        setState(() {
                          this.loading = true;
                        });
                        dynamic result =
                            await _authService.signInWithTwitter();
                        if (result == null) {
                          setState(() {
                            this.loading = false;
                            this.error =
                                'could not sign in with those credentials';
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

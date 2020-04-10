import 'package:flutter/material.dart';
import 'package:peoplesign/services/auth.dart';
import 'package:peoplesign/shared/loading.dart';

class PhoneAuthVerify extends StatefulWidget {
  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  final AuthService _authService = AuthService();

  double _height, _width, _fixedPadding;
  String code = '';
  String error = '';
  bool loading = false;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.brown[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.brown[100],
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: SizedBox(
                height: _height * 8 / 10,
                width: _width * 8 / 10,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    // AppName:
                    Text('Input OTP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.brown[500],
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700)),

                    SizedBox(height: 20.0),

                    //  Info text
                    Row(
                      children: <Widget>[
                        SizedBox(width: 16.0),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Please enter the ',
                                    style: TextStyle(
                                        color: Colors.brown[500],
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: 'One Time Password',
                                    style: TextStyle(
                                        color: Colors.brown[500],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: ' sent to your mobile',
                                  style: TextStyle(
                                      color: Colors.brown[500],
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),

                    SizedBox(height: 16.0),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        getPinField(key: "1", focusNode: focusNode1),
                        SizedBox(width: 5.0),
                        getPinField(key: "2", focusNode: focusNode2),
                        SizedBox(width: 5.0),
                        getPinField(key: "3", focusNode: focusNode3),
                        SizedBox(width: 5.0),
                        getPinField(key: "4", focusNode: focusNode4),
                        SizedBox(width: 5.0),
                        getPinField(key: "5", focusNode: focusNode5),
                        SizedBox(width: 5.0),
                        getPinField(key: "6", focusNode: focusNode6),
                        SizedBox(width: 5.0),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      this.error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      elevation: 16.0,
                      onPressed: () async {
                        if (code.length != 6) {
                          this.error = 'Please enter your OTP Number';
                        } else {
                          setState(() {
                            this.loading = true;
                          });
                          dynamic result = await _authService.signInWithPhoneNumber(code);
                          if (result == null) {
                            setState(() {
                              this.loading = false;
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                              color: Colors.brown[500], fontSize: 18.0),
                        ),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: key.contains("1") ? true : false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
}

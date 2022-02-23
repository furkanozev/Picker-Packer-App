import 'package:picker_packer/model/user_login.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'picker_navbar_widget.dart';
import 'packer_navbar_widget.dart';
import 'package:flutter/material.dart';

class SelectionWidget extends StatefulWidget {
  final UserLogin user;
  const SelectionWidget({Key key, @required this.user}) : super(key: key);

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState(user);
}

class _SelectionWidgetState extends State<SelectionWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _SelectionWidgetState(user) {
    this.user = user;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF521262),
        title: Text("Are you sure to exit the app?",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
        actions: <Widget>[
          FlatButton(
            child: Text("No",
                style:
                    TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes",
                style:
                    TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height * 1,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Color(0x99C54C82),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (user.mode != 1 && user.mode != 3) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'You aren\'t Picker!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF521262)),
                                ),
                                backgroundColor: Color(0xFFFACF39),
                              ));
                              return;
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'Successfully logged in to Picker!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF521262)),
                                ),
                                backgroundColor: Color(0xFFFACF39),
                              ));
                            }
                            await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.topToBottom,
                                duration: Duration(milliseconds: 300),
                                reverseDuration: Duration(milliseconds: 300),
                                child: PickerNavBarPage(
                                  user: this.user,
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/picker.JPG',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Color(0x9900ADB5),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (user.mode != 2 && user.mode != 3) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'You aren\'t Packer!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF521262)),
                                ),
                                backgroundColor: Color(0xFFFACF39),
                              ));
                              return;
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'Successfully logged in to Packer!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF521262)),
                                ),
                                backgroundColor: Color(0xFFFACF39),
                              ));
                            }
                            await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.topToBottom,
                                duration: Duration(milliseconds: 300),
                                reverseDuration: Duration(milliseconds: 300),
                                child: PackerNavBarPage(
                                  user: this.user,
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/packer.JPG',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

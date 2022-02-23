import 'package:page_transition/page_transition.dart';
import 'package:picker_packer/flutter_flow/flutter_flow_widgets.dart';
import 'package:picker_packer/model/packer_profile.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/pages/packer_change_password_widget.dart';
import 'package:picker_packer/pages/packer_edit_profile_widget.dart';
import 'package:picker_packer/provider/packer_profile_service.dart';
import 'package:picker_packer/provider/packer_set_active.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'login_widget.dart';

class PackerProfileWidget extends StatefulWidget {
  final UserLogin user;
  PackerProfileWidget({Key key, @required this.user}) : super(key: key);

  @override
  _PackerProfileWidgetState createState() => _PackerProfileWidgetState(user);
}

class _PackerProfileWidgetState extends State<PackerProfileWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _PackerProfileWidgetState(user) {
    this.user = user;
  }

  bool _loadingButton = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PackerProfileService packerProfileService = new PackerProfileService();
  Packer_Profile profile;

  PackerSetActive setPackerActiveService = new PackerSetActive();

  @override
  void initState() {
    super.initState();
    packerProfileService.setAccountId(user.id);
    setPackerActiveService.setAccountId(user.id);
    updateProfile();
  }

  updateProfile() async {
    profile = await packerProfileService.request();
    setState(() {});
  }

  setPackerActive() async {
    var res = await setPackerActiveService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You have successfully changed your status!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
    } else {
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You couldn\'t change your status, Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekrangenisligi = ekranbilgisi.size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0x9700ADB5),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [],
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                decoration: BoxDecoration(
                    gradient: new LinearGradient(
                  colors: [
                    Color(0xFF00ADB5),
                    Color(0xFFFACF39),
                  ],
                  stops: [0.63, 0.63],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                )),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width:
                                      MediaQuery.of(context).size.width / 4 * 3,
                                  height: 175,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 175, 0, 0),
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF521262),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: profile != null &&
                                              profile.photo != null
                                          ? profile.photo
                                          : Image.asset(
                                              'assets/images/profile.png',
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Text(
                            profile != null ? profile.name : " ",
                            style: FlutterFlowTheme.title1.override(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            'Packer',
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF00ADB5),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        profile != null ? profile.phone : " ",
                        style: FlutterFlowTheme.bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF521262),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
                    child: Text(
                      'Account Settings',
                      style: FlutterFlowTheme.bodyText1.override(
                        color: Color(0xFF00ADB5),
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0x9700ADB5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x9700ADB5),
                              offset: Offset(0, 1),
                            )
                          ],
                          shape: BoxShape.rectangle,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: PackerEditProfileWidget(
                                    user: user, profile: profile),
                              ),
                            );
                            updateProfile();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                                child: Text(
                                  'Edit Profile',
                                  style: FlutterFlowTheme.subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFFFACF39),
                                    size: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0x9700ADB5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x9700ADB5),
                              offset: Offset(0, 1),
                            )
                          ],
                          shape: BoxShape.rectangle,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child:
                                      PackerChangePasswordWidget(user: user)),
                            );
                            updateProfile();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                                child: Text(
                                  'Change Password',
                                  style: FlutterFlowTheme.subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFFFACF39),
                                    size: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: ekrangenisligi / 5),
                        child: profile != null
                            ? FFButtonWidget(
                                onPressed: () async {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: profile.is_active
                                          ? Colors.red
                                          : Color(0xFF29CA68),
                                      title: Text(
                                          profile.is_active
                                              ? "Do you approve the inactive state?\n\n(You won\'t be able to receive new orders.)"
                                              : "Do you approve the activate state?\n\n(You will be able to receive a new order.)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xFFFACF39))),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No",
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  color: Color(0xFFFACF39))),
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                        ),
                                        FlatButton(
                                          child: Text("Yes",
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  color: Color(0xFFFACF39))),
                                          onPressed: () {
                                            setPackerActiveService
                                                .setPackerActive(
                                                    !profile.is_active);
                                            setPackerActive();
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                text: profile.is_active ? 'Active' : 'Inactive',
                                options: FFButtonOptions(
                                  width: 90,
                                  height: 40,
                                  color: profile.is_active
                                      ? Color(0xFF29CA68)
                                      : Colors.red,
                                  textStyle:
                                      FlutterFlowTheme.bodyText2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.white,
                                  ),
                                  elevation: 3,
                                  borderSide: BorderSide(
                                    color: Color(0xFFFACF39),
                                    width: 1,
                                  ),
                                  borderRadius: 30,
                                ),
                                loading: _loadingButton,
                              )
                            : null,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ekrangenisligi / 8),
                        child: FFButtonWidget(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                'You have successfully log out!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF521262)),
                              ),
                              backgroundColor: Color(0xFFFACF39),
                            ));

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginWidget()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          text: 'Log Out',
                          options: FFButtonOptions(
                            width: 90,
                            height: 40,
                            color: Colors.white,
                            textStyle: FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF00ADB5),
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Color(0xFFFACF39),
                              width: 1,
                            ),
                            borderRadius: 30,
                          ),
                          loading: _loadingButton,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

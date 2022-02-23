import 'package:picker_packer/flutter_flow/flutter_flow_widgets.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/provider/picker_change_password_service.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class PickerChangePasswordWidget extends StatefulWidget {
  final UserLogin user;
  PickerChangePasswordWidget({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _PickerChangePasswordWidget createState() =>
      _PickerChangePasswordWidget(user);
}

class _PickerChangePasswordWidget extends State<PickerChangePasswordWidget> {
  UserLogin user;
  _PickerChangePasswordWidget(user) {
    this.user = user;
  }

  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController validatePasswordController =
      new TextEditingController();
  bool currentPasswordVisibility = false;
  bool newPasswordVisibility = false;
  bool validatePasswordVisibility = false;
  bool _loadingButton = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PickerChangePasswordService pickerPasswordService =
      new PickerChangePasswordService();

  @override
  void initState() {
    super.initState();
    pickerPasswordService.setAccountId(user.id);
  }

  changePassword() async {
    var res = await pickerPasswordService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'The change has been successfully saved!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'The change could not be saved!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0x98C54C82),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFFFACF39),
            size: 32,
          ),
        ),
        title: Text(
          'Change Password',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: TextFormField(
                controller: currentPasswordController,
                obscureText: !currentPasswordVisibility,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Please enter current password...',
                  hintStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: Color(0x98C54C82),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  suffixIcon: InkWell(
                    onTap: () => setState(
                      () => currentPasswordVisibility =
                          !currentPasswordVisibility,
                    ),
                    child: Icon(
                      currentPasswordVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(0xFFFACF39),
                      size: 20,
                    ),
                  ),
                ),
                style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: TextFormField(
                controller: newPasswordController,
                obscureText: !newPasswordVisibility,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Please enter new password...',
                  hintStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: Color(0x98C54C82),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  suffixIcon: InkWell(
                    onTap: () => setState(
                      () => newPasswordVisibility = !newPasswordVisibility,
                    ),
                    child: Icon(
                      newPasswordVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(0xFFFACF39),
                      size: 20,
                    ),
                  ),
                ),
                style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: TextFormField(
                controller: validatePasswordController,
                obscureText: !validatePasswordVisibility,
                decoration: InputDecoration(
                  labelText: 'Validate Password',
                  labelStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Please enter new password again...',
                  hintStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: Color(0x98FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: Color(0x98C54C82),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  suffixIcon: InkWell(
                    onTap: () => setState(
                      () => validatePasswordVisibility =
                          !validatePasswordVisibility,
                    ),
                    child: Icon(
                      validatePasswordVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(0xFFFACF39),
                      size: 20,
                    ),
                  ),
                ),
                style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: FFButtonWidget(
                onPressed: () async {
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Color(0xB3F85FA4),
                      title: Text("Are you sure to save changes?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Inter", color: Color(0xFFFACF39))),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  color: Color(0xFFFACF39))),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        FlatButton(
                          child: Text("Yes",
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  color: Color(0xFFFACF39))),
                          onPressed: () {
                            var currentPassword;
                            var newPassword;
                            var validatePassword;
                            int flag = 0;
                            currentPasswordController.text == ""
                                ? flag = 1
                                : currentPassword =
                                    currentPasswordController.text;
                            newPasswordController.text == ""
                                ? flag = 1
                                : newPassword = newPasswordController.text;
                            validatePasswordController.text == ""
                                ? flag = 1
                                : validatePassword =
                                    validatePasswordController.text;

                            if (flag == 0) {
                              if (newPassword != validatePassword) {
                                Navigator.pop(context, false);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: Duration(seconds: 4),
                                  content: Text(
                                    'New password and Validate password must be same, please check again!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        color: Color(0xFF521262)),
                                  ),
                                  backgroundColor: Color(0xFFFACF39),
                                ));
                              } else {
                                pickerPasswordService.setChanges(
                                    currentPassword, newPassword);
                                changePassword();
                                Navigator.pop(context, true);
                              }
                            } else {
                              Navigator.pop(context, false);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 4),
                                content: Text(
                                  'Please enter all text field!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF521262)),
                                ),
                                backgroundColor: Color(0xFFFACF39),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                text: 'Change Password',
                options: FFButtonOptions(
                  width: 230,
                  height: 60,
                  color: Color(0xFFFACF39),
                  textStyle: FlutterFlowTheme.subtitle2.override(
                    fontFamily: 'Lexend Deca',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  elevation: 3,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: 40,
                ),
                loading: _loadingButton,
              ),
            )
          ],
        ),
      ),
    );
  }
}

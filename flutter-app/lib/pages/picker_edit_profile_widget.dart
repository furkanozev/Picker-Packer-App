import 'dart:io';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picker_packer/flutter_flow/flutter_flow_widgets.dart';
import 'package:picker_packer/model/picker_profile.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/provider/picker_change_photo_service.dart';
import 'package:picker_packer/provider/picker_change_profile_service.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class PickerEditProfileWidget extends StatefulWidget {
  final UserLogin user;
  final Picker_Profile profile;
  PickerEditProfileWidget(
      {Key key, @required this.user, @required this.profile})
      : super(key: key);

  @override
  _PickerEditProfileWidgetState createState() =>
      _PickerEditProfileWidgetState(user, profile);
}

class _PickerEditProfileWidgetState extends State<PickerEditProfileWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  Picker_Profile profile;
  _PickerEditProfileWidgetState(user, profile) {
    this.user = user;
    this.profile = profile;
  }

  TextEditingController yourAgeController = new TextEditingController();
  TextEditingController yourEmailController = new TextEditingController();
  TextEditingController yourNameController = new TextEditingController();
  TextEditingController yourPhoneController = new TextEditingController();
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File imageFile;

  PickerChangeProfileService pickerProfileService =
      new PickerChangeProfileService();
  PickerChangePhotoService pickerPhotoService = new PickerChangePhotoService();

  @override
  void initState() {
    super.initState();
    pickerProfileService.setAccountId(user.id);
    pickerPhotoService.setAccountId(user.id);
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      var bytes = imageFile.readAsBytesSync();
      String base64Image = convert.base64Encode(bytes);
      pickerPhotoService.setChanges(base64Image);
      var res = await pickerPhotoService.request();
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
        var photo = Uint8List.fromList(bytes);
        profile.photo = Image.memory(photo);
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
    }
    setState(() {});
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      var bytes = imageFile.readAsBytesSync();
      String base64Image = convert.base64Encode(bytes);
      pickerPhotoService.setChanges(base64Image);
      var res = await pickerPhotoService.request();
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
        var photo = Uint8List.fromList(bytes);
        profile.photo = Image.memory(photo);
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
    }
    setState(() {});
  }

  /// Get from Camera
  _removePhoto() async {
    pickerPhotoService.setChanges(null);
    var res = await pickerPhotoService.request();
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
      profile.photo = null;
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

  changeProfile() async {
    var res = await pickerProfileService.request();
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
      profile.name = pickerProfileService.name;
      profile.email = pickerProfileService.email;
      profile.age = pickerProfileService.age;
      profile.phone = pickerProfileService.phone;
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
            'Edit Profile',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(0x98C54C82),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: profile != null && profile.photo != null
                        ? profile.photo
                        : Image.asset(
                            'assets/images/profile.png',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Color(0x98C54C82),
                              title: Text('Choose option',
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFFFACF39))),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _getFromCamera();
                                        Navigator.pop(context, true);
                                      },
                                      splashColor: Color(0xFFFACF39),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.camera,
                                              color: Color(0xFFFACF39),
                                            ),
                                          ),
                                          Text('Camera',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: Color(0xFFFACF39)))
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _getFromGallery();
                                        Navigator.pop(context, true);
                                      },
                                      splashColor: Color(0xFFFACF39),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.image,
                                              color: Color(0xFFFACF39),
                                            ),
                                          ),
                                          Text('Gallery',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: Color(0xFFFACF39)))
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _removePhoto();
                                        Navigator.pop(context, true);
                                      },
                                      splashColor: Color(0xFFFACF39),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Color(0xFFFACF39),
                                            ),
                                          ),
                                          Text('Remove',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Inter",
                                                  color: Color(0xFFFACF39)))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    text: 'Change Photo',
                    options: FFButtonOptions(
                      width: 140,
                      height: 40,
                      color: Color(0xFFFACF39),
                      textStyle: FlutterFlowTheme.bodyText2,
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: 8,
                    ),
                    loading: _loadingButton1,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: yourNameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: profile != null ? profile.name : "Your Name",
                      labelStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                      ),
                      hintText: 'Please enter your name...',
                      hintStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0x98FFFFFF),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color(0x98C54C82),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                    ),
                    style: FlutterFlowTheme.bodyText1.override(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: yourEmailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText:
                          profile != null ? profile.email : "Email Address",
                      labelStyle: FlutterFlowTheme.bodyText1.override(
                          fontFamily: 'Lexend Deca', color: Colors.white),
                      hintText: 'Please enter a valid email address...',
                      hintStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0x98FFFFFF),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color(0x98C54C82),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                    ),
                    style: FlutterFlowTheme.bodyText1.override(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: yourAgeController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText:
                          profile != null ? profile.age.toString() : "Your Age",
                      labelStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                      ),
                      hintText: 'i.e. 34',
                      hintStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0x98FFFFFF),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color(0x98C54C82),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                    ),
                    style: FlutterFlowTheme.bodyText1.override(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: yourPhoneController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText:
                          profile != null ? profile.phone : "Phone Number",
                      hintText: 'Please enter a valid phone number...',
                      hintStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Color(0x98FFFFFF),
                      ),
                      labelStyle: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color(0x98C54C82),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                    ),
                    style: FlutterFlowTheme.bodyText1.override(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                    ),
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
                                  fontFamily: "Inter",
                                  color: Color(0xFFFACF39))),
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
                                var name;
                                var email;
                                var age;
                                var phone;
                                yourNameController.text == ""
                                    ? name = profile.name
                                    : name = yourNameController.text;
                                yourEmailController.text == ""
                                    ? email = profile.email
                                    : email = yourEmailController.text;
                                yourAgeController.text == ""
                                    ? age = profile.age.toString()
                                    : age = yourAgeController.text;
                                yourPhoneController.text == ""
                                    ? phone = profile.phone
                                    : phone = yourPhoneController.text;

                                if (EmailValidator.validate(email)) {
                                  pickerProfileService.setChanges(
                                      name, email, age, phone);
                                  changeProfile();
                                  Navigator.pop(context, true);
                                } else {
                                  Navigator.pop(context, false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 4),
                                    content: Text(
                                      'Please enter valid email address!',
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
                    text: 'Save Changes',
                    options: FFButtonOptions(
                      width: 230,
                      height: 56,
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
                      borderRadius: 30,
                    ),
                    loading: _loadingButton2,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

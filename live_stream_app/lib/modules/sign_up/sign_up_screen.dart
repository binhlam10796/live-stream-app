import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/modules/sign_up/model/sign_up_request.dart';
import 'package:live_stream_app/widgets/custom_app_bar.dart';
import 'package:live_stream_app/widgets/custom_shape.dart';
import 'package:live_stream_app/widgets/custom_text_form_field.dart';
import 'package:live_stream_app/widgets/responsive_ui.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  File? _imageFile;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is UploadImageLoadingState) {
          const CircularProgressIndicator();
        } else if (state is UploadImageErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign up failure')));
        } else if (state is UploadImageSuccessState) {
          if (state.fileID.isEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Sign up failure')));
          } else {
            String fileID =
                state.fileID.substring(state.fileID.indexOf(":") + 1).trim();
            SignUpRequest signUpRequest = SignUpRequest(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                birthDay: birthdayController.text,
                address: addressController.text,
                email: emailController.text,
                username: usernameController.text,
                password: passwordController.text,
                file: fileID,
                role: ["user", "mod"]);
            BlocProvider.of<SignUpBloc>(context)
                .add(SignUpSubmitted(signUpRequest: signUpRequest));
          }
        }

        if (state is SignUpLoadingState) {
          const CircularProgressIndicator();
        } else if (state is SignUpErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is SignUpSuccessState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign in Successful')));
          Navigator.of(context).pop();
        }
      },
      child: Material(
        child: Scaffold(
          body: Container(
            height: _height,
            width: _width,
            margin: const EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Opacity(opacity: 0.88, child: CustomAppBar()),
                  clipShape(),
                  form(),
                  acceptTermsTextRow(),
                  SizedBox(
                    height: _height / 35,
                  ),
                  button(),
                  infoTextRow(),
                  socialIconsRow(),
                  //signInTextRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.square],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Choose a picture',
          toolbarColor: Colors.pinkAccent,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Choose a picture',
          aspectRatioLockEnabled: true,
        ));
    setState(() {
      _imageFile = croppedImage;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
    _cropImage();
  }

  Future<void> _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.image,
                        size: 30,
                        color: Colors.pinkAccent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        _imageFile == null
            ? Container(
                height: _height / 5.5,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 10.0),
                        blurRadius: 20.0),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Adding photo');
                      }
                      _showOptionsDialog(context);
                    },
                    child: Icon(
                      Icons.add_a_photo,
                      size: _large ? 40 : (_medium ? 33 : 31),
                      color: Colors.orange[200],
                    )),
              )
            : Center(
                child: CircleAvatar(
                  radius: (_height / 5.5) / 2,
                  backgroundImage: FileImage(
                    _imageFile!,
                  ),
                ),
              ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            birthdayTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            userNameTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      textEditingController: firstNameController,
      inputType: InputType.text,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      textEditingController: lastNameController,
      inputType: InputType.text,
      icon: Icons.person,
      hint: "Last Name",
    );
  }

  Widget birthdayTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.datetime,
      textEditingController: birthdayController,
      inputType: InputType.text,
      icon: Icons.date_range,
      hint: "Birthday",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      textEditingController: addressController,
      inputType: InputType.text,
      icon: Icons.location_city,
      hint: "Address",
    );
  }

  Widget emailTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      inputType: InputType.email,
      icon: Icons.email,
      hint: "Email",
    );
  }

  Widget userNameTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      textEditingController: usernameController,
      inputType: InputType.text,
      icon: Icons.account_circle_rounded,
      hint: "Username",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      textEditingController: passwordController,
      inputType: InputType.text,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (newValue) {
                setState(() {
                  checkBoxValue = newValue as bool;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (kDebugMode) {
          print("Routing to your account");
        }
        if (_key.currentState!.validate()) {
          if (_imageFile != null) {
            BlocProvider.of<SignUpBloc>(context)
                .add(UploadImage(imageFile: _imageFile!));
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Invalid image')));
          }
        }
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200]!, Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/googlelogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/fblogo.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(signIn);
              if (kDebugMode) {
                print("Routing to Sign up screen");
              }
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  void _clearImage() {
    _imageFile = null;
  }

  @override
  void dispose() {
    _clearImage();
    super.dispose();
  }
}

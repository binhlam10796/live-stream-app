import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:live_stream_app/modules/sign_up/bloc/sign_up_bloc.dart';
import 'package:live_stream_app/modules/sign_up/model/sign_up_request.dart';
import 'package:live_stream_app/modules/stream/model/stream_request.dart';
import 'package:live_stream_app/widgets/custom_app_bar.dart';
import 'package:live_stream_app/widgets/custom_shape.dart';
import 'package:live_stream_app/widgets/custom_text_form_field.dart';
import 'package:live_stream_app/widgets/responsive_ui.dart';

import 'bloc/stream_bloc.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
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
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is UploadImageLoadingState) {
              const CircularProgressIndicator();
            } else if (state is UploadImageErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Created new stream failure')));
            } else if (state is UploadImageSuccessState) {
              if (state.fileID.isEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('Created new stream failure')));
              } else {
                String fileID = state.fileID
                    .substring(state.fileID.indexOf(":") + 1)
                    .trim();
                StreamRequest streamRequest = StreamRequest(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  birthDay: birthdayController.text,
                  address: addressController.text,
                  email: emailController.text,
                  title: titleController.text,
                  content: contentController.text,
                  file: fileID,
                  userId: userID,
                );
                BlocProvider.of<StreamBloc>(context)
                    .add(UploadStream(streamRequest: streamRequest));
              }
            }
          },
        ),
        BlocListener<StreamBloc, StreamState>(
          listener: (context, state) {
            if (state is UploadStreamLoadingState) {
              const CircularProgressIndicator();
            } else if (state is UploadStreamErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is UploadStreamSuccessState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Created new stream Successful')));
              if (roles.contains('ROLE_ADMIN')) {
                BlocProvider.of<DashboardBloc>(context)
                    .add(FetchAllStream());
              } else {
                BlocProvider.of<DashboardBloc>(context)
                    .add(FetchStreamByUser(userID: userID));
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
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
                  SizedBox(
                    height: _height / 35,
                  ),
                  button(),
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
      textEditingController: titleController,
      inputType: InputType.text,
      icon: Icons.title,
      hint: "Title",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      textEditingController: contentController,
      inputType: InputType.text,
      icon: Icons.content_paste,
      hint: "Content",
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
        width: _large ? _width / 1.5 : (_medium ? _width / 1.25 : _width / 1.15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200]!, Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'CREATE NEW STREAM REQUEST',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
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

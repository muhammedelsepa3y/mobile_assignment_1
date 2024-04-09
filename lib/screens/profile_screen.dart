import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/flush_bar.dart';
import '../services/desk_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  dynamic user;

  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    studentIdController = TextEditingController(text: widget.user['studentId']);
    isMale = widget.user['isMale'];
    selectedLevel = widget.user['level'];
    imagePath = widget.user['imagePath'];
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  bool? isMale;
  int? selectedLevel;
  List<int>levels=[1,2,3,4];
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Choose an option'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Camera'),
                                onTap: () async {
                                  var pickedFile = await _picker.pickImage(
                                    source: ImageSource.camera,
                                  );
                                  if (pickedFile != null) {
                                    String? path = await DeskStorage().saveImageToFileSystem(pickedFile);
                                    setState(() {
                                      imagePath = path;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('Gallery'),
                                onTap: () async {
                                  var pickedFile = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    String? path = await DeskStorage().saveImageToFileSystem(pickedFile);
                                    setState(() {
                                      imagePath = path;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: (imagePath!=null)? FileImage(File(imagePath!)):null,
                    child:(imagePath!=null)? null:Icon(Icons.person,size: 60,)
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: studentIdController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student ID';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        leading: Radio<bool>(
                          value: true,
                          groupValue: isMale,
                          onChanged: (value) {
                            setState(() {
                              isMale = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio<bool>(
                          value: false,
                          groupValue: isMale,
                          onChanged: (value) {
                            setState(() {
                              isMale = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedLevel,
                  items: levels.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLevel = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      DeskStorage deskStorage = DeskStorage();
                      var result =await deskStorage.updateProfile(
                        nameController.text,
                        isMale,
                        studentIdController.text,
                        selectedLevel,
                        widget.user['email'],
                        imagePath,
                      );
                      if (result!= null) {
                        showFlushBar('Profile updated', isError: false);
                      }
                    }
                  },
                  child: const Text('Update'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                  },
                  child: const Text('Logout'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

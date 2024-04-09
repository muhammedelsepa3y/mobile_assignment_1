import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DeskStorage  {
  register(String name,String password,bool? isMale,String email,String studentId,int? level) async {
    await EasyLoading.show(status: 'loading...');
    var hive = await Hive.openBox('Auth');
    List<dynamic> users = hive.get('users', defaultValue: []);
    for (var user in users) {
      if (user['email'] == email) {
        await EasyLoading.dismiss();
        return 'Email already exists';
      }
      if (user['studentId'] == studentId) {
        await EasyLoading.dismiss();
        return 'Student ID already exists';
      }
    }
    users.add({
      'name': name,
      'password': password,
      'isMale': isMale,
      'email': email,
      'studentId': studentId,
      'level': level
    });
    await hive.put('users', users);
    await EasyLoading.dismiss();
    return null;
  }



  login (String email,String password) async {
    await EasyLoading.show(status: 'loading...');
    var hive = await Hive.openBox('Auth');
    List<dynamic> users = hive.get('users', defaultValue: []);
    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        await EasyLoading.dismiss();
        return user;
      }
    }
    await EasyLoading.dismiss();
    return null;
  }
  Future<String?> saveImageToFileSystem(XFile pickedFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(pickedFile.path);
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pickedFile.readAsBytes());
    return file.path;
  }
  updateProfile(String name, bool? isMale, String studentId, int? selectedLevel, email,imgPath)async {
    await EasyLoading.show(status: 'loading...');
    var hive = await Hive.openBox('Auth');
    List<dynamic> users = hive.get('users', defaultValue: []);
    for (var user in users) {
      if (user['email'] == email) {
        user['name'] = name;
        user['isMale'] = isMale;
        user['studentId'] = studentId;
        user['level'] = selectedLevel;
        user['imagePath'] = imgPath;
        await hive.put('users', users);
        await EasyLoading.dismiss();
        return user;
      }
    }
    await EasyLoading.dismiss();
    return null;

  }

}

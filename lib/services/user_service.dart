import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  /// SAVE USER TO FIRESTORE

  Future<void> saveUser(UserModel user) async {
    await _firestore
        .collection("users")
        .doc(user.uid)
        .set(user.toMap());
  }

  /// GET USER DATA
 
  Future<UserModel?> getUser(String uid) async {
    final doc =
        await _firestore.collection("users").doc(uid).get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

 
  /// UPDATE USER

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection("users")
        .doc(user.uid)
        .update(user.toMap());
  }
}

/// photo

Future<String> uploadProfileImage(String uid, File imageFile) async {
  final ref = FirebaseStorage.instance
      .ref()
      .child('profile_images')
      .child('$uid.jpg');

  await ref.putFile(imageFile);

  return await ref.getDownloadURL();
}
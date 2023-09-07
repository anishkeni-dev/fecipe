import 'package:fecipe/dashboard/dashboard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../data_models/usermodel.dart';
import '../../repository/user_repository.dart';
import 'editprofile_events.dart';
import 'editprofile_states.dart';

class EditProfileBloc extends Bloc<EditProfileEvents, EditProfileStates> {
  final userRepo = UserRepository();
  EditProfileBloc() : super(DataLoadingState()) {

    //gets userdata from firebase
    on<UserDataRequested>((event, emit) async {
      try {
        //getusername

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userid = prefs.getString('userId');
        UserModel user = await userRepo.getUserData(userid!);
        emit(DataLoadedState(user));

      } catch (e) {
        emit(DataErrorState(e.toString()));
        // print(e.toString());
      }
    });

    //updates changes made by user to firebase
    on<UserDataUpdate>((event, emit) async {
      try {
        //getusername
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userid = prefs.getString('userId');
        UserModel user = await userRepo.updateData(event.user,userid,"Your details have been Updated");


        emit(DataLoadedState(user));

      } catch (e) {
        emit(DataErrorState(e.toString()));
        // print(e.toString());
      }
    });
    on<ProfilePictureUpload>((event,emit) async {
      try{

       await showModalBottomSheet(
            context: appContext,
            builder: (context) =>
                showSelectionDialog(event.imageUrl));
      } catch (e) {
        emit(DataErrorState(e.toString()));
        // print(e.toString());
      }
    });

  }

showSelectionDialog(imgUrl) {
  return SizedBox(
    height: 100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () async {
           await uploadPicture(imgUrl,ImageSource.camera);
          },
          icon: const Icon(
            Icons.camera_alt_outlined,
          ),
          label: const Text(
            'Click a picture now',
          ),
        ),
        TextButton.icon(
          onPressed: () async {
           await uploadPicture(imgUrl,ImageSource.gallery);
          },
          icon: const Icon(Icons.image),
          label: const Text(
            'Choose from gallery',
          ),
        )
      ],
    ),
  );
}

uploadPicture(imageUrl,ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if(appContext.mounted) {
    showDialog(
      context: appContext,
      builder: (context) {
        return AlertDialog(
          title: const Text("Do you want to save the picture?"),
          actions: [
            TextButton(
              onPressed: () async {
                if (file == null) return;
                final SharedPreferences prefs =
                await SharedPreferences.getInstance();
                final String? userid = prefs.getString('userId');
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages =
                referenceRoot.child('profile_images');
                Reference referenceImageToUpload =
                referenceDirImages.child(userid!);
                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  // print(imageUrl);
                } catch (error) {
                  debugPrint(error.toString());
                }
                //update

                UserModel userdata = await userRepo.getUserData(userid);
                var user = UserModel(
                    username: userdata.username,
                    email: userdata.email,
                    pfp: imageUrl);
                userRepo.updateData(user,userid,"Your Profile picture has been Updated");
                emit(DataLoadingState());
                if(context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }

                emit(DataLoadedState(user));

              },
              child: const Text(
                "YES",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                "NO",
              ),
            ),
          ],
        );
      },
    );
  }
}
}
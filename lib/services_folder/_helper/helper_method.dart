import 'package:ff_driver/models_folder/user_data.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HelperMethod {
  //Get user Information
  static void getcurrentUserInfo() async {
    currentuser = await FirebaseAuth.instance.currentUser();
    String uid = currentuser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('drivers/$uid');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentUserinfo = UserData.fromSnapshot(snapshot);
        print('HELOOO MY NAME ISSSSSS>>>>>>>>>>>>>>>>>>>' +
            currentUserinfo.fullname);
      }
    });
  }
}

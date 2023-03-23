import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
class AuthController{


  signUpUsers(String firstName,String lastName, String email, String password,)async{
    String res = 'some error occurred';
    try{
      if(firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
        UserCredential cred =  await _auth.createUserWithEmailAndPassword(email: email, password: password);

        await _firestore.collection('Users').doc(cred.user!.uid).set({
          'first name': firstName,
          'last name': lastName,
          'email': email,
          'password': password,
          'scores':[],

        });
        res = 'success';
      }else{
        res = 'please fill in all fields';
        print('please fields must not be empty');
      }
    }catch(e){
      res = e.toString();
      print(res);
    }
    return res;
  }

  loginUsers(String email, String password)async{
    String res = 'Some error Occurred';
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      }else{
        res = 'input all fields';
      }
    }catch(e){
      res = e.toString();
    }
    return res;
  }
}
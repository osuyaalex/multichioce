import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClosingScreen extends StatefulWidget {
   ClosingScreen({Key? key}) : super(key: key);

  @override
  State<ClosingScreen> createState() => _ClosingScreenState();
}

class _ClosingScreenState extends State<ClosingScreen> {
  Map<String, dynamic> users ={};
  bool _selected = true;
  getDataFromFirestore()async{
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      Map<String, dynamic> creatorData = userDoc.data()!as Map<String, dynamic>;
      users = creatorData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirestore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Lets see how you did',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            Text('${users['firstName']} ${users['lastName']}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _selected = !_selected;
                });
              },
              child: AnimatedContainer(
                width: _selected ? 100.0 : 130.0,
                height: _selected ? 50.0 : 130.0,
                decoration: BoxDecoration(
                    color: _selected ? Colors.black : users['scores'] <= 4?Colors.red:Colors.green,
                  borderRadius: BorderRadius.circular(25)
                ),
                // alignment:
                // _selected ? Alignment.center : AlignmentDirectional.topCenter,
                duration: const Duration(seconds: 3),
                curve: Curves.bounceOut,
                child: _selected?const Center(
                  child: Text('Tap Here!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ):users['scores'] <=4?Center(child: Text('${users['scores']}/10 \n you can do better',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                )):
                Center(child: Text('${users['scores']}/10 \n So much potential!',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ))
              ),
            ),
          ],
        ),
      )
    );
  }
}

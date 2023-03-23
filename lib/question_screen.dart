import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/generate_questions.dart';

import 'model/mcq.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _mcqsUploaded = false;
  Map<String, dynamic> users ={};


  void deleteFieldValue() async {
    // Get a reference to the document you want to update
    final documentReference = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the field with the delete method
    await documentReference.update({
      'scores': 0,
    });
  }



  final Stream<QuerySnapshot> _mcqs = FirebaseFirestore.instance.collection('MCQs').snapshots();
  void uploadMCQs() async{
    List<MCQ> mcqs = [
      MCQ(
        question: 'What is the capital of France?',
        choices: ['London', 'Paris', 'Rome', 'Madrid'],
        answerIndex: 1, explanation: 'The capital of france is paris',
      ),

      MCQ(
        question: 'What is the largest organ in the human body?',
        choices: ['Liver', 'Heart', 'Lungs', 'Skin'],
        answerIndex: 3, explanation: 'The largest organ is the skin',
      ),
      MCQ(
        question: 'What is the highest mountain in the world?',
        choices: ['Mount Kilimanjaro', 'Mount Everest', 'Mount Fuji', 'Mount Rushmore'],
        answerIndex: 1, explanation: 'mount everest',
      ),
      MCQ(
        question: 'What is the largest country by area?',
        choices: ['Russia', 'Canada', 'China', 'United States'],
        answerIndex: 0,
        explanation: 'The largest country by area is russia',
      ),

      MCQ(
        question: 'What is the smallest country in the world?',
        choices: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
        answerIndex: 1,
        explanation: 'The smallest country in the world is vatican city',
      ),
      MCQ(
        question: 'What is the currency of Japan?',
        choices: ['Yuan', 'Euro', 'Yen', 'Dollar'],
        answerIndex: 2,
        explanation: 'The currency of japan is yen',
      ),

      MCQ(
        question: 'What is the longest river in the world?',
        choices: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
        answerIndex: 1,
        explanation: 'The longest river in the world is nile',
      ),
      MCQ(
        question: 'What is the hottest continent on Earth?',
        choices: ['North America', 'Asia', 'Africa', 'South America'],
        answerIndex: 2,
        explanation: 'The hottest continent on earth is Africa',
      ),

      MCQ(
        question: 'What is the largest planet in the solar system?',
        choices: ['Mars', 'Jupiter', 'Venus', 'Saturn'],
        answerIndex: 1,
        explanation: 'The largest planet in the solar system is jupiter',
      ),
      MCQ(
        question: 'What is the capital of South Africa?',
        choices: ['Cape Town', 'Johannesburg', 'Durban', 'Pretoria'],
        answerIndex: 3,
        explanation: 'The Capital of South Africa is Capetown',
      ),
    ];
    CollectionReference mcqCollection = FirebaseFirestore.instance.collection('MCQs');
    QuerySnapshot querySnapshot = await mcqCollection.get();
    if (querySnapshot.docs.length > 0) {
      print('The collection exists');
    } else {
      mcqs.forEach((mcq) {
        mcqCollection.add(mcq.toMap());
      });
    }

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_mcqsUploaded) {
      uploadMCQs();
      _mcqsUploaded = true;
    }
    deleteFieldValue();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _mcqs,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      List<MCQ> mcqs = [];
      snapshot.data!.docs.forEach((doc) {
        MCQ mcq = MCQ(
          question: doc['question'],
          choices: List<String>.from(doc['choices']),
          answerIndex: doc['answerIndex'],
          explanation: doc['explanation'],
        );
        mcqs.add(mcq);
      });


      return GenerateQuestions(mcqs: mcqs);

    },
      ),

    );
  }
}

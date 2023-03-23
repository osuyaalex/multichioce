import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/closing_screen.dart';
import 'model/mcq.dart';

class GenerateQuestions extends StatefulWidget {
  final List<MCQ> mcqs;
  const GenerateQuestions({Key? key, required this.mcqs}) : super(key: key);

  @override
  State<GenerateQuestions> createState() => _GenerateQuestionsState();
}

class _GenerateQuestionsState extends State<GenerateQuestions> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
   Timer? _timer;
  int _start = 30;
  int? selectedValue;





  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
            if (_start == 0) {
              setState(() {
                restartTimer();
                if (_currentPageIndex < widget.mcqs.length - 1) {
                  _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                  _currentPageIndex++;
                } else {// If the last page is reached, cancel the timer
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return  ClosingScreen();
                  }));
                }
              });
            }else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  void restartTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
   setState(() {
     _start = 30;
   });
    startTimer();
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    _pageController.addListener(() {
      setState(() {
        selectedValue = null;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40),
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.mcqs.length,
        controller: _pageController,
        itemBuilder: (context, index) {
          final mcq = widget.mcqs[index];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question ${index + 1}: ${mcq.question}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: mcq.choices
                      .asMap()
                      .entries
                      .map((entry) => RadioListTile(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: selectedValue,
                    toggleable: false,
                    onChanged: (v)async{
                      setState(() {
                        selectedValue = v!;
                        if(v == mcq.answerIndex){
                          DocumentReference scoresDoc =   FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid);
                          FirebaseFirestore.instance.runTransaction((transaction) async{
                            DocumentSnapshot snapshot = await transaction.get(scoresDoc);
                            int newScore = snapshot.get('scores') +1;
                            transaction.update(scoresDoc, {'scores': newScore});
                          });
                          _currentPageIndex++;
                          restartTimer();
                          _pageController.animateToPage(
                            _currentPageIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Correct!'),
                                duration: Duration(seconds: 1),
                              )
                          );

                        }else{
                          _currentPageIndex++;
                          restartTimer();
                          _pageController.animateToPage(
                            _currentPageIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(mcq.explanation),
                                duration: const Duration(seconds: 2),
                              )
                          );

                        }
                      });
                    },
                    //activeColor: Colors.blue,
                  )

                  )
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        restartTimer();
                        if (_currentPageIndex < widget.mcqs.length -1) {
                          _currentPageIndex++;
                          _pageController.animateToPage(
                            _currentPageIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return  ClosingScreen();
                          }));

                        }
                      },
                      child: Text('Next'),
                    ),
                    Text(_start.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

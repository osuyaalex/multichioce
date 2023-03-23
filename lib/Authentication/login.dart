
import 'package:flutter/material.dart';
import 'package:multichoice/Authentication/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/snackBar.dart';
import '../question_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  int? v;
  bool _wait = false;
  bool _obscurePassword = true;
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  login() async{
    setState(() {
      _wait = true;
    });
   if(_globalKey.currentState!.validate()){
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('email', _email.text);
     await prefs.setString('password', _password.text);
     String res = await _authController.loginUsers(
         _email.text,
         _password.text
     );
     setState(() {
       _wait = false;
     });
     if(res != 'Success'){
       return snackBar(res, context);
     }else{
       return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
         return const QuestionScreen();
       }));

   }

    }else{
     setState(() {
       _wait = false;
     });
   }
  }
  loadFormData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    setState(() {
      _email.text = email!;
      _password.text = password!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFormData();
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Good To See You',
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (v){
                  if(v!.isEmpty){
                    return 'Please input email';
                  }
                },
                controller: _email,
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    hintText: 'input Email Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black
                        )
                    )
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (v){
                  if(v!.isEmpty){
                    return 'Please input password';
                  }
                },
               controller: _password,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword ? Icon(Icons.visibility):
                        Icon(Icons.visibility_off)
                    ),
                    focusColor: Colors.black,
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    hintText: 'input Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black
                        )
                    )
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width*0.4,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: GestureDetector(
                  onTap: (){
                    login();
                  },
                  child:  Center(
                    child: _wait? const CircularProgressIndicator(color: Colors.white,)
                        :const Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children:  [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Don\'t have an account?',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return SignUpScreen();
                      }));
                    },
                    child: const Text('Signup',

                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

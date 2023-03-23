import 'package:flutter/material.dart';
import 'package:multichoice/controllers/auth_controller.dart';
import 'package:multichoice/controllers/snackBar.dart';

import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _wait = false;
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    signupUsers()async{
      setState(() {
        _wait = true;
      });
      if(_globalKey.currentState!.validate()){
        String res = await _authController.signUpUsers(
            _firstName,
            _lastName,
            _email,
            _password
        );
        setState(() {
          _wait = false;
        });
        if(res != 'success'){

          return snackBar(res, context);
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return LoginScreen();
          }));
        }
      }else{
        setState(() {
          _wait = false;
        });
      }
    }
    return Form(
      key: _globalKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Welcome',
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(
                height: 55,
              ),
              TextFormField(
                validator: (v){
                  if(v!.isEmpty){
                    return 'Input first Name';
                  }
                },
                onChanged: (v){
                 _firstName = v;
                },
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    labelText: 'First name',
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    hintText: 'input first name',
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
                    return 'Input last Name';
                  }
                },
               onChanged: (v){
                 _lastName = v;
               },
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    labelText: 'Last name',
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    hintText: 'input last name',
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
                    return 'Input email';
                  }
                },
                onChanged: (v){
                  _email = v;
                },
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
                    return 'Input password';
                  }
                },
                onChanged: (v){
                  _password = v;
                },
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
                    signupUsers();
                  },
                  child:  Center(
                    child: _wait? const CircularProgressIndicator(color: Colors.white,)
                        :const Text('Sign Up',
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
                    child: Text('Already have an account ?',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const LoginScreen();
                      }));
                    },
                    child: const Text('Login',

                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

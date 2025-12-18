import 'dart:async';
import 'dart:ui';
import "package:one_pay/api/signlog_calls.dart";
import 'package:flutter/material.dart';
import 'package:one_pay/screens/home.dart';

class SignLog extends StatefulWidget {
  @override
  State<SignLog> createState() => _SignLog();
}

class _SignLog extends State<SignLog> {
  bool isLogin=true;
  final _formKey = GlobalKey<FormState>();
  String? _autoLoginInput;
  final fullNameC = TextEditingController();
  final businessC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passwordC = TextEditingController();
  final loginInputC = TextEditingController();
  void dispose(){
    fullNameC.dispose();
    businessC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    loginInputC.dispose();
    super.dispose();
  }
  void _clearFields() {
    fullNameC.clear();
    businessC.clear();
    emailC.clear();
    phoneC.clear();
    loginInputC.clear();
    passwordC.clear();
  }
  
  Future<void> _handleSignUp() async{
    final email =emailC.text.trim().isEmpty ? null : emailC.text.trim();
    final phone =phoneC.text.trim();
    final res= await SignlogCalls.signUp(fullName: fullNameC.text.trim(), 
        businessName: businessC.text.trim(),
        email: email,
        phoneNumber: phone,
        password: passwordC.text.trim());
    print(res);
    if(res['success']==true){
      setState(() {
        isLogin=true;
        loginInputC.text=phoneC.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-Up Successful. Please login")));
    }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Sign-Up failed')));
      }
  }
  Future<void> _handleLogin({bool autoLogin=false}) async{
    
    final loginInput= autoLogin? _autoLoginInput : loginInputC.text.trim();
    
    if(loginInput==null || loginInput.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login input ')));
    }
    final res= await SignlogCalls.login(loginInput: loginInputC.text.trim(), password: passwordC.text.trim());
    print(res);
    if(res['success']==true){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));
      //merchantId
      final int merchantId = res['id'];
      print(merchantId);
      _clearFields();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home(merchantId: merchantId,)));
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Login failed')));
    }
  }
  
  Widget _authToggle(String text, bool active, VoidCallback onTap){
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    ));
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Row(
                  children: [
                    _authToggle('Login', isLogin,(){
                    setState(() {isLogin=true;
                        _formKey.currentState?.reset();
                    _clearFields();
                    });
                    }),
            _authToggle('Sign Up', !isLogin,(){
        setState(() {isLogin=false;
            _formKey.currentState?.reset();
        _clearFields();
            });
        }),
                  ]),
        )  ,
              if(!isLogin)
            SizedBox(height: 20,),
            if(!isLogin)
            TextFormField(controller: fullNameC,
              decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                  )
              ),
              validator: (v){
                if(v==null || v=="")
                  return "Enter full name";
                return null;
              },
            ),
              if(!isLogin)
                SizedBox(height: 20),
              if(!isLogin)
                TextFormField(controller: businessC,
                  decoration: InputDecoration(
                      labelText: 'Business Name',
                      border: OutlineInputBorder(
                      )
                  ),
                  validator: (v){
                    if(v==null || v=="")
                      return "Enter business name";
                    return null;
                  },
                ),
              if(!isLogin)
              SizedBox(height: 20),
              if(!isLogin)
              TextFormField(controller: emailC,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                  ),
                ),
                validator: (v){
                  if(v==null || v=="")
                    return "Enter your email";
                  if(!(v.contains('@')))
                    return "Invalid Email";
                  return null;
                },
              ),
              if(!isLogin)
              SizedBox(height: 20),
              if(!isLogin)
              TextFormField(controller: phoneC,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                  ),
                ),
                validator: (v){
                  if(v==null || v=="")
                    return "Enter Your Phone No.";
                  if(v.length!=10)
                    return "Invalid Phone No.";
                  return null;
                },
              ),
              if(isLogin)
              SizedBox(height: 20),
              if(isLogin)
                TextFormField(
                  controller: loginInputC,
                  decoration: InputDecoration(
                    labelText: 'Email or Phone No.',
                    border: OutlineInputBorder()
                  ),
                  validator: (v){
                    if(v==null || v=="")
                      return "Enter your email or phone no.";
                    return null;
                  },
                ),
              SizedBox(height: 20),
              TextFormField(controller: passwordC,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                  ),
                ),
                validator: (v){
                  if(v==null || v=="")
                    return "Enter Your Password";
                  if(v.length<6)
                    return "Minimum 6 characters";
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () async{
                if(_formKey.currentState!.validate()){
                  if(isLogin){
                    await _handleLogin();
                  }
                  else
                    {
                      await _handleSignUp();
                    }
                }

              }, child: Text(isLogin? "Login" : "Sign Up")),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

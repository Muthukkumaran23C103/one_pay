import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignLog extends StatefulWidget {
  @override
  State<SignLog> createState() => _SignLog();
}

class _SignLog extends State<SignLog> {
  bool isLogin=true;
  final _formKey = GlobalKey<FormState>();

  final fullNameC = TextEditingController();
  final businessC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passwordC = TextEditingController();
  void dispose(){
    fullNameC.dispose();
    businessC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    super.dispose();
  }
  void _clearFields() {
    fullNameC.clear();
    businessC.clear();
    emailC.clear();
    phoneC.clear();
    passwordC.clear();
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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
                  if(v!.length<6)
                    return "Minimum 6 characters";
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () async{
                if(_formKey.currentState!.validate()){
                  if(isLogin){
                    //login api
                  }
                  else
                    {
                      //signup api
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
 /* Future<void> substd() async{
    final url= Uri.parse("http://localhost:44300/api/AttendanceApp/InsertStu/");
    final body={
      "name" : nc.text,
      "email" : ec.text,
      "gender" : gender,
      "dob" : "${dob!.year}-${dob!.month}-${dob!.day}",
      "course":course
    };

    var c=jsonEncode(body);
    print("API RESPONSE : ${c}");
    final res= await http.post(
      url,
      headers: {
        "Content-Type": "application/json",  // tell API we are sending JSON
      },
      body: jsonEncode(body),
    );
    print("API RESPONSE : ${res.body}");
  }*/
}

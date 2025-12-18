import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ------------------- API Function -------------------
Future<String> addMerchantBankAccount(
    int merchantId,
    String accountHolderName,
    String accountNumber,
    String ifsccode,
    String bankName) async {

  final url = Uri.parse(
      "https://localhost:44395/api/MerchantAccount/AddMechantBankAccount");

  final RequestBody = jsonEncode({
    "merchantId": merchantId,
    "accountHolderName": accountHolderName,
    "accountNumber": accountNumber,
    "ifsccode": ifsccode,
    "bankName": bankName
  });

  final RequestHeaders = {"Content-Type": "application/json"};

  final Response = await http.post(
    url,
    headers: RequestHeaders,
    body: RequestBody,
  );

  return Response.body;
}

// ------------------- Widget -------------------
class RegisterBankAccount extends StatefulWidget {
  @override
  _RegisterBankAccountState createState() => _RegisterBankAccountState();
}

class _RegisterBankAccountState extends State<RegisterBankAccount> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _merchantIdController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  String _responseMessage = "";
  bool _isLoading = false;

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Register Bank Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                // Merchant ID
                TextFormField(
                  controller: _merchantIdController,
                  keyboardType: TextInputType.number,
                  decoration: _inputStyle("Merchant ID"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Merchant ID";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Account Holder Name
                TextFormField(
                  controller: _accountHolderController,
                  decoration: _inputStyle("Account Holder Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter account holder name";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Account Number
                TextFormField(
                  controller: _accountNumberController,
                  decoration: _inputStyle("Account Number"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter account number";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // IFSC Code
                TextFormField(
                  controller: _ifscController,
                  decoration: _inputStyle("IFSC Code"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter IFSC code";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Bank Name
                TextFormField(
                  controller: _bankNameController,
                  decoration: _inputStyle("Bank Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter bank name";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        int merchantId = int.parse(
                            _merchantIdController.text.trim());

                        try {
                          String response =
                          await addMerchantBankAccount(
                            merchantId,
                            _accountHolderController.text.trim(),
                            _accountNumberController.text.trim(),
                            _ifscController.text.trim(),
                            _bankNameController.text.trim(),
                          );

                          String message;
                          try {
                            final data = jsonDecode(response);
                            message = data['message'] ?? response;
                          } catch (_) {
                            message = response;
                          }

                          setState(() {
                            _responseMessage = message;
                            _isLoading = false;

                            _merchantIdController.clear();
                            _accountHolderController.clear();
                            _accountNumberController.clear();
                            _ifscController.clear();
                            _bankNameController.clear();
                          });
                        } catch (e) {
                          setState(() {
                            _responseMessage =
                            "Error connecting to server: $e";
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text("Register"),
                  ),
                ),

                SizedBox(height: 20),

                if (_responseMessage.isNotEmpty)
                  Text(
                    _responseMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================ TESTING ============================
// void main() {
//   runApp(MaterialApp(home: RegisterBankAccount()));
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../DataClasses/merchant_profile.dart';

//Widget call: ProfilePage(merchantId: _)
// ------------------- API FUNCTION -------------------
Future<MerchantProfile> getMerchantDetails(int merchantId) async {
  final url =
  Uri.parse("https://localhost:44395/api/Profile?id=$merchantId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return MerchantProfile.fromJson(data);
  } else {
    throw Exception(response.body);
  }
}

// ------------------- PROFILE PAGE -------------------
class ProfilePage extends StatefulWidget {
  final int merchantId;

  const ProfilePage({
    Key? key,
    required this.merchantId,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MerchantProfile? _profile;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ------------------- LOAD DATA -------------------
  Future<void> _loadProfile() async {
    try {
      final data = await getMerchantDetails(widget.merchantId);
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ------------------- UI -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _errorMessage.isNotEmpty
            ? Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        )
            : _buildProfile(),
      ),
    );
  }

  // ------------------- PROFILE VIEW -------------------
  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileItem("Full Name", _profile!.fullName),
          _profileItem("Business Name",
              _profile!.businessName ?? "Not Provided"),
          _profileItem("Email", _profile!.email ?? "Not Provided"),
          _profileItem("Phone Number", _profile!.phoneNumber),
        ],
      ),
    );
  }

  Widget _profileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

//------------------- TESTING -------------------
void main() {
  runApp(MaterialApp(
    home: ProfilePage(merchantId: 1),
  ));
}

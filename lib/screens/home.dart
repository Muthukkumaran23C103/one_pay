import 'package:flutter/material.dart';
import 'package:one_pay/screens/home.dart';
class Home extends StatefulWidget {
  final int merchantId;
  const Home({super.key, required this.merchantId});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: Text('One Pay', style: TextStyle(color:
        Colors.white, fontSize: 25),),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 75,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      "One Pay",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text("Add Merchant Bank Account"),
                onTap: () {
                  //connect to
                }
            ),
          ],
        ),
      )
    );
        }
}

import 'package:currency_conversion/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/userdata_services.dart';
import '../widgets/currency_convert.dart';
import '../widgets/currency_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<UserDataProvider>(context).userData;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff092E20),
          title: Container(
            width: 100,
            child: Image.asset("assets/img/appbar-logo.png"),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.currency_exchange)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrencyConvert(),
            CurrencyList(),
          ],
        ),
        endDrawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('${userData.name}',style: AppDesignSystem.currencyHeading,),
                accountEmail: Text('${userData.email}',style: AppDesignSystem.currencySubHeading),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: AppDesignSystem.whiteColor,
                  child: Text(
                    userData.name.isNotEmpty ? userData.name[0].toUpperCase() : '',  // Check if not empty
                    style: TextStyle(
                      color: AppDesignSystem.greenColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppDesignSystem.greenColor,
                ),
              ),
              SizedBox(height: 100,),
              Container(
                padding: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    late FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    });
                  },
                  child: Constants.btn("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

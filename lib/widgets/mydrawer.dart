// import 'package:e_shop/Authentication/authenication.dart';
// import 'package:e_shop/Config/config.dart';
// import 'package:e_shop/Address/addAddress.dart';
// import 'package:e_shop/Store/Search.dart';
// import 'package:e_shop/Store/cart.dart';
// import 'package:e_shop/Orders/myOrders.dart';
// import 'package:e_shop/Store/category_list.dart';
// import 'package:e_shop/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/Config/config.dart';
import 'package:user/Orders/myOrders.dart';
import 'package:user/screens/Profile.dart';
import 'package:user/screens/Search.dart';
import 'package:user/screens/cart.dart';
import 'package:user/screens/category_list.dart';
import 'package:user/screens/contactDev.dart';
import 'package:user/screens/contactUs.dart';
import 'package:user/screens/home.dart';
import 'package:user/screens/login.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding:
                EdgeInsets.only(top: 100.0, bottom: 10.0, left: 20, right: 10),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Material(
                //   borderRadius: BorderRadius.all(Radius.circular(80.0)),
                //   elevation: 8.0,
                //   child: Container(
                //     height: 160.0,
                //     width: 160.0,
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         EcommerceApp.sharedPreferences
                //             .getString(EcommerceApp.userAvatarUrl),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10.0,
                // ),
                Text(
                  "Hello,",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            // decoration: new BoxDecoration(
            //   gradient: new LinearGradient(
            //     colors: [Colors.deepOrangeAccent, Colors.deepOrange],
            //     begin: const FractionalOffset(0.0, 0.0),
            //     end: const FractionalOffset(1.0, 0.0),
            //     stops: [0.0, 1.0],
            //     tileMode: TileMode.clamp,
            //   ),
            // ),
            child: Column(
              children: [
                //ITEM NUMBER 1
                ListTile(
                  leading: Icon(
                    Icons.home,
                    //color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    //style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                //ITEM NUMBER 2
                ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: Text(
                    "Profile",
                    //style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => ProfilePage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                //ITEM NUMBER 3
                ListTile(
                  leading: Icon(
                    Icons.shopping_bag,
                    // color: Colors.white,
                  ),
                  title: Text(
                    "My Orders",
                    // style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                  },
                ),
                //ITEM NUMBER 4

                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    //color: Colors.white,
                  ),
                  title: Text(
                    "My Cart",
                    //style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),

                //ITEM NUMBER 5
                ListTile(
                  leading: Icon(
                    Icons.dashboard,
                    //color: Colors.white,
                  ),
                  title: Text(
                    "Category",
                    // style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => CategoryList());
                    Navigator.push(context, route);
                  },
                ),
                //ITEM NUMBER 6
                ListTile(
                  leading: Icon(
                    Icons.search,
                    // color: Colors.white,
                  ),
                  title: Text(
                    "Search",
                    // style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                //ITEM NUMBER 7
                ListTile(
                  leading: Icon(
                    Icons.support_agent,

                    // color: Colors.white,
                  ),
                  title: Text(
                    "Contact Us",
                    // style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => ContactUs());
                    Navigator.push(context, route);
                  },
                ),
                //ITEM NUMBER 8
                ListTile(
                  leading: Icon(
                    Icons.bug_report,

                    // color: Colors.white,
                  ),
                  title: Text(
                    "Contact Developer",
                    // style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => ContactDev());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: .2,
                ),
                //ITEM NUMBER 9
                ListTile(
                  leading: Icon(
                    Icons.person_off,
                    //color: Colors.white,
                  ),
                  title: Text(
                    "Logout",
                    //style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => SignInScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/en/4/46/Make_In_India.png",
                  height: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Made in India",
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/Address/address.dart';
import 'package:user/Config/config.dart';
import 'package:user/api/pdf_api.dart';
import 'package:user/model/address.dart';
import 'package:user/screens/home.dart';
import 'package:user/widgets/loadingWidget.dart';
import 'package:user/widgets/orderCard.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderId;
  final String url;

  // OrderDetails({
  //   Key key,
  //   this.orderId,
  // }) : super(key: key);
  OrderDetails({this.orderId, this.url});

  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;

    print('orderId');
    print(orderId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Order Details",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .doc(orderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹ " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(height: 2.0),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data()),
                                      url: url)
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel_outlined;
    status ? msg = "Successful" : msg = "Failed";
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.deepOrangeAccent, Colors.deepOrange],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_circle_down_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Text(
            "Order Placing " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  final String url;

  ShippingDetails({Key key, this.model, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details:",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin Code",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmedUserOrderRecieved(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Click Here if You Received Items",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                PdfApi.openFileFromUrl(url);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Click Here to View invoice",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmedUserOrderRecieved(BuildContext context, String myOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(myOrderId)
        .delete();
    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been received!");
  }
}

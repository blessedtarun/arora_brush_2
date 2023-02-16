import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user/Address/address.dart';
import 'package:user/Config/config.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Counters/totalMoney.dart';
import 'package:user/api/pdf_invoice_api.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/invoice.dart';
import 'package:user/model/item.dart';
import 'package:user/model/supplier.dart';
import 'package:user/screens/cart.dart';
import 'package:user/screens/home.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/widgets/loadingWidget.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final double cartTotal;
  //final int gst;
  final int shipping;
  var value;

  PaymentPage(
      {Key key,
      @required this.addressId,
      @required this.totalAmount,
      @required this.value,
      @required this.cartTotal,
      // @required this.gst,
      @required this.shipping})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime date;
  File file;
  String uname = "";
  String uphone = "";
  String faddress = "";
  String saddress = "";
  double amt;
  List<InvoiceItem> templist = [];
  Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    amt = widget.totalAmount;
    getdetails();
    getlist();
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(msg: "Payment Success");
    generatebill();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_live_x9m5rsbdf6Itzv",
      "amount": amt * 100,
      "name": "Arora Brush",
      "description": "Payment for purchase at Arora Brush",
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: "Payment Failed");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => CartPage()));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Fluttertoast.showToast(msg: "Payment external wallet");
  }

  getdetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("userAddress")
        .doc(widget.addressId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data);
        setState(() {
          uname = documentSnapshot['name'];
          uphone = documentSnapshot['phoneNumber'];
          faddress =
              documentSnapshot['flatNumber'] + ", " + documentSnapshot['city'];
          saddress =
              documentSnapshot['state'] + ", " + documentSnapshot['pincode'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  getlist() {
    int size = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartList)
        .length;
    print(size);
    for (int i = 0; i < size; i++) {
      String prodId = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)[i];

      if (prodId != 'garbageValue') {
        templist.add(InvoiceItem(
            description: EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userCartList)[i],
            quantity: int.parse(EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userCartListQuantity)[i]),
            unitPrice: double.parse(EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userCartListPrice)[i])));
      }
    }
    print('templist');
    print(templist[0].description);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Proceed to next page to make payment",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      color: Colors.white,
                  ),
                  

                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                  overlayColor:MaterialStateProperty.all<Color>(Colors.white), 
                ),
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  "Click Here",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  generatebill() async {
    date = DateTime.now();
    //final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: 'Arora Brush',
        address: '104 Ground Floor, GTB Nagar, New Delhi 110009',
        //paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      customer: Customer(
          name: uname,
          address1: faddress,
          address2: saddress,
          phone: "Phone: " + uphone),
      info: InvoiceInfo(
        date: date,
        description: 'Order Description',
        number: '${DateTime.now().month}' +
            '${DateTime.now().day}' +
            '${DateTime.now().year}' +
            '${DateTime.now().hour}' +
            '${DateTime.now().minute}',
      ),
      details: InvoiceDetails(
          cartTotal: widget.cartTotal,
          //gst: widget.gst,
          total: widget.totalAmount,
          shipping: widget.shipping),
      items: templist,
    );

    file = await PdfInvoiceApi.generate(invoice);
    uploadInvoiceAndSaveItemInfo(file);
  }

  addOrderDetails(String invoiceUrl) {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      "invoiceUrl": invoiceUrl,
      EcommerceApp.paymentDetails: "RazorPay",
      EcommerceApp.orderTime: date.millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.isCompleted: false,
      EcommerceApp.userCartListQuantity: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListQuantity),
      EcommerceApp.userCartListPrice: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListPrice)
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "invoiceUrl": invoiceUrl,
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "RazorPay",
      EcommerceApp.orderTime: date.millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.isCompleted: false,
      EcommerceApp.userCartListQuantity: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListQuantity),
      EcommerceApp.userCartListPrice: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListPrice),
    }).whenComplete(() => {emptyCartNow()});
  }

  emptyCartNow() async {
    var value = <String>[];

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, <String>[]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListPrice, <String>[]);
    List tempPriceList = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListPrice);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempList,
      EcommerceApp.userCartListQuantity: value,
      EcommerceApp.userCartListPrice: tempPriceList,
    });

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempList);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListQuantity, value);
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListPrice, tempPriceList);

    Fluttertoast.showToast(msg: "You order has been placed successfully");
  }

  uploadInvoiceAndSaveItemInfo(File file) async {
    String invoiceUrl = await uploadInvoice(file);

    print('invoiceUrl');
    print(invoiceUrl);

    addOrderDetails(invoiceUrl);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => StoreHome()));
  }

  Future<String> uploadInvoice(mFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref().child("Orders");

    String invoice =
        "invoice_" + date.millisecondsSinceEpoch.toString() + ".pdf";
    // print(invoice);
    // UploadTask uploadTask = storageReference.child(invoice).putFile(mFile);
    // TaskSnapshot taskSnapshot = uploadTask.snapshot;
    // print(taskSnapshot.ref);
    // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    // return downloadUrl;

    UploadTask uploadTask = storageReference.child(invoice).putFile(mFile);
    var invoiceUrl = await (await uploadTask).ref.getDownloadURL();
    String downloadUrl = invoiceUrl.toString();
    return downloadUrl;
  }
}

Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
  await EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.collectionOrders)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
          data['orderTime'])
      .set(data);
}

Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
  await EcommerceApp.firestore
      .collection(EcommerceApp.collectionOrders)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
          data['orderTime'])
      .set(data);
}

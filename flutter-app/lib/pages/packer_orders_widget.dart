import 'package:picker_packer/model/user_login.dart';
import 'package:flutter/services.dart';
import 'package:picker_packer/provider/packer_order_cancel_service.dart';
import 'package:picker_packer/provider/packer_order_scan_cart_barcode_service.dart';
import '../provider/packer_orders_service.dart';
import 'packer_order_delivery_widget.dart';
import '../model/packer_order.dart';
import 'packer_order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class PackerOrdersWidget extends StatefulWidget {
  final UserLogin user;
  PackerOrdersWidget({Key key, @required this.user}) : super(key: key);

  @override
  _PackerOrdersWidgetState createState() => _PackerOrdersWidgetState(user);
}

class _PackerOrdersWidgetState extends State<PackerOrdersWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _PackerOrdersWidgetState(user) {
    this.user = user;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PackerOrderCancelService orderCancelService = new PackerOrderCancelService();
  PackerOrderScanCartBarcodeService orderScanCartBarcodeService =
      new PackerOrderScanCartBarcodeService();
  PackerOrdersService orderService = new PackerOrdersService();
  List<Packer_Order> orders = new List<Packer_Order>();

  @override
  void initState() {
    super.initState();
    orderService.setAccountId(user.id);
    updateOrderList();
  }

  updateOrderList() async {
    orders = await orderService.request();
    setState(() {});
  }

  orderCancel() async {
    var res = await orderCancelService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully cancel Order #' +
              orderCancelService.order_id.toString() +
              ' !',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
    } else {
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You couldn\'t cancel Order #' +
                orderCancelService.order_id.toString() +
                ', Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderList();
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      orderScanCartBarcodeService.setBarcode(barcodeScanRes);

      var res = await orderScanCartBarcodeService.request();
      if (res == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You successfully scan cart barcode for Order #' +
                orderScanCartBarcodeService.order_id.toString() +
                '!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 4),
          content: Text(
            'You couldn\'t scan the cart barcode for Order #' +
                orderScanCartBarcodeService.order_id.toString() +
                ', please check and try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
      updateOrderList();
    } on PlatformException {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0x9700ADB5),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new IconButton(
            color: Color(0xFFFACF39),
            icon: new Icon(FontAwesomeIcons.shippingFast),
            onPressed: () async {
              var status = await Permission.location.request();

              if (status.isDenied) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text(
                    'Please allow access location!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Inter", color: Color(0xFF521262)),
                  ),
                  backgroundColor: Color(0xFFFACF39),
                ));
                // We didn't ask for permission yet.
              }

              // You can can also directly ask the permission about its status.
              if (await Permission.location.isRestricted) {}
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PackerOrderDeliveryWidget(
                          user: user,
                        )),
              );
              updateOrderList();
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          "Orders",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Center(
        child: orderList(), //İçerik
      ),
    );
  }

  Widget orderList() {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height;
    final double ekrangenisligi = ekranbilgisi.size.width;
    return RefreshIndicator(
      color: Color(0xFFFACF39),
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
          () {
            /// adding elements in list after [1 seconds] delay
            /// to mimic network call
            ///
            /// Remember: setState is necessary so that
            /// build method will run again otherwise
            /// list will not show all elements
            setState(() {
              updateOrderList();
            });
          },
        );
      },
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: ekrangenisligi / 20),
          itemCount: orders.length != null
              ? orders.length
              : 0, //Buraya çekilen listenin uzunluğu gelecek,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                // All actions are defined in the children parameter.
                children: [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                    onPressed: (_) async {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xB337CDD4),
                          title: Text(
                              "Are you sure cancel\nOrder #" +
                                  orders[index].order_id.toString() +
                                  " ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Inter",
                                  color: Color(0xFFFACF39))),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("No",
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFFFACF39))),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            FlatButton(
                              child: Text("Yes",
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFFFACF39))),
                              onPressed: () {
                                orderCancelService
                                    .setOrderId(orders[index].order_id);
                                orderCancel();
                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    spacing: 10,
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: FontAwesomeIcons.ban,
                    label: 'Cancel\n Order',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: ekrangenisligi / 25),
                      width: ekrangenisligi / 1.3,
                      height: ekranyuksekligi / 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: Color(0xB337CDD4)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: ekrangenisligi / 2.5,
                                padding:
                                    EdgeInsets.only(left: ekrangenisligi / 40),
                                child: Text(
                                  '#' + orders[index].order_id.toString(),
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: ekrangenisligi / 17,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Text(
                                  orders[index].item_amount.toString() +
                                      " Items",
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: ekrangenisligi / 22,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ekranyuksekligi / 50),
                            child: Row(
                              children: [
                                Container(
                                  width: ekrangenisligi / 4.7,
                                  padding: EdgeInsets.only(
                                      left: ekrangenisligi / 80),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.shoppingCart,
                                        size: ekrangenisligi / 30,
                                        color: Color(0xFFFACF39),
                                      ),
                                      Text(
                                        " #" + orders[index].cart_barcode,
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: ekrangenisligi / 35,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ), //SepetID
                                Container(
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.calendarAlt,
                                        size: ekrangenisligi / 30,
                                        color: Color(0xFFFACF39),
                                      ),
                                      Text(
                                        " " + orders[index].date,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: ekrangenisligi / 35,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ) //Tarih Saat
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ekranyuksekligi / 14,
                          width: ekrangenisligi / 8,
                          child: RaisedButton(
                              elevation: 0,
                              color: Color(0xFFFACF39),
                              onPressed: () {
                                if (orders[index].is_collected == true) {
                                  orderScanCartBarcodeService
                                      .setOrderId(orders[index].order_id);
                                  scanBarcodeNormal();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                      'First you need to collect cold chain items of Order #' +
                                          orders[index].order_id.toString() +
                                          ' !',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF521262)),
                                    ),
                                    backgroundColor: Color(0xFFFACF39),
                                  ));
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                              )),
                              child: FaIcon(FontAwesomeIcons.qrcode,
                                  color: Colors.white)),
                        ),
                        SizedBox(
                          height: ekranyuksekligi / 14,
                          width: ekrangenisligi / 8,
                          child: RaisedButton(
                              color: Color(0xFF404141),
                              elevation: 0,
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: PackerOrderDetailsWidget(
                                            order: orders[index])));
                                updateOrderList();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15))),
                              child: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ) //QR ve Details butonları
                  ],
                ),
              ),
            );
          }),
    );
  } //Order listesi
}

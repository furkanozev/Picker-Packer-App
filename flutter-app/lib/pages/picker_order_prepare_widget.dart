import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:picker_packer/model/picker_order_prepare.dart';
import 'package:picker_packer/model/picker_prepare_process_item.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/provider/picker_order_scan_prepare_cart_service.dart';
import 'package:picker_packer/provider/picker_orders_prepare_service.dart';
import 'package:picker_packer/provider/picker_prepare_order_cancel_service.dart';
import 'package:picker_packer/provider/picker_prepare_order_complete_service.dart';
import 'package:picker_packer/provider/picker_prepare_process_items_service.dart';
import 'picker_order_prepare_details_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class PickerOrderPrepareWidget extends StatefulWidget {
  final UserLogin user;
  PickerOrderPrepareWidget({Key key, @required this.user}) : super(key: key);

  @override
  _PickerOrderPrepareWidgetState createState() =>
      _PickerOrderPrepareWidgetState(user);
}

class _PickerOrderPrepareWidgetState extends State<PickerOrderPrepareWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _PickerOrderPrepareWidgetState(user) {
    this.user = user;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var scanned_id;

  PickerPrepareProcessItemsService itemService =
      new PickerPrepareProcessItemsService();
  List<Picker_Prepare_Process_Item> items =
      new List<Picker_Prepare_Process_Item>();

  PickerOrdersPrepareService orderService = new PickerOrdersPrepareService();
  List<Picker_Order_Prepare> orders = new List<Picker_Order_Prepare>();

  PickerOrderPrepareCancelService orderPrepareCancelService =
      new PickerOrderPrepareCancelService();
  PickerOrderPrepareCompleteService orderPrepareCompleteService =
      new PickerOrderPrepareCompleteService();
  PickerOrderPrepareScanCartService orderScanCartService =
      new PickerOrderPrepareScanCartService();

  @override
  void initState() {
    super.initState();
    scanned_id = -1;
    orderService.setAccountId(user.id);
    itemService.setAccountId(user.id);
    updateOrderList();
    updateItemList();
  }

  updateOrderList() async {
    orders = await orderService.request();
    setState(() {});
  }

  updateItemList() async {
    items = await itemService.request();
    setState(() {});
  }

  prepareCancel() async {
    var res = await orderPrepareCancelService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully cancel prepare Order #' +
              orderPrepareCancelService.order_id.toString() +
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
            'You couldn\'t cancel prepare Order #' +
                orderPrepareCancelService.order_id.toString() +
                ', Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderList();
    updateItemList();
    setState(() {});
  }

  prepareComplete() async {
    var res = await orderPrepareCompleteService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully complete prepare Order #' +
              orderPrepareCompleteService.order_id.toString() +
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
            'You couldn\'t complete prepare Order #' +
                orderPrepareCompleteService.order_id.toString() +
                ',\nPlease check that all items are in the cart and try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderList();
    updateItemList();
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeItemNormal(index) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ffff00', 'Cancel', true, ScanMode.BARCODE);

      if (items[index].item_barcode == barcodeScanRes) {
        scanned_id = items[index].id;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You successfully scan item barcode for ' +
                items[index].name +
                ' Item!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      } else {
        scanned_id = -1;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You couldn\'t scan the item barcode for ' +
                items[index].name +
                ', please check and try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
      updateOrderList();
      updateItemList();
    } on PlatformException {}
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeCartNormal(index) async {
    try {
      if (scanned_id == items[index].id) {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#b2ff59', 'Cancel', true, ScanMode.BARCODE);

        orderScanCartService.setBarcode(barcodeScanRes);
        orderScanCartService.setId(items[index].id);

        var res;

        if (items[index].cart_barcode != barcodeScanRes) {
          res = false;
        } else {
          res = await orderScanCartService.request();
        }

        if (res == true) {
          scanned_id = -1;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              'You successfully scan cart barcode for ' +
                  items[index].name +
                  ' Item!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
            ),
            backgroundColor: Color(0xFFFACF39),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              'You couldn\'t scan the cart barcode for ' +
                  items[index].name +
                  ', please check and try again!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
            ),
            backgroundColor: Color(0xFFFACF39),
          ));
        }
        updateOrderList();
        updateItemList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'Please firstly scan barcode of ' +
                items[index].name +
                ' item, then try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    } on PlatformException {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height;
    final double ekrangenisligi = ekranbilgisi.size.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFFFACF39),
            size: 32,
          ),
        ),
        backgroundColor: Color(0x98C54C82),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [],
        centerTitle: true,
        title: Text(
          "Prepare Orders",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
      //Hazırla butonu
      body: RefreshIndicator(
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
                updateItemList();
              });
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: ekrangenisligi / 20, vertical: 0),
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: ekranyuksekligi / 30),
                        child: Container(
                          width: ekrangenisligi,
                          height: ekranyuksekligi / 2.64,
                          decoration: BoxDecoration(
                              color: Color(0xB3F85FA4),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: ekranyuksekligi / 50),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ekrangenisligi / 1.43),
                                  child: Text(
                                    "Item / Cart",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: ekrangenisligi / 25,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: ekranyuksekligi / 100),
                                child: Column(
                                  children: [
                                    Container(
                                      height: ekranyuksekligi / 3.5,
                                      child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: ekrangenisligi / 35),
                                          itemCount: items.length != null
                                              ? items.length
                                              : 0, //Buraya çekilen listenin uzunluğu gelecek,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                contentPadding: EdgeInsets.only(
                                                    left: ekrangenisligi / 40),
                                                title: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: ekrangenisligi /
                                                              12),
                                                      child: Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .shoppingCart,
                                                            size:
                                                                ekrangenisligi /
                                                                    30,
                                                            color: Color(
                                                                0xFFFACF39),
                                                          ),
                                                          Text(
                                                            ' #' +
                                                                items[index]
                                                                    .cart_barcode,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Inter",
                                                                fontSize:
                                                                    ekrangenisligi /
                                                                        35,
                                                                color: scanned_id ==
                                                                        items[index]
                                                                            .id
                                                                    ? Colors
                                                                        .lightGreenAccent
                                                                    : Colors
                                                                        .white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          12,
                                                                  height:
                                                                      ekrangenisligi /
                                                                          12,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    image:
                                                                        new DecorationImage(
                                                                      image: items[index].is_cold ==
                                                                              false
                                                                          ? new AssetImage(
                                                                              "assets/images/item.png")
                                                                          : new AssetImage(
                                                                              "assets/images/cold_item.png"),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          4.8,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ekrangenisligi /
                                                                              100),
                                                                  child: Text(
                                                                      items[index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontSize: ekrangenisligi /
                                                                              25,
                                                                          color: scanned_id == items[index].id
                                                                              ? Colors.limeAccent
                                                                              : Colors.white)),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          6.5,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ekrangenisligi /
                                                                              100),
                                                                  child: Text(
                                                                      items[index]
                                                                          .category,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontSize: ekrangenisligi /
                                                                              30,
                                                                          color: scanned_id == items[index].id
                                                                              ? Colors.limeAccent
                                                                              : Colors.white)),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          6.5,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ekrangenisligi /
                                                                              100),
                                                                  child: Text(
                                                                      items[index]
                                                                          .subcategory,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontSize: ekrangenisligi /
                                                                              30,
                                                                          color: scanned_id == items[index].id
                                                                              ? Colors.limeAccent
                                                                              : Colors.white)),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          10,
                                                                  padding: EdgeInsets.only(
                                                                      left: ekrangenisligi /
                                                                          100),
                                                                  child: Text(
                                                                      "x" +
                                                                          items[index]
                                                                              .amount
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Inter",
                                                                          fontSize: ekrangenisligi /
                                                                              24,
                                                                          color: scanned_id == items[index].id
                                                                              ? Colors.limeAccent
                                                                              : Colors.white)),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          13,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ekrangenisligi /
                                                                              100),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      scanBarcodeItemNormal(
                                                                          index);
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .qrcode,
                                                                      color: Colors
                                                                          .yellowAccent,
                                                                      size:
                                                                          ekrangenisligi /
                                                                              15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      ekrangenisligi /
                                                                          13,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ekrangenisligi /
                                                                              50),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      scanBarcodeCartNormal(
                                                                          index);
                                                                    },
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .qrcode,
                                                                      color: Colors
                                                                          .lightGreenAccent,
                                                                      size:
                                                                          ekrangenisligi /
                                                                              15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          endIndent:
                                                              ekrangenisligi /
                                                                  5.5,
                                                          height: 15,
                                                          color:
                                                              Color(0xFF404141),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          }),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ekranyuksekligi / 200),
                        child: Container(
                          width: ekrangenisligi / 7,
                          height: ekrangenisligi / 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFACF39),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.shoppingBasket,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //Sipariş
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ekranyuksekligi / 2.4, bottom: ekranyuksekligi / 40),
                child: orderList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget orderList() {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height / 1.5;
    final double ekrangenisligi = ekranbilgisi.size.width;
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: ekrangenisligi / 20),
        itemCount: orders.length != null
            ? orders.length
            : 0, //Buraya çekilen listenin uzunluğu gelecek,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: ActionPane(
              extentRatio: 1,
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),
              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (_) async {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xB3F85FA4),
                        title: Text(
                            "Are you sure cancel prepare\nOrder #" +
                                orders[index].order_id.toString() +
                                " ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter", color: Color(0xFFFACF39))),
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
                              orderPrepareCancelService
                                  .setOrderId(orders[index].order_id);
                              prepareCancel();
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  spacing: 5,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.minusCircle,
                  label: ' Cancel Prepare',
                ),
                SlidableAction(
                  onPressed: (_) async {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xB3F85FA4),
                        title: Text(
                            "Are you sure complete prepare\nOrder #" +
                                orders[index].order_id.toString() +
                                " ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter", color: Color(0xFFFACF39))),
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
                              orderPrepareCompleteService
                                  .setOrderId(orders[index].order_id);
                              prepareComplete();
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  spacing: 5,
                  backgroundColor: Color(0xFF29CA68),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.checkDouble,
                  label: 'Complete Order',
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
                        color: Color(0xB3F85FA4)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
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
                            Padding(
                              padding:
                                  EdgeInsets.only(left: ekrangenisligi / 4.8),
                              child: Text(
                                orders[index].item_amount.toString() + " Items",
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
                              Padding(
                                padding:
                                    EdgeInsets.only(left: ekrangenisligi / 80),
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.shoppingCart,
                                      size: ekrangenisligi / 30,
                                      color: Color(0xFFFACF39),
                                    ),
                                    Text(
                                      ' #' + orders[index].cart_barcode,
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: ekrangenisligi / 35,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ), //SepetID
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: ekranyuksekligi / 7,
                        width: ekrangenisligi / 8,
                        child: RaisedButton(
                            color: Color(0xFF404141),
                            elevation: 0,
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: PickerOrderPrepareDetailsWidget(
                                          order: orders[index])));
                              updateOrderList();
                              updateItemList();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(15))),
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
        });
  } //Order listesi
}

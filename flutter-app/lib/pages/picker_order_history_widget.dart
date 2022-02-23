import 'package:picker_packer/model/picker_order_history.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/provider/picker_order_history_delete_all_service.dart';
import 'package:picker_packer/provider/picker_order_history_delete_service.dart';
import 'package:picker_packer/provider/picker_orders_history_service.dart';
import 'picker_order_history_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class PickerOrderHistoryWidget extends StatefulWidget {
  final UserLogin user;
  PickerOrderHistoryWidget({Key key, @required this.user}) : super(key: key);

  @override
  _PickerOrderHistoryWidgetState createState() =>
      _PickerOrderHistoryWidgetState(user);
}

class _PickerOrderHistoryWidgetState extends State<PickerOrderHistoryWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _PickerOrderHistoryWidgetState(user) {
    this.user = user;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PickerOrdersHistoryService orderHistoryService =
      new PickerOrdersHistoryService();
  List<Picker_Order_History> orders = new List<Picker_Order_History>();

  PickerOrderHistoryDeleteService orderHistoryDeleteService =
      new PickerOrderHistoryDeleteService();
  PickerOrderHistoryDeleteAllService orderHistoryDeleteAllService =
      new PickerOrderHistoryDeleteAllService();

  @override
  void initState() {
    super.initState();
    orderHistoryService.setAccountId(user.id);
    orderHistoryDeleteAllService.setAccountId(user.id);
    updateOrderList();
  }

  updateOrderList() async {
    orders = await orderHistoryService.request();
    setState(() {});
  }

  deleteOrder() async {
    var res = await orderHistoryDeleteService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully remove Order #' +
              orderHistoryDeleteService.order_id.toString() +
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
            'You couldn\'t remove Order #' +
                orderHistoryDeleteService.order_id.toString() +
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

  deleteAllOrder() async {
    var res = await orderHistoryDeleteAllService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully clear history!',
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
            'You couldn\'t clear history, Please try again!',
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

  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height;
    final double ekrangenisligi = ekranbilgisi.size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0x98C54C82),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [],
        centerTitle: true,
        title: Text(
          "Orders History",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
      floatingActionButton: SizedBox(
        width: ekrangenisligi / 3.1,
        height: ekranyuksekligi / 18,
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Clear History",
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: ekrangenisligi / 30,
                      color: Colors.white)),
              Padding(
                padding: EdgeInsets.only(left: ekrangenisligi / 50),
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: ekrangenisligi / 25,
                ),
              )
            ],
          ),
          onPressed: () {
            return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color(0xB3F85FA4),
                title: Text("Are you sure remove all orders?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Inter", color: Color(0xFFFACF39))),
                actions: <Widget>[
                  FlatButton(
                    child: Text("No",
                        style: TextStyle(
                            fontFamily: "Inter", color: Color(0xFFFACF39))),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  FlatButton(
                    child: Text("Yes",
                        style: TextStyle(
                            fontFamily: "Inter", color: Color(0xFFFACF39))),
                    onPressed: () {
                      deleteAllOrder();
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ), //Hazırla butonu
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
            return ListTile(
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
                              Container(
                                padding:
                                    EdgeInsets.only(left: ekrangenisligi / 80),
                                width: ekrangenisligi / 4.7,
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidClock,
                                      size: ekrangenisligi / 30,
                                      color: Color(0xFFFACF39),
                                    ),
                                    Text(
                                      " " + orders[index].status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter",
                                          fontSize: ekrangenisligi / 35,
                                          color: orders[index].status ==
                                                  'Completed'
                                              ? Colors.green
                                              : orders[index].status ==
                                                      'Canceled'
                                                  ? Colors.red
                                                  : Colors.white),
                                    )
                                  ],
                                ),
                              ), //Durum
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
                                      maxLines: 1,
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
                            color: Colors.red,
                            onPressed: () async {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Color(0xB3F85FA4),
                                  title: Text(
                                      "Are you sure remove\nOrder #" +
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
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    FlatButton(
                                      child: Text("Yes",
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xFFFACF39))),
                                      onPressed: () {
                                        orderHistoryDeleteService
                                            .setOrderId(orders[index].order_id);
                                        deleteOrder();
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                            )),
                            child: FaIcon(FontAwesomeIcons.minusCircle,
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
                                      child: PickerOrderHistoryDetailsWidget(
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
            );
          }),
    );
  } //Order listesi
}

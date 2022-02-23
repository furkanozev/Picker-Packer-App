import 'package:flutter/material.dart';
import 'package:picker_packer/model/picker_order_item.dart';
import 'package:picker_packer/provider/picker_order_items_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/picker_order.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PickerOrderDetailsWidget extends StatefulWidget {
  final Picker_Order order;
  const PickerOrderDetailsWidget({Key key, @required this.order})
      : super(key: key);

  @override
  _PickerOrderDetailsWidgetState createState() =>
      _PickerOrderDetailsWidgetState(order);
}

class _PickerOrderDetailsWidgetState extends State<PickerOrderDetailsWidget>
    with SingleTickerProviderStateMixin {
  Picker_Order order;
  _PickerOrderDetailsWidgetState(order) {
    this.order = order;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PickerOrderItemsService orderItemsService = new PickerOrderItemsService();
  List<Picker_Order_Item> order_items = new List<Picker_Order_Item>();

  @override
  void initState() {
    super.initState();
    orderItemsService.setOrderId(order.order_id);
    updateOrderItemsList();
  }

  updateOrderItemsList() async {
    order_items = await orderItemsService.request();
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
          "Order Details",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
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
                updateOrderItemsList();
              });
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: ekrangenisligi / 20, vertical: 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: ekranyuksekligi / 35),
                            child: Container(
                              width: ekrangenisligi,
                              height: ekranyuksekligi / 1.7,
                              decoration: BoxDecoration(
                                  color: Color(0xB3F85FA4),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ekranyuksekligi / 20),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ekrangenisligi / 40),
                                          child: Text(
                                            "#" + order.order_id.toString(),
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: ekrangenisligi / 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ekrangenisligi / 80,
                                        left: ekrangenisligi / 40),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: ekrangenisligi / 3,
                                          padding: EdgeInsets.only(
                                              left: ekrangenisligi / 80),
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.calendarAlt,
                                                size: ekrangenisligi / 30,
                                                color: Color(0xFFFACF39),
                                              ),
                                              Text(
                                                " " + order.date,
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    fontSize:
                                                        ekrangenisligi / 35,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        //Tarih Saat
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: ekranyuksekligi / 2.6,
                                        child: ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.symmetric(
                                                vertical: ekrangenisligi / 35),
                                            itemCount: order_items.length !=
                                                    null
                                                ? order_items.length
                                                : 0, //Buraya çekilen listenin uzunluğu gelecek,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: ekrangenisligi /
                                                              40),
                                                  title: Column(
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
                                                                          .circular(
                                                                              5),
                                                                  image:
                                                                      new DecorationImage(
                                                                    image: order_items[index].is_cold ==
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
                                                                        2,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        ekrangenisligi /
                                                                            20),
                                                                child: Text(
                                                                    order_items[
                                                                            index]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            ekrangenisligi /
                                                                                22,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                              Container(
                                                                width:
                                                                    ekrangenisligi /
                                                                        9,
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        ekrangenisligi /
                                                                            200),
                                                                child: Text(
                                                                    "x" +
                                                                        order_items[index]
                                                                            .amount
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Inter",
                                                                        fontSize:
                                                                            ekrangenisligi /
                                                                                22,
                                                                        color: Colors
                                                                            .white)),
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
                                                  ));
                                            }),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: ekranyuksekligi / 200),
                            child: Container(
                              width: ekrangenisligi / 7,
                              height: ekrangenisligi / 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFACF39),
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.clipboardList,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ), //Sipariş
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ekranyuksekligi / 1.95),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: ekranyuksekligi / 23),
                              child: Container(
                                width: ekrangenisligi,
                                height: ekranyuksekligi / 3.8,
                                decoration: BoxDecoration(
                                    color: Color(0xFF404141),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: ekranyuksekligi / 80,
                                            bottom: ekranyuksekligi / 150,
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidUser,
                                            color: Color(0xFFFACF39),
                                          ),
                                        ),
                                        Text(order.name,
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: ekrangenisligi / 30,
                                                color: Colors.white))
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: ekranyuksekligi / 400,
                                            bottom: ekranyuksekligi / 150,
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidComment,
                                            color: Color(0xFFFACF39),
                                          ),
                                        ),
                                        Text(order.note,
                                            overflow: TextOverflow.clip,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: ekrangenisligi / 30,
                                                color: Colors.white))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: ekranyuksekligi / 15,
                                          width: ekrangenisligi / 1.112,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              var phone = order.phone;
                                              launch('tel://$phone');
                                            },
                                            elevation: 0,
                                            color: Color(0xFFFACF39),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.phoneAlt,
                                                  color: Colors.white,
                                                  size: ekrangenisligi / 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text("Call",
                                                      style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize:
                                                              ekrangenisligi /
                                                                  25,
                                                          color: Colors.white)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ), // Ara Butonu
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: ekranyuksekligi / 50),
                              child: Container(
                                width: ekrangenisligi / 7,
                                height: ekrangenisligi / 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFACF39),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.shoppingBag,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ) //Kargo Iconu
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ), // geri tuşu
        ),
      ),
    );
  }
}

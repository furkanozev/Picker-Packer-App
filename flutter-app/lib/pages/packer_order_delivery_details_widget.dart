import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:picker_packer/model/packer_order_deliver.dart';
import 'package:picker_packer/model/packer_order_deliver_item.dart';
import 'package:picker_packer/provider/packer_order_deliver_item_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PackerOrderDeliveryDetailsWidget extends StatefulWidget {
  final Packer_Order_Deliver order;
  const PackerOrderDeliveryDetailsWidget({Key key, @required this.order})
      : super(key: key);

  @override
  _PackerOrderDeliveryDetailsWidgetState createState() =>
      _PackerOrderDeliveryDetailsWidgetState(order);
}

class _PackerOrderDeliveryDetailsWidgetState
    extends State<PackerOrderDeliveryDetailsWidget>
    with SingleTickerProviderStateMixin {
  Packer_Order_Deliver order;
  _PackerOrderDeliveryDetailsWidgetState(order) {
    this.order = order;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PackerOrderDeliverItemsService orderItemsService =
      new PackerOrderDeliverItemsService();
  List<Packer_Order_Deliver_Item> order_items =
      new List<Packer_Order_Deliver_Item>();

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
    final scaffoldKey = GlobalKey<ScaffoldState>();
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
        backgroundColor: Color(0x9700ADB5),
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
                                  color: Color(0xB337CDD4),
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
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: ekrangenisligi / 3),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidMoneyBillAlt,
                                            color: Color(0xFFFACF39),
                                            size: ekranyuksekligi / 40,
                                          ),
                                        ),
                                        Text(
                                            " " +
                                                order.price_distance
                                                    .toString() +
                                                " \???",
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Inter",
                                                fontSize: ekrangenisligi / 30,
                                                color: order.price_distance < 0
                                                    ? Colors.red
                                                    : order.price_distance > 0
                                                        ? Colors.green
                                                        : Colors.white)),
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
                                              right: ekrangenisligi / 80),
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.shoppingCart,
                                                size: ekrangenisligi / 30,
                                                color: Color(0xFFFACF39),
                                              ),
                                              Text(
                                                " #" + order.cart_barcode,
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    fontSize:
                                                        ekrangenisligi / 35,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ), //SepetID
                                        Expanded(
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
                                        ) //Tarih Saat
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ekrangenisligi / 80,
                                        left: ekrangenisligi / 40),
                                    child: Row(
                                      children: [
                                        order.time != '-'
                                            ? Container(
                                                width: ekrangenisligi / 3,
                                                padding: EdgeInsets.only(
                                                    right: ekrangenisligi / 80),
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .stopwatch,
                                                      size: ekrangenisligi / 30,
                                                      color: Color(0xFFFACF39),
                                                    ),
                                                    Text(
                                                      " " + order.time,
                                                      style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize:
                                                              ekrangenisligi /
                                                                  35,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(), //SepetID
                                        order.distance != '-'
                                            ? Expanded(
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.road,
                                                      size: ekrangenisligi / 30,
                                                      color: Color(0xFFFACF39),
                                                    ),
                                                    Text(
                                                      " " + order.distance,
                                                      style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize:
                                                              ekrangenisligi /
                                                                  35,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container() //Tarih Saat
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: order.time != '-' &&
                                                order.distance != '-'
                                            ? ekranyuksekligi / 2.83
                                            : ekranyuksekligi / 2.68,
                                        child: ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.symmetric(
                                                vertical: ekrangenisligi / 35),
                                            itemCount: order_items.length !=
                                                    null
                                                ? order_items.length
                                                : 0, //Buraya ??ekilen listenin uzunlu??u gelecek,
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
                                                                    image: new AssetImage(
                                                                        "assets/images/item.png"),
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
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 22,
                                                                        color: order_items[index].is_added == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
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
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 22,
                                                                        color: order_items[index].is_added == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
                                                              ),
                                                              Container(
                                                                width:
                                                                    ekrangenisligi /
                                                                        8.3,
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        ekrangenisligi /
                                                                            100),
                                                                child: Text(
                                                                    order_items[index]
                                                                            .price
                                                                            .toString() +
                                                                        " \???",
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 35,
                                                                        color: order_items[index].is_added == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
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
                      ), //Sipari??
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ekranyuksekligi / 2.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: ekranyuksekligi / 23),
                              child: Container(
                                width: ekrangenisligi,
                                height: ekranyuksekligi / 3.3,
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
                                              bottom: ekranyuksekligi / 150),
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
                                            FontAwesomeIcons.mapMarkerAlt,
                                            color: Color(0xFFFACF39),
                                          ),
                                        ),
                                        Text(order.address,
                                            overflow: TextOverflow.clip,
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
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
                                          width: ekrangenisligi / 2.225,
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
                                        ),
                                        SizedBox(
                                          height: ekranyuksekligi / 15,
                                          width: ekrangenisligi / 2.225,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              MapsLauncher.launchQuery(
                                                  order.address);
                                            },
                                            elevation: 0,
                                            color: Color(0xB337CDD4),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                            )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.mapMarkedAlt,
                                                  color: Colors.white,
                                                  size: ekrangenisligi / 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text("Show Map",
                                                      style: TextStyle(
                                                          fontFamily: "Inter",
                                                          fontSize:
                                                              ekrangenisligi /
                                                                  27,
                                                          color: Colors.white)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ), // Haritada G??ster Butonu
                                      ],
                                    ),
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
                                    FontAwesomeIcons.truck,
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
          ), // geri tu??u
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:picker_packer/model/picker_order_prepare.dart';
import 'package:picker_packer/model/picker_order_prepare_current_item.dart';
import 'package:picker_packer/model/picker_order_prepare_item.dart';
import 'package:picker_packer/model/picker_order_prepare_price_distance.dart';
import 'package:picker_packer/model/picker_prepare_get_item.dart';
import 'package:picker_packer/provider/picker_order_prepare_add_alternative_item_service.dart';
import 'package:picker_packer/provider/picker_order_prepare_add_item_service.dart';
import 'package:picker_packer/provider/picker_order_prepare_current_item_service.dart';
import 'package:picker_packer/provider/picker_order_prepare_item_delete_service.dart';
import 'package:picker_packer/provider/picker_order_prepare_items_service.dart';
import 'package:picker_packer/provider/picker_order_prepare_price_distance_service.dart';
import 'package:picker_packer/provider/picker_prepare_get_items_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PickerOrderPrepareDetailsWidget extends StatefulWidget {
  final Picker_Order_Prepare order;
  const PickerOrderPrepareDetailsWidget({Key key, @required this.order})
      : super(key: key);

  @override
  _PickerOrderPrepareDetailsWidgetState createState() =>
      _PickerOrderPrepareDetailsWidgetState(order);
}

class _PickerOrderPrepareDetailsWidgetState
    extends State<PickerOrderPrepareDetailsWidget>
    with SingleTickerProviderStateMixin {
  Picker_Order_Prepare order;
  _PickerOrderPrepareDetailsWidgetState(order) {
    this.order = order;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PickerOrderPrepareItemsService orderItemsService =
      new PickerOrderPrepareItemsService();
  List<Picker_Order_Prepare_Item> order_items =
      new List<Picker_Order_Prepare_Item>();

  PickerOrderPreparePriceDistanceService priceDistanceService =
      new PickerOrderPreparePriceDistanceService();
  Picker_Order_Prepare_Price_Distance price_distance =
      new Picker_Order_Prepare_Price_Distance(0);

  PickerOrderPrepareItemDeleteService itemDeleteService =
      new PickerOrderPrepareItemDeleteService();
  PickerOrderPrepareAddItemService itemAddService =
      new PickerOrderPrepareAddItemService();
  PickerOrderPrepareAddAlternativeItemService itemAddAlternativeService =
      new PickerOrderPrepareAddAlternativeItemService();

  PickerPrepareGetItemsService getItemsService =
      new PickerPrepareGetItemsService();
  List<Picker_Prepare_Get_Item> get_items = new List<Picker_Prepare_Get_Item>();

  PickerPrepareGetCurrentItemsService getCurrentItemsService =
      new PickerPrepareGetCurrentItemsService();
  List<Picker_Order_Prepare_Current_Item> get_current_items =
      new List<Picker_Order_Prepare_Current_Item>();

  @override
  void initState() {
    super.initState();
    orderItemsService.setOrderId(order.order_id);
    priceDistanceService.setOrderId(order.order_id);
    getCurrentItemsService.setOrderId(order.order_id);
    updateOrderItemsList();
    updatePriceDistance();
    updateGetItemsList();
    updateGetCurrentItemsList();
  }

  updateGetItemsList() async {
    get_items = await getItemsService.request();
    setState(() {});
  }

  updateGetCurrentItemsList() async {
    get_current_items = await getCurrentItemsService.request();
    setState(() {});
  }

  updateOrderItemsList() async {
    order_items = await orderItemsService.request();
    setState(() {});
  }

  updatePriceDistance() async {
    price_distance = await priceDistanceService.request();
    setState(() {});
  }

  itemDelete() async {
    var res = await itemDeleteService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully delete ' +
              itemDeleteService.name +
              ' from Order #' +
              order.order_id.toString() +
              ' !',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'Don\'t forget to remove the item/items from the cart. !',
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
            'You couldn\'t delete ' +
                itemDeleteService.name +
                ' from Order #' +
                order.order_id.toString() +
                ', Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderItemsList();
    updatePriceDistance();
    updateGetCurrentItemsList();
    setState(() {});
  }

  itemAdd() async {
    var res = await itemAddService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully add ' +
              itemAddService.name +
              ' to Order #' +
              order.order_id.toString() +
              ' !',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'Don\'t forget to remove the item/items from the cart. !',
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
            'You couldn\'t add ' +
                itemAddService.name +
                ' to Order #' +
                order.order_id.toString() +
                ', Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderItemsList();
    updatePriceDistance();
    updateGetCurrentItemsList();
    setState(() {});
  }

  itemAddAlternative() async {
    var res = await itemAddAlternativeService.request();
    if (res == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully replaced ' +
              itemAddAlternativeService.old_name +
              ' with ' +
              itemAddAlternativeService.new_name +
              ' to Order #' +
              order.order_id.toString() +
              ' !',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
        ),
        backgroundColor: Color(0xFFFACF39),
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'Don\'t forget to replaced the item/items from the cart. !',
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
            'You couldn\'t replaced ' +
                itemAddAlternativeService.old_name +
                ' with ' +
                itemAddAlternativeService.new_name +
                ' to Order #' +
                order.order_id.toString() +
                ', Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Inter", color: Color(0xFF521262)),
          ),
          backgroundColor: Color(0xFFFACF39),
        ));
      }
    }

    updateOrderItemsList();
    updatePriceDistance();
    updateGetCurrentItemsList();
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
      floatingActionButton: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(right: ekrangenisligi / 10),
          ),
          SizedBox(
            width: ekrangenisligi / 3.1,
            height: ekranyuksekligi / 18,
            child: RaisedButton(
              color: Color(0xFF521262),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Change Item",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: ekrangenisligi / 32,
                          color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.only(left: ekrangenisligi / 60),
                    child: FaIcon(
                      FontAwesomeIcons.exchangeAlt,
                      color: Colors.white,
                      size: ekrangenisligi / 24,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xCEC54C82),
                        title: Text("Change Item",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: ekrangenisligi / 25,
                                color: Color(0xFF29CA68))),
                        contentPadding: const EdgeInsets.all(2),
                        content: Container(
                          width: ekrangenisligi,
                          height: ekranyuksekligi / 2.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: get_current_items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                        width: ekrangenisligi / 3.7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 80),
                                        child: Text(
                                            get_current_items[index].name,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Colors.white))),
                                    Container(
                                        width: ekrangenisligi / 3.7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 80),
                                        child: Text(
                                            get_current_items[index].category +
                                                " / " +
                                                get_current_items[index]
                                                    .subcategory,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Colors.white))),
                                    Container(
                                        width: ekrangenisligi / 7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 70),
                                        child: Text(
                                            get_current_items[index]
                                                    .price
                                                    .toString() +
                                                " \₺",
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Color(0xFFFACF39)))),
                                  ],
                                ),
                                onTap: () async {
                                  Navigator.pop(context, true);
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xCEC54C82),
                                          title: Text("Add Item",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: ekrangenisligi / 25,
                                                  color: Color(0xFF29CA68))),
                                          contentPadding:
                                              const EdgeInsets.all(2),
                                          content: Container(
                                            width: ekrangenisligi,
                                            height: ekranyuksekligi / 2.8,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: get_items.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index2) {
                                                return ListTile(
                                                  title: Row(
                                                    children: [
                                                      Container(
                                                          width:
                                                              ekrangenisligi /
                                                                  3.7,
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  ekrangenisligi /
                                                                      80),
                                                          child: Text(
                                                              get_items[index2]
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Inter",
                                                                  color: Colors
                                                                      .white))),
                                                      Container(
                                                          width:
                                                              ekrangenisligi /
                                                                  3.7,
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  ekrangenisligi /
                                                                      80),
                                                          child: Text(
                                                              get_items[index2]
                                                                      .category +
                                                                  " / " +
                                                                  get_items[
                                                                          index2]
                                                                      .subcategory,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Inter",
                                                                  color: Colors
                                                                      .white))),
                                                      Container(
                                                          width:
                                                              ekrangenisligi /
                                                                  7,
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  ekrangenisligi /
                                                                      70),
                                                          child: Text(
                                                              get_items[index2]
                                                                      .price
                                                                      .toString() +
                                                                  " \₺",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Inter",
                                                                  color: Color(
                                                                      0xFFFACF39)))),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    itemAddAlternativeService
                                                        .setItem(
                                                            get_items[index2]
                                                                .item_id,
                                                            order.order_id,
                                                            get_items[index2]
                                                                .name,
                                                            get_current_items[
                                                                    index]
                                                                .id,
                                                            get_current_items[
                                                                    index]
                                                                .name);
                                                    itemAddAlternative();
                                                    Navigator.pop(
                                                        context, true);
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
                // Hazırla kodu buraya gelecek
              },
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(right: ekrangenisligi / 4),
          ),
          SizedBox(
            width: ekrangenisligi / 3.1,
            height: ekranyuksekligi / 18,
            child: RaisedButton(
              color: Color(0xFF29CA68),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Item",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: ekrangenisligi / 32,
                          color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.only(left: ekrangenisligi / 60),
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                      size: ekrangenisligi / 24,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xCEC54C82),
                        title: Text("Add Item",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: ekrangenisligi / 25,
                                color: Color(0xFF29CA68))),
                        contentPadding: const EdgeInsets.all(2),
                        content: Container(
                          width: ekrangenisligi,
                          height: ekranyuksekligi / 2.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: get_items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                        width: ekrangenisligi / 3.7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 80),
                                        child: Text(get_items[index].name,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Colors.white))),
                                    Container(
                                        width: ekrangenisligi / 3.7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 80),
                                        child: Text(
                                            get_items[index].category +
                                                " / " +
                                                get_items[index].subcategory,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Colors.white))),
                                    Container(
                                        width: ekrangenisligi / 7,
                                        padding: EdgeInsets.only(
                                            left: ekrangenisligi / 70),
                                        child: Text(
                                            get_items[index].price.toString() +
                                                " \₺",
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                color: Color(0xFFFACF39)))),
                                  ],
                                ),
                                onTap: () {
                                  itemAddService.setItem(
                                      get_items[index].item_id,
                                      order.order_id,
                                      get_items[index].name);
                                  itemAdd();
                                  Navigator.pop(context, true);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
                // Hazırla kodu buraya gelecek
              },
            ),
          ),
        ],
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
                updatePriceDistance();
                updateGetItemsList();
                updateGetCurrentItemsList();
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
                                        Padding(
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
                                                price_distance.price_distance
                                                    .toString() +
                                                " \₺",
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: ekrangenisligi / 30,
                                                fontWeight: FontWeight.bold,
                                                color: price_distance
                                                            .price_distance <
                                                        0
                                                    ? Colors.red
                                                    : price_distance
                                                                .price_distance >
                                                            0
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: ekrangenisligi / 30),
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.shoppingCart,
                                                size: ekrangenisligi / 30,
                                                color: Color(0xFFFACF39),
                                              ),
                                              Text(
                                                "#" + order.cart_barcode,
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
                                  Column(
                                    children: [
                                      Container(
                                        height: ekranyuksekligi / 2.8,
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
                                                                        4.9,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        ekrangenisligi /
                                                                            100),
                                                                child: Text(
                                                                    order_items[index].is_added &&
                                                                            order_items[index].alternative ==
                                                                                -1
                                                                        ? "* " +
                                                                            order_items[index]
                                                                                .name
                                                                        : order_items[index].is_added &&
                                                                                order_items[index].alternative != -1
                                                                            ? "** " + order_items[index].name
                                                                            : order_items[index].name,
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 22,
                                                                        color: order_items[index].is_cart == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
                                                              ),
                                                              Container(
                                                                width:
                                                                    ekrangenisligi /
                                                                        6.7,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        ekrangenisligi /
                                                                            100),
                                                                child: Text(
                                                                    order_items[
                                                                            index]
                                                                        .category,
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 30,
                                                                        color: order_items[index].is_cart == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
                                                              ),
                                                              Container(
                                                                width:
                                                                    ekrangenisligi /
                                                                        6.7,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        ekrangenisligi /
                                                                            100),
                                                                child: Text(
                                                                    order_items[
                                                                            index]
                                                                        .subcategory,
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 30,
                                                                        color: order_items[index].is_cart == true
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
                                                                        " \₺",
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 35,
                                                                        color: order_items[index].is_cart == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
                                                              ),
                                                              Container(
                                                                width:
                                                                    ekrangenisligi /
                                                                        10,
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        ekrangenisligi /
                                                                            100),
                                                                child: Text(
                                                                    "x" +
                                                                        order_items[index]
                                                                            .amount
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        decoration: order_items[index].is_deleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                                        fontFamily: "Inter",
                                                                        fontSize: ekrangenisligi / 25,
                                                                        color: order_items[index].is_cart == true
                                                                            ? Colors.green
                                                                            : order_items[index].is_deleted
                                                                                ? Colors.red
                                                                                : Colors.white)),
                                                              ),
                                                              order_items[index]
                                                                          .is_deleted ==
                                                                      false
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        return showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              AlertDialog(
                                                                            backgroundColor:
                                                                                Color(0xB3F85FA4),
                                                                            title: Text("Are you sure to delete " + order_items[index].name + " from Order #" + order.order_id.toString() + " ?",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
                                                                            actions: <Widget>[
                                                                              FlatButton(
                                                                                child: Text("No", style: TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
                                                                                onPressed: () => Navigator.pop(context, false),
                                                                              ),
                                                                              FlatButton(
                                                                                child: Text("Yes", style: TextStyle(fontFamily: "Inter", color: Color(0xFFFACF39))),
                                                                                onPressed: () {
                                                                                  itemDeleteService.setItem(order_items[index].id, order_items[index].name);
                                                                                  itemDelete();
                                                                                  Navigator.pop(context, true);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: ekrangenisligi /
                                                                            50,
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ekrangenisligi / 400),
                                                                        child:
                                                                            FaIcon(
                                                                          FontAwesomeIcons
                                                                              .minusCircle,
                                                                          color:
                                                                              Colors.red,
                                                                          size: ekrangenisligi /
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        endIndent:
                                                            ekrangenisligi / 10,
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
                    padding: EdgeInsets.only(top: ekranyuksekligi / 2.05),
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

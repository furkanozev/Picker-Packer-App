import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:picker_packer/flutter_flow/flutter_flow_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:picker_packer/model/application_bloc.dart';
import 'package:picker_packer/model/packer_order_deliver.dart';
import 'package:picker_packer/model/user_login.dart';
import 'package:picker_packer/provider/packer_deliver_order_cancel_service.dart';
import 'package:picker_packer/provider/packer_deliver_order_complete_service.dart';
import 'package:picker_packer/provider/packer_order_deliver_service.dart';
import 'packer_order_delivery_details_widget.dart';

class PackerOrderDeliveryWidget extends StatefulWidget {
  final UserLogin user;
  PackerOrderDeliveryWidget({Key key, @required this.user}) : super(key: key);

  @override
  _PackerOrderDeliveryWidgetState createState() =>
      _PackerOrderDeliveryWidgetState(user);
}

class _PackerOrderDeliveryWidgetState extends State<PackerOrderDeliveryWidget>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  _PackerOrderDeliveryWidgetState(user) {
    this.user = user;
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var current_index;
  var applicationBloc;

  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor destinationIcon;
  Set<Marker> _markers = Set<Marker>();

  LatLng currentLocation;
  LatLng destinationLocation;

  PackerOrdersDeliverService orderService = new PackerOrdersDeliverService();
  List<Packer_Order_Deliver> orders = new List<Packer_Order_Deliver>();

  PackerOrderDeliverCancelService orderDeliverCancelService =
      new PackerOrderDeliverCancelService();
  PackerOrderDeliverCompleteService orderDeliverCompleteService =
      new PackerOrderDeliverCompleteService();

  prepareComplete() async {
    var res = await orderDeliverCompleteService.request();
    if (res == true) {
      current_index = 0;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully complete prepare Order #' +
              orderDeliverCompleteService.order_id.toString() +
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
                orderDeliverCompleteService.order_id.toString() +
                ',\nPlease check that all items are in the cart and try again!',
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

  prepareCancel() async {
    var res = await orderDeliverCancelService.request();
    if (res == true) {
      current_index = 0;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You succesfully cancel prepare Order #' +
              orderDeliverCancelService.order_id.toString() +
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
                orderDeliverCancelService.order_id.toString() +
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

  @override
  void initState() {
    super.initState();
    current_index = 0;

    // set up the marker icons
    this.setSourceAndDestinationMarkerIcons();
    updatePosition();
    if (applicationBloc.currentLocation != null)
      orderService.setCoordinate(applicationBloc.currentLocation.latitude,
          applicationBloc.currentLocation.longitude);
    orderService.setAccountId(user.id);
    updateOrderList();
  }

  updatePosition() async {
    applicationBloc = ApplicationBloc();
    setState(() {});
  }

  updateOrderList() async {
    orders = await orderService.request();
    setState(() {});
  }

  void setSourceAndDestinationMarkerIcons() async {
    destinationIcon = await BitmapDescriptor.defaultMarker;
  }

  @override
  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height;
    final double ekrangenisligi = ekranbilgisi.size.width;

    return Scaffold(
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
          "Delivery Orders",
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Stack(children: [
          (applicationBloc.currentLocation == null)
              ? Padding(
                  padding: EdgeInsets.only(
                      top: ekranyuksekligi * 0.2, left: ekrangenisligi * 0.5),
                  child: Container(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFACF39),
                      backgroundColor: Color(0x9700ADB5),
                    ),
                  ),
                )
              : Container(
                  height: ekranyuksekligi * 0.40,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    markers: _markers,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(applicationBloc.currentLocation.latitude,
                            applicationBloc.currentLocation.longitude),
                        zoom: 16),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      showPinsOnMap();
                    },
                  )),
          Container(
            padding: EdgeInsets.only(
                top: ekranyuksekligi * 0.40, bottom: ekranyuksekligi * 0.048),
            child: orderList(),
          )
        ]),
      ),
    );
  }

  void showPinsOnMap() async {
    setState(() {
      if (orders.length > 0) {
        if (current_index > orders.length) current_index = 0;
        var lat = orders[current_index].lat;
        var lng = orders[current_index].lng;
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          destinationLocation = LatLng(lat, lng);
          _markers.clear();
          _markers.add(Marker(
              markerId: MarkerId('destinationPin'),
              position: destinationLocation,
              icon: destinationIcon));
        }
      }
    });
  }

  Widget orderList() {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranyuksekligi = ekranbilgisi.size.height / 1.5;
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
              if (applicationBloc.currentLocation != null)
                orderService.setCoordinate(
                    applicationBloc.currentLocation.latitude,
                    applicationBloc.currentLocation.longitude);
              updateOrderList();
              showPinsOnMap();
            });
          },
        );
      },
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: ekrangenisligi / 30),
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
                          backgroundColor: Color(0x9700ADB5),
                          title: Text(
                              "Are you sure cancel prepare\nOrder #" +
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
                                orderDeliverCancelService
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
                    label: 'Cancel Delivery',
                  ),
                  SlidableAction(
                    onPressed: (_) async {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0x9700ADB5),
                          title: Text(
                              "Are you sure complete prepare\nOrder #" +
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
                                orderDeliverCompleteService
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
                subtitle: Center(
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.bottomStart,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ekrangenisligi / 50,
                            vertical: ekranyuksekligi / 150),
                        width: ekrangenisligi / 1.1,
                        height: ekranyuksekligi / 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xB337CDD4),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x9700ADB5),
                                blurRadius: 5,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                current_index = index;
                                await showPinsOnMap();
                                setState(() {});
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == current_index
                                        ? Color(0x98C54C82)
                                        : Color(0xFFFACF39)),
                                child: Icon(
                                  Icons.update,
                                  color: index == current_index
                                      ? Color(0xFFFACF39)
                                      : Color(0x98C54C82),
                                  size: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              ' #' +
                                                  orders[index]
                                                      .order_id
                                                      .toString(),
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: ekrangenisligi / 17,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ekrangenisligi / 9.0),
                                              child: FaIcon(
                                                FontAwesomeIcons
                                                    .solidMoneyBillAlt,
                                                size: ekrangenisligi / 20,
                                                color: Color(0xFFFACF39),
                                              ),
                                            ),
                                            Text(
                                              " " +
                                                  orders[index]
                                                      .price_distance
                                                      .toString() +
                                                  " \₺",
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Inter",
                                                  fontSize: ekrangenisligi / 22,
                                                  color: orders[index]
                                                              .price_distance <
                                                          0
                                                      ? Colors.red
                                                      : orders[index]
                                                                  .price_distance >
                                                              0
                                                          ? Colors.green
                                                          : Colors.white),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: ekrangenisligi / 4.0,
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .shoppingCart,
                                                    size: ekrangenisligi / 30,
                                                    color: Color(0xFFFACF39),
                                                  ),
                                                  Text(
                                                    ' #' +
                                                        orders[index]
                                                            .cart_barcode,
                                                    style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontSize:
                                                            ekrangenisligi / 35,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ), //SepetID
                                            Container(
                                              width: ekrangenisligi / 3.0,
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .calendarAlt,
                                                    size: ekrangenisligi / 30,
                                                    color: Color(0xFFFACF39),
                                                  ),
                                                  Text(
                                                    " " + orders[index].date,
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontSize:
                                                            ekrangenisligi / 35,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            orders[index].guess_time != '-'
                                                ? Container(
                                                    width: ekrangenisligi / 4.0,
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .stopwatch,
                                                          size: ekrangenisligi /
                                                              30,
                                                          color:
                                                              Color(0xFFFACF39),
                                                        ),
                                                        Text(
                                                          ' ' +
                                                              orders[index]
                                                                  .guess_time,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Inter",
                                                              fontSize:
                                                                  ekrangenisligi /
                                                                      35,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(), //SepetID
                                            orders[index].guess_distance != '-'
                                                ? Container(
                                                    width: ekrangenisligi / 3.0,
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons.road,
                                                          size: ekrangenisligi /
                                                              30,
                                                          color:
                                                              Color(0xFFFACF39),
                                                        ),
                                                        Text(
                                                          " " +
                                                              orders[index]
                                                                  .guess_distance,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Inter",
                                                              fontSize:
                                                                  ekrangenisligi /
                                                                      35,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ekrangenisligi / 1.35,
                            bottom: ekrangenisligi / 60),
                        child: SizedBox(
                          height: ekranyuksekligi / 14,
                          width: ekrangenisligi / 7,
                          child: RaisedButton(
                              color: Color(0xFFFACF39),
                              elevation: 5,
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: PackerOrderDeliveryDetailsWidget(
                                            order: orders[index])));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

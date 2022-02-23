import 'package:flutter/material.dart';
import 'package:picker_packer/model/user_login.dart';
import 'picker_profile_widget.dart';
import 'picker_orders_widget.dart';
import 'picker_order_history_widget.dart';

class PickerNavBarPage extends StatefulWidget {
  final UserLogin user;
  PickerNavBarPage({Key key, this.initialPage, @required this.user})
      : super(key: key);

  final String initialPage;

  @override
  _PickerNavBarPageState createState() => _PickerNavBarPageState(user);
}

/// This is the private State class that goes with NavBarPage.
class _PickerNavBarPageState extends State<PickerNavBarPage>
    with SingleTickerProviderStateMixin {
  UserLogin user;
  String _currentPage = 'picker_main';
  _PickerNavBarPageState(user) {
    this.user = user;
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'picker_profile': PickerProfileWidget(
        user: this.user,
      ),
      'picker_main': PickerOrdersWidget(
        user: this.user,
      ),
      'picker_history': PickerOrderHistoryWidget(
        user: this.user,
      ),
    };
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
              label: 'Orders',
              icon: Container(
                width: 42,
                height: 42,
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Color(0x98C54C82),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x98C54C82).withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Color(0x98C54C82).withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home, color: Colors.white),
              )),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            label: 'History',
          ),
        ],
        backgroundColor: Colors.white,
        currentIndex: tabs.keys.toList().indexOf(_currentPage),
        selectedItemColor: Color(0x98C54C82),
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        unselectedItemColor: Color(0xFF521262),
        selectedIconTheme: IconThemeData(size: 28),
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'ServicesPage.dart';
import 'accountPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _nameController = TextEditingController();
  final String _userName = ''; // Current user name
  final bool _editingName = false; // Flag to track name editing state

  // ... Rest of the code ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue,
                    ),
                    tabs: const [
                      Tab(text: 'Home'),
                      Tab(text: 'Services'),
                      Tab(text: 'Account'),
                    ],
                  ),
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                Center(child: Text('Tab 1 Content')),
                Services(),
                AccountPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'login_screen.dart';
import 'package:kanban/src/services/kanban_service.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban/src/models/card_for_listing.dart';
import 'package:kanban/src/models/api_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KanbanScreen extends StatefulWidget {
  @override
  _KanbanScreenState createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen>
    with TickerProviderStateMixin {
  KanbanService get service => GetIt.instance<KanbanService>();
  APIResponse<List<CardForListing>> _apiResponse;
  bool _isLoading = false;
  TabController controller;

  final List<Tab> tabs = <Tab>[
    Tab(text: "On hold"),
    Tab(text: "In progress"),
    Tab(text: "Needs review"),
    Tab(text: "Approved"),
  ];

  @override
  void initState() {
    _fetchCards();
    controller = new TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _fetchCards() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getCardsList();

    setState(() {
      _isLoading = false;
    });
  }

  // @override
  // bool get wantKeepAlive => true;
  ListView listViewBuilder(String tab) => ListView.builder(
        itemCount: _apiResponse.data.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(4),
        itemBuilder: (_, index) {
          if (_apiResponse.data[index].row == tab) {
            return Card(
              color: Color(0xFF424242),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  'ID: ' + _apiResponse.data[index].id.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _apiResponse.data[index].text,
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  //TODO: edit function
                },
                onLongPress: () {
                  //TODO: delete function
                },
              ),
            );
          } else {
            return SizedBox(height: 0);
          }
        },
      );

  @override
  Widget build(BuildContext context) => Builder(builder: (_) {
        if (_isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (_apiResponse.error) {
          return Center(
            child: Text(_apiResponse.errorMessage),
          );
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Log Out',
                onPressed: () {
                  FlutterSecureStorage().delete(key: "jwt");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
            bottom: TabBar(
              controller: controller,
              isScrollable: true,
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              listViewBuilder('0'),
              listViewBuilder('1'),
              listViewBuilder('2'),
              listViewBuilder('3'),
            ],
          ),
        );
      });
}

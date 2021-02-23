import 'package:flutter/material.dart';
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

class _KanbanScreenState extends State<KanbanScreen> {
  KanbanService get service => GetIt.instance<KanbanService>();
  APIResponse<List<CardForListing>> _apiResponse;
  bool _isLoading = false;

  final List<Tab> tabs = <Tab>[
    Tab(text: "0"),
    Tab(text: "1"),
    Tab(text: "2"),
    Tab(text: "3"),
  ];

  @override
  void initState() {
    _fetchCards();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    ListView listViewBuilder(String tab) {
      return ListView.builder(
        itemCount: _apiResponse.data.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          if (_apiResponse.data[index].row == tab) {
            return Card(
              margin: EdgeInsets.all(4),
              color: Color(0xFF424242),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  'ID: ' + _apiResponse.data[index].id.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
          }
        },
      );
    }

    return Builder(builder: (_) {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (_apiResponse.error) {
        return Center(
          child: Text(_apiResponse.errorMessage),
        );
      }
      return DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });

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
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                listViewBuilder("0"),
                listViewBuilder("1"),
                listViewBuilder("2"),
                listViewBuilder("3"),
              ],
            ),
          );
        }),
      );
    });
  }
}

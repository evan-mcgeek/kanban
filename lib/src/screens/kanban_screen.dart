import 'package:flutter/material.dart';

class KanbanScreen extends StatefulWidget {
  @override
  _KanbanScreenState createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'On hold'),
    Tab(text: 'In progress'),
    Tab(text: 'Needs review'),
    Tab(text: 'Approved'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  tooltip: 'Log Out',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: tabs.map((Tab tab) {
                return ListView.separated(
                    separatorBuilder: (_, __) => Divider(height: 10),
                    itemCount: 20,
                    itemBuilder: (_, index) {
                      return ListTile(
                        tileColor: Color(0xFF424242),
                        title: Text(
                          "Unique ID",
                          style: TextStyle(fontSize: 10),
                        ),
                        subtitle: Text('Task ' + (tab.text).toLowerCase()),
                        onTap: () {},
                      );
                    });
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

// ListView.separated(
// separatorBuilder: (_, __) => Divider(height: 10),
// itemCount: 20,
// itemBuilder: (_, index) {
// return ListTile(
// tileColor: Colors.blueGrey,
// title: Text(
// "ID",
// style: TextStyle(fontSize: 10),
// ),
// subtitle: Text(
// 'Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle Subtitle SubtitleSubtitleSubtitleSubtitle'),
// onTap: () {},
// );
// }),

//         appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             tooltip: 'Log Out',
//             onPressed: () {},
//           ),
//         ],
//         bottom: TabBar(
//           isScrollable: true,
//           tabs: tabs,
//           ],
//         ),
//       ),
//       body:
//   ),
//   ),
//   ),
//   );
// }

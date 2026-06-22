import 'package:claymore/pages/individual_panel.dart';
import 'package:claymore/pages/login_page.dart';
import 'package:claymore/pages/organisation_panel.dart';
import 'package:claymore/services/login_cache.dart';
import 'package:claymore/state/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final isMobile = MediaQuery.of(context).size.width < 900;

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Colors.black,
            title: Builder(
              builder: (context) {
                return Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            appData.currentPage = 'logbook';
                          });
                          DefaultTabController.of(context).animateTo(0);
                        },
                        child: Text(
                          'Logbook',
                          style: TextStyle(
                            color: appData.currentPage == 'logbook'
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: appData.currentPage == 'logbook'
                                ? FontWeight.bold
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(
                        'assets/logo.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),

                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            appData.currentPage = 'readiness';
                          });
                          DefaultTabController.of(context).animateTo(1);
                        },
                        child: Text(
                          'Readiness',
                          style: TextStyle(
                            color: appData.currentPage == 'readiness'
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: appData.currentPage == 'readiness'
                                ? FontWeight.bold
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          body: const TabBarView(
            children: [IndividualPanel(), OrganisationPanel()],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        title: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 75,
              child: Image.asset('assets/logo.jpg', fit: BoxFit.contain),
            ),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CLAYMORE',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                Text(
                  'JTAC Currency Management for the Scottish Gunners',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            Spacer(),
            Text(appData.currentUser.getUserName, style: TextStyle(fontSize: 18),),
            GestureDetector(
              onTap: () {
                LoginCache.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(flex: 6, child: IndividualPanel()),
          Expanded(flex: 4, child: OrganisationPanel()),
        ],
      ),
    );
  }
}

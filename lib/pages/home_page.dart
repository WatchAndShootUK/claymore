import 'package:claymore/models/user.dart';
import 'package:claymore/pages/individual_panel.dart';
import 'package:claymore/pages/organisation_panel.dart';
import 'package:claymore/state/app_data.dart';
import 'package:claymore/ui/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? selectedJtac;
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    if (isMobile) {
      return DefaultTabController(
        length: 4,
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
                        onPressed: () =>
                            DefaultTabController.of(context).animateTo(0),
                        child: const Text('Logbook',
                          style: TextStyle(color: Colors.grey),),
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
                        onPressed: () =>
                            DefaultTabController.of(context).animateTo(1),
                        child: const Text(
                          'Readiness',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          body: const TabBarView(
            children: [
              IndividualPanel(),
              OrganisationPanel(),
              OrganisationPanel(),
              OrganisationPanel(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        title: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 75,
            child: Image.asset('assets/logo.jpg', fit: BoxFit.contain),
          ),
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

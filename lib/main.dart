import 'package:flutter/material.dart';
import 'package:music_player/content.dart';
import 'package:music_player/customWidgets.dart';
import 'package:music_player/providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => BaseProperties(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            onSecondary: Colors.purple[300],
            background: Color.fromARGB(255, 16, 12, 36),
            primary: Colors.white,
            tertiary: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with TickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<NavigatorState> _tabNavKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              buildNavBar(),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: Navigator(
                  key: _tabNavKey,
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (context) =>
                        TabBarView(controller: tabController, children: [
                      PlaylistTab(
                        navKey: _tabNavKey,
                      ),
                      TrackTab(
                        navKey: _tabNavKey,
                      )
                    ]),
                  ),
                ),
              )),
              buildMusicBar()
            ],
          )),
    );
  }

  Widget buildNavBar() {
    return TabBar(
      controller: tabController,
      tabs: [Tab(text: "Playlists"), Tab(text: "Tracks")],
      onTap: (newTab) {
        //pop every route first
        _tabNavKey.currentState!.popUntil((route) => route.isFirst);
        context.read<BaseProperties>().changeTab(newTab);
      },
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelColor: Colors.blue[100],
      unselectedLabelColor: Colors.grey[600],
    );
  }

  Widget buildMusicBar() {
    return Row(
      children: [
        Expanded(
            child: TrackWidget(
          trackName: "trackName",
          trackArtist: "trackArtist",
          trackSource: "trackSource",
        )),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.skip_previous,
                color: Theme.of(context).colorScheme.primary)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_arrow,
                color: Theme.of(context).colorScheme.primary)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.skip_next,
                color: Theme.of(context).colorScheme.primary)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.replay,
                color: Theme.of(context).colorScheme.primary)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.queue_music,
                color: Theme.of(context).colorScheme.primary))
      ],
    );
  }
}

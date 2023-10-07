import 'dart:developer';

import 'package:dynamic_link_demo/dynamic_link_page.dart';
import 'package:dynamic_link_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log("-=-=-=-=-=-==-=--=");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log("-=-=-=-=-=-==-=--ww=");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initDynamicLinks() async {
    FirebaseDynamicLinks ins = FirebaseDynamicLinks.instance;
    ins.onLink.listen((event) {
      final Uri deepLink = event.link;
      log("URL CHECK-=-=-= $deepLink");
      String? id = deepLink.toString().split("=").last;

      log("id --- $id    ");
      if (id != "null") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicLinkPage(dataFormDynamicLink: id),
            ));
      } else {
        setLoginData();
      }
    }).onError((e) {});

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    log("=-=-8=-=-is---deepLink--- $deepLink ");
    String? id = deepLink.toString().split("=").last.toString();

    log("id --- $id  ");
    if (id != "null") {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicLinkPage(dataFormDynamicLink: id),
          ));
    } else {
      setLoginData();
    }
  }

  void setLoginData() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        (route) => false);
  }

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Splash Screen",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String? shortLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(shortLink ?? ""),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  dynamicLinks(id: "bhargav_dynamic_link");
                },
                child: const Text("Create Dynamic link"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void dynamicLinks({image, title, des, id, shareContent}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fsdynamiclink.page.link',
      link: Uri.parse(
        'https://fsdynamiclink.page.link/post?id=$id',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.dynamic_link_demo',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "bundleId",
        appStoreId: "appStoreId",
      ),
      socialMetaTagParameters: title == null
          ? null
          : SocialMetaTagParameters(
              title: '$title',
              description: '$des',
              imageUrl: Uri.parse("$image")),
    );

    FirebaseDynamicLinks ins = FirebaseDynamicLinks.instance;

    final ShortDynamicLink dynamicUrl = await ins.buildShortLink(parameters);
    print("${dynamicUrl.shortUrl.origin}${dynamicUrl.shortUrl.path}");
    shortLink = "${dynamicUrl.shortUrl.origin}${dynamicUrl.shortUrl.path}";
    setState(() {});
    Share.share(
        "Hey, check out - ${dynamicUrl.shortUrl.origin}${dynamicUrl.shortUrl.path}");
  }
}

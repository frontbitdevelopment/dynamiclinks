import 'package:dynamic_link_demo/main.dart';
import 'package:flutter/material.dart';

class DynamicLinkPage extends StatefulWidget {
  final String? dataFormDynamicLink;

  const DynamicLinkPage({super.key, this.dataFormDynamicLink});

  @override
  State<DynamicLinkPage> createState() => _DynamicLinkPageState();
}

class _DynamicLinkPageState extends State<DynamicLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(title: "From Dynamic link"),
              ),
              (route) => false);
          return false;
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Here show data form dynamic link",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${widget.dataFormDynamicLink}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}

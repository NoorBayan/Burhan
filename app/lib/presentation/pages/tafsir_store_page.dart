import 'package:flutter/material.dart';

class TafsirStorePage extends StatelessWidget {
  const TafsirStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجر التفسير'),
      ),
      body: const Center(
        child: Text('هذه صفحة متجر التفسير'),
      ),
    );
  }
}

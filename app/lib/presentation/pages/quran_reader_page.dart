
import 'package:flutter/material.dart';

class QuranReaderPage extends StatelessWidget {
  const QuranReaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قارئ القرآن'),
      ),
      body: const Center(
        child: Text('هذه صفحة قارئ القرآن'),
      ),
    );
  }
}

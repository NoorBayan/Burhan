import 'package:flutter/material.dart';

class HeaderLastRef extends StatelessWidget {
  const HeaderLastRef({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/pngtree-holy-quran-opened-front-view-photography-image_605242.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black.withValues(alpha: 0.5),
          child: const Text(
            'آخر مرجعية: سورة البقرة، آية 255',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'UthmanicHafs',
            ),
          ),
        ),
      ),
    );
  }
}

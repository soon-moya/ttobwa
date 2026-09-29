import 'package:flutter/material.dart';

class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('원생')),
      body: const Center(child: Text('원생 관리 화면 (준비 중)')),
    );
  }
}

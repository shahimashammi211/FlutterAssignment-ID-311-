import 'package:flutter/material.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Page'),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Text('Hello Container Page'),
          ),

          SizedBox(
            height: 200,
            width: 200,
            child: Card(
              color: Colors.pinkAccent,
              elevation: 30,
              shadowColor: Colors.pinkAccent,
              margin: const EdgeInsets.all(30),
              child: const Center(child: Text('Hello Card')),
            ),
          ),
        ],
      ),
    );
  }
}

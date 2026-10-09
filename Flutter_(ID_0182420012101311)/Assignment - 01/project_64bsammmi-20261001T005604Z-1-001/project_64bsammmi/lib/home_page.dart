
import 'package:flutter/material.dart';
import 'package:project_64bsammmi/home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const textButton = TextButton;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage 64B"),
        backgroundColor: const Color.fromARGB(255, 164, 103, 124),
        foregroundColor: Colors.white,
        // leading: const Icon(Icons.home),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Name"),
              accountEmail: Text("Email"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              hoverColor: Colors.lime,
              title: const Text("Homepage"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              hoverColor: Colors.lime,
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              hoverColor: Colors.lime,
              onTap: () {
                Navigator.pop(context);
              },
              trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 164, 103, 124),
        foregroundColor: Colors.white,
        hoverColor: Colors.blueGrey,
        tooltip: "Write",
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),

      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          textButton(

            onPressed: null,
            child: Text("Blue"),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text("Green"),
          ),
          backgroundColor: Colors.blue,
          ForeGroundColor: Colors.white,
          shadowColor: Colors.amber,
          elevation: 10,
          OutlinedButton(
            onPressed: null,
            child: Text("Pink"),
          ),
        ],
      ),
    );
  }
}
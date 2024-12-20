 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESTapi Demo',
      home: const MyHomePage(title: 'RESTapi Demo Home Page'),
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
  static const url='http://10.0.2.2:8080/get.php';//for emulator to connect using 10.0.2.2:8080
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users=getuser();
  }

  Future<List<dynamic>>getuser() async{
    final response= await http.get(Uri.parse(url));
    if(response.statusCode==200)
    {
      debugPrint(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      throw Exception("Data not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter + WAMP MySQL"),
      ),
      body: FutureBuilder(
          future: users,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No users found'));
            } else {
              debugPrint("$users");
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return ListTile(
                    title: Text(user['id']),
                    subtitle: Text(user['name']),
                  );
                },
              );
            }
          }),
    );
  }
}












import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<List<dynamic>> futureData;

  @override
  void initState(){
    super.initState();
    futureData = fetchData();
  }
  Future<List<dynamic>> fetchData() async{
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));
    if(response.statusCode == 200){
      final jsonData = json.decode(response.body);
      final users = jsonData['data'] as List;
      return users;
    }else{
      throw Exception("Failed to load data");
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Api Example"),),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureData,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                final user = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar']),
                  ),
                  title: Text('${user['first_name']} ${user['last_name']}'),
                  subtitle: Text(user['email']),
                );
              });
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

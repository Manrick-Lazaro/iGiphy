import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _search;
  int _offset = 0;
  final _apiKey = 'b5ln3ER46WbOOjCeEaC0zpA0cJ8CTalA';

  Future<Map> _getGiphys() async {
    http.Response response;

    String route = '/v1/gifs/search';

    Map<String, dynamic> params = {
      'api_key': _apiKey,
      'offset': _offset.toString(),
      'q': _search,
    };

    if (_search == null) {
      route = '/v1/gifs/trending';

      params.remove('q');
    }

    var url = Uri.https('api.giphy.com', route, params);

    response = await http.get(url);

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGiphys().then((map) {
      print('========>>>>>>>  $map');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Expanded(
          child: Row(
            children: [
              Image.network(
                'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWM5cHl1eW1mbmQ5Y3NxMGRwZ2VjNDNxa21sa2s1NzBrb2FhMmI4ZSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7buevvUs7Y9Bw9lm/giphy.gif',
                width: 50,
                height: 50,
              ),
              Text('IGiphys', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search all the GIFs',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.pinkAccent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 3, top: 2.5),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    iconSize: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

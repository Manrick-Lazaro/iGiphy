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
    return const Placeholder();
  }
}

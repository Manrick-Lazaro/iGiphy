import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:igiphy/ui/gif_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
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

    if (_search == '') {
      route = '/v1/gifs/trending';

      params.remove('q');
    }

    var url = Uri.https('api.giphy.com', route, params);

    response = await http.get(url);

    return json.decode(response.body);
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
                gaplessPlayback: true,
              ),
              Text('IGiphys', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
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
                      onSubmitted: (text) {
                        setState(() {
                          _search = text;
                          _offset = 0;
                        });
                      },
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
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 3,
                      top: 2.5,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _search = _searchController.text;
                          _offset = 0;
                        });
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getGiphys(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGiphysTable(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createGiphysTable(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data['data'].length,
            itemBuilder: (context, index) {
              if (index < snapshot.data['data'].length - 1) {
                return GestureDetector(
                  child: Image.network(
                    snapshot.data['data'][index]['images']['original']['url'],
                    height: 300,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (_, _, __) => GifPage(snapshot.data['data'][index]),
                        transitionsBuilder: (_, animation, _, child) {
                          return FadeTransition(opacity: animation, child: child,);
                        }
                      ),
                    );
                  },
                );
              } else {
                return GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 70),
                      Text(
                        'Carregar mais...',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _offset += 24;
                    });
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

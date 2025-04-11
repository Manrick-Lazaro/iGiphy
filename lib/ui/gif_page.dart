import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // o app bar já implementa por padrão um back button quando emplilhado.
        // mas é possível de modifica-lo aqui.
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),

        title: Text(_gifData['title'], style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(_gifData['images']['original']['url']);
            },
            icon: Icon(Icons.share, color: Colors.white70),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.network(_gifData['images']['original']['url'])),
    );
  }
}

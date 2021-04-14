import 'package:flutter/material.dart';
import 'package:game_of_fifteen/elements/game_field.dart';
import 'package:game_of_fifteen/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DataProvider _provider = Provider.of<DataProvider>(context);
    if(_provider != null)
      //_provider.shakePieces();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Game of Fifteen',
          ),
        ),
      ),
      body: _provider != null ? Column(
        children: [
          GameField(),
        ],
      ) : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<DataProvider>(context, listen: false).shakePieces(),
        child: Icon(Icons.dashboard_customize),
        //auto_awesome_motion
        //cached
        //   multiple_stop_outlined
        //now_widgets
      ),
    );
  }
}

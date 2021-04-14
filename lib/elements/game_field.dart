import 'package:flutter/material.dart';
import 'package:game_of_fifteen/providers/data_provider.dart';
import 'package:provider/provider.dart';

import 'game_chip.dart';

// ignore: must_be_immutable
class GameField extends StatelessWidget {
  final _borderSize = 5.0;
  double _fieldSideSize;
  int _piecesInRow = 4;

  @override
  Widget build(BuildContext context) {
    _fieldSideSize = MediaQuery.of(context).size.width;
    if(Provider.of<DataProvider>(context, listen: false) != null) {
      Provider.of<DataProvider>(context, listen: false)
          .setGameFieldSize(_fieldSideSize - _borderSize * 2);
      _piecesInRow =
          Provider.of<DataProvider>(context, listen: false).piecesInRow;
    }

    return Container(
      color: Colors.black54,
      child: SizedBox(
        width: _fieldSideSize,
        height: _fieldSideSize,
        child: Center(
          child: SizedBox(
            width: _fieldSideSize - _borderSize * 2,
            height: _fieldSideSize - _borderSize * 2,
            child: Container(
              color: Colors.grey,
              child: Stack(
                children: [
                  for(int i = 1; i < _piecesInRow * _piecesInRow; i++)
                    GameChip(index: i,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

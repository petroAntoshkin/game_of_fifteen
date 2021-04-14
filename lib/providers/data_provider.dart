// import 'dart:io';
// import 'dart:math';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_of_fifteen/models/chip_coordinate.dart';

class DataProvider extends ChangeNotifier {
  List<List<int>> _pieces;
  final _piecesInRow = 4;
  final _possibleList = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 0, 15]
  ];
  final _impossibleList = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 15, 14, 0]
  ];
  double _sideSize;

  DataProvider() {
    shakePieces();
  }

  int getPieceIndex(int index, bool rowFlag) {
    ChipCoordinate _co = getPieceCoordinate(index);
    return rowFlag ? _co.row : _co.column;
  }

  ChipCoordinate getPieceCoordinate(int index) {
    ChipCoordinate _res;
    for (int i = 0; i < _pieces.length; i++) {
      for (int j = 0; j < _pieces[i].length; j++) {
        if (_pieces[i][j] == index) _res = ChipCoordinate(row: i, column: j);
      }
    }
    return _res;
  }

  get piecesInRow {
    return _piecesInRow;
  }

  void setGameFieldSize(double value) {
    _sideSize = value / _piecesInRow;
  }

  get sideSize {
    return _sideSize;
  }

  void _generatePieces() {
    _pieces = new List.generate(_piecesInRow, (_) => new List(_piecesInRow));
    List<int> _allNumbers =
        new List.generate(_piecesInRow * _piecesInRow, (index) => index);
    int _elem;
    for (int i = 0; i < _piecesInRow; i++) {
      for (int j = 0; j < _piecesInRow; j++) {
        _elem = _allNumbers.removeAt(new Random().nextInt(_allNumbers.length));
        _pieces[i][j] = _elem;
        // _pieces[i][j] = _possibleList[i][j];
      }
    }
  }

  void shakePieces() {
    _pieces = _impossibleList;
    while (!isPossible) {
      _generatePieces();
    }
    notifyListeners();
  }

  Offset getPossibleMoveOffset(int index) {
    double _dx = 0, _dy = 0;
    final _row = getPieceIndex(index, true), _col = getPieceIndex(index, false);
    if (_row + 1 < _piecesInRow && _pieces[_row + 1][_col] == 0)
      _dy = 1;
    else if (_row > 0 && _pieces[_row - 1][_col] == 0) _dy = -1;
    if (_col + 1 < _piecesInRow && _pieces[_row][_col + 1] == 0)
      _dx = -1;
    else if (_col > 0 && _pieces[_row][_col - 1] == 0) _dx = 1;
    // print('ask for ceil $_row, $_col offset x=$_dx, y=$_dy');
    return Offset(_dx, _dy);
  }

  get isDone {
    bool _res = true;
    int _counter = 1;
    for (int i = 0; i < _piecesInRow; i++) {
      for (int j = 0; j < _piecesInRow; j++) {
        if (_counter < _piecesInRow * _piecesInRow)
          _res = _res && (_pieces[i][j] == _counter++);
      }
    }
    return _res;
  }

  get isPossible {
    int _sum = 0;
    for (int i = 0; i < _piecesInRow; i++) {
      for (int j = 0; j < _piecesInRow; j++) {
        _sum += _smallestPiecesCount(i, j);
      }
    }
    _sum += getPieceCoordinate(0).row + 1;
    return _sum.isEven;
  }

  int _smallestPiecesCount(int i, int j) {
    int _smallestPiece = 0;
    for (int ii = 0; ii < i; ii++) {
      for (int jj = 0; jj < j; jj++) {
        if (_pieces[i][j] > _pieces[ii][jj]) _smallestPiece++;
      }
    }
    return _smallestPiece;
  }

  void swapChip(int index) {
    ChipCoordinate _target = getPieceCoordinate(index);
    ChipCoordinate _zero = getPieceCoordinate(0);
    _pieces[_zero.row][_zero.column] = index;
    _pieces[_target.row][_target.column] = 0;
    // print('check after swipe $isDone');
    notifyListeners();
  }
  void onChipTap(int index){
    Offset _of = getPossibleMoveOffset(index);
    if(_of.dx != 0 || _of.dy != 0)
      swapChip(index);
  }
}

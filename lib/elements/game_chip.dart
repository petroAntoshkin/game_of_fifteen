import 'package:flutter/material.dart';
import 'package:game_of_fifteen/providers/data_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GameChip extends StatefulWidget {
  int index;

  GameChip({@required this.index});

  @override
  _GameChipState createState() => _GameChipState();
}

class _GameChipState extends State<GameChip> {
  double _size;
  final _borderSize = 5.0;
  Offset _startPosition, _moveOffset;
  double _displaceX = 0, _displaceY = 0;
  bool _canDrag = true;
  @override
  Widget build(BuildContext context) {
    _size = Provider.of<DataProvider>(context).sideSize;
    // if(!_canDrag)
    //   _displaceX = _displaceY = 0;
    final _column = Provider.of<DataProvider>(context).getPieceIndex(widget.index, false);
    final _row = Provider.of<DataProvider>(context).getPieceIndex(widget.index, true);
    _canDrag = _canDrag && !Provider.of<DataProvider>(context).isDone;
    // print('isDone=${Provider.of<DataProvider>(context).isDone}');
    return Container(
      child: Positioned(
        left: _column * _size + _displaceX,
        top: _row * _size + _displaceY,
        child: GestureDetector(
          onTap: () => Provider.of<DataProvider>(context, listen: false).onChipTap(widget.index),
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          child: SizedBox(
            width: _size,
            height: _size,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: SizedBox(
                height: 10.0,
                child: Center(
                  child: Text(
                    '${widget.index}',
                    style: TextStyle(
                      fontSize: 44.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onScaleStart(ScaleStartDetails details) {
    _startPosition = details.focalPoint;
    _moveOffset = Provider.of<DataProvider>(context, listen: false).getPossibleMoveOffset(widget.index);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if(_canDrag) {
      setState(() {
        if ((details.focalPoint.dx >= _startPosition.dx &&
                _moveOffset.dx < 0) ||
            (details.focalPoint.dx < _startPosition.dx && _moveOffset.dx > 0))
          _displaceX = (details.focalPoint.dx - _startPosition.dx) *
              _moveOffset.dx.abs();
        if ((details.focalPoint.dy >= _startPosition.dy &&
                _moveOffset.dy > 0) ||
            (details.focalPoint.dy < _startPosition.dy && _moveOffset.dy < 0))
          _displaceY = (details.focalPoint.dy - _startPosition.dy) *
              _moveOffset.dy.abs();
        if (_displaceY.abs() > _size / 2 || _displaceX.abs() > _size / 2) {
          _canDrag = false;
          Provider.of<DataProvider>(context, listen: false).swapChip(widget.index);
          _displaceX = _displaceY = 0;
        }
      });
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      _displaceX = _displaceY = 0;
      _canDrag = true;
    });
  }
}

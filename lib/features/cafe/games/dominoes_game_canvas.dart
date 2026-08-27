import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Single Domino Tile model
class DominoTile {
  final int left;
  final int right;
  final bool isDouble;

  const DominoTile(this.left, this.right) : isDouble = left == right;

  int get totalPips => left + right;

  DominoTile flipped() => DominoTile(right, left);

  @override
  String toString() => '[$left|$right]';
}

/// Dominoes Game Canvas with Exact Egyptian Rules
class DominoesGameCanvas extends StatefulWidget {
  final bool isSpectator;
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;

  const DominoesGameCanvas({
    super.key,
    this.isSpectator = false,
    this.player1Name = 'أنت (المواطن)',
    this.player2Name = 'المعلم عضلات 🦞',
    this.player1Avatar = '🧽',
    this.player2Avatar = '🦞',
  });

  @override
  State<DominoesGameCanvas> createState() => _DominoesGameCanvasState();
}

class _DominoesGameCanvasState extends State<DominoesGameCanvas> {
  late List<DominoTile> _boneyard;
  late List<DominoTile> _playerHand;
  late List<DominoTile> _opponentHand;
  late List<DominoTile> _boardChain;
  int? _openLeft;
  int? _openRight;
  int _currentTurn = 0; // 0: Player, 1: Opponent
  String? _statusBanner;
  String? _winnerMessage;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final allTiles = <DominoTile>[];
    for (int i = 0; i <= 6; i++) {
      for (int j = i; j <= 6; j++) {
        allTiles.add(DominoTile(i, j));
      }
    }
    allTiles.shuffle(Random());

    _playerHand = allTiles.sublist(0, 7);
    _opponentHand = allTiles.sublist(7, 14);
    _boneyard = allTiles.sublist(14);
    _boardChain = [];
    _openLeft = null;
    _openRight = null;
    _winnerMessage = null;
    _statusBanner = 'ابدأ الدور بأعلى دوبل أو اسحب من البلاط! 🁓';

    DominoTile? firstTile;
    for (int d = 6; d >= 0; d--) {
      if (_playerHand.any((t) => t.left == d && t.right == d)) {
        firstTile = DominoTile(d, d);
        _playerHand.removeWhere((t) => t.left == d && t.right == d);
        _currentTurn = 1;
        break;
      } else if (_opponentHand.any((t) => t.left == d && t.right == d)) {
        firstTile = DominoTile(d, d);
        _opponentHand.removeWhere((t) => t.left == d && t.right == d);
        _currentTurn = 0;
        break;
      }
    }

    if (firstTile != null) {
      _boardChain.add(firstTile);
      _openLeft = firstTile.left;
      _openRight = firstTile.right;
      _statusBanner = 'تم لعب ${firstTile.left}-${firstTile.right}! الدور على الدور التالي';
    } else {
      firstTile = _playerHand.removeAt(0);
      _boardChain.add(firstTile);
      _openLeft = firstTile.left;
      _openRight = firstTile.right;
      _currentTurn = 1;
    }

    if (_currentTurn == 1 && !widget.isSpectator) {
      _triggerOpponentBotMove();
    }
  }

  bool _canPlay(DominoTile tile) {
    if (_openLeft == null || _openRight == null) return true;
    return tile.left == _openLeft ||
        tile.right == _openLeft ||
        tile.left == _openRight ||
        tile.right == _openRight;
  }

  void _playTile(DominoTile tile, {bool forceLeft = false}) {
    if (_currentTurn != 0 && !widget.isSpectator) return;
    if (_winnerMessage != null) return;

    final canLeft = tile.left == _openLeft || tile.right == _openLeft;
    final canRight = tile.left == _openRight || tile.right == _openRight;

    if (!canLeft && !canRight) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.deep,
          duration: const Duration(seconds: 1),
          content: Text(
            'الحجر دا مش راكب على أي طرف يا معلم! 🁓',
            style: BikiniTypography.body(color: BikiniColors.card),
          ),
        ),
      );
      return;
    }

    setState(() {
      _playerHand.remove(tile);
      if (canLeft && (forceLeft || !canRight)) {
        if (tile.right == _openLeft) {
          _boardChain.insert(0, tile);
          _openLeft = tile.left;
        } else {
          _boardChain.insert(0, tile.flipped());
          _openLeft = tile.right;
        }
      } else {
        if (tile.left == _openRight) {
          _boardChain.add(tile);
          _openRight = tile.right;
        } else {
          _boardChain.add(tile.flipped());
          _openRight = tile.left;
        }
      }

      _checkEndConditions();
      if (_winnerMessage == null) {
        _currentTurn = 1;
        _statusBanner = 'دور ${widget.player2Name} بيفكر في نقلته... 🦞';
        _triggerOpponentBotMove();
      }
    });
  }

  void _drawFromBoneyard() {
    if (_boneyard.isEmpty) {
      setState(() {
        _currentTurn = 1;
        _statusBanner = 'البلاطة خلصت! تم تمرير الدور للخصم 🁓';
        _triggerOpponentBotMove();
      });
      return;
    }

    setState(() {
      final drawn = _boneyard.removeLast();
      _playerHand.add(drawn);
      _statusBanner = 'سحبت حجر جديد من البلاط! [${drawn.left}|${drawn.right}]';
    });
  }

  void _triggerOpponentBotMove() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _winnerMessage != null) return;

      setState(() {
        final playable = _opponentHand.where(_canPlay).toList();
        if (playable.isNotEmpty) {
          final tile = playable.first;
          _opponentHand.remove(tile);

          final canLeft = tile.left == _openLeft || tile.right == _openLeft;
          if (canLeft) {
            if (tile.right == _openLeft) {
              _boardChain.insert(0, tile);
              _openLeft = tile.left;
            } else {
              _boardChain.insert(0, tile.flipped());
              _openLeft = tile.right;
            }
          } else {
            if (tile.left == _openRight) {
              _boardChain.add(tile);
              _openRight = tile.right;
            } else {
              _boardChain.add(tile.flipped());
              _openRight = tile.left;
            }
          }
          _statusBanner = '${widget.player2Name} لعب [${tile.left}|${tile.right}]!';
        } else if (_boneyard.isNotEmpty) {
          _opponentHand.add(_boneyard.removeLast());
          _statusBanner = '${widget.player2Name} سحب حجر من البلاط 🁓';
        } else {
          _statusBanner = '${widget.player2Name} باس ومعهوش حجر يلعب بيه!';
        }

        _checkEndConditions();
        if (_winnerMessage == null) {
          _currentTurn = 0;
        }
      });
    });
  }

  void _checkEndConditions() {
    if (_playerHand.isEmpty) {
      _winnerMessage = '🎉 قفلت الدور يا بطل! كسبت المعلم عضلات واحتلت الطربيزة! 🁓👑';
      return;
    }
    if (_opponentHand.isEmpty) {
      _winnerMessage = '💀 المعلم عضلات قفل الدور عليك وكسب الجولة! حظ أوفر يا مواطن!';
      return;
    }

    final playerHasMove = _playerHand.any(_canPlay);
    final opponentHasMove = _opponentHand.any(_canPlay);
    if (!playerHasMove && !opponentHasMove && _boneyard.isEmpty) {
      final playerPips = _playerHand.fold<int>(0, (sum, t) => sum + t.totalPips);
      final oppPips = _opponentHand.fold<int>(0, (sum, t) => sum + t.totalPips);

      if (playerPips < oppPips) {
        _winnerMessage = '🔥 كتمت! ومجموع نقطك ($playerPips) أقل من الخصم ($oppPips).. أنت الفائز!';
      } else if (playerPips > oppPips) {
        _winnerMessage = '💥 كتمت! ونقطك ($playerPips) أكبر من الخصم ($oppPips).. الخصم فاز!';
      } else {
        _winnerMessage = '🤝 كتمت وتعادل في النقط ($playerPips)! صلح على القهوة!';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BikiniSpacing.space12),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        children: [
          // Opponent Status Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: BikiniColors.paper,
                        shape: BoxShape.circle,
                        border: Border.all(color: BikiniColors.ink, width: 1.5),
                      ),
                      child: Center(
                        child: Text(widget.player2Avatar, style: const TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.player2Name,
                            style: BikiniTypography.label(color: BikiniColors.deep),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'معاه ${_opponentHand.length} أحجار',
                            style: BikiniTypography.caption(color: BikiniColors.muted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              BikiniBadge(
                text: 'البلاط: ${_boneyard.length} 🁓',
                backgroundColor: BikiniColors.paper,
                textColor: BikiniColors.ink,
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Game Status / Winner Banner
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BikiniSpacing.space12,
              vertical: BikiniSpacing.space8,
            ),
            decoration: BoxDecoration(
              color: BikiniColors.paper,
              borderRadius: BorderRadius.circular(BikiniRadius.button),
              border: Border.all(color: BikiniColors.ink, width: 1.5),
            ),
            child: Row(
              children: [
                Text(_winnerMessage != null ? '🏆' : '📢', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: BikiniSpacing.space8),
                Expanded(
                  child: Text(
                    _winnerMessage ?? _statusBanner ?? 'العَب دورك يا مواطن!',
                    style: BikiniTypography.caption(
                      color: _winnerMessage != null ? BikiniColors.alert : BikiniColors.deep,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Dominoes Chain Board (Horizontal Scrollable Table)
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: BikiniColors.deep,
              borderRadius: BorderRadius.circular(BikiniRadius.card),
              border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
            ),
            child: _boardChain.isEmpty
                ? Center(
                    child: Text(
                      'الطربيزة فاضية.. ابدأ أول حجر!',
                      style: BikiniTypography.caption(color: BikiniColors.card),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _boardChain.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 4),
                    itemBuilder: (ctx, i) {
                      final tile = _boardChain[i];
                      return _buildBoardDominoWidget(tile);
                    },
                  ),
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Player Hand & Controls Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: BikiniColors.paper,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.ink, width: 1.5),
                    ),
                    child: Center(
                      child: Text(widget.player1Avatar, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: BikiniSpacing.space8),
                  Text(
                    'أحجارك (${_playerHand.length}):',
                    style: BikiniTypography.caption(color: BikiniColors.deep),
                  ),
                ],
              ),
              if (!widget.isSpectator && _winnerMessage == null)
                GestureDetector(
                  onTap: _drawFromBoneyard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BikiniColors.paper,
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      border: Border.all(color: BikiniColors.ink, width: 1.2),
                    ),
                    child: Text(
                      _boneyard.isNotEmpty ? 'سحب حجر 🁓' : 'تمرير الدور ⏩',
                      style: BikiniTypography.caption(color: BikiniColors.deep),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Player Tiles Horizontal List
          SizedBox(
            height: 75,
            child: _playerHand.isEmpty
                ? Center(
                    child: Text(
                      'معكش أحجار في إيدك! 🎉',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _playerHand.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                    itemBuilder: (ctx, i) {
                      final tile = _playerHand[i];
                      final isPlayable = _canPlay(tile) && !widget.isSpectator && _currentTurn == 0;
                      return GestureDetector(
                        onTap: isPlayable ? () => _playTile(tile) : null,
                        child: _buildHandDominoWidget(tile, isPlayable: isPlayable),
                      );
                    },
                  ),
          ),

          if (_winnerMessage != null) ...[
            const SizedBox(height: BikiniSpacing.space8),
            BikiniButton.primary(
              onPressed: _startNewGame,
              text: 'لعب دور جديد 🁓🔄',
              isFullWidth: true,
              height: 48,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBoardDominoWidget(DominoTile tile) {
    return Container(
      width: 44,
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: BikiniColors.card,
        borderRadius: BorderRadius.circular(BikiniRadius.button),
        border: Border.all(color: BikiniColors.ink, width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.ink,
            offset: Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPips(tile.left),
          Container(height: 1.5, width: 34, color: BikiniColors.ink),
          _buildPips(tile.right),
        ],
      ),
    );
  }

  Widget _buildHandDominoWidget(DominoTile tile, {bool isPlayable = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 42,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isPlayable ? BikiniColors.paper : BikiniColors.card,
        borderRadius: BorderRadius.circular(BikiniRadius.button),
        border: Border.all(
          color: isPlayable ? BikiniColors.deep : BikiniColors.ink,
          width: isPlayable ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: BikiniColors.ink,
            offset: isPlayable ? const Offset(2.5, 2.5) : const Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${tile.left}', style: BikiniTypography.mono(color: BikiniColors.ink)),
          Container(height: 1.2, width: 30, color: BikiniColors.ink),
          Text('${tile.right}', style: BikiniTypography.mono(color: BikiniColors.ink)),
        ],
      ),
    );
  }

  Widget _buildPips(int count) {
    return Text(
      count.toString(),
      style: BikiniTypography.mono(color: BikiniColors.ink),
    );
  }
}

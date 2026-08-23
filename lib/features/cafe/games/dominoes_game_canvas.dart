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
    // Generate all 28 tiles
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

    // Auto-place highest double or let player start
    DominoTile? firstTile;
    for (int d = 6; d >= 0; d--) {
      if (_playerHand.any((t) => t.left == d && t.right == d)) {
        firstTile = DominoTile(d, d);
        _playerHand.removeWhere((t) => t.left == d && t.right == d);
        _currentTurn = 1; // opponent turn next
        break;
      } else if (_opponentHand.any((t) => t.left == d && t.right == d)) {
        firstTile = DominoTile(d, d);
        _opponentHand.removeWhere((t) => t.left == d && t.right == d);
        _currentTurn = 0; // player turn next
        break;
      }
    }

    if (firstTile != null) {
      _boardChain.add(firstTile);
      _openLeft = firstTile.left;
      _openRight = firstTile.right;
      _statusBanner = 'تم لعب ${firstTile.left}-${firstTile.right}! الدور على الدور التالي';
    } else {
      // Pick first from player
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
          backgroundColor: BikiniColors.cartoonBlack,
          duration: const Duration(seconds: 1),
          content: Text('الحجر دا مش راكب على أي طرف يا معلم! 🁓',
              style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow)),
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
      // Pass turn
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

    // Check if blocked (كتمت)
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BikiniColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 3),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
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
                        color: BikiniColors.krabsRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                      ),
                      child: Center(
                        child: Text(widget.player2Avatar, style: const TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.player2Name,
                            style: BikiniTypography.titleBold().copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'معاه ${_opponentHand.length} أحجار',
                            style: BikiniTypography.caption(color: const Color(0xFF666666)).copyWith(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              BikiniBadge(
                text: 'البلاط: ${_boneyard.length} 🁓',
                backgroundColor: BikiniColors.spongeYellow,
                textColor: BikiniColors.cartoonBlack,
                fontSize: 10,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Game Status / Winner Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _winnerMessage != null ? BikiniColors.spongeYellow : BikiniColors.warmSand,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
            ),
            child: Row(
              children: [
                Text(_winnerMessage != null ? '🏆' : '📢', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _winnerMessage ?? _statusBanner ?? 'العَب دورك يا مواطن!',
                    style: BikiniTypography.captionBold(
                      color: _winnerMessage != null ? BikiniColors.krabsRed : BikiniColors.cartoonBlack,
                    ).copyWith(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Dominoes Chain Board (Horizontal Scrollable Table)
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4332), // Classic green felt table
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BikiniColors.cartoonBlack, width: 2.5),
            ),
            child: _boardChain.isEmpty
                ? const Center(
                    child: Text('الطربيزة فاضية.. ابدأ أول حجر!',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
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

          const SizedBox(height: 10),

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
                      color: BikiniColors.spongeYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    child: Center(
                      child: Text(widget.player1Avatar, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'أحجارك (${_playerHand.length}):',
                    style: BikiniTypography.captionBold().copyWith(fontSize: 11.5),
                  ),
                ],
              ),
              if (!widget.isSpectator && _winnerMessage == null)
                GestureDetector(
                  onTap: _drawFromBoneyard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BikiniColors.marineCyan,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    child: Text(
                      _boneyard.isNotEmpty ? 'سحب حجر 🁓' : 'تمرير الدور ⏩',
                      style: BikiniTypography.captionBold().copyWith(fontSize: 10.5),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Player Tiles Horizontal List
          SizedBox(
            height: 75,
            child: _playerHand.isEmpty
                ? const Center(child: Text('معكش أحجار في إيدك! 🎉'))
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
            const SizedBox(height: 8),
            BikiniButton.primary(
              onPressed: _startNewGame,
              text: 'لعب دور جديد 🁓🔄',
              isFullWidth: true,
              height: 40,
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
        color: const Color(0xFFFFFFFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPips(tile.left),
          Container(height: 1.5, width: 34, color: BikiniColors.cartoonBlack),
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
        color: isPlayable ? BikiniColors.spongeYellow : const Color(0xFFFFFFFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPlayable ? BikiniColors.krabsRed : BikiniColors.cartoonBlack,
          width: isPlayable ? 2.5 : 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: isPlayable ? const Offset(2.5, 2.5) : const Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${tile.left}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Container(height: 1.2, width: 30, color: BikiniColors.cartoonBlack),
          Text('${tile.right}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPips(int count) {
    return Text(
      count.toString(),
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15,
        color: BikiniColors.cartoonBlack,
      ),
    );
  }
}

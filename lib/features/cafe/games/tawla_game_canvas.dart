import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Tawla (Backgammon) Board & Checker Models
class TawlaPoint {
  final int id; // 0 to 23
  int player1Checkers; // Player 1 (Support / Cyan)
  int player2Checkers; // Player 2 (Coin / Gold)

  TawlaPoint(this.id, {this.player1Checkers = 0, this.player2Checkers = 0});
}

/// Tawla (Backgammon) Game Canvas with Exact Egyptian Rules
class TawlaGameCanvas extends StatefulWidget {
  final bool isSpectator;
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;

  const TawlaGameCanvas({
    super.key,
    this.isSpectator = false,
    this.player1Name = 'أنت (المواطن)',
    this.player2Name = 'مستر سلطع 💰',
    this.player1Avatar = '🧽',
    this.player2Avatar = '🦀',
  });

  @override
  State<TawlaGameCanvas> createState() => _TawlaGameCanvasState();
}

class _TawlaGameCanvasState extends State<TawlaGameCanvas> with SingleTickerProviderStateMixin {
  late List<TawlaPoint> _points;
  int _player1Bar = 0;
  int _player2Bar = 0;
  int _player1BorneOff = 0;

  int _dice1 = 5;
  int _dice2 = 3;
  List<int> _availableMoves = [];
  int _currentTurn = 0; // 0: Player 1, 1: Player 2
  int? _selectedPointIndex;
  bool _hasRolled = false;
  String? _winnerMessage;
  String? _statusBanner;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initTawlaBoard();
  }

  void _initTawlaBoard() {
    _points = List.generate(24, (i) => TawlaPoint(i));

    // Standard starting setup
    _points[0].player1Checkers = 2;
    _points[11].player1Checkers = 5;
    _points[16].player1Checkers = 3;
    _points[18].player1Checkers = 5;

    _points[23].player2Checkers = 2;
    _points[12].player2Checkers = 5;
    _points[7].player2Checkers = 3;
    _points[5].player2Checkers = 5;

    _player1Bar = 0;
    _player2Bar = 0;
    _player1BorneOff = 0;
    _dice1 = 6;
    _dice2 = 5;
    _availableMoves = [];
    _hasRolled = false;
    _currentTurn = 0;
    _selectedPointIndex = null;
    _winnerMessage = null;
    _statusBanner = 'ارمي الزهر يا معلم وابدأ التحريك! 🎲';
  }

  void _rollDice() {
    if (_hasRolled || _winnerMessage != null) return;
    if (_currentTurn != 0 && !widget.isSpectator) return;

    setState(() {
      _dice1 = 1 + _random.nextInt(6);
      _dice2 = 1 + _random.nextInt(6);
      _hasRolled = true;

      if (_dice1 == _dice2) {
        _availableMoves = [_dice1, _dice1, _dice1, _dice1];
        _statusBanner = 'دوشيش دوبل ($_dice1-$_dice2)! معاك ٤ نقلات! 🔥🎲';
      } else {
        _availableMoves = [_dice1, _dice2];
        _statusBanner = 'رميت $_dice1 و $_dice2.. حدد القشاط للنقل!';
      }
    });
  }

  void _selectPoint(int pointIndex) {
    if (!_hasRolled || _availableMoves.isEmpty || _winnerMessage != null) return;
    if (_currentTurn != 0 && !widget.isSpectator) return;

    final pt = _points[pointIndex];
    if (pt.player1Checkers <= 0) return;

    setState(() {
      _selectedPointIndex = pointIndex;
    });
  }

  void _moveChecker(int targetIndex) {
    if (_selectedPointIndex == null || _availableMoves.isEmpty) return;

    final fromIndex = _selectedPointIndex!;
    final diff = (targetIndex - fromIndex).abs();

    if (!_availableMoves.contains(diff)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.deep,
          duration: const Duration(seconds: 1),
          content: Text(
            'النقلة دي مش مطابقة لأرقام الزهر المتاحة! 🎲',
            style: BikiniTypography.body(color: BikiniColors.card),
          ),
        ),
      );
      return;
    }

    final targetPt = _points[targetIndex];
    if (targetPt.player2Checkers >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.deep,
          duration: const Duration(seconds: 1),
          content: Text(
            'الخانة دي مقفولة بحجرين للخصم! 🚫',
            style: BikiniTypography.body(color: BikiniColors.alert),
          ),
        ),
      );
      return;
    }

    setState(() {
      _points[fromIndex].player1Checkers--;

      if (targetPt.player2Checkers == 1) {
        targetPt.player2Checkers = 0;
        _player2Bar++;
        _statusBanner = 'قشطت حجر الخصم وحبسته في البار! 💥';
      }

      targetPt.player1Checkers++;
      _availableMoves.remove(diff);
      _selectedPointIndex = null;

      if (_availableMoves.isEmpty) {
        _endTurn();
      }
    });
  }

  void _bearOffChecker() {
    if (_selectedPointIndex == null || _availableMoves.isEmpty) return;
    final fromIndex = _selectedPointIndex!;
    if (fromIndex < 18) return;

    final needed = 24 - fromIndex;
    if (_availableMoves.contains(needed) || _availableMoves.any((m) => m >= needed)) {
      setState(() {
        _points[fromIndex].player1Checkers--;
        _player1BorneOff++;
        final used = _availableMoves.contains(needed)
            ? needed
            : _availableMoves.firstWhere((m) => m >= needed);
        _availableMoves.remove(used);
        _selectedPointIndex = null;
        _statusBanner = 'طلعت قشاط برة الطاولة! ($player1TotalBorneOff/15) 🎉';

        if (_player1BorneOff >= 15) {
          _winnerMessage = '🏆 ألف مبروك! كسبت دور الطاولة وطلعت الـ ١٥ قشاط!';
        } else if (_availableMoves.isEmpty) {
          _endTurn();
        }
      });
    }
  }

  int get player1TotalBorneOff => _player1BorneOff;

  void _endTurn() {
    setState(() {
      _currentTurn = 1;
      _hasRolled = false;
      _availableMoves = [];
      _selectedPointIndex = null;
      _statusBanner = 'دور ${widget.player2Name} بيرمي الزهر... 🦀';
      _triggerBotTurn();
    });
  }

  void _triggerBotTurn() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _winnerMessage != null) return;

      setState(() {
        final d1 = 1 + _random.nextInt(6);
        final d2 = 1 + _random.nextInt(6);
        _dice1 = d1;
        _dice2 = d2;

        final p2Points = _points.where((p) => p.player2Checkers > 0).toList();
        if (p2Points.isNotEmpty) {
          final from = p2Points.first;
          final targetId = max(0, from.id - d1);
          if (_points[targetId].player1Checkers < 2) {
            from.player2Checkers--;
            if (_points[targetId].player1Checkers == 1) {
              _points[targetId].player1Checkers = 0;
              _player1Bar++;
            }
            _points[targetId].player2Checkers++;
            _statusBanner = '${widget.player2Name} رمى $d1-$d2 ونقل للخانة #${targetId + 1}!';
          }
        }

        _currentTurn = 0;
        _hasRolled = false;
      });
    });
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
          // Header Stats (Player vs Opponent)
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
                      child: Text(
                        '${widget.player2Name} (حبس: $_player2Bar)',
                        style: BikiniTypography.label(color: BikiniColors.deep),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              BikiniBadge(
                text: _currentTurn == 0 ? 'دورك أنت 🎲' : 'دور الخصم ⏳',
                backgroundColor: _currentTurn == 0 ? BikiniColors.support : BikiniColors.paper,
                textColor: BikiniColors.ink,
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Status Banner
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
                Text(_winnerMessage != null ? '🏆' : '🎲', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: BikiniSpacing.space8),
                Expanded(
                  child: Text(
                    _winnerMessage ?? _statusBanner ?? 'ارمي الزهر!',
                    style: BikiniTypography.caption(
                      color: _winnerMessage != null ? BikiniColors.alert : BikiniColors.deep,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Tawla Wooden Board (24 points grid)
          Container(
            height: 180,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: BikiniColors.deep,
              borderRadius: BorderRadius.circular(BikiniRadius.card),
              border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
              boxShadow: const [
                BoxShadow(
                  color: BikiniColors.ink,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Left quadrant (Points 0..5 and 18..23)
                Expanded(child: _buildQuadrant([0, 1, 2, 3, 4, 5], [23, 22, 21, 20, 19, 18])),

                // Center Bar (حبس)
                Container(
                  width: 24,
                  color: BikiniColors.deep2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_player1Bar > 0)
                        Text(
                          '🤿\nx$_player1Bar',
                          textAlign: TextAlign.center,
                          style: BikiniTypography.caption(color: BikiniColors.card).copyWith(fontSize: 8),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'BAR',
                        style: BikiniTypography.caption(color: BikiniColors.coin).copyWith(fontSize: 7),
                      ),
                      const SizedBox(height: 4),
                      if (_player2Bar > 0)
                        Text(
                          '🦀\nx$_player2Bar',
                          textAlign: TextAlign.center,
                          style: BikiniTypography.caption(color: BikiniColors.card).copyWith(fontSize: 8),
                        ),
                    ],
                  ),
                ),

                // Right quadrant (Points 6..11 and 12..17)
                Expanded(child: _buildQuadrant([6, 7, 8, 9, 10, 11], [17, 16, 15, 14, 13, 12])),
              ],
            ),
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Dice and Action Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dice Display
              Row(
                children: [
                  _buildDiceWidget(_dice1),
                  const SizedBox(width: BikiniSpacing.space8),
                  _buildDiceWidget(_dice2),
                  const SizedBox(width: BikiniSpacing.space8),
                  if (_availableMoves.isNotEmpty)
                    Text(
                      'متاح: ${_availableMoves.join(', ')}',
                      style: BikiniTypography.caption(color: BikiniColors.alert),
                    ),
                ],
              ),

              // Roll Dice Button
              if (!widget.isSpectator && _winnerMessage == null)
                Row(
                  children: [
                    if (_selectedPointIndex != null && _selectedPointIndex! >= 18)
                      BikiniButton.secondary(
                        onPressed: _bearOffChecker,
                        text: 'تطليع 📤',
                        height: 40,
                      ),
                    const SizedBox(width: BikiniSpacing.space8),
                    BikiniButton.primary(
                      onPressed: !_hasRolled && _currentTurn == 0 ? _rollDice : null,
                      text: 'رمي الزهر 🎲',
                      height: 40,
                    ),
                  ],
                ),
            ],
          ),

          if (_winnerMessage != null) ...[
            const SizedBox(height: BikiniSpacing.space8),
            BikiniButton.primary(
              onPressed: _initTawlaBoard,
              text: 'لعب دور جديد 🎲🔄',
              isFullWidth: true,
              height: 48,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuadrant(List<int> topIndices, List<int> bottomIndices) {
    return Column(
      children: [
        // Top Row of points
        Expanded(
          child: Row(
            children: topIndices.map((idx) => _buildPointColumn(idx, isTop: true)).toList(),
          ),
        ),
        Container(height: 4, color: BikiniColors.ink),
        // Bottom Row of points
        Expanded(
          child: Row(
            children: bottomIndices.map((idx) => _buildPointColumn(idx, isTop: false)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPointColumn(int pointIndex, {required bool isTop}) {
    final pt = _points[pointIndex];
    final isSelected = _selectedPointIndex == pointIndex;
    final isOdd = pointIndex % 2 == 0;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedPointIndex == null) {
            _selectPoint(pointIndex);
          } else {
            _moveChecker(pointIndex);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? BikiniColors.support
                : isOdd
                    ? BikiniColors.paper
                    : BikiniColors.deep2,
            border: isSelected
                ? Border.all(color: BikiniColors.ink, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: isTop ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (pt.player1Checkers > 0)
                _buildCheckerStack(pt.player1Checkers, color: BikiniColors.support, label: '🤿'),
              if (pt.player2Checkers > 0)
                _buildCheckerStack(pt.player2Checkers, color: BikiniColors.coin, label: '🦀'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckerStack(int count, {required Color color, required String label}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: BikiniColors.ink, width: 1.2),
      ),
      child: Center(
        child: Text(
          count > 1 ? '$count' : label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildDiceWidget(int value) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: BikiniColors.card,
        borderRadius: BorderRadius.circular(BikiniRadius.button),
        border: Border.all(color: BikiniColors.ink, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.ink,
            offset: Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$value',
          style: BikiniTypography.mono(color: BikiniColors.ink),
        ),
      ),
    );
  }
}

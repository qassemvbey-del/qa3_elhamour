import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

enum CardSuit { spades, hearts, diamonds, clubs }

class PlayingCard {
  final int value; // 1 (Ace) to 13 (King)
  final CardSuit suit;

  const PlayingCard(this.value, this.suit);

  String get label {
    switch (value) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return value.toString();
    }
  }

  String get suitSymbol {
    switch (suit) {
      case CardSuit.spades:
        return '♠';
      case CardSuit.hearts:
        return '♥';
      case CardSuit.diamonds:
        return '♦';
      case CardSuit.clubs:
        return '♣';
    }
  }

  Color get suitColor {
    return (suit == CardSuit.hearts || suit == CardSuit.diamonds)
        ? BikiniColors.danger
        : BikiniColors.ink;
  }

  bool get isJack => value == 11;
  bool get isKommi => value == 7 && suit == CardSuit.diamonds;

  @override
  String toString() => '$label$suitSymbol';
}

/// Egyptian Basra Card Game Canvas with Exact Capture, Kommi, and Basra Rules
class BasraGameCanvas extends StatefulWidget {
  final bool isSpectator;
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;

  const BasraGameCanvas({
    super.key,
    this.isSpectator = false,
    this.player1Name = 'أنت (المواطن)',
    this.player2Name = 'سبونج بوب 🍍',
    this.player1Avatar = '🤿',
    this.player2Avatar = '🧽',
  });

  @override
  State<BasraGameCanvas> createState() => _BasraGameCanvasState();
}

class _BasraGameCanvasState extends State<BasraGameCanvas> {
  late List<PlayingCard> _deck;
  late List<PlayingCard> _tableCards;
  late List<PlayingCard> _playerHand;
  late List<PlayingCard> _opponentHand;
  final List<PlayingCard> _playerCaptured = [];
  final List<PlayingCard> _opponentCaptured = [];
  int _playerBasras = 0;
  int _opponentBasras = 0;
  int _currentTurn = 0; // 0: Player, 1: Opponent
  String? _statusBanner;
  String? _winnerMessage;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _deck = [];
    for (final suit in CardSuit.values) {
      for (int v = 1; v <= 13; v++) {
        _deck.add(PlayingCard(v, suit));
      }
    }
    _deck.shuffle(_random);

    // Initial 4 table cards (no Jack or 7 Diamonds on initial floor)
    _tableCards = [];
    int drawn = 0;
    while (_tableCards.length < 4 && drawn < _deck.length) {
      final card = _deck[drawn];
      if (!card.isJack && !card.isKommi) {
        _tableCards.add(card);
        _deck.removeAt(drawn);
      } else {
        drawn++;
      }
    }

    _playerCaptured.clear();
    _opponentCaptured.clear();
    _playerBasras = 0;
    _opponentBasras = 0;
    _winnerMessage = null;

    _dealNewRound();
  }

  void _dealNewRound() {
    if (_deck.length < 8) {
      _calculateFinalScore();
      return;
    }

    setState(() {
      _playerHand = _deck.sublist(0, 4);
      _deck.removeRange(0, 4);
      _opponentHand = _deck.sublist(0, 4);
      _deck.removeRange(0, 4);
      _currentTurn = 0;
      _statusBanner = 'تم توزيع ٤ كروت لكل لاعب! العب كارتك 🃏';
    });
  }

  void _playCard(PlayingCard card) {
    if (_currentTurn != 0 && !widget.isSpectator) return;
    if (_winnerMessage != null) return;

    setState(() {
      _playerHand.remove(card);
      _resolveCardPlay(card, isPlayer: true);

      if (_playerHand.isEmpty && _opponentHand.isEmpty) {
        _dealNewRound();
      } else {
        _currentTurn = 1;
        _triggerOpponentBotMove();
      }
    });
  }

  void _resolveCardPlay(PlayingCard card, {required bool isPlayer}) {
    final capturedList = isPlayer ? _playerCaptured : _opponentCaptured;
    final playerName = isPlayer ? widget.player1Name : widget.player2Name;

    // 1. Jack or 7 Diamonds (Kommi) sweeps table
    if (card.isJack || card.isKommi) {
      if (_tableCards.isEmpty) {
        _tableCards.add(card);
        _statusBanner = '$playerName رمى ${card.label}${card.suitSymbol} على الأرض الفاضية!';
      } else {
        final count = _tableCards.length;
        final wasSingleCard = count == 1;

        capturedList.addAll(_tableCards);
        capturedList.add(card);
        _tableCards.clear();

        if (wasSingleCard) {
          if (isPlayer) {
            _playerBasras++;
          } else {
            _opponentBasras++;
          }
          _statusBanner = '🔥 بصرة! $playerName قش كارت واحد بالـ ${card.label} وكسب ١٠ نقط!';
        } else {
          _statusBanner = '🃏 $playerName قش الطربيزة كلها ($count كروت) بالـ ${card.label}! 💥';
        }
      }
      return;
    }

    // 2. Exact match or combination sum
    final matchingCards = <PlayingCard>[];
    for (final c in _tableCards) {
      if (c.value == card.value) {
        matchingCards.add(c);
      }
    }

    // Simple sum match (e.g. 8 takes 5 + 3)
    if (card.value <= 10) {
      for (int i = 0; i < _tableCards.length; i++) {
        for (int j = i + 1; j < _tableCards.length; j++) {
          if (_tableCards[i].value + _tableCards[j].value == card.value) {
            if (!matchingCards.contains(_tableCards[i])) matchingCards.add(_tableCards[i]);
            if (!matchingCards.contains(_tableCards[j])) matchingCards.add(_tableCards[j]);
          }
        }
      }
    }

    if (matchingCards.isNotEmpty) {
      final initialTableCount = _tableCards.length;
      for (final m in matchingCards) {
        _tableCards.remove(m);
      }
      capturedList.addAll(matchingCards);
      capturedList.add(card);

      // Check Basra (table cleared)
      if (_tableCards.isEmpty && initialTableCount > 0) {
        if (isPlayer) {
          _playerBasras++;
        } else {
          _opponentBasras++;
        }
        _statusBanner = '🎉 بصرة في عين الحسود! $playerName نظف الطربيزة وكسب ١٠ نقط بصرة!';
      } else {
        _statusBanner = '$playerName أكل ${matchingCards.length} كروت بالـ ${card.label}${card.suitSymbol}!';
      }
    } else {
      // Throw card on table
      _tableCards.add(card);
      _statusBanner = '$playerName رمى ${card.label}${card.suitSymbol} على الطربيزة';
    }
  }

  void _triggerOpponentBotMove() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _winnerMessage != null) return;

      setState(() {
        if (_opponentHand.isNotEmpty) {
          PlayingCard chosenCard = _opponentHand.first;

          final matches = _opponentHand.where((c) => _tableCards.any((tc) => tc.value == c.value)).toList();
          if (matches.isNotEmpty) {
            chosenCard = matches.first;
          } else if (_tableCards.length >= 3 && _opponentHand.any((c) => c.isJack || c.isKommi)) {
            chosenCard = _opponentHand.firstWhere((c) => c.isJack || c.isKommi);
          }

          _opponentHand.remove(chosenCard);
          _resolveCardPlay(chosenCard, isPlayer: false);
        }

        if (_playerHand.isEmpty && _opponentHand.isEmpty) {
          _dealNewRound();
        } else {
          _currentTurn = 0;
        }
      });
    });
  }

  void _calculateFinalScore() {
    int p1Score = _playerBasras * 10;
    int p2Score = _opponentBasras * 10;

    // Most cards (+30)
    if (_playerCaptured.length > _opponentCaptured.length) {
      p1Score += 30;
    } else if (_opponentCaptured.length > _playerCaptured.length) {
      p2Score += 30;
    }

    // 7 Diamonds (Kommi +10)
    if (_playerCaptured.any((c) => c.isKommi)) p1Score += 10;
    if (_opponentCaptured.any((c) => c.isKommi)) p2Score += 10;

    // 2 Clubs (Du +3)
    if (_playerCaptured.any((c) => c.value == 2 && c.suit == CardSuit.clubs)) p1Score += 3;
    if (_opponentCaptured.any((c) => c.value == 2 && c.suit == CardSuit.clubs)) p2Score += 3;

    if (p1Score > p2Score) {
      _winnerMessage = '🏆 كسبت دور البصرة! سكورك ($p1Score) مقابل ($p2Score) لـ ${widget.player2Name}!';
    } else if (p2Score > p1Score) {
      _winnerMessage = '💀 ${widget.player2Name} كسب الجولة بسكور ($p2Score) مقابل ($p1Score)!';
    } else {
      _winnerMessage = '🤝 تعادل مائي في البصرة! ($p1Score - $p2Score)';
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
          // Opponent Header & Card Backs
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
                            'مجمع: ${_opponentCaptured.length} كارت (بصرة: $_opponentBasras)',
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
                text: 'الكوتشينة: ${_deck.length} 🃏',
                backgroundColor: BikiniColors.paper,
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
              color: _winnerMessage != null ? BikiniColors.paper : BikiniColors.paper,
              borderRadius: BorderRadius.circular(BikiniRadius.button),
              border: Border.all(color: BikiniColors.ink, width: 1.5),
            ),
            child: Row(
              children: [
                Text(_winnerMessage != null ? '🏆' : '🃏', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: BikiniSpacing.space8),
                Expanded(
                  child: Text(
                    _winnerMessage ?? _statusBanner ?? 'العب كارتك واقش الطربيزة!',
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

          // Green/Deep Felt Table (Face-up Cards on the Floor)
          Container(
            height: 115,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: BikiniColors.deep,
              borderRadius: BorderRadius.circular(BikiniRadius.card),
              border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
            ),
            child: _tableCards.isEmpty
                ? Center(
                    child: Text(
                      'الطربيزة فاضية (قش نضيف)! 🃏✨',
                      style: BikiniTypography.caption(color: BikiniColors.card),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tableCards.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                    itemBuilder: (ctx, i) {
                      final card = _tableCards[i];
                      return _buildCardWidget(card);
                    },
                  ),
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Player Stats & Hand Section
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
                    'كروتك (مجمع: ${_playerCaptured.length} | بصرة: $_playerBasras):',
                    style: BikiniTypography.caption(color: BikiniColors.deep),
                  ),
                ],
              ),
              BikiniBadge(
                text: _currentTurn == 0 ? 'دورك للعب 🃏' : 'دور الخصم ⏳',
                backgroundColor: _currentTurn == 0 ? BikiniColors.support : BikiniColors.paper,
                textColor: BikiniColors.ink,
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Player Hand Cards
          SizedBox(
            height: 85,
            child: _playerHand.isEmpty
                ? Center(
                    child: Text(
                      'جاري توزيع الكروت الجديدة...',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _playerHand.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) {
                      final card = _playerHand[i];
                      final isMyTurn = _currentTurn == 0 && !widget.isSpectator && _winnerMessage == null;
                      return GestureDetector(
                        onTap: isMyTurn ? () => _playCard(card) : null,
                        child: _buildCardWidget(card, isInteractive: isMyTurn),
                      );
                    },
                  ),
          ),

          if (_winnerMessage != null) ...[
            const SizedBox(height: BikiniSpacing.space8),
            BikiniButton.primary(
              onPressed: _startNewGame,
              text: 'لعب دور جديد 🃏🔄',
              isFullWidth: true,
              height: 48,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardWidget(PlayingCard card, {bool isInteractive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 52,
      height: 80,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BikiniColors.card,
        borderRadius: BorderRadius.circular(BikiniRadius.button),
        border: Border.all(
          color: isInteractive ? BikiniColors.deep : BikiniColors.ink,
          width: isInteractive ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: BikiniColors.ink,
            offset: isInteractive ? const Offset(2.5, 2.5) : const Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.label,
                style: BikiniTypography.mono(color: card.suitColor),
              ),
              Text(
                card.suitSymbol,
                style: TextStyle(
                  fontSize: 12,
                  color: card.suitColor,
                ),
              ),
            ],
          ),
          Text(
            card.suitSymbol,
            style: TextStyle(
              fontSize: 22,
              color: card.suitColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              card.label,
              style: BikiniTypography.mono(color: card.suitColor),
            ),
          ),
        ],
      ),
    );
  }
}

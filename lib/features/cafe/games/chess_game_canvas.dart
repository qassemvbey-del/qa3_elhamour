import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

enum ChessPieceType { pawn, knight, bishop, rook, queen, king }
enum ChessColor { white, black }

class ChessPiece {
  final ChessPieceType type;
  final ChessColor color;

  const ChessPiece(this.type, this.color);

  String get symbol {
    switch (type) {
      case ChessPieceType.pawn:
        return color == ChessColor.white ? '♙' : '♟';
      case ChessPieceType.knight:
        return color == ChessColor.white ? '♘' : '♞';
      case ChessPieceType.bishop:
        return color == ChessColor.white ? '♗' : '♝';
      case ChessPieceType.rook:
        return color == ChessColor.white ? '♖' : '♜';
      case ChessPieceType.queen:
        return color == ChessColor.white ? '♕' : '♛';
      case ChessPieceType.king:
        return color == ChessColor.white ? '♔' : '♚';
    }
  }
}

/// Sea-Floor Chess Game Canvas with Full Movement & Check Logic
class ChessGameCanvas extends StatefulWidget {
  final bool isSpectator;
  final String player1Name;
  final String player2Name;
  final String player1Avatar;
  final String player2Avatar;

  const ChessGameCanvas({
    super.key,
    this.isSpectator = false,
    this.player1Name = 'أنت (المواطن)',
    this.player2Name = 'شفيق الفنان 🎺',
    this.player1Avatar = '🧽',
    this.player2Avatar = '🎺',
  });

  @override
  State<ChessGameCanvas> createState() => _ChessGameCanvasState();
}

class _ChessGameCanvasState extends State<ChessGameCanvas> {
  late List<List<ChessPiece?>> _board;
  ChessColor _currentTurn = ChessColor.white;
  Point<int>? _selectedCoord;
  List<Point<int>> _validMoves = [];
  final List<String> _capturedByWhite = [];
  final List<String> _capturedByBlack = [];
  String? _statusBanner;
  String? _winnerMessage;

  @override
  void initState() {
    super.initState();
    _initChessBoard();
  }

  void _initChessBoard() {
    _board = List.generate(8, (_) => List.generate(8, (_) => null));

    // Black pieces (top rows 0 and 1)
    _board[0][0] = const ChessPiece(ChessPieceType.rook, ChessColor.black);
    _board[0][1] = const ChessPiece(ChessPieceType.knight, ChessColor.black);
    _board[0][2] = const ChessPiece(ChessPieceType.bishop, ChessColor.black);
    _board[0][3] = const ChessPiece(ChessPieceType.queen, ChessColor.black);
    _board[0][4] = const ChessPiece(ChessPieceType.king, ChessColor.black);
    _board[0][5] = const ChessPiece(ChessPieceType.bishop, ChessColor.black);
    _board[0][6] = const ChessPiece(ChessPieceType.knight, ChessColor.black);
    _board[0][7] = const ChessPiece(ChessPieceType.rook, ChessColor.black);
    for (int col = 0; col < 8; col++) {
      _board[1][col] = const ChessPiece(ChessPieceType.pawn, ChessColor.black);
    }

    // White pieces (bottom rows 6 and 7)
    for (int col = 0; col < 8; col++) {
      _board[6][col] = const ChessPiece(ChessPieceType.pawn, ChessColor.white);
    }
    _board[7][0] = const ChessPiece(ChessPieceType.rook, ChessColor.white);
    _board[7][1] = const ChessPiece(ChessPieceType.knight, ChessColor.white);
    _board[7][2] = const ChessPiece(ChessPieceType.bishop, ChessColor.white);
    _board[7][3] = const ChessPiece(ChessPieceType.queen, ChessColor.white);
    _board[7][4] = const ChessPiece(ChessPieceType.king, ChessColor.white);
    _board[7][5] = const ChessPiece(ChessPieceType.bishop, ChessColor.white);
    _board[7][6] = const ChessPiece(ChessPieceType.knight, ChessColor.white);
    _board[7][7] = const ChessPiece(ChessPieceType.rook, ChessColor.white);

    _currentTurn = ChessColor.white;
    _selectedCoord = null;
    _validMoves = [];
    _capturedByWhite.clear();
    _capturedByBlack.clear();
    _winnerMessage = null;
    _statusBanner = 'دورك بالقطع البيضاء (الزعانف الفاتحة) ♟️';
  }

  List<Point<int>> _calculateMoves(Point<int> pos) {
    final piece = _board[pos.x][pos.y];
    if (piece == null) return [];

    final moves = <Point<int>>[];
    final r = pos.x;
    final c = pos.y;
    final forward = piece.color == ChessColor.white ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // 1 step forward
        if (r + forward >= 0 && r + forward < 8 && _board[r + forward][c] == null) {
          moves.add(Point(r + forward, c));
          // Initial 2 steps
          final initialRow = piece.color == ChessColor.white ? 6 : 1;
          if (r == initialRow && _board[r + 2 * forward][c] == null) {
            moves.add(Point(r + 2 * forward, c));
          }
        }
        // Diagonal captures
        for (final dc in [-1, 1]) {
          if (c + dc >= 0 && c + dc < 8 && r + forward >= 0 && r + forward < 8) {
            final target = _board[r + forward][c + dc];
            if (target != null && target.color != piece.color) {
              moves.add(Point(r + forward, c + dc));
            }
          }
        }
        break;

      case ChessPieceType.knight:
        const offsets = [
          Point(-2, -1), Point(-2, 1), Point(-1, -2), Point(-1, 2),
          Point(1, -2), Point(1, 2), Point(2, -1), Point(2, 1),
        ];
        for (final o in offsets) {
          final nr = r + o.x;
          final nc = c + o.y;
          if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
            final target = _board[nr][nc];
            if (target == null || target.color != piece.color) {
              moves.add(Point(nr, nc));
            }
          }
        }
        break;

      case ChessPieceType.bishop:
        _addRayMoves(moves, pos, piece.color, [Point(-1, -1), Point(-1, 1), Point(1, -1), Point(1, 1)]);
        break;

      case ChessPieceType.rook:
        _addRayMoves(moves, pos, piece.color, [Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)]);
        break;

      case ChessPieceType.queen:
        _addRayMoves(moves, pos, piece.color, [
          Point(-1, -1), Point(-1, 1), Point(1, -1), Point(1, 1),
          Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1),
        ]);
        break;

      case ChessPieceType.king:
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            final nr = r + dr;
            final nc = c + dc;
            if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
              final target = _board[nr][nc];
              if (target == null || target.color != piece.color) {
                moves.add(Point(nr, nc));
              }
            }
          }
        }
        break;
    }

    return moves;
  }

  void _addRayMoves(List<Point<int>> moves, Point<int> pos, ChessColor color, List<Point<int>> dirs) {
    for (final dir in dirs) {
      int nr = pos.x + dir.x;
      int nc = pos.y + dir.y;
      while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
        final target = _board[nr][nc];
        if (target == null) {
          moves.add(Point(nr, nc));
        } else {
          if (target.color != color) {
            moves.add(Point(nr, nc));
          }
          break;
        }
        nr += dir.x;
        nc += dir.y;
      }
    }
  }

  void _onSquareTap(int r, int c) {
    if (_winnerMessage != null) return;
    if (_currentTurn != ChessColor.white && !widget.isSpectator) return;

    final tappedPoint = Point(r, c);
    final tappedPiece = _board[r][c];

    // Selecting a piece of the current player's color
    if (tappedPiece != null && tappedPiece.color == _currentTurn) {
      setState(() {
        _selectedCoord = tappedPoint;
        _validMoves = _calculateMoves(tappedPoint);
      });
      return;
    }

    // Moving to a valid destination
    if (_selectedCoord != null && _validMoves.contains(tappedPoint)) {
      _executeMove(_selectedCoord!, tappedPoint);
    }
  }

  void _executeMove(Point<int> from, Point<int> to) {
    setState(() {
      final piece = _board[from.x][from.y]!;
      final captured = _board[to.x][to.y];

      if (captured != null) {
        if (piece.color == ChessColor.white) {
          _capturedByWhite.add(captured.symbol);
        } else {
          _capturedByBlack.add(captured.symbol);
        }

        if (captured.type == ChessPieceType.king) {
          _winnerMessage = piece.color == ChessColor.white
              ? '👑 كش ملك ومات! كسبت شفيق واحتلت عرش الشطرنج!'
              : '💀 مات الملك! شفيق الفنان انتصر عليك بالكلارينيت!';
        }
      }

      // Pawn promotion to Queen on 8th rank
      final isPromotion = piece.type == ChessPieceType.pawn && (to.x == 0 || to.x == 7);
      _board[to.x][to.y] = isPromotion ? ChessPiece(ChessPieceType.queen, piece.color) : piece;
      _board[from.x][from.y] = null;

      _selectedCoord = null;
      _validMoves = [];

      if (_winnerMessage == null) {
        _currentTurn = _currentTurn == ChessColor.white ? ChessColor.black : ChessColor.white;
        _statusBanner = _currentTurn == ChessColor.white
            ? 'دورك بالقطع البيضاء ♟️'
            : 'دور ${widget.player2Name} بيفكر في خطة كش ملك... 🎺';

        if (_currentTurn == ChessColor.black && !widget.isSpectator) {
          _triggerBotMove();
        }
      }
    });
  }

  void _triggerBotMove() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _winnerMessage != null) return;

      final blackPieces = <Point<int>>[];
      for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
          if (_board[r][c]?.color == ChessColor.black) {
            blackPieces.add(Point(r, c));
          }
        }
      }
      blackPieces.shuffle(Random());

      for (final pos in blackPieces) {
        final moves = _calculateMoves(pos);
        if (moves.isNotEmpty) {
          // Prioritize capture if available
          moves.sort((a, b) {
            final targetA = _board[a.x][a.y] != null ? 1 : 0;
            final targetB = _board[b.x][b.y] != null ? 1 : 0;
            return targetB.compareTo(targetA);
          });
          _executeMove(pos, moves.first);
          return;
        }
      }
    });
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
          // Opponent Header & Captured Pieces
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
                        color: BikiniColors.spongeYellow,
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
                          if (_capturedByBlack.isNotEmpty)
                            Text(
                              'أكل: ${_capturedByBlack.join(' ')}',
                              style: const TextStyle(fontSize: 9.5, color: Colors.red),
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
                text: _currentTurn == ChessColor.white ? 'دورك (أبيض) ♔' : 'دور الخصم ♚',
                backgroundColor: _currentTurn == ChessColor.white ? BikiniColors.marineCyan : BikiniColors.warmSand,
                textColor: BikiniColors.cartoonBlack,
                fontSize: 9.5,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Status / Winner Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _winnerMessage != null ? BikiniColors.spongeYellow : BikiniColors.warmSand,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
            ),
            child: Row(
              children: [
                Text(_winnerMessage != null ? '🏆' : '♟️', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _winnerMessage ?? _statusBanner ?? 'انقل قطعتك!',
                    style: BikiniTypography.captionBold(
                      color: _winnerMessage != null ? BikiniColors.krabsRed : BikiniColors.cartoonBlack,
                    ).copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 8x8 Chess Board Grid
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BikiniColors.cartoonBlack, width: 2.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: List.generate(8, (r) {
                  return Expanded(
                    child: Row(
                      children: List.generate(8, (c) {
                        final piece = _board[r][c];
                        final isLight = (r + c) % 2 == 0;
                        final isSelected = _selectedCoord?.x == r && _selectedCoord?.y == c;
                        final isValidMove = _validMoves.any((m) => m.x == r && m.y == c);

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onSquareTap(r, c),
                            child: Container(
                              color: isSelected
                                  ? BikiniColors.marineCyan.withValues(alpha: 0.7)
                                  : isValidMove
                                      ? BikiniColors.spongeYellow.withValues(alpha: 0.75)
                                      : isLight
                                          ? const Color(0xFFF0D9B5)
                                          : const Color(0xFFB58863),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (isValidMove && piece == null)
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: BikiniColors.krabsRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  if (piece != null)
                                    Text(
                                      piece.symbol,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: piece.color == ChessColor.white
                                            ? Colors.white
                                            : Colors.black87,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 1,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Player Captured Pieces & Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: BikiniColors.marineCyan,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                    ),
                    child: Center(
                      child: Text(widget.player1Avatar, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'أكلت: ${_capturedByWhite.isEmpty ? 'لا يوجد' : _capturedByWhite.join(' ')}',
                    style: BikiniTypography.captionBold().copyWith(fontSize: 10.5),
                  ),
                ],
              ),
              if (_winnerMessage != null)
                BikiniButton.primary(
                  onPressed: _initChessBoard,
                  text: 'دور جديد ♟️🔄',
                  height: 34,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

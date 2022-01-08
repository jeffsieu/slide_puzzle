import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SimplePuzzleShuffleButton(),
          medium: (_, child) => const SimplePuzzleShuffleButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Builder(builder: (context) {
      final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
      return Column(
        children: [
          const ResponsiveGap(
            small: 32,
            medium: 48,
            large: 96,
          ),
          Material(
            elevation: 8,
            color: theme.boardColor,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: ResponsiveLayoutBuilder(
                small: (_, __) => SizedBox.square(
                  dimension: _BoardSize.small,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_small'),
                    boardSize: _BoardSize.small,
                    length: size,
                    tiles: tiles,
                    spacing: 5,
                  ),
                ),
                medium: (_, __) => SizedBox.square(
                  dimension: _BoardSize.medium,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_medium'),
                    boardSize: _BoardSize.medium,
                    length: size,
                    tiles: tiles,
                  ),
                ),
                large: (_, __) => SizedBox.square(
                  dimension: _BoardSize.large,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_large'),
                    boardSize: _BoardSize.large,
                    length: size,
                    tiles: tiles,
                  ),
                ),
              ),
            ),
          ),
          const ResponsiveGap(
            large: 96,
          ),
        ],
      );
    });
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleShuffleButton(),
        ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [length]x[length] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.length,
    required this.boardSize,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int length;

  /// The size of the board in pixels.
  final double boardSize;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  /// The size of each tile on the board in pixels.
  double get tileSize => (boardSize - (spacing * (length - 1))) / length;

  @override
  Widget build(BuildContext context) {
    double getTopOffset(int position) {
      final row = position ~/ length;
      return row * (spacing + tileSize);
    }

    double getLeftOffset(int position) {
      final col = position % length;
      return col * (spacing + tileSize);
    }

    return Stack(
      // fit: StackFit.expand,
      children: [
        for (var position = 0; position < tiles.length; position++) ...{
          Positioned(
            left: getLeftOffset(position),
            top: getTopOffset(position),
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        },
        for (var position = 0; position < tiles.length; position++) ...{
          AnimatedPositioned(
            key: tiles[position].key,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: getLeftOffset(position),
            top: getTopOffset(position),
            child: SizedBox(
              width: tileSize,
              height: tileSize,
              child: tiles[position],
            ),
          ),
        },
      ],
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTileState();
}

class _SimplePuzzleTileState extends State<SimplePuzzleTile>
    with TickerProviderStateMixin {
  late final translationAnimation = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150));
  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Builder(
      builder: (context) {
        return AnimatedBuilder(
          animation: translationAnimation,
          builder: (context, child) => Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(0, 0, 16 * (1 - translationAnimation.value)),
            child: child,
          ),
          child: TextButton(
            onHover: (hovered) {
              if (hovered) {
                translationAnimation.forward();
              } else {
                translationAnimation.reverse();
              }
            },
            style: TextButton.styleFrom(
              primary: PuzzleColors.white,
              textStyle: PuzzleTextStyle.headline2.copyWith(
                fontSize: widget.tileFontSize,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ).copyWith(
              foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
                  if (widget.tile.currentPosition ==
                      widget.tile.correctPosition) {
                    return theme.correctColor;
                  } else if (states.contains(MaterialState.hovered)) {
                    return theme.hoverColor;
                  } else {
                    return theme.defaultColor;
                  }
                },
              ),
              elevation: MaterialStateProperty.resolveWith<double?>(
                (states) {
                  if (states.contains(MaterialState.hovered)) {
                    return 16.0;
                  } else {
                    return 0;
                  }
                },
              ),
            ),
            onPressed: widget.state.puzzleStatus == PuzzleStatus.incomplete
                ? () => context.read<PuzzleBloc>().add(TileTapped(widget.tile))
                : null,
            child: Text(widget.tile.value.toString()),
          ),
        );
      },
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/settings/bloc/settings_bloc.dart';
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
          large: (_, __) => Builder(builder: (context) {
            return TextButton(
              child: const Text('Settings'),
              onPressed: () {
                final isSettingsVisible =
                    context.read<SettingsBloc>().state.isSettingsVisible;
                context.read<SettingsBloc>().add(isSettingsVisible
                    ? HideSettingsTapped()
                    : ShowSettingsTapped());
              },
            );
          }),
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
  Widget boardBuilder(int size, List<Widget> tiles, PuzzleState state) {
    final board = Builder(
      builder: (context) {
        final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
        final isSettingsVisible =
            context.select((SettingsBloc bloc) => bloc.state.isSettingsVisible);
        final puzzleSize =
            context.select((SettingsBloc bloc) => bloc.state.size);

        final settingsPage = Column(
          children: [
            Text(
              'Settings',
              style: PuzzleTextStyle.headline3
                  .copyWith(color: PuzzleColors.primary800),
            ),
            const Gap(24),
            Text('Size',
                style: PuzzleTextStyle.headline4
                    .copyWith(color: PuzzleColors.primary400)),
            Slider.adaptive(
              activeColor: PuzzleColors.primary500,
              inactiveColor: PuzzleColors.primary200,
              value: puzzleSize.toDouble(),
              label: '$puzzleSize x $puzzleSize',
              divisions: SettingsBloc.sizeMax - SettingsBloc.sizeMin,
              onChanged: (value) {
                context.read<SettingsBloc>().add(SizeChanged(value.toInt()));
              },
              min: SettingsBloc.sizeMin.toDouble(),
              max: SettingsBloc.sizeMax.toDouble(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  SettingsBloc.sizeMin.toString(),
                  style: PuzzleTextStyle.body
                      .copyWith(color: PuzzleColors.primary500),
                ),
                Text(
                  SettingsBloc.sizeMax.toString(),
                  style: PuzzleTextStyle.body
                      .copyWith(color: PuzzleColors.primary500),
                ),
              ],
            )
          ],
        );

        final settings = Material(
          key: Key('Settings'),
          elevation: 8,
          color: theme.boardColor,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ResponsiveLayoutBuilder(
              small: (_, __) => SizedBox.square(
                dimension: _BoardSize.small,
                child: settingsPage,
              ),
              medium: (_, __) => SizedBox.square(
                dimension: _BoardSize.medium,
                child: settingsPage,
              ),
              large: (_, __) => SizedBox.square(
                dimension: _BoardSize.large,
                child: settingsPage,
              ),
            ),
          ),
        );
        final board = Material(
          key: Key('Board'),
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
                  state: state,
                  spacing: 5,
                ),
              ),
              medium: (_, __) => SizedBox.square(
                dimension: _BoardSize.medium,
                child: SimplePuzzleBoard(
                  key: const Key('simple_puzzle_board_medium'),
                  boardSize: _BoardSize.medium,
                  length: size,
                  state: state,
                  tiles: tiles,
                ),
              ),
              large: (_, __) => SizedBox.square(
                dimension: _BoardSize.large,
                child: SimplePuzzleBoard(
                  key: const Key('simple_puzzle_board_large'),
                  boardSize: _BoardSize.large,
                  length: size,
                  state: state,
                  tiles: tiles,
                ),
              ),
            ),
          ),
        );
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            final frontChild = isSettingsVisible ? settings : board;
            final isFrontChild = frontChild.key == child.key;
            // return FlipTransition(
            //   animation: Tween(
            //           begin: isFrontChild ? 0.0 : 1.0,
            //           end: isFrontChild ? 1.0 : 0.0)
            //       .animate(animation),
            //   child: child,
            // );
            // final rotate = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                final frontChildAngle = lerpDouble(pi / 2, 0,
                    const Interval(0.5, 1).transform(animation.value))!;
                final backChildAngle = lerpDouble(-pi / 2, 0,
                    const Interval(0.5, 1).transform(animation.value))!;
                final angle = isFrontChild ? frontChildAngle : backChildAngle;
                return Transform(
                  transform: Matrix4.rotationY(angle),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isSettingsVisible ? settings : board,
        );
      },
    );

    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        board,
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
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
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(0, 0, 16),
      child: Container(
        decoration: BoxDecoration(
          color: PuzzleColors.boardDark,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
    required this.state,
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

  /// The state of the puzzle.
  final PuzzleState state;

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

    final whitespaceIndex =
        state.puzzle.tiles.indexOf(state.puzzle.getWhitespaceTile());

    final board = Stack(
      children: [
        for (var position = 0; position < tiles.length; position++) ...{
          Positioned(
            left: getLeftOffset(position),
            top: getTopOffset(position),
            child: Ink(
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
          Positioned(
            left: getLeftOffset(position),
            top: getTopOffset(position),
            // child: tiles[whitespaceIndex],
            child: SizedBox(
              width: tileSize,
              height: tileSize,
              child: tiles[whitespaceIndex],
            ),
          ),
        },
        // Positioned(
        //   left: getLeftOffset(whitespaceIndex),
        //   top: getTopOffset(whitespaceIndex),
        //   child: SizedBox(
        //     width: tileSize,
        //     height: tileSize,
        //   ),
        // ),
        for (var position = 0; position < tiles.length; position++) ...{
          // if (state.lastTappedTile == state.puzzle.tiles[position]) ...{
          //   Positioned(
          //     left: getLeftOffset(position),
          //     top: getTopOffset(position),
          //     child: SizedBox(
          //       width: tileSize,
          //       height: tileSize,
          //       child: Container(color: Colors.blue)
          //     ),
          //   ),
          // },
          if (state.puzzle.tiles[position].isWhitespace) ...{
            // Positioned(
            //   left: getLeftOffset(position),
            //   top: getTopOffset(position),
            //   child: SizedBox(
            //     width: tileSize,
            //     height: tileSize,
            //     child: tiles[position],
            //   ),
            // ),
          } else ...{
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
          }
        },
      ],
    );

    return board;
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
      textColor: PuzzleColors.primary000,
      backgroundColor: PuzzleColors.primary400,
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

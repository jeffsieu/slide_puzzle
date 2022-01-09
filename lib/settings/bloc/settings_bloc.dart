import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(const SettingsState(isSettingsVisible: false, size: 4)) {
    on<ShowSettingsTapped>(_onShowSettingsTapped);
    on<HideSettingsTapped>(_onHideSettingsTapped);
    on<SizeChanged>(_onSizeChanged);
  }

  /// Minimum size of the puzzle.
  static const int sizeMin = 3;

  /// Maximum size of the puzzle.
  static const int sizeMax = 6;

  void _onShowSettingsTapped(
    ShowSettingsTapped event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isSettingsVisible: true));
  }

  void _onHideSettingsTapped(
    HideSettingsTapped event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isSettingsVisible: false));
  }

  void _onSizeChanged(
    SizeChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(size: event.size));
  }
}

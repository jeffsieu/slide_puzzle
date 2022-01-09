part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isSettingsVisible,
    required this.size,
  });

  final bool isSettingsVisible;
  final int size;

  SettingsState copyWith({
    bool? isSettingsVisible,
    int? size,
  }) {
    return SettingsState(
      isSettingsVisible: isSettingsVisible ?? this.isSettingsVisible,
      size: size ?? this.size,
    );
  }

  @override
  List<Object> get props => [isSettingsVisible, size];
}

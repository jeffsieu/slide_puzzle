part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ShowSettingsTapped extends SettingsEvent {}

class HideSettingsTapped extends SettingsEvent {}

class SizeChanged extends SettingsEvent {
  final int size;

  const SizeChanged(this.size);
}

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  @override
  Locale build() => const Locale('tr');

  void setLocale(final Locale locale) => state = locale;

  void toggleLocale() => state =
      state.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
}

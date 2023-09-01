import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ritammuddatask/controllers/auth_controller.dart';
import 'package:ritammuddatask/controllers/providers.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/models/user_model.dart';
import 'package:ritammuddatask/shared/shared.dart';
import 'package:ritammuddatask/views/settings/settings_tile.dart';
import 'package:ritammuddatask/wrapper.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _loading = true;

  String _selectedColor = "";
  bool _selectedBrightness = false;

  @override
  void didChangeDependencies() {
    _selectedColor = THEMES.keys.firstWhere(
        (element) => THEMES[element] == ref.watch(swatchColorProvider));
    _selectedBrightness =
        ref.watch(swatchBrightnessProvider).name == "dark" ? true : false;
    setState(() => _loading = false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: !_loading
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  SettingsTile(
                    child: SwitchListTile(
                      title: const Text(
                        "Dark Mode",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      value: _selectedBrightness,
                      onChanged: (value) async {
                        setState(() => _selectedBrightness = value);
                        ref.watch(swatchBrightnessProvider.notifier).state =
                            value ? Brightness.dark : Brightness.light;
                        await LocalSharedPref.setTheme(ThemeModel(
                          color: THEMES[_selectedColor]!,
                          dark: value,
                        ));
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  PopupMenuButton(
                    constraints: const BoxConstraints.expand(
                        width: 200.0, height: 200.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onSelected: (value) async {
                      setState(() => _selectedColor = value);
                      ref.watch(swatchColorProvider.notifier).state =
                          THEMES[value]!;
                      await LocalSharedPref.setTheme(ThemeModel(
                        color: THEMES[value]!,
                        dark: _selectedBrightness,
                      ));
                    },
                    itemBuilder: (context) {
                      return <PopupMenuEntry<String>>[
                        for (String elem in THEMES.keys)
                          PopupMenuItem(
                            value: elem,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(elem),
                                ),
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Theme.of(context).indicatorColor),
                                    color: THEMES[elem],
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ],
                            ),
                          ),
                      ];
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12.0,
                            spreadRadius: 1.0,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withAlpha(100),
                          )
                        ],
                      ),
                      height: 50.0,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedColor,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: THEMES[_selectedColor],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () => signOut(ref).whenComplete(
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const Wrapper()),
                        (route) => false,
                      ),
                    ),
                    child: const SettingsTile(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Sign out",
                              style: TextStyle(fontSize: 18.0),
                            )),
                            Icon(Icons.arrow_right_rounded)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80.0),
                ],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  Future<void> signOut(WidgetRef ref) async {
    ref.watch(isOnLoginScreenProvider.notifier).state = true;
    await AuthController().signOut();
    await LocalSharedPref.clearSharedPref();
  }
}

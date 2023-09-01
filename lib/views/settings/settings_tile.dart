import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            spreadRadius: 1.0,
            color:
                Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
          ),
        ],
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(200),
          highlightColor:
              Theme.of(context).colorScheme.onBackground.withAlpha(50),
          period: const Duration(seconds: 1),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(100),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello friend",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(100),
                      ),
                    ),
                    Text(
                      "have a nice day!",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(100),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(100),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(200),
          highlightColor:
              Theme.of(context).colorScheme.onBackground.withAlpha(50),
          period: const Duration(seconds: 1),
          child: Column(
            children: [
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(50),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                height: 100.0,
                width: double.infinity,
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(50),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                height: 100.0,
                width: double.infinity,
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(50),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                height: 100.0,
                width: double.infinity,
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(200),
        highlightColor:
            Theme.of(context).colorScheme.onBackground.withAlpha(50),
        period: const Duration(seconds: 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withAlpha(50),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withAlpha(100)),
                Text(
                  "\tAdd task",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withAlpha(100)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

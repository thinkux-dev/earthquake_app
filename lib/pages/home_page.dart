// import 'package:earthquake_app/map_page.dart';
import 'dart:io';

import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/pages/settings_page.dart';
import 'package:earthquake_app/providers/earthquake_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EarthShake'),
        actions: [
          IconButton(
            onPressed: _showSortingDialog,
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: weather.when(
        data: (model) => model.features!.isEmpty
            ? const Center(child: Text('No record found'))
            : ListView.builder(
                itemCount: model.features!.length,
                itemBuilder: (context, index) {
                  // final value = provider.shouldUseLocation;
                  final data = model.features![index].properties!;
                  final location =
                      model.features![index].geometry!.coordinates!;
                  final latitude = location[0];
                  final longitude = location[1];
                  print('data  $data');
                  print('location  $location');
                  print('latitude  $latitude');
                  print('longitude  $longitude');
                  return ListTile(
                    title: Text(data.place ?? data.title ?? 'Unknown'),
                    subtitle: Text(getFormattedDateTime(
                        data.time!, 'EEE MMM dd yyyy hh:mm a')),
                    trailing: Chip(
                      avatar: data.alert == null
                          ? null
                          : CircleAvatar(
                              backgroundColor: getAlertColor(data.alert!),
                            ),
                      label: Text('${data.mag!.toStringAsFixed(2)}'),
                    ),
                    onTap: () async {
                      await viewLocationMap(data.place, latitude, longitude);
                    },
                  );
                },
              ),
        error: (e, trace) => Center(child: Text('Error: ${e.toString()}')),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _showSortingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final groupValue = orderFilterValues[ref.read(orderFilterProvider)]!;
          return AlertDialog(
            title: const Text('Sort by'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioGroup(
                    groupValue: groupValue,
                    value: 'magnitude',
                    label: 'Magnitude-Desc',
                    onChange: (value) {
                      Navigator.pop(context);
                      ref.read(orderFilterProvider.notifier).state =
                          OrderFilter.magnitude;
                    }),
                RadioGroup(
                    groupValue: groupValue,
                    value: 'magnitude-asc',
                    label: 'Magnitude-Asc',
                    onChange: (value) {
                      Navigator.pop(context);
                      ref.read(orderFilterProvider.notifier).state =
                          OrderFilter.magnitudeAsc;
                    }),
                RadioGroup(
                    groupValue: groupValue,
                    value: 'time',
                    label: 'Time-Desc',
                    onChange: (value) {
                      Navigator.pop(context);
                      ref.read(orderFilterProvider.notifier).state =
                          OrderFilter.time;
                    }),
                RadioGroup(
                    groupValue: groupValue,
                    value: 'time-asc',
                    label: 'Time-Asc',
                    onChange: (value) {
                      Navigator.pop(context);
                      ref.read(orderFilterProvider.notifier).state =
                          OrderFilter.timeAsc;
                    }),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'))
            ],
          );
        });
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(value: value, groupValue: groupValue, onChanged: onChange),
        Text(label),
      ],
    );
  }
}

viewLocationMap(String? place, num latitude, num longitude) async {
  String mapUrl = '';
  if (Platform.isAndroid) {
    mapUrl = 'geo:$latitude,$longitude?q=$place';
  } else {
    mapUrl = 'http://maps.apple.com/?q=$place';
  }
  if (await canLaunchUrlString(mapUrl)) {
    await launchUrlString(mapUrl);
  } else {
    // showMsg(context, 'Cannot perform this task');
  }
}

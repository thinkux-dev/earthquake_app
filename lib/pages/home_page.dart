// import 'package:earthquake_app/map_page.dart';
import 'dart:io';

import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/settings_page.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? provider.earthquakeModel!.features!.isEmpty
                ? const Center(
                    child: Text('No record found'),
                  )
                : ListView.builder(
                    itemCount: provider.earthquakeModel!.features!.length,
                    itemBuilder: (context, index) {
                      final value = provider.shouldUseLocation;
                      final data = provider
                          .earthquakeModel!.features![index].properties!;
                      final location = provider
                          .earthquakeModel!.features![index].geometry!.coordinates!;
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
                                  backgroundColor:
                                      provider.getAlertColor(data.alert!),
                                ),
                          label: Text('${data.mag}'),
                        ),
                        onTap: () async {
                          await provider.viewLocationMap(value, latitude, longitude);
                        },
                      );
                    },
                  )
            : const Center(
                child: Text('Please wait'),
              ),
      ),
    );
  }

  void _showSortingDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sort by'),
          content: Consumer<AppDataProvider>(
            builder: (context, provider, child) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioGroup(
                    groupValue: provider.orderBy,
                    value: 'magnitude',
                    label: 'Magnitude-Desc',
                    onChange: (value) {
                      provider.setOrder(value!);
                    }
                ),
                RadioGroup(
                    groupValue: provider.orderBy,
                    value: 'magnitude-asc',
                    label: 'Magnitude-Asc',
                    onChange: (value) {
                      provider.setOrder(value!);
                    }
                ),
                RadioGroup(
                    groupValue: provider.orderBy,
                    value: 'time',
                    label: 'Time-Desc',
                    onChange: (value) {
                      provider.setOrder(value!);
                    }
                ),
                RadioGroup(
                    groupValue: provider.orderBy,
                    value: 'time-asc',
                    label: 'Time-Asc',
                    onChange: (value) {
                      provider.setOrder(value!);
                    }
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')
            )
          ],
            ));
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

viewLocationMap(String? place, num latitude, num longitude) async{
  String mapUrl = '';
  if(Platform.isAndroid) {
    mapUrl = 'geo:$latitude,$longitude?q=$place';
  } else {
    mapUrl = 'http://maps.apple.com/?q=$place';
  }
  if(await canLaunchUrlString(mapUrl)) {
    await launchUrlString(mapUrl);
  } else {
    // showMsg(context, 'Cannot perform this task');
  }
}
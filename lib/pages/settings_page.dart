import 'package:earthquake_app/providers/earthquake_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final queryParams = ref.watch(queryParamsProvider);
    final city = ref.watch(cityProvider);
    final shouldUseLocation = ref.watch(shouldUseLocationProvider);

    ref.listen(shouldShowLoadingBarProvider, (previous, next) {
      if(next) {
        EasyLoading.show(status: "Fetching location...");
      } else {
        EasyLoading.dismiss();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Time Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(queryParams.starttime),
                  trailing: IconButton(
                    onPressed: () async {
                      final date = await selectDate();
                      if (date != null) {
                        ref.read(queryParamsProvider.notifier).setStartTime(date);
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(queryParams.endtime),
                  trailing: IconButton(
                    onPressed: () async {
                      final date = await selectDate();
                      if (date != null) {
                        ref.read(queryParamsProvider.notifier).setEndTime(date);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       provider.getEarthquakeData();
                //       showMsg(context, 'Times has been updated');
                //     },
                //     child: const Text('Update Time Changes')
                // )
              ],
            ),
          ),
          Text(
            'Location Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            child: SwitchListTile(
              title: Text(city ?? 'Your location is unknown'),
              subtitle: city == null
                  ? null
                  : Text(
                      "Earthquake data will be shown within ${queryParams.maxradiuskm} Km radius from $city"
              ),
              value: shouldUseLocation,
              onChanged: (value) {
                EasyLoading.show(status: 'Getting location...');
                ref.read(queryParamsProvider.notifier).setLocation(value);
                EasyLoading.dismiss();
              },
            ),
          ),
          Text(
            'Magnitude Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            child: Slider(
              value: double.parse(queryParams.minmagnitude),
              max: 10,
              divisions: 6,
              label: double.parse(queryParams.minmagnitude).round().toString(),
              onChanged: (value) async {
                await ref.read(queryParamsProvider.notifier).setMagnitude(value);
              },
            ),
          ),
          Text(
            'MaxRadius Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          // Card(
          //   child: Slider(
          //     value: provider.maxRadiusKm,
          //     max: 5000,
          //     divisions: 10,
          //     label: provider.maxRadiusKm.round().toString(),
          //     onChanged: (value) async{
          //       await provider.setMaxRadiusKm(value);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<String?> selectDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (dt != null) {
      return getFormattedDateTime(dt.millisecondsSinceEpoch);
    }
    return null;
  }
}

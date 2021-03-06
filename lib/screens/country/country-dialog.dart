import 'dart:ui';

import 'package:covid19/models/country-model.dart';
import 'package:covid19/themes/color-theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryDialog extends StatelessWidget {
  final Country data;
  const CountryDialog({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add To Home',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
            Consumer<Future<SharedPreferences>>(
              builder: (_, Future<SharedPreferences> consumer, __) {
                return StreamBuilder(
                  stream: consumer.asStream(),
                  builder:
                      (context, AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      final error = snapshot.error;
                      return Center(child: Text(error.toString()));
                    } else if (snapshot.hasData) {
                      String country = snapshot.data.getString('homeCountry');
                      SharedPreferences pref = snapshot.data;
                      return DialogActions(
                          data: data, country: country, pref: pref);
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DialogActions extends StatelessWidget {
  const DialogActions({
    Key key,
    @required this.data,
    @required this.country,
    this.pref,
  }) : super(key: key);

  final Country data;
  final String country;
  final SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Add ${data.country} to your Home Page'),
          SizedBox(height: 30),
          Container(
            child: Row(
              children: [
                country == data.country
                    ? Expanded(
                        child: FlatButton.icon(
                          onPressed: () {
                            pref.setString('homeCountry', '');
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: Icon(Ionicons.ios_remove_circle_outline),
                          label: Text('Remove'),
                          textColor: ColorTheme.deaths,
                          padding: const EdgeInsets.all(20),
                          splashColor: Theme.of(context).accentColor,
                        ),
                      )
                    : Expanded(
                        child: FlatButton.icon(
                          onPressed: () {
                            pref.setString('homeCountry', data.country);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: Icon(Ionicons.ios_add_circle_outline),
                          label: Text('Add'),
                          textColor: ColorTheme.recovered,
                          padding: const EdgeInsets.all(20),
                          splashColor: Theme.of(context).accentColor,
                        ),
                      ),
                SizedBox(width: 20),
                Expanded(
                  child: FlatButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Ionicons.ios_close_circle_outline),
                    label: Text('Cancel'),
                    textColor: Theme.of(context).accentColor,
                    padding: const EdgeInsets.all(20),
                    splashColor: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

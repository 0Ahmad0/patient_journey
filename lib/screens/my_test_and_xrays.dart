import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:patient_journey/common_widgets/constans.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTestAndXRaysScreen extends StatelessWidget {
  const MyTestAndXRaysScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(12.0),
          itemBuilder: (_, index) {
            return Card(
              child: ListTile(
                onTap: () async {
                  final _url = Uri.parse('link here');
                  if (await launchUrl(_url)) {
                  } else {
                    Const.TOAST(context, textToast: 'Error Launch');
                  }
                },
                leading: TextButton.icon(
                  onPressed: null,
                  icon: Text('${index + 1}'),
                  label: SvgPicture.asset(
                    AppAssets.pdfFileIMG,
                    width: 30.0,
                    height: 30.0,
                  ),
                ),
                title: Text('Name File'),
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:patient_journey/constants/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Reports'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'My Treatment Palns',
                ),
                Tab(
                  text: 'My Tests and X-rays',
                ),
                Tab(
                  text: 'My Performed Surgeries',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.separated(
                padding: EdgeInsets.all(12.0),
                  itemCount: 15,
                  separatorBuilder: (_, __) => SizedBox(
                        height: 10.0,
                      ),
                  itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - Name.pdf',)),
              ListView.separated(
                padding: EdgeInsets.all(12.0),
                  itemCount: 15,
                  separatorBuilder: (_, __) => SizedBox(
                        height: 10.0,
                      ),
                  itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - Name.pdf',)),
              ListView.separated(
                padding: EdgeInsets.all(12.0),
                  itemCount: 15,
                  separatorBuilder: (_, __) => SizedBox(
                        height: 10.0,
                      ),
                  itemBuilder: (_, index) => CardFileWidget( nameFile: '${index+1} - Name.pdf',)),

            ],
          ),
        ));
  }
}

class CardFileWidget extends StatelessWidget {
  const CardFileWidget({
    super.key, required this.nameFile,
  });

  final String nameFile;

  launchFile({url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
          child: ListTile(
            onTap: (){
              launchFile(url:'https://flutter.dev');
            },
            leading: SvgPicture.asset(
              AppAssets.pdfFileIMG,
              width: 40,
              height: 40,
            ),
            title: Text(nameFile),
          ),
        );
  }
}

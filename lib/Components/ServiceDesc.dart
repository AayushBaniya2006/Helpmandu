import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'booking.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDesc extends StatelessWidget {
  final String name;
  final IconData icon;
  final String desc;
  final String img;

  ServiceDesc({
    Key? key,
    required this.name,
    required this.icon,
    required this.desc,
    required this.img,
  }) : super(key: key);

  bool _isNetworkImage() {
    return img.startsWith('http') || img.startsWith('https');
  }

  //9841868601 Business

  Uri dialnumber=Uri(scheme: 'tel', path: "+9979851140485");

  callNumber()async{
    await launchUrl(dialnumber);
  }

  directcall() async{
    await FlutterPhoneDirectCaller.callNumber("+9979851140485");
  }

  Widget _buildImageWidget() {
    if (_isNetworkImage()) {
      return Image.network(
        img,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      );
    } else {
      return Image.asset(
        img,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("--- $name ---"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImageWidget(),
              const SizedBox(height: 24),
              
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 70),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        directcall();
                      },
                      child: const Text('Call Now'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookPage(name: name), // Pass the name to BookPage
                      ),
                    );
                  },
                  child: const Text('Book Now'),
                ),

                    ),
                  
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void showError(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

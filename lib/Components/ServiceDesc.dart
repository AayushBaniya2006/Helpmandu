import 'package:flutter/material.dart';

class ServiceDesc extends StatelessWidget {
  final String name;
  final IconData icon;
  final int price;
  final String desc;
  final String img;

  const ServiceDesc({
    Key? key,
    required this.name,
    required this.icon,
    required this.price,
    required this.desc,
    required this.img,
  }) : super(key: key);

  bool _isNetworkImage() {
    return img.startsWith('http') || img.startsWith('https');
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
              Text(
                'Price: ${price.toString()} NPR',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              const SizedBox(height: 150),
        const ElevatedButton(
          onPressed: null,
          child: Text('Call Now'),
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
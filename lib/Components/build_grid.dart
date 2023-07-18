import 'package:flutter/material.dart';
import 'ServiceDesc.dart';
import 'booking.dart';

class buildGrid extends StatelessWidget {
  final String name1;
  final String name2;
  final String name3;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final String desc1;
  final String desc2;
  final String desc3;
  final String img1;
  final String img2;
  final String img3;

  const buildGrid({
    Key? key,
    required this.name1,
    required this.name2,
    required this.name3,
    required this.icon1,
    required this.icon2,
    required this.icon3,

    required this.desc1,
    required this.desc2,
    required this.desc3,
    required this.img1,
    required this.img2,
    required this.img3, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(3, (index) {
          IconData selectedIcon;
          String selectedName;
          String selectedDesc;
          String selectedImg;

          if (index == 0) {
            selectedIcon = icon1;
            selectedName = name1;
            selectedDesc = desc1;
            selectedImg = img1;
          } else if (index == 1) {
            selectedIcon = icon2;
            selectedName = name2;
            selectedDesc = desc2;
            selectedImg = img2;
          } else {
            selectedIcon = icon3;
            selectedName = name3;
            selectedDesc = desc3;
            selectedImg = img3;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDesc(
                    name: selectedName,
                    icon: selectedIcon,
                    desc: selectedDesc, 
                    img: selectedImg,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 40,
                    child: Icon(
                      selectedIcon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      selectedName,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

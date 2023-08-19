import 'package:flutter/material.dart';
import 'ServiceDesc.dart';

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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio:
            1.0, // Adjust this value to control the grid item sizes
      ),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildGridItem(context, name1, icon1, desc1, img1);
        } else if (index == 1) {
          return buildGridItem(context, name2, icon2, desc2, img2);
        } else if (index == 2) {
          return buildGridItem(context, name3, icon3, desc3, img3);
        }
        return Container(); // Placeholder container for the item builder
      },
    );
  }

  Widget buildGridItem(
    BuildContext context,
    String name,
    IconData icon,
    String desc,
    String img,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDesc(
              name: name,
              icon: icon,
              desc: desc,
              img: img,
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
              radius: 24,
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

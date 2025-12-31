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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildServiceItem(context, name1, icon1, desc1, img1, 0)),
          const SizedBox(width: 12),
          Expanded(child: _buildServiceItem(context, name2, icon2, desc2, img2, 1)),
          const SizedBox(width: 12),
          Expanded(child: _buildServiceItem(context, name3, icon3, desc3, img3, 2)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    String name,
    IconData icon,
    String desc,
    String img,
    int index,
  ) {
    // Different colors for variety
    final colors = [
      const Color(0xFF5C6BC0), // Indigo
      const Color(0xFF26A69A), // Teal
      const Color(0xFFFF7043), // Deep Orange
    ];

    final bgColors = [
      const Color(0xFFE8EAF6), // Light Indigo
      const Color(0xFFE0F2F1), // Light Teal
      const Color(0xFFFBE9E7), // Light Orange
    ];

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColors[index % 3],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 28,
              color: colors[index % 3],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

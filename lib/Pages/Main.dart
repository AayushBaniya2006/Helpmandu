import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/build_grid.dart';

class Main extends StatelessWidget {
  const Main({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/images/2D & 3D Design.jpeg', // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most Popular Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16.0),
          const buildGrid(
              name1: "Hair Dresser",
              name2: "Plumbing",
              name3: "Pest Control",
              icon1: Icons.spa_rounded,
              icon2: Icons.plumbing,
              icon3: Icons.pest_control_rodent_outlined,
              desc1:
              "Hair Dresser- Get a stunning hair transformation with our skilled hairdressers. We offer expert hairdressing services, including cuts, colors, and styles, to leave you looking and feeling fabulous. Trust our experienced team for personalized attention and tailored solutions that suit your unique style. Whether you're seeking a trendy haircut, a glamorous updo, or a complete makeover, we deliver exceptional results. Our hairdressers stay updated with the latest trends and techniques to offer you a wide range of options and ensure your satisfaction with every visit.",
              desc2: "Plumbing- Trust our plumbing services for all your plumbing needs. Our team of experienced plumbers offers comprehensive solutions to ensure proper water flow, drainage, and maintenance in your home. From installation of new fixtures to repairing leaks and clogs, we provide reliable and efficient plumbing services. We use the latest tools and technology to diagnose and resolve plumbing issues, ensuring long-lasting functionality and customer satisfaction.",
              desc3: "Pest Control- Protect your home from pests with our reliable pest control services. Our expert technicians are well-versed in dealing with a wide range of pests, from insects to rodents. We employ effective and environmentally friendly methods to eliminate pests and ensure a pest-free living environment. Our thorough inspection and targeted treatment approach ensure the complete eradication of pests while minimizing any impact on your home and the surrounding ecosystem.",
              img1: "change",
              img2: "lib/images/Plumbing.jpeg",
              img3: "lib/images/PestControl.jpeg",
            ),

            const buildGrid(
              name1: "Railing Installation",
              name2: "Painting",
              name3: "Electrician",
              icon1: Icons.fence_rounded,
              icon2: Icons.format_paint,
              icon3: Icons.electric_meter_outlined,
              desc1:
              "Railing Installation- Enhance your property with our professional railing installation services. Our skilled team ensures precise positioning, secure attachment, and meticulous installation for a visually appealing and functional result. Trust us to enhance safety and aesthetics with expert railing installation. We offer a variety of railing options, including metal, glass, and wood, to complement your property's design. Whether it's a staircase railing, balcony railing, or deck railing, our experienced installers deliver top-quality craftsmanship and attention to detail.",
              desc2:"Painting- If you're looking for exceptional painting services, look no further. We provide meticulous attention to detail, innovative designs, and a blend of modern artistry for your colorful journey. Let our team of professional painters transform your home and bring your vision to life. We use premium quality paints, tools, and techniques to deliver stunning results that exceed your expectations. From interior walls to exterior surfaces, we cater to all your painting needs.",
              desc3:
              "Electrician- For any electrical issues, we've got you covered. Our team of licensed electricians provides high-quality electrical services to ensure a consistent and safe flow of power in your home. Whether you need electrical installations, repairs, or upgrades, we have the expertise and reliability to meet your electrical needs. From wiring and lighting to electrical panel maintenance, we deliver efficient solutions using top-of-the-line equipment and adhering to industry safety standards.",
              //change
              img1: "lib/images/2D & 3D Design.jpeg",
              img2: "lib/images/Painting.jpeg",
              img3: "lib/images/Electrician.jpeg",
            ),

            const SizedBox(height: 12.0),
            
          const SizedBox(height: 16.0),
          const Text(
            'About Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Welcome to Helpmandu! We offer a wide range of professional services to enhance your living spaces. Our experienced team is dedicated to delivering high-quality results and exceeding your expectations. From repairs to remodeling, we are here to transform your home. Choose us for reliable, personalized solutions that cater to your needs. Experience the difference we can make in your living environment.',
          ),
        ],
      ),
    );
  }
}

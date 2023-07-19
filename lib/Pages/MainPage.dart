import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/build_grid.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

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
                //Plumbing, Painting, 2d 3D Design, House Inspection, Railing Installation, 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16.0),
          const buildGrid(
            name1: "House Inspection",
            name2: "Plumbing",
            name3: "2d 3D Design",
            icon1: Icons.search_rounded,
            icon2: Icons.plumbing,
            icon3: Icons.design_services_rounded,
            desc1:
            "Home Inspection- Ensure the safety and integrity of your home with our thorough home inspection services. Our professional inspectors conduct detailed assessments to identify potential issues and provide recommendations for maintenance and improvements. We inspect various aspects of your home, including electrical systems, plumbing, structural integrity, roofing, and more, to give you peace of mind. Our comprehensive reports highlight any existing or potential problems, allowing you to make informed decisions and take necessary actions to maintain or enhance your home's condition.",
            desc2: "Plumbing- Trust our plumbing services for all your plumbing needs. Our team of experienced plumbers offers comprehensive solutions to ensure proper water flow, drainage, and maintenance in your home. From installation of new fixtures to repairing leaks and clogs, we provide reliable and efficient plumbing services. We use the latest tools and technology to diagnose and resolve plumbing issues, ensuring long-lasting functionality and customer satisfaction.",
            desc3:  "2D & 3D Design- Explore the possibilities of your space with our 2D and 3D design services. Our talented designers provide realistic visualizations and precise floor plans to help you envision and plan your dream home. Whether you're starting from scratch or remodeling an existing space, our design expertise can bring your ideas to life. We collaborate closely with you to understand your lifestyle, preferences, and functional requirements, translating them into captivating designs that optimize space utilization and create harmonious living environments.",
            img1: "lib/images/Home Inspection.jpeg",
            img2: "lib/images/Plumbing.jpeg",
            img3: "lib/images/2D & 3D Design.jpeg",
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

          // Add the box with a circular image and text
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/images/your_image_asset_path_here.jpg'), // Replace with your image asset path
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Your text goes here. You can add more details about your business or any other information you want to display.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
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

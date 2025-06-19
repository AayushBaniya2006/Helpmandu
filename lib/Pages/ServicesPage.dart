import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/build_grid.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              '- Our Services Provided -',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            buildGrid(
              name1: "Painting",
              name2: "Plumbing",
              name3: "Pest Control",
              icon1: Icons.format_paint,
              icon2: Icons.plumbing,
              icon3: Icons.pest_control_rodent_outlined,
              desc1:
                  "Painting- If you're looking for exceptional painting services, look no further. We provide meticulous attention to detail, innovative designs, and a blend of modern artistry for your colorful journey. Let our team of professional painters transform your home and bring your vision to life. We use premium quality paints, tools, and techniques to deliver stunning results that exceed your expectations. From interior walls to exterior surfaces, we cater to all your painting needs.",
              desc2:
                  "Plumbing- Trust our plumbing services for all your plumbing needs. Our team of experienced plumbers offers comprehensive solutions to ensure proper water flow, drainage, and maintenance in your home. From installation of new fixtures to repairing leaks and clogs, we provide reliable and efficient plumbing services. We use the latest tools and technology to diagnose and resolve plumbing issues, ensuring long-lasting functionality and customer satisfaction.",
              desc3:
                  "Pest Control- Protect your home from pests with our reliable pest control services. Our expert technicians are well-versed in dealing with a wide range of pests, from insects to rodents. We employ effective and environmentally friendly methods to eliminate pests and ensure a pest-free living environment. Our thorough inspection and targeted treatment approach ensure the complete eradication of pests while minimizing any impact on your home and the surrounding ecosystem.",
              img1: "lib/images/Painting.jpeg",
              img2: "lib/images/Plumbing.jpeg",
              img3: "lib/images/PestControl.jpeg",
            ),
            SizedBox(height: 30),
            buildGrid(
              name1: "Electrician",
              name2: "UPVC Roofing",
              name3: "Toughened Glass",
              icon1: Icons.electric_meter_outlined,
              icon2: Icons.roofing_sharp,
              icon3: Icons.window_rounded,
              desc1:
                  "Electrician- For any electrical issues, we've got you covered. Our team of licensed electricians provides high-quality electrical services to ensure a consistent and safe flow of power in your home. Whether you need electrical installations, repairs, or upgrades, we have the expertise and reliability to meet your electrical needs. From wiring and lighting to electrical panel maintenance, we deliver efficient solutions using top-of-the-line equipment and adhering to industry safety standards.",
              desc2:
                  "UPVC Installation- When it comes to roofing solutions, our UPVC roofing services are top-notch. Experience superior quality and durability with our expertise in UPVC roof installation. We offer long-lasting protection for your home against the elements. Our team of skilled technicians ensures precise measurements, seamless installation, and excellent insulation for a reliable and energy-efficient roof. Choose from a variety of UPVC roofing options that provide thermal insulation, noise reduction, and enhanced weather resistance.",
              desc3:
                  "Toughened Glass- Enhance the aesthetics and safety of your space with our toughened glass installation services. Our expert team ensures precise installation, providing a stylish and secure solution for windows and glass features. We offer a wide range of toughened glass options, including clear, frosted, and textured glass, to suit your design preferences. Our experienced glaziers ensure seamless installation, taking into account factors such as safety regulations, thermal efficiency, and noise reduction.",
              img1: "lib/images/Electrician.jpeg",
              img2: "lib/images/UPVC Roofing Installation.webp",
              img3: "lib/images/Toughened Glass.jpeg",
            ),
            SizedBox(height: 12),
            buildGrid(
              name1: "Aluminum Installation",
              name2: "Smart Home",
              name3: "Home Finishing",
              icon1: Icons.door_front_door_rounded,
              icon2: Icons.roofing_sharp,
              icon3: Icons.smart_button_sharp,
              desc1:
                  "Aluminum Installation- Add elegance and functionality to your home with our aluminum installation services. Our skilled team specializes in installing high-quality aluminum fixtures, including doors, windows, and partitions, to enhance your living space. We offer a wide range of aluminum profiles, finishes, and designs to match your architectural style. Our precise installation ensures optimal fit, security, and energy efficiency, providing you with lasting comfort and peace of mind.",
              desc2:
                  "Smart Home Appliances Installation- Upgrade your home with smart home appliances installation. Experience the convenience and efficiency of automation with our expert installation services. From smart thermostats and lighting systems to security cameras and voice-controlled assistants, we integrate a wide range of smart devices to make your home smarter and more connected. Our technicians ensure seamless integration, configure settings according to your preferences, and provide training on how to use and manage your new smart home setup.",
              desc3:
                  "Home Finishing- Give your home the perfect finishing touches with our home finishing services. From exquisite details to flawless craftsmanship, we take pride in providing the final touches that make your home truly exceptional. Our team of skilled craftsmen and artisans can assist with various finishing tasks, including trim work, molding installation, cabinetry, and decorative accents. Whether you're looking to add character to a new construction or revitalize an existing space, we offer creative solutions that elevate the aesthetics and value of your home.",
              img1: "lib/images/Aluminum Installation.jpeg",
              img2: "lib/images/Smart Home Appliances Installation.jpeg",
              img3: "lib/images/Home Finishing.jpeg",
            ),
            SizedBox(height: 12),
            buildGrid(
              name1: "False Ceiling Installation",
              name2: "Furnishing",
              name3: "AC Repair",
              icon1: Icons.home_sharp,
              icon2: Icons.chair_rounded,
              icon3: Icons.air_rounded,
              desc1:
                  "False Ceiling Installation- Transform your space with our false ceiling installation services. Create an elegant and modern look while concealing unsightly wires and ducts. Our expert team ensures a seamless installation, adding style and sophistication to your home. We offer a variety of false ceiling designs, including gypsum board, metal, and acoustic panels, to suit your aesthetic preferences. Our skilled installers meticulously plan and execute the installation, taking into account lighting fixtures, ventilation requirements, and acoustics to create a visually appealing and functional false ceiling.",
              desc2:
                  "Furnishing- Complete your interior design with our exquisite furnishing services. From carefully selected furniture pieces to tasteful accessories, we offer stylish and comfortable options to complement your home's aesthetic. Our interior designers collaborate with you to understand your preferences and create a cohesive and personalized furnishing plan. Whether you're furnishing a single room or your entire home, we curate a selection of high-quality furniture, fabrics, and decor items that reflect your style and enhance the functionality of your living spaces.",
              desc3:
                  "AC Repair- Beat the heat with our reliable AC repair services. Our skilled technicians ensure your air conditioning system is running smoothly and efficiently, providing you with a cool and comfortable environment. We diagnose and repair a wide range of AC issues, including refrigerant leaks, compressor problems, and airflow restrictions. Our team is equipped with the necessary tools and expertise to handle various AC models and brands. We prioritize prompt service and strive to restore your AC's performance to its optimal level, helping you maintain a comfortable indoor climate.",
              img1: "lib/images/False Ceiling Installation.jpeg",
              img2: "lib/images/Furnishing.avif",
              img3: "lib/images/AC Repair.jpeg",
            ),
            SizedBox(height: 12),
            buildGrid(
              name1: "Application Repair",
              name2: "Home Inspection",
              name3: "Home Remodeling",
              icon1: Icons.local_laundry_service,
              icon2: Icons.search_rounded,
              icon3: Icons.house_sharp,
              desc1:
                  "Application Repair- Need assistance with application repairs? Our expert technicians are here to help. Whether it's fixing glitches, optimizing performance, or resolving software issues, we provide reliable and efficient application repair services. From mobile apps to desktop software, we have the expertise to diagnose and troubleshoot a wide range of applications. Our team stays updated with the latest technologies and tools to ensure effective and timely repairs, minimizing downtime and maximizing the usability of your applications.",
              desc2:
                  "Home Inspection- Ensure the safety and integrity of your home with our thorough home inspection services. Our professional inspectors conduct detailed assessments to identify potential issues and provide recommendations for maintenance and improvements. We inspect various aspects of your home, including electrical systems, plumbing, structural integrity, roofing, and more, to give you peace of mind. Our comprehensive reports highlight any existing or potential problems, allowing you to make informed decisions and take necessary actions to maintain or enhance your home's condition.",
              desc3:
                  "Home Remodeling- Transform your home into your dream space with our expert home remodeling services. From minor renovations to complete makeovers, we bring your vision to life, creating a functional and aesthetically pleasing living environment. Our team of designers, architects, and contractors work together to deliver high-quality craftsmanship and exceptional results. Whether you're looking to update a single room or overhaul your entire home, we offer comprehensive remodeling solutions tailored to your specific needs and preferences. From concept development to final execution, we guide you through each step of the remodeling process, ensuring your satisfaction and creating a space you'll love.",
              img1: "lib/images/Application Repair.jpeg",
              img2: "lib/images/Home Inspection.jpeg",
              img3: "lib/images/Home Remodeling.jpeg",
            ),
            SizedBox(height: 12),
            buildGrid(
              name1: "2D & 3D Design",
              name2: "House Map Design",
              name3: "Bathroom Remodeling",
              icon1: Icons.design_services_rounded,
              icon2: Icons.map_outlined,
              icon3: Icons.bathtub,
              desc1:
                  "2D & 3D Design- Explore the possibilities of your space with our 2D and 3D design services. Our talented designers provide realistic visualizations and precise floor plans to help you envision and plan your dream home. Whether you're starting from scratch or remodeling an existing space, our design expertise can bring your ideas to life. We collaborate closely with you to understand your lifestyle, preferences, and functional requirements, translating them into captivating designs that optimize space utilization and create harmonious living environments.",
              desc2:
                  "House Map Design- Design your dream home with our house map design services. Our experienced architects create customized and functional floor plans, optimizing space utilization and ensuring architectural integrity. We consider factors such as your lifestyle, preferences, and local building regulations to design a home that meets your needs and reflects your personal style. Our architects bring creativity and technical expertise to the table, delivering comprehensive house maps that address all aspects of a well-designed home, including spatial flow, natural lighting, structural stability, and sustainability.",
              desc3:
                  "Bathroom Remodeling- Elevate your bathroom experience with our bathroom remodeling services. From luxurious fixtures to innovative designs, we specialize in creating stylish and functional bathrooms tailored to your preferences. Our team of designers and contractors collaborate closely with you to understand your vision and specific requirements. We offer a wide range of options for bathroom fixtures, flooring, lighting, and storage solutions. Whether you desire a relaxing spa-like retreat or a modern and sleek design, we ensure attention to detail and superior craftsmanship in every aspect of your bathroom remodel.",
              img1: "lib/images/2D & 3D Design.jpeg",
              img2: "lib/images/House Map Design.jpeg",
              img3: "lib/images/Bathroom Remodeling.jpeg",
            ),
            SizedBox(height: 12),
            buildGrid(
              name1: "Railing Installation",
              name2: "Hair Dresser",
              name3: "Modular Kitchen",
              icon1: Icons.fence_rounded,
              icon2: Icons.spa_rounded,
              icon3: Icons.kitchen,
              desc1:
                  "Railing Installation- Enhance your property with our professional railing installation services. Our skilled team ensures precise positioning, secure attachment, and meticulous installation for a visually appealing and functional result. Trust us to enhance safety and aesthetics with expert railing installation. We offer a variety of railing options, including metal, glass, and wood, to complement your property's design. Whether it's a staircase railing, balcony railing, or deck railing, our experienced installers deliver top-quality craftsmanship and attention to detail.",
              desc2:
                  "Hair Dresser- Get a stunning hair transformation with our skilled hairdressers. We offer expert hairdressing services, including cuts, colors, and styles, to leave you looking and feeling fabulous. Trust our experienced team for personalized attention and tailored solutions that suit your unique style. Whether you're seeking a trendy haircut, a glamorous updo, or a complete makeover, we deliver exceptional results. Our hairdressers stay updated with the latest trends and techniques to offer you a wide range of options and ensure your satisfaction with every visit.",
              desc3:
                  "Modular Kitchen- Revamp your kitchen with a sleek and efficient modular solution. Our customizable options, including cabinets, countertops, and storage solutions, offer both style and functionality. Experience the convenience of a modern kitchen with our expert installations. Our team works closely with you to design a modular kitchen that maximizes space, improves workflow, and reflects your culinary preferences. From selecting high-quality materials to optimizing storage solutions and incorporating cutting-edge kitchen appliances, we create a kitchen that meets your unique needs and enhances your cooking experience.",
              //change
              img1: "lib/images/Railing.jpeg",
              img2: "lib/images/Hair_Dresser.jpeg",
              img3: "lib/images/Modular Kitchen.jpeg",
            ),
          ],
        ),
      ),
    );
  }
}

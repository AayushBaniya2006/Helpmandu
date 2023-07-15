import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/ServiceDesc.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);


  void logOut() {
    FirebaseAuth.instance.signOut();
  }



  Widget buildGrid(
    String name1,
    String name2,
    String name3,
    IconData icon1,
    IconData icon2,
    IconData icon3,
    int price1,
    int price2,
    int price3,
    String desc1,
    String desc2,
    String desc3,
    String img1,
    String img2,
    String img3,
    BuildContext context,
  ) {
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
          int selectedPrice;

          if (index == 0) {
            selectedIcon = icon1;
            selectedName = name1;
            selectedDesc = desc1;
            selectedImg = img1;
            selectedPrice = price1;
          } else if (index == 1) {
            selectedIcon = icon2;
            selectedName = name2;
            selectedDesc = desc2;
            selectedImg = img2;
            selectedPrice = price2;
          } else {
            selectedIcon = icon3;
            selectedName = name3;
            selectedDesc = desc3;
            selectedImg = img3;
            selectedPrice = price3;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDesc(
                    name: selectedName,
                    icon: selectedIcon,
                    price: selectedPrice,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        '- Our Services Provided -',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Categories:
                      buildGrid(
                        "Painting",
                        "Plumbing",
                        "Pest Control",
                        Icons.format_paint,
                        Icons.plumbing,
                        Icons.pest_control_rodent_outlined,
                        200,
                        300,
                        400,
                        "Painting- If you're looking for exceptional painting services, look no further. We provide meticulous attention to detail, innovative designs, and a blend of modern artistry for your colorful journey. Let us transform your home and bring your vision to life.",
                        "Plumbing- Trust our plumbing services for all your plumbing needs. From installation to repair, we offer comprehensive solutions to ensure proper water flow, drainage, and maintenance in your home.",
                        "Pest Control- Protect your home from pests with our reliable pest control services. Our expert technicians use effective and environmentally friendly methods to eliminate pests and ensure a pest-free living environment.",
                        "lib/images/Painting.jpeg",
                        "lib/images/Plumbing.jpeg",
                        "lib/images/PestControl.jpeg",
                        context,
                      ),
                      const SizedBox(height: 12),
                      buildGrid(
                        "Electrician",
                        "UPVC Roofing Installation",
                        "Toughened Glass Installation",
                        Icons.electric_meter_outlined,
                        Icons.roofing_sharp,
                        Icons.window_rounded,
                        200,
                        300,
                        400,
                        "Electrician- For any electrical issues, we've got you covered. Our high-quality electrical services ensure a consistent and safe flow of power in your home. We provide expertise and reliability in all our electrical installations and repairs.",
                        "UPVC Installation-When it comes to roofing solutions, our UPVC roofing services are top-notch. Experience superior quality and durability with our expertise in UPVC roof installation. We offer long-lasting protection for your home against the elements.",
                        "Toughened Glass- Enhance the aesthetics and safety of your space with our toughened glass installation services. Our expert team ensures precise installation, providing a stylish and secure solution for windows and glass features. ",
                        "lib/images/Electrician.jpeg",
                        "lib/images/UPVC Roofing Installation.webp",
                        "lib/images/Toughened Glass.jpeg",
                        context,
                      ),
                      const SizedBox(height: 12),
                      buildGrid(
                        "Aluminum Installation",
                        "Smart Home Appliances Installation",
                        "Home Finishing",
                        Icons.door_front_door_rounded,
                        Icons.roofing_sharp,
                        Icons.smart_button_sharp,
                        200,
                        300,
                        400,
                        "Aluminum Installation- Add elegance and functionality to your home with our aluminum installation services. Our skilled team specializes in installing high-quality aluminum fixtures, including doors and windows, to enhance your living space.",
                        "Smart Home Appliances Installation- Upgrade your home with smart home appliances installation. Experience the convenience and efficiency of automation with our expert installation services. Make your home smarter and more connected.",
                        "Home Finishing- Give your home the perfect finishing touches with our home finishing services. From exquisite details to flawless craftsmanship, we take pride in providing the final touches that make your home truly exceptional.",
                        "lib/images/Aluminum Installation.jpeg",
                        "lib/images/Smart Home Appliances Installation.jpeg",
                        "lib/images/Home Finishing.jpeg",
                        context,
                      ),
                      const SizedBox(height: 12),
                      buildGrid(
                        "False Ceiling Installation",
                        "Furnishing",
                        "AC Repair",
                        Icons.home_sharp,
                        Icons.chair_rounded,
                        Icons.air_rounded,
                        200,
                        300,
                        400,
                        "False Ceiling Installation- Transform your space with our false ceiling installation services. Create an elegant and modern look while concealing unsightly wires and ducts. Our expert team ensures a seamless installation, adding style and sophistication to your home.",
                        "Furnishing- Complete your interior design with our exquisite furnishing services. From carefully selected furniture pieces to tasteful accessories, we offer stylish and comfortable options to complement your home's aesthetic.",
                        "AC Repair- Beat the heat with our reliable AC repair services. Our skilled technicians ensure your air conditioning system is running smoothly and efficiently, providing you with a cool and comfortable environment.",
                        "lib/images/False Ceiling Installation.jpeg",
                        "lib/images/Furnishing.avif",
                        "lib/images/AC Repair.jpeg",
                        context,
                      ),
                      const SizedBox(height: 12),
                      buildGrid(
                        "Application Repair",
                        "Home Inspection",
                        "Home Remodeling",
                        Icons.local_laundry_service,
                        Icons.search_rounded,
                        Icons.house_sharp,
                        200,
                        300,
                        400,
                        "Application Repair- Need assistance with application repairs? Our expert technicians are here to help. Whether it's fixing glitches, optimizing performance, or resolving software issues, we provide reliable and efficient application repair services.",
                        "Home Inspection- Ensure the safety and integrity of your home with our thorough home inspection services. Our professional inspectors conduct detailed assessments to identify potential issues and provide recommendations for maintenance and improvements.",
                        "Home Remodeling-  Transform your home into your dream space with our expert home remodeling services. From minor renovations to complete makeovers, we bring your vision to life, creating a functional and aesthetically pleasing living environment.",
                        "lib/images/Application Repair.jpeg",
                        "lib/images/Home Inspection.jpeg",
                        "lib/images/Home Remodeling.jpeg",
                        context,
                      ),
                      const SizedBox(height: 12),
                      buildGrid(
                        "2D & 3D Design",
                        "House Map Design",
                        "Bathroom Remodeling",
                        Icons.design_services_rounded,
                        Icons.map_outlined,
                        Icons.bathtub,
                        200,
                        300,
                        400,
                        "2D & 3D Design- Explore the possibilities of your space with our 2D and 3D design services. Our talented designers provide realistic visualizations and precise floor plans to help you envision and plan your dream home.",
                        "House Map Design- Design your dream home with our house map design services. Our experienced architects create customized and functional floor plans, optimizing space utilization and ensuring architectural integrity.",
                        "Bathroom Remodeling-  Elevate your bathroom experience with our bathroom remodeling services. From luxurious fixtures to innovative designs, we specialize in creating stylish and functional bathrooms tailored to your preferences.",
                        "lib/images/2D & 3D Design.jpeg",
                        "lib/images/House Map Design.jpeg",
                        "lib/images/Bathroom Remodeling.jpeg",
                        context,
                      ),
                      buildGrid(
                        "Railing Installation",
                        "Hair Dresser",
                        "Modular Kitchen",
                        Icons.fence_rounded,
                        Icons.spa_rounded,
                        Icons.kitchen,
                        200,
                        300,
                        400,
                        "Railing Installation- Enhance your property with our professional railing installation services. Our skilled team ensures precise positioning, secure attachment, and meticulous installation for a visually appealing and functional result. Trust us to enhance safety and aesthetics with expert railing installation.",                        
                        "Hair Dresser- Get a stunning hair transformation with our skilled hairdressers. We offer expert hairdressing services, including cuts, colors, and styles, to leave you looking and feeling fabulous. Trust our experienced team for personalized attention and tailored solutions that suit your unique style.",
                        "Modular Kitchen-  Revamp your kitchen with a sleek and efficient modular solution. Our customizable options, including cabinets, countertops, and storage solutions, offer both style and functionality. Experience the convenience of a modern kitchen with our expert installations.",
                        "lib/images/2D & 3D Design.jpeg",
                        "lib/images/House Map Design.jpeg",
                        "lib/images/Bathroom Remodeling.jpeg",
                        context
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

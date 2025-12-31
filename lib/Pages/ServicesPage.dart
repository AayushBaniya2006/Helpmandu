import 'package:flutter/material.dart';
import '../Components/build_grid.dart';

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'All Services',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Text(
                  'Browse our complete range of services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              // Services Grid
              const buildGrid(
                name1: "Painting",
                name2: "Plumbing",
                name3: "Pest\nControl",
                icon1: Icons.format_paint_outlined,
                icon2: Icons.plumbing_outlined,
                icon3: Icons.pest_control_outlined,
                desc1: "Exceptional painting services with meticulous attention to detail.",
                desc2: "Trust our plumbing services for all your plumbing needs.",
                desc3: "Protect your home from pests with our reliable pest control services.",
                img1: "lib/images/Painting.jpeg",
                img2: "lib/images/Plumbing.jpeg",
                img3: "lib/images/PestControl.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "Electrician",
                name2: "UPVC\nRoofing",
                name3: "Toughened\nGlass",
                icon1: Icons.electrical_services_outlined,
                icon2: Icons.roofing_outlined,
                icon3: Icons.window_outlined,
                desc1: "Licensed electricians for a safe flow of power in your home.",
                desc2: "Experience superior quality and durability with our UPVC roofing.",
                desc3: "Enhance aesthetics and safety with toughened glass installation.",
                img1: "lib/images/Electrician.jpeg",
                img2: "lib/images/UPVC Roofing Installation.webp",
                img3: "lib/images/Toughened Glass.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "Aluminum\nInstallation",
                name2: "Smart\nHome",
                name3: "Home\nFinishing",
                icon1: Icons.door_sliding_outlined,
                icon2: Icons.smart_toy_outlined,
                icon3: Icons.home_repair_service_outlined,
                desc1: "Add elegance and functionality with aluminum installation.",
                desc2: "Upgrade your home with smart appliances installation.",
                desc3: "Give your home the perfect finishing touches.",
                img1: "lib/images/Aluminum Installation.jpeg",
                img2: "lib/images/Smart Home Appliances Installation.jpeg",
                img3: "lib/images/Home Finishing.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "False\nCeiling",
                name2: "Furnishing",
                name3: "AC Repair",
                icon1: Icons.layers_outlined,
                icon2: Icons.chair_outlined,
                icon3: Icons.ac_unit_outlined,
                desc1: "Transform your space with false ceiling installation.",
                desc2: "Complete your interior with exquisite furnishing.",
                desc3: "Beat the heat with our reliable AC repair services.",
                img1: "lib/images/False Ceiling Installation.jpeg",
                img2: "lib/images/Furnishing.avif",
                img3: "lib/images/AC Repair.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "Appliance\nRepair",
                name2: "Home\nInspection",
                name3: "Home\nRemodeling",
                icon1: Icons.settings_outlined,
                icon2: Icons.home_work_outlined,
                icon3: Icons.construction_outlined,
                desc1: "Expert technicians for appliance repairs.",
                desc2: "Thorough home inspection services.",
                desc3: "Transform your home into your dream space.",
                img1: "lib/images/Application Repair.jpeg",
                img2: "lib/images/Home Inspection.jpeg",
                img3: "lib/images/Home Remodeling.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "2D & 3D\nDesign",
                name2: "House Map\nDesign",
                name3: "Bathroom\nRemodel",
                icon1: Icons.design_services_outlined,
                icon2: Icons.map_outlined,
                icon3: Icons.bathtub_outlined,
                desc1: "Explore possibilities with our design services.",
                desc2: "Customized and functional floor plans.",
                desc3: "Elevate your bathroom experience.",
                img1: "lib/images/2D & 3D Design.jpeg",
                img2: "lib/images/House Map Design.jpeg",
                img3: "lib/images/Bathroom Remodeling.jpeg",
              ),
              const SizedBox(height: 20),

              const buildGrid(
                name1: "Railing\nInstallation",
                name2: "Hair\nDresser",
                name3: "Modular\nKitchen",
                icon1: Icons.fence_outlined,
                icon2: Icons.content_cut_outlined,
                icon3: Icons.kitchen_outlined,
                desc1: "Professional railing installation services.",
                desc2: "Expert hairdressing services.",
                desc3: "Sleek and efficient modular kitchen solutions.",
                img1: "lib/images/Railing.jpeg",
                img2: "lib/images/Hair_Dresser.jpeg",
                img3: "lib/images/Modular Kitchen.jpeg",
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

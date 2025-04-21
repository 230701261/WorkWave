import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_themes.dart';
import '../routes.dart';
import '../models/user_model.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final UserModel user;
  
  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.user,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isFreelancer = user.userType == 'freelancer';
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppThemes.primaryColor,
      unselectedItemColor: AppThemes.textSecondaryColor,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      onTap: (index) => _onItemTapped(index, isFreelancer),
      items: isFreelancer
          ? _getFreelancerNavItems()
          : _getClientNavItems(),
    );
  }
  
  List<BottomNavigationBarItem> _getFreelancerNavItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        activeIcon: Icon(Icons.search),
        label: 'Find Jobs',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.description_outlined),
        activeIcon: Icon(Icons.description),
        label: 'My Proposals',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_outlined),
        activeIcon: Icon(Icons.chat),
        label: 'Messages',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
  
  List<BottomNavigationBarItem> _getClientNavItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        activeIcon: Icon(Icons.add_circle),
        label: 'Post a Job',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'My Jobs',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_outlined),
        activeIcon: Icon(Icons.chat),
        label: 'Messages',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
  
  void _onItemTapped(int index, bool isFreelancer) {
    if (currentIndex == index) return;
    
    if (isFreelancer) {
      switch (index) {
        case 0:
          Get.offAllNamed(Routes.freelancerDashboard);
          break;
        case 1:
          Get.offAllNamed(Routes.findJobs);
          break;
        case 2:
          Get.offAllNamed(Routes.myProposals);
          break;
        case 3:
          Get.offAllNamed(Routes.messages);
          break;
        case 4:
          Get.offAllNamed(Routes.freelancerProfile);
          break;
      }
    } else {
      switch (index) {
        case 0:
          Get.offAllNamed(Routes.clientDashboard);
          break;
        case 1:
          Get.offAllNamed(Routes.postJob);
          break;
        case 2:
          Get.offAllNamed(Routes.myJobs);
          break;
        case 3:
          Get.offAllNamed(Routes.messages);
          break;
        case 4:
          Get.offAllNamed(Routes.clientProfile);
          break;
      }
    }
  }
}

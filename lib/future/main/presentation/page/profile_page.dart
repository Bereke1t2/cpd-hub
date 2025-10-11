import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';

import '../../../../core/ui_constants.dart';
import '../widget/info_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Profile",
      subtitle: "Your personal information",
      selectedIndex: 4,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
              decoration: BoxDecoration(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://www.gravatar.com/avatar/placeholder?s=200&d=robohash&r=x',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "John Doe",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: UiConstants.mainTextColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 14,
                              color: UiConstants.primaryButtonColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text('Profile', style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: UiConstants.mainTextColor),),
                      SizedBox(width: 16,), 
                      Text('Attendance' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.normal , color: UiConstants.subtitleTextColor),),
                      SizedBox(width: 16,),
                      Text('Submission' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.normal , color: UiConstants.subtitleTextColor),),
                      SizedBox(width: 16,),
                      Text('Edit Profile' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.normal , color: UiConstants.subtitleTextColor),),
                    ],),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const InfoSection(
              division: 1,
              rating: "1500",
              rank: "Gold",
              solvedProblems: 120,
            ),
          ],
        ),
      ),
    );
  }
}

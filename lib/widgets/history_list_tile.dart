import 'package:ecosort/constants/colors.dart';
import 'package:ecosort/enums/recyclability.dart';
import 'package:flutter/material.dart';

import 'recyclability_indicator.dart';


class HistoryTile extends StatelessWidget {
  final Recyclability recyclability;
  final String materialDescription;

  const HistoryTile(
      {super.key,
      required this.recyclability,
      required this.materialDescription});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor,
              blurRadius: 5.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/6/6b/8.4_floz_can_of_Red_Bull_Energy_Drink.jpg',
            height: 50,
            width: 50,
          ),
          title: Text(
            materialDescription,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  RecyclabilityIndicator(
                    recyclability: recyclability,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.grey,
                    size: 15,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '3 weeks ago',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

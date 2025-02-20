import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';

import '../pages/scan_result.dart';

class QuestionModalBottomSheet extends StatelessWidget {
  final String question;
  final String description;
  final int categoryId;
  final String categoryName;

  const QuestionModalBottomSheet(
      {super.key,
      required this.question,
      required this.description,
      required this.categoryId,
      required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                question,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Text(description),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanResultScreen(
                          materialConditionId: 2,
                          categoryId: categoryId,
                          categoryName: categoryName,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text('Yes', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanResultScreen(
                          materialConditionId: 1,
                          categoryId: categoryId,
                          categoryName: categoryName,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('No', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

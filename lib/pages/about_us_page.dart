import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Color(0xFF0EB145), // Primary color
      ),
      body: SingleChildScrollView( // Enable scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About EcoSort',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'EcoSort is an AI-powered waste segregation app that identifies, classifies, and suggests the correct disposal method for waste. Using image recognition and real-time feedback, it helps users sort recyclables, compostables, and non-recyclables accurately. EcoSort promotes sustainable habits, reduces landfill contributions, and makes waste management smarter and more efficient for homes, offices, and communities.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Meet the Developers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildCreatorTile('Florian Jafar Sabonchi', 'Lead Developer', 'German', 'Florian is passionate about sustainable technology and has a background in software engineering.'),
            _buildCreatorTile('Silas Germer', 'Researcher', 'German', 'Silas specializes in environmental science and focuses on waste management solutions.'),
            _buildCreatorTile('Nishtha Jain', 'Frontend Developer', 'Indian', 'Nishtha is a creative developer with a knack for building user-friendly interfaces.'),
            _buildCreatorTile('Aishwarya Dhaul', 'Frontend Developer', 'Indian', 'Aishwarya is dedicated to enhancing user experience through innovative design.'),
            _buildCreatorTile('Ceyanne Dsouza', 'Backend Developer', 'Indian', 'Ceyanne is skilled in server-side development and database management.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorTile(String name, String role, String nationality, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role),
            Text(nationality),
            Text(description, style: TextStyle(color: Colors.black54)),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF0EB145),
          // Replace with an image if available
          backgroundImage: AssetImage('assets/images/${name.toLowerCase().replaceAll(' ', '_')}.jpg'), // Example image path
        ),
      ),
    );
  }
}
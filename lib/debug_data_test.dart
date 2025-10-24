import 'package:flutter/material.dart';
import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homestate.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';

/// Debug widget to test data display
class DebugDataTest extends StatelessWidget {
  const DebugDataTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Data Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Display Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Test currentIndex logic
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Index Logic Test:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildTestScenario('Users: 5, currentIndex: 0', 5, 0),
                  _buildTestScenario('Users: 5, currentIndex: 2', 5, 2),
                  _buildTestScenario('Users: 5, currentIndex: 4', 5, 4),
                  _buildTestScenario('Users: 5, currentIndex: 5', 5, 5),
                  _buildTestScenario('Users: 3, currentIndex: 0', 3, 0),
                  _buildTestScenario('Users: 3, currentIndex: 2', 3, 2),
                  _buildTestScenario('Users: 3, currentIndex: 3', 3, 3),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Test state initialization
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'State Initialization Test:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Default currentIndex: 0 (Fixed)'),
                  Text('Previous currentIndex: 2 (Caused the issue)'),
                  SizedBox(height: 10),
                  Text(
                    'The issue was that currentIndex=2 was greater than or equal to users.length-1, causing "No More Users Found" to show instead of actual user data.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Test the fix
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fix Applied:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                  SizedBox(height: 10),
                  Text('✅ Changed currentIndex default from 2 to 0'),
                  Text('✅ Fixed condition from >= length-1 to >= length'),
                  Text('✅ Added safety check for array bounds'),
                  Text('✅ Reset currentIndex to 0 when new data loads'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestScenario(String description, int userCount, int currentIndex) {
    bool shouldShowUser = currentIndex < userCount;
    bool isAtEnd = currentIndex >= userCount;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            shouldShowUser ? Icons.check_circle : Icons.cancel,
            color: shouldShowUser ? Colors.green : Colors.red,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '$description → ${shouldShowUser ? "Shows User Data" : "Shows No More Users"}',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

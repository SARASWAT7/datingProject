import 'package:flutter/material.dart';
import 'package:demoproject/service/update_manager.dart';

/// Test widget to manually trigger update checks
class TestUpdateWidget extends StatelessWidget {
  const TestUpdateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Update System'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Update System Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            
            // Test Optional Update
            ElevatedButton(
              onPressed: () => _testOptionalUpdate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Test Optional Update Dialog'),
            ),
            
            SizedBox(height: 20),
            
            // Test Force Update
            ElevatedButton(
              onPressed: () => _testForceUpdate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Test Force Update Screen'),
            ),
            
            SizedBox(height: 20),
            
            // Test Manual Check
            ElevatedButton(
              onPressed: () => _testManualCheck(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Test Manual Update Check'),
            ),
            
            SizedBox(height: 20),
            
            // Reset Dismissal
            ElevatedButton(
              onPressed: () => _resetDismissal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Reset Update Dismissal'),
            ),
            
            SizedBox(height: 30),
            
            Text(
              'Instructions:\n'
              '1. Optional Update: Shows dismissible dialog\n'
              '2. Force Update: Shows full screen (no dismiss)\n'
              '3. Manual Check: Checks for updates\n'
              '4. Reset: Clears dismissal memory',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _testOptionalUpdate(BuildContext context) {
    // Simulate optional update by showing dialog directly
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('Test Optional Update'),
        content: Text('This simulates an optional update dialog. You can dismiss this.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Update button pressed!')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _testForceUpdate(BuildContext context) {
    // Navigate to force update screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Force Update Test'),
            automaticallyImplyLeading: false, // No back button
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.system_update, size: 100, color: Colors.red),
                SizedBox(height: 20),
                Text(
                  'Force Update Screen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('This simulates a force update that cannot be dismissed.'),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update button pressed!')),
                    );
                  },
                  child: Text('Update Now'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Back to Test (Only for testing)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _testManualCheck(BuildContext context) async {
    try {
      await UpdateManager.manualUpdateCheck(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Manual check completed')),
      );
    }
  }

  void _resetDismissal(BuildContext context) async {
    try {
      await UpdateManager.resetUpdateDismissal();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update dismissal reset successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting dismissal: $e')),
      );
    }
  }
}

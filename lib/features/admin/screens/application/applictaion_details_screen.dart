import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/screens/driver/model/driver_model.dart';
import 'package:kmb_app/features/admin/screens/driver/ui/driver_details_screen.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  const ApplicationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Application details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(
          onPressed: () {
            context.goNamed('admin_dashboard');
          },
        ),
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            const Text(
              'APPLICATION INFORMATION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ConstrainedBox(
                
                constraints: const BoxConstraints(
                  maxWidth: 600, // adjust as needed
                ),
                child: _detailsGrid(context),
            
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _detailsGrid(BuildContext context) {
    return Column(
     
      children: [
        _row(_detail('DRIVER\'S NAME', ''), _detail('DRIVER\'S PHONE', '')),
        const SizedBox(height: 16),
        _row(
          _detail('DRIVER\'S PAN', ''),
          _detail('DRIVER\'S VOTER', ''),
        ),
        const SizedBox(height: 16),

      ],
    );
  }

  Widget _row(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left,flex: 2,),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _detail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 78, 78, 78),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _documentDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 78, 78, 78),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              value ?? '-',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            if (value != null)
              InkWell(
                onTap: () {},
                child: const Icon(Icons.visibility, size: 18),
              ),
          ],
        ),
      ],
    );
  }
}

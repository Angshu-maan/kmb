import 'package:flutter/material.dart';

class DriverDetailsImagePlaceholder extends StatelessWidget {

  final String? imageUrl;

  const DriverDetailsImagePlaceholder({super.key,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl == null ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(Icons.image_outlined,size: 40,),
          SizedBox(height: 8,),
          Text('No Photo available'),
        ],
      )
      : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl!, fit: BoxFit.cover),
            ),
    );
  }
}






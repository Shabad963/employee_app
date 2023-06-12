import 'package:flutter/material.dart';

class RoleSelectionBottomSheet extends StatelessWidget {
  
  final TextEditingController roleController;

   RoleSelectionBottomSheet({
   
    required this.roleController,
  });

 final List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: roles
            .map(
              (role) => ListTile(
                title: Text(role),
                onTap: () {
                  roleController.text = role;
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

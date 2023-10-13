import 'package:flutter/material.dart';
import 'package:patient_journey/constants/app_colors.dart';

class AddChatScreen extends StatelessWidget {
  const AddChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Chat'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
          itemBuilder: (ctx,index)=>Card(
            child: ListTile(
              leading: CircleAvatar(),
              title: Text('Name'),
              subtitle: Text('Email'),
              trailing: IconButton(
                onPressed: (){
                  
                },
                icon: Icon(Icons.add_circle,color: AppColors.primary,),
              ),
            ),
          ),
          itemCount: 10
      ),
    );
  }
}

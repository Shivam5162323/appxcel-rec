import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe['image']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe['label'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Display the ingredients only if they exist and are iterable
            if (recipe['ingredients'] != null && recipe['ingredients'] is Iterable)
              for (var ingredient in recipe['ingredients'])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('- $ingredient'),
                ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Steps:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Display the steps only if they exist and are iterable
            if (recipe['steps'] != null && recipe['steps'] is Iterable)
              for (var step in recipe['steps'])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('- $step'),
                ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
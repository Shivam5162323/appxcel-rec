import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  Map<String, dynamic> chatResponse = {};
  String recipeSteps = 'Loading...'; // Placeholder for recipe steps

  @override
  void initState() {
    super.initState();
    _searchRecipeDetails();
  }



  Future<void> _searchRecipeDetails() async {
    final label = widget.recipe['label'];
    final apiKey = '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'; // Replace with your OpenAI API key

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'query': 'Find a recipe for $label in less than 10 steps',
        'max_tokens': 100, // Increase max_tokens for longer responses
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('ChatGPT Response: $responseData');

      setState(() {
        chatResponse = responseData;
      });

      // Now, make another API call to retrieve the recipe steps
      final recipeStepsResponse = await http.get(
        Uri.parse('URL_TO_RETRIEVE_RECIPE_STEPS'), // Replace with the actual URL for retrieving steps
      );

      if (recipeStepsResponse.statusCode == 200) {
        final recipeStepsData = json.decode(recipeStepsResponse.body);
        // Extract and handle the recipe steps here
        setState(() {
          recipeSteps = '1. Step 1\n2. Step 2\n3. Step 3'; // Replace with actual steps
        });
      } else {
        print('Recipe Steps API Request Failed: ${recipeStepsResponse.statusCode}');
        setState(() {
          recipeSteps = 'Failed to retrieve recipe steps.';
        });
      }
    } else {
      print('ChatGPT API Request Failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13),
                  alignment: Alignment.center,
                  child: Text(
                    widget.recipe['label'],
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
                if (widget.recipe['ingredients'] != null && widget.recipe['ingredients'] is Iterable)
                  for (var ingredient in widget.recipe['ingredients'])
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                      child: ListTile(
                        tileColor: Color(0xFFF262627),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                        title: Text('${ingredient['text']}', style: TextStyle(color: Color(0xFFFF4F4EC))),
                      ),
                    ),


                SizedBox(height: 16),




                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Recipe Steps:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // Display the recipe steps here
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    child: Text('${widget.recipe['url']}',style: TextStyle(fontSize: 16),),
                    onPressed: (){
                     launchUrlString(widget.recipe['url'],mode: LaunchMode.inAppWebView);
                    },

                  ),
                ),
                SizedBox(height: 16),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(400)),
                  child: Image.network(
                    widget.recipe['image'],
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

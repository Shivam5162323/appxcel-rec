import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackcog/recdet.dart';
import 'package:http/http.dart' as http;

class RecipeGenerator extends StatefulWidget {
  @override
  _RecipeGeneratorState createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {
  TextEditingController _ingredientController = TextEditingController();
  List<String> filters = [];
  List<dynamic> recipes = [];
  bool isLoading = false;

  void addFilter() {
    String ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        filters.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void deleteFilter(int index) {
    setState(() {
      filters.removeAt(index);
    });
  }

  void searchRecipes() async {
    setState(() {
      isLoading = true;
    });

    final app_id = 'beb1aeae'; // Replace with your Edamam app ID
    final app_key = '8c653798159b10ffea8beb0bd541a0c0'; // Replace with your Edamam app key
    final query = filters.join(' ');

    final Uri url = Uri.parse('https://api.edamam.com/search?q=$query&app_id=$app_id&app_key=$app_key');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        recipes = data['hits'];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
        recipes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Generator'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                      hintText: 'Add your ingredients here',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addFilter,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchRecipes,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(filters[index]),
                  onDeleted: () => deleteFilter(index),
                );
              },
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                childAspectRatio: 0.7, // Aspect ratio for each card
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index]['recipe'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailsScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01,vertical: MediaQuery.of(context).size.height*0.01),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17))),
                      elevation: 4, // Adjust the elevation as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                          borderRadius:  BorderRadius.only(topRight: Radius.circular(17)),
                              child: Image.network(recipe['image'])),
                          Text(
                            recipe['label'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(recipe['source']),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

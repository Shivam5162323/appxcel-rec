import 'dart:convert';
import 'dart:math';
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
  List<String> initialIngredients = [
    'lemon', 'tea', 'chicken', 'tomato', 'potato', 'onion', 'garlic', 'carrot',
    'broccoli', 'spinach', 'pasta', 'rice', 'beans', 'cheese', 'egg', 'bread',
    'avocado', 'banana', 'strawberry', 'blueberry', 'mushroom', 'bell pepper',
    'cucumber', 'zucchini', 'pineapple', 'orange', 'grapefruit', 'watermelon',
    'chocolate', 'yogurt', 'honey', 'nuts', 'cereal', 'oatmeal', 'quinoa'

  ];


  void addFilter() {
    String ingredient = _ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        filters.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Select a random ingredient from initialIngredients list
    final random = Random();
    final randomIngredientIndex = random.nextInt(initialIngredients.length);
    final initialIngredient = initialIngredients[randomIngredientIndex];

    // Add the random ingredient to filters
    filters.add(initialIngredient);

    // Trigger searchRecipes to populate recipes with initial search
    searchRecipes();
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

    final app_id = 'beb1aeae';
    final app_key = '8c653798159b10ffea8beb0bd541a0c0';
    final query = filters.join(' ');

    final Uri url = Uri.parse(
        'https://api.edamam.com/search?q=$query&app_id=$app_id&app_key=$app_key');
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


      body: Column(
        children: <Widget>[


          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              color: Color(0xFFF262627),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),

            ),

            child: Column(
              children: [

                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: MediaQuery
                            .of(context)
                            .size
                            .width * 0.04, top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.077),
                        child: Text('CineCook~', style: TextStyle(
                            color: Colors.white, fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * 0.035, fontWeight: FontWeight.w600),)),
                    Container(
                        height: 35,

                        // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005,vertical: MediaQuery.of(context).size.height * 0.0001),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFFCCFF00),

                        ),


                        margin: EdgeInsets.only(left: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4, top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.077),
                        child: IconButton(onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border, color: Colors.black,)))
                  ],
                ),


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Color(0xFFF393939),
                    borderRadius: BorderRadius.circular(15),

                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: TextField(

                            style: TextStyle(color: Colors.white),

                            controller: _ingredientController,
                            decoration: InputDecoration(


                              hintText: 'Add your ingredients here',
                              hintStyle: TextStyle(color: Colors.grey,),

                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.grey,),
                        onPressed: addFilter,
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.grey,),
                        onPressed: searchRecipes,
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),


          Container(

            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * 0.02, left: MediaQuery
                .of(context)
                .size
                .width * 0.04, right: MediaQuery
                .of(context)
                .size
                .width * 0.02, bottom: MediaQuery
                .of(context)
                .size
                .height * 0.02),
            // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,left:MediaQuery.of(context).size.width*0.04 ),

            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.02, right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.01),

                  child: Chip(
                    backgroundColor: Color(0xFFF393939),
                    label: Text(
                      filters[index], style: TextStyle(color: Colors.grey),),
                    deleteIconColor: Colors.grey,
                    onDeleted: () => deleteFilter(index),
                  ),
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
                        builder: (context) =>
                            RecipeDetailsScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Container(


                    margin: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.01, vertical: MediaQuery
                        .of(context)
                        .size
                        .height * 0.005),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17))),
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(

                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30)),


                              child: Container(
                                // padding: EdgeInsets.all(10),

                                  child: Image.network(recipe['image'],

                                      errorBuilder: (context, error, stackTrace) {

                                        return Container(
                                            margin: EdgeInsets.symmetric(vertical: 25),
                                            child: Image.network('https://cdn-icons-png.flaticon.com/128/11520/11520781.png'));
                                      }
                                  ),),),

                          SizedBox(height: 15,),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  recipe['label'],
                                  maxLines: 1, // Limit to one line
                                  overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  recipe['source'],
                                  maxLines: 1, // Limit to one line
                                  overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
                                ),
                              ],
                            ),
                          )

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

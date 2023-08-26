import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/parser.dart' as html;

class RecipeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  List<String> movieTitles = [];
  List<String> movieImageUrls = [];
  String genres = 'comedy';

  void fetchData(String genre) async {
    final url = 'https://moviesmod.vip/movies-by-genre/$genre/';

    // Send an HTTP GET request to the URL
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the HTML content of the webpage
      final document = html.parse(response.body);

      // Extract movie titles
      final titles = document.querySelectorAll('.front-view-title');
      for (final title in titles) {
        final extractedTitle = extractTitle(title.text);
        if (extractedTitle != null) {
          // Check if the widget is still mounted before calling setState
          if (mounted) {
            setState(() {
              movieTitles.add(extractedTitle);
            });
          }
        }
      }

      // Extract movie image URLs
      final images = document.querySelectorAll('.featured-thumbnail img');
      for (final image in images) {
        final imageUrl = image.attributes['src'] ?? '';
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            movieImageUrls.add(imageUrl);
          });
        }
      }

      // Genre checking based on dish ingredients
      final dishIngredients = widget.recipe['ingredients'];
      if (dishIngredients != null && dishIngredients is Iterable) {
        for (var ingredient in dishIngredients) {
          final ingredientText = ingredient['text'].toLowerCase();

          if (ingredientText.contains('sugar') ||
              ingredientText.contains('honey') ||
              ingredientText.contains('sweet')) {
            genres = 'romance';
          } else if (ingredientText.contains('chili') ||
              ingredientText.contains('pepper')) {
            genres = 'action';
          } else if (ingredientText.contains('spice') ||
              ingredientText.contains('turmeric')) {
            genres = 'adventure';
          } else if (ingredientText.contains('onion')) {
            genres = 'thriller';
          } else {
            genres = 'horror';
          }
        }
      }
    } else {
      // Handle the case when the request fails
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  String? extractTitle(String text) {
    // Split the text at each "Download" occurrence
    final parts = text.split("Download");

    // Check if there are at least two parts
    if (parts.length >= 2) {
      // Trim and get the second part, which contains the title
      final title = parts[1].trim();

      // Find the first occurrence of a year in parentheses
      final yearMatch = RegExp(r'\(\d{4}\)').firstMatch(title);

      if (yearMatch != null) {
        // Remove the text after the year
        final cleanedTitle = title.substring(0, yearMatch.start).trim();
        return cleanedTitle;
      } else {
        // If no year is found, return the original title
        return title;
      }
    } else {
      print("Invalid format: $text");
      return null;
    }
  }
  late String tle;
  @override
  void initState() {
    super.initState();
    tle = widget.recipe['label'];
  }



  @override
  Widget build(BuildContext context) {
    fetchData(genres);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .height * 0.34,
                          margin: EdgeInsets.only(
                            left: MediaQuery
                                .of(context)
                                .size
                                .width * 0.04,
                            top: tle.length>30?MediaQuery
                                .of(context)
                                .size
                                .height * 0.05:MediaQuery
                                .of(context)
                                .size
                                .height * 0.08,),
                          child: Text(
                            widget.recipe['label'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.025,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                            // height: 35,

                            // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.005,vertical: MediaQuery.of(context).size.height * 0.0001),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xFFFCCFF00),
                            ),
                            margin: EdgeInsets.only(
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.04,
                              right:MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.03 ,
                              top: tle.length>30?MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.05:MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.08,

                            ),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                )))
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.155, left: MediaQuery
                        .of(context)
                        .size
                        .width * 0.04),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),


                  if (widget.recipe['ingredients'] != null &&
                      widget.recipe['ingredients'] is Iterable)
                    for (var ingredient in widget.recipe['ingredients'])
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 7, horizontal: 13),
                        child: ListTile(
                          tileColor: Color(0xFFF262627),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17)),
                          title: Text('${ingredient['text']}',
                              style: TextStyle(color: Color(0xFFFF4F4EC))),
                        ),
                      ),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Recipe link:',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Display the recipe steps here
                  Container(
                    margin: EdgeInsets.only(right: 16,left: 16,top: 16,bottom: MediaQuery.of(context).size.height*0.1),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF262627),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      child: Text(
                        '${widget.recipe['url']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        launchUrlString(widget.recipe['url'],
                            mode: LaunchMode.inAppWebView);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),


              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.15,
                ),
                child: Center(
                  child: Container(

                    padding: EdgeInsets.all(MediaQuery
                        .of(context)
                        .size
                        .width * 0.014),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(420),),
                      border: Border.fromBorderSide(BorderSide(
                          strokeAlign: 1.2, color: Colors.grey, width: 5)),
                      color: Colors.black,


                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(400)),

                      child: Image.network(
                        widget.recipe['image'],
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.23,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.symmetric(vertical: 25),
                              child: CircleAvatar(


                                foregroundColor: Colors.grey,
                                child: Image.network(
                                    'https://cdn-icons-png.flaticon.com/128/11520/11520781.png'),
                                backgroundColor: Colors.grey,
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: MediaQuery.of(context).size.width*0.185,
          width: MediaQuery.of(context).size.width*0.185,
          child: FloatingActionButton(
            elevation: 6,


            backgroundColor: Colors.black,
            child: Icon(Icons.movie_filter_outlined,color: Colors.white,),
            shape: StadiumBorder(

              side: BorderSide(color: Colors.grey, width: 2.0),
            ),
            onPressed: (){
              showModalBottomSheet(


                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),),border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Column(
                      children: [
                        Text(
                          'Recommended Movies',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(

                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                color: Colors.white,

                                margin: EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(

                                  title: Text(movieTitles[index]),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(77),
                                    child: Image.network(
                                        movieImageUrls[index],  errorBuilder: (context, error, stackTrace) {

                                      return Container(
                                        // margin: EdgeInsets.symmetric(vertical: 25),
                                          child: Image.network('https://cdn-icons-png.flaticon.com/128/777/777242.png'));
                                    }),
                                  ), // Show movie image here
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

    );
  }
}
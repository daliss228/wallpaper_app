import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/src/categorie.dart';
import 'package:wallpaper_app/src/data/data.dart';
import 'package:wallpaper_app/src/image_view.dart';
import 'package:wallpaper_app/src/models/categories.dart';
import 'package:wallpaper_app/src/models/wallpaper_model.dart';
import 'package:wallpaper_app/src/search.dart';
import 'package:wallpaper_app/src/widgets/widgets.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController searchController = TextEditingController();
  List<CategorieModel> categories = new List();
  List<PhotosModel> photos = new List();
  String apiKEY = "563492ad6f917000010000019904bea780b440faab806345064fb1ca";

  getTrendingWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/curated?per_page=50&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });
      setState(() {});
    });
  }
  
  @override
  void initState() {
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
       body: SingleChildScrollView(
         child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Buscar Wallpapers",
                          hintStyle: TextStyle(fontFamily: 'OpenSansRegular'),
                          border: InputBorder.none
                        ),
                      )
                    ),
                    InkWell(
                      onTap: () {
                        if (searchController.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchView(search: searchController.text)
                            )
                          );
                        }
                      },
                      child: Container(child: Icon(Icons.search)
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 80.0,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal:25.0),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    // photos[i].src.portrait
                    return CategoriesTile(
                      imgUrls: categories[i].imgUrl,
                      categorie: categories[i].categorieName
                    );
                  }
                ),
              ),
              wallpapersList(wallpapers: photos, context: context),
              SizedBox(height: 50.0),
            ],
          ),
         ),
       )
    );
  }
}

class CategoriesTile extends StatelessWidget {

  final String imgUrls, categorie;
  CategoriesTile({@required this.imgUrls, @required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategorieScreen(
                categorie: categorie,
          ))
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        child: true
          ? Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imgUrls, height: 50, width: 100, fit: BoxFit.cover)
                  // kIsWeb
                  //   ? Image.network(imgUrls, height: 50, width: 100, fit: BoxFit.cover)
                  //   : CachedNetworkImage(imageUrl: imgUrls, height: 50, width: 100, fit: BoxFit.cover)
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      categorie,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'OpenSansRegular'),
                    )),
              ],
            )
          : Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => ImageView(imgPath: ))
                    // );
                  },
                  child: Hero(
                    tag: imgUrls,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(imgUrls, height: 50, width: 100, fit: BoxFit.cover)
                        // kIsWeb
                        // ? Image.network(imgUrls, height: 50, width: 100, fit: BoxFit.cover)
                        // : CachedNetworkImage(imageUrl: imgUrls, height: 50, width: 100, fit: BoxFit.cover,)
                      ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                    height: 50,
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      categorie ?? "Yo Yo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSansRegular'),
                    ))
              ],
            ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:wallpaper_app/src/image_view.dart';
import 'package:wallpaper_app/src/models/wallpaper_model.dart';


Widget brandName() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize : MainAxisSize.min,
      children: <Widget>[
        Text(
          "Wallpaper", style: TextStyle(color: Colors.black87, fontFamily: 'OpenSansBold'),
        ),
        Text(
          "Hub",
          style: TextStyle(color: Colors.blue, fontFamily: 'OpenSansBold'),
        )
      ],
    ),
  );
}

Widget wallpapersList({List<PhotosModel> wallpapers, context}){
  return Container(
    child: GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper){
        return GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImageView(
                    imgPath: wallpaper.src.portrait,
                  )
              ));
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(wallpaper.src.portrait, fit: BoxFit.cover,)),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
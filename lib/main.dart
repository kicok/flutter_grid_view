import 'package:flutter/material.dart';
import 'package:flutter_grid_view/image_detail.dart';
import 'package:flutter_grid_view/providers/pixabay_photos.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PixabayPhotos(),
      child: MaterialApp(
        title: 'GridView Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PixabayPhotoItem> photos = [];
  int _page = 1;
  bool _isFirst = true;

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero).then((_) async {
  //     final pixbayProvider = Provider.of<PixabayPhotos>(context, listen: false);
  //     await pixbayProvider.getPixabayPhotos(_page, 4);
  //     setState(() {
  //       photos = pixbayProvider.photos;
  //     });
  //   }).catchError((onError) {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('Error'),
  //             content: Text('Fail to fetch images from pixabay'),
  //             actions: [
  //               FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Ok'),
  //               )
  //             ],
  //           );
  //         });
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      final pixbayProvider = Provider.of<PixabayPhotos>(context);
      pixbayProvider.getPixabayPhotos(_page, 4).then((_) {
        photos = pixbayProvider.photos;
      });
    }
    _isFirst = false;
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView Demo'),
      ),
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ImageDetail(photos[index]);
                }));
              },
              child: GridTile(
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage(photos[index].webformatURL),
                  fit: BoxFit.cover,
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(photos[index].user),
                  subtitle: Text('views : ${photos[index].favorites}'),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //print('클릭');
          _page++;

          final pixabayProvider =
              Provider.of<PixabayPhotos>(context, listen: false);
          await pixabayProvider.getPixabayPhotos(_page, 4);
          setState(() {
            photos = pixabayProvider.photos;
          });
        },
        tooltip: 'Get More Images',
        child: Icon(Icons.add),
      ),
    );
  }
}

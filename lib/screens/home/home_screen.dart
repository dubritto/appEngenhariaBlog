import 'package:clube_da_obra/common/custom_drawer/custom_drawer.dart';
import 'package:clube_da_obra/models/Ad.dart';
import 'package:clube_da_obra/screens/home/widgets/blog_tile.dart';
import 'package:flutter/material.dart';
import 'package:clube_da_obra/screens/home/widgets/search_dialog.dart';
import 'package:provider/provider.dart';
import 'package:clube_da_obra/blocs/home_bloc.dart';
import 'package:clube_da_obra/screens/home/widgets/top_bar.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeBloc _homeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final HomeBloc homeBloc = Provider.of<HomeBloc>(context);
    if(homeBloc != _homeBloc)
      _homeBloc = homeBloc;
  }

  @override
  Widget build(BuildContext context) {
    _openSearch(String currentSearch) async {
      final String search = await showDialog(
        context: context,
        builder: (context) => SearchDialog(currentSearch: currentSearch),
      );
      if(search != null)
        _homeBloc.setSearch(search);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: StreamBuilder<String>(
          stream: _homeBloc.outSearch,
          initialData: '',
          builder: (context, snapshot) {
           if(snapshot.data.isEmpty)
             return Container();
           else
             return GestureDetector(
               onTap: () => _openSearch(snapshot.data),
               child: LayoutBuilder(
                 builder: (context, constrains){
                   return Container(
                     child: Text(snapshot.data),
                     width: constrains.biggest.width,
                   );
                 },
               ),
             );
          },
        ),
        actions: <Widget>[
          StreamBuilder<String>(
            stream: _homeBloc.outSearch,
            initialData: '',
            builder: (context, snapshot){
              if(snapshot.data.isEmpty)
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _openSearch("");
                  },
                );
              else
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _homeBloc.setSearch('');
                  },
                );
            },
          )
        ],
      ),
      drawer: CustomDrawer(),

      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            TopBar(),
            Expanded(
              child: StreamBuilder<List<Ad>>(
                stream: _homeBloc.outAd,
                builder: (context, snapshot){
                  if(snapshot.data == null)
                    return Container();
                  return ListView.separated(
                    itemBuilder: (context, index){
                      return BlogTile(snapshot.data[index]);
                    },
                    separatorBuilder: (context, index){
                      return Container();
                    },
                    itemCount: snapshot.data.length,

                  );
                },

              ),
            )
          ],
        ),
      ),
    );
  }
}

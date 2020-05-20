import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget{

  final int index;

  Home({ this.index });

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  bool like = false;

  

  void ChangeColor() {
    setState(() {
      like = !like;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        GestureDetector(
          child: Image.asset("images/image${widget.index}.png"),
          onDoubleTap: () { ChangeColor(); },
        ),
        SizedBox(height: 5),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("images/image${widget.index}.png"),
          ),
          title:Text(
            widget.index == 3 ? "マロンぬ??" : "マロンぬ${widget.index+1}",
            style: TextStyle(fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("tomokimiwa * 5.1 M Views * 1 years ago"),
          trailing: RaisedButton.icon(
            
            icon: Icon(
              Icons.favorite,
              color: like ? Colors.red : Colors.grey,
            ),
            label: Text("Like"),
            onPressed: (){ ChangeColor(); },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
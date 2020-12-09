import 'package:flutter/material.dart';
import 'package:socgo/globals.dart';

class InfoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              'https://cdn.discordapp.com/attachments/491512399141142529/772954314809278494/pexels-rfstudio-4177486.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 170,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Align(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Enjoy the holidays with your ',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                              color: Color(0x77000000),
                              blurRadius: 3,
                              offset: Offset(0.0, 2.0)),
                        ])),
                TextSpan(
                    text: 'friends',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                              color: Color(0x77000000),
                              blurRadius: 3,
                              offset: Offset(0.0, 2.0)),
                        ])),
                TextSpan(
                    text: '.',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                              color: Color(0x77000000),
                              blurRadius: 3,
                              offset: Offset(0.0, 2.0)),
                        ]))
              ])),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Align(
            child: Icon(
              Icons.people,
              color: Colors.white,
            ),
            alignment: Alignment.topRight,
          ),
        )
      ],
    );
  }
}


import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/image_assets.dart';

class DashboardCard extends StatelessWidget
{
  final String title,imageURI,countValue;
  final Color cardBg;
  Function onCardTap;
  DashboardCard(this.title,this.imageURI,this.countValue,this.cardBg,this.onCardTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onCardTap();
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4),
        color: cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child:  Container(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [

              // SizedBox(width: 15),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 25),
                        Text(
                          countValue,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Image.asset(imageURI,width: 30,height: 30),
                        ),
                        //  SizedBox(width: 5)

                      ],
                    )


                  ],
                ),
              ),








            ],
          ),

        ),
      ),
    );
  }

}
class ProfileCard extends StatelessWidget
{
  final String title,imageURI;
  final Color cardBg;
  final Function onTap;
  ProfileCard(this.title,this.imageURI,this.cardBg,this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child:Card(
        elevation: 4,
        shadowColor: cardBg,
        margin: EdgeInsets.zero,
        color: cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child:  Container(
          padding: EdgeInsets.symmetric(vertical: 11,horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // SizedBox(width: 15),
              Image.asset(imageURI,width: 20,height: 20),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),



              SizedBox(width: 5)





            ],
          ),

        ),
      )
    );
  }

}

class GroupCard extends StatelessWidget
{
  final String title;
  final Icon iconURI;
  final Color cardBg;
  final Function onTap;
  GroupCard(this.title,this.iconURI,this.cardBg,this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          onTap();
        },
        child:Card(
          elevation: 4,
          shadowColor: cardBg,
          margin: EdgeInsets.zero,
          color: cardBg,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child:  Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // SizedBox(width: 15),
                iconURI,
                SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),



                SizedBox(width: 5)






              ],
            ),

          ),
        )
    );
  }

}



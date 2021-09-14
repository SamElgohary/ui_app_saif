import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_resources.dart';

class AdvanceCustomAlert extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child:   Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                       borderSide: new BorderSide(color: Colors.grey,),
                       borderRadius: BorderRadius.circular(55) ),
                        hintText: 'ادخل كلمة المرور الجديدة',
                        labelText: 'كلمة المرور الجديده',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        prefixText: ' ',
                        suffixStyle: const TextStyle(color: Colors.green)),
                        onChanged: (val){

                        },
                      ),

                      SizedBox(height: 16,),

                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey,),
                                borderRadius: BorderRadius.circular(55) ),
                            hintText: 'ادخل كلمة المرور الجديدة',
                            labelText: 'كلمة المرور الجديده',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            prefixText: ' ',
                            suffixStyle: const TextStyle(color: Colors.green)),
                        onChanged: (val){

                        },
                      ),

                      SizedBox(height: 16,),

                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color:  ColorResources.Orange,
                              width: 1.0,
                            ),
                          ),
                          child:Padding(
                            padding: const EdgeInsets.symmetric(horizontal:32.0,vertical: 8),
                            child: Text(
                                'تم',
                                style: GoogleFonts.tajawal(fontSize: 18,color: ColorResources.Orange)
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -60,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[700],
                    radius: 60,
                    child: Icon(Icons.lock, color: Colors.white, size: 50,),
                  )
              ),
            ],
          )
      ),
    )
     ;
  }
}
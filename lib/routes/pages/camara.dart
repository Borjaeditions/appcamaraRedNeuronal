import 'package:camara_red_neuronal/routes/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class Camara extends StatefulWidget {
  const Camara({key});

  @override
  State<Camara> createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {

  XFile? image;
  final picker = ImagePicker();

  final description = TextEditingController();
  final title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar imagen"),
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: (){

                  opciones(context);
                  
                },
                child: Text("Seleccione imagén"),
              ),
              CustomImput(icon: Icons.text_format_outlined, placeholder: 'Titulo', textEditingController: title,),
              CustomImput(icon: Icons.description, placeholder: 'Descripción', textEditingController: description,),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){

                  uploadImage(title.text, description.text);
                  
                },
                child: Text("Subir imagén"),
              ),
              SizedBox(height: 10,),
              SizedBox(height: 30,),
              image == null ? Center(): Image.file(File(image?.path ?? ''))
            ],
          ),
          )
        ],
      ),
    );
  }

  void opciones(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            //controller: controller,
            child: Column(
              children: [
                InkWell(
                  onTap: (){

                    selImage(1);

                  },
                  child: Container(padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey))   
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text("Tomar una foto", style: TextStyle(fontSize: 16),)),
                      Icon(Icons.camera_alt, color: Colors.blue)                      
                    ],
                  ),
                  ),
                ),
                InkWell(
                  onTap: (){

                    selImage(2);

                  },
                  child: Container(padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(child: Text("Seleccionar de galeria", style: TextStyle(fontSize: 16),)),
                      Icon(Icons.image, color: Colors.blue)                      
                    ],
                  ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.red),
                  child: Row(
                    children: [
                      Expanded(child: Text("Cancelar", style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,)),                      
                    ],
                  ),
                  ),
                )
              ],              
            ),
          )
        );
      }
    );

  }

  Future selImage(int option) async {

    var pickedFile;
    switch (option) {
    case 1:
      pickedFile = await picker.pickImage(source: ImageSource.camera);
      break;
    case 2:
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      break;
    }
    if (pickedFile != null) {
      setState(() {
        //image = pickedFile;
        resize(pickedFile);
      });
    }
    Navigator.of(context).pop();


  }

  void resize(pickedFile) async {

    File? cut = await ImageCropper().cropImage(sourcePath: pickedFile.path, 
    aspectRatio: CropAspectRatio(
      ratioX: 1.0,
      ratioY: 1.0
      ) 
    );
    if(cut != null){

      setState(() {
        image = XFile(cut.path);
      });

    }
  }

  Dio dio = new Dio();

  Future<void> uploadImage(String title, String description) async {

    try {

      String filename = image!.path.split('/').last;

      FormData formData = new FormData.fromMap({
        'title': title,
        'description': description,
        'image': await MultipartFile.fromFile(image!.path, filename: filename)

      });
      //! Cambiar dirección en presentación
      await dio.post('http://192.168.137.1:3000/upload',
        data: formData
      ).then((value) => print(value));
      
    } catch (e) {

      print(e.toString());

    }

  }
}
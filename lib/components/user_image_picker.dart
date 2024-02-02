import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // Vai receber a função do componente pai (authForm -> _handleImagePick)
  // vai basicamente deixar o formData.image no File que pegar por parametro
  final void Function(File image) onImagePick;
  const UserImagePicker({super.key, required this.onImagePick});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  // Executar de fato a biblioteca ImagePicker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      // Diminuir a resolução pra não ocupar todo firebase
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      // Vai chamar no authForm o _handleImagePick onde vai basicamente
      // deixar o formData.image igual o _image que foi setado acima
      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton.icon(
          icon: Icon(
            Icons.image,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: const Text('Adicionar Imagem'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}

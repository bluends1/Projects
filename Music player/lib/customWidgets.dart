// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/providers.dart';
import 'package:provider/provider.dart';

class TrackWidget extends StatelessWidget {
  TrackWidget(
      {this.image = "",
      required this.trackName,
      required this.trackArtist,
      this.trackSource,
      super.key});

  final String image;
  final String trackName;
  final String trackArtist;
  final String? trackSource;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.abc), //image
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(trackName,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            Text(
                trackSource == null
                    ? "$trackArtist - $trackSource"
                    : trackArtist,
                style: TextStyle(color: Theme.of(context).colorScheme.primary))
          ],
        )
      ],
    );
  }
}

class PlaylistWidget extends StatefulWidget {
  PlaylistWidget({required this.onClick, required this.playlist, super.key});

  Function() onClick;
  Playlist playlist;

  @override
  State<PlaylistWidget> createState() => _GridPlaylistWidgetState();
}

class _GridPlaylistWidgetState extends State<PlaylistWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Stack(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.deepPurple[900],
              child: Center(
                  child: widget.playlist.image == null
                      ? ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              widget.playlist.defaultColor == null
                                  ? Colors.white
                                  : widget.playlist.defaultColor!,
                              BlendMode.srcIn),
                          child: Image.asset('assets/images/playlist.png'))
                      : Image.memory(widget.playlist.image!)),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: OutlinedText(
              text: widget.playlist.name,
              outlineColor: Colors.black,
              textColor: Theme.of(context).colorScheme.primary,
              outlineWidth: 5,
            ),
          )
        ],
      ),
    );
  }
}

class EditorWidget extends StatefulWidget {
  EditorWidget({required this.formCallBack, super.key});

  Map<String, dynamic> formData = {};
  bool formReady = false;
  Function(Map<String, dynamic> formData) formCallBack;

  @override
  State<EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    if (context.read<BaseProperties>().activeTab == 0) {
      widgetList.add(imageSelector(context.read<BaseProperties>().activeTab));
      widgetList.add(colorPicker(context.read<BaseProperties>().activeTab));
      widgetList.addAll(textInput(context.read<BaseProperties>().activeTab));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Create Playlist",
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ...widgetList,
        Expanded(child: Container()),
        Row(children: [
          Expanded(
              child: TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  })),
          Expanded(
              child: TextButton(
                  child: Text("Create",
                      style: TextStyle(
                          color: nameController.text.isEmpty
                              ? Colors.grey[600]
                              : Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    if (context.read<BaseProperties>().activeTab == 0) {
                      //check form ready
                      if (nameController.text.isNotEmpty) {
                        widget.formData["name"] = nameController.text;
                        widget.formReady = true;
                      }
                    }

                    if (widget.formReady) {
                      widget.formCallBack(widget.formData);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }))
        ])
      ]),
    );
  }

  Widget imageSelector(editMode) {
    if (editMode == 0) {
      if (widget.formData["ImageBytes"] == null) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: GestureDetector(
                    onTap: () {},
                    child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            widget.formData["IconColor"] == null
                                ? Colors.white
                                : widget.formData["IconColor"],
                            BlendMode.srcIn),
                        child: Image.asset('assets/images/playlist.png'))),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    style: ButtonStyle(),
                    onPressed: selectCropImage,
                    icon: Icon(Icons.edit),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: GestureDetector(
                    onTap: () {},
                    child: Image.memory(widget.formData["ImageBytes"]!)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          widget.formData["ImageBytes"] = null;
                          setState(() {});
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        style: ButtonStyle(),
                        onPressed: selectCropImage,
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget colorPicker(editMode) {
    if (editMode == 0) {
      if (widget.formData["ImageBytes"] == null) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: pickColor,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Positioned(
                      left: 10,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        color: Theme.of(context).colorScheme.background,
                        child: Text(
                          'Icon Color',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: double.infinity,
                      height: 46,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: widget.formData["IconColor"] == null
                            ? Colors.white
                            : widget.formData["IconColor"],
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  List<Widget> textInput(editMode) {
    List<Widget> textInputs = [];
    if (editMode == 0) {
      textInputs.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextField(
            controller: nameController,
            onChanged: (value) {
              setState(() {});
            },
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
                labelText: "Playlist name",
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary)))),
      ));
    } else {
      return textInputs;
    }
    return textInputs;
  }

  void selectCropImage() async {
    final ImagePicker picker = ImagePicker();
    //get image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      //crop
      CroppedFile? croppedImage =
          await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
        AndroidUiSettings(
            backgroundColor: Colors.black,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            initAspectRatio: CropAspectRatioPreset.square,
            toolbarTitle: "Crop Image Cover")
      ]);
      if (croppedImage != null) {
        widget.formData["ImageBytes"] = await croppedImage.readAsBytes();
        setState(() {});
      }
    }
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color currentColor = widget.formData["IconColor"] == null
            ? Colors.white
            : widget.formData["IconColor"];
        return AlertDialog(
          title: Text('Pick a color',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: SingleChildScrollView(
            child: ColorPicker(
              hexInputBar: false,
              enableAlpha: false,
              showLabel: false,
              labelTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              pickerColor: currentColor,
              onColorChanged: (color) {
                currentColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                widget.formData["IconColor"] = currentColor;
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class OutlinedText extends StatelessWidget {
  OutlinedText(
      {required this.text,
      this.textColor = Colors.black,
      this.outlineColor = Colors.white,
      this.outlineWidth = 2,
      this.fontSize = 16,
      super.key});

  String text;
  Color textColor;
  Color outlineColor;
  double fontSize;
  double outlineWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

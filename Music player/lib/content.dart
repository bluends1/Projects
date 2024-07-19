import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:music_player/customWidgets.dart';
import 'package:music_player/providers.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class PlaylistTab extends StatefulWidget {
  const PlaylistTab({required this.navKey, super.key});

  final GlobalKey<NavigatorState> navKey;

  @override
  State<PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<PlaylistTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Row(children: [
            Expanded(child: Container()),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit,
                    color: Theme.of(context).colorScheme.primary)),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary))
          ]),
          Expanded(
            child: ReorderableGridView.count(
              onReorder: (oldIndex, newIndex) {},
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              footer: [
                GestureDetector(
                  onTap: () {
                    widget.navKey.currentState!.push(MaterialPageRoute(
                        builder: (_) => EditorWidget(
                              formCallBack: (formData) {
                                //create playlist
                                context.read<BaseProperties>().newPlaylist(
                                    image: formData["ImageBytes"],
                                    defaultColor: formData["IconColor"],
                                    name: formData["name"]);
                              },
                            )));
                  },
                  child: Card(
                    color: Colors.deepPurple[900],
                    elevation: 0,
                    child: Center(
                        child: Icon(Icons.add,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                )
              ],
              dragWidgetBuilder: (index, child) {
                return ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(15),
                    child: child);
              },
              children: buildPlaylistDisplay(
                  context.watch<BaseProperties>().playLists),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildPlaylistDisplay(List<Playlist> playlists) {
    List<Widget> playListItems = [];
    playlists.forEachIndexed((int index, Playlist p) {
      playListItems.add(PlaylistWidget(
        key: ValueKey(index),
        playlist: p,
        onClick: () {},
      ));
    });
    return playListItems;
  }
}

class TrackTab extends StatefulWidget {
  const TrackTab({required this.navKey, super.key});

  final GlobalKey<NavigatorState> navKey;

  @override
  State<TrackTab> createState() => _TrackTabState();
}

class _TrackTabState extends State<TrackTab> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

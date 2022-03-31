import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:live_stream_app/modules/dashboard/model/approve_request.dart';
import 'package:live_stream_app/modules/dashboard/model/stream_response.dart';
import 'package:live_stream_app/modules/sign_in/bloc/sign_in_bloc.dart';
import 'package:live_stream_app/service/notification_service.dart';
import 'package:live_stream_app/widgets/responsive_ui.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  late int _tempIndex;
  List<StreamResponse> _streams = [];
  List<StreamResponse> _foundedStreams = [];
  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    _fetchData();
    NotificationService().subscribeToTopic();
    super.initState();
  }

  void _fetchData() async {
    if (roles.contains('ROLE_ADMIN')) {
      BlocProvider.of<DashboardBloc>(context).add(FetchAllStream());
    } else {
      BlocProvider.of<DashboardBloc>(context)
          .add(FetchStreamByUser(userID: userID));
    }
  }

  _onSearch(String search) {
    setState(() {
      _foundedStreams = _streams
          .where((stream) => stream.title!.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is ApproveStreamLoadingState) {
              const CircularProgressIndicator();
            } else if (state is ApproveStreamErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Approve stream failure')));
            } else if (state is ApproveStreamSuccessState) {
              _foundedStreams[_tempIndex].active =
                  !_foundedStreams[_tempIndex].active!;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Approve stream success')));
              Navigator.of(context).pushNamed(dashboard);
            }
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignOutLoadingState) {
              const CircularProgressIndicator();
            } else if (state is SignOutErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Sign out failure')));
            } else if (state is SignOutSuccessState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Sign out success')));
              NotificationService().unSubscribeToTopic();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 10,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey.shade900,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<SignInBloc>(context)
                        .add(SignOutSubmitted(userID: userID));
                  },
                  child: const Icon(
                    Icons.logout,
                  ),
                ),
              ),
            ],
            title: SizedBox(
              height: 38,
              child: TextField(
                onChanged: (value) => _onSearch(value),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none),
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
                  hintText: "Search streams",
                ),
              ),
            ),
          ),
          body: Material(
            child: Container(
              height: _height,
              width: _width,
              color: Colors.grey.shade900,
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                children: <Widget>[
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state is FetchAllStreamSuccessState) {
                        if (state.streams.isNotEmpty) {
                          _streams = [];
                          _foundedStreams = [];
                          _streams.addAll(state.streams);
                          _foundedStreams = _streams;
                        }
                      }
                      if (state is FetchStreamByUserSuccessState) {
                        if (state.streams.isNotEmpty) {
                          _streams = [];
                          _foundedStreams = [];
                          _streams.addAll(state.streams);
                          _foundedStreams = _streams;
                        }
                      }
                      if (_foundedStreams.isEmpty) {
                        return Container();
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Slidable(
                                    enabled: roles.contains('ROLE_ADMIN'),
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (BuildContext context) {
                                            setState(() {
                                              ApproveRequest approveRequest =
                                                  ApproveRequest(
                                                active: true,
                                                streamID:
                                                    _foundedStreams[index].id,
                                                userID: _foundedStreams[index]
                                                    .user
                                                    ?.id,
                                              );
                                              BlocProvider.of<DashboardBloc>(
                                                      context)
                                                  .add(ApproveStream(
                                                      approveRequest:
                                                          approveRequest));
                                              _tempIndex = index;
                                            });
                                          },
                                          backgroundColor:
                                              const Color(0xFF7BC043),
                                          foregroundColor: Colors.white,
                                          icon: Icons.voice_chat,
                                          label: 'Activate',
                                        ),
                                        SlidableAction(
                                          onPressed: (BuildContext context) {
                                            setState(() {
                                              ApproveRequest approveRequest =
                                                  ApproveRequest(
                                                active: false,
                                                streamID:
                                                    _foundedStreams[index].id,
                                                userID: _foundedStreams[index]
                                                    .user
                                                    ?.id,
                                              );
                                              BlocProvider.of<DashboardBloc>(
                                                      context)
                                                  .add(ApproveStream(
                                                      approveRequest:
                                                          approveRequest));
                                              _tempIndex = index;
                                            });
                                          },
                                          backgroundColor:
                                              const Color(0xFFD4171F),
                                          foregroundColor: Colors.white,
                                          icon: Icons.voice_chat_outlined,
                                          label: 'Deactivate',
                                        ),
                                      ],
                                    ),
                                    child: _streamItem(
                                        streamResponse: _foundedStreams[index]),
                                  ),
                                );
                              },
                              itemCount: _foundedStreams.length,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[700],
            child: const Icon(
              Icons.add_box_outlined,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(stream);
            },
          ),
        ),
      ),
    );
  }

  _streamItem({required StreamResponse streamResponse}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                      "$baseUrl/file/files/${streamResponse.user?.file}"),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: _width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Owner: ${(streamResponse.user?.username ?? "").toUpperCase()}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Birthday: ${streamResponse.user?.birthday ?? ""}",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Title: ${streamResponse.title ?? ""}",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "Content: ${streamResponse.content ?? ""}",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedContainer(
              height: _width / 15,
              width: _width / 8,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: streamResponse.active!
                      ? Colors.blue[700]
                      : const Color(0x00ffffff),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: streamResponse.active!
                        ? Colors.transparent
                        : Colors.grey.shade700,
                  )),
              child: Center(
                  child: Text(
                      streamResponse.active! ? 'On' : 'Off',
                      style: TextStyle(
                          color: streamResponse.active!
                              ? Colors.white
                              : Colors.white))))
        ],
      ),
    );
  }
}

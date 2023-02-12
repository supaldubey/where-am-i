import 'package:flutter/material.dart';
import 'package:where_am_i/location/fetch.dart';

class ErrorView extends StatefulWidget {
  final dynamic error;

  const ErrorView(this.error, {super.key});

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> with TickerProviderStateMixin {
  final int _duration = 1500;
  final int _buffer = 500;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration + _buffer));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.decelerate)));

    _animation.addListener(() => setState(() {}));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var error = widget.error;

    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff2f9fe),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * (1 - _animation.value),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.location_on),
                              color: Colors.red,
                              tooltip: 'Exit',
                              onPressed: () {},
                            ),
                            const Text(
                              "Where Am I",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 25, left: 25, right: 25, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.03),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 25, right: 20, left: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://images.unsplash.com/photo-1599930113854-d6d7fd521f10?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80"),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: (size.width - 40) * 0.8,
                            child: Column(
                              children: const [
                                Text(
                                  "Lookup Failed",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              left: 25,
                              right: 25,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.03),
                                    spreadRadius: 10,
                                    blurRadius: 3,
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20, left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                        child: Icon(
                                            Icons.phonelink_erase_rounded)),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: (size.width - 90) * 0.7,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Error Fetching location ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              error.toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

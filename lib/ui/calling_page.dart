import 'package:flutter/material.dart';

class CallingPage extends StatefulWidget {
  final String name;

  const CallingPage({required this.name, super.key});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  bool isMuted = false;
  bool isOnHold = false;

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
  }

  void _toggleHold() {
    setState(() {
      isOnHold = !isOnHold;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Text(
            "Calling ${widget.name}...",
            style: const TextStyle(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _toggleMute,
                  ),
                  const SizedBox(height: 8),
                  Text("Mute", style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isOnHold ? Icons.pause_circle : Icons.pause,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _toggleHold,
                  ),
                  const SizedBox(height: 8),
                  Text("Hold", style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 60),
          FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.red,
            child: const Icon(Icons.call_end),
          ),
        ],
      ),
    );
  }
}

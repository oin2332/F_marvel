import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Event1 extends StatefulWidget {
  const Event1({Key? key}) : super(key: key);

  @override
  State<Event1> createState() => _Event1State();
}

class _Event1State extends State<Event1> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    redirectToPage();
  }

  Future<void> redirectToPage() async {
    const url = 'https://www.bluer.co.kr/magazine/303';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Redirecting...'),
      ),
    );
  }
}

class Event2 extends StatefulWidget {
  const Event2({Key? key}) : super(key: key);

  @override
  State<Event2> createState() => _Event2State();
}

class _Event2State extends State<Event2> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    redirectToPage();
  }

  Future<void> redirectToPage() async {
    const url = 'https://www.bluer.co.kr/magazine/346';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('바부...'),
      ),
    );
  }
}
class Event3 extends StatefulWidget {
  const Event3({Key? key}) : super(key: key);

  @override
  State<Event3> createState() => _Event3State();
}

class _Event3State extends State<Event3> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    redirectToPage();
  }

  Future<void> redirectToPage() async {
    const url = 'https://magazine.hankyung.com/money/article/202101214003c';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('말미잘...'),
      ),
    );
  }
}
class Event4 extends StatefulWidget {
  const Event4({Key? key}) : super(key: key);

  @override
  State<Event4> createState() => _Event4State();
}

class _Event4State extends State<Event4> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    redirectToPage();
  }

  Future<void> redirectToPage() async {
    const url = 'https://www.story-w.co.kr/story-w/1426/2023-wine-referral';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('해삼...'),
      ),
    );
  }
}
class Event5 extends StatefulWidget {
  const Event5({Key? key}) : super(key: key);

  @override
  State<Event5> createState() => _Event5State();
}

class _Event5State extends State<Event5> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    redirectToPage();
  }

  Future<void> redirectToPage() async {
    const url = 'https://the-edit.co.kr/50593';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('멍청이...'),
      ),
    );
  }
}
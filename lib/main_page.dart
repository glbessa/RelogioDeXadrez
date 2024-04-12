import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

// permite alteracao dinamica da estrutura do arquivo
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  Color timer1Color = Colors.green;
  Color timer2Color = Colors.green;
  Duration defaultDuration = new Duration(minutes: 5, seconds: 0);
  Duration timer1Duration = new Duration(minutes: 5, seconds: 0);
  Duration timer2Duration = new Duration(minutes: 5, seconds: 0);
  Timer? timer;
  bool timer1Activated = false;
  bool timer2Activated = false;
  late int minutes;
  late int seconds;
  late int milliseconds;

  @override
  Widget build(BuildContext context) {
    double realHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * 0.05;

    return Column(
      children: [
        SizedBox(
          height:MediaQuery.of(context).size.height * 0.05
        ),
        //https://www.fluttercampus.com/guide/204/how-to-rotate-widget-in-flutter/
        Transform.rotate(
          angle: math.pi,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: realHeight * 0.45,
            child: ElevatedButton(onPressed: changeToTimer2, child: Text(format(timer1Duration), style: TextStyle(fontSize: 50, color:Colors.black)), style: ElevatedButton.styleFrom(backgroundColor: timer1Color))
          )
        ),
        SizedBox(
          height: realHeight * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              SizedBox(
                height: realHeight * 0.1,
                width: MediaQuery.of(context).size.width * 0.35,
                child: TextButton(child: Text('Reiniciar', style: TextStyle(color: Colors.black)), onPressed: restart, style: TextButton.styleFrom(backgroundColor: Colors.amberAccent, shape: RoundedRectangleBorder()))
              ),
              SizedBox(
                height:realHeight * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextButton(child: Text(timer != null ? (timer!.isActive ? "Pausar" : "Despausar") : "Pausar", style: TextStyle(color: Colors.black)), onPressed: pauseResumeTimer, style: TextButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder()))
              ),
              SizedBox(
                height: realHeight * 0.1,
                width: MediaQuery.of(context).size.width * 0.35,
                child: TextButton(child: Text('Mudar tempo', style: TextStyle(color: Colors.black)), onPressed: () => this.showCustomDialog(context), style: TextButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder()))
              )
            ]
            )
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: realHeight * 0.45,
          child: ElevatedButton(onPressed: changeToTimer1, child: Text(format(timer2Duration), style: TextStyle(fontSize: 50, color:Colors.black)), style: ElevatedButton.styleFrom(backgroundColor: timer2Color))
        ),
      ]
    );
  }

  changeToTimer1() {
    setState(() {
      timer2Color = Colors.white;
      timer1Color = Colors.green;
      timer == null ? null : timer!.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() { 
          timer1Duration -= const Duration(milliseconds: 100);
        });
      });
      timer1Activated = true;
      timer2Activated = false;
    });
  }

  changeToTimer2() {
    setState(() {
      timer1Color = Colors.white;
      timer2Color = Colors.green;
      timer == null ? null : timer!.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() { 
          timer2Duration -= const Duration(milliseconds: 100);
        });
      });
      timer1Activated = false;
      timer2Activated = true;
    });
  }

  restart() {
    setState(() {
      timer != null ? (timer!.isActive ? timer!.cancel() : null) : null;
      timer = null;
      timer1Color = Colors.green;
      timer2Color = Colors.green;
      timer1Activated = false;
      timer2Activated = false;
      timer1Duration = defaultDuration;
      timer2Duration = defaultDuration;
    });
  }

  pauseResumeTimer()
  {
    setState(() {
      if (timer != null) {
        if (timer!.isActive) {
          timer!.cancel();
        }
        else {
          if (timer1Activated) {
            timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
              setState(() { 
                timer1Duration -= const Duration(milliseconds: 100);
              });
            });
          }
          else {
            timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
              setState(() { 
                timer2Duration -= const Duration(milliseconds: 100);
              });
            });
          }
        }
      }
    });
  }

  changeDefaultDuration(int minutes, int seconds, int milliseconds) {
    defaultDuration = Duration(minutes: minutes, seconds: seconds, microseconds: milliseconds);
  }

  void showCustomDialog(BuildContext context, ) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Column(
          children: [
            const Text('Mudar tempo'),
            Row(
              children: [
                TextField(onSubmitted: (value) { minutes = int.parse(value); }),
                TextField(onSubmitted: (value) { seconds = int.parse(value); }),
                TextField(onSubmitted: (value) { milliseconds = int.parse(value); })
              ]
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () { Navigator.pop(context);changeDefaultDuration(minutes, seconds, milliseconds); }, child: Text('Ok')),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))
              ]
            )
          ]
        )
      );
    }
  );

  format(Duration d) => d.toString().substring(2,9);

  /*@override
  Widget build(BuildContext context) {
    // pode ser Material tambem
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      // containers == single-render
      body: Container(
        height: 150,
        width: 150,
        color: Colors.black,
        child: Align(
          alignment: Alignment.center,
          child: Container (
            height: 50,
            width: 50,
            color: Colors.green,
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementarContador, 
        child: Icon(Icons.add)
      )
    );
  }
  */

  /*
  @override
  Widget build(BuildContext context) {
    // pode ser Material tambem
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        // gesturedetector serve para detectar eventos
        child: GestureDetector(
          child: Text('Contador: $counter'),
          onTap: incrementarContador,
          onLongPress: zerarContador,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementarContador, 
        child: Icon(Icons.add)
      )
    );
  }
  */
}
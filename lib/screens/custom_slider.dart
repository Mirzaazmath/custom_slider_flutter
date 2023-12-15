import 'package:flutter/material.dart';
class CustomSliderWidget extends StatefulWidget {
  final double height;
  final double width;
  const CustomSliderWidget({super.key,this.height=300,this.width=90});

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  /// Global Key to Recognize the widget
  final GlobalKey _key=LabeledGlobalKey("main_slider");

/// initial values
  bool _showPercent=false;
  double _dragPosition=0;
  double _dragPercent=0.5;
/// When Drag Starts
  void _onDragStart(DragStartDetails details){
    /// check the currentContext
    if(_key.currentContext==null)return;
    /// Initializing the renderBox using _key
    final renderBox=_key.currentContext!.findRenderObject() as RenderBox;
    /// Getting position and converting the into Offset
    final offSet=renderBox.globalToLocal(details.globalPosition);
    /// Calling the _onDrag to Update values and state
    _onDrag(offSet);
  }
  /// When Drag Update
  void _onDragUpdate(DragUpdateDetails details){
    /// check the currentContext
    if(_key.currentContext==null)return;
    /// Initializing the renderBox using _key
    final renderBox=_key.currentContext!.findRenderObject() as RenderBox;
    /// Getting position and converting the into Offset
    final offSet=renderBox.globalToLocal(details.globalPosition);
    /// Calling the _onDrag to Update values and state
    _onDrag(offSet);
  }
  /// When Drag End
  void _onDraEnd( DragEndDetails details){
    /// Setting _showPercent to false to hide the top Percentage
    setState(() {
      _showPercent=false;
    });
  }
/// ONDrag Method
  void _onDrag(Offset offset){
    /// Creating the tempDragPosition variable and assgin value as 0;
    double tempDragPosition=0;
    /// Checking the drag Height is less than 0
    if(offset.dy<=0){
      tempDragPosition=0;
      /// Checking the drag Height is greater than actual container height
    }else if(offset.dy>=widget.height){
      tempDragPosition=widget.height;
/// else setting the tempDragPosition offset.dy (means drag height)
    }else{
      tempDragPosition=offset.dy;
    }
    /// Updating the value
    setState(() {

      _dragPosition=tempDragPosition;
      _dragPercent=_dragPosition/widget.height;
      if(!_showPercent)_showPercent=true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //// Percentage Line ///////
        Container(
          height: widget.height,
          margin:const  EdgeInsets.fromLTRB(0, 20, 8,4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(11, (index) => Text("${100-(index*10)}",style: const TextStyle(color: Colors.white),))
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //// Percent indicator
            AnimatedOpacity(
                opacity: _showPercent?1:0, duration: const Duration(milliseconds: 100),
              child: Text("${(_dragPercent*100).floor()}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

            ),
          const   SizedBox(height: 8,),
            /////// Slider with Border /////
            Container(
             
              decoration: BoxDecoration(
                border: Border.all(
                    width: 8,
                    color: Colors.white),
                borderRadius: BorderRadius.circular(16)
              ),
              child: GestureDetector(
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDraEnd,

                child: RotatedBox(
                  quarterTurns: 2,
                  child: Container(
                    key: _key,
                    height: widget.height,
                    width: widget.width,
                    child: AbsorbPointer(

                      child: ClipPath(
                        clipper: PercentagePainter(percetage: _dragPercent),
                        child: Container(
                          height: widget.height,
                            width: widget.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient:const  LinearGradient(
                              begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Color(0xFFDEAC6A),
                              Color(0xFFFA2323)])
                          ),
                        ),

                      ),
                    ),
                  ),

                ),
              ),

            )
          ],

        )
      ],
    );
  }
}
class PercentagePainter extends CustomClipper<Path>{

  final double percetage;
  PercentagePainter({ required this.percetage});
  @override
  Path getClip(Size size) {

    final path =Path();
    path.moveTo(0, size.height*percetage);
    path.lineTo(0,0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height*percetage);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}
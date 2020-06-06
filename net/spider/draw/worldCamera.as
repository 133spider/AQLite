package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.filters.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.avatar.*;
    import net.spider.handlers.*;
    import fl.events.*;
    import fl.data.*;

    public class worldCamera extends MovieClip {

        public function worldCamera(){
            this.btnExit.addEventListener(MouseEvent.CLICK, onExit, false, 0, true);
            
            this.btnZoomIn.addEventListener(MouseEvent.CLICK, onZoomIn, false, 0, true);
            this.btnZoomOut.addEventListener(MouseEvent.CLICK, onZoomOut, false, 0, true);
            
            this.btnUp.addEventListener(MouseEvent.CLICK, onUp, false, 0, true);
            this.btnDown.addEventListener(MouseEvent.CLICK, onDown, false, 0, true);
            this.btnLeft.addEventListener(MouseEvent.CLICK, onLeft, false, 0, true);
            this.btnRight.addEventListener(MouseEvent.CLICK, onRight, false, 0, true);
            this.btnReset.addEventListener(MouseEvent.CLICK, onReset, false, 0, true);

            main.Game.ui.visible = false;

            main.Game.world.mouseEnabled = main.Game.world.mouseChildren = false;
            main._stage.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            main._stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseDrag, false, 0, true);

            main._stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
        }

        public function onKey(e:KeyboardEvent):void{
            if(String.fromCharCode(e.charCode) == "h")
			{
                for(var i:Number = 0; i < this.numChildren; i++){
                    this.getChildAt(i).visible = !this.getChildAt(i).visible;
                }
            }
        }

        public function onDrag(e:MouseEvent):void{
            main.Game.startDrag();
        }

        public function onReleaseDrag(e:MouseEvent):void{
            main.Game.stopDrag();
        }

        public function onExit(e:MouseEvent):void{
            main.Game.removeEventListener(KeyboardEvent.KEY_UP, onKey);
            main._stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
            main._stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseDrag);

            main.Game.x = main.Game.y = 0;
            main.Game.scaleX = main.Game.scaleY = 1;
            main.Game.ui.visible = true;
            main.Game.world.mouseEnabled = main.Game.world.mouseChildren = true;
            optionHandler.worldCameraMC = null;
            this.parent.removeChild(this);
        }

        public function onZoomIn(e:MouseEvent):void{
            main.Game.scaleX = main.Game.scaleY = (main.Game.scaleX += .5);
            main.Game.x -= 220;
            main.Game.y -= 150;
        }

        public function onZoomOut(e:MouseEvent):void{
            main.Game.scaleX = main.Game.scaleY = (main.Game.scaleX -= .5);
            main.Game.x += 220;
            main.Game.y += 150;
        }

        public function onReset(e:MouseEvent):void{
            main.Game.x = main.Game.y = 0;
            main.Game.scaleX = main.Game.scaleY = 1;
        }

        public function onUp(e:MouseEvent):void{
            main.Game.y += 10;
        }

        public function onLeft(e:MouseEvent):void{
            main.Game.x -= 10;
        }

        public function onRight(e:MouseEvent):void{
            main.Game.x += 10;
        }

        public function onDown(e:MouseEvent):void{
            main.Game.y -= 10;
        }
    }
}
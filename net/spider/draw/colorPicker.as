package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.handlers.*;
    import fl.motion.Color;
    import fl.controls.TextInput;
    import fl.managers.StyleManager;

    public class colorPicker extends MovieClip {
        public function colorPicker(){
            this.txtRed.text = "255";
            this.txtGreen.text = "255";
            this.txtBlue.text = "255";
            this.txtHex.text = "#ffffff";

            this.ui.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.ui.addEventListener(MouseEvent.MOUSE_UP, onMRelease, false, 0, true);
            this.ui.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            this.btnColor.addEventListener(MouseEvent.CLICK, onBtColor, false, 0, true);
        }

        private function onClose(e:MouseEvent):void{
            this.visible = false;
        }

        private function onBtColor(evt:MouseEvent):void{
            stage.addEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private var _stageBitmap:BitmapData;
        private function getColor(evt:MouseEvent):void{
            if (_stageBitmap == null) 
                _stageBitmap = new BitmapData(stage.width, stage.height);
            _stageBitmap.draw(stage);

            var rgb:uint = _stageBitmap.getPixel(stage.mouseX,stage.mouseY);

            var red:int =  (rgb >> 16 & 0xff);
            var green:int =  (rgb >> 8 & 0xff);
            var blue:int =  (rgb & 0xff);

            this.txtRed.text = red.toString();
            this.txtGreen.text = green.toString();
            this.txtBlue.text = blue.toString();

            this.txtHex.text = "#" + rgb.toString(16);

            var c:Color=new Color();
            c.setTint(rgb, 1);
            this.colorPreview.transform.colorTransform = c;

            stage.removeEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private function onDrag(e:MouseEvent):void{
            this.startDrag();
        }

        private function onMRelease(e:MouseEvent):void{
            this.stopDrag();
        }
    }
}
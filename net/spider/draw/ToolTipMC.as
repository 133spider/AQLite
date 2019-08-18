// Decompiled by AS3 Sorcerer 1.40
// http://www.as3sorcerer.com/

//ToolTipMC

package net.spider.draw{
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import flash.geom.ColorTransform;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.*;
    import net.spider.main;

    public class ToolTipMC extends MovieClip {

        public var tClose:Timer;
        public var cnt:MovieClip;
        private var neutralCT:ColorTransform;
        var mc:MovieClip;
        var isOpen:Boolean = false;
        private var blackCT:ColorTransform;
        var data:Object;
        var tWidth:int;
        public var tOpen:Timer;

        public function ToolTipMC(){
            isOpen = false;
            neutralCT = new ColorTransform();
            blackCT = new ColorTransform(0, 0, 0);
            tOpen = new Timer(200, 1);
            tClose = new Timer(10000, 1);
            addFrameScript(0, frame1, 9, frame10);
            mc = MovieClip(this);
            mc.cnt.visible = false;
            mc.cnt.ti.autoSize = "left";
            tWidth = mc.cnt.ti.width;
            mc.mouseEnabled = false;
            mc.mouseChildren = false;
            tOpen.addEventListener(TimerEvent.TIMER_COMPLETE, open, false, 0, true);
            tClose.addEventListener(TimerEvent.TIMER_COMPLETE, close, false, 0, true);
            addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
            addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
            mc.cnt.ti.addEventListener(TextEvent.LINK, onTextLink, false, 0, true);
        }

        private function onMouseOver(e:MouseEvent):void{
            tClose.reset();
        }

        public function close(e:Event=null){
            isOpen = false;
            tOpen.reset();
            tClose.reset();
            mc.gotoAndPlay("out");
        }

        public function openWith(newData){
            data = newData;
            tOpen.reset();
            tOpen.start();
            if (("closein" in data))
            {
                tClose.reset();
                tClose.delay = int(data.closein);
                tClose.start();
            }
        }

        function frame10(){
            stop();
        }

        public function open(e:TimerEvent){
            isOpen = true;
            mc.cnt.visible = true;
            mc.cnt.ti.width = tWidth;
            mc.cnt.ti.htmlText = data.str;
            mc.cnt.ti.width = (int(mc.cnt.ti.textWidth) + 6);
            mc.cnt.bg.width = (int(mc.cnt.ti.width) + 10);
            mc.cnt.bg.height = (int(mc.cnt.ti.height) + 8);
            if (((("invert" in data)) && (data.invert)))
            {
                mc.cnt.bg.transform.colorTransform = blackCT;
            }
            else
            {
                mc.cnt.bg.transform.colorTransform = neutralCT;
            }
            if (("lowerright" in data))
            {
                mc.x = ((960 - mc.cnt.bg.width) - 4);
                mc.y = ((480 - mc.cnt.bg.height) - 4);
            }
            else
            {
                mc.x = ((main._stage.mouseX - (mc.width / 2)) - main.Game.x);
                mc.y = ((main._stage.mouseY - mc.height) - 15);
                if ((mc.x + mc.cnt.bg.width) > 960)
                {
                    mc.x = ((960 - mc.cnt.bg.width) - 10);
                }
                if (mc.x < 1)
                {
                    mc.x = 1;
                }
                if (mc.y < 1)
                {
                    mc.y = (main._stage.mouseY + 10);
                }
            }
            if (data.str.indexOf("href") > -1)
            {
                mc.mouseEnabled = false;
                mc.mouseChildren = true;
            }
            else
            {
                mc.mouseEnabled = false;
                mc.mouseChildren = false;
            }
            mc.x = int(mc.x);
            mc.y = int(mc.y);
            mc.gotoAndPlay("in");
        }

        private function onMouseOut(e:MouseEvent):void{
            if (tOpen.running)
            {
                tOpen.stop();
            }
            if (tClose.running)
            {
                tClose.stop();
            }
            close();
        }

        function frame1(){
            hide();
            stop();
        }

        public function hide(){
            mc.cnt.visible = false;
            mc.x = 1050;
            mc.y = 0;
        }

        private function onTextLink(e:TextEvent):void{
            var cmd:String;
            cmd = String(e.text.split("::")[0]).toLowerCase();
            if (cmd == "link")
            {
                navigateToURL(new URLRequest(e.text.split("::")[1]), "_blank");
            }
        }


    }
}//package 


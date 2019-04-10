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

    public class questPin extends MovieClip {
        public function questPin(){
            this.txtPin.mouseEnabled = false;
            this.visible = false;
        }
    }
}
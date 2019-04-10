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

    public class iconDrops extends MovieClip {
        private var iconTimer:Timer;
        public function iconDrops(){
            this.visible = false;
            this.mouseEnabled = true;
            this.addEventListener(MouseEvent.CLICK, onBtDrop);
        }

        public function onBtDrop(e:MouseEvent):void{
            if(options.cDrops)
                dropmenu.events.dispatchEvent(new ClientEvent(ClientEvent.onShow));
            if(options.sbpcDrops)
                dropmenutwo.events.dispatchEvent(new ClientEvent(ClientEvent.onShow));
        }
    }
}
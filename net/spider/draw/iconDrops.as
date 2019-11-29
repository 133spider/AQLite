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
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, onBtDrop);
        }

        public function onBtDrop(e:MouseEvent):void{
            e.stopPropagation();
            if(optionHandler.cDrops)
                optionHandler.dropmenuMC.onShow();
            if(optionHandler.sbpcDrops)
                optionHandler.dropmenutwoMC.onShow();
        }
    }
}
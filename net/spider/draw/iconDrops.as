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
    import flash.filters.*;

    public class iconDrops extends MovieClip {
        private var iconTimer:Timer;
        public function iconDrops(){
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, onBtDrop, false, 0, true);

            glowFilter = new GlowFilter(0xFFFFFF, 1, 35, 35, 1, 1, true, false);
            alertTimer = new Timer(0);
            alertTimer.addEventListener(TimerEvent.TIMER, onGlow, false, 0, true);
        }

        public function onBtDrop(e:MouseEvent):void{
            if(alertTimer.running){
                alertTimer.stop();
                border.filters = [];
            }
            e.stopPropagation();
            if(optionHandler.cDrops)
                optionHandler.dropmenuMC.onShow();
            if(optionHandler.sbpcDrops)
                optionHandler.dropmenutwoMC.onShow();
        }

        private var alertTimer:Timer;
        private var glowFilter:GlowFilter;
        public function onAlert():void{
            if(alertTimer.running)
                return;
            glowFilter.strength = 1;
            border.filters = [glowFilter];
            alternate = false;

            alertTimer.start();
        }

        private var alternate:Boolean = false;
        public function onGlow(e:TimerEvent):void{
           glowFilter.strength += (alternate ? .05 : -.05);
           border.filters = [glowFilter];
           if(glowFilter.strength <= 0 || glowFilter.strength >= 1){
               alternate = (glowFilter.strength <= 0 ? true : false);
           }
        }
    }
}
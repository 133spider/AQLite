package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	import net.spider.draw.*;

	public class colorsets extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var colorTimer:Timer;

		public static function onCreate():void{
			colorsets.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(optionHandler.bColorSets){
				colorTimer = new Timer(0);
				colorTimer.addEventListener(TimerEvent.TIMER, onTimer);
				colorTimer.start();
			}else{
				colorTimer.reset();
				colorTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        private static var performOnceFlag:Boolean;
        private static var performOnceFlag2:Boolean;
		private static var _menu:colorSets;
        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor") && !performOnceFlag){
                if(!main.Game.ui.getChildByName("colorSets")){
					_menu = new colorSets();
                    _menu.mode = "mcCustomizeArmor";
					_menu.name = "colorSets";
                    _menu.y += main.Game.ui.mcPopup.mcCustomizeArmor.height + 12;
                    _menu.onUpdate();
					main.Game.ui.mcPopup.mcCustomizeArmor.addChild(_menu);
				}

                performOnceFlag = true;
            }else if(performOnceFlag && !main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor")){
                performOnceFlag = false;
            }

            if(main.Game.ui.mcPopup.getChildByName("mcCustomize") && !performOnceFlag2){
                if(!main.Game.ui.getChildByName("colorSets")){
					_menu = new colorSets();
                    _menu.mode = "mcCustomize";
					_menu.name = "colorSets";
                    _menu.y += main.Game.ui.mcPopup.mcCustomize.height + 12;
                    _menu.onUpdate();
					main.Game.ui.mcPopup.mcCustomize.addChild(_menu);
				}
                performOnceFlag2 = true;
            }else if(performOnceFlag2 && !main.Game.ui.mcPopup.getChildByName("mcCustomize")){
                performOnceFlag2 = false;
            }
		}
	}
	
}

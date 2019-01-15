package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class qrates extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var qTimer:Timer;

		public static function onCreate():void{
			qrates.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.qRates){
				qTimer = new Timer(0);
				qTimer.addEventListener(TimerEvent.TIMER, onTimer);
				qTimer.start();
			}else{
				qTimer.reset();
				qTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if (main.Game.ui.ModalStack.numChildren)
			{
				var frame:* = main.Game.ui.ModalStack.getChildAt(0);
				if(frame.cnt.core){
					if(!frame.cnt.core.rewardsRoll)
						return;
					for(var i:Number = 1; i < frame.cnt.core.rewardsRoll.numChildren; i++){
						if(frame.cnt.core.rewardsRoll.getChildAt(i).strType.text.indexOf("%") >= 0)
							continue;
						for each(var s:* in frame.qData.reward){
							if(s["ItemID"] == frame.cnt.core.rewardsRoll.getChildAt(i).ItemID){
								if(frame.cnt.core.rewardsRoll.getChildAt(i).strQ.visible)
									if(s["iQty"].toString() != frame.cnt.core.rewardsRoll.getChildAt(i).strQ.text.substring(1))
										continue;
								frame.cnt.core.rewardsRoll.getChildAt(i).strType.text += " (" + s["iRate"] + "%)";
								frame.cnt.core.rewardsRoll.getChildAt(i).strType.width = 100;
								break;
							}
						}
					}
				}
			}
		}
	}
	
}

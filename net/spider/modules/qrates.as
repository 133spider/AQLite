package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.TextFormat;
	import net.spider.draw.dRender;
	import net.spider.handlers.DrawEvent;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;

	public class qrates extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			qrates.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			//optionHandler.qRates
		}

		public static var doneOnce:Boolean = false;
        public static function onFrameUpdate():void{
			if(!optionHandler.qRates || !main.Game.sfc.isConnected)
				return;
			if (main.Game.ui.ModalStack.numChildren)
			{
				var frame:* = main.Game.ui.ModalStack.getChildAt(0);
				if(frame.cnt.core){
					if(!frame.cnt.core.rewardsRoll)
						return;
					for(var i:Number = 1; i < frame.cnt.core.rewardsRoll.numChildren; i++){
						var rItem:* = frame.cnt.core.rewardsRoll.getChildAt(i);
						if(rItem.strType.text.indexOf("%") >= 0)
							continue;
						inner: for each(var s:* in frame.qData.reward){
							if(s["ItemID"] == rItem.ItemID){
								if(rItem.strQ.visible)
									if(s["iQty"].toString() != rItem.strQ.text.substring(1))
										continue;
								rItem.strType.text += " (" + s["iRate"] + "%)";
								rItem.strType.width = 100;
								rItem.strRate.visible = false;
								break inner;
							}
						}
					}
				}
			}
		}
	}
	
}

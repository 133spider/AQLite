package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import net.spider.draw.dRender;
	import net.spider.handlers.DrawEvent;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import flash.utils.getQualifiedClassName;
	import net.spider.handlers.optionHandler;
	
	public class qprev extends MovieClip{

		public static var frame:*;
        public static function onFrameUpdate():void{
			if(!optionHandler.qPrev || !main.Game.sfc.isConnected)
				return;
			if (main.Game.ui.ModalStack.numChildren)
			{
				frame = main.Game.ui.ModalStack.getChildAt(0);
				if(frame.cnt.core){
					if(frame.cnt.core.rewardsStatic)
						establishRender(frame.cnt.core.rewardsStatic);
					if(frame.cnt.core.rewardsRoll)
						establishRender(frame.cnt.core.rewardsRoll);
					if(frame.cnt.core.rewardsChoice)
						establishRender(frame.cnt.core.rewardsChoice);
					if(frame.cnt.core.rewardsRandom)
						establishRender(frame.cnt.core.rewardsRandom);
				}
			}
		}

		public static var itemUI:*;
		public static function establishRender(core:*):void{
			for(var i:* = 1; i < core.numChildren; i++){
				itemUI = core.getChildAt(i);
				if(itemUI.hasEventListener(MouseEvent.CLICK))
					continue;
				inner: for each(var s:* in frame.qData.reward){
					if(s["ItemID"] == itemUI.ItemID){
						for each(var j:* in frame.qData.oRewards){
							for each(var k:* in j){
								if(k.ItemID == s["ItemID"]){
									itemUI.addEventListener(MouseEvent.CLICK, 
										onQuestItemRender(k), false, 0, true);
									break inner;
								}
							}
						}
					}
				}
			}
		}

		public static function onQuestItemRender(item:Object):Function{
			return function(e:MouseEvent):void {
				trace("Rendering " + item.sName + ": " + item.sFile + ", " + item.sLink);
				dRender.events.dispatchEvent(new DrawEvent(DrawEvent.onBtPreview, item));
			};
		}
	}
	
}

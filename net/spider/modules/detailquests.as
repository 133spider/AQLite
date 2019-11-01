package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.TextFormat;
	import net.spider.draw.*;
	import net.spider.handlers.DrawEvent;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class detailquests extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			detailquests.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			//optionHandler.detailquest
		}

		public static var frame:*;
        public static function onFrameUpdate():void{
			if(!optionHandler.detailquest || !main.Game.sfc.isConnected)
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
				if(itemUI.getChildByName("flag"))
					continue;
				inner: for each(var s:* in frame.qData.reward){
					if(s["ItemID"] == itemUI.ItemID){
						for each(var j:* in frame.qData.oRewards){
							for each(var k:* in j){
								if(k.ItemID == s["ItemID"]){
									if(k.bCoins == 1){
										var ac:fadedAC = new fadedAC();
										ac.width = 68.55;
										ac.height = 38.10;
										ac.x = itemUI.bg.width - 72; //w: 80
										ac.alpha = 0.25;
										itemUI.addChild(ac);
									}
									if(k.bUpg){
										var txtFormat:TextFormat = itemUI.strName.defaultTextFormat;
										txtFormat.color = 0xFCC749;
										itemUI.strName.setTextFormat(txtFormat);
										txtFormat = itemUI.strQ.defaultTextFormat;
										txtFormat.color = 0xFCC749;
										itemUI.strQ.setTextFormat(txtFormat);
									}
									var flag:mcCoin = new mcCoin();
									flag.visible = false;
									flag.name = "flag";
									itemUI.addChild(flag);
									break inner;
								}
							}
						}
					}
				}
			}
		}
	}
	
}

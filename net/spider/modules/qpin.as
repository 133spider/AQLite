package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.draw.cMenu;
	import net.spider.draw.questPin;
	import net.spider.handlers.optionHandler;
	
	public class qpin extends MovieClip{

		private static var pinnedQuests:String = "";
		public static function onPin(e:MouseEvent):void{
			pinnedQuests = "";
			for each(var qID:* in frame.qIDs){
				pinnedQuests += (qID + ",");
			}
		}

		public static function onToggle():void{
			if(optionHandler.qPin){
				if(main.Game.ui){
					main.Game.ui.iconQuest.addEventListener(MouseEvent.CLICK, onPinQuests, false, 0, true);
					main.Game.ui.iconQuest.removeEventListener(MouseEvent.CLICK, main.Game.oniconQuestClick);
				}
			}else{
				main.Game.ui.iconQuest.removeEventListener(MouseEvent.CLICK, onPinQuests);
				main.Game.ui.iconQuest.addEventListener(MouseEvent.CLICK, main.Game.oniconQuestClick, false, 0, true);
			}
		}

		public static function onPinQuests(e:MouseEvent):void{
			if(e.shiftKey){
				main.Game.ui.mcQTracker.toggle();
				return;
			}
			if(pinnedQuests == "")
				return;
			main.Game.world.showQuests(pinnedQuests, "q");
		}

		private static var frame:*;
		public static function onFrameUpdate():void{
			if(!optionHandler.qPin || !main.Game.sfc.isConnected)
				return;
			if (main.Game.ui.ModalStack.numChildren)
			{
				frame = main.Game.ui.ModalStack.getChildAt(0);
				if(flash.utils.getQualifiedClassName(frame) == "QFrameMC")
					if(frame.cnt.strTitle){
						if(frame.cnt.strTitle.htmlText.indexOf("Available Quests") > -1){
							if(!frame.cnt.bg.getChildByName("questPin")){
								var pinUI:* = frame.cnt.bg.addChild(new questPin());
								pinUI.name = "questPin";
								pinUI.x = 27;
								pinUI.y = 19;
								pinUI.addEventListener(MouseEvent.CLICK, onPin, false, 0, true);
								frame.cnt.bg.setChildIndex(frame.cnt.bg.getChildByName("tl2"), frame.cnt.bg.numChildren-1);
								frame.cnt.strTitle.mouseEnabled = false;
								frame.cnt.strTitle.x += 11;
							}
						}else{
							if(frame.cnt.bg.getChildByName("questPin")){
								frame.cnt.bg.getChildByName("questPin").removeEventListener(MouseEvent.CLICK, onPin);
								frame.cnt.bg.removeChild(frame.cnt.bg.getChildByName("questPin"));
							}
						}
					}
			}
		}
	}
	
}

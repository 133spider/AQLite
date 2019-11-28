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
	import net.spider.handlers.optionHandler;
	
	public class qpin extends MovieClip{

		public static function setVisiblity(e:Boolean):void{
			main.rootDisplay.getChildByName("mcQuestPin").visible = e;
		}

		private static var pinnedQuests:String = "";
		public static function onPin(e:MouseEvent):void{
			pinnedQuests = "";
			for each(var qID:* in frame.qIDs){
				pinnedQuests += (qID + ",");
			}
		}

		public static var eventInitialized:Boolean = false;
		public static function onToggle():void{
			if(optionHandler.qPin){
				if(main.Game.ui){
					if(!eventInitialized){
						main.Game.ui.iconQuest.addEventListener(MouseEvent.CLICK, onPinQuests, false, 0, true);
						main.Game.ui.iconQuest.removeEventListener(MouseEvent.CLICK, main.Game.oniconQuestClick);
						eventInitialized = true;
					}
				}
				main.rootDisplay.getChildByName("mcQuestPin").btPin.addEventListener(MouseEvent.CLICK, onPin, false, 0, true);
			}else{
				if(eventInitialized){
					main.Game.ui.iconQuest.removeEventListener(MouseEvent.CLICK, onPinQuests);
					main.Game.ui.iconQuest.addEventListener(MouseEvent.CLICK, main.Game.oniconQuestClick, false, 0, true);
					eventInitialized = false;
				}
				main.rootDisplay.getChildByName("mcQuestPin").btPin.removeEventListener(MouseEvent.CLICK, onPin);
			}
		}

		public static function onPinQuests(e:MouseEvent):void{
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
				if(frame.cnt.strTitle){
					if(frame.cnt.strTitle.htmlText.indexOf("Available Quests") > -1){
						setVisiblity(true);
					}else{
						setVisiblity(false);
					}
				}
			}else{
				setVisiblity(false);
			}
		}
	}
	
}

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

		public static var events:EventDispatcher = new EventDispatcher();
		public static function onCreate():void{
			pinnedQuests = "";
			qpin.events.addEventListener(ClientEvent.onToggle, onToggle);
			main.rootDisplay.getChildByName("mcQuestPin").btPin.addEventListener(MouseEvent.CLICK, onPin, false, 0, true);
		}

		public static function setVisiblity(e:Boolean):void{
			main.rootDisplay.getChildByName("mcQuestPin").visible = e;
		}

		private static var pinnedQuests:String;
		public static function onPin(e:MouseEvent):void{
			pinnedQuests = "";
			for each(var qID:* in frame.qIDs){
				pinnedQuests += (qID + ",");
			}
		}

		public static function onToggle(e:Event):void{
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

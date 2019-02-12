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
	
	public class qlog extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var qTimer:Timer;

		private static var stage;
		public static function onCreate():void{
			stage = main._stage;
			qlog.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.qLog){
				//main.Game.ui.mcInterface.mcMenu.btnQuest.addEventListener(MouseEvent.CLICK, onRegister);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
				//main.Game.ui.mcInterface.mcMenu.btnQuest.removeEventListener(MouseEvent.CLICK, main.Game.ui.mcInterface.mcMenu.onMouseClick);
			}else{
				//main.Game.ui.mcInterface.mcMenu.btnQuest.removeEventListener(MouseEvent.CLICK, onRegister);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
				//main.Game.ui.mcInterface.mcMenu.btnQuest.getChildByName(menu.btnOpen).addEventListener(MouseEvent.CLICK, main.Game.ui.mcInterface.mcMenu.onMouseClick);
			}
		}

		public static function onKey(e:KeyboardEvent){
			var chatF:* = main.Game.chatF;
			var world:* = main.Game.world;
			var ui:* = main.Game.ui;
            if (!("text" in e.target))
            {
                if (String.fromCharCode(e.charCode) == "l")
                {
                    if (stage.focus != ui.mcInterface.te)
                    {
						main.Game.world.toggleQuestLog();
                        var mcQFrame:*;
						mcQFrame = main.Game.getInstanceFromModalStack("QFrameMC");
						if (mcQFrame == null)
							main.Game.world.showQuests(main.Game.world.getActiveQuests(), "q");
						else
							mcQFrame.open();
                    }
                }
            }
        }

		public static function onRegister(e:MouseEvent):void{
			try{
				main.Game.ui.mcInterface.mcMenu.btnQuest.getChildAt(1).addEventListener(MouseEvent.CLICK, showQuests, false, 0, true);
			}catch(exception){}
		}

		public static function showQuests(e:MouseEvent):void{
			if(e.target.mTxt.text != "Quests")
				return;
			main.Game.world.toggleQuestLog();
			var mcQFrame:*;
            mcQFrame = main.Game.getInstanceFromModalStack("QFrameMC");
            if (mcQFrame == null)
                main.Game.world.showQuests(main.Game.world.getActiveQuests(), "q");
            else
                mcQFrame.open();
		}
	}
	
}

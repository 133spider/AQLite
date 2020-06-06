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
	
	public class qlog extends MovieClip{

		public static function onToggle():void{
			if(optionHandler.qLog){
				if(main.Game.sfc.isConnected && main.Game.ui){
					main.Game.ui.mcInterface.mcMenu.btnQuest.addEventListener(MouseEvent.CLICK, onRegister, false, 0, true);
				}
			}else{
				main.Game.ui.mcInterface.mcMenu.btnQuest.removeEventListener(MouseEvent.CLICK, onRegister);
			}
		}

		public static function onKey(e:KeyboardEvent){
			if(!optionHandler.qLog)
				return;
			var chatF:* = main.Game.chatF;
			var world:* = main.Game.world;
			var ui:* = main.Game.ui;
            if (!("text" in e.target))
            {
                if (String.fromCharCode(e.charCode) == "l")
                {
                    if (main._stage.focus != ui.mcInterface.te)
                    {
						var delay:* = new Timer(100, 1);
						delay.addEventListener(TimerEvent.TIMER_COMPLETE,
							function(e:TimerEvent):void{
								main.Game.world.toggleQuestLog();
								main.Game.world.showQuests(main.Game.world.getActiveQuests(), "q");
							}, false, 0, true);
						delay.start();
                    }
                }
            }
        }

		public static function onRegister(e:MouseEvent):void{
			try{
				main.Game.ui.mcInterface.mcMenu.btnQuest.getChildAt(1).addEventListener(MouseEvent.CLICK, showQuests, false, 0, true);
			}catch(exception){
				main.Game.ui.mcInterface.mcMenu.btnQuest.getChildAt(1).addEventListener(MouseEvent.CLICK, showQuests, false, 0, true);
			}
		}

		public static function showQuests(e:MouseEvent):void{
			if(e.target.mTxt.text != "Quests")
				return;
			var delay:* = new Timer(100, 1);
			delay.addEventListener(TimerEvent.TIMER_COMPLETE,
				function(e:TimerEvent):void{
					main.Game.world.toggleQuestLog();
					main.Game.world.showQuests(main.Game.world.getActiveQuests(), "q");
				}, false, 0, true);
			delay.start();
		}
	}
	
}

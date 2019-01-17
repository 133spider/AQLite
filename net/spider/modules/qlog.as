package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class qlog extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var qTimer:Timer;

		public static function onCreate():void{
			qlog.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.qLog){
				main.Game.ui.mcInterface.mcMenu.btnQuest.addEventListener(MouseEvent.CLICK, showQuests);
				main.Game.ui.mcInterface.mcMenu.btnQuest.removeEventListener(MouseEvent.CLICK, main.Game.ui.mcInterface.mcMenu.onMouseClick);
			}else{
				main.Game.ui.mcInterface.mcMenu.btnQuest.removeEventListener(MouseEvent.CLICK, showQuests);
				main.Game.ui.mcInterface.mcMenu.btnQuest.addEventListener(MouseEvent.CLICK, main.Game.ui.mcInterface.mcMenu.onMouseClick);
			}
		}

		public static function showQuests(e:MouseEvent):void{
			var mcQFrame:*;
            mcQFrame = main.Game.getInstanceFromModalStack("QFrameMC");
            if (mcQFrame == null)
                main.Game.world.showQuests(main.Game.world.getActiveQuests(), "q");
            else
                mcQFrame.open();
		}
	}
	
}

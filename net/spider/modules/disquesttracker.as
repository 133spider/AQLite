package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.optionHandler;
	
	public class disquesttracker extends MovieClip{

		public static function onTimerUpdate():void{
			if(!optionHandler.bDisQuestTracker || !main.Game.sfc.isConnected)
				return;
			if (main.Game.ui.mcQTracker.visible)
                main.Game.ui.mcQTracker.visible = false;
		}
	}
	
}

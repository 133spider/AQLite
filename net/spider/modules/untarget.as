package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;

	public class untarget extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			untarget.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			//optionHandler.untargetMon
		}

        public static function onTimerUpdate():void{
			if(!optionHandler.untargetMon || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			if(main.Game.world.myAvatar.target)
				if(main.Game.world.myAvatar.target.dataLeaf.intState == 0)
					main.Game.world.cancelTarget();
		}
	}
	
}

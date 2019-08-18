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
        private static var untargetTimer:Timer;

		public static function onCreate():void{
			untarget.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(optionHandler.untargetMon){
				untargetTimer = new Timer(0);
				untargetTimer.addEventListener(TimerEvent.TIMER, onTimer);
				untargetTimer.start();
			}else{
				untargetTimer.reset();
				untargetTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			if(main.Game.world.myAvatar.target)
				if(main.Game.world.myAvatar.target.dataLeaf.intState == 0)
					main.Game.world.cancelTarget();
		}
	}
	
}

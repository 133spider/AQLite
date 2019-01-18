package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class untargetself extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var untargetTimer:Timer;

		public static function onCreate():void{
			untargetself.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.selfTarget){
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
				if(main.Game.world.myAvatar.target.isMyAvatar)
					main.Game.world.cancelTarget();
		}
	}
	
}

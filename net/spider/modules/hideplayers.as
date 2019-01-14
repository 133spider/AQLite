package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class hideplayers extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var hideTimer:Timer;

		public static function onCreate():void{
			hideplayers.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.hideP){
				hideTimer = new Timer(0);
				hideTimer.addEventListener(TimerEvent.TIMER, onTimer);
				hideTimer.start();
			}else{
				hideTimer.reset();
				hideTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars)
				if(!main.Game.world.avatars[playerMC].isMyAvatar && main.Game.world.avatars[playerMC].pMC)
					main.Game.world.avatars[playerMC].pMC.mcChar.visible = false;
		}
	}
	
}

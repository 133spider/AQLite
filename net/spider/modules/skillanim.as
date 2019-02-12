package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class skillanim extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var animTimer:Timer;

		public static function onCreate():void{
			skillanim.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.disableSkillAnim){
				animTimer = new Timer(0);
				animTimer.addEventListener(TimerEvent.TIMER, onTimer);
				animTimer.start();
			}else{
				animTimer.reset();
				animTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(!main.Game.world.myAvatar.pMC.spFX)
				return;
			if(main.Game.world.avatars.length < 2 && !options.filterChecks["chkSelfOnly"])
				main.Game.world.myAvatar.pMC.spFX.strl = "";
			else
				for(var playerMC:* in main.Game.world.avatars){
					if(options.filterChecks["chkSelfOnly"])
						if(main.Game.world.avatars[playerMC].isMyAvatar)
							continue;
					if(main.Game.world.avatars[playerMC].pMC)
						main.Game.world.avatars[playerMC].pMC.spFX.strl = "";
				}
		}
	}
	
}

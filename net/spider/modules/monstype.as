package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class monstype extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var monsTimer:Timer;

		public static function onCreate():void{
			monstype.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.mType){
				monsTimer = new Timer(0);
				monsTimer.addEventListener(TimerEvent.TIMER, onTimer);
				monsTimer.start();
			}else{
				monsTimer.reset();
				monsTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !(main.Game.world.myAvatar.target != null))
				return;
			if(main.Game.world.myAvatar.target.npcType == "monster")
				if(main.Game.ui.mcPortraitTarget.strClass.text != main.Game.world.myAvatar.target.objData.sRace)
					main.Game.ui.mcPortraitTarget.strClass.text = main.Game.world.myAvatar.target.objData.sRace;
		}
	}
	
}

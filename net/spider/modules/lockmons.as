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
	
	public class lockmons extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var monsTimer:Timer;

		public static function onCreate():void{
			lockmons.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(optionHandler.lockm){
				monsTimer = new Timer(0);
				monsTimer.addEventListener(TimerEvent.TIMER, onTimer);
				monsTimer.start();
			}else{
				monsTimer.reset();
				monsTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				var mons:Array = main.Game.world.getMonstersByCell(main.Game.world.strFrame);
				for each(var _m in mons){
					if(!_m)
						continue;
					if(!_m.pMC)
						continue;
					if(_m.pMC.noMove)
						_m.pMC.noMove = false;
				}
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(!main.Game.world.strFrame)
				return;
			var mons:Array = main.Game.world.getMonstersByCell(main.Game.world.strFrame);
			for each(var _m in mons){
				if(!_m)
					continue;
				if(!_m.pMC)
					continue;
				if(!_m.pMC.noMove)
					_m.pMC.noMove = true;
			}
		}
	}
	
}

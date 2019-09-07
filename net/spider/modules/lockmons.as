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

		public static function onCreate():void{
			lockmons.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(!optionHandler.lockm){
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

        public static function onTimerUpdate():void{
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

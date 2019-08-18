package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.*;
    import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.handlers.flags;
	import net.spider.handlers.optionHandler;
	
	public class boosts extends MovieClip {
		
        public static var events:EventDispatcher = new EventDispatcher();
        private static var boostTimer:Timer;

		public static function onCreate():void {
            boosts.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

        public static function onToggle(e:Event):void{
            if(optionHandler.boost){
				boostTimer = new Timer(0);
				boostTimer.addEventListener(TimerEvent.TIMER, onTimer);
				boostTimer.start();
			}else{
				boostTimer.reset();
				boostTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
        }

		private static var runOnce:Boolean = false;
        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(!main.Game.world.myAvatar)
				return;
			if(!main.Game.world.myAvatar.items)
				return;
			if(!flags.isInventory() && runOnce)
				runOnce = false;
			if(flags.isInventory() && !runOnce){
				for each(var pItem:* in main.Game.world.myAvatar.items){
					if(!pItem.oldDesc)
						pItem.oldDesc = pItem.sDesc;
					var nuDesc:String = "";
					if(pItem.sMeta)
						nuDesc = "sMeta: " + pItem.sMeta + "\n";
					pItem.sDesc = nuDesc + "Stacks: " + pItem.iQty + "/" + pItem.iStk + "\n" + pItem.oldDesc;
					nuDesc = null;
				}
				runOnce = true;
			}
		}
	}
	
}

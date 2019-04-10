package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class bitmap extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var animTimer:Timer;

		public static function onCreate():void{
			bitmap.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.bitmapP){
				animTimer = new Timer(0);
				animTimer.addEventListener(TimerEvent.TIMER, onTimer);
				animTimer.start();
			}else{
				animTimer.reset();
				animTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				for(var playerMC:* in main.Game.world.avatars){
					if((!main.Game.world.avatars[playerMC].dataLeaf) 
						&& (main.Game.world.avatars[playerMC].dataLeaf.strFrame != main.Game.world.strFrame))
						continue;
					if(!main.Game.world.avatars[playerMC].pMC)
						continue;
					if(main.Game.world.avatars[playerMC].isMyAvatar)
						continue;
					if(main.Game.world.avatars[playerMC].dataLeaf.intState > 0){
						main.Game.world.avatars[playerMC].pMC.mcChar.gotoAndPlay(0);
						movieClipPlayAll((main.Game.world.avatars[playerMC].pMC.mcChar as MovieClip));
						main.Game.world.avatars[playerMC].pMC.mcChar.cacheAsBitmap = false;
					}
				}
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.avatars)
				return;
			for(var playerMC:* in main.Game.world.avatars){
				if((!main.Game.world.avatars[playerMC].dataLeaf) 
					&& (main.Game.world.avatars[playerMC].dataLeaf.strFrame != main.Game.world.strFrame))
					continue;
				if(!main.Game.world.avatars[playerMC].pMC)
					continue;
				if(main.Game.world.avatars[playerMC].isMyAvatar)
					continue;
				if(main.Game.world.avatars[playerMC].dataLeaf.intState > 0){
					main.Game.world.avatars[playerMC].pMC.mcChar.gotoAndStop("Idle");
					movieClipStopAll((main.Game.world.avatars[playerMC].pMC.mcChar as MovieClip));
					main.Game.world.avatars[playerMC].pMC.mcChar.cacheAsBitmap = true;
				}
			}
		}

		public static function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if((container.getChildAt(i) as MovieClip).name == "pvpFlag")
						continue;
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
                    (container.getChildAt(i) as MovieClip).gotoAndStop(0);
                    movieClipStopAll(container.getChildAt(i) as MovieClip);
                }
        }

		public static function movieClipPlayAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if((container.getChildAt(i) as MovieClip).name == "pvpFlag")
						continue;
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
                    (container.getChildAt(i) as MovieClip).gotoAndPlay(0);
                    movieClipPlayAll(container.getChildAt(i) as MovieClip);
                }
        }
	}
	
}

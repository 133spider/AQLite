package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class dismonanim extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var animTimer:Timer;

		public static function onCreate():void{
			dismonanim.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.disMonAnim){
				animTimer = new Timer(0);
				animTimer.addEventListener(TimerEvent.TIMER, onTimer);
				animTimer.start();
			}else{
				animTimer.reset();
				animTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				for(var monsterMC:* in main.Game.world.monsters){
					if((!main.Game.world.monsters[monsterMC].dataLeaf) 
						&& (main.Game.world.monsters[monsterMC].dataLeaf.strFrame != main.Game.world.strFrame))
						continue;
					if(!main.Game.world.monsters[monsterMC].pMC)
						continue;
					if(main.Game.world.monsters[monsterMC].dataLeaf.intState > 0){
						main.Game.world.monsters[monsterMC].pMC.gotoAndPlay(0);
						movieClipPlayAll((main.Game.world.monsters[monsterMC].pMC as MovieClip));
					}
				}
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.monsters)
				return;
			for(var monsterMC:* in main.Game.world.monsters){
				if((!main.Game.world.monsters[monsterMC].dataLeaf) 
					&& (main.Game.world.monsters[monsterMC].dataLeaf.strFrame != main.Game.world.strFrame))
					continue;
				if(!main.Game.world.monsters[monsterMC].pMC)
					continue;
				if(main.Game.world.monsters[monsterMC].dataLeaf.intState > 0){
					main.Game.world.monsters[monsterMC].pMC.getChildAt(1).gotoAndStop("Idle");
					movieClipStopAll((main.Game.world.monsters[monsterMC].pMC.getChildAt(1) as MovieClip));
				}
			}
		}

		public static function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
                    (container.getChildAt(i) as MovieClip).gotoAndStop(0);
                    movieClipStopAll(container.getChildAt(i) as MovieClip);
                }
        }

		public static function movieClipPlayAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
                    (container.getChildAt(i) as MovieClip).gotoAndPlay(0);
                    movieClipPlayAll(container.getChildAt(i) as MovieClip);
                }
        }
	}
	
}

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
	
	public class dismonanim extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			dismonanim.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(!optionHandler.disMonAnim){
				for(var monsterMC:* in main.Game.world.monsters){
					if((!main.Game.world.monsters[monsterMC].dataLeaf) 
						&& (main.Game.world.monsters[monsterMC].dataLeaf.strFrame != main.Game.world.strFrame))
						continue;
					if(!main.Game.world.monsters[monsterMC].pMC)
						continue;
					if(main.Game.world.monsters[monsterMC].dataLeaf.intState > 0){
						try{
							main.Game.world.monsters[monsterMC].pMC.gotoAndPlay(0);
							movieClipPlayAll((main.Game.world.monsters[monsterMC].pMC as MovieClip));
						}catch(exception){}
					}
				}
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.disMonAnim || !main.Game.sfc.isConnected || !main.Game.world.monsters)
				return;
			for(var monsterMC:* in main.Game.world.monsters){
				if((!main.Game.world.monsters[monsterMC].dataLeaf) 
					&& (main.Game.world.monsters[monsterMC].dataLeaf.strFrame != main.Game.world.strFrame))
					continue;
				if(!main.Game.world.monsters[monsterMC].pMC)
					continue;
				if(main.Game.world.monsters[monsterMC].dataLeaf.intState > 0){
					try{
						main.Game.world.monsters[monsterMC].pMC.getChildAt(1).gotoAndStop("Idle");
						movieClipStopAll((main.Game.world.monsters[monsterMC].pMC.getChildAt(1) as MovieClip));
					}catch(exception){}
				}
			}
		}

		public static function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
					try{
						(container.getChildAt(i) as MovieClip).gotoAndStop(0);
						movieClipStopAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

		public static function movieClipPlayAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
					try{
						(container.getChildAt(i) as MovieClip).gotoAndPlay(0);
						movieClipPlayAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }
	}
	
}

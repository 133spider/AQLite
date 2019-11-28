package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import fl.controls.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class dismapanim extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.disMapAnim){
				propPlay(main.Game.world.CHARS);
				var ctr:Number = 0;
				while(ctr < main.Game.world.map.numChildren){
					if(main.Game.world.map.getChildAt(ctr) is MovieClip){
						mapPlay((main.Game.world.map.getChildAt(ctr) as MovieClip));
					}
					ctr++;
				}
			}
		}

		public static function propStop(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip && 
					(container.getChildAt(i).hasOwnProperty("isProp") || container.getChildAt(i).hasOwnProperty("isHouseItem"))
					&& !container.getChildAt(i).hasOwnProperty("isEvent")) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndStop(0);
						propStop(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

		public static function mapStop(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip
					&& (getQualifiedClassName(container.getChildAt(i)).indexOf("Eggs") == -1)) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndStop(0);
						mapStop(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

        public static function onFrameUpdate():void{
			if(!optionHandler.disMapAnim || !main.Game.sfc.isConnected)
				return;
			if(!main.Game.world.map)
				return;
			if(main.Game.world.map.numChildren < 1)
				return;
			propStop(main.Game.world.CHARS);
			var ctr:Number = 0;
			while(ctr < main.Game.world.map.numChildren){
				if(main.Game.world.map.getChildAt(ctr) is MovieClip){
					mapStop((main.Game.world.map.getChildAt(ctr) as MovieClip));
				}
				ctr++;
			}
		}

		public static function propPlay(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip && 
					(container.getChildAt(i).hasOwnProperty("isProp") || container.getChildAt(i).hasOwnProperty("isHouseItem"))
					&& !container.getChildAt(i).hasOwnProperty("isEvent")) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndPlay(0);
						propPlay(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

		public static function mapPlay(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip
					&& (getQualifiedClassName(container.getChildAt(i)).indexOf("Eggs") == -1)) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndPlay(0);
						mapPlay(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }
	}
	
}

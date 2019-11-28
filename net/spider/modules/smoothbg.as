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

	public class smoothbg extends MovieClip{

        public static function onFrameUpdate():void{
			if(!optionHandler.smoothBG || !main.Game.world)
				return;
			if(!main.Game.world.map)
				return;
			var ctr:Number = 0;
			while(ctr < main.Game.world.map.numChildren){
				if(main.Game.world.map.getChildAt(ctr) is MovieClip && main.Game.world.map.getChildAt(ctr).width >= 960
					&& !main.Game.world.map.getChildAt(ctr).visible
					&& (getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("mcShadow") == -1)){
					main.Game.world.map.getChildAt(ctr).visible = true;
				}
				if(getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("Bitmap") > -1
					&& main.Game.world.map.getChildAt(ctr).visible){
					main.Game.world.map.getChildAt(ctr).visible = false;
				}
				if((getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("mcFloor") > -1) &&
					main.Game.world.map.getChildAt(ctr).visible){
					if(getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("mcFloors") == -1){
						main.Game.world.map.getChildAt(ctr).visible = false;
					}
				}
				if((getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("Plate") > -1) &&
					main.Game.world.map.getChildAt(ctr).visible){
					main.Game.world.map.getChildAt(ctr).visible = false;
				}
				ctr++;
            }
		}
	}
	
}

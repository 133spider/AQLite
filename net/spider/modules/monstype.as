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
	
	public class monstype extends MovieClip{

        public static function onFrameUpdate():void{
			if(!optionHandler.mType || !main.Game.sfc.isConnected
				|| (main.Game.world.myAvatar == null) 
				|| (main.Game.world.myAvatar.target == null))
				return;
			if(main.Game.world.myAvatar.target.npcType == "monster")
				if(main.Game.ui.mcPortraitTarget.strClass.text != main.Game.world.myAvatar.target.objData.sRace)
					main.Game.ui.mcPortraitTarget.strClass.text = main.Game.world.myAvatar.target.objData.sRace;
		}
	}
	
}

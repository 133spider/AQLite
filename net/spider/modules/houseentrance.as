package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.draw.cMenu;
	import net.spider.handlers.optionHandler;
	
	public class houseentrance extends MovieClip{

		public static var houseEvent:Boolean = false;
		public static function onToggle():void{
			if(!main.Game)
				return;
			if(!main.Game.ui)
				return;
			if(!houseEvent){
				main.Game.ui.mcInterface.mcMenu.btnHouse.addEventListener(MouseEvent.CLICK, onHouseClick, false, 0, true);
				houseEvent = true;
			}else{
				if(main.Game.ui)
					main.Game.ui.mcInterface.mcMenu.btnHouse.removeEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = false;
			}
		}

		public static function onHouseClick(e:MouseEvent):void{
			if(main.Game.world.strMapName.toLowerCase() == "house")
				main.Game.world.moveToCell("Enter", "Spawn");
		}
	}
	
}

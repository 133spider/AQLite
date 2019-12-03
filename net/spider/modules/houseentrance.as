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

		private static var passInit:Boolean = false;
		private static var houseEvent:Boolean = false;
		public static function onToggle():void{
			if(!main.Game)
				return;
			if(!main.Game.ui)
				return;
			if(!houseEvent && passInit){
				main.Game.ui.mcInterface.mcMenu.btnHouse.addEventListener(MouseEvent.CLICK, onHouseClick, false, 0, true);
				houseEvent = true;
			}else{
				main.Game.ui.mcInterface.mcMenu.btnHouse.removeEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = false;
			}
			if(!passInit) //dodge the first initial dispatch
				passInit = true;
		}

		public static function onHouseClick(e:MouseEvent):void{
			if(main.Game.world.strMapName.toLowerCase() == "house")
				main.Game.world.moveToCell("Enter", "Spawn");
		}
	}
	
}

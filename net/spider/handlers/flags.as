package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	
	public class flags extends MovieClip{

		public static function isOptions():Boolean{
            return (main.Game.ui.mcPopup.currentLabel == "Option");
        }
	}
	
}

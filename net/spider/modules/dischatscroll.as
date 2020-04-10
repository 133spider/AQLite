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
	
	public class dischatscroll extends MovieClip{

		public static function onToggle():void{
            if(optionHandler.bDisChatScroll){
                main.Game.addEventListener(MouseEvent.MOUSE_WHEEL, onDisableWheel, false, 0, true);
            }else{
                main.Game.removeEventListener(MouseEvent.MOUSE_WHEEL, onDisableWheel);
            }
		}

        public static function onDisableWheel(e:MouseEvent):void{
			e.stopPropagation();
		}
	}
	
}

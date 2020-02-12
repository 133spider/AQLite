package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.draw.cMenu;
	import net.spider.draw.questPin;
	import net.spider.handlers.optionHandler;
	
	public class bankkey extends MovieClip{

        public static function isAllowed():Boolean{
            for each(var item:* in main.Game.world.myAvatar.items){
                if(item.sName.indexOf(" Bank") > -1)
                    return true;
            }
            return false;
        }

		public static function onKey(e:KeyboardEvent):void{
			if(!optionHandler.bBankKey)
				return;
			var chatF:* = main.Game.chatF;
			var world:* = main.Game.world;
			var ui:* = main.Game.ui;
            if (!("text" in e.target))
            {
                if (String.fromCharCode(e.charCode) == "b")
                {
                    if (main._stage.focus != ui.mcInterface.te)
                    {
                        trace(isAllowed());
                        if(isAllowed())
                            main.Game.world.toggleBank();
                    }
                }
            }
		}
	}
	
}

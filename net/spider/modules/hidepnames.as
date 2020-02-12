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
	
	public class hidepnames extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.hideP){
				for(var playerMC:* in main.Game.world.avatars)
					if(main.Game.world.avatars[playerMC].pMC){
						main.Game.world.avatars[playerMC].pMC.pname.visible = true;
						main.Game.world.avatars[playerMC].pMC.pname.ti.visible = true;
						main.Game.world.avatars[playerMC].pMC.pname.tg.visible = true;
					}
			}
		}

        static var mouseOverAvatar:*;
		public static function onMouseAvatarOver(e:*):void{
			mouseOverAvatar = e.currentTarget.parent.pname.ti.text;
		}

		public static function onMouseAvatarOut(e:*):void{
			mouseOverAvatar = "";
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.hidePNames || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars){
				if(!main.Game.world.avatars[playerMC].objData)
					continue;
				if(optionHandler.filterChecks["chkGuild"]){
					if(main.Game.world.avatars[playerMC].pMC.pname.tg.visible 
						&& mouseOverAvatar != main.Game.world.avatars[playerMC].pMC.pname.ti.text){
						main.Game.world.avatars[playerMC].pMC.pname.tg.visible = false;
					}else if(!main.Game.world.avatars[playerMC].pMC.pname.tg.visible 
						&& main.Game.world.avatars[playerMC].pMC.pname.ti.text == mouseOverAvatar){
						main.Game.world.avatars[playerMC].pMC.pname.tg.visible = true;
					}
				}else{
					if(main.Game.world.avatars[playerMC].pMC.pname.visible 
						&& mouseOverAvatar != main.Game.world.avatars[playerMC].pMC.pname.ti.text){
						main.Game.world.avatars[playerMC].pMC.pname.visible = false;
					}else if(!main.Game.world.avatars[playerMC].pMC.pname.visible 
						&& main.Game.world.avatars[playerMC].pMC.pname.ti.text == mouseOverAvatar){
						main.Game.world.avatars[playerMC].pMC.pname.visible = true;
					}
				}
				if(!main.Game.world.avatars[playerMC].dataLeaf.hasMouseOverEvent){
					try{
						main.Game.world.avatars[playerMC].pMC.mcChar.addEventListener(MouseEvent.ROLL_OVER, onMouseAvatarOver, false, 0, true);
						main.Game.world.avatars[playerMC].pMC.mcChar.addEventListener(MouseEvent.ROLL_OUT, onMouseAvatarOut, false, 0, true);
						main.Game.world.avatars[playerMC].dataLeaf.hasMouseOverEvent = true;
					}catch(exception){}
				}
			}
		}
	}
	
}

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
	
	public class skillanim extends MovieClip{

        public static function onTimerUpdate():void{
			if(!optionHandler.disableSkillAnim || !main.Game.sfc.isConnected || !main.Game.world.myAvatar || !main.Game.world.myAvatar.pMC.spFX)
				return;
			if(main.Game.world.avatars.length < 2 && !optionHandler.filterChecks["chkSelfOnly"]){
				main.Game.world.myAvatar.pMC.spFX.strl = "";
			}else{
				for(var playerMC:* in main.Game.world.avatars){
					if(optionHandler.filterChecks["chkSelfOnly"])
						if(main.Game.world.avatars[playerMC].isMyAvatar)
							continue;
					if(main.Game.world.avatars[playerMC].pMC)
						main.Game.world.avatars[playerMC].pMC.spFX.strl = "";
				}
			}
		}
	}
	
}

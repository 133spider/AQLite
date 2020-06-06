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
	
	public class diswepanim extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.disWepAnim){
				for(var playerMC:* in main.Game.world.avatars){
					if(!main.Game.world.avatars[playerMC].objData)
						continue;
					if(main.Game.world.avatars[playerMC].pMC){
						try{
							main.Game.world.avatars[playerMC].pMC.mcChar.weapon.mcWeapon.gotoAndPlay(0);
							(main.Game.world.avatars[playerMC].pMC.mcChar.weaponOff.getChildAt(0) as MovieClip).gotoAndPlay(0);
							movieClipPlayAll(main.Game.world.avatars[playerMC].pMC.mcChar.weapon.mcWeapon);
							movieClipPlayAll((main.Game.world.avatars[playerMC].pMC.mcChar.weaponOff.getChildAt(0) as MovieClip));
						}catch(exception){}
					}
				}
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.disWepAnim || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars){
				if(!main.Game.world.avatars[playerMC].objData)
					continue;
				if(optionHandler.filterChecks["chkDisWepAnim"])
					if(main.Game.world.avatars[playerMC].isMyAvatar)
						continue;
				if(main.Game.world.avatars[playerMC].pMC.isLoaded &&
					main.Game.world.avatars[playerMC].pMC.mcChar.weapon.mcWeapon){
					try{
						main.Game.world.avatars[playerMC].pMC.mcChar.weapon.mcWeapon.gotoAndStop(0);
						(main.Game.world.avatars[playerMC].pMC.mcChar.weaponOff.getChildAt(0) as MovieClip).gotoAndStop(0);
						movieClipStopAll(main.Game.world.avatars[playerMC].pMC.mcChar.weapon.mcWeapon);
						movieClipStopAll((main.Game.world.avatars[playerMC].pMC.mcChar.weaponOff.getChildAt(0) as MovieClip));
					}catch(exception){}
				}
			}
		}

		public static function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndStop(0);
						movieClipStopAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

		public static function movieClipPlayAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					try{
						(container.getChildAt(i) as MovieClip).gotoAndPlay(0);
						movieClipPlayAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }
	}
	
}

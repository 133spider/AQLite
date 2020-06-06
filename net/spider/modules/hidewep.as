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
	
	public class hidewep extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.bHideWep){
				for(var playerMC:* in main.Game.world.avatars)
					if(main.Game.world.avatars[playerMC].pMC)
						if(!main.Game.world.avatars[playerMC].pMC.mcChar.weapon.visible){
							main.Game.world.avatars[playerMC].pMC.mcChar.weapon.visible = true;
                            if(main.Game.world.avatars[playerMC].pMC.pAV.getItemByEquipSlot("Weapon").sType == "Dagger")
							    main.Game.world.avatars[playerMC].pMC.mcChar.weaponOff.visible = true;
						}
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.bHideWep || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars){
                var target_mc:* = main.Game.world.avatars[playerMC];
				if(optionHandler.filterChecks["chkHideOtherWep"] || (!optionHandler.filterChecks["chkHideOtherWep"] && target_mc.isMyAvatar))
                    if(target_mc.pMC)
                        if(target_mc.pMC.mcChar.weapon.visible && target_mc.dataLeaf.intState < 2){
                            target_mc.pMC.mcChar.weapon.visible = false;
                            target_mc.pMC.mcChar.weaponOff.visible = false;
                        }else if(!target_mc.pMC.mcChar.weapon.visible && target_mc.dataLeaf.intState > 1){
                            target_mc.pMC.mcChar.weapon.visible = true;
                            if(target_mc.pMC.pAV.getItemByEquipSlot("Weapon").sType == "Dagger")
                                target_mc.pMC.mcChar.weaponOff.visible = true;
                        }
            }
		}
	}
	
}

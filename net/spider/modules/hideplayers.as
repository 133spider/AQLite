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
	
	public class hideplayers extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.hideP){
				for(var playerMC:* in main.Game.world.avatars)
					if(!main.Game.world.avatars[playerMC].isMyAvatar && main.Game.world.avatars[playerMC].pMC)
						if(!main.Game.world.avatars[playerMC].pMC.mcChar.visible){
							main.Game.world.avatars[playerMC].pMC.mcChar.visible = true;
							main.Game.world.avatars[playerMC].pMC.pname.visible = true;
							main.Game.world.avatars[playerMC].pMC.shadow.visible = true;
						}
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.hideP || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars)
				if(!main.Game.world.avatars[playerMC].isMyAvatar && main.Game.world.avatars[playerMC].pMC)
					if(main.Game.world.avatars[playerMC].pMC.mcChar.visible){
						main.Game.world.avatars[playerMC].pMC.mcChar.visible = false;
						if(!optionHandler.filterChecks["chkName"])
							main.Game.world.avatars[playerMC].pMC.pname.visible = false;
						if(optionHandler.filterChecks["chkShadow"]){
							trace("shadowed");
							main.Game.world.avatars[playerMC].pMC.shadow.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
							main.Game.world.avatars[playerMC].pMC.shadow.mouseEnabled = true;
							main.Game.world.avatars[playerMC].pMC.shadow.buttonMode = true;
						}else{
							main.Game.world.avatars[playerMC].pMC.shadow.visible = false;
						}
					}
		}

		private static function onClickHandler(e:MouseEvent):void{
            var tAvt:*;
            tAvt = e.currentTarget.parent.pAV;
            if (e.shiftKey)
            {
                main.Game.world.onWalkClick();
            }
            else
            {
                if (!e.ctrlKey)
                {
                    if (((((((!((tAvt == main.Game.world.myAvatar))) && (main.Game.world.bPvP))) && (!((tAvt.dataLeaf.pvpTeam == main.Game.world.myAvatar.dataLeaf.pvpTeam))))) && ((tAvt == main.Game.world.myAvatar.target))))
                    {
                        main.Game.world.approachTarget();
                    }
                    else
                    {
                        if (tAvt != main.Game.world.myAvatar.target)
                        {
                            main.Game.world.setTarget(tAvt);
                        }
                    }
                }
            }
        }
	}
	
}

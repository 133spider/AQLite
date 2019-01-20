package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	
	public class hideplayers extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var hideTimer:Timer;

		public static function onCreate():void{
			hideplayers.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(options.hideP){
				hideTimer = new Timer(0);
				hideTimer.addEventListener(TimerEvent.TIMER, onTimer);
				hideTimer.start();
			}else{
				hideTimer.reset();
				hideTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				for(var playerMC:* in main.Game.world.avatars)
					if(!main.Game.world.avatars[playerMC].isMyAvatar && main.Game.world.avatars[playerMC].pMC)
						if(!main.Game.world.avatars[playerMC].pMC.mcChar.visible){
							main.Game.world.avatars[playerMC].pMC.mcChar.visible = true;
							main.Game.world.avatars[playerMC].pMC.pname.visible = true;
							main.Game.world.avatars[playerMC].pMC.shadow.visible = true;
						}
			}
		}

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars)
				if(!main.Game.world.avatars[playerMC].isMyAvatar && main.Game.world.avatars[playerMC].pMC)
					if(main.Game.world.avatars[playerMC].pMC.mcChar.visible){
						main.Game.world.avatars[playerMC].pMC.mcChar.visible = false;
						if(!options.filterChecks["chkName"])
							main.Game.world.avatars[playerMC].pMC.pname.visible = false;
						main.Game.world.avatars[playerMC].pMC.shadow.visible = false;
						/**if(!main.Game.world.avatars[playerMC].pMC.shadow.hasEventListener(MouseEvent.CLICK)){
							main.Game.world.avatars[playerMC].pMC.shadow.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
							main.Game.world.avatars[playerMC].pMC.shadow.mouseEnabled = true;
						}**/
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

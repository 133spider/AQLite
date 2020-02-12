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
	
	public class dispetanim extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.bDisPetAnim){
				for(var playerMC:* in main.Game.world.avatars){
					if(!main.Game.world.avatars[playerMC].objData)
						continue;
					if(main.Game.world.avatars[playerMC].petMC){
						try{
							main.Game.world.avatars[playerMC].petMC.mcChar.gotoAndStop(0);
						    movieClipStopAll(main.Game.world.avatars[playerMC].petMC.mcChar);
						}catch(exception){}
					}
				}
			}else{
                if(main.Game.sfc.isConnected && main.Game.world.myAvatar){
                    for(var t_playerMC:* in main.Game.world.avatars){
                        if(!main.Game.world.avatars[t_playerMC].objData)
                            continue;
                        if(main.Game.world.avatars[t_playerMC].petMC){
                            try{
                                main.Game.world.avatars[t_playerMC].petMC.mcChar.gotoAndPlay(0);
                                movieClipPlayAll(main.Game.world.avatars[t_playerMC].petMC.mcChar);
                            }catch(exception){}
                        }
                    }
                }
            }
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.bDisPetAnim || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			for(var playerMC:* in main.Game.world.avatars){
				if(!main.Game.world.avatars[playerMC].objData)
					continue;
				if(optionHandler.filterChecks["chkDisPetAnim"])
					if(main.Game.world.avatars[playerMC].isMyAvatar)
						continue;
				if(main.Game.world.avatars[playerMC].petMC){
					try{
						main.Game.world.avatars[playerMC].petMC.mcChar.gotoAndStop(0);
						movieClipStopAll(main.Game.world.avatars[playerMC].petMC.mcChar);
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

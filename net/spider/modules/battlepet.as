package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.draw.cMenu;
	import net.spider.handlers.optionHandler;
	
	public class battlepet extends MovieClip{

		public static function onExtensionResponseHandler(e:*):void{
			if(!optionHandler.bBattlePet)
				return;
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
						case "ct":
							if(resObj.anims == null)
								return;
							if(!main.Game.world.myAvatar.objData.eqp["pe"])
								return;
							for each(var o:* in resObj.anims)
                           	{
								if((o.tInf.indexOf("m:") > -1) && (o.cInf.indexOf("p:") > -1)){
									if(main.Game.world.getAvatarByUserID(String(o.cInf.split(":")[1])).isMyAvatar){
										if(o.animStr == main.Game.world.actions.active[0].anim){
											if(main.Game.world.myAvatar.objData.eqp["pe"]){
												main.Game.world.myAvatar.pMC.queueAnim("PetAttack");
											}
											return;
										}
									}
								}
							}
							break;
                    }
                }
        }
	}
	
}

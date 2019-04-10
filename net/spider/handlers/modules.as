package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.modules.*;
	import net.spider.handlers.*;
	import net.spider.main;

	public class modules extends MovieClip{

		private static var maintainTimer:Timer;
		public static function create():void{
			drops.onCreate();
			skillanim.onCreate();
			hideplayers.onCreate();
			monstype.onCreate();
			qrates.onCreate();
			qprev.onCreate();
			qlog.onCreate();
			untarget.onCreate();
			chatfilter.onCreate();
			untargetself.onCreate();
			diswepanim.onCreate();
			detaildrops.onCreate();
			detailquests.onCreate();
			dismonanim.onCreate();
			bitmap.onCreate();
			cskillanim.onCreate();
			qaccept.onCreate();
			qpin.onCreate();

			options.events.dispatchEvent(new ClientEvent(ClientEvent.onEnable));
			main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
			maintainTimer = new Timer(0);
			maintainTimer.addEventListener(TimerEvent.TIMER, onMaintain);
			maintainTimer.start();
		}

		private static var houseEvent:Boolean;
		public static function onMaintain(e:TimerEvent):void{
			if(!main.Game)
				return;
			if(!main.Game.ui)
				return;
			if(!houseEvent && main.Game.ui.mcInterface.mcMenu.btnHouse){
				main.Game.ui.mcInterface.mcMenu.btnHouse.addEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = true;
			}else if(houseEvent && main.Game.currentLabel == "Login"){
				main.Game.ui.mcInterface.mcMenu.btnHouse.removeEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = false;
			}
		}

		public static function onExtensionResponseHandler(e:*):void{
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

		public static function onHouseClick(e:MouseEvent):void{
			if(main.Game.world.strMapName.toLowerCase() == "house")
				main.Game.world.moveToCell("Enter", "Spawn");
		}
	}
	
}

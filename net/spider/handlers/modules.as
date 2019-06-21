package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import net.spider.draw.theArchive;
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
			dismapanim.onCreate();
			lockmons.onCreate();

			options.events.dispatchEvent(new ClientEvent(ClientEvent.onEnable));
			main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
			maintainTimer = new Timer(0);
			maintainTimer.addEventListener(TimerEvent.TIMER, onMaintain);
			maintainTimer.start();
		}

		public static function onWheel(e:MouseEvent):void{
			var book:MovieClip = MovieClip(main.Game.ui.mcPopup.mcBook.getChildAt(0).content);
			
			if(e.delta > 0){
				book.btnLeft.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}else{
				book.btnRight.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		public static function onInvWheel(e:MouseEvent):void{
			var inv:MovieClip;
			if(main.Game.ui.mcPopup.currentLabel == "Shop"){
				inv = MovieClip(e.currentTarget.multiPanel.frames[5].mc.scr);
			}else{
				inv = MovieClip(e.currentTarget.multiPanel.frames[4].mc.scr);
			}

			if(e.delta > 0){
				for (var i:Number = 0; i < e.delta; i++) {
					inv.a1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}else{
				for (var j:Number = 0; j < (e.delta*-1); j++) {
					inv.a2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}

		public static function onBankWheel(e:MouseEvent):void{
			if(e.delta > 0){
				var oldY:Number = e.currentTarget.scr.h.y;
				for (var i:Number = 0; i < e.delta; i++) {
					MovieClip(e.currentTarget.scr).a1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				if(oldY == e.currentTarget.scr.h.y){ //fix for bank up key not working in weapons / helm tab
					e.currentTarget.scr.h.y -= (e.delta * 1.1);
					if(e.currentTarget.scr.h.y + e.currentTarget.scr.h.height > e.currentTarget.scr.b.height)
					{
						e.currentTarget.scr.h.y = int(e.currentTarget.scr.b.height - e.currentTarget.scr.h.height);
					}
					if(e.currentTarget.scr.h.y < 0)
					{
						e.currentTarget.scr.h.y = 0;
					}
				}
			}else{
				for (var j:Number = 0; j < (e.delta*-1); j++) {
					MovieClip(e.currentTarget.scr).a2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}

		public static function onBtArchive(e:MouseEvent):void{
			var book:MovieClip = MovieClip(main.Game.ui.mcPopup.mcBook.getChildAt(0).content);
			var _archive:theArchive = new theArchive();
			main._stage.addChild(_archive);
			book.questList.removeEventListener(Event.ENTER_FRAME, book.dEF);
			book.btnBack.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public static function _func_flag(e:MouseEvent):void{
			trace("Garbage temporary function flag for btnQuests");
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

			if(main.Game.ui.mcPopup.currentLabel == "Book"){
				if(main.Game.ui.mcPopup.mcBook){
					var book:MovieClip = MovieClip(main.Game.ui.mcPopup.mcBook.getChildAt(0).content);
					if(book.btnRight){
						if(!book.btnRight.hasEventListener(MouseEvent.MOUSE_WHEEL)){
							main._stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
						}
					}
					if(book.btnQuests && !book.btnQuests.hasEventListener(MouseEvent.DOUBLE_CLICK)){
						book.btnQuests.addEventListener(MouseEvent.CLICK, onBtArchive, false, 0, true);
						book.btnQuests.addEventListener(MouseEvent.DOUBLE_CLICK, _func_flag, false, 0, true);
					}
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Inventory")
			{
				if(main.Game.ui.mcPopup.getChildByName("mcInventory")){
					if(!MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).hasEventListener(MouseEvent.MOUSE_WHEEL)){
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
					}
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Shop")
			{
				if(!MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).hasEventListener(MouseEvent.MOUSE_WHEEL)){
					MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Bank")
			{
				if(main.Game.ui.mcPopup.getChildByName("mcBank")){
					var bank:MovieClip = MovieClip(main.Game.ui.mcPopup.getChildByName("mcBank").bankPanel.frames[1].mc);
					var inv:MovieClip = MovieClip(main.Game.ui.mcPopup.getChildByName("mcBank").bankPanel.frames[7].mc);
					if(!bank.hasEventListener(MouseEvent.MOUSE_WHEEL)){
						bank.addEventListener(MouseEvent.MOUSE_WHEEL, onBankWheel, false, 0, true);
					}
					if(!inv.hasEventListener(MouseEvent.MOUSE_WHEEL)){
						inv.addEventListener(MouseEvent.MOUSE_WHEEL, onBankWheel, false, 0, true);
					}
				}
			}

			if(!main.Game.world)
				return;
			if(!main.Game.world.map)
				return;
			var ctr:Number = 0;
			while(ctr < main.Game.world.map.numChildren){
				if(main.Game.world.map.getChildAt(ctr) is MovieClip && main.Game.world.map.getChildAt(ctr).width >= 960
					&& !main.Game.world.map.getChildAt(ctr).visible
					&& (getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("mcShadow") == -1)){
					main.Game.world.map.getChildAt(ctr).visible = true;
				}
				if(getQualifiedClassName(main.Game.world.map.getChildAt(ctr)).indexOf("Bitmap") > -1
					&& main.Game.world.map.getChildAt(ctr).visible){
					main.Game.world.map.getChildAt(ctr).visible = false;
				}
				ctr++;
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
						case "bookInfo":
							main.Game.world.bookData.HMBadge.sortOn("strName");
							main.Game.world.bookData.OBadge.sortOn("strName");
							main.Game.world.bookData.AchBadge.sortOn("strName");
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

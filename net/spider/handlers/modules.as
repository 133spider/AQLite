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
		private static var moduleList:Array;
		public static function create():void{

			optionHandler.onCreate();

			moduleList = [
				{
					moduleClass: passives,
					moduleType: "Frame"
				},
				{
					moduleClass: drops,
					moduleType: "Frame"
				},
				{
					moduleClass: skillanim,
					moduleType: "Timer"
				},
				{
					moduleClass: hideplayers,
					moduleType: "Frame"
				},
				{
					moduleClass: monstype,
					moduleType: "Frame"
				},
				{
					moduleClass: qrates,
					moduleType: "Frame"
				},
				{
					moduleClass: qprev,
					moduleType: "Frame"
				},
				{
					moduleClass: qlog,
					moduleType: ""
				},
				{
					moduleClass: untarget,
					moduleType: "Timer"
				},
				{
					moduleClass: chatfilter,
					moduleType: "Frame"
				},
				{
					moduleClass: untargetself,
					moduleType: "Timer"
				},
				{
					moduleClass: diswepanim,
					moduleType: "Frame"
				},
				{
					moduleClass: detaildrops,
					moduleType: "Frame"
				},
				{
					moduleClass: detailquests,
					moduleType: "Frame"
				},
				{
					moduleClass: dismonanim,
					moduleType: "Frame"
				},
				{
					moduleClass: bitmap,
					moduleType: "Frame"
				},
				{
					moduleClass: cskillanim,
					moduleType: "Timer"
				},
				{
					moduleClass: qaccept,
					moduleType: ""
				},
				{
					moduleClass: qpin,
					moduleType: "Frame"
				},
				{
					moduleClass: dismapanim,
					moduleType: "Frame"
				},
				{
					moduleClass: lockmons,
					moduleType: "Timer"
				},
				{
					moduleClass: smoothbg,
					moduleType: "Frame"
				},
				{
					moduleClass: colorsets,
					moduleType: "Frame"
				},
				{
					moduleClass: boosts,
					moduleType: "Timer"
				},
				{
					moduleClass: hidemonsters,
					moduleType: "Frame"
				},
				{
					moduleClass: hidepnames,
					moduleType: "Frame"
				}
			]

			for each(var _module:* in moduleList){
				_module.moduleClass.onCreate();
			}

			optionHandler.events.dispatchEvent(new ClientEvent(ClientEvent.onEnable));
			main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);

			main._stage.addEventListener(Event.ENTER_FRAME, onMaintainFrame);

			maintainTimer = new Timer(0);
			maintainTimer.addEventListener(TimerEvent.TIMER, onMaintainTimer);
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
			var inv:MovieClip = MovieClip(e.currentTarget.scr);

			if(e.delta > 0){
				if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
					e.currentTarget.scr.h.y -= ((e.delta*3) * 1.1);
					if(e.currentTarget.scr.h.y + e.currentTarget.scr.h.height > e.currentTarget.scr.b.height)
					{
						e.currentTarget.scr.h.y = int(e.currentTarget.scr.b.height - e.currentTarget.scr.h.height);
					}
					if(e.currentTarget.scr.h.y < 0)
					{
						e.currentTarget.scr.h.y = 0;
					}
					return;
				}
				for (var i:Number = 0; i < e.delta; i++) {
					inv.a1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}else{
				for (var j:Number = 0; j < (e.delta*-1); j++) {
					inv.a2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}

		public static function onQuestWheel(e:MouseEvent):void{
			var quest:MovieClip = MovieClip(e.currentTarget.scr);
			quest.h.y  += (e.delta*-1)*3;

			if(quest.h.y < 0)
				quest.h.y = 0;
			if(quest.h.y + quest.h.height > quest.b.height)
				quest.h.y = int(quest.b.height - quest.h.height);
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

		private static var performOnceFlag:Boolean = false;
		public static function onMaintainFrame(e:Event):void{
			if(!main.Game || !main.Game.ui)
				return;

			for each(var _module:* in moduleList){
				if(_module.moduleType == "Frame"){
					_module.moduleClass.onFrameUpdate();
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Book"){
				if(main.Game.ui.mcPopup.mcBook){
					var book:MovieClip = MovieClip(main.Game.ui.mcPopup.mcBook.getChildAt(0).content);
					if(book){
						if(book.btnRight){
							if(!book.btnRight.hasEventListener(MouseEvent.MOUSE_WHEEL)){
								main._stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
							}
						}
						if(book.btnQuests && !book.btnQuests.hasEventListener(MouseEvent.DOUBLE_CLICK)){
							if(optionHandler.bTheArchive){
								book.btnQuests.addEventListener(MouseEvent.CLICK, onBtArchive, false, 0, true);
							}
							book.btnQuests.addEventListener(MouseEvent.DOUBLE_CLICK, _func_flag, false, 0, true);
						}
					}
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Inventory")
			{
				if(main.Game.ui.mcPopup.getChildByName("mcInventory")){
					if(!MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory").multiPanel.frames[4].mc).hasEventListener(MouseEvent.MOUSE_WHEEL)){
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory").multiPanel.frames[4].mc).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory").splitPanel.frames[2].mc).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
					}
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "Shop")
			{
				if(main.Game.ui.mcPopup.getChildByName("mcShop")){
					if(!MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop").multiPanel.frames[5].mc).hasEventListener(MouseEvent.MOUSE_WHEEL)){
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop").multiPanel.frames[5].mc).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop").splitPanel.frames[2].mc).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
					}
				}
			}

			if(main.Game.ui.mcPopup.currentLabel == "MergeShop")
			{
				if(main.Game.ui.mcPopup.getChildByName("mcShop")){
					if(!MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop").mergePanel.frames[8].mc).hasEventListener(MouseEvent.MOUSE_WHEEL)){
						MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop").mergePanel.frames[8].mc).addEventListener(MouseEvent.MOUSE_WHEEL, onInvWheel, false, 0, true);
					}
				}
			}

			if (main.Game.ui.ModalStack.numChildren)
			{
				var frame:MovieClip = main.Game.ui.ModalStack.getChildAt(0);
				if(!MovieClip(frame.cnt).hasEventListener(MouseEvent.MOUSE_WHEEL)){
					MovieClip(frame.cnt).addEventListener(MouseEvent.MOUSE_WHEEL, onQuestWheel, false, 0, true);
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

			if(main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor") && !performOnceFlag){
                main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.addEventListener("ROLL_OVER",onItemRollOver,false,0,true);
                main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.addEventListener("ROLL_OUT",onItemRollOut,false,0,true);
			    performOnceFlag = true;
            }else if(performOnceFlag && !main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor")){
                performOnceFlag = false;
            }
		}
		
		private static var houseEvent:Boolean;
		public static function onMaintainTimer(e:TimerEvent):void{
			if(!main.Game || !main.Game.ui)
				return;
			
			for each(var _module:* in moduleList){
				if(_module.moduleType == "Timer"){
					_module.moduleClass.onTimerUpdate();
				}
			}

			if(!houseEvent && main.Game.ui.mcInterface.mcMenu.btnHouse){
				main.Game.ui.mcInterface.mcMenu.btnHouse.addEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = true;
			}else if(houseEvent && main.Game.currentLabel == "Login"){
				main.Game.ui.mcInterface.mcMenu.btnHouse.removeEventListener(MouseEvent.CLICK, onHouseClick);
				houseEvent = false;
			}

			if(optionHandler.cleanRep && !main.Game.world.myAvatar.factions.hasOwnProperty("cleaned")){
				for each(var faction:* in main.Game.world.myAvatar.factions){
					if(faction.iRank == "10"){
						faction.iSpillRep = 0;
					}
					if(faction.sName == "Blacksmithing" && faction.iRank == "4"){
						faction.iSpellRep = 0;
						faction.iRepToRank = 0;
						faction.iRank = "10";
					}
				}
				main.Game.world.myAvatar.factions.cleaned = true;
			}
		}

		public static function onItemRollOver(param1:Event) : void
        {
            var _loc2_:* = new Object();
            var avt:* =  main.Game.world.myAvatar;
            _loc2_.intColorSkin = avt.objData.intColorSkin;
            _loc2_.intColorHair = avt.objData.intColorHair;
            _loc2_.intColorEye = avt.objData.intColorEye;
            _loc2_.intColorBase = avt.objData.intColorBase;
            _loc2_.intColorTrim = avt.objData.intColorTrim;
            _loc2_.intColorAccessory = param1.target.selectedColor;
            avt.pMC.updateColor(_loc2_);
        }
        
        public static function onItemRollOut(param1:Event) : void
        {
            main.Game.world.myAvatar.pMC.updateColor();
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
							if(optionHandler.alphaBOL){
								main.Game.world.bookData.HMBadge.sortOn("strName");
								main.Game.world.bookData.OBadge.sortOn("strName");
								main.Game.world.bookData.AchBadge.sortOn("strName");
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

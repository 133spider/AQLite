package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import fl.managers.StyleManager;
	import fl.controls.*;
	import flash.text.*;
    import net.spider.main;
    import net.spider.draw.*;
    import net.spider.handlers.*;
	import com.adobe.utils.StringUtil;
	
	public class dynamicoptions extends MovieClip {
		public var optObj;
      	public var optItem:*;
		public var Len;
		public var optionList;

		public var hRun:Number;
		public var dRun:Number;
		public var oy:Number;
		public var mDown:Boolean;
		public var mbY:int;
		public var mbD:int;
		public var mhY:int;
		public var pos:int;
		public var i:int;

		public var optionGet:Vector.<Object>;

		private var toolTip:ToolTipMC;
		private var toolTipMC:*;
		public function dynamicoptions() {
			toolTip = new ToolTipMC();
			toolTipMC = this.addChild(toolTip);
            this.txtSearch.textField.background = true;
            this.txtSearch.textField.backgroundColor = 0x111111;

			initOptions();

			redraw(optionGet);
			SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,onScrDown,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_UP,onScrUp,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
			optionList.addEventListener(Event.ENTER_FRAME,hEF,false,0,true);
			optionList.addEventListener(Event.ENTER_FRAME,dEF,false,0,true);
			txtSearch.addEventListener(Event.CHANGE, onSearch, false, 0, true);
            btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);

			 if(main.isUpdated == false){
                this.txtVersion.appendText(" (OUTDATED)");
                this.txtVersion.textColor = 0xFF0000;
                this.txtVersion.addEventListener(MouseEvent.CLICK, onGotoRelease);
            }
		}

		public function initOptions():void{
			optionGet = new <Object>[
				{
					strName: "Draggable Drops",
					bEnabled: main.sharedObject.data.draggable,
					sDesc: "Allows you to drag the drops on your screen using your mouse"
				},
				{
					strName: "Detailed Item Drops",
					bEnabled: main.sharedObject.data.detaildrop,
					sDesc: "Identifies dropped items if they're member only, ac, or both\nYou must have your items in your bank LOADED for it to detect them!"
				},
				{
					strName: "Enhanced Item Descriptions",
					bEnabled: main.sharedObject.data.boost,
					sDesc: "Adds item stack amount and extra information to the item descriptions of the items in your inventory"
				},
				{
					strName: "Quest Drop Rates",
					bEnabled: main.sharedObject.data.qRates,
					sDesc: "Replaces AQW's Quest Drop Rates with AQLite's original Quest Drop Rates"
				},
				{
					strName: "Quest Reward Previews",
					bEnabled: main.sharedObject.data.qPrev,
					sDesc: "Allows you to click on quest rewards to preview their appearance. You can preview the equipment if you click on the '?' button!\nThe UI is draggable!"
				},
				{
					strName: "Detailed Quest Rewards",
					bEnabled: main.sharedObject.data.detailquest,
					sDesc: "Identifies quest rewards if they're member only, ac, or both\nA checkmark will appear if you already own the item in the bank/inv\nYou must have your items in your bank LOADED for it to detect them!"
				},
				{
					strName: "Allow Quest Log Turn-Ins",
					bEnabled: main.sharedObject.data.qLog,
					sDesc: "Keybind: L\nAllows you to turn-in quests using your quest log on the bottom right screen! Replacement for quest glitch!"
				},
				{
					strName: "Reaccept Quest After Turn-In",
					bEnabled: main.sharedObject.data.qAccept,
					sDesc: "After turning in a quest, it will try to reaccept the quest if possible"
				},
				{
					strName: "Quest Pinner",
					bEnabled: main.sharedObject.data.qPin,
					sDesc: "A replacement for quest box glitching.\n1. Open quests from any NPC\n2. Press the \"Pin Quests\" button (left)\n3. You can now access it from anywhere by clicking on the yellow (!) quest log icon at the top left!\nShift+Click the yellow (!) quest log icon to open the Quest Tracker!"
				},
				{
					strName: "Disable Skill Animations",
					bEnabled: main.sharedObject.data.disableSkillAnim,
					sDesc: "Disables class skill animations",
					extra: [
						{
							strName: "Show Your Skill Animations Only",
							bEnabled: main.sharedObject.data.filterChecks["chkSelfOnly"],
							sDesc: "Only works if \"Disable Skill Animations\" is enabled!\nAdds an exception to \"Disable Skill Animations\" to show your skill animations only"
						}
					]
				},
				{
					strName: "Custom Skill Animations",
					bEnabled: main.sharedObject.data.cSkillAnim,
					sDesc: "Currently only supported classes: DragonLord, Void Highlord\nVoid Highlord brings back its graphic heavy skill animations!"
				},
				{
					strName: "Disable Monster Animations",
					bEnabled: main.sharedObject.data.disMonAnim,
					sDesc: "Disables monster animations"
				},
				{
					strName: "Class Actives/Auras UI",
					bEnabled: main.sharedObject.data.skill,
					sDesc: "Show buffs/passives and their stacks like your average MMO's buff/passive tracker"
				},
				{
					strName: "Freeze / Lock Monster Position",
					bEnabled: main.sharedObject.data.lockM,
					sDesc: "This will freeze monsters on the map in place to prevent players from luring/dragging monsters all over the map"
				},
				{
					strName: "Monster Type",
					bEnabled: main.sharedObject.data.mType,
					sDesc: "Shows the monster type of your target"
				},
				{
					strName: "Auto-Untarget Dead Targets",
					bEnabled: main.sharedObject.data.untargetMon,
					sDesc: "This will untarget targets that are already dead"
				},
				{
					strName: "Auto-Untarget Self-Targetting",
					bEnabled: main.sharedObject.data.selfTarget,
					sDesc: "This will prevent you from targetting yourself whatsoever"
				},
				{
					strName: "Custom Drops UI",
					bEnabled: main.sharedObject.data.cDrops,
					sDesc: "A reimagined UI of AQW's drops\nShift+Click to blacklist an item!\nYou must have your items in your bank LOADED for it to detect them!",
					extra: [
						{
							strName: "Drop Notifications",
							bEnabled: main.sharedObject.data.filterChecks["chkCDropNotification"],
							sDesc: "Every new non-temporary item drop will have a drop notification accompanied with it"
						},
						{
							strName: "Hide Temp Drop Notifications",
							bEnabled: main.sharedObject.data.filterChecks["chkCTempDropNotification"],
							sDesc: "This will hide temporary item drop notifications"
						},
						{
							strName: "Warn When Declining A Drop",
							bEnabled: main.sharedObject.data.filterChecks["chkCDecline"],
							sDesc: "This will spawn a pop-up box that will ask you to confirm if you want to decline the item drop"
						}
					]
				},
				{
					strName: "SBP's Custom Drops UI",
					bEnabled: main.sharedObject.data.sbpcDrops,
					sDesc: "Inspired by SharpBladePoint on r/AQW\nA reimagined UI of AQW's drops\nShift+Click to blacklist an item!\nYou must have your items in your bank LOADED for it to detect them!",
					extra: [
						{
							strName: "Invert Menu",
							bEnabled: main.sharedObject.data.filterChecks["chkInvertDrop"],
							sDesc: "This will change SBP's Custom Drops UI's drop menu from having the list go downward to having the list go upward instead"
						},
						{
							strName: "Attached Menu",
							bEnabled: main.sharedObject.data.filterChecks["chkAttachMenu"],
							sDesc: "Attaches SBP's UI to the Game's UI"
						},
						{
							strName: "(SBP)Warn When Declining A Drop",
							bEnabled: main.sharedObject.data.filterChecks["chkSBPDecline"],
							sDesc: "This will spawn a pop-up box that will ask you to confirm if you want to decline the item drop"
						},
						{
							strName: "Hide All Drop Notifications",
							bEnabled: main.sharedObject.data.filterChecks["chkSBPDropNotification"],
							sDesc: "This will hide temporary item drop notifications"
						},
						{
							strName: "Reset Position",
							extra: "btn",
							sDesc: "If the Drop UI somehow goes off-screen and you can't see it"
						}
					]
				},
				{
					strName: "Hide Players",
					bEnabled: main.sharedObject.data.hideP,
					sDesc: "This will hide players on the map\nToggling it off will show players again\nYou can hide specific players by clicking on their portraits (targetting them)!",
					extra: [
						{
							strName: "Show Name Tags",
							bEnabled: main.sharedObject.data.filterChecks["chkName"],
							sDesc: "Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see name tags of players even though they're hidden. This setting also works if you hide specific players by targetting them and clicking on their portraits."
						},
						{
							strName: "Show Shadows",
							bEnabled: main.sharedObject.data.filterChecks["chkShadow"],
							sDesc: "Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see player shadows and clicking on the shadows will target them. This setting also works if you hide specific players by targetting them and clicking on their portraits."
						}
					]
				},
				{
					strName: "Disable Weapon Animations",
					bEnabled: main.sharedObject.data.disWepAnim,
					sDesc: "Disables weapon animations\nYou can disable a specific player's weapon animations by targetting them and clicking on their portrait!",
					extra: [
						{
							strName: "Keep Your Weapon Animations Only",
							bEnabled: main.sharedObject.data.filterChecks["chkDisWepAnim"],
							sDesc: "Only works if \"Disable Weapon Animation\" is enabled!\nHaving this enabled will allow your weapon animations to continue working while others have theirs disabled"
						}
					]
				},
				{
					strName: "Disable Map Animations",
					bEnabled: main.sharedObject.data.disMapAnim,
					sDesc: "Disables map animations"
				},
				{
					strName: "Cache Players",
					bEnabled: main.sharedObject.data.bitmapP,
					sDesc: "Reduces the graphics of other players and freezes them in place. Useful if you still want to see other players, but want increased performance that \"Hide Players\" gives.\n!WARNING! Having this enabled may or may not show some of other player's equipments (Missing helmets, etc). You will not be able to see their equipment changes with this enabled either. You can not click on other players with this enabled."
				},
				{
					strName: "Disable Sound FX",
					bEnabled: main.sharedObject.data.disableFX,
					sDesc: "Disables the sound effects in the game for you to enjoy the game's music"
				},
				{
					strName: "Display FPS",
					extra: "btn",
					sDesc: "Toggles the Frames Per Second Display"
				},
				{
					strName: "Color Picker",
					extra: "btn",
					sDesc: "Allow you to retrieve hex color codes and RGB values of what you click with your mouse"
				},
				{
					strName: "Decline All Drops",
					extra: "btn",
					sDesc: "Declines all the drops on your screen"
				},
				{
					strName: "Item Drops Blacklist",
					extra: "btn",
					sDesc: "Auto-Declines / blocks drops that you do not want"
				},
				{
					strName: "Smooth Background",
					bEnabled: main.sharedObject.data.smoothBG,
					sDesc: "Removes the pixels in the map"
				},
				{
					strName: "Color Sets",
					bEnabled: main.sharedObject.data.bColorSets,
					sDesc: "A feature that lets you save and load color sets for armor/hair customizing! If enabled, it will appear when you go to customize your armor/hair"
				},
				{
					strName: "Alphabetize Book of Lore",
					bEnabled: main.sharedObject.data.alphBOL,
					sDesc: "Will sort all the Book of Lore badges into alphabetical order"
				},
				{
					strName: "Hide Monsters",
					bEnabled: main.sharedObject.data.hideM,
					sDesc: "Hide monsters. You can target them by clicking on their shadow."
				},
				{
					strName: "The Archive",
					bEnabled: main.sharedObject.data.theArchive,
					sDesc: "A collection of forgotten/hidden/unpopular maps. If enabled, it can be found in Book of Lore -> Quests."
				},
				{
					strName: "Clean Reputation List",
					bEnabled: main.sharedObject.data.cleanRep,
					sDesc: "Cleans the reputation list by making sure Rank 10's are displayed as 0/0\nBlacksmithing only goes up to Rank 4 and will be displayed as Rank 10\nIf you switch this to disabled, relogging in is required for changes to take effect"
				},
				{
					strName: "Camera Tool",
					extra: "btn",
					sDesc: "WIP"
				},
				{
					strName: "Hide Player Names",
					bEnabled: main.sharedObject.data.hidePNames,
					sDesc: "Hides player names\nHover over a player to reveal their name & guild",
					extra: [
						{
							strName: "Hide Guild Names Only",
							bEnabled: main.sharedObject.data.filterChecks["chkGuild"],
							sDesc: "Player names will be visible, and guild names will be hidden"
						}
					]
				},
				{
					strName: "Battlepets",
					bEnabled: main.sharedObject.data.bBattlePet,
					sDesc: "Allows battlepets to fight alongside you in battle without having to equip a battlepet class!"
				},
				{
					strName: "House Entrance Teleport",
					bEnabled: main.sharedObject.data.bHouseEntrance,
					sDesc: "While already in your house, if you click on the house icon (the same one you use to go to your house), you can teleport to the entrance of your house!"
				},
				{
					strName: "Display Memory Usage",
					extra: "btn",
					sDesc: "Toggles the Memory Usage Display"
				},
				{
					strName: "Disable Quest Tracker",
					bEnabled: main.sharedObject.data.bDisQuestTracker,
					sDesc: "Prevents the Quest Tracker from popping up"
				},
				{
					strName: "Quest Progress Notifications",
					bEnabled: main.sharedObject.data.bQuestNotif,
					sDesc: "Quest Progress will continue to notify/update you even when you've completed the quest"
				},
				{
					strName: "Open Bank with Keybind",
					bEnabled: main.sharedObject.data.bBankKey,
					sDesc: "If you have a bank pet in your inventory (or a bank cape), pressing b on your keyboard will open the bank regardless if you have the pet equipped or not"
				},
				{
					strName: "Disable Pet Animations",
					bEnabled: main.sharedObject.data.bDisPetAnim,
					sDesc: "Disables pet animations\nYou can disable a specific player's pet animations by targetting them and clicking on their portrait!",
					extra: [
						{
							strName: "Keep Your Pet Animations Only",
							bEnabled: main.sharedObject.data.filterChecks["chkDisPetAnim"],
							sDesc: "Only works if \"Disable Pet Animation\" is enabled!\nHaving this enabled will allow your pet animations to continue working while others have theirs disabled"
						}
					]
				},
				{
					strName: "Travel Menu",
					extra: "btn",
					sDesc: "Jump between multiple maps in an efficient manner"
				},
				{
					strName: "Transparent Quest Box",
					bEnabled: main.sharedObject.data.bTransQuest,
					sDesc: "If you are in combat and you have the quest window open, it will allow you to click through it while being transparent"
				},
				{
					strName: "Better Mounts",
					bEnabled: main.sharedObject.data.bBetterMounts,
					sDesc: "Keybind: M\nGives mount armors a client-sided 160% movement speed (Disabled in PvP)\nOther players will still see you with regular walking speed!\nSummon Mount icon will appear on the top left and will revert back to your original armor when struck in combat\nSet your primary mount by going to your inventory, selecting a mount armor, and clicking on the Set Mount button icon! If there is no Set Mount button icon, the armor is not a mount.\nPrimary mounts are saved by your username.",
					extra: [
						{
							strName: "Force Basic Rider Animation",
							bEnabled: main.sharedObject.data.filterChecks["chkBasicRiderAnim"],
							sDesc: "Some mount armors do not have a default rider animation (Dread Gryphon Rider armors) so you can choose to force those animations here!\nYou can also force these animations if you do not like the default rider animation (although it may be buggy)\nOnly one of these options can be turned on."
						},
						{
							strName: "Force Horse Rider Animation",
							bEnabled: main.sharedObject.data.filterChecks["chkHorseRiderAnim"],
							sDesc: "Some mount armors do not have a default rider animation (Dread Gryphon Rider armors) so you can choose to force those animations here!\nYou can also force these animations if you do not like the default rider animation (although it may be buggy)\nOnly one of these options can be turned on."
						}
					]
				},
				{
					strName: "Disable Chat Mouse Scrolling",
					bEnabled: main.sharedObject.data.bDisChatScroll,
					sDesc: "Disables the mouse scroll wheel on the Chat"
				},
				{
					strName: "World Camera",
					extra: "btn",
					sDesc: "WIP\nYou can have Color Picker open while using this feature"
				},
				{
					strName: "Hide Weapon If Not In-Combat",
					bEnabled: main.sharedObject.data.bHideWep,
					sDesc: "Hides your weapon when you're not in combat",
					extra: [
						{
							strName: "Hide Other Players' Weapons",
							bEnabled: main.sharedObject.data.filterChecks["chkHideOtherWep"],
							sDesc: "Hide other players' weapons when they're not in combat"
						}
					]
				},
				{
					strName: "Custom Chat UI",
					bEnabled: main.sharedObject.data.bCChat,
					sDesc: "WIP",
					extra: [
						{
							strName: "Message Timestamps",
							bEnabled: main.sharedObject.data.filterChecks["chkTimestamp"],
							sDesc: "Suggested by u/chickeniggets from r/AQW"
						}
					]
				},
				{
					special: 1,
					strName: "Char Page",
					sDesc: "Search Character Pages"
				}
			];
		}

        public function onGotoRelease(e:MouseEvent):void{
            navigateToURL(new URLRequest("https://github.com/133spider/AQLite/releases/latest"), "_blank");
        }

        public function onClose(evt:MouseEvent):void{
			this.parent.removeChild(this);
            main.Game.ui.mcPopup.onClose();
        }

		public function onOver(e:MouseEvent):void{
			try{
				if(!e.target.parent.sDesc)
					return;
				toolTip.openWith({str:e.target.parent.sDesc});
			}catch(e){}
		}

		public function onOut(e:MouseEvent){
            toolTip.close();
        }

		public function orderName(a, b):int 
		{ 
			var name1 = a["strName"]; 
			var name2 = b["strName"]; 
			if (name1 < name2) 
			{ 
				return -1; 
			} 
			else if (name1 > name2) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		} 

		public function redraw(filteredArray:Vector.<Object>):void{
			SBar.h.y = 0;
			if(optionList != null){
				this.removeChild(optionList);
				optionList = null;
			}
			optionList = this.addChild(new MovieClip());
			setChildIndex(toolTipMC, numChildren-1);
			Len = filteredArray.length;
			filteredArray.sort(orderName);
			i = 0;
			var item:*;
			var posI:* = 0;
			while(i < Len)
			{
				optObj = filteredArray[i];
				switch(true){
					case (optObj.hasOwnProperty("special")):
						optItem = new listOptionsItemTxt(optObj.sDesc);
						optItem.txtName.text = optObj.strName;
						item = optionList.addChild(optItem);
						item.x = cntMask.x;
						item.y = cntMask.y+(35 * posI);
						item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
						item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
					break;
					case (optObj.hasOwnProperty("extra") && optObj.extra is String):
						optItem = new listOptionsItemBtn(optObj.sDesc);
						optItem.txtName.text = optObj.strName;
						item = optionList.addChild(optItem);
						item.x = cntMask.x;
						item.y = cntMask.y+(35 * posI);
						item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
						item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
					break;
					case (optObj.hasOwnProperty("extra") && optObj.extra is Array):
						optItem = new listOptionsItem(optObj.bEnabled, optObj.sDesc);
						optItem.txtName.text = optObj.strName;
						item = optionList.addChild(optItem);
						item.x = cntMask.x;
						item.y = cntMask.y+(35 * posI);
						item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
						item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);

						for(var j:int = 0; j < optObj.extra.length; j++){
							posI++;
							if(optObj.extra[j].hasOwnProperty("extra")){
								optItem = new listOptionsItemExtraBtn(optObj.extra[j].sDesc);
							}else{
								optItem = new listOptionsItemExtra(optObj.extra[j].bEnabled, optObj.extra[j].sDesc);
							}
							optItem.txtName.text = optObj.extra[j].strName;
							item = optionList.addChild(optItem);
							item.x = cntMask.x+9;
							item.y = cntMask.y+(35 * posI);
							item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
							item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
						}
					break;
					default: 
						optItem = new listOptionsItem(optObj.bEnabled, optObj.sDesc);
						optItem.txtName.text = optObj.strName;
						item = optionList.addChild(optItem);
						item.x = cntMask.x;
						item.y = cntMask.y+(35 * posI);
						item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
						item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
					break;
				}
				i++;
				posI++;
			}
			optionList.mask = cntMask;

			mDown = false;
			hRun = SBar.b.height - SBar.h.height;
			dRun = optionList.height - cntMask.height + 5;
			oy = optionList.y;

			optionList.addEventListener(Event.ENTER_FRAME,hEF,false,0,true);
			optionList.addEventListener(Event.ENTER_FRAME,dEF,false,0,true);
		}

		public function onSearch(e:Event):void{
			this.txtSearch.textField.setTextFormat(new TextFormat("Arial", 16, 0xFFFFFF), this.txtSearch.textField.caretIndex-1);
			initOptions();
			var element_ctr:Number = 0;
			var _tempArray:Vector.<Object> = new Vector.<Object>();
			for(var k:int = 0; k < optionGet.length; k++){
				if(optionGet[k].strName.toLowerCase().indexOf(txtSearch.text.toLowerCase()) > -1){
					_tempArray.push(optionGet[k]);
					element_ctr += (optionGet[k].extra ? (1 + (optionGet[k].extra.length)) : 1);
				}
			}
			if(element_ctr <= 9){
				SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN,onScrDown);
				this.removeEventListener(MouseEvent.MOUSE_UP,onScrUp);
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			}else if(element_ctr > 9 && !SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN)){
				SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,onScrDown,false,0,true);
				this.addEventListener(MouseEvent.MOUSE_UP,onScrUp,false,0,true);
				this.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
			}
			redraw(!txtSearch.text ? optionGet : _tempArray);
			_tempArray = null;
		}

		public function onWheel(e:MouseEvent):void{
			var _local2:*;
			_local2 = SBar;
			_local2.h.y = int(SBar.h.y) + ((e.delta*3) * -1);
			if (((_local2.h.y) + _local2.h.height) > (_local2.b.height)){
				_local2.h.y = int(((_local2.b.height) - _local2.h.height));
			}
			if (_local2.h.y < 0){
				_local2.h.y = 0;
			}
		}
		
		var sDown:Boolean;
		public function onScrDown(param1:MouseEvent) : *
		{
			mbY = int(mouseY);
			mhY = int(SBar.h.y);
			mDown = true;
		}
		
		public function onScrUp(param1:MouseEvent) : void
		{
			mDown = false;
		}
		
		public function hEF(_arg1:Event){
			var _local2:*;
			if (mDown){
				_local2 = SBar;
				mbD = (int(mouseY) - mbY);
				_local2.h.y = (mhY + mbD);
				if (((_local2.h.y + 1) + _local2.h.height) > (_local2.b.height + 1)){
					_local2.h.y = int(((_local2.b.height + 1) - _local2.h.height));
				}
				if (_local2.h.y < 1){
					_local2.h.y = 1;
				}
			}
		}

		public function dEF(_arg1:Event){
			var _local2:* = SBar;
			var _local3:* = optionList;
			var _local4:* = (-((_local2.h.y - 1)) / hRun);
			var _local5:* = (int((_local4 * dRun)) + oy);
			if (Math.abs((_local5 - _local3.y)) > 0.2){
				_local3.y = (_local3.y + ((_local5 - _local3.y)/4));
			} else {
				_local3.y = _local5;
			}
		}
}
	
}

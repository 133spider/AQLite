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
	
	public class qaccept extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
		public static function onCreate():void{
			qaccept.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(optionHandler.qAccept){
				main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
			}else{
				main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
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
						case "ccqr":
							if(resObj.bSuccess != 0)
							{
								if(main.Game.world.questTree[resObj.QuestID]){
									if(!main.Game.world.questTree[resObj.QuestID].bOnce){
										if(getQuestValidationString(main.Game.world.questTree[resObj.QuestID]) == ""){
											main.Game.world.acceptQuest(int(resObj.QuestID));
										}
									}
								}
							}
							break;
                    }
                }
        }

		private static function getQuestValidationString(param1:Object) : String
		{
			var rootClass:* = main.Game;
			var world:* = main.Game.world;
			var _loc2_:int = 0;
			var _loc3_:* = undefined;
			var _loc4_:int = 0;
			var _loc5_:* = undefined;
			var _loc6_:* = null;
			var _loc7_:int = 0;
			var _loc8_:Object = null;
			var _loc9_:int = 0;
			var _loc10_:int = 0;
			var _loc11_:* = undefined;
			if(param1.sField != null && world.getAchievement(param1.sField,param1.iIndex) != 0)
			{
				if(param1.sField == "im0")
				{
				return "Monthly Quests are only available once per month.";
				}
				return "Daily Quests are only available once per day.";
			}
			if(param1.bUpg == 1 && !world.myAvatar.isUpgraded())
			{
				return "Upgrade is required for this quest!";
			}
			if(param1.iSlot >= 0 && world.getQuestValue(param1.iSlot) < param1.iValue - 1)
			{
				return "Quest has not been unlocked!";
			}
			if(param1.iLvl > world.myAvatar.objData.intLevel)
			{
				return "Unlocks at Level " + param1.iLvl + ".";
			}
			if(param1.iClass > 0 && world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP)
			{
				_loc2_ = rootClass.getRankFromPoints(param1.iReqCP);
				_loc3_ = param1.iReqCP - rootClass.arrRanks[_loc2_ - 1];
				if(_loc3_ > 0)
				{
				return "Requires " + _loc3_ + " Class Points on " + param1.sClass + ", Rank " + _loc2_ + ".";
				}
				return "Requires " + param1.sClass + ", Rank " + _loc2_ + ".";
			}
			if(param1.FactionID > 1 && world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
			{
				_loc4_ = rootClass.getRankFromPoints(param1.iReqRep);
				_loc5_ = param1.iReqRep - rootClass.arrRanks[_loc4_ - 1];
				if(_loc5_ > 0)
				{
				return "Requires " + _loc5_ + " Reputation for " + param1.sFaction + ", Rank " + _loc4_ + ".";
				}
				return "Requires " + param1.sFaction + ", Rank " + _loc4_ + ".";
			}
			if(param1.reqd != null && !hasRequiredItemsForQuest(param1))
			{
				_loc6_ = "Required Item(s): ";
				_loc7_ = 0;
				while(_loc7_ < param1.reqd.length)
				{
				_loc8_ = world.invTree[param1.reqd[_loc7_].ItemID];
				_loc9_ = param1.reqd[_loc7_].iQty;
				if(_loc8_.sES == "ar")
				{
					_loc10_ = rootClass.getRankFromPoints(_loc9_);
					_loc11_ = _loc9_ - rootClass.arrRanks[_loc10_ - 1];
					if(_loc11_ > 0)
					{
						_loc6_ = _loc6_ + (_loc11_ + " Class Points on ");
					}
					_loc6_ = _loc6_ + (_loc8_.sName + ", Rank " + _loc10_);
				}
				else
				{
					_loc6_ = _loc6_ + _loc8_.sName;
					if(_loc9_ > 1)
					{
						_loc6_ = _loc6_ + ("x" + _loc9_);
					}
				}
				_loc6_ = _loc6_ + ", ";
				_loc7_++;
				}
				_loc6_ = _loc6_.substr(0,_loc6_.length - 2) + ".";
				return _loc6_;
			}
			return "";
		}

		private static function hasRequiredItemsForQuest(param1:Object) : Boolean
		{
			var rootClass:* = main.Game;
			var _loc2_:int = 0;
			var _loc3_:* = undefined;
			var _loc4_:int = 0;
			if(param1.reqd != null && param1.reqd.length > 0)
			{
				_loc2_ = 0;
				while(_loc2_ < param1.reqd.length)
				{
				_loc3_ = param1.reqd[_loc2_].ItemID;
				_loc4_ = int(param1.reqd[_loc2_].iQty);
				if(rootClass.world.invTree[_loc3_] == null || int(rootClass.world.invTree[_loc3_].iQty) < _loc4_)
				{
					return false;
				}
				_loc2_++;
				}
			}
			return true;
		}
	}
	
}

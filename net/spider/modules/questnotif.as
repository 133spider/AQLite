package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.optionHandler;
	
	public class questnotif extends MovieClip{

		public static function updateQuestProgress(param1:String, param2:Object) : void
        {
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            var _loc6_:int = 0;
            var _loc7_:* = undefined;
            var _loc8_:* = undefined;
            var _loc9_:* = undefined;
            for(_loc3_ in main.Game.world.questTree)
            {
                _loc4_ = main.Game.world.questTree[_loc3_];
                _loc5_ = {};
                if(_loc4_.status != null && _loc4_.status == "c")
                {
                    if(param1 == "item" && _loc4_.turnin != null && _loc4_.turnin.length > 0)
                    {
                        _loc5_.sItems = true;
                        _loc6_ = 0;
                        while(_loc6_ < _loc4_.turnin.length)
                        {
                            _loc7_ = _loc4_.turnin[_loc6_].ItemID;
                            _loc8_ = _loc4_.turnin[_loc6_].iQty;
                            if(param2.ItemID == _loc7_ && main.Game.world.invTree[_loc7_] != null && main.Game.world.invTree[_loc7_].iQty > _loc8_)
                            {
                                _loc9_ = main.Game.world.invTree[_loc7_];
                                main.Game.addUpdate(_loc4_.sName + ": " + _loc9_.sName + " " + main.Game.world.invTree[_loc7_].iQty + "/" + _loc8_);
                            }
                            _loc6_++;
                        }
                    }
                    main.Game.world.checkAllQuestStatus(_loc3_);
                }
            }
        }

        public static function onExtensionResponseHandler(e:*):void{
			if(!optionHandler.bQuestNotif)
				return;
            var dID:*;
            var protocol:* = e.params.type;
            var item:*;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
						case "buyItem":
                            item = main.Game.copyObj(main.Game.world.shopBuyItem);
                            if(main.Game.world.invTree[item.ItemID] == null)
                            {
                                main.Game.world.invTree[item.ItemID] = main.Game.copyObj(resObj);
                                main.Game.world.invTree[item.ItemID].iQty = 0;
                            }
                            updateQuestProgress("item",item);
						break;
                        case "getDrop":
                            if(resObj.bSuccess == 1){
                                item = main.Game.copyObj(main.Game.world.invTree[resObj.ItemID]);
                                item.CharItemID = resObj.CharItemID;
                                item.bBank = resObj.bBank;
                                item.iQty = int(resObj.iQty);
                                if(resObj.EnhID != null)
                                {
                                    item.EnhID = int(resObj.EnhID);
                                    item.EnhLvl = int(resObj.EnhLvl);
                                    item.EnhPatternID = int(resObj.EnhPatternID);
                                    item.EnhRty = int(resObj.EnhRty);
                                }
                                updateQuestProgress("item", item);
                            }
                        break;
                        case "addItems":
                            for(var ItemID:* in resObj.items)
                            {
                                if(main.Game.world.invTree[ItemID] == null)
                                {
                                    item = main.Game.copyObj(resObj.items[ItemID]);
                                }
                                else
                                {
                                    item = main.Game.copyObj(main.Game.world.invTree[ItemID]);
                                    item.iQty = int(resObj.items[ItemID].iQty);
                                }
                                updateQuestProgress("item", item);
                            }
                        break;
                    }
                }
        }
	}
	
}

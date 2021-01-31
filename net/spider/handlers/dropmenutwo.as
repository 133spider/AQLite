package net.spider.handlers{
    import flash.geom.Rectangle;
    import flash.filters.GlowFilter;
    import flash.text.*;
    import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.handlers.*;
    import net.spider.draw.dEntry;
    import net.spider.handlers.DrawEvent;
    import flash.utils.getQualifiedClassName;
    import com.adobe.utils.StringUtil;
    import net.spider.handlers.optionHandler;
    import net.spider.draw.dAttached;

    public class dropmenutwo extends MovieClip {
        public function dropmenutwo(){
            itemCount = {};
            invTree = new Vector.<Object>();
            this.menu.visible = false;
            this.txtQty.mouseEnabled = false;
            this.menuBar.addEventListener(MouseEvent.CLICK, onToggleMenu);
            this.menuBar.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			this.menuBar.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
            var pos:Boolean = main.sharedObject.data.dmtPos;
            if(pos){
                this.x = main.sharedObject.data.dmtPos.x;
                this.y = main.sharedObject.data.dmtPos.y;
            }else{
                this.x = 383;
                this.y = 461;
            }
            this.visible = false;
            main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler, false, 0, true);
            main._stage.addEventListener(Event.ENTER_FRAME, onDropFrame, false, 0, true);
            createUIStack();
            onChangeReset(optionHandler.filterChecks["chkAttachMenu"]);
        }

        private var bAttachedOpen:Boolean = false;
        private var mcAttached:dAttached;
        public function onChangeReset(mode:Boolean):void{
            //mode: true; clear out sbp and switch over, mode: false; clean out current attach and update it
            //TODO: handle mode var
            bAttachedOpen = false;
            if(mode){
                mcAttached = new dAttached(); //252.45 x 157.70
                mcAttached.name = "mcAttached";
                main.Game.ui.mcInterface.addChild(mcAttached);

                main.Game.ui.mcInterface.setChildIndex(main.Game.ui.mcInterface.getChildByName("mcAttached"), 0);

                mcAttached.x = 352;
                mcAttached.y = (optionHandler.filterChecks["chkInvertDrop"]) ? -530 : -19; //-28 (hovered)
                mcAttached.visible = true;

                mcAttached.inner_menu.height = (optionHandler.filterChecks["chkInvertDrop"]) ? 42.80 : 157.70;
                mcAttached.inner_menu.addEventListener(MouseEvent.ROLL_OVER, onRollOverAttached, false, 0, true);
                mcAttached.inner_menu.addEventListener(MouseEvent.ROLL_OUT, onRollOutAttached, false, 0, true);
                mcAttached.inner_menu.addEventListener(MouseEvent.CLICK, onToggleAttached, false, 0, true);
                this.visible = false;
            }else if(mcAttached){ //TODO: account for regular sbp custom drop ui being open, etc
                while (mcAttached.numChildren > 1)
                    mcAttached.removeChildAt(1);
                mcAttached.inner_menu.removeEventListener(MouseEvent.CLICK, onToggleAttached);
                mcAttached.inner_menu.removeEventListener(MouseEvent.ROLL_OVER, onRollOverAttached);
                mcAttached.inner_menu.removeEventListener(MouseEvent.ROLL_OUT, onRollOutAttached);
                main.Game.ui.mcInterface.removeChild(main.Game.ui.mcInterface.getChildByName("mcAttached"));
                mcAttached = null;
                this.visible = true;
            }
        }

        public function onRollOverAttached(e:MouseEvent):void{
            if(bAttachedOpen)
                return;
            mcAttached.y = (optionHandler.filterChecks["chkInvertDrop"]) ? -521 : -28;
        }

        public function onRollOutAttached(e:MouseEvent):void{
            if(bAttachedOpen)
                return;
            mcAttached.y = (optionHandler.filterChecks["chkInvertDrop"]) ? -530 : -19;
        }

        public function onToggleAttached(e:MouseEvent):void{
            bAttachedOpen = !bAttachedOpen;
            if(!bAttachedOpen){
                while (this.mcAttached.numChildren > 1)
                    this.mcAttached.removeChildAt(1);
                mcAttached.inner_menu.height = (optionHandler.filterChecks["chkInvertDrop"]) ? 42.80 : 157.70;
                mcAttached.inner_menu.y = 0;
                mcAttached.y = (optionHandler.filterChecks["chkInvertDrop"]) ? -530 : -19;
            }else{
                reDraw();
            }
        }

        public function createUIStack():void{
           if(!main.Game.ui.getChildByName("dsUI")){
                var dsUI:MovieClip;
                dsUI = new MovieClip();
                dsUI.name = "dsUI";
                main.Game.ui.addChild(dsUI);
                dsUI.x = main.Game.ui.dropStack.x;
                dsUI.y = main.Game.ui.dropStack.y;
            }
        }

        public function resetPos():void{
            this.x = 383;
            this.y = 461;
            main.sharedObject.data.dmtPos = {x: this.x, y: this.y};
			main.sharedObject.flush();
        }

        public function onShow():void{
            if(mcAttached){
                mcAttached.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }else{
                this.visible = !this.visible;
            }
        }

        private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
            main.sharedObject.data.dmtPos = {x: this.x, y: this.y};
			main.sharedObject.flush();
		}

        public function onUpdate(){
            itemCount = {};
            invTree.length = 0;
            reDraw();
        }

        public function onBtNo(e:*):void{
            for(var val:* in invTree){ //add this to onBtYes in dEntry!!! bug issue with wrong quantity!
                if(invTree[val].ItemID == e.ItemID){
                    itemCount[invTree[val].dID] = null;
                    invTree.splice(val, 1);
                }
            }
            for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                if(!main.Game.ui.dropStack.getChildAt(i))
                    continue;
                if(e.iStk == 1){
                    if(main.Game.ui.dropStack.getChildAt(i).cnt && main.Game.ui.dropStack.getChildAt(i).cnt.strName)
                        if(main.Game.ui.dropStack.getChildAt(i).cnt.strName.text == e.sName)
                            main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }else{
                    var nutext:String = main.Game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if(nutext == e.sName)
                        main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }
            }
            reDraw();
        }

        public function onToggleMenu(e:MouseEvent):void{
            this.menu.visible = !this.menu.visible;
            if(this.menu.visible){
                reDraw();
            }
        }

        public function cleanup():void{
            main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
            main._stage.removeEventListener(Event.ENTER_FRAME, onDropFrame);
            main.Game.ui.dropStack.visible = true;
            main.Game.ui.removeChild(main.Game.ui.getChildByName("dsUI"));
            if(achvmnt_timer && achvmnt_timer.running){
                achvmnt_timer.reset();
                achvmnt_timer.removeEventListener(TimerEvent.TIMER, onAchvmntCooldown);
            }
            achvmnt_timer = null;
        }

        private function onAchvmntCooldown(e:TimerEvent):void{
            if(main.Game.ui.dropStack.numChildren > 0){
                for(var i:uint = 0; i < main.Game.ui.dropStack.numChildren; i++){
                    var dropObj:* = main.Game.ui.dropStack.getChildAt(i);
                    if(getQualifiedClassName(dropObj) == "mcAchievement"){
                        return;
                    }
                }
            }
            e.target.reset();
            e.target.removeEventListener(TimerEvent.TIMER, onAchvmntCooldown);
            achvmnt_timer = null;
        }

        private var achvmnt_timer:Timer;
        public function onDropFrame(e:*):void{
            if(!main.Game.sfc.isConnected){
                main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                main._stage.removeEventListener(Event.ENTER_FRAME, onDropFrame);
                itemCount = {};
                invTree.length = 0;
                if(achvmnt_timer && achvmnt_timer.running){
                    achvmnt_timer.reset();
                    achvmnt_timer.removeEventListener(TimerEvent.TIMER, onAchvmntCooldown);
                }
                achvmnt_timer = null;
                return;
            }
            main.Game.ui.dropStack.visible = false;
            if(main.Game.ui.dropStack.numChildren < 1)
                return;
            if(achvmnt_timer && achvmnt_timer.running)
                return;
            for(var i:uint = 0; i < main.Game.ui.dropStack.numChildren; i++){
                var dropObj:* = main.Game.ui.dropStack.getChildAt(i);
                if(getQualifiedClassName(dropObj) == "mcAchievement"){
                    var achievementClass:Class = main.Game.world.getClass("mcAchievement") as Class;
                    var achvmnt_ui:*;
                    achvmnt_ui = main.Game.ui.getChildByName("dsUI").addChild(new (achievementClass)()) as MovieClip;
                    achvmnt_ui.cnt.tBody.text = dropObj.cnt.tBody.text;
                    achvmnt_ui.cnt.tPts.text = dropObj.cnt.tPts.text;
                    achvmnt_ui.fWidth = 348;
                    achvmnt_ui.fHeight = 90;
                    achvmnt_ui.fX = achvmnt_ui.x = -(achvmnt_ui.fWidth / 2);
                    achvmnt_ui.fY = achvmnt_ui.y = -(achvmnt_ui.fHeight + 8);
                    cleanDSUI();
                    achvmnt_timer = new Timer(7000);
                    achvmnt_timer.addEventListener(TimerEvent.TIMER, onAchvmntCooldown);
                    achvmnt_timer.start();
                    break;
                }
            }
        }

        public function isBlacklisted(item:String):Boolean{
            for each(var blacklisted:* in optionHandler.blackListed){
                if(item.indexOf(" X") != -1)
                    item = item.substring(0, item.lastIndexOf(" X"));
                if(StringUtil.trim(item) == StringUtil.trim(blacklisted.label)){
                    return true;
                }
            }
            return false;
        }

        public function cleanDSUI():void{
            var notifCtr = main.Game.ui.getChildByName("dsUI").numChildren;
            notifCtr -= 2;
            var notifObj:MovieClip;
            var notifObj2:MovieClip;
            while(notifCtr > -1)
            {
                notifObj = main.Game.ui.getChildByName("dsUI").getChildAt(notifCtr) as MovieClip;
                notifObj2 = main.Game.ui.getChildByName("dsUI").getChildAt(notifCtr + 1) as MovieClip;
                notifObj.fY = notifObj.y = notifObj2.fY - (notifObj2.fHeight + 8);
                notifCtr--;
            }
        }

        public function showQuestpopup(param1:Object) : void
        {
            var _loc2_:* = null;
            var _loc3_:MovieClip = null;
            var _loc4_:String = null;
            var _loc5_:Object = null;
            var _loc6_:int = 0;
            var questPopupClass:Class = main.Game.world.getClass("mcQuestpopup") as Class;
            _loc2_ = new (questPopupClass)();
            _loc2_.cnt.mcAC.visible = false;
            _loc3_ = main.Game.ui.getChildByName("dsUI").addChild(_loc2_) as MovieClip;
            _loc3_.cnt.tName.text = param1.sName;
            _loc3_.cnt.rewards.tRewards.htmlText = "";
            _loc4_ = "";
            _loc5_ = param1.rewardObj;
            if(param1.rewardType == "ac")
            {
                _loc4_ = "<font color=\'#FFFFFF\'>" + param1.intAmount + "</font>";
                _loc4_ = _loc4_ + "<font color=\'#FFCC00\'> Adventure Coins</font>";
                _loc3_.cnt.mcAC.visible = true;
            }
            else
            {
                if("intGold" in _loc5_ && _loc5_.intGold > 0)
                {
                _loc4_ = "<font color=\'#FFFFFF\'>" + _loc5_.intGold + "</font>";
                _loc4_ = _loc4_ + "<font color=\'#FFCC00\'>g</font>";
                }
                if("intExp" in _loc5_ && _loc5_.intExp > 0)
                {
                if(_loc4_.length > 0)
                {
                    _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
                }
                _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.intExp + "</font>");
                _loc4_ = _loc4_ + "<font color=\'#FF00FF\'>xp</font>";
                }
                if("iRep" in _loc5_ && _loc5_.iRep > 0)
                {
                if(_loc4_.length > 0)
                {
                    _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
                }
                _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.iRep + "</font>");
                _loc4_ = _loc4_ + "<font color=\'#00CCFF\'>rep</font>";
                }
                if("guildRep" in _loc5_ && _loc5_.guildRep > 0)
                {
                if(_loc4_.length > 0)
                {
                    _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
                }
                _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.guildRep + "</font>");
                _loc4_ = _loc4_ + "<font color=\'#00CCFF\'>guild rep</font>";
                }
            }
            _loc3_.cnt.rewards.tRewards.htmlText = _loc4_;
            _loc3_.fWidth = 240;
            _loc3_.fHeight = 70;
            _loc6_ = _loc3_.cnt.rewards.tRewards.x + _loc3_.cnt.rewards.tRewards.textWidth;
            _loc3_.cnt.rewards.x = Math.round(_loc3_.fWidth / 2 - _loc6_ / 2);
            _loc3_.fX = _loc3_.x = -(_loc3_.fWidth / 2);
            _loc3_.fY = _loc3_.y = -(_loc3_.fHeight + 8);
            cleanDSUI();
        }

        public function showItemDS(item:*, qty:*):void{
            var dropClass:Class = main.Game.world.getClass("DFrameMC") as Class;
            var droppedItem:* = main.Game.copyObj(item);
            droppedItem.iQty = qty;

            var dropUI:* = new (dropClass)(droppedItem);
            main.Game.ui.getChildByName("dsUI").addChild(dropUI);
            dropUI.init();
            if(qty > 1){
                dropUI.cnt.bg.width = int(dropUI.cnt.strName.textWidth) + 50;
                dropUI.cnt.bg.width += dropUI.cnt.strQ.textWidth + 2;
                dropUI.cnt.strQ.x = dropUI.cnt.strName.textWidth + 12;
                dropUI.cnt.fx1.width = dropUI.cnt.bg.width;
                dropUI.fWidth = dropUI.cnt.bg.width;
            }else{
                if(dropUI.cnt.strName.textWidth < dropUI.cnt.strType.textWidth){
                    dropUI.cnt.bg.width = int(dropUI.cnt.strType.textWidth) + 50;
                    dropUI.cnt.fx1.width = dropUI.cnt.bg.width;
                    dropUI.fWidth = dropUI.cnt.bg.width;
                }
            }
            dropUI.fY = dropUI.y = -(dropUI.fHeight + 8);
            dropUI.fX = dropUI.x = -(dropUI.fWidth / 2);
            cleanDSUI();
        }

        var itemWasAdded:Boolean;
        var itemCount:Object;
        var invTree:Vector.<Object>;
        public function onExtensionResponseHandler(e:*):void{
            var t_dItem:*;
            var dItem:*;
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "dropItem":
                            for (dID in resObj.items)
                            {
                                if(main.Game.world.invTree[dID]){
                                    dItem = main.Game.copyObj(main.Game.world.invTree[dID]);
                                    if(isBlacklisted(dItem.sName.toUpperCase()))
                                        continue;
                                }else{
                                    if(isBlacklisted(resObj.items[dID].sName.toUpperCase()))
                                        continue;
                                }
                                if(itemCount[dID] == null){
                                    itemCount[dID] = int(resObj.items[dID].iQty);
                                    if(main.Game.world.invTree[dID] == null){
                                        invTree.push(main.Game.copyObj(resObj.items[dID]));
                                    }else{
                                        dItem = main.Game.copyObj(main.Game.world.invTree[dID]);
                                        dItem.iQty = int(resObj.items[dID].iQty);
                                        invTree.push(dItem);
                                    }
                                    invTree[invTree.length-1].dID = dID;
                                }else{
                                    itemCount[dID] += int(resObj.items[dID].iQty);
                                }
                                itemWasAdded = true;
                            }
                        if(!mcAttached || (mcAttached && bAttachedOpen))
                            reDraw();
                        if(itemWasAdded && (!this.visible && !mcAttached) || (mcAttached && !bAttachedOpen)){ 
                            main.Game.ui.mcPortrait.getChildByName("iconDrops").onAlert();
                            itemWasAdded = false;
                        }
                        break;
                        case "addItems":
                            for (dID in resObj.items)
                                if(!optionHandler.filterChecks["chkSBPDropNotification"])
                                    showItemDS((main.Game.world.invTree[dID] == null) ? resObj.items[dID] : main.Game.world.invTree[dID], int(resObj.items[dID].iQty));
                            break;
                        case "getDrop":
                            if(resObj.bSuccess == 1){
                                if("showDrop" in resObj && resObj.showDrop == 1)
                                    showItemDS(main.Game.world.invTree[resObj.ItemID], int(resObj.iQty));
                            }
                            for(var val:* in invTree){
                                if (invTree[val].ItemID == resObj.ItemID)
                                {
                                    if (resObj.bSuccess == 1)
                                    {
                                        itemCount[invTree[val].dID] = null;
                                        invTree.splice(val, 1);
                                    }
                                }
                            }
                        reDraw();
                        break;
                        case "powerGem":
                            for(dID in resObj.items)
                                showItemDS((main.Game.world.invTree[dID] == null) ? resObj.items[dID] : main.Game.world.invTree[dID], int(resObj.items[dID].iQty));
                        break;
                        case "buyItem":
                            if(resObj.CharItemID != -1)
                            {
                                t_dItem = main.Game.copyObj(main.Game.world.shopBuyItem);
                                t_dItem.CharItemID = resObj.CharItemID;
                                showItemDS((main.Game.world.invTree[t_dItem.ItemID] == null) 
                                    ? resObj.items[t_dItem.ItemID] : main.Game.world.invTree[t_dItem.ItemID], 
                                    int(t_dItem.iQty));                               
                            }
                        break;
                        case "ccqr":
                            if(resObj.bSuccess != 0)
                                showQuestpopup(resObj);
                        break;
                        case "Wheel":
                            showItemDS(resObj.dropItems["18927"], resObj.dropQty != null ? int(resObj.dropQty) : 1);
                            showItemDS(resObj.dropItems["19189"], 1);
                            if(resObj.Item != null)
                                showItemDS(resObj.Item, 1);
                        break;
                    }
                }
        }

        public function reDraw():void{
            var qtyCtr:int = 0;
            while ((this.mcAttached ? this.mcAttached : this.menu).numChildren > 1)
                (this.mcAttached ? this.mcAttached : this.menu).removeChildAt(1);
            var ctr:int = 0;
            for each(var item:* in invTree){
                var dropItemGet:* = new dEntry(item, itemCount[item.dID]);
                if(optionHandler.filterChecks["chkInvertDrop"]){
                    dropItemGet.x = 1.5;
                    dropItemGet.y = (this.mcAttached ? 24+(21.5*ctr) - 0.5: (161)+(21.5*ctr));
                }else{
                    dropItemGet.x = 1.5;
                    dropItemGet.y = (this.mcAttached ? (-16)-(21.5*(ctr)) + 0.5: (108)-(21.5*ctr));
                }
                dropItemGet.name = item.sName;
                (this.mcAttached ? this.mcAttached : this.menu).addChild(dropItemGet);
                qtyCtr += itemCount[item.dID];
                ctr++;
            }
            if(this.mcAttached){
                if(optionHandler.filterChecks["chkInvertDrop"]){
                    this.mcAttached.inner_menu.y = 0;
                    this.mcAttached.inner_menu.height = (ctr == 0) ? 47.50 : (47.50) + (21.5*(ctr-1));
                    mcAttached.y = -521;
                }else{
                    this.mcAttached.inner_menu.y = 4-(21.5*(ctr)); //26
                    this.mcAttached.inner_menu.height = (ctr == 0) ? 157.70 : (157.70) + (21.5*(ctr-1));
                    mcAttached.y = -28;
                }
            }else{
                this.txtQty.text = " x " + qtyCtr;
                if(optionHandler.filterChecks["chkInvertDrop"]){
                    this.menu.menuBG.y = ((158)); 
                    this.menu.menuBG.height = 21.5*(ctr) + 6;
                }else{
                    this.menu.menuBG.y = ((108)-(21.5*(ctr-1))) - 3; //26
                    this.menu.menuBG.height = 21.5*(ctr) + 6;
                }
            }
        }
    }
}
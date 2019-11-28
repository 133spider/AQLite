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

    public class dropmenutwo extends MovieClip {
        public static var events:EventDispatcher = new EventDispatcher();
        public function dropmenutwo(){
            this.visible = false;
            itemCount = {};
            invTree = new Array();
            this.menu.visible = false;
            this.txtQty.mouseEnabled = false;
            this.menuBar.addEventListener(MouseEvent.CLICK, onToggleMenu);
            this.menuBar.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			this.menuBar.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
            dropmenutwo.events.addEventListener(ClientEvent.onToggle, onToggle);
            dropmenutwo.events.addEventListener(DrawEvent.onBtNo, onBtNo);
            dropmenutwo.events.addEventListener(ClientEvent.onShow, onShow);
            dropmenutwo.events.addEventListener(ClientEvent.onUpdate, onUpdate);
        }

        public function onShow(e:ClientEvent):void{
            this.visible = !this.visible;
        }

        private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
            main.sharedObject.data.dmtPos = {x: this.x, y: this.y};
			main.sharedObject.flush();
		}

        public function onUpdate(e:ClientEvent){
            itemCount = {};
            invTree = new Array();
            reDraw();
        }

        public function onBtNo(e:*):void{
            for(var val:* in invTree){ //add this to onBtYes in dEntry!!! bug issue with wrong quantity!
                if(invTree[val].ItemID == e.data.ItemID){
                    itemCount[invTree[val].dID] = null;
                    invTree.splice(val, 1);
                }
            }
            for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                if(e.data.iStk == 1){
                    if(main.Game.ui.dropStack.getChildAt(i).cnt.strName.text == e.data.sName)
                        main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }else{
                    var nutext:String = main.Game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if(nutext == e.data.sName)
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

        public function onToggle(e:*):void{
            if(optionHandler.sbpcDrops){
                var pos:* = main.sharedObject.data.dmtPos;
                if(pos){
                    this.x = pos.x;
                    this.y = pos.y;
                }
                this.visible = false;
                main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler, false, 0, true);
                main._stage.addEventListener(Event.ENTER_FRAME, onDropFrame, false, 0, true);
            }else{
                this.visible = false;
                main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                main._stage.removeEventListener(Event.ENTER_FRAME, onDropFrame);
                if(main.Game.ui.dropStack.numChildren < 1)
                    return;
                for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                    try{
                        if(!(main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible){
                            (main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible = true;
                        }
                    }catch(exception){
                        trace("Error handling drops: " + exception);
                    }
                }
            }
        }

        public function onDropFrame(e:*):void{
            if(!main.Game.sfc.isConnected){
                itemCount = {};
                invTree = new Array();
                return;
            }
            if(main.Game.ui.dropStack.numChildren < 1)
				return;
			for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
				try{
					if(getQualifiedClassName(main.Game.ui.dropStack.getChildAt(i) as MovieClip).indexOf("DFrame2MC") > -1){
						(main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible = false;
                    }
				}catch(exception){
					trace("Error handling drops: " + exception);
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

        var itemCount:Object;
        var invTree:Array;
        public function onExtensionResponseHandler(e:*):void{
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
                            }
                        reDraw();
                        break;
                        case "getDrop":
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
                    }
                }
        }

        public function reDraw():void{
            var qtyCtr:int = 0;
            while (this.menu.numChildren > 1)
                this.menu.removeChildAt(1);
            var ctr:int = 0;
            for each(var item:* in invTree){
                var dropItemGet:* = new dEntry(item, itemCount[item.dID]);
                if(optionHandler.filterChecks["chkInvertDrop"]){
                    dropItemGet.x = 2;
                    dropItemGet.y = (161)+(21.5*ctr);
                }else{
                    dropItemGet.x = 2;
                    dropItemGet.y = (108)-(21.5*ctr);
                }
                dropItemGet.name = item.sName;
                this.menu.addChild(dropItemGet);
                qtyCtr += itemCount[item.dID];
                ctr++;
            }
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
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
            dropmenutwo.events.addEventListener(ClientEvent.onUpdate, onUpdate);
        }

        private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
		}

        public function onUpdate(e:ClientEvent){
            itemCount = {};
            invTree = new Array();
            reDraw();
        }

        public function onBtNo(e:*):void{
            for(var val:* in invTree){
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
        }

        private static var dropTimer:Timer;
        public function onToggle(e:Event):void{
            if(options.sbpcDrops){
                this.visible = true;
                main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                dropTimer = new Timer(0);
				dropTimer.addEventListener(TimerEvent.TIMER, onDropTimer);
				dropTimer.start();
            }else{
                this.visible = false;
                main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                dropTimer.reset();
				dropTimer.removeEventListener(TimerEvent.TIMER, onDropTimer);
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

        public function onDropTimer(e:TimerEvent):void{
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
                dropItemGet.x = 2;
                dropItemGet.y = (108)-(21.5*ctr);
                dropItemGet.name = item.sName;
                this.menu.addChild(dropItemGet);
                qtyCtr += itemCount[item.dID];
                ctr++;
            }
            this.txtQty.text = " x " + qtyCtr;
            this.menu.menuBG.y = ((108)-(21.5*(ctr-1))) - 3; //26
            this.menu.menuBG.height = 21.5*(ctr) + 6;
        }
    }
}
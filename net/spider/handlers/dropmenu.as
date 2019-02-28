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

    public class dropmenu extends MovieClip {

        public static var events:EventDispatcher = new EventDispatcher();
        public var btnClose:SimpleButton;
        var hRun:int = 0;
        var moy:int = 0;
        var mhY:int = 0;
        var mox:int = 0;
        public var fData:Object = null;
        public var tTitle:MovieClip;
        public var bg:MovieClip;
        var mbY:int = 0;
        var mbD:int = 0;
        public var iListB:MovieClip;
        var dRun:int = 0;
        public var world:MovieClip;
        public var hit:MovieClip;
        public var iListA:MovieClip;
        var mDown:Boolean = false;
        public var rootClass:MovieClip;
        public var fxmask:MovieClip;
        public var CHARS:MovieClip;
        public var preview:MovieClip;
        var scrTgt:MovieClip;
        var ox:int = 0;
        var oy:int = 0;

        public var invTree:Array;
        public function dropmenu():void{
            var mc:MovieClip;
            fData = null;
            mDown = false;
            hRun = 0;
            dRun = 0;
            mbY = 0;
            mhY = 0;
            mbD = 0;
            ox = 0;
            oy = 0;
            mox = 0;
            moy = 0;
            super();
            mc = (this as MovieClip);
            mc.tTitle.mouseEnabled = false;
            mc.preview.tPreview.mouseEnabled = false;
            mc.hit.alpha = 0;
            mc.hit.buttonMode = true;
            mc.visible = false;
            itemCount = {};
            invTree = new Array();
            ldr = new Loader();
            dropmenu.events.addEventListener(ClientEvent.onToggle, onToggle);
            dropmenu.events.addEventListener(ClientEvent.onShow, onShow);
            dropmenu.events.addEventListener(ClientEvent.onUpdate, onUpdate);
        }

        function onUpdate(e:ClientEvent){
            itemCount = {};
            invTree = new Array();
            fOpen();
        }

        public function onShow(e:Event):void{
            fOpen();
        }

        private static var dropTimer:Timer;
        public function onToggle(e:Event):void{
            if(options.cDrops){
                main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                dropTimer = new Timer(0);
				dropTimer.addEventListener(TimerEvent.TIMER, onDropTimer);
				dropTimer.start();
            }else{
                main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
                dropTimer.reset();
				dropTimer.removeEventListener(TimerEvent.TIMER, onDropTimer);
                if(main.Game.ui.dropStack.numChildren < 1)
                    return;
                for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                    try{
                        if(!(main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible)
                            (main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible = true;
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
					if((main.Game.ui.dropStack.getChildAt(i) as MovieClip).cnt.ybtn)
						(main.Game.ui.dropStack.getChildAt(i) as MovieClip).visible = false;
				}catch(exception){
					trace("Error handling drops: " + exception);
				}
			}
        }

        public function isBlacklisted(item:String):Boolean{
            for each(var blacklisted:* in options.blackListed){
                if(item.indexOf(" X") != -1)
                    item = item.substring(0, item.lastIndexOf(" X"));
                if(item == blacklisted.label){
                    return true;
                }
            }
            return false;
        }

        var itemCount:Object;
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
                            };
                        fOpen();
                        break;
                        case "getDrop":
                            for(var val:* in invTree){
                                if (invTree[val].ItemID == resObj.ItemID)
                                {
                                    if (resObj.bSuccess == 1)
                                    {
                                        itemCount[invTree[val].dID] = null;
                                        invTree.splice(val, 1);
                                        fOpen();
                                    };
                                };
                            }
                        break;
                    }
                }
        }

        public function check(itemID:*):*{
            for(var val:* in invTree){
                if(invTree[val].ItemID == itemID)
                    return val;
            }
            return null;
        }

        public function btnCloseClick(e:MouseEvent=null):void{
            rootClass.mixer.playSound("Click");
            hideEditMenu();
        }

        public function dEF(e:Event){
            var scr:*;
            var display:*;
            var hP:*;
            var tY:*;
            scr = MovieClip(e.currentTarget.parent).scr;
            display = MovieClip(e.currentTarget);
            hP = (-(scr.h.y) / hRun);
            tY = (int((hP * dRun)) + display.oy);
            if (Math.abs((tY - display.y)) > 0.2)
            {
                display.y = (display.y + ((tY - display.y) / 4));
            }
            else
            {
                display.y = tY;
            };
        }

        public function hEF(e:Event){
            var scr:*;
            if (MovieClip(e.currentTarget.parent).mDown)
            {
                scr = MovieClip(e.currentTarget.parent);
                mbD = (int(mouseY) - mbY);
                scr.h.y = (mhY + mbD);
                if ((scr.h.y + scr.h.height) > scr.b.height)
                {
                    scr.h.y = int((scr.b.height - scr.h.height));
                };
                if (scr.h.y < 0)
                {
                    scr.h.y = 0;
                };
            };
        }

        public function hideEditMenu():void{
            var mc:MovieClip;
            mc = MovieClip(this);
            mc.visible = false;
            mc.x = 1000;
            stage.focus = stage;
        }

        public function onMenuBGEnterFrame(e:Event){
            var mc:MovieClip;
            mc = (e.currentTarget.parent as MovieClip);
            if (mc.visible)
            {
                if (mc.mDown)
                {
                    mc.x = (mc.ox + (stage.mouseX - mc.mox));
                    mc.y = (mc.oy + (stage.mouseY - mc.moy));
                    if (mc.x < 0)
                    {
                        mc.x = 0;
                    };
                    if ((mc.x + mc.bg.width) > 960)
                    {
                        mc.x = (960 - mc.bg.width);
                    };
                    if (mc.y < 0)
                    {
                        mc.y = 0;
                    };
                    if ((mc.y + mc.bg.height) > 495)
                    {
                        mc.y = (495 - mc.bg.height);
                    };
                };
            };
        }

        public function resizeMe(){
            var mc:MovieClip;
            var minWidth:*;
            mc = MovieClip(this);
            if (mc.iListA.visible)
            {
                mc.bg.width = ((mc.iListA.x + mc.iListA.w) + 5);
            };
            if (mc.iListB.visible)
            {
                mc.iListB.x = ((mc.iListA.x + mc.iListA.w) + 1);
                mc.bg.width = (mc.bg.width + (mc.iListB.w + 1));
                mc.iListA.divider.visible = !(mc.iListA.scr.visible);
            }
            else
            {
                mc.iListA.divider.visible = false;
            };
            if (((mc.preview.t2.visible) || (mc.cnt.visible)))
            {
                mc.preview.x = ((mc.iListB.x + mc.iListB.w) + 4);
                mc.bg.width = (mc.bg.width + (mc.preview.width + 4));
                mc.iListB.divider.visible = !(mc.iListB.scr.visible);
            }
            else
            {
                mc.iListB.divider.visible = false;
            };
            minWidth = ((((mc.tTitle.x + tTitle.width) + 4) + mc.btnClose.width) + 4);
            if (mc.bg.width < minWidth)
            {
                mc.bg.width = minWidth;
            };
            mc.btnClose.x = (mc.bg.width - 19);
            mc.fxmask.width = mc.bg.width;
            if (mc.x < 0)
            {
                mc.x = 0;
            };
            if ((mc.x + mc.bg.width) > 960)
            {
                mc.x = (960 - mc.bg.width);
            };
            if (mc.y < 0)
            {
                mc.y = 0;
            };
            if ((mc.y + mc.bg.height) > 495)
            {
                mc.y = (495 - mc.bg.height);
            };
        }

        public function fClose(e:MouseEvent=null):void{
            var mc:MovieClip;
            var mcp:MovieClip;
            var h:MovieClip;
            mc = MovieClip(this);
            mc.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
            mc.bg.removeEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick);
            mc.bg.removeEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame);
            mc.hit.removeEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick);
            mc.hit.removeEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame);
            mc.btnClose.removeEventListener(MouseEvent.CLICK, btnCloseClick);
            mc.preview.bAdd.removeEventListener(MouseEvent.CLICK, onItemAddClick);
            mc.preview.bDel.removeEventListener(MouseEvent.CLICK, onItemDelClick);
            destroyIList(mc.iListA);
            destroyIList(mc.iListB);
            mc.visible = false;
            stage.focus = stage;
        }

        private function refreshIListB():void{
            var mc:MovieClip;
            var i:int;
            var imc:MovieClip;
            mc = MovieClip(this).iListB.iList;
            i = 1;
            while (i < mc.numChildren)
            {
                imc = (mc.getChildAt(i) as MovieClip);
                if (imc.val != null)
                {
                    imc.bg.visible = false;
                    if (imc.iSel)
                    {
                        imc.bg.visible = true;
                        imc.bg.alpha = 0.5;
                    };
                    if (int(imc.val.bEquip) == 1)
                    {
                        imc.bg.visible = true;
                        imc.bg.alpha = 1;
                    };
                };
                i++;
            };
        }

        public function scrDown(e:MouseEvent){
            mbY = int(mouseY);
            mhY = int(MovieClip(e.currentTarget.parent).h.y);
            scrTgt = MovieClip(e.currentTarget.parent);
            scrTgt.mDown = true;
            stage.addEventListener(MouseEvent.MOUSE_UP, scrUp, false, 0, true);
        }

        public function scrUp(e:MouseEvent){
            scrTgt.mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, scrUp);
        }

        var ldr:Loader;
        private function addGlow(mc:MovieClip):void{
            var mcFilter:*;
            mcFilter = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            mc.filters = [mcFilter];
        }

        public function onMenuBGRelease(e:MouseEvent):void{
            var mc:MovieClip;
            mc = MovieClip(this);
            mc.mDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMenuBGRelease);
        }

        var item_load:Object;
        public function onMenuItemClick(e:MouseEvent):void{
            var imc:MovieClip;
            var cmc:MovieClip;
            var parMC:MovieClip;
            var mc:MovieClip;
            var item:Object;
            var i:int;
            var s:String;
            imc = (e.currentTarget as MovieClip);
            parMC = (imc.parent as MovieClip);
            mc = (this as MovieClip);
            i = 0;
            s = "";
            if (imc.typ == "A")
            {
                i = 0;
                while (i < parMC.numChildren)
                {
                    MovieClip(parMC.getChildAt(i)).bg.visible = false;
                    i++;
                };
                imc.bg.visible = true;
                buildItemList(fData[imc.val], "B", MovieClip(imc.parent));
            };
            if (imc.typ == "B")
            {
                i = 1;
                while (i < parMC.numChildren)
                {
                    cmc = (parMC.getChildAt(i) as MovieClip);
                    cmc.iSel = false;
                    i++;
                };
                imc.iSel = true;
                refreshIListB();
                item = imc.val;
                item_load = imc.val;
                switch(item.sType.toLowerCase()){
                    case "armor":
                    case "class":
                        onLoadArmorComplete(item.sFile, item.sLink);
                        break;
                    case "quest item":
                    case "item":
                        loadItem();
                        break;
                    default:
                        trace("Loading " + item.sLink + ":" + item.sFile);
                        ldr.load(new URLRequest(("http://aqworldscdn.aq.com/game/gamefiles/" + item.sFile)), new LoaderContext(false, ApplicationDomain.currentDomain)); //rootClass.sFilePath
                        ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
                        ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
                        break;
                }
            };
        }

        public function repositionPreview(mc:MovieClip):void{
            var r:Rectangle;
            r = mc.getBounds(this);
            if (r.height > 113)
            {
                mc.scaleX = (mc.scaleX * (113 / r.height));
                mc.scaleY = (mc.scaleY * (113 / r.height));
            };
            mc.x = (MovieClip(this).preview.x - int(((mc.getBounds(this).x + (mc.getBounds(this).width / 2)) - (130 / 2))));
            mc.y = int((MovieClip(this).preview.y - mc.getBounds(this).y));
        }

        public function onLoadComplete(e:Event):void{
            var s:String;
            var itemC:Class;
            var mc:MovieClip;
            var item:*;
            var obj:* = item_load;
            var itemClip:MovieClip;
            s = obj.sLink;
            trace("Obj type: " + obj.sType);
            mc = (MovieClip(this).cnt as MovieClip);
            if (mc.numChildren > 0)
            {
                mc.removeChildAt(0);
            };
            try
            {
                itemC = (ldr.contentLoaderInfo.applicationDomain.getDefinition(s) as Class); //ldr.contentLoaderInfo.applicationDomain
                itemClip = new (itemC)();
            }
            catch (err:Error)
            {
                trace(" Weapon added to display list manually");
                itemClip = MovieClip(e.target.content);
            }

            switch(obj.sType.toLowerCase()){
                case "helm":
                    itemClip.scaleX = itemClip.scaleY = .8;
                    break;
                case "pet":
                    itemClip.scaleX = itemClip.scaleY = 2;
                    break;
                default:
                    itemClip.scaleX = itemClip.scaleY = .3;
                    break;
            }
            item = (mc.addChild(itemClip) as MovieClip);
            addGlow(itemClip);
            item.ItemID = obj.ItemID;
            MovieClip(this).preview.item = obj;
            MovieClip(this).preview.bAdd.visible = true;
            MovieClip(this).preview.bDel.visible = true;
            MovieClip(this).preview.tPreview.visible = true;
            MovieClip(this).preview.t2.visible = false;
            MovieClip(this).cnt.visible = true;
            MovieClip(this).pMC.visible = false;
            MovieClip(this).cnt.alpha = 1;
            if(obj.bCoins)
                MovieClip(this).preview.mcCoin.visible = true;
            else
                MovieClip(this).preview.mcCoin.visible = false;
            resizeMe();
            repositionPreview(itemClip);
        }

        public function onLoadError(e:IOErrorEvent):void{
            var s:String;
            var itemC:Class;
            var mc:MovieClip;
            var item:*;
            var obj:* = item_load;
            var itemClip:MovieClip;
            mc = (MovieClip(this).cnt as MovieClip);
            if (mc.numChildren > 0)
            {
                mc.removeChildAt(0);
            };
            itemC = (rootClass.world.getClass("iibag") as Class);
            itemClip = new (itemC)();
            itemClip.scaleX = itemClip.scaleY = 1;
            itemClip.y = itemClip.y - 35;
            item = (mc.addChild(itemClip) as MovieClip);
            addGlow(itemClip);
            item.ItemID = obj.ItemID;
            MovieClip(this).preview.item = obj;
            MovieClip(this).preview.bAdd.visible = true;
            MovieClip(this).preview.bDel.visible = true;
            MovieClip(this).preview.tPreview.visible = true;
            MovieClip(this).preview.t2.visible = false;
            MovieClip(this).cnt.visible = true;
            MovieClip(this).pMC.visible = false;
            MovieClip(this).cnt.alpha = 1;
            if(obj.bCoins)
                MovieClip(this).preview.mcCoin.visible = true;
            else
                MovieClip(this).preview.mcCoin.visible = false;
            resizeMe();
            repositionPreview(itemClip);
        }

        public function onLoadArmorComplete(sFile, sLink):void{
            var s:String;
            var itemC:Class;
            var mc:MovieClip;
            var item:*;
            var obj:* = item_load;
            s = obj.sLink;
            trace("Obj type: " + obj.sType);
            var objChar:Object = new Object();
            objChar.strGender = main.Game.world.myAvatar.objData.strGender;
            mc = (MovieClip(this).cnt as MovieClip);
            if (mc.numChildren > 0)
            {
                mc.removeChildAt(0);
            };
            MovieClip(this).pMC.pAV.objData = objChar;
            MovieClip(this).pMC.loadArmor(sFile, sLink);
            MovieClip(this).pMC.visible = true;
            MovieClip(this).preview.item = obj;
            MovieClip(this).preview.bAdd.visible = true;
            MovieClip(this).preview.bDel.visible = true;
            MovieClip(this).preview.tPreview.visible = true;
            MovieClip(this).preview.t2.visible = false;
            MovieClip(this).cnt.visible = true;
            MovieClip(this).cnt.alpha = 0;
            if(obj.bCoins)
                MovieClip(this).preview.mcCoin.visible = true;
            else
                MovieClip(this).preview.mcCoin.visible = false;
            resizeMe();
            MovieClip(this).pMC.x = MovieClip(this).preview.x + 60;
        }

        public function loadItem():void{
            var s:String;
            var itemC:Class;
            var mc:MovieClip;
            var item:*;
            var obj:* = item_load;
            var itemClip:MovieClip;
            mc = (MovieClip(this).cnt as MovieClip);
            if (mc.numChildren > 0)
            {
                mc.removeChildAt(0);
            };
            itemC = (rootClass.world.getClass("iibag") as Class);
            itemClip = new (itemC)();
            itemClip.scaleX = itemClip.scaleY = 1;
            itemClip.y = itemClip.y - 35;
            item = (mc.addChild(itemClip) as MovieClip);
            addGlow(itemClip);
            item.ItemID = obj.ItemID;
            MovieClip(this).preview.item = obj;
            MovieClip(this).preview.bAdd.visible = true;
            MovieClip(this).preview.bDel.visible = true;
            MovieClip(this).preview.tPreview.visible = true;
            MovieClip(this).preview.t2.visible = false;
            MovieClip(this).cnt.visible = true;
            MovieClip(this).pMC.visible = false;
            MovieClip(this).cnt.alpha = 1;
            if(obj.bCoins)
                MovieClip(this).preview.mcCoin.visible = true;
            else
                MovieClip(this).preview.mcCoin.visible = false;
            resizeMe();
            repositionPreview(itemClip);
        }

        public function showMenu():void{
            var mc:MovieClip;
            mc = MovieClip(this);
            buildMenu();
            mc.visible = true;
            //mc.y = 315;
            //mc.x = int((480 - (mc.bg.width / 2)));
        }

        public function onHandleEnterFrame(e:Event){
            var mc:MovieClip;
            mc = (e.currentTarget as MovieClip);
            if (mc.visible)
            {
                mc.bCancel.x = ((mc.frame.width - mc.bCancel.width) - 4);
                mc.bDelete.x = ((mc.bCancel.x - mc.bDelete.width) - 4);
                if (mc.mDown)
                {
                    mc.x = (mc.ox + (stage.mouseX - mc.mox));
                    mc.y = (mc.oy + (stage.mouseY - mc.moy));
                    if ((mc.x + (mc.frame.width / 2)) < 0)
                    {
                        mc.x = -(int((mc.frame.width / 2)));
                    };
                    if ((mc.x + (mc.frame.width / 2)) > 960)
                    {
                        mc.x = int((960 - (mc.frame.width / 2)));
                    };
                    if ((mc.y + (mc.frame.height / 2)) < 0)
                    {
                        mc.y = -(int((mc.frame.height / 2)));
                    };
                    if ((mc.y + (mc.frame.height / 2)) > 495)
                    {
                        mc.y = int((495 - (mc.frame.height / 2)));
                    };
                    mc.tgt.x = Math.ceil((mc.x + (mc.frame.width / 2)));
                    mc.tgt.y = Math.ceil((mc.y - (mc.tgt.getBounds(stage).y - mc.tgt.y)));
                };
            };
        }

        public function onMenuBGClick(e:MouseEvent):void{
            var mc:MovieClip;
            mc = MovieClip(this);
            mc.mDown = true;
            mc.ox = mc.x;
            mc.oy = mc.y;
            mc.mox = stage.mouseX;
            mc.moy = stage.mouseY;
            stage.addEventListener(MouseEvent.MOUSE_UP, onMenuBGRelease, false, 0, true);
        }

        private function destroyIList(lmc:MovieClip):void{
            var child:MovieClip;
            while (lmc.iList.numChildren > 1)
            {
                child = lmc.iList.getChildAt(1);
                child.removeEventListener(MouseEvent.CLICK, onMenuItemClick);
                child.removeEventListener(MouseEvent.MOUSE_OVER, onMenuItemMouseOver);
                delete child.val;
                lmc.iList.removeChildAt(1);
            };
            lmc.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, scrDown);
            lmc.scr.h.removeEventListener(Event.ENTER_FRAME, hEF);
            lmc.iList.removeEventListener(Event.ENTER_FRAME, dEF);
        }

        public function fOpen():void{
            var h:MovieClip;
            var mcp:MovieClip;
            var mc:MovieClip;
            rootClass = (stage.getChildAt(0) as MovieClip);
            world = (rootClass.world as MovieClip);
            CHARS = (rootClass.world.CHARS as MovieClip);
            mc = (this as MovieClip);
            mc.preview.bAdd.buttonMode = true;
            mc.preview.bDel.buttonMode = true;
            mc.preview.t2.mouseEnabled = false;
            mc.btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0, true);
            mc.bg.addEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick, false, 0, true);
            mc.bg.addEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame, false, 0, true);
            mc.hit.addEventListener(MouseEvent.MOUSE_DOWN, onMenuBGClick, false, 0, true);
            mc.hit.addEventListener(Event.ENTER_FRAME, onMenuBGEnterFrame, false, 0, true);
            mc.preview.bAdd.addEventListener(MouseEvent.CLICK, onItemAddClick, false, 0, true);
            mc.preview.bDel.addEventListener(MouseEvent.CLICK, onItemDelClick, false, 0, true);
            mc.pMC.visible = false;
            showMenu();
        }

        public function onItemAddClick(e:MouseEvent):void{
            var item:Object;
            item = MovieClip(e.currentTarget.parent).item;
            for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                if(item.iStk == 1){
                    if(main.Game.ui.dropStack.getChildAt(i).cnt.strName.text == item.sName){
                        main.Game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        break;
                    }
                }else{
                    var nutext:String = main.Game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if(nutext == item.sName){
                        main.Game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        break;
                    }
                }
            }
        }

        public function onItemDelClick(e:MouseEvent):void{
            var item:Object;
            item = MovieClip(e.currentTarget.parent).item;
            for(var val:* in invTree){ //add this to onItemAddClick!!!
                if(invTree[val].ItemID == item.ItemID){
                    itemCount[invTree[val].dID] = null;
                    invTree.splice(val, 1);
                }
            }
            for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                if(item.iStk == 1){
                    if(main.Game.ui.dropStack.getChildAt(i).cnt.strName.text == item.sName)
                        main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }else{
                    var nutext:String = main.Game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if(nutext == item.sName)
                        main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }
            }
            fOpen();
        }

        public function buildMenu():void{
            var i:int;
            var o:Object;
            var mc:MovieClip;
            var item:Object;
            var s:String;
            var a:Array;
            var ok:Boolean;
            var list:Array;
            var j:int;
            i = 0;
            o = {};
            mc = (this as MovieClip);
            item = {};
            s = "";
            a = [];
            ok = true;
            i = 0;
            while (i < invTree.length) //invTree
            {
                ok = true;
                item = invTree[i];
                s = item.sType;
                if (!(s in o))
                {
                    o[s] = [];
                };
                a = o[s];
                j = 0;
                while (j < a.length)
                {
                    if (a[j].ItemID == item.ItemID)
                    {
                        ok = false;
                    };
                    j++;
                };
                if (ok)
                {
                    a.push(item);
                };
                i++;
            };
            for (s in o)
            {
                o[s].sortOn("sName");
            };
            fData = o;
            list = [];
            for (s in o)
            {
                list.push(s);
            };
            list.sort(rootClass.arraySort);
            buildItemList(list, "A", mc);
        }

        public function onMenuItemMouseOver(e:MouseEvent):void{
            var mc:MovieClip;
            var item:MovieClip;
            var i:int;
            mc = MovieClip(e.currentTarget);
            i = 1;
            while (i < mc.parent.numChildren)
            {
                item = MovieClip(mc.parent.getChildAt(i));
                if (item.bg.alpha < 0.4)
                {
                    item.bg.visible = false;
                };
                i++;
            };
            if (!mc.bg.visible)
            {
                mc.bg.visible = true;
                mc.bg.alpha = 0.33;
            };
        }

        public function buildItemList(list:Array, typ:String, par:MovieClip):void{
            var i:int;
            var mc:MovieClip;
            var lmc:MovieClip;
            var item:MovieClip;
            var itemC:Class;
            var s:String;
            var ok:Boolean;
            var w:int;
            var scr:MovieClip;
            var bMask:MovieClip;
            var display:MovieClip;
            i = 0;
            mc = (this as MovieClip);
            s = "";
            ok = true;
            w = 90;
            mc.cnt.visible = false;
            mc.preview.mcCoin.visible = false;
            mc.pMC.visible = false;
            mc.preview.t2.visible = false;
            mc.preview.bAdd.visible = false;
            mc.preview.bDel.visible = false;
            mc.preview.tPreview.visible = false;
            if (typ == "A")
            {
                mc.iListB.visible = false;
                lmc = mc.iListA;
                destroyIList(lmc);
                lmc.par = par;
                i = 0;
                while (i < list.length)
                {
                    itemC = (lmc.iList.iproto.constructor as Class);
                    item = lmc.iList.addChild(new (itemC)());
                    item.ti.autoSize = "left";
                    item.ti.text = String(list[i]);
                    if (item.ti.textWidth > w)
                    {
                        w = int(item.ti.textWidth);
                    };
                    item.hit.alpha = 0;
                    item.typ = typ;
                    item.val = list[i];
                    item.iSel = false;
                    item.addEventListener(MouseEvent.CLICK, onMenuItemClick, false, 0, true);
                    item.addEventListener(MouseEvent.MOUSE_OVER, onMenuItemMouseOver, false, 0, true);
                    item.y = (lmc.iList.iproto.y + (i * 16));
                    item.bg.visible = false;
                    item.buttonMode = true;
                    i++;
                };
                lmc.iList.iproto.visible = false;
                lmc.iList.y = ((lmc.imask.height / 2) - (lmc.iList.height / 2));
            }
            else
            {
                if (typ == "B")
                {
                    mc.iListB.visible = true;
                    lmc = mc.iListB;
                    destroyIList(lmc);
                    lmc.par = par;
                    i = 0;
                    while (i < list.length)
                    {
                        itemC = (lmc.iList.iproto.constructor as Class);
                        item = lmc.iList.addChild(new (itemC)());
                        item.ti.autoSize = "left";
                        if(list[i].bUpg == 1){
                            if(list[i].iStk > 1)
                                item.ti.htmlText = "<font color='#FCC749'>" + String(list[i].sName) + " x" + String(itemCount[list[i].dID]) + "</font>";
                            else
                                item.ti.htmlText = "<font color='#FCC749'>" + String(list[i].sName) + "</font>";
                        }else{
                            if(list[i].iStk > 1)
                                item.ti.text = String(list[i].sName) + " x" + String(itemCount[list[i].dID]);
                            else
                                item.ti.text = String(list[i].sName);
                        }
                        if (item.ti.textWidth > w)
                        {
                            w = int(item.ti.textWidth);
                        };
                        item.hit.alpha = 0;
                        item.typ = typ;
                        item.val = list[i];
                        item.iSel = false;
                        item.addEventListener(MouseEvent.CLICK, onMenuItemClick, false, 0, true);
                        item.addEventListener(MouseEvent.MOUSE_OVER, onMenuItemMouseOver, false, 0, true);
                        item.y = (lmc.iList.iproto.y + (i * 16));
                        item.bg.visible = (item.val.bEquip == 1);
                        item.buttonMode = true;
                        i++;
                    };
                    lmc.iList.iproto.visible = false;
                    lmc.x = ((lmc.par.x + lmc.par.width) + 1);
                    lmc.iList.y = ((lmc.imask.height / 2) - (lmc.iList.height / 2));
                };
            };
            w = (w + 7);
            i = 1;
            while (i < lmc.iList.numChildren)
            {
                item = (lmc.iList.getChildAt(i) as MovieClip);
                item.bg.width = w;
                item.hit.width = w;
                i++;
            };
            scr = lmc.scr;
            bMask = lmc.imask;
            display = lmc.iList;
            scr.h.y = 0;
            scr.visible = false;
            scr.hit.alpha = 0;
            scr.mDown = false;
            if (display.height > scr.b.height)
            {
                scr.h.height = int(((scr.b.height / display.height) * scr.b.height));
                hRun = (scr.b.height - scr.h.height);
                dRun = ((display.height - scr.b.height) + 10);
                display.oy = (display.y = bMask.y);
                scr.visible = true;
                scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, scrDown, false, 0, true);
                scr.h.addEventListener(Event.ENTER_FRAME, hEF, false, 0, true);
                display.addEventListener(Event.ENTER_FRAME, dEF, false, 0, true);
            }
            else
            {
                scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, scrDown);
                scr.h.removeEventListener(Event.ENTER_FRAME, hEF);
                display.removeEventListener(Event.ENTER_FRAME, dEF);
            };
            lmc.imask.width = (w - 1);
            lmc.divider.x = w;
            lmc.scr.x = w;
            if (lmc.scr.visible)
            {
                lmc.w = (w + lmc.scr.width);
            }
            else
            {
                lmc.w = (w + 1);
            };
            resizeMe();
        }


    }
}//package 


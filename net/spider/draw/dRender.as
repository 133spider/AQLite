package net.spider.draw
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.handlers.DrawEvent;
    import net.spider.avatar.*;
    import net.spider.handlers.ClientEvent;

    public class dRender extends MovieClip
    {
        public var btnClose:SimpleButton;
        var rootClass:MovieClip;
        var mcStage:MovieClip;
        var curItem:Object;
        var sLinkArmor:String = "";
        var sLinkCape:String = "";
        var sLinkHelm:String = "";
        var sLinkPet:String = "";
        var sLinkWeapon:String = "";
        var sLinkHouse:String = "";
        var pLoaderD:ApplicationDomain;
        var pLoaderC:LoaderContext;

        public function dRender(e:*) : void
        {
            rootClass = MovieClip(main.Game);
            pLoaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
            pLoaderC = new LoaderContext(false, pLoaderD);
            this.x = 325;
            this.y = 90;
            this.btnClose.addEventListener(MouseEvent.CLICK, xClick, false, 0, true);
            this.btnTryMe.addEventListener(MouseEvent.CLICK, xTryMe, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
            mcStage = MovieClip(this.addChild(new MovieClip()));
            loadItem(e);
        }// end function

        private function xClick(event:MouseEvent)
        {
            this.parent.removeChild(this);
            return;
        }// end function

        private function xTryMe(event:MouseEvent)
        {
            switch(curItem.sES)
            {
                case "Weapon":
                case "he":
                case "ba":
                case "pe":
                case "ar":
                case "co":
                    var sES:String = curItem.sES;
                    if(sES == "ar")
                        sES = "co";
                    if(sES == "pe"){
                        if(main.Game.world.myAvatar.objData.eqp["pe"]){
                            main.Game.world.myAvatar.unloadPet();
                        }
                    }
                    if(!main.Game.world.myAvatar.objData.eqp[sES]){
                        main.Game.world.myAvatar.objData.eqp[sES] = {};
                        main.Game.world.myAvatar.objData.eqp[sES].wasCreated = true;
                    }
                    if(!main.Game.world.myAvatar.objData.eqp[sES].isPreview){
                        main.Game.world.myAvatar.objData.eqp[sES].isPreview = true;
                        if("sType" in curItem){
                            main.Game.world.myAvatar.objData.eqp[sES].oldType = main.Game.world.myAvatar.objData.eqp[sES].sType;
                            main.Game.world.myAvatar.objData.eqp[sES].sType = curItem.sType;
                        }
                        main.Game.world.myAvatar.objData.eqp[sES].oldFile = main.Game.world.myAvatar.objData.eqp[sES].sFile;
                        main.Game.world.myAvatar.objData.eqp[sES].oldLink = main.Game.world.myAvatar.objData.eqp[sES].sLink;
                        main.Game.world.myAvatar.objData.eqp[sES].sFile = (curItem.sFile == "undefined" ? "" : curItem.sFile);
                        main.Game.world.myAvatar.objData.eqp[sES].sLink = curItem.sLink;
                    }else{
                        if("sType" in curItem){
                            main.Game.world.myAvatar.objData.eqp[sES].sType = curItem.sType;
                        }
                        main.Game.world.myAvatar.objData.eqp[sES].sFile = (curItem.sFile == "undefined" ? "" : curItem.sFile);
                        main.Game.world.myAvatar.objData.eqp[sES].sLink = curItem.sLink;
                    }
                    main.Game.world.myAvatar.loadMovieAtES(sES, curItem.sFile, curItem.sLink);
                    if((sES == "pe") && (curItem.sName.indexOf("Bank Pet") != -1)){
                        petDisable.addEventListener(TimerEvent.TIMER, onPetDisable, false, 0, true);
                        petDisable.start();
                    }
                    this.visible = false;
                    main.events.dispatchEvent(new ClientEvent(ClientEvent.onCostumePending));
                    break;
            }
        }

        var petDisable:Timer = new Timer(0);
        function onPetDisable(e:TimerEvent):void{
            if(!main.Game.world.myAvatar.petMC.mcChar)
                return;
            main.Game.world.myAvatar.petMC.mcChar.mouseEnabled = false;
            main.Game.world.myAvatar.petMC.mcChar.mouseChildren = false;
            main.Game.world.myAvatar.petMC.mcChar.enabled = false;
            petDisable.reset();
            petDisable.removeEventListener(TimerEvent.TIMER, onPetDisable);
        }

        public function loadItem(e:*) : void
        {
            this.visible = true;
            var param1:* = e;
            if (curItem != param1)
            {
                this.btnTryMe.visible = false;
                this.pMC.visible = false;
                curItem = param1;
                switch(curItem.sES)
                {
                    case "Weapon":
                    case "he":
                    case "ba":
                    case "pe":
                    case "ar":
                    case "co":
                        if(curItem.bUpg == 1){
                            if(!main.Game.world.myAvatar.isUpgraded()){
                                this.btnTryMe.visible = false;
                            }else{
                                this.btnTryMe.visible = true;
                            }
                        }else{
                            this.btnTryMe.visible = true;
                        }
                    break;
                }
                switch(param1.sES)
                {
                    case "Weapon":
                    {
                        loadWeapon(param1.sFile, param1.sLink);
                        break;
                    }
                    case "he":
                    {
                        loadHelm(param1.sFile, param1.sLink);
                        break;
                    }
                    case "ba":
                    {
                        loadCape(param1.sFile, param1.sLink);
                        break;
                    }
                    case "pe":
                    {
                        loadPet(param1.sFile, param1.sLink);
                        break;
                    }
                    case "ar":
                    case "co":
                    {
                        loadArmor(param1.sFile, param1.sLink);
                        break;
                    }
                    case "ho":
                    {
                        loadHouse(param1.sFile);
                        break;
                    }
                    case "hi":
                    {
                        loadHouseItem(param1.sFile,param1.sLink);
                        break;
                    }
                    default:
                    {
                        loadItemFile();
                        break;
                    }
                }
            }
            return;
        }// end function

        private function clearStage() : void
        {
            var _loc_1:* = mcStage.numChildren - 1;
            while (_loc_1 >= 0)
            {
                
                mcStage.removeChildAt(_loc_1);
                _loc_1 = _loc_1 - 1;
            }
            return;
        }// end function

        var ldr:* = new Loader();
        private function loadHouseItem(param1, param2) : void
        {
            clearStage();
            sLinkHouse = param2;
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + param1),pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onloadHouseItemComplete,false,0,true);
            return;
        }
        
        private function onloadHouseItemComplete(param1:Event) : void
        {
            var _loc_3:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(sLinkHouse) as Class);
            var _loc_4:* = new _loc_3;
            _loc_4.x = 150;
            _loc_4.y = 200;
            mcStage.addChild(_loc_4);
            addGlow(_loc_4);
        }

        private function loadWeapon(param1, param2) : void
        {
            clearStage();
            sLinkWeapon = param2;
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + param1), pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadWeaponComplete, false, 0, true);
            return;
        }// end function

        private function loadCape(param1, param2) : void
        {
            clearStage();
            sLinkCape = param2;
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + param1), pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCapeComplete, false, 0, true);
            return;
        }// end function

        private function loadHelm(param1, param2) : void
        {
            clearStage();
            sLinkHelm = param2;
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + param1), pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHelmComplete, false, 0, true);
            return;
        }// end function

        private function loadPet(param1, param2) : void
        {
            clearStage();
            sLinkPet = param2;
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + param1), pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPetComplete, false, 0, true);
            return;
        }// end function

        private function loadHouse(param1) : void
        {
            clearStage();
            var _loc_2:* = "maps/" + curItem.sFile.substr(0, -4) + "_preview.swf";
            ldr = new Loader();
            ldr.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + _loc_2), pLoaderC);
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadHouseComplete, false, 0, true);
            return;
        }// end function

        function onLoadHouseComplete(event:Event) : void
        {
            var _loc_2:* = curItem.sFile.substr(0, -4).substr((curItem.sFile.lastIndexOf("/") + 1)).split("-").join("_") + "_preview";
            var _loc_3:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(_loc_2) as Class);
            var _loc_4:* = new _loc_3;
            _loc_4.x = 150;
            _loc_4.y = 200;
            mcStage.addChild(_loc_4);
            addGlow(_loc_4);
            return;
        }// end function

        private function loadArmor(param1, param2) : void
        {
            clearStage();
            sLinkArmor = param2;
            var _loc_3:* = this.pMC;
            var objChar:Object = new Object();
            objChar.strGender = main.Game.world.myAvatar.objData.strGender;
            _loc_3.pAV.objData = objChar;
            _loc_3.x = 150;
            _loc_3.y = 250;
            var _loc_4:* = 1.65;
            _loc_3.scaleY = 1.65;
            _loc_3.scaleX = _loc_4;
            _loc_3.loadArmor(param1, param2);
            addGlow(_loc_3);
            _loc_3.visible = true;
            return;
        }// end function

        function onLoadWeaponComplete(event:Event) : void
        {
            var mc:MovieClip;
            var AssetClass:Class;
            var e:* = event;
            try
            {
                AssetClass = (ldr.contentLoaderInfo.applicationDomain.getDefinition(sLinkWeapon) as Class);
                mc = new AssetClass;
            }
            catch (err:Error)
            {
                mc = MovieClip(e.target.content);
            }
            mc.x = 150;
            mc.y = 180;
            var _loc_3:* = 0.3;
            mc.scaleY = 0.3;
            mc.scaleX = _loc_3;
            mcStage.addChild(mc);
            addGlow(mc);
            return;
        }// end function

        function onLoadCapeComplete(event:Event) : void
        {
            var _loc_2:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(sLinkCape) as Class);
            var _loc_3:* = new _loc_2;
            _loc_3.x = 150;
            _loc_3.y = 150;
            var _loc_4:* = 0.5;
            _loc_3.scaleY = 0.5;
            _loc_3.scaleX = _loc_4;
            mcStage.addChild(_loc_3);
            addGlow(_loc_3);
            return;
        }// end function

        function onLoadHelmComplete(event:Event) : void
        {
            var _loc_2:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(sLinkHelm) as Class);
            var _loc_3:* = new _loc_2;
            _loc_3.x = 170;
            _loc_3.y = 200;
            mcStage.addChild(_loc_3);
            addGlow(_loc_3);
            return;
        }// end function

        function onLoadPetComplete(event:Event) : void
        {
            var _loc_2:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(sLinkPet) as Class);
            var _loc_3:* = new _loc_2;
            _loc_3.x = 150;
            _loc_3.y = 250;
            var _loc_4:* = 2;
            _loc_3.scaleY = 2;
            _loc_3.scaleX = _loc_4;
            mcStage.addChild(_loc_3);
            addGlow(_loc_3);
            return;
        }// end function

        private function addGlow(param1:MovieClip) : void
        {
            var _loc_2:* = new GlowFilter(16777215, 1, 8, 8, 2, 1, false, false);
            param1.filters = [_loc_2];
            return;
        }// end function

        private function loadItemFile() : void
        {
            clearStage();
            var _loc_1:* = new Loader();
            _loc_1.load(new URLRequest("http://aqworldscdn.aq.com/game/gamefiles/" + curItem.sFile), pLoaderC);
            _loc_1.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadItemFileComplete, false, 0, true);
            _loc_1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
            return;
        }// end function

        function onLoadItemFileComplete(event:Event) : void
        {
            var _loc_2:* = (ldr.contentLoaderInfo.applicationDomain.getDefinition(curItem.sLink) as Class);
            var _loc_3:* = new _loc_2;
            _loc_3.x = 150;
            _loc_3.y = 250;
            if (_loc_3.height > 225)
            {
                _loc_3.height = 225;
                _loc_3.scaleX = _loc_3.scaleY;
            }
            if (_loc_3.width > 275)
            {
                _loc_3.width = 275;
                _loc_3.scaleY = _loc_3.scaleX;
            }
            mcStage.addChild(_loc_3);
            addGlow(_loc_3);
            return;
        }// end function

        function onLoadError(event:Event) : void
        {
            var _loc_2:* = main.Game.world.getClass("iibag") as Class;
            var _loc_3:* = new _loc_2;
            _loc_3.x = 150;
            _loc_3.y = 180;
            _loc_3.scaleY = _loc_3.scaleX = 1;
            mcStage.addChild(_loc_3);
            addGlow(_loc_3);
            return;
        }// end function

        private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
		}
    }
}

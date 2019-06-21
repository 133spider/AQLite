package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.handlers.flags;
    import net.spider.handlers.ClientEvent;
    import net.spider.draw.colorSets;

    public class tryMe extends MovieClip {
        private var shopTimer:Timer;
        public function tryMe(){
            this.visible = false;
            this.btnTry.visible = false;
            this.txtShop.visible = false;
            this.txtShop.mouseEnabled = false;
            this.btnTryMerge.visible = false;
            this.txtMerge.visible = false;
            this.txtMerge.mouseEnabled = false;
            this.btnTry.addEventListener(MouseEvent.CLICK, onBtnTry);
            this.btnTryMerge.addEventListener(MouseEvent.CLICK, onBtnTry);
            shopTimer = new Timer(0);
			shopTimer.addEventListener(TimerEvent.TIMER, onTimer);
            shopTimer.start();
        }

        public var once:Boolean = false;
        public var once2:Boolean = false;
        public function onTimer(e:TimerEvent):void{
            if(!main.Game)
                return;
            if(!main.Game.ui)
                return;
            if(main.Game.ui.mcPopup.getChildByName("mcShop")){
                this.visible = (isPreviewable());
                if((main.Game.ui.mcPopup.currentLabel == "Shop") && main.Game.ui.mcPopup.getChildByName("mcShop").previewPanel.visible){
                    this.btnTry.visible = true;
                    this.txtShop.visible = true;
                    this.btnTryMerge.visible = false;
                    this.txtMerge.visible = false;
                }else if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                    this.btnTryMerge.visible = true;
                    this.txtShop.visible = false;
                    this.btnTry.visible = false;
                    this.txtMerge.visible = true;
                }else{
                    this.visible = false;
                    this.btnTry.visible = false;
                    this.txtShop.visible = false;
                    this.btnTryMerge.visible = false;
                    this.txtMerge.visible = false;
                }
            }else{
                this.visible = false;
                this.btnTry.visible = false;
                this.txtShop.visible = false;
                this.btnTryMerge.visible = false;
                this.txtMerge.visible = false;
            }
            if(main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor") && !once){
                trace("HELLO WORLD");
                main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.addEventListener("ROLL_OVER",onItemRollOver,false,0,true);
                main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.addEventListener("ROLL_OUT",onItemRollOut,false,0,true);

                if(!main.Game.ui.getChildByName("colorSets")){
					var _menu:colorSets = new colorSets();
                    _menu.mode = "mcCustomizeArmor";
					_menu.name = "colorSets";
                    _menu.y += main.Game.ui.mcPopup.mcCustomizeArmor.height + 12;
                    _menu.onUpdate();
					main.Game.ui.mcPopup.mcCustomizeArmor.addChild(_menu);
				}

                once = true;
            }else if(once && !main.Game.ui.mcPopup.getChildByName("mcCustomizeArmor")){
                once = false;
            }

            if(main.Game.ui.mcPopup.getChildByName("mcCustomize") && !once2){
                trace("HELLO WORLD2");

                if(!main.Game.ui.getChildByName("colorSets")){
					var _menu2:colorSets = new colorSets();
                    _menu2.mode = "mcCustomize";
					_menu2.name = "colorSets";
                    _menu2.y += main.Game.ui.mcPopup.mcCustomize.height + 12;
                    _menu2.onUpdate();
					main.Game.ui.mcPopup.mcCustomize.addChild(_menu2);
				}

                once2 = true;
            }else if(once2 && !main.Game.ui.mcPopup.getChildByName("mcCustomize")){
                once2 = false;
            }
        }

        public function onItemRollOver(param1:Event) : void
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
        
        public function onItemRollOut(param1:Event) : void
        {
            main.Game.world.myAvatar.pMC.updateColor();
        }

        function isPreviewable():Boolean{
            if(!main.Game.ui.mcPopup.getChildByName("mcShop").iSel)
                return false;
            switch(main.Game.ui.mcPopup.getChildByName("mcShop").iSel.sES)
            {
                case "Weapon":
                case "he":
                case "ba":
                case "pe":
                case "ar":
                case "co":
                    if(main.Game.ui.mcPopup.getChildByName("mcShop").iSel.bUpg == 1)
                        if(!main.Game.world.myAvatar.isUpgraded())
                            return false;
                    return true;
                case "ho":
                case "hi":
                default:
                    return false;
            }
        }

        var item:*;
        function onBtnTry(e:MouseEvent):void{
            item = main.Game.ui.mcPopup.getChildByName("mcShop").iSel;
            var sES:String = item.sES;
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
                if("sType" in item){
                    main.Game.world.myAvatar.objData.eqp[sES].oldType = main.Game.world.myAvatar.objData.eqp[sES].sType;
                    main.Game.world.myAvatar.objData.eqp[sES].sType = item.sType;
                }
                main.Game.world.myAvatar.objData.eqp[sES].oldFile = main.Game.world.myAvatar.objData.eqp[sES].sFile;
                main.Game.world.myAvatar.objData.eqp[sES].oldLink = main.Game.world.myAvatar.objData.eqp[sES].sLink;
                main.Game.world.myAvatar.objData.eqp[sES].sFile = (item.sFile == "undefined" ? "" : item.sFile);
                main.Game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
            }else{
                if("sType" in item){
                    main.Game.world.myAvatar.objData.eqp[sES].sType = item.sType;
                }
                main.Game.world.myAvatar.objData.eqp[sES].sFile = (item.sFile == "undefined" ? "" : item.sFile);
                main.Game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
            }
            main.Game.world.myAvatar.loadMovieAtES(sES, item.sFile, item.sLink);
            if((sES == "pe") && (item.sName.indexOf("Bank Pet") != -1)){
                petDisable.addEventListener(TimerEvent.TIMER, onPetDisable, false, 0, true);
                petDisable.start();
            }
            if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                main.Game.ui.mcPopup.getChildByName("mcShop").fClose();
            }else{
                main.Game.ui.mcPopup.getChildByName("mcShop").previewPanel.visible = false;
            }
            main.events.dispatchEvent(new ClientEvent(ClientEvent.onCostumePending));
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

        /**
            var item:*;
        function onBtnTry(e:MouseEvent):void{
            item = main.Game.ui.mcPopup.getChildByName("mcShop").iSel;
            var sES:String = item.sES;
            if(sES == "ar")
                sES = "co";
            main.Game.world.myAvatar.objData.eqp[sES] = {};
            main.Game.world.myAvatar.objData.eqp[sES].sFile = item.sFile == "undefined"?"":item.sFile;
            main.Game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
            if("sType" in item)
            {
                main.Game.world.myAvatar.objData.eqp[sES].sType = item.sType;
            }
            if("ItemID" in item)
            {
                main.Game.world.myAvatar.objData.eqp[sES].ItemID = item.ItemID;
            }
            if("sMeta" in item)
            {
                main.Game.world.myAvatar.objData.eqp[sES].sMeta = item.sMeta;
            }
            main.Game.world.myAvatar.loadMovieAtES(sES, item.sFile, item.sLink);
            if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                main.Game.ui.mcPopup.getChildByName("mcShop").fClose();
            }else{
                main.Game.ui.mcPopup.getChildByName("mcShop").previewPanel.visible = false;
            }
        }
        **/
    }
}
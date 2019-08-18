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
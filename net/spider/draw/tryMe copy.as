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
    import net.spider.draw.btGender;
    import net.spider.avatar.AvatarMC;
    import com.adobe.utils.StringUtil;

    public class tryMe extends MovieClip {

        public var mcBtGender:*;
        public function tryMe(){
            onEstablish();
            this.txtShop.mouseEnabled = false;
            this.btnTry.addEventListener(MouseEvent.CLICK, onBtnTry);
            
            mcBtGender = this.addChild(new btGender());
            mcBtGender.name = "btGender";
            mcBtGender.visible = false;
            mcBtGender.height = 25; 
            mcBtGender.width = 30;
            mcBtGender.addEventListener(MouseEvent.CLICK, onBtGender);
        }

        public function onClick(e:MouseEvent):void{
            if(flash.utils.getQualifiedClassName(e.target).indexOf("LPFElementListItemItem") > -1){
                var mcFocus:String;
                var focusMovie:MovieClip;
                if(main.Game.ui.mcPopup.currentLabel == "Shop"){
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.getChildAt(3);
                    mcFocus = "mcShop";
                }else if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.getChildAt(3);
                    mcFocus = "mcShop";
                }else{
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
                    mcFocus = "mcInventory";
                }
                focusMovie.mcPreview.visible = true;
                focusMovie.removeChild(focusMovie.getChildByName("genderPreview"));
                MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).removeEventListener(MouseEvent.CLICK, onClick);
            }
        }

        public function onBtGender(e:Event):void{
            var mcFocus:String;
            var focusMovie:MovieClip;

            switch(main.Game.ui.mcPopup.currentLabel){
                case "Shop":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.getChildAt(3);
                    mcFocus = "mcShop";
                    break;
                case "MergeShop":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.getChildAt(3);
                    mcFocus = "mcShop";
                    break;
                case "Inventory":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
                    mcFocus = "mcInventory";
                    break;
            }

            focusMovie.mcPreview.visible = !focusMovie.mcPreview.visible;

            if(!focusMovie.getChildByName("genderPreview")){
                var genderPreview:* = focusMovie.addChild(new AvatarMC());
                genderPreview.name = "genderPreview";
            }

            focusMovie.getChildByName("genderPreview").visible = !focusMovie.mcPreview.visible;
            if(focusMovie.getChildByName("genderPreview").visible){
                var objChar:Object = new Object();
                objChar.strGender = (main.Game.world.myAvatar.objData.strGender == "M") ? "F" : "M";
                (focusMovie.getChildByName("genderPreview") as AvatarMC).pAV.objData = objChar;
                focusMovie.getChildByName("genderPreview").x = focusMovie.mcPreview.x;
                focusMovie.getChildByName("genderPreview").y = focusMovie.mcPreview.y;
                (focusMovie.getChildByName("genderPreview") as AvatarMC).loadArmor(main.Game.ui.mcPopup.getChildByName(mcFocus).iSel.sFile, main.Game.ui.mcPopup.getChildByName(mcFocus).iSel.sLink);
                focusMovie.setChildIndex(focusMovie.getChildByName("genderPreview"), (focusMovie.getChildIndex(focusMovie.tInfo)-1));
            }
            if(!MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).hasEventListener(MouseEvent.CLICK))
                MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).addEventListener(MouseEvent.CLICK, onClick);
        }

        public function onEstablish():void{
            var mcFocus:MovieClip;
            var mcTarget:String;
            var mcUI:MovieClip;
            switch(main.Game.ui.mcPopup.currentLabel){
                case "Shop":
                    if(!main.Game.ui.mcPopup.getChildByName("mcShop")){
                        mcTarget = "None";
                        break;
                    }
                    mcFocus = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.getChildAt(3);
                    mcTarget = (MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.visible) ? "mcShop" : "None";
                    break;
                case "MergeShop":
                    if(!main.Game.ui.mcPopup.getChildByName("mcShop")){
                        mcTarget = "None";
                        break;
                    }
                    mcFocus = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.getChildAt(3);
                    mcTarget = (MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.visible) ? "mcShop" : "None";
                    break;
                case "Inventory":
                    if(!main.Game.ui.mcPopup.getChildByName("mcInventory")){
                        mcTarget = "None";
                        break;
                    }
                    mcFocus = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
                    mcTarget = (MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.visible) ? "mcInventory" : "None";
                    break;
                default:
                    mcTarget = "None";
                    break;
            }

            mcUI = main.Game.ui.mcPopup.getChildByName(mcTarget);
            if(mcTarget == "None" || !mcUI){
                this.visible = false;
                return;
            }

            if(mcFocus.tInfo.textHeight > mcFocus.tInfo.height){
                mcUI.iSel.sDesc = StringUtil.trim(mcUI.iSel.sDesc);
                mcFocus.tInfo.htmlText = main.Game.getItemInfoStringB(mcUI.iSel);
                if(mcFocus.tInfo.textHeight >= 109.8)
                    mcFocus.tInfo.y = int((mcFocus.btnDelete.y + mcFocus.btnDelete.height) - 
                        (mcFocus.tInfo.height - ((mcFocus.tInfo.textHeight == 109.8 || mcFocus.tInfo.textHeight == 122.95) ? 15 : 3)));
            }

            this.visible = (main.Game.ui.mcPopup.currentLabel == "Inventory") ? true : (isPreviewable());

            if((main.Game.ui.mcPopup.currentLabel == "Shop") && mcUI.previewPanel.visible && !(mcUI.splitPanel.visible)){
                mcBtGender.x = 264;
                mcBtGender.y = -185;
            }else if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                mcBtGender.x = -62;
                mcBtGender.y = -180;
            }else if((main.Game.ui.mcPopup.currentLabel == "Inventory") && !(mcUI.splitPanel.visible)){
                mcBtGender.x = 264;
                mcBtGender.y = -210;
            }

            mcBtGender.visible = isGender(mcTarget);
            this.btnTry.visible = this.txtShop.visible = (main.Game.ui.mcPopup.currentLabel == "Shop") && mcUI.previewPanel.visible && !(mcUI.splitPanel.visible);
            this.btnTryMerge.visible = this.txtMerge.visible = (main.Game.ui.mcPopup.currentLabel == "MergeShop");
        }

        function isGender(mcFocus:String):Boolean{
            if(main.Game.ui.mcPopup.currentLabel != "MergeShop")
                if(main.Game.ui.mcPopup.getChildByName(mcFocus).splitPanel.visible)
                    return false;
            if(!main.Game.ui.mcPopup.getChildByName(mcFocus).iSel)
                return false;
            switch(main.Game.ui.mcPopup.getChildByName(mcFocus).iSel.sES)
            {
                case "ar":
                case "co":
                    return true;
                default:
                    return false;
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
    }
}
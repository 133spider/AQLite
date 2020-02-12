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

        public function tryMe(){
            this.btnTry.addEventListener(MouseEvent.CLICK, onBtnTry, false, 0, true);
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
            }else{
                if("sType" in item){
                    main.Game.world.myAvatar.objData.eqp[sES].sType = item.sType;
                }
            }
            main.Game.world.myAvatar.objData.eqp[sES].sFile = (item.sFile == "undefined" ? "" : item.sFile);
            main.Game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
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
package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import net.spider.main;
    import net.spider.handlers.optionHandler;
    import net.spider.modules.hidemonsters;

    public class cMenu extends MovieClip {

        public var cnt:MovieClip;
        var world:MovieClip;
        var fData:Object = null;
        var isOpen:Boolean = false;
        var fMode:String;
        var mc:MovieClip;
        var rootClass:MovieClip;
        var iHi:Number = -1;
        var iSel:Number = -1;
        var iCT:ColorTransform;

        public function cMenu(){
            addFrameScript(0, frame1, 4, frame5, 9, frame10);
            mc = MovieClip(this);
            rootClass = MovieClip(main.Game);
            mc.cnt.iproto.visible = false;
            mc.addEventListener(MouseEvent.MOUSE_OVER, mouseOn);
            mc.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            fData = {};
            fData.params = {};
            fData.user = ["Char Page", "Is Staff?", "Hide Weapon", "Hide Player", "Disable Wep Anim", "Whisper", "Add Friend", "Go To", "Invite", "Report", "Delete Friend", "Ignore", "Close"];
            fData.party = ["Char Page", "Whisper", "Add Friend", "Go To", "Remove", "Summon", "Promote", "Report", "Delete Friend", "Ignore", "Close"];
            fData.self = ["Char Page", "Reputation", "Leave Party", "Close"];
            fData.pvpqueue = ["Leave Queue", "Close"];
            fData.offline = ["Delete Friend", "Close"];
            fData.ignored = ["Unignore", "Close"];
            fData.mons = ["Freeze Monster", "Hide Monster", "Close"];
            fData.cl = [];
            fData.clc = [];
        }
        public function fOpenWith(_arg1, _arg2){
            var _local7:*;
            var _local8:*;
            var _local9:*;
            isOpen = true;
            fMode = _arg1.toLowerCase();
            fData.params = _arg2;
            mc.cnt.mHi.visible = false;
            iCT = mc.cnt.mHi.transform.colorTransform;
            iCT.color = 13434675;
            mc.cnt.mHi.transform.colorTransform = iCT;
            var _local3:int;
            _local3 = 0;
            while (_local3 < fData.user.length) {
                _local7 = mc.cnt.getChildByName(("i" + _local3));
                if (_local7 != null){
                    _local7.removeEventListener(MouseEvent.CLICK, itemClick);
                    _local7.removeEventListener(MouseEvent.MOUSE_OVER, itemMouseOver);
                    mc.cnt.removeChild(_local7);
                };
                _local3++;
            };
            var _local4:* = 0;
            delete fData.cl;
            delete fData.clc;
            var _local5:* = fData.params.strUsername.toLowerCase();
            var _local6:* = rootClass.world.uoTree[_local5];
            fData.cl = rootClass.copyObj(fData[fMode]);
            fData.clc = [];
            _local3 = 0;
            while (_local3 < fData.cl.length) {
                if ((((fData.cl[_local3] == "Add Friend")) && (rootClass.world.myAvatar.isFriend(fData.params.ID)))){
                    fData.cl.splice(_local3, 1);
                    _local3--;
                };
                if ((((fData.cl[_local3] == "Delete Friend")) && (!(rootClass.world.myAvatar.isFriend(fData.params.ID))))){
                    fData.cl.splice(_local3, 1);
                    _local3--;
                };
                _local3++;
            };
            _local3 = 0;
            while (_local3 < fData.cl.length) {
                if ((((fData.cl[_local3] == "Ignore")) && (rootClass.chatF.isIgnored(_local5)))){
                    fData.cl[_local3] = "Unignore";
                }
                if ((fData.cl[_local3] == "Hide Player") && !rootClass.world.getAvatarByUserName(_local5).pMC.mcChar.visible){
                    fData.cl[_local3] = "Show Player";
                }
                if ((fData.cl[_local3] == "Hide Weapon") && !rootClass.world.getAvatarByUserName(_local5).pMC.mcChar.weapon.visible){
                    fData.cl[_local3] = "Show Weapon";
                }
                if ((fData.cl[_local3] == "Freeze Monster") && fData.params.target.noMove){
                    fData.cl[_local3] = "UnFreeze Monster";
                }
                if ((fData.cl[_local3] == "Hide Monster") && !fData.params.target.getChildAt(1).visible){
                    fData.cl[_local3] = "Show Monster";
                }
                _local8 = mc.cnt.addChild(new cProto());
                _local8.name = ("i" + _local3);
                _local8.y = (mc.cnt.iproto.y + (_local3 * 14));
                iCT = _local8.transform.colorTransform;
                _local9 = true;
                switch (fData.cl[_local3].toLowerCase()){
                    case "add friend":
                        if (((((!((rootClass.world.getAvatarByUserName(_local5) == null))) && (!((rootClass.world.getAvatarByUserName(_local5).objData == null))))) && (((rootClass.world.getAvatarByUserName(_local5).isStaff()) && (!(rootClass.world.myAvatar.isStaff())))))){
                            _local9 = false;
                        };
                        break;
                    case "go to":
                        if (!((rootClass.world.isPartyMember(_local5)) || (rootClass.world.myAvatar.isFriend(fData.params.ID)))){
                            _local9 = false;
                        };
                        break;
                    case "ignore":
                    case "unignore":
                        if (_local5 == rootClass.sfc.myUserName){
                            _local9 = false;
                        };
                        break;
                    case "invite":
                        if ((((((((((((((_local5 == rootClass.sfc.myUserName)) || ((_local6 == null)))) || (((((!((rootClass.world.getAvatarByUserName(_local5) == null))) && (!((rootClass.world.getAvatarByUserName(_local5).objData == null))))) && (((rootClass.world.getAvatarByUserName(_local5).isStaff()) && (!(rootClass.world.myAvatar.isStaff())))))))) || ((rootClass.world.partyMembers.length > 4)))) || (rootClass.world.isPartyMember(fData.params.strUsername)))) || (((rootClass.world.bPvP) && (!((_local6.pvpTeam == rootClass.world.myAvatar.dataLeaf.pvpTeam))))))) || ((((rootClass.world.partyMembers.length > 0)) && (!((rootClass.world.partyOwner.toLowerCase() == rootClass.sfc.myUserName))))))){
                            _local9 = false;
                        };
                        break;
                    case "leave party":
                        if (rootClass.world.partyMembers.length == 0){
                            _local9 = false;
                        };
                        break;
                    case "remove":
                        if (rootClass.world.partyOwner.toLowerCase() != rootClass.sfc.myUserName){
                            fData.cl[_local3] = "Leave Party";
                        };
                        break;
                    case "private: on":
                    case "private: off":
                    case "promote":
                        if (rootClass.world.partyOwner != rootClass.world.myAvatar.objData.strUsername){
                            _local9 = false;
                        };
                        break;
                    case "inspect":
                        if ((((_local6 == null)) || (!((_local6.strFrame == rootClass.world.strFrame))))){
                            _local9 = false;
                        };
                        break;
                };
                if (_local9){
                    iCT.color = 0x999999;
                    _local8.addEventListener(MouseEvent.CLICK, itemClick, false, 0, true);
                    _local8.buttonMode = true;
                } else {
                    iCT.color = 0x666666;
                };
                _local8.addEventListener(MouseEvent.MOUSE_OVER, itemMouseOver, false, 0, true);
                fData.clc.push(iCT.color);
                _local8.ti.text = fData.cl[_local3];
                if (_local8.ti.textWidth > _local4){
                    _local4 = _local8.ti.textWidth;
                };
                _local8.transform.colorTransform = iCT;
                _local8.ti.width = (_local8.ti.textWidth + 5);
                _local8.hit.width = ((_local8.ti.x + _local8.ti.textWidth) + 2);
                _local3++;
            };
            mc.cnt.bg.height = (mc.cnt.getChildByName(String(("i" + (fData.cl.length - 1)))).y + 26);
            mc.cnt.bg.width = (_local4 + 20);
            mc.x = (MovieClip(parent).mouseX - 5);
            mc.y = (MovieClip(parent).mouseY - 5);
            if ((mc.x + mc.cnt.bg.width) > 960){
                mc.x = (MovieClip(parent).mouseX - mc.cnt.bg.width);
            };
            if ((mc.y + mc.cnt.bg.height) > 500){
                mc.y = (500 - mc.cnt.bg.height);
            };
            mc.gotoAndPlay("in");
        }
        public function fClose(){
            isOpen = false;
            if (mc.currentFrame != 1){
                if (mc.currentFrame == 10){
                    mc.gotoAndPlay("out");
                } else {
                    mc.gotoAndStop("hold");
                };
            };
        }
        private function itemMouseOver(_arg1:MouseEvent){
            var _local4:*;
            var _local2:* = MovieClip(_arg1.currentTarget);
            iHi = int(_local2.name.substr(1));
            var _local3:int;
            _local3 = 0;
            while (_local3 < fData.cl.length) {
                _local4 = mc.cnt.getChildByName(("i" + _local3));
                iCT = _local4.transform.colorTransform;
                if (_local3 == iHi){
                    if (_local2.hasEventListener(MouseEvent.CLICK)){
                        iCT.color = 0xFFFFFF;
                        cnt.mHi.visible = true;
                        cnt.mHi.y = (_local4.y + 3);
                    } else {
                        cnt.mHi.visible = false;
                    };
                } else {
                    iCT.color = fData.clc[_local3];
                };
                _local4.transform.colorTransform = iCT;
                _local3++;
            };
        }

        private function itemClick(_arg1:MouseEvent){
            var _local3:String;
            var _local5:String;
            var _local6:int;
            var _local2:* = MovieClip(_arg1.currentTarget);
            var playerMC:*;
            iSel = int(_local2.name.substr(1));
            iCT = mc.cnt.mHi.transform.colorTransform;
            iCT.color = 16763955;
            mc.cnt.mHi.transform.colorTransform = iCT;
            fClose();
            _local3 = fData.cl[iSel];
            var _local4:String = fData.params.strUsername;
            switch (_local3.toLowerCase()){
                case "freeze monster":
                    fData.params.target.noMove = true;
                    break;
                case "unfreeze monster":
                    fData.params.target.noMove = false;
                    break;
                case "hide monster":
                    fData.params.target.getChildAt(1).visible = false;
                    fData.params.target.shadow.addEventListener(MouseEvent.CLICK, hidemonsters.onClickHandler, false, 0, true);
                    fData.params.target.shadow.mouseEnabled = true;
                    fData.params.target.shadow.buttonMode = true;
                    break;
                case "show monster":
                    fData.params.target.getChildAt(1).visible = true;
                    fData.params.target.shadow.removeEventListener(MouseEvent.CLICK, hidemonsters.onClickHandler);
                    fData.params.target.shadow.mouseEnabled = false;
                    fData.params.target.shadow.buttonMode = false;
                    break;
                case "char page":
                    rootClass.mixer.playSound("Click");
                    navigateToURL(new URLRequest(("http://www.aq.com/character.asp?id=" + _local4)), "_blank");
                    break;
                case "is staff?":
                    rootClass.world.isModerator(_local4);
                    break;
                case "show weapon":
                    playerMC = rootClass.world.getAvatarByUserName(_local4);
                    playerMC.pMC.mcChar.weapon.visible = true;
                    if(playerMC.pMC.pAV.getItemByEquipSlot("Weapon").sType == "Dagger"){
                        playerMC.pMC.mcChar.weaponOff.visible = true;
                    }
                    break;
                case "show player":
                    playerMC = rootClass.world.getAvatarByUserName(_local4);
                    playerMC.pMC.mcChar.visible = true;
                    playerMC.pMC.pname.visible = true;
                    playerMC.pMC.shadow.visible = true;
                    break;
                case "hide weapon":
                    playerMC = rootClass.world.getAvatarByUserName(_local4);
                    playerMC.pMC.mcChar.weapon.visible = false;
                    playerMC.pMC.mcChar.weaponOff.visible = false;
                    break;
                case "hide player":
                    playerMC = rootClass.world.getAvatarByUserName(_local4);
                    playerMC.pMC.mcChar.visible = false;
                    if(!optionHandler.filterChecks["chkName"])
                        playerMC.pMC.pname.visible = false;
                    if(optionHandler.filterChecks["chkShadow"]){
                        playerMC.pMC.shadow.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
                        playerMC.pMC.shadow.mouseEnabled = true;
                        playerMC.pMC.shadow.buttonMode = true;
                    }else{
                        playerMC.pMC.shadow.visible = false;
                    }
                    break;
                case "disable wep anim":
                    playerMC = rootClass.world.getAvatarByUserName(_local4);
                    playerMC.pMC.mcChar.weapon.mcWeapon.gotoAndStop(0);
                    (playerMC.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip).gotoAndStop(0);
                    movieClipStopAll(playerMC.pMC.mcChar.weapon.mcWeapon);
                    movieClipStopAll((playerMC.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip));
                    break;
                case "reputation":
                    rootClass.mixer.playSound("Click");
                    rootClass.showFactionInterface();
                    break;
                case "whisper":
                    toPM = _local4;
                    rootClass.chatF.chn.cur = rootClass.chatF.chn.whisper;
                    updateMsg();
                    break;
                case "ignore":
                    rootClass.chatF.ignore(_local4);
                    rootClass.chatF.pushMsg("server", (("You are now ignoring user " + _local4) + "."), "SERVER", "", 0);
                    break;
                case "unignore":
                    rootClass.chatF.unignore(_local4);
                    rootClass.chatF.pushMsg("server", (("User " + _local4) + " is no longer being ignored."), "SERVER", "", 0);
                    break;
                case "report":
                    rootClass.ui.mcPopup.fOpen("Report", {unm:_local4});
                    break;
                case "close":
                    if ((((fMode == "user")) || ((fMode == "party")))){
                        rootClass.world.cancelTarget();
                    };
                    break;
                case "add friend":
                    if (rootClass.world.myAvatar.friends.length >= 100){
                        rootClass.chatF.pushMsg("server", "You are too popular! (40 friends max)", "SERVER", "", 0);
                    } else {
                        rootClass.world.requestFriend(_local4);
                    };
                    break;
                case "delete friend":
                    rootClass.world.deleteFriend(fData.params.ID, _local4);
                    break;
                case "go to":
                    rootClass.world.goto(_local4);
                    break;
                case "invite":
                    rootClass.world.partyInvite(_local4);
                    break;
                case "remove":
                    rootClass.world.partyKick(_local4);
                    break;
                case "leave party":
                    rootClass.world.partyLeave();
                    break;
                case "private: on":
                case "private: off":
                    _local5 = _local3.toLowerCase().split(": ")[0];
                    _local6 = ((_local3.toLowerCase().split(": ")[1])=="on") ? 1 : 0;
                    rootClass.world.partyUpdate(_local5, _local6);
                    break;
                case "promote":
                    rootClass.world.partyPromote(_local4);
                    break;
                case "summon":
                    rootClass.world.partySummon(_local4);
                    break;
                case "leave queue":
                    rootClass.world.requestPVPQueue("none");
                    break;
            };
        }
        private function onClickHandler(e:MouseEvent):void{
            var tAvt:*;
            tAvt = e.currentTarget.parent.pAV;
            if (e.shiftKey)
            {
                rootClass.world.onWalkClick();
            }
            else
            {
                if (!e.ctrlKey)
                {
                    if (((((((!((tAvt == rootClass.world.myAvatar))) && (rootClass.world.bPvP))) && (!((tAvt.dataLeaf.pvpTeam == rootClass.world.myAvatar.dataLeaf.pvpTeam))))) && ((tAvt == rootClass.world.myAvatar.target))))
                    {
                        rootClass.world.approachTarget();
                    }
                    else
                    {
                        if (tAvt != rootClass.world.myAvatar.target)
                        {
                            rootClass.world.setTarget(tAvt);
                        }
                    }
                }
            }
        }
        function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
                    (container.getChildAt(i) as MovieClip).gotoAndStop(0);
                    movieClipStopAll(container.getChildAt(i) as MovieClip);
                }
        }
        private var toPM:String;
        private function updateMsg():void{
            rootClass.chatF.pmI = 0;
            rootClass.chatF.myMsgsI = 0;
            rootClass.ui.mcInterface.tebg.addEventListener(MouseEvent.CLICK, chat_focus);
            rootClass.ui.mcInterface.te.visible = true;
            rootClass.ui.mcInterface.te.type = TextFieldType.INPUT;
            rootClass.stage.focus = null;
            rootClass.stage.focus = rootClass.ui.mcInterface.te;
            rootClass.chatF.formatMsgEntry(toPM);
            rootClass.chatF.updateMsgEntry();
        }
        private function chat_focus(e:MouseEvent):void{
            if (rootClass.stage.focus != rootClass.ui.mcInterface.te){
               updateMsg();
            }
        }
        private function mouseOn(_arg1:MouseEvent){
            this.cnt.gotoAndStop("hold");
        }
        private function mouseOut(_arg1:MouseEvent){
            this.cnt.gotoAndPlay("out");
        }
        function frame1(){
            visible = false;
            stop();
        }
        function frame5(){
            visible = true;
        }
        function frame10(){
            stop();
        }

    }
}//package 
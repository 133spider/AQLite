package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.filters.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.avatar.*;
    import net.spider.handlers.*;
    import fl.events.*;
    import fl.data.*;
	
	public class charPage extends MovieClip {
		
		var socket:SecureSocket;
        var userName:String;
		public function charPage(_userName:String) {
            this.x = 205;
            this.y = 80;
            this.visible = false;
            userName = _userName;

            socket = new SecureSocket(); 
            //socket.addEventListener(Event.CONNECT, connectHandler); 
            socket.addEventListener(Event.CLOSE, closeHandler); 
            //socket.addEventListener(ErrorEvent.ERROR, errorHandler); 
            socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
            socket.addEventListener(ProgressEvent.SOCKET_DATA, onCharPageLoad); 
            try 
            { 
                socket.connect("account.aq.com", 443); 
                socket.writeUTFBytes('GET /CharPage?id=' + userName.split(" ").join("+") + ' HTTP/1.1\r\n');
                socket.writeUTFBytes('User-Agent: Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) ArtixGameLauncher/2.0.4 Chrome/73.0.3683.121 Electron/5.0.11 Safari/537.36\r\n');
                socket.writeUTFBytes('Host: account.aq.com\r\n');
                socket.writeUTFBytes('Connection: close\r\n\r\n');
                socket.flush();
            } 
            catch (error:Error) 
            { 
                socket.close(); 
            } 

            this.btCharPage.addEventListener(MouseEvent.CLICK, onBtCharPage, false, 0, true);
            this.btClose.addEventListener(MouseEvent.CLICK, onBtClose, false, 0, true);

            this.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onStopDrag, false, 0, true);
		}

        public function onDrag(e:MouseEvent):void{
			this.startDrag();
		}

		public function onStopDrag(e:MouseEvent):void{
			this.stopDrag();
		}

        var flashvars:URLVariables;
        public function closeHandler(e:*):void{
            if(htmlContent.indexOf("FlashVars") == -1){
                var modalClass:Class;
                var modal:*;
                var modalO:*;
                modalClass= main.Game.world.getClass("ModalMC");
                modal = new modalClass();
                modalO = {};
                modalO.strBody = "User not found: " + userName;
                modalO.params = {};
                modalO.glow = "red,medium";
                modalO.btns = "mono";
                main._stage.addChild(modal);
                modal.init(modalO);
                return;
            }
            htmlContent = htmlContent.split("<param name=\"FlashVars\" value=\"&amp;")[1];
            htmlContent = htmlContent.split("\" />")[0];
            htmlContent = htmlContent.split("&amp;").join("&");
            htmlContent = htmlContent.split("&quot;").join("\"");
            htmlContent = htmlContent.split(" ").join("+");
            trace(htmlContent);
            flashvars = new URLVariables(htmlContent);
            //TODO: level, name, etc
            this.txtUserName.text = flashvars.strName.split("+").join(" ");
            this.txtLvl.text = (flashvars.intLevel.split("+").join(" ")).split(" -")[0];

            if((flashvars.intLevel.split("+").join(" ")).indexOf(" Guild") > -1){
                this.txtGuildName.text = ((flashvars.intLevel.split("+").join(" ")).split("--- ")[1]).substring(0, ((flashvars.intLevel.split("+").join(" ")).split("--- ")[1]).length - 6);
            }else{
                this.txtGuildName.text = "None";
            }

            this.txtClassName.text = flashvars.strClassName.split("+").join(" ");
            if(this.txtClassName.text == "")
                this.txtClassName.text = "None";
            this.txtWeapon.text = flashvars.strWeaponName.split("+").join(" ");
            if(this.txtWeapon.text == "")
                this.txtWeapon.text = "None";
            this.txtArmor.text = flashvars.strArmorName.split("+").join(" ");
            if(this.txtArmor.text == "")
                this.txtArmor.text = "None";
            this.txtHelm.text = flashvars.strHelmName.split("+").join(" ");
            if(this.txtHelm.text == "")
                this.txtHelm.text = "None";
            this.txtCape.text = flashvars.strCapeName.split("+").join(" ");
            if(this.txtCape.text == "")
                this.txtCape.text = "None";
            this.txtPet.text = flashvars.strPetName.split("+").join(" ");
            if(this.txtPet.text == "")
                this.txtPet.text = "None";
            var strFaction:String = flashvars.strFaction.split("+").join(" ");
            this.txtAlignment.text = strFaction;
            if(strFaction == "Neutral")
            {
                this.movFaction.gotoAndStop(2);
            }
            if(strFaction == "Good")
            {
                this.movFaction.gotoAndStop(3);
            }
            if(strFaction == "Evil")
            {
                this.movFaction.gotoAndStop(4);
            }
            if(strFaction == "Chaos")
            {
                this.movFaction.gotoAndStop(5);
            }

            _tempMC = new relAvatarMC();

            _tempMC.world = main.Game.world;
            this.copyTo(_tempMC.mcChar);
            _tempMC.hideHPBar();
            _tempMC.name = "DisplayMC";
            this.mcCharUI.mcBG.addChild(_tempMC);
            _tempMC.x = 250;
            _tempMC.y = -30;
            _tempMC.scaleX *= -3;
            _tempMC.scaleY *= 3;


            this.visible = true;
        }
        var _tempMC:relAvatarMC;

        public function getAchievement(index:int) : int
        {
            if(index < 0 || index > 31)
            {
                return -1;
            }
            var iA:* = flashvars.ia1;
            if(iA == null)
            {
                return -1;
            }
            return (iA & Math.pow(2,index)) == 0?0:1;
        }

        public function copyTo(param1:MovieClip) : void{
            var _loc3_:* = undefined;
            var Avatar:Class = main.Game.world.getClass("Avatar") as Class;
            var _tempAvt:* = new Avatar(main.Game);
            _tempAvt.pnm = main.Game.world.myAvatar.pnm;
            _tempAvt.objData = main.Game.copyObj(main.Game.world.myAvatar.objData);
            _tempMC.pAV = _tempAvt;
            _tempMC.pAV.pMC = _tempMC;

            _tempMC.pAV.objData.intColorHair = flashvars.intColorHair;
            _tempMC.pAV.objData.intColorSkin = flashvars.intColorSkin;
            _tempMC.pAV.objData.intColorEye = flashvars.intColorEye;
            _tempMC.pAV.objData.intColorBase = flashvars.intColorBase;
            _tempMC.pAV.objData.intColorTrim = flashvars.intColorTrim;
            _tempMC.pAV.objData.intColorAccessory = flashvars.intColorAccessory;


            _tempMC.pAV.objData.strHairFilename = flashvars.strHairFile;
            _tempMC.pAV.objData.strHairName = flashvars.strHairName;
            _tempMC.pAV.objData.eqp.co["sFile"] = flashvars.strClassFile;
            _tempMC.pAV.objData.eqp.co["sLink"] = flashvars.strClassLink;
            _tempMC.pAV.objData.eqp.Weapon["sFile"] = flashvars.strWeaponFile;
            _tempMC.pAV.objData.eqp.Weapon["sLink"] = flashvars.strWeaponLink;
            _tempMC.pAV.objData.eqp.Weapon["sType"] = flashvars.strWeaponType;
            _tempMC.pAV.objData.eqp.ba["sFile"] = flashvars.strCapeFile;
            _tempMC.pAV.objData.eqp.ba["sLink"] = flashvars.strCapeLink;
            _tempMC.pAV.objData.eqp.he["sFile"] = flashvars.strHelmFile;
            _tempMC.pAV.objData.eqp.he["sLink"] = flashvars.strHelmLink;
            _tempMC.pAV.objData.strGender = flashvars.strGender;
            _tempMC.strGender = flashvars.strGender;

            _tempMC.pAV.dataLeaf.showHelm = flashvars.strHelmFile != "none" && this.getAchievement(1) == 0;
            _tempMC.pAV.dataLeaf.showCloak = flashvars.strCapeFile != "none" && this.getAchievement(0) == 0;

            var _loc2_:* = ["cape","backhair","robe","backrobe"];
            for(_loc3_ in _loc2_)
            {
                if(typeof param1[_loc2_[_loc3_]] != undefined)
                {
                    param1[_loc2_[_loc3_]].visible = false;
                }
            }
            if(!_tempMC.pAV.dataLeaf.showHelm || _tempMC.pAV.objData.eqp.he.sFile == "none")
            {
                _tempMC.loadHair();
            }
            for(var _loc7_ in main.Game.world.myAvatar.objData.eqp)
            {
                switch(_loc7_)
                {
                    case "Weapon":
                        _tempMC.loadWeapon(_tempMC.pAV.objData.eqp[_loc7_].sFile, null);
                        continue;
                    case "he":
                        if(_tempMC.pAV.dataLeaf.showHelm && _tempMC.pAV.objData.eqp.he.sFile != "none")
                        {
                            _tempMC.loadHelm(_tempMC.pAV.objData.eqp[_loc7_].sFile, null);
                        }
                        continue;
                    case "ba":
                        if(_tempMC.pAV.dataLeaf.showCloak && _tempMC.pAV.objData.eqp.ba.sFile != "none")
                        {
                            _tempMC.loadCape(_tempMC.pAV.objData.eqp[_loc7_].sFile, null);
                        }
                        continue;
                    case "co":
                        _tempMC.loadArmor(_tempMC.pAV.objData.eqp[_loc7_].sFile, _tempMC.pAV.objData.eqp[_loc7_].sLink);
                        continue;
                    default:
                        continue;
                }
            }
            if(flashvars.strPetFile != "none" && this.getAchievement(2) == 0){
                var class_petMC:Class = main.Game.world.getClass("PetMC") as Class;
                petMC = new class_petMC();
                petMC.mouseEnabled = petMC.mouseChildren = false;
                petMC.pAV = _tempMC.pAV;
                main.Game.world.queueLoad({
                    "strFile": main.Game.getFilePath() + flashvars.strPetFile,
                    "callBackA": onLoadPetComplete,
                    "avt": _tempMC.pAV,
                    "sES":"Pet"
                });
            }
        }
        private var petMC:*;

        public function onLoadPetComplete(param1:Event) : void
        {
            var pet:Class = main.Game.world.getClass(flashvars.strPetLink) as Class;
            petMC.removeChildAt(1);
            petMC.mcChar = MovieClip(petMC.addChildAt(new pet(), 1));

            mcCharUI.mcBG.addChild(petMC);
            petMC.scale(2);
            petMC.turn("left");
            petMC.x = 50;
            petMC.y = -150;
            petMC.shadow.visible = false;
            mcCharUI.mcBG.setChildIndex(petMC, mcCharUI.mcBG.numChildren-2);
        }

        public function ioErrorHandler(e:*):void{
            var modalClass:Class;
            var modal:*;
            var modalO:*;
            modalClass= main.Game.world.getClass("ModalMC");
            modal = new modalClass();
            modalO = {};
            modalO.strBody = "Connection Error";
            modalO.params = {};
            modalO.glow = "red,medium";
            modalO.btns = "mono";
            main._stage.addChild(modal);
            modal.init(modalO);
        }

        var htmlContent:String;
        public function onCharPageLoad(e:Event){
            htmlContent += socket.readUTFBytes(socket.bytesAvailable);
        }

        public function onBtCharPage(e:*):void{
            navigateToURL(new URLRequest(("http://www.aq.com/character.asp?id=" + userName)), "_blank");
        }

        public function onBtClose(e:*):void{
            this.parent.removeChild(this);
        }
    }
}
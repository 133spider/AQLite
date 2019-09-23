package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.filters.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.avatar.*;
    import net.spider.handlers.*;
    import fl.events.*;
    import fl.data.*;

    public class cameratool extends MovieClip {

        public var AvatarDisplay:relAvatarMC;

        public function cameratool(){
            this.btnExpandTxt.mouseEnabled = false;
            this.weaponUI.visible = false;    
            this.dummyMC.visible = false;    

            this.btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpand);
            
            AvatarDisplay = new relAvatarMC();

            AvatarDisplay.world = main.Game.world;
            this.copyTo(AvatarDisplay.mcChar);
            AvatarDisplay.x = (650);
            AvatarDisplay.y = (450);

            AvatarDisplay.hideHPBar();
            AvatarDisplay.gotoAndPlay("in2");
            AvatarDisplay.mcChar.gotoAndPlay("Idle");

            AvatarDisplay.scale(scaleAvt);

            this.addChild(AvatarDisplay);

            this.cameratoolUI.txtClassName.text = main.Game.world.myAvatar.objData.strClassName;

            this.background.mouseEnabled = true;
            this.background.addEventListener(MouseEvent.CLICK, onWalk);

            //cameratoolUI
            this.cameratoolUI.colBG.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColBG);
            this.cameratoolUI.colBG.addEventListener(Event.CLOSE, onColBG);

            //emotes
            var emotes:Array = [
                {
                    label: "Idle"
                },
                {
                    label: "Walk"   
                },
                {
                    label: "Dance"   
                },
                {
                    label: "Laugh"   
                },
                {
                    label: "Point"   
                },
                {
                    label: "Use"   
                },
                {
                    label: "Stern"   
                },
                {
                    label: "SternLoop"   
                },
                {
                    label: "Salute"   
                },
                {
                    label: "Cheer"   
                },
                {
                    label: "Facepalm"   
                },
                {
                    label: "Airguitar"   
                },
                {
                    label: "Backflip"   
                },
                {
                    label: "Sleep"   
                },
                {
                    label: "Jump"   
                },
                {
                    label: "Punt"   
                },
                {
                    label: "Dance2"   
                },
                {
                    label: "Swordplay"   
                },
                {
                    label: "Feign"   
                },
                {
                    label: "Dead"   
                },
                {
                    label: "Wave"   
                },
                {
                    label: "Bow"   
                },
                {
                    label: "Rest"   
                },
                {
                    label: "Cry"   
                },
                {
                    label: "Unsheath"   
                },
                {
                    label: "Fight"   
                },
                {
                    label: "Attack1"   
                },
                {
                    label: "Attack2"   
                },
                {
                    label: "Attack3"   
                },
                {
                    label: "Attack4"   
                },
                {
                    label: "Hit"   
                },
                {
                    label: "Knockout"   
                },
                {
                    label: "Getup"   
                },
                {
                    label: "Stab"   
                },
                {
                    label: "Thrash"   
                },
                {
                    label: "Castgood"   
                },
                {
                    label: "Cast1"   
                },
                {
                    label: "Cast2"   
                },
                {
                    label: "Cast3"   
                },
                {
                    label: "Sword/ShieldFight"   
                },
                {
                    label: "Sword/ShieldAttack1"   
                },
                {
                    label: "Sword/ShieldAttack2"   
                },
                {
                    label: "ShieldBlock"   
                },
                {
                    label: "DuelWield/DaggerFight"   
                },
                {
                    label: "DuelWield/DaggerAttack1"   
                },
                {
                    label: "DuelWield/DaggerAttack2"   
                },
                {
                    label: "FistweaponFight"   
                },
                {
                    label: "FistweaponAttack1"   
                },
                {
                    label: "FistweaponAttack2"   
                },
                {
                    label: "PolearmFight"   
                },
                {
                    label: "PolearmAttack1"   
                },
                {
                    label: "PolearmAttack2"   
                },
                {
                    label: "RangedFight"   
                },
                {
                    label: "UnarmedFight"   
                },
                {
                    label: "UnarmedAttack1"   
                },
                {
                    label: "UnarmedAttack2"   
                },
                {
                    label: "KickAttack"   
                },
                {
                    label: "FlipAttack"   
                },
                {
                    label: "Dodge"   
                },
                {
                    label: "Powerup"   
                },
                {
                    label: "Kneel"   
                },
                {
                    label: "Jumpcheer"   
                },
                {
                    label: "Salute2"   
                },
                {
                    label: "Cry2"   
                },
                {
                    label: "Spar"   
                },
                {
                    label: "Samba"   
                },
                {
                    label: "Stepdance"   
                },
                {
                    label: "Headbang"   
                },
                {
                    label: "Dazed"   
                },
                {
                    label: "Psychic1"   
                },
                {
                    label: "Psychic2"   
                },
                {
                    label: "Danceweapon"   
                },
                {
                    label: "Useweapon"   
                },
                {
                    label: "Throw"   
                },
                {
                    label: "FireBreath"   
                }

            ];

            emotes.sortOn("label");
            
            this.cameratoolUI.cbEmotes.dataProvider = new DataProvider(emotes);
            this.cameratoolUI.btnEmote.addEventListener(MouseEvent.CLICK, onBtnEmote);

            //class
            this.cameratoolUI.btnClass1.addEventListener(MouseEvent.CLICK, onBtnClass);
            this.cameratoolUI.btnClass2.addEventListener(MouseEvent.CLICK, onBtnClass);
            this.cameratoolUI.btnClass3.addEventListener(MouseEvent.CLICK, onBtnClass);
            this.cameratoolUI.btnClass4.addEventListener(MouseEvent.CLICK, onBtnClass);
            this.cameratoolUI.btnClass5.addEventListener(MouseEvent.CLICK, onBtnClass);

            this.cameratoolUI.btnToggleDummy.addEventListener(MouseEvent.CLICK, onBtnToggleDummy);

            this.dummyMC.addEventListener(MouseEvent.MOUSE_DOWN, onDummyDown);
            this.dummyMC.addEventListener(MouseEvent.MOUSE_UP, onDummyUp);

            //visibility
            var visible:Array = [
                {
                    label: "Mainhand"
                },
                {
                    label: "Offhand"
                },
                {
                    label: "Cape"
                },
                {
                    label: "Helmet"
                },
                {
                    label: "Player"
                },
                {
                    label: "Shadow"
                },
                {
                    label: "Head"
                },
                {
                    label: "Robe"
                },
                {
                    label: "Back Robe"
                }
            ];

            visible.sortOn("label");

            this.cameratoolUI.cbVisibility.dataProvider = new DataProvider(visible);
            this.cameratoolUI.btnVisibility.addEventListener(MouseEvent.CLICK, onBtnVisibility);

            //scaling
            this.cameratoolUI.numScaling.addEventListener(Event.CHANGE, onNumScaling);

            //weapon deattachment
            this.cameratoolUI.btnDeattach.addEventListener(MouseEvent.CLICK, onBtnDeattach);

            this.cameratoolUI.btnShowDeattach.addEventListener(MouseEvent.CLICK, onBtnShowDeattach);

            //weapon UI
            this.weaponUI.background.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponUIDown);
            this.weaponUI.background.addEventListener(MouseEvent.MOUSE_UP, onWeaponUIUp);

            this.weaponUI.txtFocus.mouseEnabled = false;
            this.weaponUI.btnSetFocus.addEventListener(MouseEvent.CLICK, onBtnSetFocus);
            
            this.weaponUI.sldrRotation.addEventListener(SliderEvent.CHANGE, onSldrRotation);

            this.weaponUI.btnAddLayer.addEventListener(MouseEvent.CLICK, onBtnAddLayer);
            this.weaponUI.btnDelLayer.addEventListener(MouseEvent.CLICK, onBtnDelLayer);

            this.weaponUI.numWepScale.addEventListener(Event.CHANGE, onNumWepScale);

            this.weaponUI.btnMirror.addEventListener(MouseEvent.CLICK, onBtnMirror);
            this.weaponUI.btnInCombat.addEventListener(MouseEvent.CLICK, onBtnInCombat);

            //player options

            this.cameratoolUI.btnFreezePlayer.addEventListener(MouseEvent.CLICK, onBtnFreezePlayer);
            this.cameratoolUI.btnStonePlayer.addEventListener(MouseEvent.CLICK, onBtnStonePlayer);
            this.cameratoolUI.btnHitPlayer.addEventListener(MouseEvent.CLICK, onBtnHitPlayer);
            this.cameratoolUI.btnResetPlayer.addEventListener(MouseEvent.CLICK, onBtnResetPlayer);

            //glow
            this.cameratoolUI.colGlow.addEventListener(Event.CLOSE, onColGlow);
            this.cameratoolUI.colGlow.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlow);

            this.cameratoolUI.colGlowMain.addEventListener(Event.CLOSE, onColGlowMain);
            this.cameratoolUI.colGlowMain.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlowMain);

            this.cameratoolUI.colGlowOff.addEventListener(Event.CLOSE, onColGlowOff);
            this.cameratoolUI.colGlowOff.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, onColGlowOff);

            this.cameratoolUI.btnGlowMain.addEventListener(MouseEvent.CLICK, onBtnGlowMain);
            this.cameratoolUI.btnGlowOff.addEventListener(MouseEvent.CLICK, onBtnGlowOff);
            this.cameratoolUI.btnGlowPlayer.addEventListener(MouseEvent.CLICK, onBtnGlowPlayer);

            this.btnClose.addEventListener(MouseEvent.CLICK, onBtnClose);
        }

        public function copyTo(param1:MovieClip) : void{
            var _loc3_:* = undefined;
            AvatarDisplay.pAV = main.Game.world.myAvatar;
            AvatarDisplay.strGender = AvatarDisplay.pAV.objData.strGender;
            var _loc2_:* = ["cape","backhair","robe","backrobe"];
            for(_loc3_ in _loc2_)
            {
                if(typeof param1[_loc2_[_loc3_]] != undefined)
                {
                    param1[_loc2_[_loc3_]].visible = false;
                }
            }
            if(!AvatarDisplay.pAV.dataLeaf.showHelm || !("he" in AvatarDisplay.pAV.objData.eqp) && AvatarDisplay.pAV.objData.eqp.he == null)
            {
                AvatarDisplay.loadHair();
            }
            for(var _loc7_ in main.Game.world.myAvatar.objData.eqp)
            {
                switch(_loc7_)
                {
                    case "Weapon":
                        AvatarDisplay.loadWeapon(AvatarDisplay.pAV.objData.eqp[_loc7_].sFile, null);
                        continue;
                    case "he":
                        if(AvatarDisplay.pAV.dataLeaf.showHelm)
                        {
                            AvatarDisplay.loadHelm(AvatarDisplay.pAV.objData.eqp[_loc7_].sFile, null);
                        }
                        continue;
                    case "ba":
                        if(AvatarDisplay.pAV.dataLeaf.showCloak)
                        {
                            AvatarDisplay.loadCape(AvatarDisplay.pAV.objData.eqp[_loc7_].sFile, null);
                        }
                        continue;
                    case "ar":
                        if(main.Game.world.myAvatar.objData.eqp.co == null)
                        {
                            AvatarDisplay.loadClass(AvatarDisplay.pAV.objData.eqp[_loc7_].sFile, null);
                        }
                        continue;
                    case "co":
                        AvatarDisplay.loadArmor(AvatarDisplay.pAV.objData.eqp[_loc7_].sFile, AvatarDisplay.pAV.objData.eqp[_loc7_].sLink);
                        continue;
                    default:
                        continue;
                }
            }
        }

        public function loadWeaponOff(param1:*, param2:*) : void{
            main.Game.world.queueLoad({
            "strFile":main.Game.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponOffComplete,
            "avt":AvatarDisplay.pAV,
            "sES":"weapon"
            });
        }
        
        public function onLoadWeaponOffComplete(param1:Event) : void{
            var AssetClass:Class = null;
            AvatarDisplay.pAV.updateLoaded();
            AvatarDisplay.mcChar.weaponOff.removeChildAt(0);
            try
            {
                AssetClass = main.Game.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
                AvatarDisplay.mcChar.weaponOff.addChild(new AssetClass());
            }
            catch(err:Error)
            {
                trace(AvatarDisplay.pAV.objData.eqp.Weapon.sLink + " weaponOff added to display list manually");
                AvatarDisplay.mcChar.weaponOff.addChild(param1.target.content);
            }
            AvatarDisplay.mcChar.weaponOff.visible = true;
        }

        public function onBtnClose(e:MouseEvent):void{
            main.Game.world.visible = true;
            this.parent.removeChild(this);
        }

        //TODO: Pet Walk
        public function onWalk(e:MouseEvent):void{
            if(isFrozen)
                return;
            walkTo(e.stageX, e.stageY, 16);
        }

        private var op;
        private var tp;
        private var walkTS;
        private var walkD;
        public function walkTo(toX:int, toY:int, walkSpeed:int):void{
            var dist:Number;
            var dx:Number;
            var toX:int = toX;
            var toY:int = toY;
            var walkSpeed:int = walkSpeed;
            op = new Point(AvatarDisplay.x, AvatarDisplay.y);
            tp = new Point(toX, toY);
            dist = Point.distance(op, tp);
            walkTS = new Date().getTime();
            walkD = Math.round((1000 * (dist / (walkSpeed * 22))));
            if (walkD > 0)
            {
                dx = (op.x - tp.x);
                if (dx < 0)
                {
                    AvatarDisplay.turn("right");
                }
                else
                {
                    AvatarDisplay.turn("left");
                }
                if (!AvatarDisplay.mcChar.onMove)
                {
                    AvatarDisplay.mcChar.onMove = true;
                    if (AvatarDisplay.mcChar.currentLabel != "Walk")
                    {
                        AvatarDisplay.mcChar.gotoAndPlay("Walk");
                    }
                }
                AvatarDisplay.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
                AvatarDisplay.addEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            }
        }

        public function onEnterFrameWalk(event:Event):void{
            var now:Number;
            var f:Number;
            var vX:*;
            var vY:*;
            var hitOK:Boolean;
            var aP:Point;
            var aR:Rectangle;
            now = new Date().getTime();
            f = ((now - walkTS) / walkD);
            if (f > 1)
            {
                f = 1;
            }
            if ((((Point.distance(op, tp) > 0.5)) && (AvatarDisplay.mcChar.onMove)))
            {
                vX = AvatarDisplay.x;
                vY = AvatarDisplay.y;
                AvatarDisplay.x = Point.interpolate(tp, op, f).x;
                AvatarDisplay.y = Point.interpolate(tp, op, f).y;
                if ((((((Math.round(vX) == Math.round(AvatarDisplay.x))) && ((Math.round(vY) == Math.round(AvatarDisplay.y))))) && ((now > (walkTS + 50)))))
                {
                    stopWalking();
                }
            }
            else
            {
                stopWalking();
            }
        }

        public function stopWalking() : void{
            if(AvatarDisplay.mcChar.onMove)
            {
                AvatarDisplay.removeEventListener(Event.ENTER_FRAME, onEnterFrameWalk);
            }
            AvatarDisplay.mcChar.onMove = false;
            AvatarDisplay.mcChar.gotoAndPlay("Idle");
        }

        public function onBtnExpand(e:MouseEvent):void{
            if(cameratoolUI.visible){
                this.cameratoolUI.visible = false;
                this.weaponUI.visible = false;
                this.btnExpandTxt.text = "+";
            }else{
                this.cameratoolUI.visible = true;
                this.btnExpandTxt.text = "-";
            }
        }

        public function onColBG(e:*):void{
            var backgroundTransform = new ColorTransform();
            backgroundTransform.color = "0x" + e.currentTarget.hexValue;
            this.background.transform.colorTransform = backgroundTransform;
        }

        public function onBtnEmote(e:MouseEvent):void{
            if(this.cameratoolUI.cbEmotes.selectedItem.label == "Walk"){
                AvatarDisplay.mcChar.onMove = true;
            }else{
                AvatarDisplay.mcChar.onMove = false;
            }
            AvatarDisplay.mcChar.gotoAndPlay(this.cameratoolUI.cbEmotes.selectedItem.label);
        }

        public function onBtnClass(e:MouseEvent):void{
            var animSkill:String;
            var active:*;
            switch(e.currentTarget.name){
                case "btnClass1":
                    animSkill = main.Game.world.actions.active[0].anim;
                    active = main.Game.world.actions.active[0];
                    break;
                case "btnClass2":
                    animSkill = main.Game.world.actions.active[1].anim;
                    active = main.Game.world.actions.active[1];
                    break;
                case "btnClass3":
                    animSkill = main.Game.world.actions.active[2].anim;
                    active = main.Game.world.actions.active[2];
                    break;
                case "btnClass4":
                    animSkill = main.Game.world.actions.active[3].anim;
                    active = main.Game.world.actions.active[3];
                    break;
                case "btnClass5":
                    animSkill = main.Game.world.actions.active[4].anim;
                    active = main.Game.world.actions.active[4];
                    break;
            }
            if(animSkill.indexOf(",") > -1){
                animSkill = animSkill.split(",")[Math.round(Math.random() * (animSkill.split(",").length - 1))];
            }
            AvatarDisplay.mcChar.gotoAndPlay(animSkill);

            AvatarDisplay.spFX = main.Game.world.myAvatar.pMC.spFX;

            AvatarDisplay.spFX.strl = active.strl;
            AvatarDisplay.spFX.fx = active.fx;
            AvatarDisplay.spFX.tgt = active.tgt;
            castSpellFX(AvatarDisplay.pAV, AvatarDisplay.spFX, null, 7);
        }

        public function castSpellFX(param1:*, param2:*, param3:*, param4:int = 0) : *{
            var _loc6_:* = main.Game.world.getClass(param2.strl) as Class;
            var _loc7_:*;
            if(_loc6_ != null)
            {
                _loc7_ = new _loc6_();
                _loc7_.spellDur = param4;
                this.addChild(_loc7_);
                _loc7_.scaleX *= scaleAvt;
                _loc7_.scaleY *= scaleAvt;
                _loc7_.mouseEnabled = false;
                _loc7_.mouseChildren = false;
                _loc7_.visible = true;
                _loc7_.world = main.Game.world;
                _loc7_.strl = param2.strl;
                if(param2.tgt == 's'){
                    _loc7_.tMC = AvatarDisplay;
                }else{
                    _loc7_.tMC = this.dummyMC;
                }
                switch(param2.fx)
                {
                    case "p":
                        _loc7_.x = AvatarDisplay.x + 71;
                        _loc7_.y = (AvatarDisplay.y - AvatarDisplay.mcChar.height * 0.5) + 122;
                        _loc7_.dir = this.dummyMC.x - AvatarDisplay.x >= 0?1:-1;
                        break;
                    case "w":
                        _loc7_.x = _loc7_.tMC.x + 71;
                        _loc7_.y = (_loc7_.tMC.y + 3) + 122;
                        if(param1 != null)
                        {
                            if(_loc7_.tMC.x < AvatarDisplay.x)
                            {
                                _loc7_.scaleX = _loc7_.scaleX * -1;
                            }
                        }
                }
                showSpellFXHit({
                     "tMC":_loc7_.tMC,
                     "strl":_loc7_.strl
                  });
            }
            else
            {
                trace();
                trace("*>*>*> Could not load class " + param2.strl);
                trace();
            }
        }

        public function showSpellFXHit(param1:*) : *{
            var _loc2_:* = {};
            switch(param1.strl)
            {
                case "sp_ice1":
                    _loc2_.strl = "sp_ice2";
                break;
                case "sp_el3":
                    _loc2_.strl = "sp_el2";
                    break;
                case "sp_ed3":
                    _loc2_.strl = "sp_ed1";
                    break;
                case "sp_ef1":
                case "sp_ef6":
                    _loc2_.strl = "sp_ef2";
            }
            _loc2_.fx = "w";
            _loc2_.avts = [param1.tMC];
            this.castSpellFX(null,_loc2_,null);
        }

        public function onBtnToggleDummy(e:MouseEvent):void{
            this.dummyMC.visible = !this.dummyMC.visible;
        }

        public function onDummyDown(e:MouseEvent):void{
            this.dummyMC.startDrag();
        }

        public function onDummyUp(e:MouseEvent):void{
            this.dummyMC.stopDrag();
        }

        public function get isCharHidden():Boolean{
            return mcCharHidden;
        }

        public var mcCharHidden:Boolean;
        public var mcCharOptions:Object = {
            "backhair": false,
            "robe": false,
            "backrobe": false
        };
        public function onBtnVisibility(e:MouseEvent):void{
            switch(cameratoolUI.cbVisibility.selectedItem.label){
                case "Mainhand":
                    AvatarDisplay.mcChar.weapon.visible = !AvatarDisplay.mcChar.weapon.visible;
                    break;
                case "Offhand":
                    AvatarDisplay.mcChar.weaponOff.visible = !AvatarDisplay.mcChar.weaponOff.visible;
                    break;
                case "Cape":
                    AvatarDisplay.mcChar.cape.visible = !AvatarDisplay.mcChar.cape.visible;
                    break;
                case "Helmet":
                    AvatarDisplay.mcChar.head.helm.visible = !AvatarDisplay.mcChar.head.helm.visible;
                    AvatarDisplay.mcChar.head.hair.visible = !AvatarDisplay.mcChar.head.helm.visible;
                    break;
                case "Player":
                    mcCharHidden = !mcCharHidden;
                    if(!mcCharHidden){
                        AvatarDisplay.mcChar.head.visible = true;
                        AvatarDisplay.mcChar.chest.visible = true;
                        AvatarDisplay.mcChar.frontshoulder.visible = true;
                        AvatarDisplay.mcChar.backshoulder.visible = true;
                        AvatarDisplay.mcChar.fronthand.visible = true;
                        AvatarDisplay.mcChar.backhand.visible = true;
                        AvatarDisplay.mcChar.frontthigh.visible = true;
                        AvatarDisplay.mcChar.backthigh.visible = true;
                        AvatarDisplay.mcChar.frontshin.visible = true;
                        AvatarDisplay.mcChar.backshin.visible = true;
                        AvatarDisplay.mcChar.idlefoot.visible = true;
                        AvatarDisplay.mcChar.backfoot.visible = true;
                        AvatarDisplay.mcChar.hip.visible = true;
                        AvatarDisplay.mcChar.robe.visible = mcCharOptions["robe"];
                        AvatarDisplay.mcChar.backrobe.visible = mcCharOptions["backrobe"];
                        AvatarDisplay.mcChar.backhair.visible = mcCharOptions["backhair"];
                    }else{
                        AvatarDisplay.mcChar.head.visible = false;
                        AvatarDisplay.mcChar.chest.visible = false;
                        AvatarDisplay.mcChar.frontshoulder.visible = false;
                        AvatarDisplay.mcChar.backshoulder.visible = false;
                        AvatarDisplay.mcChar.fronthand.visible = false;
                        AvatarDisplay.mcChar.backhand.visible = false;
                        AvatarDisplay.mcChar.frontthigh.visible = false;
                        AvatarDisplay.mcChar.backthigh.visible = false;
                        AvatarDisplay.mcChar.frontshin.visible = false;
                        AvatarDisplay.mcChar.backshin.visible = false;
                        AvatarDisplay.mcChar.idlefoot.visible = false;
                        AvatarDisplay.mcChar.backfoot.visible = false;
                        AvatarDisplay.mcChar.hip.visible = false;
                        if(AvatarDisplay.mcChar.robe.visible){
                            AvatarDisplay.mcChar.robe.visible = false;
                            mcCharOptions["robe"] = true;
                        }
                        if(AvatarDisplay.mcChar.backrobe.visible){
                            AvatarDisplay.mcChar.backrobe.visible = false;
                            mcCharOptions["backrobe"] = true;
                        }
                        if(AvatarDisplay.mcChar.backhair.visible){
                            AvatarDisplay.mcChar.backhair.visible = false;
                            mcCharOptions["backhair"] = true;
                        }
                    }
                    break;
                case "Shadow":
                    AvatarDisplay.shadow.visible = !AvatarDisplay.shadow.visible;
                    break;
                case "Head":
                    AvatarDisplay.mcChar.head.visible = !AvatarDisplay.mcChar.head.visible;
                    break;
                case "Robe":
                    AvatarDisplay.mcChar.robe.visible = !AvatarDisplay.mcChar.robe.visible;
                    break;
                case "Back Robe":
                    AvatarDisplay.mcChar.backrobe.visible = !AvatarDisplay.mcChar.backrobe.visible;
                    break;
            }
        }

        public var scaleAvt:Number = 3;
        public function onNumScaling(e:Event):void{
            scaleAvt = this.cameratoolUI.numScaling.textField.text;
            AvatarDisplay.scale(scaleAvt);
        }

        public var weaponDeattached:Boolean;
        public var deattachedMain:MovieClip;
        public var deattachedOff:MovieClip;
        public function onBtnDeattach(e:MouseEvent):void{
            if(weaponDeattached){
                weaponDeattached = false;
                isMirrored = false;
                isMirroredOff = false;
                this.cameratoolUI.txtDeattached.text = "Weapon Deattachment: OFF";

                deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag);
                deattachedMain.removeEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag);

                AvatarDisplay.mcChar.weapon.visible = true;
                var wItem:Object = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
                if(wItem != null && wItem.sType != null)
                {
                    if(wItem.sType == "Dagger")
                    {
                        AvatarDisplay.mcChar.weaponOff.visible = true;
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag);
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag);
                    }
                }

                AvatarDisplay.mcChar.removeChild(deattachedMain);
                AvatarDisplay.mcChar.removeChild(deattachedOff);

                deattachedMain = null;
                deattachedOff = null;
            }else{
                weaponDeattached = true;
                this.cameratoolUI.txtDeattached.text = "Weapon Deattachment: ON";

                main.Game.world.queueLoad({
                    "strFile":main.Game.world.rootClass.getFilePath() + AvatarDisplay.pAV.objData.eqp.Weapon.sFile,
                    "callBackA":this.onLoadWeaponClones,
                    "avt":AvatarDisplay.pAV,
                    "sES":"weapon"
                });

                AvatarDisplay.mcChar.weapon.visible = false;
                AvatarDisplay.mcChar.weaponOff.visible = false;
            }
        }

        public function onLoadWeaponClones(e:*):void{
            var AssetClass:Class = null;
            try
            {
                AssetClass = main.Game.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
                deattachedMain = new AssetClass();
            }
            catch(err:Error)
            {
                trace(" Weapon added to display list manually");
                deattachedMain = MovieClip(e.target.content);
            }
            
            AvatarDisplay.mcChar.addChild(deattachedMain);
            deattachedMain.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag);
            deattachedMain.addEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag);
            
            deattachedMain.scaleX = deattachedMain.scaleY = .222;

            var wItem:Object = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
            if(wItem != null && wItem.sType != null)
            {
                if(wItem.sType == "Dagger")
                {
                    main.Game.world.queueLoad({
                        "strFile":main.Game.world.rootClass.getFilePath() + AvatarDisplay.pAV.objData.eqp.Weapon.sFile,
                        "callBackA":this.onLoadWeaponOffClones,
                        "avt":AvatarDisplay.pAV,
                        "sES":"weapon"
                    });
                }
            }
        }

        public function onLoadWeaponOffClones(e:*):void{
            var AssetClass:Class = null;
            try
            {
                AssetClass = main.Game.world.getClass(AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
                deattachedOff = new AssetClass();
            }
            catch(err:Error)
            {
                trace(" Weapon added to display list manually");
                deattachedOff = MovieClip(e.target.content);
            }
            
            AvatarDisplay.mcChar.addChild(deattachedOff);

            deattachedOff.scaleX = deattachedOff.scaleY = .222;

            deattachedOff.addEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag);
            deattachedOff.addEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag);
        }

        public function onWeaponUpDrag(e:MouseEvent):void{
            deattachedMain.stopDrag();
        }

        public function onWeaponDownDrag(e:MouseEvent):void{
            deattachedMain.startDrag();
        }

        public function onWeaponOffUpDrag(e:MouseEvent):void{
            deattachedOff.stopDrag();
        }

        public function onWeaponOffDownDrag(e:MouseEvent):void{
            deattachedOff.startDrag();
        }

        public function onBtnShowDeattach(e:MouseEvent):void{
            if(!weaponDeattached){
                this.weaponUI.visible = false;
                return;
            }
            this.weaponUI.visible = !this.weaponUI.visible;    
        }

        public var weaponFocus:int = 0; //0 = main, 1 = off, 2 = both
        public function onBtnSetFocus(e:MouseEvent):void{
            if(!deattachedOff){
                weaponFocus = 0;
                this.weaponUI.txtFocus.text = "Mainhand";
                return;
            }
            weaponFocus++;
            if(weaponFocus >= 3){
                weaponFocus = 0;
            }
            switch(weaponFocus){
                case 0:
                    this.weaponUI.txtFocus.text = "Mainhand";
                    break;
                case 1:
                    this.weaponUI.txtFocus.text = "Offhand";
                    break;
                case 2:
                    this.weaponUI.txtFocus.text = "Both";
                    break;
            }
        }

        public function onSldrRotation(e:Event):void{
            switch(weaponFocus){
                case 0:
                    deattachedMain.rotation = this.weaponUI.sldrRotation.value;
                    break;
                case 1:
                    deattachedOff.rotation = this.weaponUI.sldrRotation.value;
                    break;
                case 2:
                    deattachedMain.rotation = this.weaponUI.sldrRotation.value;
                    deattachedOff.rotation = this.weaponUI.sldrRotation.value;
                    break;
            }
        }

        public function onBtnAddLayer(e:MouseEvent):void{
            switch(weaponFocus){
                case 0:
                    if(AvatarDisplay.mcChar.getChildIndex(deattachedMain) >= (AvatarDisplay.mcChar.numChildren-2))
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, AvatarDisplay.mcChar.getChildIndex(deattachedMain)+1)
                    break;
                case 1:
                    if(AvatarDisplay.mcChar.getChildIndex(deattachedOff) >= (AvatarDisplay.mcChar.numChildren-2))
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, AvatarDisplay.mcChar.getChildIndex(deattachedOff)+1)
                    break;
                case 2:
                    if((AvatarDisplay.mcChar.getChildIndex(deattachedMain) >= (AvatarDisplay.mcChar.numChildren-2)) 
                    || (AvatarDisplay.mcChar.getChildIndex(deattachedOff) == (AvatarDisplay.mcChar.numChildren-2)))
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, AvatarDisplay.mcChar.getChildIndex(deattachedMain)+1)
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, AvatarDisplay.mcChar.getChildIndex(deattachedOff)+1)
                    break;
            }
        }

        public function onBtnDelLayer(e:MouseEvent):void{
            switch(weaponFocus){
                case 0:
                    if(AvatarDisplay.mcChar.getChildIndex(deattachedMain) <= 0)
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, AvatarDisplay.mcChar.getChildIndex(deattachedMain)-1)
                    break;
                case 1:
                    if(AvatarDisplay.mcChar.getChildIndex(deattachedOff) <= 0)
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, AvatarDisplay.mcChar.getChildIndex(deattachedOff)-1)
                    break;
                case 2:
                    if((AvatarDisplay.mcChar.getChildIndex(deattachedMain) <= 0) 
                    || (AvatarDisplay.mcChar.getChildIndex(deattachedOff) <= 0))
                        return;
                    AvatarDisplay.mcChar.setChildIndex(deattachedMain, AvatarDisplay.mcChar.getChildIndex(deattachedMain)-1)
                    AvatarDisplay.mcChar.setChildIndex(deattachedOff, AvatarDisplay.mcChar.getChildIndex(deattachedOff)-1)
                    break;
            }
        }

        public function onNumWepScale(e:Event):void{
            switch(weaponFocus){
                case 0:
                    deattachedMain.scaleX = deattachedMain.scaleY = this.weaponUI.numWepScale.textField.text * (isMirrored ? -1 : 1);
                    break;
                case 1:
                    deattachedOff.scaleX = deattachedOff.scaleY = this.weaponUI.numWepScale.textField.text * (isMirroredOff ? -1 : 1);
                    break;
                case 2:
                    deattachedMain.scaleX = deattachedMain.scaleY = this.weaponUI.numWepScale.textField.text * (isMirrored ? -1 : 1);
                    deattachedOff.scaleX = deattachedOff.scaleY = this.weaponUI.numWepScale.textField.text * (isMirroredOff ? -1 : 1);
                    break;
            }
        }

        public var isMirrored:Boolean;
        public var isMirroredOff:Boolean;
        public function onBtnMirror(e:MouseEvent):void{
            switch(weaponFocus){
                case 0:
                    isMirrored = !isMirrored;
                    deattachedMain.scaleX *= -1;
                    break;
                case 1:
                    isMirroredOff = !isMirroredOff;
                    deattachedOff.scaleX *= -1;
                    break;
                case 2:
                    isMirrored = !isMirrored;
                    isMirroredOff = !isMirroredOff;
                    deattachedMain.scaleX *= -1;
                    deattachedOff.scaleX *= -1;
                    break;
            }
        }

        public function onBtnInCombat(e:MouseEvent):void{
            switch(weaponFocus){
                case 0:
                    if(deattachedMain.bAttack == true && deattachedMain.currentLabel != "Attack")
                    {
                        deattachedMain.gotoAndPlay("Attack");
                    }else{
                        deattachedMain.gotoAndPlay("Idle");
                    }
                    break;
                case 1:
                    if(deattachedOff.bAttack == true && deattachedOff.currentLabel != "Attack")
                    {
                        deattachedOff.gotoAndPlay("Attack");
                    }else{
                        deattachedOff.gotoAndPlay("Idle");
                    }
                    break;
                case 2:
                    if(deattachedMain.bAttack == true && deattachedMain.currentLabel != "Attack")
                    {
                        deattachedMain.gotoAndPlay("Attack");
                    }else{
                        deattachedMain.gotoAndPlay("Idle");
                    }
                    if(deattachedOff.bAttack == true && deattachedOff.currentLabel != "Attack")
                    {
                        deattachedOff.gotoAndPlay("Attack");
                    }else{
                        deattachedOff.gotoAndPlay("Idle");
                    }
                    break;
            }
        }

        public function onWeaponUIDown(e:MouseEvent):void{
            this.weaponUI.startDrag();
        }

        public function onWeaponUIUp(e:MouseEvent):void{
            this.weaponUI.stopDrag();
        }

        public function onAvatarDown(e:MouseEvent):void{
            AvatarDisplay.startDrag();
        }

        public function onAvatarUp(e:MouseEvent):void{
            AvatarDisplay.stopDrag();
        }

        public var isFrozen:Boolean;
        public function onBtnFreezePlayer(e:MouseEvent):void{
            if(!isFrozen){
                isFrozen = true;
                AvatarDisplay.mcChar.stop();
                AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown);
                AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_UP, onAvatarUp);
            }else{
                isFrozen = false;
                AvatarDisplay.mcChar.play();
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown);
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP, onAvatarUp);
            }
        }

        public var isStoned:Boolean;
        public function onBtnStonePlayer(e:MouseEvent):void{
            if(!isStoned){
                isStoned = true;
                AvatarDisplay.modulateColor(new ColorTransform(-1.3,-1.3,-1.3,0,100,100,100,0), "+");
            }else{
                isStoned = false;
                AvatarDisplay.modulateColor(new ColorTransform(-1.3,-1.3,-1.3,0,100,100,100,0), "-");
            }
        }

        public var isHit:Boolean;
        public function onBtnHitPlayer(e:MouseEvent):void{
            if(!isHit){
                isHit = true;
                AvatarDisplay.modulateColor(new ColorTransform(0,0,0,0,255,255,255,0), "+");
            }else{
                isHit = false;
                AvatarDisplay.modulateColor(new ColorTransform(0,0,0,0,255,255,255,0), "-");
            }
        }

        public function onBtnResetPlayer(e:MouseEvent):void{
            if(isFrozen){
                isFrozen = false;
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN, onAvatarDown);
                AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP, onAvatarUp);
            }
            isStoned = false;
            isHit = false;
            glowPlayer = false;
            glowMain = false;
            glowOff = false;
            isMirrored = false;
            isMirroredOff = false;
            mcCharHidden = false;
            mcCharOptions = {
                "backhair": false,
                "robe": false,
                "backrobe": false
            };
            if(weaponDeattached){
                weaponDeattached = false;
                this.cameratoolUI.txtDeattached.text = "Weapon Deattachment: OFF";
                deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponDownDrag);
                deattachedMain.removeEventListener(MouseEvent.MOUSE_UP, onWeaponUpDrag);

                AvatarDisplay.mcChar.weapon.visible = true;
                var wItem:Object = AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
                if(wItem != null && wItem.sType != null)
                {
                    if(wItem.sType == "Dagger")
                    {
                        AvatarDisplay.mcChar.weaponOff.visible = true;
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN, onWeaponOffDownDrag);
                        deattachedOff.removeEventListener(MouseEvent.MOUSE_UP, onWeaponOffUpDrag);
                    }
                }

                AvatarDisplay.mcChar.removeChild(deattachedMain);
                AvatarDisplay.mcChar.removeChild(deattachedOff);

                deattachedMain = null;
                deattachedOff = null;
            }
            this.removeChild(AvatarDisplay);

            AvatarDisplay = new relAvatarMC();

            AvatarDisplay.world = main.Game.world;
            this.copyTo(AvatarDisplay.mcChar);
            AvatarDisplay.x = (650);
            AvatarDisplay.y = (450);

            AvatarDisplay.hideHPBar();
            AvatarDisplay.gotoAndPlay("in2");
            AvatarDisplay.mcChar.gotoAndPlay("Idle");

            AvatarDisplay.scale(scaleAvt);

            this.addChild(AvatarDisplay);
        }

        public function onColGlow(e:*):void{
            if(!glowPlayer)
                return;
            var glowFilter:* = new GlowFilter(e.currentTarget.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            AvatarDisplay.mcChar.filters = [glowFilter];
        }

        public function onColGlowMain(e:*):void{
            if(!glowMain)
                return;
            var glowFilter:* = new GlowFilter(e.currentTarget.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            if(weaponDeattached){
                deattachedMain.filters = [glowFilter];
            }else{
                AvatarDisplay.mcChar.weapon.filters = [glowFilter];
            }
        }

        public function onColGlowOff(e:*):void{
            if(!glowOff)
                return;
            var glowFilter:* = new GlowFilter(e.currentTarget.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            if(weaponDeattached && deattachedOff){
                deattachedOff.filters = [glowFilter];
            }else{
                AvatarDisplay.mcChar.weaponOff.filters = [glowFilter];
            }
        }

        public var glowMain:Boolean;
        public function onBtnGlowMain(e:MouseEvent):void{
            var glowFilter:* = new GlowFilter(this.cameratoolUI.colGlowMain.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            if(!glowMain){
                glowMain = true;
                AvatarDisplay.mcChar.weapon.filters = [glowFilter];
            }else{
                glowMain = false;
                AvatarDisplay.mcChar.weapon.filters = [];
            }
        }

        public var glowOff:Boolean;
        public function onBtnGlowOff(e:MouseEvent):void{
            var glowFilter:* = new GlowFilter(this.cameratoolUI.colGlowOff.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            if(!glowOff){
                glowOff = true;
                AvatarDisplay.mcChar.weaponOff.filters = [glowFilter];
            }else{
                glowOff = false;
                AvatarDisplay.mcChar.weaponOff.filters = [];
            }
        }

        public var glowPlayer:Boolean;
        public function onBtnGlowPlayer(e:MouseEvent):void{
            var glowFilter:* = new GlowFilter(this.cameratoolUI.colGlow.selectedColor, 
                1, 8, 8, 2, 1, false, false);
            if(!glowPlayer){
                glowPlayer = true;
                AvatarDisplay.mcChar.filters = [glowFilter];
            }else{
                glowPlayer = false;
                AvatarDisplay.mcChar.filters = [];
            }
        }

    }
}
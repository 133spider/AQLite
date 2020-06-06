package net.spider.avatar
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.ApplicationDomain;
    import net.spider.main;

    public class CombatMC extends MovieClip
    {
        public var mcChar:mcCombatSkel;
        public var fx:MovieClip;
        public var proxy:MovieClip;
        public var bubble:MovieClip;
        private var xDep;
        private var yDep;
        private var xTar;
        private var yTar:Number;
        private var nDuration;
        private var nXStep;
        private var nYStep;
        private var walkSpeed:Number;
        private var op:Point;
        private var tp:Point;
        private var walkTS:Number;
        private var walkD:Number;
        private var headPoint:Point;
        private var cbx;
        private var cby:Number;
        private var objLinks:Object;
        private var heavyAssets:Array;
        private var totalTransform:Object;
        private var clampedTransform:ColorTransform;
        private var animQueue:Array;
        public var spFX:Object;
        public var spellDur:int = 0;
        public var bBackHair:Boolean = false;
        public var isLoaded:Boolean = false;
        public var STAGE:MovieClip;
        public var world:MovieClip;
        public var px;
        public var py;
        public var tx;
        public var ty:Number;
        public var defaultCT:ColorTransform;
        public var strGender:String;
        public var previousframe:int = -1;
        public var hitboxR:Rectangle;
        public var CT3:ColorTransform;
        public var CT2:ColorTransform;
        public var CT1:ColorTransform;
        private var rootClass:MovieClip;
        private const MAX_RATIO:Number = 4.656612875245797E-10;
        private const NEGA_MAX_RATIO:Number = -MAX_RATIO;
        private var r:int;
        private var randNum:Number;
        private var animEvents:Object;
        private var mcOrder:Object;
        private var testMC;
        private var topIndex:int = 0;
        public var groundRupture:Boolean = false;

        public function CombatMC()
        {
            this.world = main.Game.world;
            this.objLinks = {};
            this.heavyAssets = [];
            this.totalTransform = {
                "alphaMultiplier":1,
                "alphaOffset":0,
                "redMultiplier":1,
                "redOffset":0,
                "greenMultiplier":1,
                "greenOffset":0,
                "blueMultiplier":1,
                "blueOffset":0
            };
            this.clampedTransform = new ColorTransform();
            this.animQueue = [];
            this.spFX = {};
            this.defaultCT = MovieClip(this).transform.colorTransform;
            this.CT3 = new ColorTransform(1,1,1,1,255,255,255,0);
            this.CT2 = new ColorTransform(1,1,1,1,127,127,127,0);
            this.CT1 = new ColorTransform(1,1,1,1,0,0,0,0);
            this.r = Math.random() * int.MAX_VALUE;
            this.animEvents = new Object();
            this.mcOrder = new Object();
            super();
            //this.mcChar.addEventListener(MouseEvent.CLICK,this.onClickHandler);
            this.mcChar.buttonMode = true;
            this.mcChar.mouseChildren = true;
            //this.addEventListener(Event.ENTER_FRAME,this.checkQueue,false,0,true);
            this.headPoint = new Point(0,this.mcChar.head.y - 1.4 * this.mcChar.head.height);
            this.hideOptionalParts();
        }
        
        override public function gotoAndPlay(param1:Object, param2:String = null) : void
        {
            this.handleAnimEvent(String(param1));
            super.gotoAndPlay(param1);
        }
        
        public function hasLabel(param1:String) : Boolean
        {
            var _loc2_:Array = this.mcChar.currentLabels;
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_.length)
            {
            if(_loc2_[_loc3_].name == param1)
            {
                return true;
            }
            _loc3_++;
            }
            return false;
        }
        
        private function hideOptionalParts() : void
        {
            var _loc1_:* = ["cape","backhair","robe","backrobe","pvpFlag"];
            var _loc2_:* = ["weapon","weaponOff","weaponFist","weaponFistOff","shield"];
            var _loc3_:* = "";
            for(_loc3_ in _loc1_)
            {
                if(typeof this.mcChar[_loc1_[_loc3_]] != undefined)
                {
                    this.mcChar[_loc1_[_loc3_]].visible = false;
                }
            }
            for(_loc3_ in _loc2_)
            {
                if(typeof this.mcChar[_loc2_[_loc3_]] != undefined)
                {
                    this.mcChar[_loc2_[_loc3_]].visible = false;
                }
            }
        }
        
        public function loadClass() : void
        {
            if(main.Game.world.myAvatar.pMC.pAV.objData.eqp.co == null){
                this.loadArmorPieces(main.Game.world.myAvatar.pMC.pAV.objData.eqp.ar.sLink);
            }
        }
        
        public function loadArmor() : void
        {
            this.loadArmorPieces(main.Game.world.myAvatar.pMC.pAV.objData.eqp.co.sLink);
        }
        
        public function loadArmorPieces(param1:String) : void
        {
            var AssetClass:Class = null;
            var child:DisplayObject = null;
            var strSkinLinkage:String = param1;
            trace(">>>>>>>>>>>> loadArmorPieces " + param1);
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Head") as Class;
                child = this.mcChar.head.getChildByName("face");
                if(child != null)
                {
                    this.mcChar.head.removeChild(child);
                }
                this.testMC = this.mcChar.head.addChildAt(new AssetClass(),0);
                this.testMC.name = "face";
            }
            catch(err:Error)
            {
                AssetClass = world.getClass("mcHead" + strGender) as Class;
                child = mcChar.head.getChildByName("face");
                if(child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(new AssetClass(),0);
                testMC.name = "face";
            }
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Chest") as Class;
                this.mcChar.chest.removeChildAt(0);
                this.mcChar.chest.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Hip") as Class;
                this.mcChar.hip.removeChildAt(0);
                this.mcChar.hip.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "FootIdle") as Class;
                this.mcChar.idlefoot.removeChildAt(0);
                this.mcChar.idlefoot.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Foot") as Class;
                this.mcChar.frontfoot.removeChildAt(0);
                this.mcChar.frontfoot.addChild(new AssetClass());
                this.mcChar.frontfoot.visible = false;
                this.mcChar.backfoot.removeChildAt(0);
                this.mcChar.backfoot.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Shoulder") as Class;
                this.mcChar.frontshoulder.removeChildAt(0);
                this.mcChar.frontshoulder.addChild(new AssetClass());
                this.mcChar.backshoulder.removeChildAt(0);
                this.mcChar.backshoulder.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Hand") as Class;
                this.mcChar.fronthand.removeChildAt(0);
                this.mcChar.fronthand.addChild(new AssetClass());
                this.mcChar.backhand.removeChildAt(0);
                this.mcChar.backhand.addChild(new AssetClass());
            }
            catch(e:Error){}
            /**AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Ground") as Class;
            if(AssetClass != null)
            {
                this.shadow.removeChildAt(0);
                this.shadow.addChild(new AssetClass());
                this.shadow.alpha = 1;
                this.shadow.scaleX = 0.7;
                this.shadow.scaleY = 0.7;
                this.shadow.scaleX = this.shadow.scaleX * -1;
            }
            else
            {
                this.shadow.removeChildAt(0);
                AssetClass = this.world.getClass("mcShadow") as Class;
                this.shadow.addChild(new AssetClass());
                this.shadow.scaleX = 1;
                this.shadow.scaleY = 1;
            }**/
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Thigh") as Class;
                this.mcChar.frontthigh.removeChildAt(0);
                this.mcChar.frontthigh.addChild(new AssetClass());
                this.mcChar.backthigh.removeChildAt(0);
                this.mcChar.backthigh.addChild(new AssetClass());
            }
            catch(e:Error){}
            try
            {
                AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Shin") as Class;
                this.mcChar.frontshin.removeChildAt(0);
                this.mcChar.frontshin.addChild(new AssetClass());
                this.mcChar.backshin.removeChildAt(0);
                this.mcChar.backshin.addChild(new AssetClass());
            }
            catch(e:Error){}
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "Robe") as Class;
            if(AssetClass != null)
            {
                this.mcChar.robe.removeChildAt(0);
                this.mcChar.robe.addChild(new AssetClass());
                this.mcChar.robe.visible = true;
            }
            else
            {
                this.mcChar.robe.visible = false;
            }
            AssetClass = this.world.getClass(strSkinLinkage + this.strGender + "RobeBack") as Class;
            if(AssetClass != null)
            {
                this.mcChar.backrobe.removeChildAt(0);
                this.mcChar.backrobe.addChild(new AssetClass());
                this.mcChar.backrobe.visible = true;
            }
            else
            {
                this.mcChar.backrobe.visible = false;
            }
            this.isLoaded = true;
        }
        
        public function loadArmorPiecesFromDomain(param1:String, param2:ApplicationDomain) : void
        {
            var AssetClass:Class = null;
            var child:DisplayObject = null;
            var strSkinLinkage:String = param1;
            var pLoaderD:ApplicationDomain = param2;
            trace(">>>>>>>>>>>> loadArmorPiecesFromDomain > " + strSkinLinkage);
            try
            {
                AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Head") as Class;
                child = this.mcChar.head.getChildByName("face");
                if(child != null)
                {
                    this.mcChar.head.removeChild(child);
                }
                this.testMC = this.mcChar.head.addChildAt(new AssetClass(),0);
                this.testMC.name = "face";
            }
            catch(err:Error)
            {
                AssetClass = pLoaderD.getDefinition("mcHead" + strGender) as Class;
                child = mcChar.head.getChildByName("face");
                if(child != null)
                {
                    mcChar.head.removeChild(child);
                }
                testMC = mcChar.head.addChildAt(new AssetClass(),0);
                testMC.name = "face";
            }
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Chest") as Class;
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hip") as Class;
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "FootIdle") as Class;
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Foot") as Class;
            this.mcChar.frontfoot.removeChildAt(0);
            this.mcChar.frontfoot.addChild(new AssetClass());
            this.mcChar.frontfoot.visible = false;
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shoulder") as Class;
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new AssetClass());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hand") as Class;
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChild(new AssetClass());
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Thigh") as Class;
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new AssetClass());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new AssetClass());
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shin") as Class;
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new AssetClass());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new AssetClass());
            try
            {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Robe") as Class;
            if(AssetClass != null)
            {
                this.mcChar.robe.removeChildAt(0);
                this.mcChar.robe.addChild(new AssetClass());
                this.mcChar.robe.visible = true;
            }
            else
            {
                this.mcChar.robe.visible = false;
            }
            }
            catch(e:Error)
            {
            mcChar.robe.visible = false;
            }
            try
            {
                AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "RobeBack") as Class;
                if(AssetClass != null)
                {
                    this.mcChar.backrobe.removeChildAt(0);
                    this.mcChar.backrobe.addChild(new AssetClass());
                    this.mcChar.backrobe.visible = true;
                }
                else
                {
                    this.mcChar.backrobe.visible = false;
                }
            }
            catch(e:Error)
            {
                mcChar.backrobe.visible = false;
            }
            this.isLoaded = true;
        }
        
        public function loadHair() : void
        {
            var _loc2_:Class = null;
            trace("onHairLoadComplete >");
            try
            {
                trace("hair linkage: " + (main.Game.world.myAvatar.pMC.pAV.objData.strHairName + main.Game.world.myAvatar.pMC.pAV.objData.strGender + "Hair"));
                _loc2_ = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.strHairName + main.Game.world.myAvatar.pMC.pAV.objData.strGender + "Hair") as Class;
                if(_loc2_ != null)
                {
                    if(this.mcChar.head.hair.numChildren > 0)
                    {
                        this.mcChar.head.hair.removeChildAt(0);
                    }
                    this.mcChar.head.hair.addChild(new _loc2_());
                    this.mcChar.head.hair.visible = true;
                }
                else
                {
                    this.mcChar.head.hair.visible = false;
                }
                _loc2_ = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.strHairName + main.Game.world.myAvatar.pMC.pAV.objData.strGender + "HairBack") as Class;
                if(_loc2_ != null)
                {
                    if(this.mcChar.backhair.numChildren > 0)
                    {
                        this.mcChar.backhair.removeChildAt(0);
                    }
                    this.mcChar.backhair.addChild(new _loc2_());
                    this.mcChar.backhair.visible = true;
                    this.bBackHair = true;
                }
                else
                {
                    this.mcChar.backhair.visible = false;
                    this.bBackHair = false;
                }
                if("he" in main.Game.world.myAvatar.pMC.pAV.objData.eqp && main.Game.world.myAvatar.pMC.pAV.objData.eqp.he != null)
                {
                    if(main.Game.world.myAvatar.pMC.pAV.dataLeaf.showHelm)
                    {
                        this.mcChar.head.hair.visible = false;
                    }
                    else
                    {
                        this.mcChar.head.hair.visible = true;
                    }
                }
                return;
            }
            catch(e:Error){}
        }
        
        public function loadWeapon() : void
        {
            var AssetClass:Class = null;
            trace("onLoadWeaponComplete >");
            this.mcChar.weapon.removeChildAt(0);
            try
            {
                AssetClass = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.eqp.Weapon.sLink) as Class;
                this.mcChar.weapon.mcWeapon = new AssetClass();
                this.mcChar.weapon.addChild(this.mcChar.weapon.mcWeapon);
            }
            catch(err:Error)
            {
                trace(" Weapon added to display list manually");
                mcChar.weapon.addChild(main.Game.world.myAvatar.pMC.mcChar.weapon.mcWeapon);
            }
            this.mcChar.weapon.visible = true;
            this.mcChar.weaponOff.visible = false;
            var wItem:Object = main.Game.world.myAvatar.pMC.pAV.getItemByEquipSlot("Weapon");
            if(wItem != null && wItem.sType != null)
            {
                if(wItem.sType == "Dagger")
                {
                    this.loadWeaponOff();
                }
            }
        }
        
        public function loadWeaponOff() : void
        {
            var AssetClass:Class = null;
            trace("onLoadWeaponOffComplete >");
            this.mcChar.weaponOff.removeChildAt(0);
            try
            {
                AssetClass = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.eqp.Weapon.sLink) as Class;
                this.mcChar.weaponOff.addChild(new AssetClass());
            }
            catch(err:Error)
            {
                trace(" weaponOff added to display list manually");
                mcChar.weaponOff.addChild(main.Game.world.myAvatar.pMC.mcChar.weaponOff);
            }
            this.mcChar.weaponOff.visible = true;
        }
        
        public function loadCape() : void
        {
            var _loc2_:Class = null;
            try
            {
                _loc2_ = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.eqp.ba.sLink) as Class;
                this.mcChar.cape.removeChildAt(0);
                this.mcChar.cape.cape = new _loc2_();
                this.mcChar.cape.addChild(this.mcChar.cape.cape);
                this.setCloakVisibility(main.Game.world.myAvatar.pMC.pAV.dataLeaf.showCloak);
                return;
            }
            catch(e:*){}
        }
        
        public function loadHelm() : void
        {
            trace("pMC.onLoadHelmComplete >");
            var _loc2_:Class = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.eqp.he.sLink) as Class;
            var _loc3_:Class = this.world.getClass(main.Game.world.myAvatar.pMC.pAV.objData.eqp.he.sLink + "_backhair") as Class;
            if(_loc2_ != null)
            {
                if(this.mcChar.head.helm.numChildren > 0)
                {
                    this.mcChar.head.helm.removeChildAt(0);
                }
                this.mcChar.head.helm.visible = main.Game.world.myAvatar.pMC.pAV.dataLeaf.showHelm;
                this.mcChar.head.hair.visible = !this.mcChar.head.helm.visible;
                if(_loc3_ != null)
                {
                    if(main.Game.world.myAvatar.pMC.pAV.dataLeaf.showHelm)
                    {
                        if(this.mcChar.backhair.numChildren > 0)
                        {
                            this.mcChar.backhair.removeChildAt(0);
                        }
                        this.mcChar.backhair.visible = true;
                        this.mcChar.backhair.addChild(new _loc3_());
                    }
                }
                else
                {
                    this.mcChar.backhair.visible = this.mcChar.head.hair.visible && this.bBackHair;
                }
                this.mcChar.head.helm.addChild(new _loc2_());
            }
        }
        
        public function setHelmVisibility(param1:Boolean) : void
        {
            trace("setHelmVisibility > " + param1);
            if(main.Game.world.myAvatar.pMC.pAV.objData.eqp.he != null && main.Game.world.myAvatar.pMC.pAV.objData.eqp.he.sLink != null)
            {
                if(param1)
                {
                    this.mcChar.head.helm.visible = true;
                    this.mcChar.head.hair.visible = false;
                    this.mcChar.backhair.visible = false;
                }
                else
                {
                    this.mcChar.head.helm.visible = false;
                    this.mcChar.head.hair.visible = true;
                    this.mcChar.backhair.visible = this.bBackHair;
                }
            }
        }
        
        public function setCloakVisibility(param1:Boolean) : void
        {
            trace("setCloakVisibility > " + param1);
            if(main.Game.world.myAvatar.pMC.pAV.objData.eqp.ba != null && main.Game.world.myAvatar.pMC.pAV.objData.eqp.ba.sLink != null)
            {
                if(main.Game.world.myAvatar.pMC.pAV.isMyAvatar)
                {
                    this.mcChar.cape.visible = param1;
                }
                else
                {
                    this.mcChar.cape.visible = param1 && !this.world.hideAllCapes;
                }
            }
        }
        
        public function setColor(param1:MovieClip, param2:String, param3:String, param4:String) : void
        {
            var _loc5_:Number = Number(main.Game.world.myAvatar.pMC.pAV.objData["intColor" + param3]);
            param1.isColored = true;
            param1.intColor = _loc5_;
            param1.strLocation = param3;
            param1.strShade = param4;
            this.changeColor(param1,_loc5_,param4);
        }
        
        public function changeColor(param1:MovieClip, param2:Number, param3:String, param4:String = "") : void
        {
            var _loc5_:ColorTransform = new ColorTransform();
            if(param4 == "")
            {
                _loc5_.color = param2;
            }
            switch(param3.toUpperCase())
            {
                case "LIGHT":
                    _loc5_.redOffset = _loc5_.redOffset + 100;
                    _loc5_.greenOffset = _loc5_.greenOffset + 100;
                    _loc5_.blueOffset = _loc5_.blueOffset + 100;
                    break;
                case "DARK":
                    _loc5_.redOffset = _loc5_.redOffset - 25;
                    _loc5_.greenOffset = _loc5_.greenOffset - 50;
                    _loc5_.blueOffset = _loc5_.blueOffset - 50;
                    break;
                case "DARKER":
                    _loc5_.redOffset = _loc5_.redOffset - 125;
                    _loc5_.greenOffset = _loc5_.greenOffset - 125;
                    _loc5_.blueOffset = _loc5_.blueOffset - 125;
            }
            if(param4 == "-")
            {
                _loc5_.redOffset = _loc5_.redOffset * -1;
                _loc5_.greenOffset = _loc5_.greenOffset * -1;
                _loc5_.blueOffset = _loc5_.blueOffset * -1;
            }
            if(param4 == "" || param1.transform.colorTransform.redOffset != _loc5_.redOffset)
            {
                param1.transform.colorTransform = _loc5_;
            }
        }
        
        public function modulateColor(param1:ColorTransform, param2:String) : void
        {
            var _loc3_:MovieClip = this.stage.getChildAt(0) as MovieClip;
            if(param2 == "+")
            {
                this.totalTransform.alphaMultiplier = this.totalTransform.alphaMultiplier + param1.alphaMultiplier;
                this.totalTransform.alphaOffset = this.totalTransform.alphaOffset + param1.alphaOffset;
                this.totalTransform.redMultiplier = this.totalTransform.redMultiplier + param1.redMultiplier;
                this.totalTransform.redOffset = this.totalTransform.redOffset + param1.redOffset;
                this.totalTransform.greenMultiplier = this.totalTransform.greenMultiplier + param1.greenMultiplier;
                this.totalTransform.greenOffset = this.totalTransform.greenOffset + param1.greenOffset;
                this.totalTransform.blueMultiplier = this.totalTransform.blueMultiplier + param1.blueMultiplier;
                this.totalTransform.blueOffset = this.totalTransform.blueOffset + param1.blueOffset;
            }
            else if(param2 == "-")
            {
                this.totalTransform.alphaMultiplier = this.totalTransform.alphaMultiplier - param1.alphaMultiplier;
                this.totalTransform.alphaOffset = this.totalTransform.alphaOffset - param1.alphaOffset;
                this.totalTransform.redMultiplier = this.totalTransform.redMultiplier - param1.redMultiplier;
                this.totalTransform.redOffset = this.totalTransform.redOffset - param1.redOffset;
                this.totalTransform.greenMultiplier = this.totalTransform.greenMultiplier - param1.greenMultiplier;
                this.totalTransform.greenOffset = this.totalTransform.greenOffset - param1.greenOffset;
                this.totalTransform.blueMultiplier = this.totalTransform.blueMultiplier - param1.blueMultiplier;
                this.totalTransform.blueOffset = this.totalTransform.blueOffset - param1.blueOffset;
            }
            this.clampedTransform.alphaMultiplier = _loc3_.clamp(this.totalTransform.alphaMultiplier,-1,1);
            this.clampedTransform.alphaOffset = _loc3_.clamp(this.totalTransform.alphaOffset,-255,255);
            this.clampedTransform.redMultiplier = _loc3_.clamp(this.totalTransform.redMultiplier,-1,1);
            this.clampedTransform.redOffset = _loc3_.clamp(this.totalTransform.redOffset,-255,255);
            this.clampedTransform.greenMultiplier = _loc3_.clamp(this.totalTransform.greenMultiplier,-1,1);
            this.clampedTransform.greenOffset = _loc3_.clamp(this.totalTransform.greenOffset,-255,255);
            this.clampedTransform.blueMultiplier = _loc3_.clamp(this.totalTransform.blueMultiplier,-1,1);
            this.clampedTransform.blueOffset = _loc3_.clamp(this.totalTransform.blueOffset,-255,255);
            this.transform.colorTransform = this.clampedTransform;
        }
        
        public function updateColor(param1:Object = null) : *
        {
            var _loc2_:* = main.Game.world.myAvatar.pMC.pAV.objData;
            if(param1 != null)
            {
                _loc2_ = param1;
            }
            var _loc3_:* = MovieClip(stage.getChildAt(0)).ui;
            this.scanColor(this,_loc2_);
        }
        
        private function scanColor(param1:MovieClip, param2:*) : void
        {
            var _loc4_:DisplayObject = null;
            if("isColored" in param1)
            {
                this.changeColor(param1,Number(param2["intColor" + param1.strLocation]),param1.strShade);
            }
            var _loc3_:int = 0;
            while(_loc3_ < param1.numChildren)
            {
                _loc4_ = param1.getChildAt(_loc3_);
                if(_loc4_ is MovieClip)
                {
                    this.scanColor(MovieClip(_loc4_),param2);
                }
                _loc3_++;
            }
        }
        
        public function queueAnim(param1:String) : void
        {
            var wItem:Object = null;
            var sType:* = undefined;
            var world:MovieClip = null;
            var l:String = null;
            var s:String = param1;
            trace("queueing...");
            if(s == "Attack1" || s == "Attack2")
            {
                wItem = main.Game.world.myAvatar.pMC.pAV.getItemByEquipSlot("Weapon");
                if(wItem != null && wItem.sType != null)
                {
                    sType = wItem.sType;
                    if(wItem.ItemID == 156 || wItem.ItemID == 12583)
                    {
                        sType = "Unarmed";
                    }
                    switch(sType)
                    {
                        case "Unarmed2":
                            s = ["UnarmedAttack1","UnarmedAttack2","KickAttack","FlipAttack"][Math.round(Math.random() * 3)];
                            break;
                        case "Polearm":
                            s = ["PolearmAttack1","PolearmAttack2"][Math.round(Math.random() * 1)];
                            break;
                        case "Dagger":
                            s = ["DuelWield/DaggerAttack1","DuelWield/DaggerAttack2"][Math.round(Math.random() * 1)];
                            break;
                        case "Bow":
                            s = "RangedAttack1";
                    }
                }
            }
            trace("made it here");
            if(main.Game.world.myAvatar.pMC.pAV.dataLeaf.intState > 0)
            {
                main.Game.world.myAvatar.pMC.pAV.handleItemAnimation();
                world = main.Game.world as MovieClip;
                l = this.mcChar.currentLabel;
                trace("Queueing Anim " + s);
                this.animQueue.push(s);
            }
            else
            {
                trace("playing ahead");
                this.mcChar.gotoAndPlay(s);
                if(s.indexOf("Attack") >= 0 && this.mcChar.weapon.mcWeapon.bAttack == true)
                {
                    this.mcChar.weapon.mcWeapon.gotoAndPlay("Attack");
                }
            }
        }
        
        public function checkQueue() : Boolean
        {
            var _loc2_:MovieClip = null;
            var _loc3_:String = null;
            var _loc4_:int = 0;
            var _loc5_:* = undefined;
            if(this.animQueue.length > 0)
            {
                trace("Length is greater than 0");
                _loc2_ = main.Game.world as MovieClip;
                _loc3_ = this.mcChar.currentLabel;
                _loc4_ = this.mcChar.emoteLoopFrame();
                trace("curr Frame: " + this.mcChar.currentFrame + " ! " + (_loc4_ + 4));
                //if(this.mcChar.currentFrame > _loc4_ + 4)
                if(!this.mcChar.isPlaying)
                {
                    trace("Playing");
                    _loc5_ = this.animQueue[0];
                    this.mcChar.gotoAndPlay(_loc5_);
                    if(_loc5_.indexOf("Attack") >= 0 && this.mcChar.weapon.mcWeapon.bAttack == true)
                    {
                        this.mcChar.weapon.mcWeapon.gotoAndPlay("Attack");
                    }
                    this.animQueue.shift();
                    return true;
                }
            }
            return false;
        }
        
        public function clearQueue() : void
        {
            this.animQueue = [];
        }
        
        private function linearTween(param1:*, param2:*, param3:*, param4:*) : Number
        {
            return param3 * param1 / param4 + param2;
        }
        
        public function walkTo(param1:int, param2:int, param3:int) : void
        {
            var dist:Number = NaN;
            var dx:Number = NaN;
            var toX:int = param1;
            var toY:int = param2;
            var walkSpeed:int = param3;
            var isOK:Boolean = true;
            try
            {
            this.STAGE = MovieClip(parent.parent);
            }
            catch(e:Error)
            {
            isOK = false;
            }
            if(isOK)
            {
                this.op = new Point(this.x,this.y);
                this.tp = new Point(toX,toY);
                this.walkSpeed = walkSpeed;
                dist = Point.distance(this.op,this.tp);
                this.walkTS = new Date().getTime();
                this.walkD = Math.round(1000 * (dist / (walkSpeed * 22)));
                if(this.walkD > 0)
                {
                    dx = this.op.x - this.tp.x;
                    if(dx < 0)
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    }
                    if(!this.mcChar.onMove)
                    {
                        this.mcChar.onMove = true;
                        if(this.mcChar.currentLabel != "Walk")
                        {
                            this.mcChar.gotoAndPlay("Walk");
                        }
                    }
                    //this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
                    //this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
                }
            }
        }
        
        public function stopWalking() : void
        {
            this.world = MovieClip(stage.getChildAt(0)).world;
            if(this.mcChar.onMove)
            {
            //this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(main.Game.world.myAvatar.pMC.pAV.isMyAvatar && MovieClip(parent.parent).actionReady)
            {
                this.world.testAction(this.world.getAutoAttack());
            }
            }
            this.mcChar.onMove = false;
            if(this.walkSpeed > 23)
            {
                this.mcChar.gotoAndPlay("Fight");
            }
            else
            {
                this.mcChar.gotoAndPlay("Idle");
            }
        }
        
        public function turn(param1:String) : void
        {
            if(param1 == "right" && this.mcChar.scaleX < 0 || param1 == "left" && this.mcChar.scaleX > 0)
            {
                this.mcChar.scaleX = this.mcChar.scaleX * -1;
            }
        }
        
        public function scale(param1:Number) : void
        {
            if(this.mcChar.scaleX >= 0)
            {
                this.mcChar.scaleX = param1;
            }
            else
            {
                this.mcChar.scaleX = -param1;
            }
            this.mcChar.scaleY = param1;
            var _loc2_:Point = this.mcChar.localToGlobal(this.headPoint);
            _loc2_ = this.globalToLocal(_loc2_);
            this.drawHitBox();
        }
        
        public function endAction() : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:String = null;
            var _loc4_:Object = null;
            var _loc5_:* = undefined;
            var _loc1_:* = null;
            if(main.Game.world.myAvatar.pMC.pAV.target != null)
            {
                _loc1_ = main.Game.world.myAvatar.pMC.pAV.target.pMC.getChildAt(1);
            }
            if(!this.checkQueue())
            {
                if(this.mcChar.onMove)
                {
                    this.mcChar.gotoAndPlay("Walk");
                    _loc2_ = this.x - this.xTar;
                    if(_loc2_ < 0)
                    {
                        this.turn("right");
                    }
                    else
                    {
                        this.turn("left");
                    }
                }
                else if(_loc1_ == null || _loc1_ != null && (_loc1_.currentLabel == "Die" || _loc1_.currentLabel == "Feign" || _loc1_.currentLabel == "Dead" 
                    || main.Game.world.myAvatar.pMC.pAV.target.npcType == "player" 
                    && (!("pvpTeam" in main.Game.world.myAvatar.pMC.pAV.dataLeaf) 
                    || main.Game.world.myAvatar.pMC.pAV.dataLeaf.pvpTeam == main.Game.world.myAvatar.pMC.pAV.target.dataLeaf.pvpTeam)))
                {
                    if(this.mcChar.currentLabel != "Jump")
                    {
                        this.mcChar.gotoAndPlay("Idle");
                    }
                    if(_loc1_ != null)
                    {
                        if(main.Game.world.myAvatar.pMC.pAV.target.dataLeaf.intState == 0)
                        {
                            if(main.Game.world.myAvatar.pMC.pAV == this.world.myAvatar)
                            {
                            this.world.setTarget(null);
                            }
                        }
                    }
                }
                else
                {
                    _loc3_ = "Fight";
                    _loc4_ = main.Game.world.myAvatar.pMC.pAV.getItemByEquipSlot("Weapon");
                    if(_loc4_ != null && _loc4_.sType != null)
                    {
                        _loc5_ = _loc4_.sType;
                        if(_loc4_.ItemID == 156)
                        {
                            _loc5_ = "Unarmed";
                        }
                        switch(_loc5_)
                        {
                            case "Unarmed":
                            _loc3_ = "UnarmedFight";
                            break;
                            case "Polearm":
                            _loc3_ = "PolearmFight";
                            break;
                            case "Dagger":
                            _loc3_ = "DuelWield/DaggerFight";
                        }
                    }
                    this.mcChar.gotoAndPlay(_loc3_);
                }
            }
        }
        
        private function drawHitBox() : void
        {
            this.mcChar.hitbox.graphics.clear();
            var _loc1_:int = -30;
            var _loc2_:int = 60;
            var _loc3_:int = this.mcChar.head.y;
            var _loc4_:int = -_loc3_ * 0.8;
            this.hitboxR = new Rectangle(_loc1_,_loc3_,_loc2_,_loc4_);
            var _loc5_:Graphics = this.mcChar.hitbox.graphics;
            _loc5_.lineStyle(0,16777215,0);
            _loc5_.beginFill(11141375,0);
            _loc5_.moveTo(_loc1_,_loc3_);
            _loc5_.lineTo(_loc1_ + _loc2_,_loc3_);
            _loc5_.lineTo(_loc1_ + _loc2_,_loc3_ + _loc4_);
            _loc5_.lineTo(_loc1_,_loc3_ + _loc4_);
            _loc5_.lineTo(_loc1_,_loc3_);
            _loc5_.endFill();
        }
        
        private function randomNumber(param1:Number, param2:Number) : Number
        {
            this.randNum = param1 + (param2 + 1 - param1) * this.XORandom();
            return this.randNum < param2?Number(this.randNum):Number(param2);
        }
        
        private function XORandom() : Number
        {
            this.r = this.r ^ this.r << 21;
            this.r = this.r ^ this.r >>> 35;
            this.r = this.r ^ this.r << 4;
            if(this.r > 0)
            {
            return this.r * this.MAX_RATIO;
            }
            return this.r * this.NEGA_MAX_RATIO;
        }
        
        public function iaF(param1:Object) : void
        {
            var _loc2_:MovieClip = null;
            trace("avatar iaF called");
            _loc2_ = this.mcChar.head.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.chest.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.hip.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.idlefoot.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.frontfoot.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backfoot.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.frontshoulder.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backshoulder.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.fronthand.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backhand.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.frontthigh.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backthigh.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.frontshin.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backshin.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.robe.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
            }
            catch(e:*)
            {
            }
            }
            _loc2_ = this.mcChar.backrobe.getChildAt(0) as MovieClip;
            if(_loc2_ != null)
            {
            try
            {
                _loc2_.iaF(param1);
                return;
            }
            catch(e:*)
            {
                return;
            }
            }
        }
        
        public function addAnimationListener(param1:String, param2:Function) : void
        {
            if(this.animEvents[param1] == null)
            {
                this.animEvents[param1] = new Array();
            }
            if(!this.hasAnimationListener(param1,param2))
            {
                this.animEvents[param1].push(param2);
            }
        }
        
        public function removeAnimationListener(param1:String, param2:Function) : void
        {
            if(this.animEvents[param1] == null)
            {
                return;
            }
            var _loc3_:uint = 0;
            while(_loc3_ < this.animEvents[param1].length)
            {
                if(this.animEvents[param1][_loc3_] == param2)
                {
                    this.animEvents[param1].splice(_loc3_,1);
                    break;
                }
                _loc3_++;
            }
        }
        
        public function hasAnimationListener(param1:String, param2:Function) : Boolean
        {
            if(this.animEvents[param1] == null)
            {
                return false;
            }
            var _loc3_:uint = 0;
            while(_loc3_ < this.animEvents[param1].length)
            {
                if(this.animEvents[param1][_loc3_] == param2)
                {
                    return true;
                }
                _loc3_++;
            }
            return false;
        }
        
        private function handleAnimEvent(param1:String) : void
        {
            var _loc2_:Function = null;
            if(this.animEvents[param1] == null)
            {
                return;
            }
            var _loc3_:uint = 0;
            while(_loc3_ < this.animEvents[param1].length)
            {
                _loc2_ = this.animEvents[param1][_loc3_];
                _loc2_();
                _loc3_++;
            }
        }
        
        public function get AnimEvent() : Object
        {
            return this.animEvents;
        }
        
        function frame1() : *
        {
            this.mcChar.transform.colorTransform = this.CT1;
            this.mcChar.alpha = 0;
            stop();
        }
        
        function frame5() : *
        {
            this.mcChar.transform.colorTransform = this.CT1;
            this.mcChar.alpha = 0;
        }
        
        function frame8() : *
        {
            stop();
        }
        
        function frame10() : *
        {
            this.mcChar.alpha = 0;
        }
        
        function frame12() : *
        {
            this.mcChar.transform.colorTransform = this.CT3;
        }
        
        function frame13() : *
        {
            this.mcChar.transform.colorTransform = this.CT2;
        }
        
        function frame14() : *
        {
            this.mcChar.transform.colorTransform = this.CT1;
        }
        
        function frame18() : *
        {
            stop();
        }
        
        function frame20() : *
        {
            this.mcChar.transform.colorTransform = this.CT1;
        }
        
        function frame23() : *
        {
            stop();
        }
    }
}

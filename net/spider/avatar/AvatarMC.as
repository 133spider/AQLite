package net.spider.avatar{
    import flash.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.filters.*;

    public class AvatarMC extends MovieClip {

        public var mcChar:MovieClip;
        public var shadow:MovieClip;
        public var strGender:String;
        public var noGlow:Boolean = false;
        var ldr:Loader;
        var defaultCT:ColorTransform;
        var serverFilePath:String = "http://aqworldscdn.aq.com/game/gamefiles/";
        public var pAV:Object;
        var strSkinLinkage:String;

        public function AvatarMC(){
            this.ldr = new Loader();
            this.defaultCT = MovieClip(this).transform.colorTransform;
            this.pAV = new Object();
            visible = false;
            this.hideOptionalParts();
        }
        private function hideOptionalParts():void{
            var i:*;
            var killList:* = ["cape", "backhair", "robe", "backrobe"];
            for (i in killList) {
                if (typeof(this.mcChar[killList[i]]) != undefined){
                    this.mcChar[killList[i]].visible = false;
                };
            };
        }
        public function loadArmor(strFilename:String, sLink:String){
            this.hideOptionalParts();
            this.strSkinLinkage = sLink;
            this.ldr.load(new URLRequest(((((this.serverFilePath + "classes/") + this.pAV.objData.strGender) + "/") + strFilename)), new LoaderContext(false, ApplicationDomain.currentDomain));
            this.ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadSkinComplete);
            this.ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
        }
        private function onLoadSkinComplete(evt:Event){
            var AssetClass:* = null;
            var evt:* = evt;
            this.strGender = this.pAV.objData.strGender;
            try {
                AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Head")) as Class);
                this.mcChar.head.removeChildAt(0);
                this.mcChar.head.addChildAt(new (AssetClass)(), 0);
            } catch(err:Error) {
                AssetClass = (getDefinitionByName(("net.spider.avatar." + "mcHead" + strGender)) as Class);
                mcChar.head.removeChildAt(0);
                mcChar.head.addChildAt(new (AssetClass)(), 0);
            };
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Chest")) as Class);
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Hip")) as Class);
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "FootIdle")) as Class);
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Foot")) as Class);
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Shoulder")) as Class);
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new (AssetClass)());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Hand")) as Class);
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChild(new (AssetClass)());
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Thigh")) as Class);
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new (AssetClass)());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new (AssetClass)());
            AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Shin")) as Class);
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new (AssetClass)());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new (AssetClass)());
            try {
                AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "Robe")) as Class);
                this.mcChar.robe.removeChildAt(0);
                this.mcChar.robe.addChild(new (AssetClass)());
                this.mcChar.robe.visible = true;
            } catch(err:Error) {
            };
            try {
                AssetClass = (this.ldr.contentLoaderInfo.applicationDomain.getDefinition(((this.strSkinLinkage + this.strGender) + "RobeBack")) as Class);
                this.mcChar.backrobe.removeChildAt(0);
                this.mcChar.backrobe.addChild(new (AssetClass)());
                this.mcChar.backrobe.visible = true;
            } catch(err:Error) {
            };
            this.addGlow(this.mcChar);
            visible = true;
        }
        private function ioErrorHandler(event:IOErrorEvent):void{
            trace(("ioErrorHandler: " + event));
        }
        public function setColor(mc:MovieClip, strLocation:String, strShade:String):void{
            var intColor:Number = Number(this.pAV.objData[("intColor" + strLocation)]);
            mc.isColored = true;
            mc.intColor = intColor;
            mc.strLocation = strLocation;
            mc.strShade = strShade;
            this.changeColor(mc, intColor, strShade);
        }
        public function changeColor(mc:MovieClip, intColor:Number, strShade:String):void{
            var newCT:ColorTransform = new ColorTransform();
            newCT.color = intColor;
            switch (strShade.toUpperCase()){
                case "LIGHT":
                    newCT.redOffset = (newCT.redOffset + 100);
                    newCT.greenOffset = (newCT.greenOffset + 100);
                    newCT.blueOffset = (newCT.blueOffset + 100);
                    break;
                case "DARK":
                    newCT.redOffset = (newCT.redOffset - 25);
                    newCT.greenOffset = (newCT.greenOffset - 50);
                    newCT.blueOffset = (newCT.blueOffset - 50);
                    break;
                case "DARKER":
                    newCT.redOffset = (newCT.redOffset - 125);
                    newCT.greenOffset = (newCT.greenOffset - 125);
                    newCT.blueOffset = (newCT.blueOffset - 125);
                    break;
            };
            mc.transform.colorTransform = newCT;
        }
        private function addGlow(mc:MovieClip):void{
            if (this.noGlow){
                return;
            };
            var mcFilter:* = new GlowFilter(0xFFFFFF, 1, 8, 8, 2, 1, false, false);
            mc.filters = [mcFilter];
		}
    }
}//package 
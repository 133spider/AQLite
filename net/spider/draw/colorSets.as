package net.spider.draw{
    import fl.motion.Color;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import fl.data.DataProvider;
    import net.spider.main;
    import fl.controls.TextInput;
    import fl.managers.StyleManager;

    public class colorSets extends MovieClip {

        public var mode:String;

        public function colorSets(){ 
            this.txtRed.text = "255";
            this.txtGreen.text = "255";
            this.txtBlue.text = "255";
            this.txtHex.text = "#ffffff";

            this.txtColor1.text = "#ffffff";
            this.txtColor2.text = "#ffffff";
            this.txtColor3.text = "#ffffff";
            this.txtName.text = "My Color Set 1";

            this.bg.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			this.bg.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);

            this.cbSets.addEventListener(MouseEvent.CLICK, onCbSets, false, 0, true);
            this.cbSets.addEventListener(Event.CHANGE, onCbSets, false, 0, true);

            this.txtColor1.addEventListener(Event.CHANGE, onTxtColor1, false, 0, true);
            this.txtColor2.addEventListener(Event.CHANGE, onTxtColor2, false, 0, true);
            this.txtColor3.addEventListener(Event.CHANGE, onTxtColor3, false, 0, true);

            this.btnColor.addEventListener(MouseEvent.CLICK, onBtColor, false, 0, true);
            this.btnApply.addEventListener(MouseEvent.CLICK, onBtApply, false, 0, true);
            this.btnAdd.addEventListener(MouseEvent.CLICK, onBtAdd, false, 0, true);
            this.btnDel.addEventListener(MouseEvent.CLICK, onBtDel, false, 0, true);

            this.btnCopy.addEventListener(MouseEvent.CLICK, onBtCopy, false, 0, true);
        }

        public function onUpdate():void{
            if(main.sharedObject.data.colorSets)
                this.cbSets.dataProvider = new DataProvider(main.sharedObject.data.colorSets);
        }

        private function onBtCopy(e:MouseEvent):void{
            if(mode == "mcCustomize"){
                this.txtColor1.text = "#" + main.Game.ui.mcPopup.mcCustomize.cpHair.selectedColor.toString(16);
                this.txtColor2.text = "#" + main.Game.ui.mcPopup.mcCustomize.cpSkin.selectedColor.toString(16);
                this.txtColor3.text = "#" + main.Game.ui.mcPopup.mcCustomize.cpEye.selectedColor.toString(16);
            }else{
                this.txtColor1.text = "#" + main.Game.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor.toString(16);
                this.txtColor2.text = "#" + main.Game.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor.toString(16);
                this.txtColor3.text = "#" + main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor.toString(16);
            }

            this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
        }

        private function onBtApply(e:MouseEvent):void{
            if(mode == "mcCustomize"){
                main.Game.ui.mcPopup.mcCustomize.cpHair.selectedColor = int("0x" + this.txtColor1.text.replace("#", ""));
                main.Game.ui.mcPopup.mcCustomize.cpSkin.selectedColor = int("0x" + this.txtColor2.text.replace("#", ""));
                main.Game.ui.mcPopup.mcCustomize.cpEye.selectedColor = int("0x" + this.txtColor3.text.replace("#", ""));

                if(!main.Game.ui.mcPopup.mcCustomize.backData.intColorHair)
                    main.Game.ui.mcPopup.mcCustomize.backData.intColorHair = main.Game.world.myAvatar.objData.intColorHair;
                if(!main.Game.ui.mcPopup.mcCustomize.backData.intColorSkin)
                    main.Game.ui.mcPopup.mcCustomize.backData.intColorSkin = main.Game.world.myAvatar.objData.intColorSkin;
                if(!main.Game.ui.mcPopup.mcCustomize.backData.intColorEye)
                    main.Game.ui.mcPopup.mcCustomize.backData.intColorEye = main.Game.world.myAvatar.objData.intColorEye;

                main.Game.world.myAvatar.objData.intColorHair = int("0x" + this.txtColor1.text.replace("#", ""));
                main.Game.world.myAvatar.objData.intColorSkin = int("0x" + this.txtColor2.text.replace("#", ""));
                main.Game.world.myAvatar.objData.intColorEye = int("0x" + this.txtColor3.text.replace("#", ""));
            }else{
                main.Game.ui.mcPopup.mcCustomizeArmor.cpBase.selectedColor = int("0x" + this.txtColor1.text.replace("#", ""));
                main.Game.ui.mcPopup.mcCustomizeArmor.cpTrim.selectedColor = int("0x" + this.txtColor2.text.replace("#", ""));
                main.Game.ui.mcPopup.mcCustomizeArmor.cpAccessory.selectedColor = int("0x" + this.txtColor3.text.replace("#", ""));

                if(!main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorBase)
                    main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorBase = main.Game.world.myAvatar.objData.intColorBase;
                if(!main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim)
                    main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorTrim = main.Game.world.myAvatar.objData.intColorTrim;
                if(!main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory)
                    main.Game.ui.mcPopup.mcCustomizeArmor.backData.intColorAccessory = main.Game.world.myAvatar.objData.intColorAccessory;

                main.Game.world.myAvatar.objData.intColorBase = int("0x" + this.txtColor1.text.replace("#", ""));
                main.Game.world.myAvatar.objData.intColorTrim = int("0x" + this.txtColor2.text.replace("#", ""));
                main.Game.world.myAvatar.objData.intColorAccessory = int("0x" + this.txtColor3.text.replace("#", ""));
            }
            main.Game.world.myAvatar.pMC.updateColor();
        }

        private function onCbSets(e:Event):void{
            if(this.cbSets.selectedIndex < 0)
                return;
            this.txtName.text = this.cbSets.selectedItem.label;
            this.txtColor1.text = this.cbSets.selectedItem.color1;
            this.txtColor2.text = this.cbSets.selectedItem.color2;
            this.txtColor3.text = this.cbSets.selectedItem.color3;

            this.txtColor1.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor2.dispatchEvent(new Event(Event.CHANGE));
            this.txtColor3.dispatchEvent(new Event(Event.CHANGE));
        }

        private function onTxtColor1(e:Event):void{
            try{
                var myColorTransform = new ColorTransform();
                myColorTransform.color = int("0x" + this.txtColor1.text.replace("#", ""));
                this.cPreview1.transform.colorTransform = myColorTransform;
            }catch(exception){}
        }

        private function onTxtColor2(e:Event):void{
            try{
                var myColorTransform = new ColorTransform();
                myColorTransform.color = int("0x" + this.txtColor2.text.replace("#", ""));
                this.cPreview2.transform.colorTransform = myColorTransform;
            }catch(exception){}
        }

        private function onTxtColor3(e:Event):void{
            try{
                var myColorTransform = new ColorTransform();
                myColorTransform.color = int("0x" + this.txtColor3.text.replace("#", ""));
                this.cPreview3.transform.colorTransform = myColorTransform;
            }catch(exception){}
        }

        private function onBtAdd(evt:MouseEvent):void{
            this.cbSets.addItem({
                label:this.txtName.text,
                color1:this.txtColor1.text,
                color2:this.txtColor2.text,
                color3:this.txtColor3.text});
            main.sharedObject.data.colorSets = this.cbSets.dataProvider.toArray();
			main.sharedObject.flush();
        }

        private function onBtDel(evt:MouseEvent):void{
            if(this.cbSets.selectedIndex != -1)
                this.cbSets.removeItemAt(this.cbSets.selectedIndex);
            this.cbSets.selectedIndex = -1;
            main.sharedObject.data.colorSets = this.cbSets.dataProvider.toArray();
			main.sharedObject.flush();
        }

        private function onBtColor(evt:MouseEvent):void{
            stage.addEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private var _stageBitmap:BitmapData;
        private function getColor(evt:MouseEvent):void{
            if (_stageBitmap == null) 
                _stageBitmap = new BitmapData(stage.width, stage.height);
            _stageBitmap.draw(stage);

            var rgb:uint = _stageBitmap.getPixel(stage.mouseX,stage.mouseY);

            var red:int =  (rgb >> 16 & 0xff);
            var green:int =  (rgb >> 8 & 0xff);
            var blue:int =  (rgb & 0xff);

            this.txtRed.text = red.toString();
            this.txtGreen.text = green.toString();
            this.txtBlue.text = blue.toString();

            this.txtHex.text = "#" + rgb.toString(16);

            var c:Color=new Color();
            c.setTint(rgb, 1);
            this.colorPreview.transform.colorTransform = c;

            stage.removeEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private function onHold(e:MouseEvent):void{
            if(!(e.target is TextField))
                this.startDrag();
        }
            
        private function onMouseRelease(e:MouseEvent):void{
            this.stopDrag();
        }
    }
}
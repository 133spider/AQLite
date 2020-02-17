package net.spider.draw{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import flash.text.*;
    import fl.data.DataProvider;
    import net.spider.main;
    import net.spider.handlers.DrawEvent;
    import net.spider.handlers.dropmenutwo;
    import net.spider.handlers.modules;
    import net.spider.draw.dRender;
    import net.spider.draw.detailedCheck;
    import net.spider.handlers.optionHandler;

    public class dEntry extends MovieClip {

        public var itemObj:Object;
        var format:TextFormat = new TextFormat();
        public function dEntry(resObj:Object, relQty:int):void{ //X: 2.5 Y: 3
            this.gotoAndStop("idle");
            this.btYes.visible = false;
            this.btNo.visible = false;
            this.btPreview.visible = false;
            var AssetClass:Class;
            var mcIcon:*;

            itemObj = resObj;

            this.iconAC.visible = (resObj.bCoins == 1);
            this.txtDrop.text = "";
            this.txtDrop.htmlText = "";
            if(resObj.bUpg == 1)
                this.txtDrop.htmlText = "<font color='#FCC749'>" + resObj.sName + " x " + relQty + "</font>";
            else
                this.txtDrop.text = (resObj.sName + " x " + relQty);

            /**if(this.txtDrop.textWidth > 135){
                var testSize:int = 200;
                while( testSize > 10 ){
                    updateFormat( testSize );
                    if( this.txtDrop.numLines > 1 ){
                        testSize--;
                    }else{
                        testSize = 10;
                    }
                }
            }**/

            if(this.iconAC.visible)
                this.iconAC.x = this.txtDrop.textWidth + 35;
            var sIcon:String = "";
            if (resObj.sType.toLowerCase() == "enhancement")
            {
                sIcon = main.Game.getIconBySlot(resObj.sES);
            }
            else
            {
                if ((((resObj.sType.toLowerCase() == "serveruse")) || ((resObj.sType.toLowerCase() == "clientuse"))))
                {
                    if (((((("sFile" in resObj)) && ((resObj.sFile.length > 0)))) && (!((main.Game.world.getClass(resObj.sFile) == null)))))
                    {
                        sIcon = resObj.sFile;
                    }
                    else
                    {
                        sIcon = resObj.sIcon;
                    }
                }
                else
                {
                    if ((((((resObj.sIcon == null)) || ((resObj.sIcon == "")))) || ((resObj.sIcon == "none"))))
                    {
                        if (resObj.sLink.toLowerCase() != "none")
                        {
                            sIcon = "iidesign";
                        }
                        else
                        {
                            sIcon = "iibag";
                        }
                    }
                    else
                    {
                        sIcon = resObj.sIcon;
                    }
                }
            }
            try
            {
                AssetClass = (main.Game.world.getClass(sIcon) as Class);
                mcIcon = this.icon.addChild(new (AssetClass)());
            }
            catch(e:Error)
            {
                AssetClass = (main.Game.world.getClass("iibag") as Class);
                mcIcon = this.icon.addChild(new (AssetClass)());
            }
            if(isOwned(resObj.bHouse, resObj.ItemID)){
                var check:detailedCheck = new detailedCheck();
                check.width = mcIcon.width;
                check.height = mcIcon.height;
                check.x = 0;
                check.y = 0;
                mcIcon.addChild(check);
            }
            mcIcon.scaleX = (mcIcon.scaleY = 0.4);

            this.addEventListener(MouseEvent.ROLL_OVER, onHighlight, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, onDeHighlight, false, 0, true);
            this.addEventListener(MouseEvent.CLICK, onShiftClick, false, 0, true);

            this.btYes.addEventListener(MouseEvent.CLICK, onBtYes, false, 0, true);
            this.btNo.addEventListener(MouseEvent.CLICK, onBtNo, false, 0, true);
            this.btPreview.addEventListener(MouseEvent.CLICK, onBtPreview, false, 0, true);
        }

        function onShiftClick(e:MouseEvent):void{
            if(e.shiftKey){
                var modalClass:Class;
                var modal:*;
                var modalO:*;
                modalClass= main.Game.world.getClass("ModalMC");
                modal = new modalClass();
                modalO = {};
                modalO.strBody = "Are you sure you want to add " + itemObj.sName + " to the item blacklist?";
                modalO.callback = onModifyBlacklist;
                modalO.params = {
                    "sName": itemObj.sName
                };
                modalO.glow = "red,medium";
                modalO.btns = "dual";
                main._stage.addChild(modal);
                modal.init(modalO);
            }
        }

        function onModifyBlacklist(o:Object):void{
            if(o.accept){
                var t_dataProvider:DataProvider = new DataProvider(main.sharedObject.data.listBlack);
                t_dataProvider.addItem( { label: o.sName.toUpperCase(), value: o.sName.toUpperCase()} );
                main.sharedObject.data.listBlack = t_dataProvider.toArray();
                main.sharedObject.flush();
                optionHandler.blackListed = main.sharedObject.data.listBlack;
                optionHandler.dropmenutwoMC.onBtNo(itemObj);
            }
            main._stage.focus = null;
        }

        function isOwned(isHouse:Boolean, itemID:*):Boolean{
			for each(var item:* in ((isHouse) ? main.Game.world.myAvatar.houseitems : main.Game.world.myAvatar.items)){
				if(item.ItemID == itemID)
					return true;
			}
			if(main.Game.world.bankinfo.isItemInBank(itemID))
				return true;
			return false;
		}

        function updateFormat(size:int):void{
            format.size = size;
            this.txtDrop.setTextFormat( format );
        }

        function onBtYes(e:MouseEvent):void{
            for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                if(!main.Game.ui.dropStack.getChildAt(i))
                    continue;
                if(itemObj.iStk == 1){
                    if(main.Game.ui.dropStack.getChildAt(i).cnt && main.Game.ui.dropStack.getChildAt(i).cnt.strName)
                        if(main.Game.ui.dropStack.getChildAt(i).cnt.strName.text == itemObj.sName){
                            main.Game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            break;
                        }
                }else{
                    var nutext:String = main.Game.ui.dropStack.getChildAt(i).cnt.strName.text;
                    nutext = nutext.substring(0, nutext.lastIndexOf(" x"));
                    if(nutext == itemObj.sName){
                        main.Game.ui.dropStack.getChildAt(i).cnt.ybtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                        break;
                    }
                }
            }
            main._stage.focus = null;
        }

        function onBtNo(e:MouseEvent):void{
            optionHandler.dropmenutwoMC.onBtNo(itemObj);
            main._stage.focus = null;
        }

        function onBtPreview(e:MouseEvent):void{
            if(main.Game.ui.getChildByName("renderPreview"))
                main.Game.ui.removeChild(main.Game.ui.getChildByName("renderPreview"));
            var dRenderObj:* = new dRender(itemObj);
            dRenderObj.name = "renderPreview";
            main.Game.ui.addChild(dRenderObj);
            main._stage.focus = null;
        }

        function onHighlight(e:MouseEvent):void{
            this.gotoAndStop("hover");
            this.btYes.visible = true;
            this.btNo.visible = true;
            this.btPreview.visible = true;
        }

        function onDeHighlight(e:MouseEvent):void{
            this.gotoAndStop("idle");
            this.btYes.visible = false;
            this.btNo.visible = false;
            this.btPreview.visible = false;
        }
    }
}
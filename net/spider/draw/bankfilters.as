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

    public class bankfilters extends MovieClip {
        public function bankfilters(){
            
            this.chkAC.checkmark.visible = false;
            this.chkGold.checkmark.visible = false;
            this.chkLegend.checkmark.visible = false;
            this.chkFree.checkmark.visible = false;
            this.chkRarity.checkmark.visible = false;

            this.chkAC.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkGold.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkLegend.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkFree.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);
            this.chkRarity.addEventListener(MouseEvent.CLICK, onChkChange, false, 0, true);

            this.btnFilter.addEventListener(MouseEvent.CLICK, onBtnFilter, false, 0, true);
        }

        public function onChkChange(e:MouseEvent):void{
            e.currentTarget.checkmark.visible = !e.currentTarget.checkmark.visible;
            switch(e.currentTarget.name){
                case "chkAC":
                    if(e.currentTarget.checkmark.visible)
                        chkGold.checkmark.visible = false;
                    break;
                case "chkGold":
                    if(e.currentTarget.checkmark.visible)
                        chkAC.checkmark.visible = false;
                    break;
                case "chkLegend":
                    if(e.currentTarget.checkmark.visible)
                        chkFree.checkmark.visible = false;
                    break;
                case "chkFree":
                    if(e.currentTarget.checkmark.visible)
                        chkLegend.checkmark.visible = false;
                    break;
            }
        }

        public function onFilter(bank:*, index:int, arr:Array):Boolean {
            var filter_result:Boolean = false;
            if(chkAC.checkmark.visible){
                filter_result = (bank.bCoins == 1);
                if(chkLegend.checkmark.visible)
                    filter_result = filter_result && (bank.bUpg == 1);
                if(chkFree.checkmark.visible)
                    filter_result = filter_result && (bank.bUpg == 0);
            }else if(chkGold.checkmark.visible){
                filter_result = (bank.bCoins == 0);
                if(chkLegend.checkmark.visible)
                    filter_result = filter_result && (bank.bUpg == 1);
                if(chkFree.checkmark.visible)
                    filter_result = filter_result && (bank.bUpg == 0);
            }else{
                if(chkLegend.checkmark.visible)
                    filter_result = (bank.bUpg == 1);
                if(chkFree.checkmark.visible)
                    filter_result = (bank.bUpg == 0);
            }
            if(chkRarity.checkmark.visible)
                filter_result = (bank.iRty == 30);
            if(!chkAC.checkmark.visible && !chkGold.checkmark.visible && !chkLegend.checkmark.visible && !chkFree.checkmark.visible
                && !chkRarity.checkmark.visible)
                filter_result = true;
            return filter_result;
        }

        public function onBtnFilter(e:MouseEvent):void{
            var mcFocus:MovieClip = MovieClip(main.Game.ui.mcPopup.getChildByName("mcBank")).bankPanel.frames[1].mc;
            mcFocus.fOpen({
                    "fData":{
                        "list":main.Game.world.bankinfo.items.filter(onFilter),
                        "itemsB":main.Game.world.bankinfo.items,
                        "itemsI":main.Game.world.myAvatar.items,
                        "objData":main.Game.world.myAvatar.objData,
                        "isBank":true
                    },
                    "r":{
                        "x":21,
                        "y":46,
                        "w":265,
                        "h":304
                    },
                    "sMode":"bank",
                    "refreshTabs":true
                });
        }
    }
}
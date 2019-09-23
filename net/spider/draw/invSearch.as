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

    public class invSearch extends MovieClip {
        public function invSearch(){
            this.visible = false;
            this.txtSearch.addEventListener(Event.CHANGE, onTextFormat);
            this.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN, onInvSearch);
            this.addEventListener(Event.ENTER_FRAME, onFrame);
        }

        public function onFrame(e:Event):void{
            if(!main.Game)
                return;
            if(!main.Game.ui)
                return;
            this.visible = flags.isInventory();
        }

        public function onFilter(inventory:*, index:int, arr:Array):Boolean {
            return (inventory.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1);
        }

        public function onTextFormat(e:*):void{
            this.txtSearch.textField.setTextFormat(new TextFormat("Arial", 16, 0xFFFFFF), this.txtSearch.textField.caretIndex-1);
        }

		function onInvSearch(e:KeyboardEvent):void{
			if((e.charCode == 13) && main.Game.ui.mcPopup.getChildByName("mcInventory")){
                MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).fOpen({
                    fData:{
                        itemsInv:(this.txtSearch.text != "") ? main.Game.world.myAvatar.items.filter(onFilter) : main.Game.world.myAvatar.items,
                        objData:main.Game.world.myAvatar.objData
                    },
                    r:{
                        x:0,
                        y:0,
                        w:stage.stageWidth,
                        h:stage.stageHeight
                    },
                    sMode:"inventory"
                });
			}
		}
    }
}
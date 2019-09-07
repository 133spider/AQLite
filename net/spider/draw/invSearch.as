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
            this.btnSearch.addEventListener(MouseEvent.CLICK, onInvSearch);
            this.addEventListener(Event.ENTER_FRAME, onFrame);
        }

        public function onFrame(e:Event):void{
            if(!main.Game)
                return;
            if(!main.Game.ui)
                return;
            this.visible = flags.isInventory();
        }

        var toSend:Array;
		function onInvSearch(e:MouseEvent):void{
			if(main.Game.ui.mcPopup.getChildByName("mcInventory")){
                toSend = new Array();
				for each(var t:* in main.Game.world.myAvatar.items){
					if(t.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1){
						toSend.push(t);
                    }
				}
                MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).fOpen({
                    fData:{
                        itemsInv:toSend,
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
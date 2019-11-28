package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.TextFormat;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.handlers.optionHandler;
	
	public class drops extends MovieClip{

		static var incr:int = 0;
        public static function onExtensionResponseHandler(e:*):void{
			if(!optionHandler.draggable)
				return;
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "dropItem":
							if(main.Game.ui.dropStack.numChildren <= 2)
								return;
							var itemA:MovieClip;
							var itemB:MovieClip;
							var i:*;

							i = (main.Game.ui.dropStack.numChildren - 2);
							while (i > -1)
							{
								itemA = (main.Game.ui.dropStack.getChildAt(i) as MovieClip);
								itemB = (main.Game.ui.dropStack.getChildAt((i + 1)) as MovieClip);
								(itemA.fY = (itemA.y = (itemB.fY - (itemB.fHeight + 8))));
								itemB.fX = (main.Game.ui.dropStack.getChildAt(0) as MovieClip).fX;
								itemB.x = (main.Game.ui.dropStack.getChildAt(0) as MovieClip).x;
								i--;
							}
                        	break;
                    }
                }
        }

        public static function onFrameUpdate():void{
			if(!optionHandler.draggable || !main.Game.sfc.isConnected || (main.Game.ui.dropStack.numChildren < 1))
				return;
			for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
				try{
					var mcDrop:* = (main.Game.ui.dropStack.getChildAt(i) as MovieClip);
					if(!mcDrop.hasEventListener(MouseEvent.MOUSE_DOWN)){
						mcDrop.addEventListener(MouseEvent.MOUSE_DOWN, drops.startDrag, false, 0, true);
						mcDrop.addEventListener(MouseEvent.MOUSE_UP, drops.stopDrag, false, 0, true);
					}
				}catch(exception){
					trace("Error handling drops: " + exception);
				}
			}
		}

		private static function startDrag(e:MouseEvent):void{
			e.currentTarget.startDrag(); 
		}
		
		private static function stopDrag(e:MouseEvent):void{
			e.currentTarget.stopDrag(); 
		}
	}
	
}

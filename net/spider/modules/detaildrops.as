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

	
	public class detaildrops extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var dropTimer:Timer;

		public static function onCreate():void{
			detaildrops.events.addEventListener(ClientEvent.onToggle, onToggle);
			main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
		}

		public static function onToggle(e:Event):void{
			if(options.detaildrop){
				dropTimer = new Timer(100);
				dropTimer.addEventListener(TimerEvent.TIMER, onTimer);
				dropTimer.start();
				itemArchive = new Array();
			}else{
				dropTimer.reset();
				dropTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				itemArchive = null;
			}
		}

		public static var itemArchive:Array;
        public static function onExtensionResponseHandler(e:*):void{
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "dropItem":
							for (dID in resObj.items)
                                if(itemArchive[dID] == null)
                                    itemArchive.push(main.Game.copyObj(resObj.items[dID]));
                        	break;
                    }
                }
        }

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(main.Game.ui.dropStack.numChildren < 1)
				return;
			for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
				try{
					var mcDrop:* = (main.Game.ui.dropStack.getChildAt(i) as MovieClip);
					if(getQualifiedClassName(mcDrop) != "DFrame2MC")
						continue;
					if(!mcDrop.cnt.bg.getChildByName("flag")){
						var sName:String = mcDrop.cnt.strName.text.replace(/ x[0-9]/g, "");
						for each(var item:* in itemArchive){
							if(item.sName == sName){
								if(item.bCoins == 1){
									var ac:mcCoin = new mcCoin();
									ac.width = 25;
									ac.height = 30;
									ac.x = mcDrop.cnt.bg.width - 25; //w: 80
									mcDrop.cnt.bg.addChild(ac);
								}
								if(item.bUpg){
									var txtFormat:TextFormat = mcDrop.cnt.strName.defaultTextFormat;
									txtFormat.color = 0xFCC749;
									mcDrop.cnt.strName.setTextFormat(txtFormat);
								}
								var flag:mcCoin = new mcCoin();
								flag.visible = false;
								flag.name = "flag";
								mcDrop.cnt.bg.addChild(flag);
							}
						}
					}
				}catch(exception){
					trace("Error handling drops: " + exception);
				}
			}
		}
	}
	
}

package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.*;
    import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.handlers.flags;
	
	public class boosts extends MovieClip {
		
        public static var events:EventDispatcher = new EventDispatcher();
        private static var boostTimer:Timer;

		public function boosts() {
			this.visible = false;
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			//this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
            boosts.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

        public function onToggle(e:Event):void{
            //this.visible = options.boost;
            if(options.boost){
				//main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
				//activeBoosts = new Object();
				boostTimer = new Timer(0);
				boostTimer.addEventListener(TimerEvent.TIMER, onTimer);
				boostTimer.start();
			}else{
				boostTimer.reset();
				boostTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				//main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
				//activeBoosts = null;
			}
        }

		public var activeBoosts:Object;
		public function onExtensionResponseHandler(e:*):void{
			var avt:*;
			var tLeaf:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "equipItem":
							avt = main.Game.world.getAvatarByUserID(resObj.uid);
							tLeaf = main.Game.world.getUoLeafById(resObj.uid);
							if(avt != null)
							{
								if(!avt.isMyAvatar)
									return;
								if(avt.pMC != null && avt.objData != null)
								{
									if("sMeta" in resObj)
									{
										if(resObj.sMeta.indexOf(":") == -1)
											return;
										if(resObj.sMeta.indexOf("anim") != -1 && resObj.sMeta.indexOf("proj") != -1)
											return;
										var objMetas:Array = resObj.sMeta.split(",");
										for each(var resMeta:* in objMetas){
											if(resMeta.split(":")[0] == "cp" || resMeta.split(":")[0] == "exp" 
											|| resMeta.split(":")[0] == "gold" || resMeta.split(":")[0] == "rep"){
												activeBoosts[resMeta.split(":")[0]] = resMeta.split(":")[1];
											}else{
												for(var elmt:* in activeBoosts){
													if(elmt == "cp")
														continue;
													if(elmt == "exp")
														continue;
													if(elmt == "gold")
														continue;
													if(elmt == "rep")
														continue;
													activeBoosts[elmt] = null;
												}
												activeBoosts[resMeta.split(":")[0]] = resMeta.split(":")[1];
											}
										}
									}
								}
							}
                            break;
                    }
                }
        }

		private var runOnce:Boolean = false;
        public function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return;
			if(!main.Game.world.myAvatar)
				return;
			if(!main.Game.world.myAvatar.items)
				return;
			if(!flags.isInventory() && runOnce)
				runOnce = false;
			if(flags.isInventory() && !runOnce){
				for each(var pItem:* in main.Game.world.myAvatar.items){
					if(!pItem.oldDesc)
						pItem.oldDesc = pItem.sDesc;
					var nuDesc:String = "";
					if(pItem.sMeta)
						nuDesc = "sMeta: " + pItem.sMeta + "\n";
					pItem.sDesc = nuDesc + "Stacks: " + pItem.iQty + "/" + pItem.iStk + "\n" + pItem.oldDesc;
					nuDesc = null;
				}
				runOnce = true;
			}
			/**if(!main.Game.world.myAvatar.objData.eqp)
				return;
			if(activeBoosts.length < 1)
				return;
			this.activesTxt.text = "";
			for each(var pItem:* in main.Game.world.myAvatar.objData.eqp){
				if((pItem.sMeta as String) == null)
					continue;
				var eqpMetas:Array = (pItem.sMeta as String).split(",");
				for each(var metaItems:String in eqpMetas){
					if(metaItems.indexOf(":") == -1)
						continue;
					if(metaItems.indexOf("anim") != -1 && metaItems.indexOf("proj") != -1)
						continue;
					if(isActive(metaItems.split(":")[0], metaItems.split(":")[1]))
						this.activesTxt.appendText("[" + metaItems.split(":")[0] + "]: x" + metaItems.split(":")[1] + "\n");
				}
			}**/
			//resizeMe();
		}

		public function isActive(active:String, value:String):Boolean{
			for(var typ:* in activeBoosts){
				if(typ == active){
					if(value != activeBoosts[typ])
						return false;
				}
			}
			return true;
		}

		var size:*;
		public function resizeMe():void{
			size = this.activesTxt.textWidth + 8;
			if(size > 150){
				this.head.width = size;
				this.titleBar.width = size - 27;
				this.activesTxt.width = size;
				this.back.width = size;
			}else{
				this.head.width = 150;
				this.titleBar.width = 150 - 27;
				this.activesTxt.width = 150;
				this.back.width = 150;
			}
			size = this.activesTxt.textHeight + 5;
			this.activesTxt.height = size;
			this.back.height = size;
		}
		
		private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
		}
	}
	
}

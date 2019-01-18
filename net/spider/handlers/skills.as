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
	
	public class skills extends MovieClip {
		
        public static var events:EventDispatcher = new EventDispatcher();
        private static var skillTimer:Timer;

		public function skills() {
			this.visible = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
            skills.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

        public function onToggle(e:Event):void{
            this.visible = options.skill;
            if(options.skill){
				main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
				auras = new Object();
				skillTimer = new Timer(0);
				skillTimer.addEventListener(TimerEvent.TIMER, onTimer);
				skillTimer.start();
			}else{
				skillTimer.reset();
				skillTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				main.Game.sfc.removeEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
				auras = null;
			}
        }

		public var auras:Object;
		public function onExtensionResponseHandler(e:*):void{
			var aura:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "ct":
							if (resObj.a == null)
								return;
							for each(var i:* in resObj.a){
								if(i.tInf.indexOf("p") == -1)
									continue;
								if(i.auras){
									for each(var j:* in i.auras){
										if (i.cmd.indexOf("+") > -1)
										{
											if(!auras.hasOwnProperty(j.nam)){
												auras[j.nam] = 1;
											}else{
												auras[j.nam] += 1;
												for each(var a:* in main.Game.world.myAvatar.dataLeaf.auras){
													if(a.nam == j.nam){
														a.ts = j.ts;
														break;
													}
												}
											}
										}else if(i.cmd.indexOf("-") > -1) {
											auras[j.nam] = null;
										}
									}
								}else{
									if (i.cmd.indexOf("+") > -1)
									{
										if(!auras.hasOwnProperty(i.aura.nam)){
											auras[i.aura.nam] = 1;
										}else{
											auras[i.aura.nam] += 1;
											for each(var b:* in main.Game.world.myAvatar.dataLeaf.auras){
												if(b.nam == i.aura.nam){
													b.ts = i.aura.ts;
													break;
												}
											}
										}
									}else if(i.cmd.indexOf("-") > -1) {
										auras[i.aura.nam] = null;
									}
								}
							}
                            break;
                    }
                }
        }

		var dateObj:*;
        public function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.actions.passive){
				auras = new Object();
				return;
			}
			//world.actions.active = []; world.actions.passive = [];
			dateObj = new Date();
            this.activesTxt.text = "";
            for each(var a:* in main.Game.world.myAvatar.dataLeaf.auras){
                this.activesTxt.appendText("[" + a.nam + "]: (" + (!auras.hasOwnProperty(a.nam) ? "NaN" : auras[a.nam].toString()) + " stacks) (" + (a.dur - Math.floor((dateObj.getTime() - a.ts)/1000)).toString() + "s)\n");
            }
			resizeMe();
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

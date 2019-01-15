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
	
	public class passives extends MovieClip {
		
        public static var events:EventDispatcher = new EventDispatcher();
        private static var passivesTimer:Timer;

		public function passives() {
			this.visible = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
            passives.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

        public function onToggle(e:Event):void{
            this.visible = options.passive;
            if(options.passive){
				passivesTimer = new Timer(0);
				passivesTimer.addEventListener(TimerEvent.TIMER, onTimer);
				passivesTimer.start();
			}else{
				passivesTimer.reset();
				passivesTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				lastClass = "";
			}
        }

		var lastClass:String;
        public function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.actions.passive)
				return;
			if(lastClass == main.Game.world.myAvatar.objData.strClassName)
				return;
			this.passivesTxt.text = "";
			for each(var p:* in main.Game.world.actions.passive){
                this.passivesTxt.appendText("[" + p.nam + "]: " + p.desc + "\n");
            }
			lastClass = main.Game.world.myAvatar.objData.strClassName;
			resizeMe();
		}

		var size:*;
		public function resizeMe():void{
			size = this.passivesTxt.textWidth + 8;
			if(size > 150){
				this.head.width = size;
				this.titleBar.width = size - 27;
				this.passivesTxt.width = size;
				this.back.width = size;
			}else{
				this.head.width = 150;
				this.titleBar.width = 150 - 27;
				this.passivesTxt.width = 150;
				this.back.width = 150;
			}
			size = this.passivesTxt.textHeight + 5;
			this.passivesTxt.height = size;
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

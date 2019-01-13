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
				skillTimer = new Timer(0);
				skillTimer.addEventListener(TimerEvent.TIMER, onTimer);
				skillTimer.start();
			}else{
				skillTimer.reset();
				skillTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
        }

        public function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.actions.passive)
				return;
			//world.actions.active = []; world.actions.passive = [];
            this.activesTxt.text = "";
            for each(var a:* in main.Game.world.myAvatar.dataLeaf.auras){
                this.activesTxt.appendText("[" + a.nam + "]: " + a.dur + " seconds\n");
            }

            if(main.Game.world.actions.passive[0])
                this.passive1.text = main.Game.world.actions.passive[0].desc;
            else
                this.passive1.text = "NaN";
            if(main.Game.world.actions.passive[1])
                this.passive2.text = main.Game.world.actions.passive[1].desc;
            else
                this.passive2.text = "NaN";
            if(main.Game.world.actions.passive[2])
                this.passive3.text = main.Game.world.actions.passive[2].desc;
            else
                this.passive3.text = "NaN";
		}
		
		private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
		}
	}
	
}

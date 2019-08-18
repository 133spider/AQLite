package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.*;
    import net.spider.main;
    import net.spider.modules.*;
    import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class passives extends MovieClip {
		
        public static var events:EventDispatcher = new EventDispatcher();
        private static var passivesTimer:Timer;

		public function passives() {
			this.visible = false;
            passives.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

        public function onToggle(e:Event):void{
			lastClass = "";
            if(optionHandler.passive){
				passivesTimer = new Timer(0);
				passivesTimer.addEventListener(TimerEvent.TIMER, onTimer);
				passivesTimer.start();
			}else{
				passivesTimer.reset();
				passivesTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
        }

		var lastClass:String;
        public function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected || !main.Game.world.actions.passive)
				return;

			if(main.Game.ui.mcPopup.currentLabel == "Charpanel" && lastClass == main.Game.world.myAvatar.objData.strClassName)
				if(main.Game.ui.mcPopup.mcCharpanel.cnt2.abilities.getChildByName("a10"))
					return;
				
			if(main.Game.ui.mcPopup.currentLabel != "Charpanel")
				return;

			if(main.Game.world.actions.passive.length != 3)
				return;

			if(!main.Game.ui.mcPopup.mcCharpanel || !main.Game.ui.mcPopup.mcCharpanel.cnt2
				|| !main.Game.ui.mcPopup.mcCharpanel.cnt2.abilities)
				return;
			trace("DRAW");
			
			var mcPanel:* = main.Game.ui.mcPopup.mcCharpanel.cnt2.abilities;
			mcPanel.x = 20;
			var ico:Class = main.Game.world.getClass("ib2");
			var rnk:* = new ico();
			rnk.height = mcPanel.a4.height;
			rnk.width = mcPanel.a4.width;
			rnk.x = mcPanel.a4.x + mcPanel.a4.width + 5;
			rnk.y = mcPanel.a4.y;
			var o:* = main.Game.world.actions.passive[2];
			rnk.tQty.visible = false;
			main.Game.updateIcons([rnk], o.icon.split(","), null);
			if (!o.isOK)
			{
				rnk.alpha = 0.33;
			};
			rnk.actObj = o;
			rnk.addEventListener(MouseEvent.MOUSE_OVER, main.Game.actIconOver, false, 0, true);
			rnk.addEventListener(MouseEvent.MOUSE_OUT, main.Game.actIconOut, false, 0, true);
			rnk.name = "a10";
			mcPanel.addChild(rnk);

			var uoData:* = main.Game.world.myAvatar.objData;
			var g:* = mcPanel.bg.graphics;
            g.lineStyle(0, 0, 0);
            var ox:* = 0;
            var boxFill:* = 0x666666;
            var textCol:* = "#FFFFFF";

			ox = (5 * 51);
			boxFill = 0x666666;
			textCol = "#FFFFFF";
			if (uoData.iRank < (10))
			{
				boxFill = 0x242424;
				textCol = "#999999";
				g.beginFill(boxFill);
				g.moveTo(ox, 19);
				g.lineTo((ox + 50), 19);
				g.lineTo((ox + 50), 127);
				g.lineTo(ox, 127);
				g.lineTo(ox, 19);
				g.endFill();
			};
			g.beginFill(boxFill);
			g.moveTo(ox, 0);
			g.lineTo((ox + 50), 0);
			g.lineTo((ox + 50), 18);
			g.lineTo(ox, 18);
			g.lineTo(ox, 0);
			g.endFill();
			g.beginFill(boxFill);
			g.moveTo(ox, 128);
			g.lineTo((ox + 50), 128);
			g.lineTo((ox + 50), 132);
			g.lineTo(ox, 132);
			g.lineTo(ox, 128);
			g.endFill();

			var rnkDisplay:* = new TextField();
			rnkDisplay.type = TextFieldType.DYNAMIC;
			rnkDisplay.mouseEnabled = false;
			var txtFormat:TextFormat = mcPanel.tRank5.defaultTextFormat;
			txtFormat.font = "Arial";
			txtFormat.size = 11;
			rnkDisplay.setTextFormat(txtFormat);
			rnkDisplay.height = mcPanel.tRank5.height;
			rnkDisplay.width = 45;
			rnkDisplay.x = mcPanel.tRank5.x + mcPanel.tRank5.width + 9;
			rnkDisplay.y = mcPanel.tRank5.y - 1;
			rnkDisplay.htmlText = (("<font face='Arial' size='11' color='" + textCol) + "'><b>") + "Rank 10</b></font>";
			mcPanel.addChild(rnkDisplay)
			lastClass = main.Game.world.myAvatar.objData.strClassName;
		}
	}
	
}

package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.TextFormat;
	import flash.geom.Point;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class chatfilter extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			chatfilter.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		static var firstRuntimePassed:Boolean = false;
		public static function onToggle(e:Event):void{
			if(!optionHandler.chatFilter){
				if(!main.Game.ui)
					return;
				clog = main.Game.ui.mcInterface.t1;
				for(var i:uint = 0; i < clog.numChildren; i++){
					if(!clog.getChildAt(i).getChildAt(0).ti)
						continue;
					if(!clog.getChildAt(i).getChildAt(0).visible)
						clog.getChildAt(i).getChildAt(0).visible = true;
				}
				if(optionHandler.filterChecks["chkRedSkills"] && firstRuntimePassed){
					main._stage.addEventListener(KeyboardEvent.KEY_UP, main.Game.key_actBar, false, 0, true);
					for(var k:* = 1; k < 6; k++){
						main.Game.ui.mcInterface.actBar.getChildByName("i" + k).removeEventListener(MouseEvent.CLICK, actIconClick);
						main.Game.ui.mcInterface.actBar.getChildByName("i" + k).addEventListener(MouseEvent.CLICK, main.Game.actIconClick, false, 0, true);
					}
				}
			}else{
				if(optionHandler.filterChecks["chkRedSkills"] && firstRuntimePassed){
					main._stage.removeEventListener(KeyboardEvent.KEY_UP, main.Game.key_actBar);
					main._stage.addEventListener(KeyboardEvent.KEY_UP, new_actBar, false, 0, true);
					for(var j:* = 1; j < 6; j++){
						main.Game.ui.mcInterface.actBar.getChildByName("i" + j).addEventListener(MouseEvent.CLICK, actIconClick, false, 0, true);
						main.Game.ui.mcInterface.actBar.getChildByName("i" + j).removeEventListener(MouseEvent.CLICK, main.Game.actIconClick);
					}
				}
			}
			if(!firstRuntimePassed)
				firstRuntimePassed = true;
		}

		public static function new_actBar(param1:KeyboardEvent) : *
		{
			if(main._stage.focus == null || main._stage.focus != null && !("text" in main._stage.focus))
			{
				switch(param1.charCode)
				{
					case 49:
						main.Game.world.approachTarget();
						break;
					default:
						if(param1.charCode > 49 && param1.charCode < 55)
						{
							var toRound:Number = 1 - Math.min(Math.max(main.Game.world.myAvatar.dataLeaf.sta.$tha,-1),0.5);
							var curTime:Number = new Date().getTime();
							var skillObj:* = main.Game.world.actions.active[param1.charCode - 49];
							if(skillObj != null)
							{
								if(skillObj.isOK)
								{
									if(!(curTime - main.Game.world.GCDTS < main.Game.world.GCD))
									{
										if(curTime - skillObj.ts >= Math.round(skillObj.cd * toRound))
										{
											main.Game.world.testAction(skillObj);
											skillObj = null;
										}
									}
								}
							}
						}
				}
			}
		}

		public static function actIconClick(param1:MouseEvent) : *
		{
			var skillObj:* = MovieClip(param1.currentTarget).actObj;
			if(skillObj.auto != null && skillObj.auto == true)
			{
				main.Game.world.approachTarget();
			}
			else
			{
				var toRound:Number = 1 - Math.min(Math.max(main.Game.world.myAvatar.dataLeaf.sta.$tha,-1),0.5);
				var curTime:Number = new Date().getTime();
				if(skillObj != null)
				{
					if(skillObj.isOK)
					{
						if(!(curTime - main.Game.world.GCDTS < main.Game.world.GCD))
						{
							if(curTime - skillObj.ts >= Math.round(skillObj.cd * toRound))
							{
								main.Game.world.testAction(skillObj);
								skillObj = null;
							}
						}
					}
				}
			}
		}

		private static var clog:*;
		private static var txt:*;
        public static function onFrameUpdate():void{
			if(!optionHandler.chatFilter || !main.Game.sfc.isConnected)
				return;
			//main.Game.ui.mcInterface.t1.visible = false;
			clog = main.Game.ui.mcInterface.t1;
			for(var i:uint = 0; i < clog.numChildren; i++){
				if(!clog.getChildAt(i).getChildAt(0).ti)
					continue;
				txt = clog.getChildAt(i).getChildAt(0).ti.htmlText;
				switch(true){
					case (optionHandler.filterChecks["chkRed"] && txt.indexOf('COLOR="#FF0000"') > -1):
					case (optionHandler.filterChecks["chkBlue"] && txt.indexOf('COLOR="#00FFFF"') > -1):
							if(txt.indexOf("Server shutdown") > -1)
									continue;
							clog.getChildAt(i).getChildAt(0).visible = false;
						break;
				}
			}
		}
	}
	
}

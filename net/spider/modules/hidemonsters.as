package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class hidemonsters extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();

		public static function onCreate():void{
			hidemonsters.events.addEventListener(ClientEvent.onToggle, onToggle);
		}

		public static function onToggle(e:Event):void{
			if(!optionHandler.hideM){
                if(!main.Game.world.strFrame)
				    return;
                var mons:Array = main.Game.world.getMonstersByCell(main.Game.world.strFrame);
                for each(var _m in mons){
                    if(!_m)
                        continue;
                    if(!_m.pMC)
					    continue;
                    if(!_m.pMC.getChildAt(1))
                        continue;
                    if(!_m.pMC.getChildAt(1).visible)
                        _m.pMC.getChildAt(1).visible = true;
                }
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.hideM || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;
			if(!main.Game.world.strFrame)
				return;
            var mons:Array = main.Game.world.getMonstersByCell(main.Game.world.strFrame);
			for each(var _m in mons){
				if(!_m)
					continue;
				if(!_m.pMC)
					continue;
                if(!_m.pMC.getChildAt(1))
					continue;
                if(_m.pMC.getChildAt(1).visible){
                    trace("shadowed");
                    _m.pMC.getChildAt(1).visible = false;
                    _m.pMC.shadow.addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
                    _m.pMC.shadow.mouseEnabled = true;
                    _m.pMC.shadow.buttonMode = true;
                }
			}
		}

		public static function onClickHandler(e:MouseEvent):void{
            var tAvt:*;
            tAvt = e.currentTarget.parent.pAV;
            if (e.shiftKey)
            {
                main.Game.world.onWalkClick();
            }
            else
            {
                if (!e.ctrlKey)
                {
                    if (((((((!((tAvt == main.Game.world.myAvatar))) && (main.Game.world.bPvP))) && (!((tAvt.dataLeaf.pvpTeam == main.Game.world.myAvatar.dataLeaf.pvpTeam))))) && ((tAvt == main.Game.world.myAvatar.target))))
                    {
                        main.Game.world.approachTarget();
                    }
                    else
                    {
                        if (tAvt != main.Game.world.myAvatar.target)
                        {
                            main.Game.world.setTarget(tAvt);
                        }
                    }
                }
            }
        }
	}
	
}

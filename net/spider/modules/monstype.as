package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class monstype extends MovieClip{

		public static function onToggle():void{
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
			if(!optionHandler.mType || !main.Game.sfc.isConnected || !main.Game.world.myAvatar)
				return;

			if(main.Game.world.strFrame){
				var mons:Array = main.Game.world.getMonstersByCell(main.Game.world.strFrame);
				for each(var _m in mons){
					if(!_m)
						continue;
					if(!_m.pMC)
						continue;
					if(!_m.pMC.getChildAt(1))
						continue;
					if(!_m.pMC.pname.getChildByName("ptype")){
						var t_type:TextField = new TextField();
						var t_format:TextFormat = new TextFormat();
						t_format = _m.pMC.pname.ti.getTextFormat();
						t_format.align = TextFormatAlign.CENTER;
						t_format.font = "Purista";
						t_type.defaultTextFormat = t_format;
						t_type.name = "ptype";
						t_type.width = _m.pMC.pname.ti.width;
						t_type.y = 9;
						t_type.text = "< " + _m.pMC.pAV.objData.sRace + " >";
						_m.pMC.pname.addChild(t_type);
					}
				}
			}

			if(main.Game.world.myAvatar.target == null)
				return;
			if(main.Game.world.myAvatar.target.npcType == "monster"){
				if(main.Game.ui.mcPortraitTarget.strClass.text != main.Game.world.myAvatar.target.objData.sRace)
					main.Game.ui.mcPortraitTarget.strClass.text = main.Game.world.myAvatar.target.objData.sRace;
			}
		}
	}
	
}

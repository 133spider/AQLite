package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	import net.spider.handlers.optionHandler;
	
	public class cskillanim extends MovieClip{

		private static var stage;
		public static function onToggle():void{
			stage = main._stage;
			if(optionHandler.cSkillAnim){
				if(main.Game.ui){
					if(!eventInitialized){
						for(var i:* = 2; i < 6; i++){
							if(main.Game.ui.mcInterface.actBar.getChildByName("i" + i))
								main.Game.ui.mcInterface.actBar.getChildByName("i" + i).addEventListener(MouseEvent.CLICK, actIconClick, false, 0, true);
						}
						eventInitialized = true;
					}
				}
			}else{
				if(eventInitialized){
					for(var j:* = 2; j < 6; j++){
						if(main.Game.ui.mcInterface.actBar.getChildByName("i" + j))
							main.Game.ui.mcInterface.actBar.getChildByName("i" + j).removeEventListener(MouseEvent.CLICK, actIconClick);
					}
					eventInitialized = false;
				}
			}
		}

		public static function onTimerUpdate():void{
			if(!optionHandler.cSkillAnim || !main.Game.sfc.isConnected)
				return;
			main.Game.world.myAvatar.pMC.spFX.strl = "";
		}

		public static function handleSkills(param1:String):void{
			switch(param1){ //p = fireballs, thrown stuff, w = regular, d = summon monster
				case "i2":
					//main.Game.world.myAvatar.pMC.spFX.strl = "sp_doomfire";
					//main.Game.world.myAvatar.pMC.spFX.fx = "w";
					switch(main.Game.world.myAvatar.objData.strClassName){
						case "Dragonlord":
							main.Game.world.myAvatar.pMC.spFX.strl2 = "dragonstrike";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "h";
							break;
						/**default: 
							main.Game.world.myAvatar.pMC.spFX.strl = "shadowstrike";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "h";
							break;**/
					}
					break;
				case "i3":
					//main.Game.world.myAvatar.pMC.spFX.strl = "sp_deathcurse";
					//main.Game.world.myAvatar.pMC.spFX.fx = "p";
					switch(main.Game.world.myAvatar.objData.strClassName){
						case "Dragonlord":
							main.Game.world.myAvatar.pMC.spFX.strl2 = "firedragon";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "h";
							break;
						/**default: 
							main.Game.world.myAvatar.pMC.spFX.strl = "onyxcombustion";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "h";
							break;**/
					}
					break;
				case "i4":
					//main.Game.world.myAvatar.pMC.spFX.strl = "sp_doomdragon";
					//main.Game.world.myAvatar.pMC.spFX.fx = "d";
					switch(main.Game.world.myAvatar.objData.strClassName){
						case "Dragonlord":
							main.Game.world.myAvatar.pMC.spFX.strl2 = "healthdragon";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "s";
							break;
						/**default: 
							main.Game.world.myAvatar.pMC.spFX.strl = "bloodball";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "s";
							break;**/
					}
					break;
				case "i5":
					//main.Game.world.myAvatar.pMC.spFX.strl = "sp_mentalkill";
					//main.Game.world.myAvatar.pMC.spFX.fx = "w";
					switch(main.Game.world.myAvatar.objData.strClassName){
						case "Dragonlord":
							main.Game.world.myAvatar.pMC.spFX.strl2 = "darknessdragon";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "s";
							break;
						/**default: 
							main.Game.world.myAvatar.pMC.spFX.strl = "toxicabomination";
							main.Game.world.myAvatar.pMC.spFX.fx = "w";
							main.Game.world.myAvatar.pMC.spFX.tgt = "s";
							break;**/
					}
					break;
			}
			castSpellFX(main.Game.world.myAvatar.pMC.pAV, main.Game.world.myAvatar.pMC.spFX, null, main.Game.world.myAvatar.pMC.spellDur);
		}

		public static function actIconClick(e:*):void{
			if(main.Game.world.myAvatar.objData.strClassName == "Void Highlord")
				return;
			if(main.Game.world.myAvatar.objData.strClassName != "Dragonlord")
				return;
			handleSkills(e.target.name);
		}

		public static function onKey(param1:KeyboardEvent) : *
		{
			if(!optionHandler.cSkillAnim)
				return;
			if(main.Game.world.myAvatar.objData.strClassName == "Void Highlord")
				return;
			if(main.Game.world.myAvatar.objData.strClassName != "Dragonlord")
				return;
			if(stage.focus == null || stage.focus != null && !("text" in stage.focus))
			{
				if(param1.charCode > 49 && param1.charCode < 55)
				{
					switch(param1.charCode){
						case 50:
							if(main.Game.world.actions.active[1].isOK)
								handleSkills("i2");
							break;
						case 51:
							if(main.Game.world.actions.active[2].isOK)
								handleSkills("i3");
							break;
						case 52:
							if(main.Game.world.actions.active[3].isOK)
								handleSkills("i4");
							break;
						case 53:
							if(main.Game.world.actions.active[4].isOK)
								handleSkills("i5");
							break;
					}
				}
			}
		}

		public static var eventInitialized:Boolean = false;
        public static function onExtensionResponseHandler(e:*):void{
			if(!optionHandler.cSkillAnim)
				return;
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
						case "sAct":
							if(!eventInitialized){
								for(var i:* = 2; i < 6; i++){
									if(main.Game.ui.mcInterface.actBar.getChildByName("i" + i))
										main.Game.ui.mcInterface.actBar.getChildByName("i" + i).addEventListener(MouseEvent.CLICK, actIconClick, false, 0, true);
								}
								eventInitialized = true;
							}
							break;
						case "ct":
							if(resObj.anims != null && main.Game.world.myAvatar.objData.strClassName == "Void Highlord")
							{
								for each(var o:* in resObj.anims)
								{
									switch(o.strl){
										case "sp_voidhaa":
											main.Game.world.myAvatar.pMC.spFX.strl2 = "vhaa";
											break;
										case "sp_voidha1":
											main.Game.world.myAvatar.pMC.spFX.strl2 = "vha1";
											break;
										case "sp_voidha2":
											main.Game.world.myAvatar.pMC.spFX.strl2 = "vha2";
											break;
										case "sp_voidha3":
											main.Game.world.myAvatar.pMC.spFX.strl2 = "vha3";
											break;
										case "sp_voidha4":
											main.Game.world.myAvatar.pMC.spFX.strl2 = "vha4";
											break;
										default: return;
									}
									castSpellFX(main.Game.world.myAvatar.pMC.pAV, main.Game.world.myAvatar.pMC.spFX, null, main.Game.world.myAvatar.pMC.spellDur);
									break;
								}
							}
							break;
                    }
                }
        }

		public static function castSpellFX(param1:*, param2:*, param3:*, param4:int = 0) : *
		{
			var rootClass:* = main.Game;
			var _loc5_:* = null;
			var _loc6_:Class = null;
			var _loc7_:* = undefined;
			var _loc8_:Array = null;
			var _loc9_:int = 0;
			if(param2.strl2 != null && param2.strl2 != "" && param2.avts != null)
			{
				_loc8_ = [];
				_loc9_ = 0;
				if(param2.fx == "c")
				{
				if(param2.strl2 == "lit1")
				{
					_loc8_.push(param1.pMC.mcChar);
					_loc9_ = 0;
					while(_loc9_ < param2.avts.length)
					{
						_loc5_ = param2.avts[_loc9_];
						if(_loc5_ != null && _loc5_.pMC != null && _loc5_.pMC.mcChar != null)
						{
							_loc8_.push(_loc5_.pMC.mcChar);
						}
						_loc9_++;
					}
					if(_loc8_.length > 1)
					{
						_loc6_ = getDefinitionByName("net.spider.anim." + param2.strl2) as Class; //sp_C1
						if(_loc6_ != null)
						{
							_loc7_ = new _loc6_();
							_loc7_.mouseEnabled = false;
							_loc7_.mouseChildren = false;
							_loc7_.visible = true;
							_loc7_.world = rootClass.world;
							_loc7_.strl2 = param2.strl2;
							rootClass.drawChainsLinear(_loc8_,33,MovieClip(main.Game.world.CHARS.addChild(_loc7_)));
						}
					}
				}
				}
				else if(param2.fx == "f")
				{
				_loc8_.push(param1.pMC.mcChar);
				_loc5_ = param2.avts[0];
				if(_loc5_ != null && _loc5_.pMC != null && _loc5_.pMC.mcChar != null)
				{
					_loc8_.push(_loc5_.pMC.mcChar);
				}
				if(_loc8_.length > 1)
				{
					_loc7_ = new MovieClip();
					_loc7_.mouseEnabled = false;
					_loc7_.mouseChildren = false;
					_loc7_.visible = true;
					_loc7_.world = rootClass.world;
					_loc7_.strl2 = param2.strl2;
					rootClass.drawFunnel(_loc8_,MovieClip(main.Game.world.CHARS.addChild(_loc7_)));
				}
				}
				else
				{
				_loc9_ = 0;
				while(_loc9_ < param2.avts.length)
				{
					_loc5_ = param2.avts[_loc9_];
					//_loc6_ = pLoaderD.getDefinition(param2.strl) as Class;
					_loc6_ = getDefinitionByName("net.spider.anim." + param2.strl2) as Class;
					if(_loc6_ != null)
					{
						_loc7_ = new _loc6_();
						_loc7_.spellDur = param4;
						if(param3 != null)
						{
							_loc7_.transform = param3.transform;
						}
						main.Game.world.CHARS.addChild(_loc7_);
						_loc7_.mouseEnabled = false;
						_loc7_.mouseChildren = false;
						_loc7_.visible = true;
						_loc7_.world = rootClass.world;
						_loc7_.strl2 = param2.strl2;
						if(param2.tgt == 's'){
							_loc7_.tMC = param1.pMC;
						}else{
							if(main.Game.world.myAvatar.target){
								_loc7_.tMC = _loc5_.pMC;
							}else{
								_loc7_.tMC = param1.pMC;
							}
						}
						if(main.Game.world.myAvatar.target){
							_loc7_.trueTarget = main.Game.world.myAvatar.target.pMC;
							_loc7_.trueSelf = param1.pMC;
						}
						switch(param2.fx)
						{
							case "p":
								_loc7_.x = param1.pMC.x;
								_loc7_.y = param1.pMC.y - param1.pMC.mcChar.height * 0.5;
								_loc7_.dir = _loc5_.pMC.x - param1.pMC.x >= 0?1:-1;
								break;
							case "w":
								_loc7_.x = _loc7_.tMC.x;
								_loc7_.y = _loc7_.tMC.y + 3;
								if(param1 != null)
								{
									if(_loc5_.pMC.x < param1.pMC.x)
									{
										MovieClip(_loc7_).scaleX *= -1;
									}
								}
								break;
							case "d":
								_loc7_.x = param1.pMC.x;
								_loc7_.y = param1.pMC.y;
								if(param1 != null)
								{
									if(_loc5_.pMC.x < param1.pMC.x)
									{
										MovieClip(_loc7_).scaleX *= -1;
									}
								}
								break;
						}
						//main.Game.world.CHARS.addChild(_loc7_);
					}
					else
					{
						trace();
						trace("*>*>*> Could not load class " + param2.strl2);
						trace();
					}
					_loc9_++;
				}
				}
			}
		}
	}
	
}

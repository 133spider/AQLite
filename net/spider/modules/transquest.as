package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.draw.cMenu;
	import net.spider.handlers.optionHandler;
	
	public class transquest extends MovieClip{

		public static function onToggle():void{
            if(main.Game.ui){
                if (main.Game.ui.ModalStack.numChildren > 0)
                {
                    var q_frame:* = main.Game.ui.ModalStack.getChildAt(0);
                    if(flash.utils.getQualifiedClassName(q_frame) == "QFrameMC")
                        if(!optionHandler.bTransQuest && q_frame.alpha != 1){
                            q_frame.alpha = 1;
                            main.Game.ui.ModalStack.mouseEnabled = main.Game.ui.ModalStack.mouseChildren = true;
                        }
                }
            }
		}

        public static function onFrameUpdate():void{
            if(!optionHandler.bTransQuest || !main.Game || !main.Game.ui || !main.Game.ui.ModalStack)
                return;
            if (main.Game.ui.ModalStack.numChildren > 0)
			{
				var q_frame:* = main.Game.ui.ModalStack.getChildAt(0);
				if(flash.utils.getQualifiedClassName(q_frame) == "QFrameMC")
					if(main.Game.world.myAvatar.dataLeaf.intState > 1 && q_frame.alpha > .5){
						q_frame.alpha -= .05;
						main.Game.ui.ModalStack.mouseEnabled = main.Game.ui.ModalStack.mouseChildren = false;
					}else if(main.Game.world.myAvatar.dataLeaf.intState == 1 && q_frame.alpha != 1){
						q_frame.alpha = 1;
						main.Game.ui.ModalStack.mouseEnabled = main.Game.ui.ModalStack.mouseChildren = true;
					}
			}
        }

	}
	
}

package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import fl.controls.*;
	import flash.geom.*;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.optionHandler;
	
	public class bitmap extends MovieClip{

		public static function onToggle():void{
			if(!optionHandler.bitmapP){
				for(var playerMC:* in main.Game.world.avatars){
					if((!main.Game.world.avatars[playerMC].dataLeaf) 
						&& (main.Game.world.avatars[playerMC].dataLeaf.strFrame != main.Game.world.strFrame))
						continue;
					if(!main.Game.world.avatars[playerMC].pMC)
						continue;
					if(main.Game.world.avatars[playerMC].isMyAvatar)
						continue;
					if(!main.Game.world.avatars[playerMC].pMC.getChildByName("avtCache"))
						continue;
					if(main.Game.world.avatars[playerMC].dataLeaf.intState > 0){
						try{
							main.Game.world.avatars[playerMC].pMC.removeChild(main.Game.world.avatars[playerMC].pMC.getChildByName("avtCache"));
							main.Game.world.avatars[playerMC].pMC.mcChar.visible = true;
							main.Game.world.avatars[playerMC].pMC.mouseEnabled = true;
						}catch(exception){}
					}
				}
			}
		}

        public static function onFrameUpdate():void{
			if(!optionHandler.bitmapP || !main.Game.sfc.isConnected || !main.Game.world.avatars)
				return;
			for(var playerMC:* in main.Game.world.avatars){
				if((!main.Game.world.avatars[playerMC].dataLeaf) 
					&& (main.Game.world.avatars[playerMC].dataLeaf.strFrame != main.Game.world.strFrame))
					continue;
				if(!main.Game.world.avatars[playerMC].pMC)
					continue;
				if(main.Game.world.avatars[playerMC].isMyAvatar)
					continue;
				if(!main.Game.world.avatars[playerMC].pMC.isLoaded)
					continue;
				if(main.Game.world.avatars[playerMC].pMC.getChildByName("avtCache"))
					continue;
				if(main.Game.world.avatars[playerMC].dataLeaf.intState > 0){
					try{
						main.Game.world.avatars[playerMC].pMC.mcChar.gotoAndStop("Idle");
						trace("Rasterizing - " + main.Game.world.avatars[playerMC].pMC.pname.ti.text);
						rasterize(main.Game.world.avatars[playerMC].pMC.mcChar);
					}catch(exception){}
				}
			}
		}

		public static function createAvtBM(avt:DisplayObject):Bitmap {
			var avtMatrix:Matrix = avt.transform.concatenatedMatrix;
			var avtGBounds:Rectangle = avt.getBounds(avt.stage);
			var avtGPos:Point = avt.localToGlobal(new Point());
			var avtOffset:Point = new Point(avtGPos.x - avtGBounds.left, avtGPos.y - avtGBounds.top);

			var scaledSprite:Sprite = new Sprite();
			avt.stage.addChild(scaledSprite);
			var scaledMatrix:Matrix = scaledSprite.transform.concatenatedMatrix;
			avt.stage.removeChild(scaledSprite);

			avtMatrix.tx = avtOffset.x * scaledMatrix.a;
			avtMatrix.ty = avtOffset.y * scaledMatrix.d;

			var avtBMD:BitmapData = new BitmapData(avtGBounds.width * scaledMatrix.a, avtGBounds.height * scaledMatrix.d, true, 0x00000000);
			avtBMD.draw(avt, avtMatrix);
			var avtBM:Bitmap = new Bitmap(avtBMD);

			avtBM.x -= avtOffset.x;
			avtBM.y -= avtOffset.y;
			avtBM.scaleX = 1 / scaledMatrix.a;
    		avtBM.scaleY = 1 / scaledMatrix.d;

			return avtBM;
		}

		public static function rasterize(avtDisplay:MovieClip):void{
			var render:* = avtDisplay.parent.addChildAt(createAvtBM(avtDisplay), (avtDisplay.parent.getChildIndex(avtDisplay) + 1));
			render.name = "avtCache";
			render.parent.mouseEnabled = false;
			avtDisplay.visible = false;
        }

		public static function movieClipStopAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if((container.getChildAt(i) as MovieClip).name == "pvpFlag")
						continue;
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
					try{
						(container.getChildAt(i) as MovieClip).gotoAndStop(0);
						movieClipStopAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }

		public static function movieClipPlayAll(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					if((container.getChildAt(i) as MovieClip).name == "pvpFlag")
						continue;
					if(getQualifiedClassName(container.getChildAt(i) as MovieClip).indexOf("Display") > -1)
						continue;
					try{
						(container.getChildAt(i) as MovieClip).gotoAndPlay(0);
						movieClipPlayAll(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
        }
	}
	
}

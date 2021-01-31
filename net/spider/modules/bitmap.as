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
	import net.spider.draw.mcAC;
	
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
				if(main.Game.world.loaderQueue.length > 0)
					continue;
				if(!main.Game.world.avatars[playerMC].pMC.isLoaded)
					continue;
				if(main.Game.world.avatars[playerMC].pMC.getChildByName("avtCache"))
					continue;
				if(main.Game.world.avatars[playerMC].dataLeaf.intState > 0){
					try{
						//main.Game.world.avatars[playerMC].pMC.mcChar.gotoAndStop("Idle");
						trace("Rasterizing - " + main.Game.world.avatars[playerMC].pMC.pname.ti.text);
						rasterize(main.Game.world.avatars[playerMC].pMC.mcChar);
					}catch(exception){}
				}
			}
		}
		//TODO: Re-rasterize on scale change

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
			avtBMD.draw(avt, avtMatrix, null, null, null, true);
			var avtBM:Bitmap = new Bitmap(avtBMD);
			avtBM.smoothing = true;

			avtBM.x -= avtOffset.x;
			avtBM.y -= avtOffset.y;
			avtBM.scaleX = 1 / scaledMatrix.a;
    		avtBM.scaleY = 1 / scaledMatrix.d;

			return avtBM;
		}

		//rasterizes individual children of one movieclip, should allow for animations to still work
		public static function rasterizePart(avt:DisplayObject):Bitmap {
			var avtMatrix:Matrix = avt.transform.matrix;
			var avtGBounds:Rectangle = avt.getBounds(avt.parent);
			var avtOffset:Point = new Point(avt.x - avtGBounds.left, avt.y - avtGBounds.top);

			avtMatrix.tx = avtOffset.x;
			avtMatrix.ty = avtOffset.y;

			var avtBMD:BitmapData = new BitmapData(avtGBounds.width, avtGBounds.height, true, 0x00000000);
			avtBMD.draw(avt, avtMatrix, avt.parent.transform.colorTransform, null, null, true);
			var avtBM:Bitmap = new Bitmap(avtBMD);
			avtBM.smoothing = true;

			avtBM.x -= avtOffset.x;
			avtBM.y -= avtOffset.y;

			return avtBM;
			/**var rect:Rectangle = avt.getBounds(avt.parent); //get the bounds of the item relative to it's parent
			var bmpData:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			//you have to pass a matrix so you only draw the part of the parent that contains the child.
			bmpData.draw(avt.parent, new Matrix(1,0,0,1,-rect.x,-rect.y));
			return new Bitmap(bmpData);**/
		}

		public static function rasterize(avtDisplay:MovieClip):void{
			//var render:* = avtDisplay.parent.addChildAt(createAvtBM(avtDisplay), (avtDisplay.parent.getChildIndex(avtDisplay) + 1));
			//render.name = "avtCache";
			//render.parent.mouseEnabled = false;
			//render.cacheAsBitmap = true;
			var movieClip:mcAC = new mcAC();
			movieClip.name = "avtCache";
			avtDisplay.parent.addChild(movieClip);
			movieClip.visible = false;
			movieClipRasterizeInner(avtDisplay);
			//avtDisplay.visible = false;
        }

		public static function movieClipRasterizeInner(container:MovieClip):void {
            for (var i:uint = 0; i < container.numChildren; i++)
                if (container.getChildAt(i) is MovieClip) {
					try{
						var toRasterize:MovieClip = (container.getChildAt(i) as MovieClip);
						if(toRasterize.visible == false)
							continue;
						toRasterize.getChildAt(0).visible = false;
						var rasterized:* = toRasterize.addChildAt(rasterizePart(toRasterize.getChildAt(0)), 0);
						movieClipRasterizeInner(container.getChildAt(i) as MovieClip);
					}catch(exception){}
                }
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

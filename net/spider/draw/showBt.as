package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
	
	public class showBt extends MovieClip {

		public function showBt() {
			bt_update();
			this.txtShow.mouseEnabled = false;
			this.btShow.addEventListener(MouseEvent.CLICK, onShowBt, false, 0, true);
		}

		public function bt_update():void{
			var sES:String = (main.Game.ui.mcPopup.getChildByName("mcInventory").iSel).sES;
			if(sES == "ar")
				sES = "co";
			if(main.Game.world.myAvatar.objData.eqp[sES] && (main.Game.ui.mcPopup.getChildByName("mcInventory").iSel).sFile == 
				main.Game.world.myAvatar.objData.eqp[sES].sFile)
				this.txtShow.text = "Hide";
			else
				this.txtShow.text = "Show";
		}

		var item:*;
		public function onShowBt(e:MouseEvent):void{
			item = main.Game.ui.mcPopup.getChildByName("mcInventory").iSel;
            var sES:String = item.sES;
			if(sES == "ar")
				sES = "co";
			if(this.txtShow.text == "Show"){
				if(!main.Game.world.myAvatar.objData.eqp[sES]){
					main.Game.world.myAvatar.objData.eqp[sES] = {};
					main.Game.world.myAvatar.objData.eqp[sES].wasCreatedShowable = true;
				}
				if(!main.Game.world.myAvatar.objData.eqp[sES].isShowable){
					main.Game.world.myAvatar.objData.eqp[sES].isShowable = true;
					if(!main.Game.world.myAvatar.objData.eqp[sES].isPreview){
						if("sType" in item){
							main.Game.world.myAvatar.objData.eqp[sES].oldType = main.Game.world.myAvatar.objData.eqp[sES].sType;
						}
						main.Game.world.myAvatar.objData.eqp[sES].oldFile = main.Game.world.myAvatar.objData.eqp[sES].sFile;
						main.Game.world.myAvatar.objData.eqp[sES].oldLink = main.Game.world.myAvatar.objData.eqp[sES].sLink;
					}
				}
				if("sType" in item){
					main.Game.world.myAvatar.objData.eqp[sES].sType = item.sType;
				}
				main.Game.world.myAvatar.objData.eqp[sES].sFile = (item.sFile == "undefined" ? "" : item.sFile);
				main.Game.world.myAvatar.objData.eqp[sES].sLink = item.sLink;
				main.Game.world.myAvatar.loadMovieAtES(sES, item.sFile, item.sLink);
			}else{
				if(main.Game.world.myAvatar.objData.eqp[sES].wasCreatedShowable){
					delete main.Game.world.myAvatar.objData.eqp[sES];
					main.Game.world.myAvatar.unloadMovieAtES(sES);
				}else{
					if(main.Game.world.myAvatar.objData.eqp[sES].isShowable){
						main.Game.world.myAvatar.objData.eqp[sES].sType = main.Game.world.myAvatar.objData.eqp[sES].oldType;
						main.Game.world.myAvatar.objData.eqp[sES].sFile = main.Game.world.myAvatar.objData.eqp[sES].oldFile;
						main.Game.world.myAvatar.objData.eqp[sES].sLink = main.Game.world.myAvatar.objData.eqp[sES].oldLink;
						main.Game.world.myAvatar.loadMovieAtES(sES, 
							main.Game.world.myAvatar.objData.eqp[sES].oldFile, 
							main.Game.world.myAvatar.objData.eqp[sES].oldLink);
						main.Game.world.myAvatar.objData.eqp[sES].isShowable = null;
					}
				}
			}
			main.Game.ui.mcPopup.getChildByName("mcInventory").previewPanel.visible = false;
		}
	}
	
}

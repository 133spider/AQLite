package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.handlers.flags;
    import net.spider.handlers.ClientEvent;
    import net.spider.draw.colorSets;
    import net.spider.draw.btGender;
    import net.spider.avatar.AvatarMC;
    import com.adobe.utils.StringUtil;
	
	
	public class btGender extends SimpleButton {
		
		
		public function btGender() {
            t_tip = new ToolTipMC();
            main._stage.addChild(t_tip);
			this.addEventListener(MouseEvent.CLICK, onBtGender, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OVER, onHover, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}

		private var t_tip:ToolTipMC;
		public function onHover(e:MouseEvent):void{
            t_tip.openWith({str:"Switch Gender Preview"});
        }

		public function onOut(e:MouseEvent):void{
			t_tip.close();
		}

		public function onClick(e:MouseEvent):void{
            if(flash.utils.getQualifiedClassName(e.target).indexOf("LPFElementListItemItem") > -1){
                var mcFocus:String;
                var focusMovie:MovieClip;
                if(main.Game.ui.mcPopup.currentLabel == "Shop"){
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.getChildAt(3);
                    mcFocus = "mcShop";
                }else if(main.Game.ui.mcPopup.currentLabel == "MergeShop"){
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.getChildAt(3);
                    mcFocus = "mcShop";
                }else{
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
                    mcFocus = "mcInventory";
                }
                focusMovie.mcPreview.visible = true;
                focusMovie.removeChild(focusMovie.getChildByName("genderPreview"));
                MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).removeEventListener(MouseEvent.CLICK, onClick);
            }
        }

        public function onBtGender(e:Event):void{
            var mcFocus:String;
            var focusMovie:MovieClip;

            switch(main.Game.ui.mcPopup.currentLabel){
                case "Shop":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).previewPanel.getChildAt(3);
                    mcFocus = "mcShop";
                    break;
                case "MergeShop":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcShop")).mergePanel.getChildAt(3);
                    mcFocus = "mcShop";
                    break;
                case "Inventory":
                    focusMovie = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
                    mcFocus = "mcInventory";
                    break;
            }

            focusMovie.mcPreview.visible = !focusMovie.mcPreview.visible;

            if(!focusMovie.getChildByName("genderPreview")){
                var genderPreview:* = focusMovie.addChild(new AvatarMC());
                genderPreview.name = "genderPreview";
            }

            focusMovie.getChildByName("genderPreview").visible = !focusMovie.mcPreview.visible;
            if(focusMovie.getChildByName("genderPreview").visible){
                var objChar:Object = new Object();
                objChar.strGender = (main.Game.world.myAvatar.objData.strGender == "M") ? "F" : "M";
                (focusMovie.getChildByName("genderPreview") as AvatarMC).pAV.objData = objChar;
                focusMovie.getChildByName("genderPreview").x = focusMovie.mcPreview.x;
                focusMovie.getChildByName("genderPreview").y = focusMovie.mcPreview.y;
                (focusMovie.getChildByName("genderPreview") as AvatarMC).loadArmor(main.Game.ui.mcPopup.getChildByName(mcFocus).iSel.sFile, main.Game.ui.mcPopup.getChildByName(mcFocus).iSel.sLink);
                focusMovie.setChildIndex(focusMovie.getChildByName("genderPreview"), (focusMovie.getChildIndex(focusMovie.tInfo)-1));
            }
            if(!MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).hasEventListener(MouseEvent.CLICK))
                MovieClip(main.Game.ui.mcPopup.getChildByName(mcFocus)).addEventListener(MouseEvent.CLICK, onClick);
        }
	}
	
}

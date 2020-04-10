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
	
	public class btSetMount extends SimpleButton {
		
		
		public function btSetMount() {
			t_tip = new ToolTipMC();
            main._stage.addChild(t_tip);
			this.addEventListener(MouseEvent.CLICK, onSetMount, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onHover, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}

		private var t_tip:ToolTipMC;
		public function onHover(e:MouseEvent):void{
            t_tip.openWith({str:"Set Primary Mount"});
        }

		public function onOut(e:MouseEvent):void{
			t_tip.close();
		}

		public function warning():void{
            var modalClass:Class = main.Game.world.getClass("ModalMC");
            var modal:* = new modalClass();
            var modalO:* = {};
            modalO.strBody = "This armor is not a mount!";
            modalO.params = {};
            modalO.glow = "red,medium";
            modalO.btns = "mono";
            main._stage.addChild(modal);
            modal.init(modalO);
        }

		//save by username:mount
		public function onSetMount(e:MouseEvent):void{
			if(!main.Game.ui.mcPopup.getChildByName("mcInventory"))
				return;
			if(!main.Game.ui.mcPopup.getChildByName("mcInventory").iSel)
				return;
			var mcFocus:MovieClip = MovieClip(main.Game.ui.mcPopup.getChildByName("mcInventory")).previewPanel.getChildAt(3);
			if(!mcFocus.mcPreview)
				return;
			if(!mcFocus.mcPreview.getChildByName("previewMCB"))
				return;
			var mnt:MovieClip = (mcFocus).mcPreview.getChildByName("previewMCB").mcChar.robe.getChildAt(0);
			for(var i = 0; i < mnt.currentLabels.length; i++){
				trace(mnt.currentLabels[i].name);
				if(mnt.currentLabels[i].name.indexOf("Walk") == 0){
					var t_obj:Object = (main.sharedObject.data.savedMounts) ? main.sharedObject.data.savedMounts : [];
					t_obj[main.Game.world.myAvatar.objData.strUsername.toLowerCase()] = main.Game.ui.mcPopup.getChildByName("mcInventory").iSel.ItemID;
					main.sharedObject.data.savedMounts = t_obj;
					main.sharedObject.flush();
					return;
				}
			}
			warning();
		}
	}
	
}

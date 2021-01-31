package net.spider.draw{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	import net.spider.main;
	import net.spider.modules.dynamicoptions;

	public class listOptionsItem extends MovieClip {
		
		public var txtName:TextField;
		
		public var txtStatus:TextField;
		
		public var btnLeft:MovieClip;
		
		public var btnRight:MovieClip;
		
		public var bEnabled:Boolean;

		public var sDesc:String;
		public function listOptionsItem(bEnabled:Boolean, sDesc:String) {
			txtStatus.text = (bEnabled ? "ON" : " OFF");
			this.bEnabled = bEnabled;
			this.sDesc = sDesc;

			btnLeft.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
			btnRight.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
		}

		public function onToggle(e:MouseEvent):void{
			var modalClass:Class;
			var modal:*;
			var modalO:*;
			switch(txtName.text){
				case "Custom Drops UI":
					if(optionHandler.sbpcDrops){
						modalClass= main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "You can only have one version of the Custom Drops UI enabled! Disable the other one before enabling this one!";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
						return;
					}
					break;
				case "SBP's Custom Drops UI":
					if(optionHandler.cDrops){
						modalClass = main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "You can only have one version of the Custom Drops UI enabled! Disable the other one before enabling this one!";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
						return;
					}
					break;
				case "Disable Map Animations":
					if(!optionHandler.disMapAnim){
						modalClass = main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "Enabling \"Disable Map Animations\" will cause map buttons (e.g. Quest Heads) to NOT work!";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
					}
					break;
				default: break;
			}
			bEnabled = !bEnabled;
			txtStatus.text = (bEnabled ? "ON" : " OFF");
			optionHandler.cmd(txtName.text);
		}
	}
	
}

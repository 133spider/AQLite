package net.spider.draw{
	
	import flash.display.MovieClip;
	import fl.controls.*;
	import flash.text.*;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	import net.spider.main;
	
	public class listOptionsItemExtra extends MovieClip {
		
		public var txtName:TextField;
		
		public var chkActive:MovieClip;
		
		public var sDesc:String;
		public function listOptionsItemExtra(bEnabled:Boolean, sDesc:String) {
			this.sDesc = sDesc;
			chkActive.checkmark.visible = bEnabled;
			chkActive.addEventListener(MouseEvent.CLICK, onToggle, false, 0, true);
		}

		public function onToggle(e:MouseEvent):void{
			var modalClass:Class;
			var modal:*;
			var modalO:*;
			switch(txtName.text){
				case "Disable Skill Warning Messages":
					if(optionHandler.chatFilter){
						modalClass= main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "Chat Filter must be disabled before changing this setting!";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
						return;
					}
					break;
				case "Force Basic Rider Animation":
					if(optionHandler.filterChecks["chkHorseRiderAnim"]){
						modalClass= main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "You can only have one of these enabled at a time.";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
						return;
					}
					break;
				case "Force Horse Rider Animation":
					if(optionHandler.filterChecks["chkBasicRiderAnim"]){
						modalClass= main.Game.world.getClass("ModalMC");
						modal = new modalClass();
						modalO = {};
						modalO.strBody = "You can only have one of these enabled at a time.";
						modalO.params = {};
						modalO.glow = "red,medium";
						modalO.btns = "mono";
						main._stage.addChild(modal);
						modal.init(modalO);
						return;
					}
					break;
				default: break;
			}
			chkActive.checkmark.visible = !chkActive.checkmark.visible;
			optionHandler.cmd(txtName.text);
		}
	}
	
}

package net.spider.draw{
	
	import flash.display.MovieClip;
	import fl.controls.*;
	import flash.text.*;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	
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
			chkActive.checkmark.visible = !chkActive.checkmark.visible;
			optionHandler.cmd(txtName.text);
		}
	}
	
}

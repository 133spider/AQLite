package net.spider.draw{
	
	import flash.display.MovieClip;
	import fl.controls.*;
	import flash.text.*;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	import net.spider.main;
	import flash.display.SimpleButton;
	
	public class listOptionsItemExtraBtn extends MovieClip {
		
		public var txtName:TextField;
		
		public var btnActive:SimpleButton;
		
		public var sDesc:String;
		public function listOptionsItemExtraBtn(sDesc:String) {
			this.sDesc = sDesc;
			btnActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
		}

		public function onActive(e:MouseEvent):void{
			optionHandler.cmd(txtName.text);
		}
	}
	
}

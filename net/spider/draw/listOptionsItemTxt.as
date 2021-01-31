package net.spider.draw{
	
	import flash.display.MovieClip;
	import fl.controls.*;
	import flash.text.*;
	import flash.display.SimpleButton;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	import net.spider.draw.charPage;
	import net.spider.main;
	
	public class listOptionsItemTxt extends MovieClip {
		
		public var txtName:TextField;
		public var btnActive:SimpleButton;
		public var sDesc:String;
		public function listOptionsItemTxt(sDesc:String) {
			this.sDesc = sDesc;
			btnActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
			txtSearch.addEventListener(Event.CHANGE, onSearch, false, 0, true);
		}

		public function onSearch(e:Event):void{
			this.txtSearch.textField.setTextFormat(new TextFormat("Arial", 16, 0xFFFFFF), this.txtSearch.textField.caretIndex-1);
		}

		public function onActive(e:MouseEvent):void{
			if(txtSearch.text.length < 1)
				return;
			var mcCharPage:charPage = new charPage(txtSearch.text);
			main.Game.ui.addChild(mcCharPage);
		}
	}
	
}

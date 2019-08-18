package  net.spider.draw{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import net.spider.handlers.optionHandler;
	import flash.events.*;
	import net.spider.draw.ToolTipMC;
	
	public class listOptionsItemBtn extends MovieClip {
		
		public var txtName:TextField;
		
		public var btnActive:SimpleButton;
		
		public var sDesc:String;
		public function listOptionsItemBtn(sDesc:String) {
			this.sDesc = sDesc;
			btnActive.addEventListener(MouseEvent.CLICK, onActive, false, 0, true);
		}

		public function onActive(e:MouseEvent):void{
			optionHandler.cmd(txtName.text);
		}
	}
	
}

package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
	import net.spider.handlers.optionHandler;
	
	public class btColorPicker extends MovieClip {
		
		
		public function btColorPicker() {
			this.btnColor.addEventListener(MouseEvent.CLICK, onBtnColor, false, 0, true);
		}

		public function onBtnColor(e:MouseEvent):void{
			if(!optionHandler.colorPickerMC){
				optionHandler.colorPickerMC = new colorPicker();
				main._stage.addChild(optionHandler.colorPickerMC);
			}else{
				optionHandler.colorPickerMC.visible = !optionHandler.colorPickerMC.visible;
			}
		}

		public function destroy():void{
			this.btnColor.removeEventListener(MouseEvent.CLICK, onBtnColor);
		}
	}
	
}

package net.spider.draw {
	
	import flash.display.MovieClip;
	import flash.system.*;
	import flash.events.*;
	
	public class memoryusage extends MovieClip {
		
		
		public function memoryusage() {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onHold, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(e:*):void{
			this.txtMemory.text = "Not In Use: " + System.freeMemory/1000000 + "mb\nIn Use: " + System.totalMemory/1000000 + "mb\nAllocated: " + System.privateMemory/1000000 + "mb";
		}

		public function cleanup():void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onHold);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onHold(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function onMouseRelease(e:MouseEvent):void{
			this.stopDrag();
		}
	}
	
}

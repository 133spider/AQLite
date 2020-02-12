package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.filters.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.avatar.*;
    import net.spider.handlers.*;
    import fl.events.*;
    import fl.data.*;
	
	public class travelMenu extends MovieClip {
		
		
		public function travelMenu() {
			this.txtExpand.mouseEnabled = false;

			this.frame.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
			this.frame.addEventListener(MouseEvent.MOUSE_UP, onStopDrag, false, 0, true);

			this.btnAdd.addEventListener(MouseEvent.CLICK, onBtnAdd, false, 0, true);
			this.btnDel.addEventListener(MouseEvent.CLICK, onBtnDel, false, 0, true);
			this.btnUp.addEventListener(MouseEvent.CLICK, onBtnUp, false, 0, true);
			this.btnDown.addEventListener(MouseEvent.CLICK, onBtnDown, false, 0, true);

			this.btnTravel.addEventListener(MouseEvent.CLICK, onBtnTravel, false, 0, true);

			this.btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpand, false, 0, true);
			this.btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);
		}

		public function onBtnExpand(e:MouseEvent):void{
			this.txtExpand.text = (this.txtExpand.text == "+") ? "-" : "+";
			var i:int = 0;
			if(this.frame.visible){
				while(i < this.numChildren){
					if(!(this.getChildAt(i).name == "btnExpand") && !(this.getChildAt(i).name == "txtExpand"))
						this.getChildAt(i).visible = false;
					i++;
				}
			}else{
				while(i < this.numChildren){
					this.getChildAt(i).visible = true;
					i++;
				}
			}
		}

		public function onDrag(e:MouseEvent):void{
			this.startDrag();
		}

		public function onStopDrag(e:MouseEvent):void{
			this.stopDrag();
		}

		public function onBtnClose(e:MouseEvent):void{
			this.visible = false;
		}

		public function onBtnAdd(e:MouseEvent):void{
			if(this.txtTravel.text != "")
				this.listTravel.dataProvider.addItem( { label: this.txtTravel.text } );
			this.txtTravel.text = "";
		}

		public function onBtnDel(e:MouseEvent):void{
			if(this.listTravel.selectedIndex > -1)
				this.listTravel.dataProvider.removeItemAt(this.listTravel.selectedIndex);
			this.listTravel.selectedIndex = 0;
		}

		private var lObj:Object;
		private var lIndex:int;
		public function onBtnUp(e:MouseEvent):void{
			if(this.listTravel.selectedIndex == -1)
				return;
			if(this.listTravel.selectedIndex != -1 && this.listTravel.selectedIndex != 0){
				lObj = this.listTravel.selectedItem;
				lIndex = this.listTravel.selectedIndex - 1;
				this.listTravel.dataProvider.removeItem(this.listTravel.selectedItem);
				this.listTravel.dataProvider.addItemAt(lObj, lIndex);
				this.listTravel.selectedIndex = lIndex;
			}
		}

		public function onBtnDown(e:MouseEvent):void{
			if(this.listTravel.selectedIndex == -1)
				return;
			if(this.listTravel.selectedIndex < (this.listTravel.length - 1)){
				lObj = this.listTravel.selectedItem;
				lIndex = this.listTravel.selectedIndex + 1;
				this.listTravel.dataProvider.removeItem(this.listTravel.selectedItem);
				this.listTravel.dataProvider.addItemAt(lObj, lIndex);
				this.listTravel.selectedIndex = lIndex;
			}
		}

		public function onBtnTravel(e:MouseEvent):void{
			if(this.listTravel.length < 1)
				return;
			if(this.listTravel.selectedIndex == -1)
				this.listTravel.selectedIndex = 0;
			main.Game.world.gotoTown(this.listTravel.selectedItem.label, "Enter", "Spawn");
			this.listTravel.selectedIndex++;
			if(this.listTravel.selectedIndex > this.listTravel.length-1)
				this.listTravel.selectedIndex = 0;
		}
	}
	
}

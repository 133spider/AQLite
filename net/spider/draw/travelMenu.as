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
	import com.adobe.utils.StringUtil;
	
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
			this.btnSave.addEventListener(MouseEvent.CLICK, onBtnSave, false, 0, true);
			this.btnClear.addEventListener(MouseEvent.CLICK, onBtnClear, false, 0, true);
			
			this.btnDelSave.addEventListener(MouseEvent.CLICK, onBtnDelSave, false, 0, true);
			this.cbSave.addEventListener(MouseEvent.CLICK, onCbSaveChange, false, 0, true);
			this.cbSave.addEventListener(Event.CHANGE, onCbSaveChange, false, 0, true);

			this.btnExpand.addEventListener(MouseEvent.CLICK, onBtnExpand, false, 0, true);
			this.btnClose.addEventListener(MouseEvent.CLICK, onBtnClose, false, 0, true);

			if(main.sharedObject.data.travelSaves)
				this.cbSave.dataProvider = new DataProvider(main.sharedObject.data.travelSaves);
		}

		public function onBtnSave(e:MouseEvent):void{
			if(this.txtSave.length < 1)
				return;
			if(this.listTravel.dataProvider.length < 1)
				return;
			this.cbSave.dataProvider.addItem({label: StringUtil.trim(this.txtSave.text), data: this.listTravel.dataProvider.toArray()});
			main.sharedObject.data.travelSaves = this.cbSave.dataProvider.toArray();
			main.sharedObject.flush();
			this.cbSave.dataProvider.invalidate();
			this.txtSave.text = "";
			main._stage.focus = null;
		}

		public function onBtnClear(e:MouseEvent):void{
			this.listTravel.dataProvider.removeAll();
			main._stage.focus = null;
		}

		public function onBtnDelSave(e:MouseEvent):void{
			if(!main.sharedObject.data.travelSaves)
				return;
			this.cbSave.dataProvider.removeItemAt(this.cbSave.selectedIndex);
			main.sharedObject.data.travelSaves = this.cbSave.dataProvider.toArray();
			main.sharedObject.flush();
			this.cbSave.dataProvider.invalidate();
			main._stage.focus = null;
		}

		public function onCbSaveChange(e:*):void{
			if(this.cbSave.selectedIndex < 0)
				return;
			this.listTravel.dataProvider = new DataProvider(this.cbSave.selectedItem.data);
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
			main._stage.focus = null;
		}

		public function onDrag(e:MouseEvent):void{
			this.startDrag();
		}

		public function onStopDrag(e:MouseEvent):void{
			this.stopDrag();
		}

		public function onBtnClose(e:MouseEvent):void{
			this.visible = false;
			main._stage.focus = null;
		}

		public function onBtnAdd(e:MouseEvent):void{
			if(this.txtTravel.text != "")
				this.listTravel.dataProvider.addItem( { label: StringUtil.trim(this.txtTravel.text) } );
			this.txtTravel.text = "";
		}

		public function onBtnDel(e:MouseEvent):void{
			if(this.listTravel.selectedIndex > -1)
				this.listTravel.dataProvider.removeItemAt(this.listTravel.selectedIndex);
			this.listTravel.selectedIndex = 0;
			main._stage.focus = null;
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
			main._stage.focus = null;
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
			main._stage.focus = null;
		}

		public function dispatchTravel():void{
			this.btnTravel.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function onBtnTravel(e:MouseEvent):void{
			if(this.listTravel.length < 1)
				return;
			if(this.listTravel.selectedIndex == -1)
				this.listTravel.selectedIndex = 0;

			
			if(main.Game.world.myAvatar.dataLeaf.intState == 0)
			{
				main.Game.MsgBox.notify("You are dead!");
			}
			else if(!main.Game.world.myAvatar.invLoaded || !main.Game.world.myAvatar.pMC.artLoaded())
			{
				main.Game.MsgBox.notify("Character still being loaded.");
			}
			else if(main.Game.world.coolDown("tfer")){
				var town:String = this.listTravel.selectedItem.label;
				main.Game.MsgBox.notify("Joining " + town);
				var cell:String = "Enter";
				var pad:String = "Spawn";
				main.Game.world.setReturnInfo(town, cell, pad);
				main.Game.sfc.sendXtMessage("zm","cmd",["tfer", main.Game.sfc.myUserName, town, cell, pad], "str", main.Game.world.curRoom);
				if(main.Game.world.strAreaName.indexOf("battleon") < 0 || main.Game.world.strAreaName.indexOf("battleontown") > -1)
					main.Game.menuClose();
				this.listTravel.selectedIndex++;
				if(this.listTravel.selectedIndex > this.listTravel.length-1)
					this.listTravel.selectedIndex = 0;
			}else{
				main.Game.MsgBox.notify("Not able to travel yet, please wait.");
			}
			main._stage.focus = null;
		}
	}
	
}

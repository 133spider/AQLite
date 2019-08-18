package net.spider.draw{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.handlers.*;
    import fl.data.DataProvider;
    import fl.controls.TextInput;
    import fl.managers.StyleManager;

    public class blackList extends MovieClip {
        public function blackList(){
            this.ui.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
            this.ui.addEventListener(MouseEvent.MOUSE_UP, onMRelease, false, 0, true);
        
            this.btnAddBlacklist.addEventListener(MouseEvent.CLICK, onBtnAddBlacklist, false, 0, true);
            this.btnRemoveBlacklist.addEventListener(MouseEvent.CLICK, onBtnRemoveBlacklist, false, 0, true);
            this.btnClearBlacklist.addEventListener(MouseEvent.CLICK, onBtnClearBlacklist, false, 0, true);
            
            this.ui.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);

            if(main.sharedObject.data.listBlack)
                this.listBlack.dataProvider = new DataProvider(main.sharedObject.data.listBlack);
        }

        private function onClose(e:MouseEvent):void{
            this.visible = false;
        }

        private function onBtnAddBlacklist(evt:MouseEvent):void{
            if(!this.listBlack)
                return;
            this.listBlack.dataProvider.addItem( { label: this.txtBlacklist.text.toUpperCase(), value: this.txtBlacklist.text.toUpperCase()} );
            main.sharedObject.data.listBlack = this.listBlack.dataProvider.toArray();
			main.sharedObject.flush();
            optionHandler.blackListed = this.listBlack.dataProvider.toArray();
            this.txtBlacklist.text = "";
        }

        private function onBtnRemoveBlacklist(evt:MouseEvent):void{
            if(!this.listBlack)
                return;
            if(this.listBlack.selectedIndex != -1){
                this.listBlack.removeItemAt(this.listBlack.selectedIndex);
                this.listBlack.selectedIndex = -1;
            }
            main.sharedObject.data.listBlack = this.listBlack.dataProvider.toArray();
			main.sharedObject.flush();
            optionHandler.blackListed = this.listBlack.dataProvider.toArray();
        }

        private function onBtnClearBlacklist(evt:MouseEvent):void{
            if(!this.listBlack)
                return;
            this.listBlack.removeAll();
            main.sharedObject.data.listBlack = this.listBlack.dataProvider.toArray();
			main.sharedObject.flush();
            optionHandler.blackListed = this.listBlack.dataProvider.toArray();
        }

        private function onDrag(e:MouseEvent):void{
            this.startDrag();
        }

        private function onMRelease(e:MouseEvent):void{
            this.stopDrag();
        }
    }
}
package net.spider.draw {
	
	import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.net.*;
    import flash.geom.*;
    import flash.utils.*;
    import net.spider.main;
    import net.spider.modules.options;
    import net.spider.modules.bettermounts;
    import net.spider.handlers.*;
	
	
	public class iconMount extends MovieClip {
		
        private var isRunning:Boolean = false;
		public function iconMount() {
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onBtMount, false, 0, true);
		}

		public function onBtMount(e:MouseEvent):void{
            e.stopPropagation();
            if(isRunning)
                return;
            isRunning = true;
            if(main.sharedObject.data.savedMounts){
                var t_obj:Object = main.sharedObject.data.savedMounts;
                if(!t_obj[main.Game.world.myAvatar.objData.strUsername.toLowerCase()]){
                    isRunning = false;
                    warning();
                    return;
                }
            }else{
                isRunning = false;
                warning();
                return;
            }
            if(bettermounts.isMountEquipped && bettermounts.mnt_id != 0){
                var sES:String = (main.Game.world.myAvatar.objData.eqp.co == null) ? "ar" : "co";
                var avt_eqp:* = main.Game.world.myAvatar.objData.eqp[sES];
                if(avt_eqp.hasOwnProperty("relsFile")){
                    revertMount();
                    return;
                }
            }
            wasMount = (bettermounts.isMountEquipped && bettermounts.mnt_id != 0);
            oldID = bettermounts.mnt_id;
			var _local2:* = undefined;
            var _local3:* = undefined;
            _local2 = {};
            _local2.typ = "generic";
            _local2.dur = 0.5;
            _local2.txt = "Summoning Mount";
            _local2.callback = summonMount;
            _local2.args = {};
            main.Game.ui.mcCastBar.fOpenWith(_local2);
        }

        public function warning():void{
            var modalClass:Class = main.Game.world.getClass("ModalMC");
            var modal:* = new modalClass();
            var modalO:* = {};
            modalO.strBody = "You must set your primary mount from your inventory!";
            modalO.params = {};
            modalO.glow = "red,medium";
            modalO.btns = "mono";
            main._stage.addChild(modal);
            modal.init(modalO);
        }

        private var loadTimer:Timer;
		public function summonMount(_arg1):void{
			var item:*;
            var t_obj:Object = main.sharedObject.data.savedMounts;
			for each(var t_item:* in main.Game.world.myAvatar.items)
				if(t_item.ItemID == t_obj[main.Game.world.myAvatar.objData.strUsername.toLowerCase()])
					item = t_item;
            if(!item){
                warning();
                return;
            }
            var sES:String = (main.Game.world.myAvatar.objData.eqp.co == null) ? "ar" : "co";
			var avt_eqp:* = main.Game.world.myAvatar.objData.eqp[sES];

			avt_eqp.relsFile = avt_eqp.sFile;
			avt_eqp.relsLink = avt_eqp.sLink;
            avt_eqp.sFile = item.sFile;
            avt_eqp.sLink = item.sLink;
            main.Game.world.myAvatar.loadMovieAtES(sES, item.sFile, item.sLink);
			bettermounts.isMountEquipped = true;
			bettermounts.mnt_id = item.ItemID;
            isRunning = false;
		}

        private var oldID:Number = 0;
        private var wasMount:Boolean = false;//was a mount before pressing the mount icon
        public function revertMount():void{
            var sES:String = (main.Game.world.myAvatar.objData.eqp.co == null) ? "ar" : "co";
            var avt_eqp:* = main.Game.world.myAvatar.objData.eqp[sES];

            avt_eqp.sFile = avt_eqp.relsFile;
            avt_eqp.sLink = avt_eqp.relsLink;
            main.Game.world.myAvatar.loadMovieAtES(sES, avt_eqp.sFile, avt_eqp.sLink);
            delete avt_eqp.relsFile;
			delete avt_eqp.relsLink;
            bettermounts.isMountEquipped = wasMount;
            bettermounts.mnt_id = (wasMount) ? oldID : 0;
            isRunning = false;
        }
	}
	
}

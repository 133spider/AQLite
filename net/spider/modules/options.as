package net.spider.modules{
	
    import fl.motion.Color;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.handlers.flags;
    import net.spider.handlers.dropmenu;
    import net.spider.handlers.targetskills;
    import net.spider.handlers.skills;
    import net.spider.handlers.passives;
    import net.spider.handlers.ClientEvent;
    import net.spider.modules.*;
	
	public class options extends MovieClip{

        private var optTimer:Timer;
        
        public static var cDrops:Boolean;
        public static var draggable:Boolean;
        public static var hideP:Boolean;
        public static var mType:Boolean;
        public static var qRates:Boolean;
        public static var qLog:Boolean;

        public static var disableSkillAnim:Boolean;
        public static var myAnim:Boolean;
        public static var skill:Boolean;
        public static var passive:Boolean;
        public static var untargetMon:Boolean;

        public static var chatFilter:Boolean;

        public function options():void{
            this.visible = false;

            this.gotoAndStop("general");
            btnGeneral.gotoAndStop(2);
            btnCombat.gotoAndStop(1);
            btnChat.gotoAndStop(1);
            btnAccount.gotoAndStop(1);

            btnGeneral.addEventListener(MouseEvent.CLICK, onCategoryClick, false, 0, true);
            btnGeneral.gotoAndStop(2);
            btnGeneral.buttonMode = true;
            setup("btnGeneral");
            btnCombat.addEventListener(MouseEvent.CLICK, onCategoryClick, false, 0, true);
            btnCombat.buttonMode = true;
            btnChat.addEventListener(MouseEvent.CLICK, onCategoryClick, false, 0, true);
            btnChat.buttonMode = true;

            this.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            filterChecks["chkRed"] = true;
            filterChecks["chkBlue"] = false;
            optTimer = new Timer(0);
			optTimer.addEventListener(TimerEvent.TIMER, onTimer);
            optTimer.start();
        }

        private function onCategoryClick(e:MouseEvent):void
        {
            btnGeneral.gotoAndStop(1);
            btnCombat.gotoAndStop(1);
            btnChat.gotoAndStop(1);
            btnAccount.gotoAndStop(1);
            e.currentTarget.gotoAndStop(2);
            switch (e.currentTarget.name)
            {
                case "btnGeneral":
                    if (this.currentLabel != "general")
                        this.gotoAndStop("general");
                    break;
                case "btnCombat":
                    if (this.currentLabel != "combat")
                        this.gotoAndStop("combat");
                    break;
                case "btnChat":
                    if (this.currentLabel != "chat")
                        this.gotoAndStop("chat");
                    break;
                default:
                    break;
            }
            setup(e.currentTarget.name);
        }

        private function setup(e:String):void{
            switch(e){
                case "btnGeneral":
                    this.txtCDrops.text = (cDrops ? "ON" : "OFF");
                    this.txtDraggable.text = (draggable ? "ON" : "OFF");
                    this.txtHideP.text = (hideP ? "ON" : "OFF");
                    this.txtMType.text = (mType ? "ON" : "OFF");
                    this.txtQRates.text = (qRates ? "ON" : "OFF");
                    this.txtQLog.text = (qLog ? "ON" : "OFF");
                    if(this.btnLeftCDrops.hasEventListener(MouseEvent.CLICK))
                        return;
                    this.btnLeftCDrops.addEventListener(MouseEvent.CLICK, onCDrops, false, 0, true);
                    this.btnRightCDrops.addEventListener(MouseEvent.CLICK, onCDrops, false, 0, true);
                    this.btnLeftDraggable.addEventListener(MouseEvent.CLICK, onDraggable, false, 0, true);
                    this.btnRightDraggable.addEventListener(MouseEvent.CLICK, onDraggable, false, 0, true);
                    this.btnLeftHideP.addEventListener(MouseEvent.CLICK, onHideP, false, 0, true);
                    this.btnRightHideP.addEventListener(MouseEvent.CLICK, onHideP, false, 0, true);
                    this.btnLeftMType.addEventListener(MouseEvent.CLICK, onMType, false, 0, true);
                    this.btnRightMType.addEventListener(MouseEvent.CLICK, onMType, false, 0, true);
                    this.btnLeftQRates.addEventListener(MouseEvent.CLICK, onQRates, false, 0, true);
                    this.btnRightQRates.addEventListener(MouseEvent.CLICK, onQRates, false, 0, true);
                    this.btnLeftQLog.addEventListener(MouseEvent.CLICK, onQLog, false, 0, true);
                    this.btnRightQLog.addEventListener(MouseEvent.CLICK, onQLog, false, 0, true);
                    this.btnColor.addEventListener(MouseEvent.CLICK, onBtColor, false, 0, true);
                    break;
                case "btnCombat":
                    this.txtSkillAnim.text = (disableSkillAnim ? "ON" : "OFF");
                    this.txtMyAnim.text = (myAnim ? "ON" : "OFF");
                    this.txtSkill.text = (skill ? "ON" : "OFF");
                    this.txtSkillP.text = (passive ? "ON" : "OFF");
                    this.txtEsc.text = (untargetMon ? "ON" : "OFF");
                    if(this.btnLeftSkillAnim.hasEventListener(MouseEvent.CLICK))
                        return;
                    this.btnLeftSkillAnim.addEventListener(MouseEvent.CLICK, onSkillAnim, false, 0, true);
                    this.btnRightSkillAnim.addEventListener(MouseEvent.CLICK, onSkillAnim, false, 0, true);
                    this.btnLeftMyAnim.addEventListener(MouseEvent.CLICK, onMyAnim, false, 0, true);
                    this.btnRightMyAnim.addEventListener(MouseEvent.CLICK, onMyAnim, false, 0, true);
                    this.btnLeftSkill.addEventListener(MouseEvent.CLICK, onSkill, false, 0, true);
                    this.btnRightSkill.addEventListener(MouseEvent.CLICK, onSkill, false, 0, true);
                    this.btnLeftSkillP.addEventListener(MouseEvent.CLICK, onSkillP, false, 0, true);
                    this.btnRightSkillP.addEventListener(MouseEvent.CLICK, onSkillP, false, 0, true);
                    this.btnLeftEsc.addEventListener(MouseEvent.CLICK, onEsc, false, 0, true);
                    this.btnRightEsc.addEventListener(MouseEvent.CLICK, onEsc, false, 0, true);
                    break;
                case "btnChat":
                    this.txtChat.text = (chatFilter ? "ON" : "OFF");
                    this.chkRed.checkmark.visible = filterChecks["chkRed"];
                    this.chkBlue.checkmark.visible = filterChecks["chkBlue"];
                    if(this.btnLeftChat.hasEventListener(MouseEvent.CLICK))
                        return;
                    this.btnLeftChat.addEventListener(MouseEvent.CLICK, onChat, false, 0, true);
                    this.btnRightChat.addEventListener(MouseEvent.CLICK, onChat, false, 0, true);
                    this.chkRed.addEventListener(MouseEvent.CLICK, onCheckPressed, false, 0, true);
                    this.chkBlue.addEventListener(MouseEvent.CLICK, onCheckPressed, false, 0, true);
                    break;
                default: break;
            }
        }

        private function onBtColor(evt:MouseEvent):void{
            main.Game.ui.mcPopup.onClose();
            stage.addEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        private var _stageBitmap:BitmapData;
        private function getColor(evt:MouseEvent):void{
            if (_stageBitmap == null) 
                _stageBitmap = new BitmapData(stage.width, stage.height);
            _stageBitmap.draw(stage);

            var rgb:uint = _stageBitmap.getPixel(stage.mouseX,stage.mouseY);

            var red:int =  (rgb >> 16 & 0xff);
            var green:int =  (rgb >> 8 & 0xff);
            var blue:int =  (rgb & 0xff);

            this.txtRed.text = red.toString();
            this.txtGreen.text = green.toString();
            this.txtBlue.text = blue.toString();

            this.txtHex.text = "#" + rgb.toString(16);

            var c:Color=new Color();
            c.setTint(rgb, 1);
            this.colorPreview.transform.colorTransform = c;

            main.Game.ui.mcPopup.fOpen("Option");
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, getColor);
        }

        public static var filterChecks:Object = new Object();
        public function onCheckPressed(evt:MouseEvent):void{
            evt.currentTarget.checkmark.visible = !evt.currentTarget.checkmark.visible;
            filterChecks[evt.currentTarget.name] = evt.currentTarget.checkmark.visible;
        }

        public function onClose(evt:MouseEvent):void{
            main.Game.ui.mcPopup.onClose();
        }

        public function onChat(evt:MouseEvent):void{
            chatFilter = !chatFilter;
            dispatch(chatfilter);
            if(!chatFilter)
                this.txtChat.text = "OFF";
            else
                this.txtChat.text = "ON";
        }

        public function onSkillAnim(evt:MouseEvent):void{
            disableSkillAnim = !disableSkillAnim;
            dispatch(skillanim);
            if(!disableSkillAnim)
                this.txtSkillAnim.text = "OFF";
            else
                this.txtSkillAnim.text = "ON";
        }

        public function onMyAnim(evt:MouseEvent):void{
            myAnim = !myAnim;
            if(myAnim && !disableSkillAnim)
                btnLeftSkillAnim.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(!myAnim)
                this.txtMyAnim.text = "OFF";
            else
                this.txtMyAnim.text = "ON";
        }

        public function onSkill(evt:MouseEvent):void{
            skill = !skill;
            dispatch(skills);
            dispatch(targetskills);
            if(!skill)
                this.txtSkill.text = "OFF";
            else
                this.txtSkill.text = "ON";
        }

        public function onSkillP(evt:MouseEvent):void{
            passive = !passive;
            dispatch(passives);
            if(!passive)
                this.txtSkillP.text = "OFF";
            else
                this.txtSkillP.text = "ON";
        }

        public function onEsc(evt:MouseEvent):void{
            untargetMon = !untargetMon;
            dispatch(untarget);
            if(!untargetMon)
                this.txtEsc.text = "OFF";
            else
                this.txtEsc.text = "ON";
        }

        public function onCDrops(evt:MouseEvent):void{
            cDrops = !cDrops;
            dispatch(dropmenu);
            if(!cDrops)
                this.txtCDrops.text = "OFF";
            else
                this.txtCDrops.text = "ON";
        }

        public function onDraggable(evt:MouseEvent):void{
            draggable = !draggable;
            dispatch(drops);
            if(!draggable)
                this.txtDraggable.text = "OFF";
            else
                this.txtDraggable.text = "ON";
        }

        public function onHideP(evt:MouseEvent):void{
            hideP = !hideP;
            dispatch(hideplayers);
            if(!hideP)
                this.txtHideP.text = "OFF";
            else
                this.txtHideP.text = "ON";
        }

        public function onMType(e:MouseEvent):void{
            mType = !mType;
            dispatch(monstype);
            if(!mType)
                this.txtMType.text = "OFF";
            else
                this.txtMType.text = "ON";
        }

        public function onQRates(e:MouseEvent):void{
            qRates = !qRates;
            dispatch(qrates);
            if(!qRates)
                this.txtQRates.text = "OFF";
            else
                this.txtQRates.text = "ON";
        }

        public function onQLog(e:MouseEvent):void{
            qLog = !qLog;
            dispatch(qlog);
            if(!qLog)
                this.txtQLog.text = "OFF";
            else
                this.txtQLog.text = "ON";
        }

        public function onTimer(e:TimerEvent):void{
            if(!main.Game.ui || !main.Game){
                this.visible = false;
                return;
            }
            this.visible = flags.isOptions();
		}

        public function onDestroy():void{
            optTimer.reset();
            optTimer.removeEventListener(TimerEvent.TIMER, onTimer);
        }

        public function dispatch(e:*):void{
            e.events.dispatchEvent(new ClientEvent(ClientEvent.onToggle));
        }
	}
	
}

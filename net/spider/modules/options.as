package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.handlers.flags;
    import net.spider.handlers.dropmenu;
    import net.spider.handlers.skills;
    import net.spider.handlers.ClientEvent;
    import net.spider.modules.*;
	
	public class options extends MovieClip{

        private var optTimer:Timer;
        
        public static var disableSkillAnim:Boolean;
        public static var myAnim:Boolean;
        public static var skill:Boolean;
        public static var cDrops:Boolean;
        public static var draggable:Boolean;
        public static var hideP:Boolean;
        public static var mType:Boolean;
        public static var qRates:Boolean;

        public function options():void{
            this.visible = false;

            this.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
            this.btnLeftSkillAnim.addEventListener(MouseEvent.CLICK, onSkillAnim, false, 0, true);
            this.btnRightSkillAnim.addEventListener(MouseEvent.CLICK, onSkillAnim, false, 0, true);
            this.btnLeftMyAnim.addEventListener(MouseEvent.CLICK, onMyAnim, false, 0, true);
            this.btnRightMyAnim.addEventListener(MouseEvent.CLICK, onMyAnim, false, 0, true);
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
            this.btnLeftSkill.addEventListener(MouseEvent.CLICK, onSkill, false, 0, true);
            this.btnRightSkill.addEventListener(MouseEvent.CLICK, onSkill, false, 0, true);
            optTimer = new Timer(0);
			optTimer.addEventListener(TimerEvent.TIMER, onTimer);
            optTimer.start();
        }

        public function onClose(evt:MouseEvent):void{
            main.Game.ui.mcPopup.onClose();
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
            if(!skill)
                this.txtSkill.text = "OFF";
            else
                this.txtSkill.text = "ON";
        }

        public function onCDrops(evt:MouseEvent):void{
            cDrops = !cDrops;
            main.Game.ui.dropStack.visible = !cDrops;
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

        public function onTimer(e:TimerEvent):void{
            if(!main.Game.ui || !main.Game){
                this.visible = false;
                return;
            }
            this.visible = flags.isOptions();
            if(!this.visible)
                return;
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

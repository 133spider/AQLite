package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.geom.*;
    import fl.controls.TextArea;
    import fl.controls.ScrollPolicy;
    import net.spider.main;
    import net.spider.draw.mcAC;
	
	public class chatui extends MovieClip{

        private var activeTab:Number = 0; //vector index in tabs

        private var chatBox:MovieClip;
        private var chatBox_mask:Shape;
        //0 - all
        //1 - regular chat
        //2 - system
        //3 - party
        //4 - guild
        private var tabs:Vector.<Object>;
        private var messages:Vector.<Object>;
		public function chatui(){
            //store existing chat messages into a vector object
            //listen for future messages
            tabs = new <Object>[
                {
                    label: "GENERAL"
                },
                {
                    label: "CHAT"
                },
                {
                    label: "SYSTEM"
                },
                {
                    label: "PARTY"
                },
                {
                    label: "GUILD"
                },
                {
                    label: "WHISPER"
                }
            ];

            
            var game_chat:* = main.Game.ui.mcInterface.t1;
            this.x = game_chat.x - 12;
            this.y = (heightConst) - this.height;

            messages = new Vector.<Object>();
            chatBox = new MovieClip();

            chatBox_mask = new Shape(); 
            chatBox_mask.graphics.beginFill(0);
            chatBox_mask.graphics.drawRect(0, 0, game_chat.width, game_chat.height);
            chatBox_mask.graphics.endFill();
            main.Game.ui.mcInterface.addChild(chatBox_mask);
            chatBox_mask.name = "chatBox_chatBox_mask";
            chatBox_mask.x = game_chat.x;
            chatBox_mask.y = game_chat.y;
            chatBox.x = game_chat.x;
            chatBox.y = game_chat.y;
            chatBox.mask = chatBox_mask;

            draw_tab();

            main.Game.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);

            main.Game.ui.mcInterface.bShortTall.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            var id:Number = 1;
            var txt:String;
            for(var i:uint = 0; i < game_chat.numChildren; i++){
				if(!game_chat.getChildAt(i).getChildAt(0).ti)
					continue;
				txt = game_chat.getChildAt(i).getChildAt(0).ti.htmlText;
				switch(true){
                    case txt.indexOf('COLOR="#FF0000"') > -1:
                    case txt.indexOf('COLOR="#00FFFF"') > -1:
                        id = 2;
                        break;
                    case txt.indexOf('COLOR="#00CCFF"') > -1:
                        id = 3;
                        break;
                    case txt.indexOf('COLOR="#99FF00"') > -1:
                        id = 4;
                        break;
                    case txt.indexOf('COLOR="#990099"') > -1:
                    case txt.indexOf('COLOR="#FF00FF"') > -1:
                        id = 5;
                        break;
                }
                messages.push({
                    id: id,
                    message: txt,
                    timestamp: "<font size=\"11\" style=\"font-family:purista;\">" + format_time() + "</font> "
                });
			}
            main.Game.ui.mcInterface.bShortTall.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            main.Game.ui.mcInterface.addChild(chatBox);
            chatBox.name = "chatui_chatBox";
            game_chat.visible = false;
            filterMessages();

            chatBox.mouseEnabled = chatBox.mouseChildren = false;
            game_chat.addEventListener(Event.ADDED, onAdded, false, 0, true);
            main.Game.ui.mcInterface.bShortTall.mouseEnabled = main.Game.ui.mcInterface.bShortTall.mouseChildren = false;
            main.Game.ui.mcInterface.bMinMax.mouseEnabled = main.Game.ui.mcInterface.bMinMax.mouseChildren = false;

            var ghostBtShape:Shape = new Shape(); 
            ghostBtShape.graphics.beginFill(0, 0);
            ghostBtShape.graphics.drawRect(0, 0, main.Game.ui.mcInterface.bShortTall.width, main.Game.ui.mcInterface.bShortTall.height);
            ghostBtShape.graphics.endFill();
            ghostBt1 = new MovieClip();
            ghostBt1.addChild(ghostBtShape);
            main.Game.ui.mcInterface.addChild(ghostBt1);
            ghostBt1.x = main.Game.ui.mcInterface.bShortTall.x;
            ghostBt1.y = main.Game.ui.mcInterface.bShortTall.y;

            var ghostBtShape2:Shape = new Shape(); 
            ghostBtShape2.graphics.beginFill(0, 0);
            ghostBtShape2.graphics.drawRect(0, 0, main.Game.ui.mcInterface.bMinMax.width, main.Game.ui.mcInterface.bMinMax.height);
            ghostBtShape2.graphics.endFill();
            ghostBt2 = new MovieClip();
            ghostBt2.addChild(ghostBtShape2);
            main.Game.ui.mcInterface.addChild(ghostBt2);
            ghostBt2.x = main.Game.ui.mcInterface.bMinMax.x;
            ghostBt2.y = main.Game.ui.mcInterface.bMinMax.y;

            ghostBt1.addEventListener(MouseEvent.CLICK, onChangeSize, false, 0, true);
            ghostBt2.addEventListener(MouseEvent.CLICK, onVisibility, false, 0, true);
        }
        private var ghostBt1:MovieClip;
        private var ghostBt2:MovieClip;

        public function onVisibility(e:*):void{
            trace("visiblity clicked");
            this.visible = !this.visible;
            chatBox.visible = !chatBox.visible;
        }

        public function cleanup():void{
            main._stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
            main.Game.ui.mcInterface.t1.removeEventListener(Event.ADDED, onAdded);
            main.Game.ui.mcInterface.bShortTall.removeEventListener(MouseEvent.CLICK, onChangeSize);
            main.Game.ui.mcInterface.bMinMax.removeEventListener(MouseEvent.CLICK, onVisibility);
            main.Game.ui.mcInterface.removeChild(main.Game.ui.mcInterface.getChildByName("chatui_chatBox"));
            main.Game.ui.mcInterface.removeChild(main.Game.ui.mcInterface.getChildByName("chatBox_chatBox_mask"));
            main.Game.ui.mcInterface.bShortTall.mouseEnabled = main.Game.ui.mcInterface.bShortTall.mouseChildren = true;
            main.Game.ui.mcInterface.bMinMax.mouseEnabled = main.Game.ui.mcInterface.bMinMax.mouseChildren = true;
            main.Game.ui.mcInterface.t1.visible = true;
            this.parent.removeChild(this);
        }

        private var heightConst:Number = -137;
        public function onChangeSize(e:*):void{ //121.35, 233.35
            heightConst = (heightConst == -137) ? -378 : -137;
            main.Game.ui.mcInterface.removeChild(main.Game.ui.mcInterface.getChildByName("chatBox_chatBox_mask"));
            chatBox_mask = new Shape(); 
            chatBox_mask.graphics.beginFill(0);
            chatBox_mask.graphics.drawRect(0, 0, 371.9, (heightConst == -137) ? 121.35 : 362.25);
            chatBox_mask.graphics.endFill();
            main.Game.ui.mcInterface.addChild(chatBox_mask);
            chatBox_mask.name = "chatBox_chatBox_mask";
            chatBox_mask.x = chatBox.x;
            chatBox_mask.y = heightConst;
            chatBox.mask = chatBox_mask;

            draw_tab();
            filterMessages();
        }

        public function onAdded(e:Event):void{ //limit 100
            if(!e.target.getChildAt(e.target.numChildren-1).hasOwnProperty("ti"))
                return;
            var txt:String = e.target.getChildAt(e.target.numChildren-1).ti.htmlText;
            var id:Number = 1;
            switch(true){
                case txt.indexOf('COLOR="#FF0000"') > -1:
                case txt.indexOf('COLOR="#00FFFF"') > -1:
                    id = 2;
                    break;
                case txt.indexOf('COLOR="#00CCFF"') > -1:
                    id = 3;
                    break;
                case txt.indexOf('COLOR="#99FF00"') > -1:
                    id = 4;
                    break;
                case txt.indexOf('COLOR="#990099"') > -1:
                case txt.indexOf('COLOR="#FF00FF"') > -1:
                    id = 5;
                    break;
            }
            messages.push({
                id: id,
                message: txt,
                timestamp: "<font size=\"11\" style=\"font-family:purista;\">" + format_time() + "</font> "
            });
            if(messages.length > 100)
                messages.shift();
            filterMessages();
        }

        public function onWheel(e:MouseEvent):void{
            e.stopPropagation();
            if(!chatBox.hitTestPoint(e.stageX,e.stageY))
                return;
            e.delta *= 2;
            if(chatBox.y + e.delta <= heightConst){
                chatBox.y += e.delta;
            }else if(chatBox.y + e.delta >= ((heightConst) + (chatBox.height + chatBox.mask.height))){
                chatBox.y -= e.delta;
            }
            if(chatBox.y >= heightConst){
                chatBox.y = heightConst;
            }else if(chatBox.y <= (heightConst) - (chatBox.height - chatBox.mask.height)){
                chatBox.y = (heightConst) - (chatBox.height - chatBox.mask.height);
            }
        }

        public function draw_tab():void{
            var txtFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0, 1.0, 3.0, 3.0, 10.0, 1, false, false, false);
            var txtFormat:TextFormat = new TextFormat();
            txtFormat.font = "MINI 7 Condensed";
            txtFormat.size = 9;
            var _tab:Object;
            var _child:*;
            for(var i:Number = 0; i < tabs.length; i++){
                _tab = tabs[i];
                if(_tab.component && this.getChildByName("@"+_tab.component.text) != null)
                    this.removeChild(this.getChildByName("@"+_tab.component.text));
                _tab.component = null;
                _tab.component = new TextField();
                txtFormat.color = (i == activeTab) ? 0xFFFFFF : 0x999999;
                //_tab.component.embedFonts = true;
                _tab.component.filters = [txtFilter];
                _tab.component.defaultTextFormat = txtFormat;
                _tab.component.border = false;
                _tab.component.text = _tab.label;
                _tab.component.selectable = false;
                _tab.component.autoSize = "left";
                _child = this.addChild(_tab.component);
                _child.name = "@"+_tab.component.text;
                _child.x = (i > 0 ? (tabs[i-1].component.x + tabs[i-1].component.width + 8) : 12);
                _child.y = (heightConst == -137) ? 4.90 : -236.1;
                this.tabShadowBar.y = (heightConst == -137) ? 0 : -241;

                _child.addEventListener(MouseEvent.CLICK, onTabClicked, false, 0, true);

                if(i == activeTab){
                    if(this.getChildByName("active_stripe") != null)
                        this.removeChild(this.getChildByName("active_stripe"));
                    var active_stripe:MovieClip = new MovieClip();
                    active_stripe.name = "active_stripe";
                    active_stripe.graphics.beginFill(0xFFFFFF);
                    active_stripe.graphics.drawRect(0, 0, _tab.component.width, 2.20);
                    active_stripe.graphics.endFill();
                    active_stripe.x = _child.x;
                    active_stripe.y = (heightConst == -137) ? 22.80 : -218.2;
                    this.addChild(active_stripe);
                }
            }
        }

        public static function format_time():String{
			var hours:Number = main.Game.date_server.hours;
			var minutes:Number = main.Game.date_server.minutes;

			var format_hrs:String = ("" + hours);
			var format_mints:String = ("" + minutes);
			if(hours < 10)
				format_hrs = "0" + hours;
			if(minutes < 10)
				format_mints = "0" + minutes;
			return format_hrs + ":" + format_mints + " ";
		}

        public function filterMessages():void{
            while(chatBox.numChildren > 0)
                chatBox.removeChildAt(0);
            for each(var msg_string:* in messages){
                if(activeTab == 0 || activeTab == msg_string.id || (activeTab == 1 && (msg_string.id == 3 || msg_string.id == 4 || msg_string.id == 5)) ){
                    var txtui:Class = main.Game.world.getClass("uiTextLine");
                    var mc_txtui:MovieClip = new (txtui as Class)();
                    mc_txtui.ti.filters = [new DropShadowFilter(0, 45, 0, 1.0, 3.0, 3.0, 10.0, 1, false, false, false)];
                    mc_txtui.ti.htmlText = (optionHandler.filterChecks["chkTimestamp"]) ? (msg_string.timestamp + msg_string.message) : msg_string.message;
                    mc_txtui.ti.autoSize = "left";
                    mc_txtui.y = chatBox.numChildren > 0 ? chatBox.getChildAt(chatBox.numChildren-1).y + chatBox.getChildAt(chatBox.numChildren-1).height : 0;
                    chatBox.addChild(mc_txtui);
                    mc_txtui.mouseEnabled = mc_txtui.mouseChildren = false;
                }
            }
            chatBox.y = (heightConst) - (chatBox.height - chatBox.mask.height);
            trace("PLACED@@ HEIGHT: " + chatBox.height + " | " + chatBox.mask.height);
        }

        public function onTabClicked(e:MouseEvent):void{
            for(var i:Number = 0; i < tabs.length; i++){
                if(tabs[i].label == e.target.text){
                    activeTab = i;
                    draw_tab();
                    break;
                }
            }
            trace(e.target.text + "CLICKED");
            filterMessages();
        }
	}
	
}

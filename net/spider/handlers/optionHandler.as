package net.spider.handlers{
	
    import fl.motion.Color;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.main;
    import net.spider.handlers.*;
    import net.spider.modules.*;
    import net.spider.draw.*;
    import flash.media.SoundTransform;
    import fl.data.DataProvider;
    import com.adobe.utils.StringUtil;
	
	public class optionHandler extends MovieClip{

        public static var events:EventDispatcher = new EventDispatcher();

        public static var cDrops:Boolean;
        public static var sbpcDrops:Boolean;
        public static var draggable:Boolean;
        public static var detaildrop:Boolean;
        public static var mType:Boolean;
        public static var qRates:Boolean;
        public static var qPrev:Boolean;
        public static var detailquest:Boolean;
        public static var qLog:Boolean;
        public static var qAccept:Boolean;
        public static var qPin:Boolean;
        public static var disableSkillAnim:Boolean;
        public static var skill:Boolean;
        public static var cSkillAnim:Boolean;
        public static var passive:Boolean;
        public static var lockm:Boolean;
        public static var boost:Boolean;
        public static var untargetMon:Boolean;
        public static var selfTarget:Boolean;
        public static var hideP:Boolean;
        public static var hideM:Boolean;
        public static var disWepAnim:Boolean;
        public static var disMonAnim:Boolean;
        public static var disMapAnim:Boolean;
        public static var bitmapP:Boolean;
        public static var chatFilter:Boolean;
        public static var disableFX:Boolean;
        public static var smoothBG:Boolean;
        public static var bColorSets:Boolean;
        public static var alphaBOL:Boolean;
        public static var bTheArchive:Boolean;
        public static var cleanRep:Boolean;

        public static var filterChecks:Object = new Object();
        public static var blackListed:Array = new Array();

        public static function onCreate():void{
            optionHandler.events.addEventListener(ClientEvent.onEnable, readSettings);
        }

        public static function readSettings(e:ClientEvent):void{
            if(main.sharedObject.data.filterChecks == null)
                main.sharedObject.data.filterChecks = new Object();
            if(main.sharedObject.data.filterChecks["chkRed"] == null){
                main.sharedObject.data.filterChecks["chkRed"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkRed"] = main.sharedObject.data.filterChecks["chkRed"];
            if(main.sharedObject.data.filterChecks["chkBlue"] == null){
                main.sharedObject.data.filterChecks["chkBlue"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkBlue"] = main.sharedObject.data.filterChecks["chkBlue"];
            if(main.sharedObject.data.filterChecks["chkName"] == null){
                main.sharedObject.data.filterChecks["chkName"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkName"] = main.sharedObject.data.filterChecks["chkName"];
            if(main.sharedObject.data.filterChecks["chkSelfOnly"] == null){
                main.sharedObject.data.filterChecks["chkSelfOnly"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkSelfOnly"] = main.sharedObject.data.filterChecks["chkSelfOnly"];
            if(main.sharedObject.data.filterChecks["chkDisWepAnim"] == null){
                main.sharedObject.data.filterChecks["chkDisWepAnim"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkDisWepAnim"] = main.sharedObject.data.filterChecks["chkDisWepAnim"];
            if(main.sharedObject.data.filterChecks["chkInvertDrop"] == null){
                main.sharedObject.data.filterChecks["chkInvertDrop"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkShadow"] = main.sharedObject.data.filterChecks["chkShadow"];
            if(main.sharedObject.data.filterChecks["chkShadow"] == null){
                main.sharedObject.data.filterChecks["chkShadow"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkInvertDrop"] = main.sharedObject.data.filterChecks["chkInvertDrop"];
            cDrops = main.sharedObject.data.cDrops;
            if(cDrops)
                dispatch(dropmenu);

            sbpcDrops = main.sharedObject.data.sbpcDrops;
            if(sbpcDrops)
                dispatch(dropmenutwo);

            draggable = main.sharedObject.data.draggable;
            if(draggable)
                dispatch(drops);

            detaildrop = main.sharedObject.data.detaildrop;
            if(detaildrop)
                dispatch(detaildrops);

            mType = main.sharedObject.data.mType;
            if(mType)
                dispatch(monstype);

            qRates = main.sharedObject.data.qRates;
            if(qRates)
                dispatch(qrates);

            qPrev = main.sharedObject.data.qPrev;
            if(qPrev)
                dispatch(qprev);

            detailquest = main.sharedObject.data.detailquest;
            if(detailquest)
                dispatch(detailquests);

            qLog = main.sharedObject.data.qLog;
            if(qLog)
                dispatch(qlog);

            disableSkillAnim = main.sharedObject.data.disableSkillAnim;
            if(disableSkillAnim)
                dispatch(skillanim);

            skill = main.sharedObject.data.skill;
            if(skill){
                dispatch(skills);
                dispatch(targetskills);
            }

            //passive = main.sharedObject.data.passive;
            passive = true;
            if(passive)
                dispatch(passives);

            boost = main.sharedObject.data.boost;
            if(boost)
                dispatch(boosts);

            untargetMon = main.sharedObject.data.untargetMon;
            if(untargetMon)
                dispatch(untarget);

            selfTarget = main.sharedObject.data.selfTarget;
            if(selfTarget)
                dispatch(untargetself);

            hideP = main.sharedObject.data.hideP;
            if(hideP)
                dispatch(hideplayers);

            disWepAnim = main.sharedObject.data.disWepAnim;
            if(disWepAnim)
                dispatch(diswepanim);

            chatFilter = main.sharedObject.data.chatFilter;
            if(chatFilter)
                dispatch(chatfilter);

            disableFX = main.sharedObject.data.disableFX;
            if(disableFX)
                main.Game.mixer.stf = new SoundTransform(0);

            disMonAnim = main.sharedObject.data.disMonAnim;
            if(disMonAnim)
                dispatch(dismonanim);
            
            if(main.sharedObject.data.listBlack)
                blackListed = main.sharedObject.data.listBlack;

            bitmapP = main.sharedObject.data.bitmapP;
            if(bitmapP)
                dispatch(bitmap);

            qAccept = main.sharedObject.data.qAccept;
            if(qAccept)
                dispatch(qaccept);
            
            cSkillAnim = main.sharedObject.data.cSkillAnim;
            if(cSkillAnim)
                dispatch(cskillanim);

            qPin = main.sharedObject.data.qPin;
            if(qPin)
                dispatch(qpin);

            disMapAnim = main.sharedObject.data.disMapAnim;
            if(disMapAnim)
                dispatch(dismapanim);

            lockm = main.sharedObject.data.lockM;
            if(lockm)
                dispatch(lockmons);
            
            smoothBG = main.sharedObject.data.smoothBG;
            if(smoothBG)
                dispatch(smoothbg);

            bColorSets = main.sharedObject.data.bColorSets;
            if(bColorSets)
                dispatch(colorsets);

            hideM = main.sharedObject.data.hideM;
            if(hideM)
                dispatch(hidemonsters);

            alphaBOL = main.sharedObject.data.alphaBOL;
            bTheArchive = main.sharedObject.data.theArchive;
            cleanRep = main.sharedObject.data.cleanRep;
        }

        public static var colorPickerMC:colorPicker;
        public static var blackListMC:blackList;
        public static function cmd(id:String):void{
            switch(id){
                case "Draggable Drops":
                    draggable = !draggable;
                    dispatch(drops);
                    main.sharedObject.data.draggable = draggable;
                    main.sharedObject.flush();
                    break;
                case "Show Detailed Item Drops":
                    detaildrop = !detaildrop;
                    dispatch(detaildrops);
                    main.sharedObject.data.detaildrop = detaildrop;
                    main.sharedObject.flush();
                    break;
                case "Enhanced Item Descriptions":
                    boost = !boost;
                    dispatch(boosts);
                    main.sharedObject.data.boost = boost;
                    main.sharedObject.flush();
                    break;
                case "Show Quest Drop Rates":
                    qRates = !qRates;
                    dispatch(qrates);
                    main.sharedObject.data.qRates = qRates;
                    main.sharedObject.flush();
                    break;
                case "Show Quest Reward Previews":
                    qPrev = !qPrev;
                    dispatch(qprev);
                    main.sharedObject.data.qPrev = qPrev;
                    main.sharedObject.flush();
                    break;
                case "Show Detailed Quest Rewards":
                    detailquest = !detailquest;
                    dispatch(detailquests);
                    main.sharedObject.data.detailquest = detailquest;
                    main.sharedObject.flush();
                    break;
                case "Allow Quest Log Turn-Ins":
                    qLog = !qLog;
                    dispatch(qlog);
                    main.sharedObject.data.qLog = qLog;
                    main.sharedObject.flush();
                    break;
                case "Reaccept Quest After Turn-In":
                    qAccept = !qAccept;
                    dispatch(qaccept);
                    main.sharedObject.data.qAccept = qAccept;
                    main.sharedObject.flush();
                    break;
                case "Quest Pinner":
                    qPin = !qPin;
                    dispatch(qpin);
                    main.sharedObject.data.qPin = qPin;
                    main.sharedObject.flush();
                    break;
                case "Disable Skill Animations":
                    disableSkillAnim = !disableSkillAnim;
                    dispatch(skillanim);
                    main.sharedObject.data.disableSkillAnim = disableSkillAnim;
                    main.sharedObject.flush();
                    break;
                case "Show Your Skill Animations Only":
                    filterChecks["chkSelfOnly"] = !filterChecks["chkSelfOnly"];
                    main.sharedObject.data.filterChecks["chkSelfOnly"] = filterChecks["chkSelfOnly"];
                    main.sharedObject.flush();
                    break;
                case "Custom Skill Animations":
                    cSkillAnim = !cSkillAnim;
                    dispatch(cskillanim);
                    main.sharedObject.data.cSkillAnim = cSkillAnim;
                    main.sharedObject.flush();
                    break;
                case "Disable Monster Animations":
                    disMonAnim = !disMonAnim;
                    dispatch(dismonanim);
                    main.sharedObject.data.disMonAnim = disMonAnim;
                    main.sharedObject.flush();
                    break;
                case "Class Actives/Auras UI":
                    skill = !skill;
                    dispatch(skills);
                    dispatch(targetskills);
                    main.sharedObject.data.skill = skill;
                    main.sharedObject.flush();
                    break;
                case "Freeze / Lock Monster Position":
                    lockm = !lockm;
                    dispatch(lockmons);
                    main.sharedObject.data.lockM = lockm;
                    main.sharedObject.flush();
                    break;
                case "Show Monster Type":
                    mType = !mType;
                    dispatch(monstype);
                    main.sharedObject.data.mType = mType;
                    main.sharedObject.flush();
                    break;
                case "Auto-Untarget Dead Targets":
                    untargetMon = !untargetMon;
                    dispatch(untarget);
                    main.sharedObject.data.untargetMon = untargetMon;
                    main.sharedObject.flush();
                    break;
                case "Auto-Untarget Self-Targetting":
                    selfTarget = !selfTarget;
                    dispatch(untargetself);
                    main.sharedObject.data.selfTarget = selfTarget;
                    main.sharedObject.flush();
                    break;
                case "Custom Drops UI":
                    cDrops = !cDrops;
                    if(cDrops){
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = true;
                    }else{
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = false;
                    }
                    dispatch(dropmenu);
                    main.sharedObject.data.cDrops = cDrops;
                    main.sharedObject.flush();
                    break;
                case "SBP's Custom Drops UI":
                    sbpcDrops = !sbpcDrops;
                    if(sbpcDrops){
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = true;
                    }else{
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = false;
                    }
                    dispatch(dropmenutwo);
                    main.sharedObject.data.sbpcDrops = sbpcDrops;
                    main.sharedObject.flush();
                    break;
                case "Invert Menu":
                    filterChecks["chkInvertDrop"] = !filterChecks["chkInvertDrop"];
                    main.sharedObject.data.filterChecks["chkInvertDrop"] = filterChecks["chkInvertDrop"];
                    main.sharedObject.flush();
                    break;
                case "Hide Players":
                    hideP = !hideP;
                    dispatch(hideplayers);
                    main.sharedObject.data.hideP = hideP;
                    main.sharedObject.flush();
                    break;
                case "Show Name Tags":
                    filterChecks["chkName"] = !filterChecks["chkName"];
                    main.sharedObject.data.filterChecks["chkName"] = filterChecks["chkName"];
                    main.sharedObject.flush();
                    break;
                case "Disable Weapon Animations":
                    disWepAnim = !disWepAnim;
                    dispatch(diswepanim);
                    main.sharedObject.data.disWepAnim = disWepAnim;
                    main.sharedObject.flush();
                    break;
                case "Keep Your Weapon Animations Only":
                    filterChecks["chkDisWepAnim"] = !filterChecks["chkDisWepAnim"];
                    main.sharedObject.data.filterChecks["chkDisWepAnim"] = filterChecks["chkDisWepAnim"];
                    main.sharedObject.flush();
                    break;
                case "Disable Map Animations":
                    disMapAnim = !disMapAnim;
                    dispatch(dismapanim);
                    main.sharedObject.data.disMapAnim = disMapAnim;
                    main.sharedObject.flush();
                    break;
                case "Cache Players":
                    bitmapP = !bitmapP;
                    dispatch(bitmap);
                    main.sharedObject.data.bitmapP = bitmapP;
                    main.sharedObject.flush();
                    break;
                case "Toggle Chat Filter":
                    chatFilter = !chatFilter;
                    dispatch(chatfilter);
                    main.sharedObject.data.chatFilter = chatFilter;
                    main.sharedObject.flush();
                    break;
                case "Hide Red Warning Messages":
                    filterChecks["chkRed"] = !filterChecks["chkRed"];
                    main.sharedObject.data.filterChecks["chkRed"] = filterChecks["chkRed"];
                    main.sharedObject.flush();
                    break;
                case "Hide Blue Server Messages":
                    filterChecks["chkBlue"] = !filterChecks["chkBlue"];
                    main.sharedObject.data.filterChecks["chkBlue"] = filterChecks["chkBlue"];
                    main.sharedObject.flush();
                    break;
                case "Disable Sound FX":
                    disableFX = !disableFX;
                    if(disableFX){
                        main.Game.mixer.stf = new SoundTransform(0);
                    }else{
                        main.Game.mixer.stf = new SoundTransform(1);
                    }
                    main.sharedObject.data.disableFX = disableFX;
                    main.sharedObject.flush();
                    break;
                case "Display FPS":
                    main.Game.ui.mcFPS.visible = !main.Game.ui.mcFPS.visible;
                    break;
                case "Color Picker":
                    if(!colorPickerMC){
                        colorPickerMC = new colorPicker();
                        main._stage.addChild(colorPickerMC);
                    }else{
                        colorPickerMC.visible = !colorPickerMC.visible;
                    }
                    main.Game.ui.mcPopup.onClose();
                    break;
                case "Decline All Drops":
                    if(main.Game.ui.dropStack.numChildren < 1)
                        return;			
                    for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
                        try{
                            main.Game.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            if(cDrops)
                                dropmenu.events.dispatchEvent(new ClientEvent(ClientEvent.onUpdate));
                            if(sbpcDrops)
                                dropmenutwo.events.dispatchEvent(new ClientEvent(ClientEvent.onUpdate));
                        }catch(e){
                            continue;
                        }
                    }
                    break;
                case "Item Drops Blacklist":
                    if(!blackListMC){
                        blackListMC = new blackList();
                        main._stage.addChild(blackListMC);
                    }else{
                        blackListMC.visible = !blackListMC.visible;
                    }
                    main.Game.ui.mcPopup.onClose();
                    break;
                case "Smooth Background":
                    smoothBG = !smoothBG;
                    dispatch(smoothbg);
                    main.sharedObject.data.smoothBG = smoothBG;
                    main.sharedObject.flush();
                    break;
                case "Color Sets":
                    bColorSets = !bColorSets;
                    dispatch(colorsets);
                    main.sharedObject.data.bColorSets = bColorSets;
                    main.sharedObject.flush();
                    break;
                case "Alphabetize Book of Lore":
                    alphaBOL = !alphaBOL;
                    main.sharedObject.data.alphBOL = alphaBOL;
                    main.sharedObject.flush();
                    break;
                case "Hide Monsters":
                    hideM = !hideM;
                    dispatch(hidemonsters);
                    main.sharedObject.data.hideM = hideM;
                    main.sharedObject.flush();
                    break;
                case "Show Shadows":
                    filterChecks["chkShadow"] = !filterChecks["chkShadow"];
                    main.sharedObject.data.filterChecks["chkShadow"] = filterChecks["chkShadow"];
                    main.sharedObject.flush();
                    break;
                case "The Archive":
                    bTheArchive = !bTheArchive;
                    main.sharedObject.data.theArchive = bTheArchive;
                    main.sharedObject.flush();
                    break;
                case "Clean Reputation List":
                    cleanRep = !cleanRep;
                    main.sharedObject.data.cleanRep = cleanRep;
                    main.sharedObject.flush();
                    break;
                default: break;
            }
        }

        public static function dispatch(e:*):void{
            e.events.dispatchEvent(new ClientEvent(ClientEvent.onToggle));
        }

    }
}

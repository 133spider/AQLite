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

        //TO-DO: Change naming convention to bVar
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
        public static var hidePNames:Boolean;
        public static var bBattlePet:Boolean;
        public static var bHouseEntrance:Boolean;
        public static var bDisQuestTracker:Boolean;
        public static var bQuestNotif:Boolean;
        public static var bBankKey:Boolean;
        public static var bDisPetAnim:Boolean;

        public static var filterChecks:Object = new Object();
        public static var blackListed:Array = new Array();

        public static var cameratoolMC:cameratool;
        public static var dropmenuMC:dropmenu;
        public static var dropmenutwoMC:dropmenutwo;
        public static var memoryusageMC:memoryusage;
        public static var skillsMC:skills;
        public static var targetskillsMC:targetskills;

        public static function onCreate():void{
            optionHandler.events.addEventListener(ClientEvent.onEnable, readSettings);
        }

        public static function readSettings():void{
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
            filterChecks["chkInvertDrop"] = main.sharedObject.data.filterChecks["chkInvertDrop"];
            if(main.sharedObject.data.filterChecks["chkShadow"] == null){
                main.sharedObject.data.filterChecks["chkShadow"] = false;
                main.sharedObject.flush();
            }
            filterChecks["chkShadow"] = main.sharedObject.data.filterChecks["chkShadow"];
            if(main.sharedObject.data.filterChecks["chkRedSkills"] == null){
                main.sharedObject.data.filterChecks["chkRedSkills"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkRedSkills"] = main.sharedObject.data.filterChecks["chkRedSkills"];
            if(main.sharedObject.data.filterChecks["chkCDropNotification"] == null){
                main.sharedObject.data.filterChecks["chkCDropNotification"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkCDropNotification"] = main.sharedObject.data.filterChecks["chkCDropNotification"];
            if(main.sharedObject.data.filterChecks["chkGuild"] == null){
                main.sharedObject.data.filterChecks["chkGuild"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkGuild"] = main.sharedObject.data.filterChecks["chkGuild"];
            if(main.sharedObject.data.filterChecks["chkDisPetAnim"] == null){
                main.sharedObject.data.filterChecks["chkDisPetAnim"] = true;
                main.sharedObject.flush();
            }
            filterChecks["chkDisPetAnim"] = main.sharedObject.data.filterChecks["chkDisPetAnim"];
            cDrops = main.sharedObject.data.cDrops;
            if(cDrops){
                dropmenuMC = new dropmenu();
                dropmenuMC.name = "dropmenu";
                main.Game.ui.addChild(dropmenuMC);
            }

            sbpcDrops = main.sharedObject.data.sbpcDrops;
            if(sbpcDrops){
                dropmenutwoMC = new dropmenutwo();
                dropmenutwoMC.name = "dropmenutwo";
                main.Game.ui.addChild(dropmenutwoMC);
            }

            detaildrop = main.sharedObject.data.detaildrop;
            if(detaildrop)
                dispatch(detaildrops);

            qLog = main.sharedObject.data.qLog;
            if(qLog)
                dispatch(qlog);

            skill = main.sharedObject.data.skill;
            if(skill){
                skillsMC = new skills();
                skillsMC.name = "skillsMC";
                main.Game.ui.addChild(skillsMC);
                targetskillsMC = new targetskills();
                targetskillsMC.name = "targetskillsMC";
                main.Game.ui.addChild(targetskillsMC);
            }

            //passive = main.sharedObject.data.passive;
            passive = true;
            if(passive)
                dispatch(passives);

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

            hideM = main.sharedObject.data.hideM;
            if(hideM)
                dispatch(hidemonsters);
            
            hidePNames = main.sharedObject.data.hidePNames;
            if(hidePNames)
                dispatch(hidepnames);

            bHouseEntrance = main.sharedObject.data.bHouseEntrance;
            if(bHouseEntrance)
                dispatch(houseentrance);

            bDisPetAnim = main.sharedObject.data.bDisPetAnim;
            if(bDisPetAnim)
                dispatch(dispetanim);

            bBankKey = main.sharedObject.data.bBankKey;
            draggable = main.sharedObject.data.draggable;
            disableSkillAnim = main.sharedObject.data.disableSkillAnim;
            mType = main.sharedObject.data.mType;
            qRates = main.sharedObject.data.qRates;
            qPrev = main.sharedObject.data.qPrev;
            detailquest = main.sharedObject.data.detailquest;
            boost = main.sharedObject.data.boost;
            untargetMon = main.sharedObject.data.untargetMon;
            selfTarget = main.sharedObject.data.selfTarget;
            qAccept = main.sharedObject.data.qAccept;
            smoothBG = main.sharedObject.data.smoothBG;
            bColorSets = main.sharedObject.data.bColorSets;
            bBattlePet = main.sharedObject.data.bBattlePet;
            alphaBOL = main.sharedObject.data.alphaBOL;
            bTheArchive = main.sharedObject.data.theArchive;
            cleanRep = main.sharedObject.data.cleanRep;
            bDisQuestTracker = main.sharedObject.data.bDisQuestTracker;
            bQuestNotif = main.sharedObject.data.bQuestNotif;
        }

        public static var colorPickerMC:colorPicker;
        public static var blackListMC:blackList;
        public static var travelMenuMC:travelMenu;
        public static function cmd(id:String):void{
            switch(id){
                case "Draggable Drops":
                    draggable = !draggable;
                    main.sharedObject.data.draggable = draggable;
                    main.sharedObject.flush();
                    break;
                case "Detailed Item Drops":
                    detaildrop = !detaildrop;
                    dispatch(detaildrops);
                    main.sharedObject.data.detaildrop = detaildrop;
                    main.sharedObject.flush();
                    break;
                case "Enhanced Item Descriptions":
                    boost = !boost;
                    main.sharedObject.data.boost = boost;
                    main.sharedObject.flush();
                    break;
                case "Quest Drop Rates":
                    qRates = !qRates;
                    main.sharedObject.data.qRates = qRates;
                    main.sharedObject.flush();
                    break;
                case "Quest Reward Previews":
                    qPrev = !qPrev;
                    main.sharedObject.data.qPrev = qPrev;
                    main.sharedObject.flush();
                    break;
                case "Detailed Quest Rewards":
                    detailquest = !detailquest;
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
                    if(!main.Game.ui.getChildByName("skillsMC")){
                        skillsMC = new skills();
                        skillsMC.name = "skillsMC";
                        main.Game.ui.addChild(skillsMC);
                        skillsMC.mouseEnabled = false;
                        targetskillsMC = new targetskills();
                        targetskillsMC.name = "targetskillsMC";
                        main.Game.ui.addChild(targetskillsMC);
                        targetskillsMC.mouseEnabled = false;
                    }else{
                        main.Game.ui.removeChild(main.Game.ui.getChildByName("skillsMC"));
                        main.Game.ui.removeChild(main.Game.ui.getChildByName("targetskillsMC"));
                        skillsMC = null;
                        targetskillsMC = null;
                    }
                    main.sharedObject.data.skill = skill;
                    main.sharedObject.flush();
                    break;
                case "Freeze / Lock Monster Position":
                    lockm = !lockm;
                    dispatch(lockmons);
                    main.sharedObject.data.lockM = lockm;
                    main.sharedObject.flush();
                    break;
                case "Monster Type":
                    mType = !mType;
                    main.sharedObject.data.mType = mType;
                    main.sharedObject.flush();
                    break;
                case "Auto-Untarget Dead Targets":
                    untargetMon = !untargetMon;
                    main.sharedObject.data.untargetMon = untargetMon;
                    main.sharedObject.flush();
                    break;
                case "Auto-Untarget Self-Targetting":
                    selfTarget = !selfTarget;
                    main.sharedObject.data.selfTarget = selfTarget;
                    main.sharedObject.flush();
                    break;
                case "Custom Drops UI":
                    cDrops = !cDrops;
                    if(cDrops){
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = true;
                        dropmenuMC = new dropmenu();
                        dropmenuMC.name = "dropmenu";
                        main.Game.ui.addChild(dropmenuMC);
                    }else{
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = false;
                        dropmenuMC.cleanup();
                        main.Game.ui.removeChild(main.Game.ui.getChildByName("dropmenu"));
                        dropmenuMC = null;
                    }
                    main.sharedObject.data.cDrops = cDrops;
                    main.sharedObject.flush();
                    break;
                case "SBP's Custom Drops UI":
                    sbpcDrops = !sbpcDrops;
                    if(sbpcDrops){
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = true;
                        dropmenutwoMC = new dropmenutwo();
                        dropmenutwoMC.name = "dropmenutwo";
                        main.Game.ui.addChild(dropmenutwoMC);
                    }else{
                        main.Game.ui.mcPortrait.getChildByName("iconDrops").visible = false;
                        dropmenutwoMC.cleanup();
                        main.Game.ui.removeChild(main.Game.ui.getChildByName("dropmenutwo"));
                        dropmenutwoMC = null;
                    }
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
                case "Chat Filter":
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
                case "Display Memory Usage":
                    if(!main.Game.ui.getChildByName("memoryusage")){
                        memoryusageMC = new memoryusage();
                        memoryusageMC.name = "memoryusage";
                        main.Game.ui.addChild(memoryusageMC);
                    }else{
                        memoryusageMC.cleanup();
                        main.Game.ui.removeChild(memoryusageMC);
                        memoryusageMC = null;
                    }
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
                                dropmenuMC.onUpdate();
                            if(sbpcDrops)
                                dropmenutwoMC.onUpdate();
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
                    main.sharedObject.data.smoothBG = smoothBG;
                    main.sharedObject.flush();
                    break;
                case "Color Sets":
                    bColorSets = !bColorSets;
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
                case "Camera Tool":
                    cameratoolMC = new cameratool();
                    cameratoolMC.x = -7;
                    main._stage.addChild(cameratoolMC);
                    main.Game.world.visible = false;
                    break;
                case "Hide Player Names":
                    hidePNames = !hidePNames;
                    dispatch(hidepnames);
                    main.sharedObject.data.hidePNames = hidePNames;
                    main.sharedObject.flush();
                    break;
                case "Disable Skill Warning Messages":
                    filterChecks["chkRedSkills"] = !filterChecks["chkRedSkills"];
                    main.sharedObject.data.filterChecks["chkRedSkills"] = filterChecks["chkRedSkills"];
                    main.sharedObject.flush();
                    break;
                case "Drop Notifications":
                    filterChecks["chkCDropNotification"] = !filterChecks["chkCDropNotification"];
                    main.sharedObject.data.filterChecks["chkCDropNotification"] = filterChecks["chkCDropNotification"];
                    main.sharedObject.flush();
                    break;
                case "Battlepets":
                    bBattlePet = !bBattlePet;
                    main.sharedObject.data.bBattlePet = bBattlePet;
                    main.sharedObject.flush();
                    break;
                case "House Entrance Teleport":
                    bHouseEntrance = !bHouseEntrance;
                    dispatch(houseentrance);
                    main.sharedObject.data.bHouseEntrance = bHouseEntrance;
                    main.sharedObject.flush();
                    break;
                case "Reset Position":
                    if(sbpcDrops){
                        dropmenutwoMC.resetPos();
                    }
                    break;
                case "Hide Guild Names Only":
                    filterChecks["chkGuild"] = !filterChecks["chkGuild"];
                    main.sharedObject.data.filterChecks["chkGuild"] = filterChecks["chkGuild"];
                    main.sharedObject.flush();
                    break;
                case "Disable Quest Tracker":
                    bDisQuestTracker = !bDisQuestTracker;
                    main.sharedObject.data.bDisQuestTracker = bDisQuestTracker;
                    main.sharedObject.flush();
                    break;
                case "Quest Progress Notifications":
                    bQuestNotif = !bQuestNotif;
                    main.sharedObject.data.bQuestNotif = bQuestNotif;
                    main.sharedObject.flush();
                    break;
                case "Open Bank with Keybind":
                    bBankKey = !bBankKey;
                    main.sharedObject.data.bBankKey = bBankKey;
                    main.sharedObject.flush();
                    break;
                case "Disable Pet Animations":
                    bDisPetAnim = !bDisPetAnim;
                    dispatch(dispetanim);
                    main.sharedObject.data.bDisPetAnim = bDisPetAnim;
                    main.sharedObject.flush();
                    break;
                case "Keep Your Pet Animations Only":
                    filterChecks["chkDisPetAnim"] = !filterChecks["chkDisPetAnim"];
                    main.sharedObject.data.filterChecks["chkDisPetAnim"] = filterChecks["chkDisPetAnim"];
                    main.sharedObject.flush();
                    break;
                case "Travel Menu":
                    if(!travelMenuMC){
                        travelMenuMC = new travelMenu();
                        main._stage.addChild(travelMenuMC);
                    }else{
                        travelMenuMC.visible = !travelMenuMC.visible;
                    }
                    break;
                default: break;
            }
        }

        public static function dispatch(e:*):void{
            e.onToggle();
        }

        public static function oldDispatch(e:*):void{
            e.events.dispatchEvent(new ClientEvent(ClientEvent.onToggle));
        }

    }
}

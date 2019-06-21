package net.spider.draw
{
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.system.*;
  import flash.ui.*;
  import flash.utils.*;
  import flash.external.ExternalInterface;
  import flash.geom.ColorTransform;
  import flash.text.TextField;
  import net.spider.draw.listQuestItem;
  import net.spider.main;
   
   public class theArchive extends MovieClip
   {
      public var quest;
      
      public var questListItem:listQuestItem;
      
      public var Len:int;
      
      public var questCount:int;
      
      public var hRun:Number;
      
      public var dRun:Number;
      
      public var oy:Number;
      
      public var mDown:Boolean;
      
      public var mbY:int;
      
      public var mbD:int;
      
      public var mhY:int;
      
      public var pos:int;

      public var i:int;
      
      public function onPrev(e:MouseEvent):void{
         preview.imgMask.visible = false;
         preview.imgMaskMask.visible = false;
         preview.imgMask.scaleX = preview.imgMask.scaleY = 1;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
         loader.load(new URLRequest(zPrev));
         preview.visible = true;
      }

      public function onTravel(e:MouseEvent):void{
          main.Game.world.gotoTown(activeMap,"Enter","Spawn");
          main._stage.removeEventListener(MouseEvent.MOUSE_UP,onScrUp);
          main._stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
          SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN,onScrDown);
          questList.removeEventListener(Event.ENTER_FRAME,hEF);
          questList.removeEventListener(Event.ENTER_FRAME,dEF);
          this.parent.removeChild(this);
      }

      public function onClose(e:MouseEvent):void{
         if(preview.imgMask.numChildren > 1)
            preview.imgMask.removeChildAt(0);
         preview.visible = false;
      }

      public function onQuit(e:MouseEvent):void{
          main._stage.removeEventListener(MouseEvent.MOUSE_UP,onScrUp);
          main._stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
          SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN,onScrDown);
          questList.removeEventListener(Event.ENTER_FRAME,hEF);
          questList.removeEventListener(Event.ENTER_FRAME,dEF);
          this.parent.removeChild(this);
      }

      public function theArchive()
      {
         preview.imgMask.visible = false;
         preview.imgMaskMask.visible = false;
         this.btPreview.addEventListener(MouseEvent.CLICK, onPrev, false, 0, true);
         this.preview.btnClose.addEventListener(MouseEvent.CLICK, onClose, false, 0, true);
         this.btTravel.addEventListener(MouseEvent.CLICK, onTravel, false, 0, true);
         this.btnQuit.addEventListener(MouseEvent.CLICK, onQuit, false, 0, true);
         this.btnBack.addEventListener(MouseEvent.CLICK, onQuit, false, 0, true);
         preview.visible = false;
         //Security.allowDomain("*");
         var questsGet:Array = [
            {
              strName: "Willowcreek",
              strMap: "willowcreek",
              strType: "F",
              strDesc: "A notable area for the first non-member pet in AQWorlds.\nThis was also the place to farm easy exp to the max level 20 before it got nerfed or whatever.\n\nThis was where Xyo reached the max level 20.",
              strPrev: "https://i.imgur.com/CsndZ5m.png"
            },
            {
              strName: "Cysero's Clubhouse",
              strMap: "clubhouse",
              strType: "M",
              strDesc: "Released in October 10, 2008.\nA once popular and nostalgic area for members. Sadly, the place is now a ghost town.\n\nYou can also get Cysero's Defender weapon sets here.",
              strPrev: "http://i.imgur.com/8Lime0G.png"
            },
            {
              strName: "Twilight",
              strMap: "twilight",
              strType: "M",
              strDesc: "Released in October 10, 2008.\nA notable area for the monster called \"Abaddon\" that drops pretty cool items designed by Miltonius.",
              strPrev: "http://i.imgur.com/VGd3IRW.png"
            },
            {
              strName: "Bludrut Keep",
              strMap: "bludrut",
              strType: "F",
              strDesc: "Released in October 22, 2008.\nPretty fun release when it came out. Also, really cool items designed by Miltonius.\n\nCheck out Xyo's video on Bludrut!",
              strPrev: "http://i.imgur.com/LXmS8PB.png"
            },
            {
              strName: "Lair",
              strMap: "lair",
              strType: "F",
              strDesc: "Released in November 06, 2008.\nA place to get cool wings, swords, and rare weekly drops (check Design Notes).\n\nFun fact: It's an AE tradition in all of their games for the Dragonslayer class to be horrible at slaying dragons. Though, DragonFable broke that tradition by finally buffing it to a Dragonslaying monster.",
              strPrev: "http://aqwwiki.wdfiles.com/local--files/lair/LairRoom1.png"
            },
            {
              strName: "Crash Site",
              strMap: "crashsite",
              strType: "F",
              strDesc: "Released in November 21, 2008.\nProtosartorium, Rustbucket, and Enforcer were the top tier classes with the Event Horizon invincibility bug.\n\nWas also a great place to farm gold back then.",
              strPrev: "http://i.imgur.com/3dTF4ie.png"
            },
            {
              strName: "Death",
              strMap: "death",
              strType: "F",
              strDesc: "Released in December 05, 2008.\nWhere you turn your baby dragon into a dracolich!\nThis was released around the time Chuckles Skull was a common pet to see in AQW.",
              strPrev: "http://i.imgur.com/7ihAQgf.png"
            },
            {
              strName: "Citadel",
              strMap: "citadel",
              strType: "F",
              strDesc: "Released in December 05, 2008.\nThis map was not completed until February 06, 2009.\n\nPretty cool gear was released on this map. This was where Miltonius started to become a common household name. He released tercessuinotlim on this map in secret (even behind AE's back).\n\nLater had his name changed to Nulgath.",
              strPrev: "https://i.imgur.com/cY3WJXZ.png"
            },
            {
              strName: "New Years",
              strMap: "newyear",
              strType: "F",
              strDesc: "Released in December 30, 2009.\nThe goto-map to celebrate New Years every year in AQWorlds.\n\nOnly accessible on New Years.",
              strPrev: "https://i.imgur.com/h0QHnl3.png"
            },
            {
              strName: "Portal Undead",
              strMap: "portalundead",
              strType: "F",
              strDesc: "Released in February 06, 2009.\nBack then, the daily quest \"Burn it down\" gave a sellable staff for 12500 gold.\n\nIt *was* a hotspot for gold farming.",
              strPrev: "https://i.imgur.com/6rgSJly.png"
            },
            {
              strName: "Prison",
              strMap: "prison",
              strType: "F",
              strDesc: "Released in February 27, 2009.\nYou stole gold from a pig.\n\nFamous place for AQWMV and fan-made AQW series.",
              strPrev: "https://i.imgur.com/4WDLWZ3.png"
            },
            {
              strName: "Forest of Chaos",
              strMap: "forestchaos",
              strType: "F",
              strDesc: "Released in March 06, 2009.\nA chaos bear that dropped cool bear gear.",
              strPrev: "http://i.imgur.com/qy59F9B.png"
            },
            {
              strName: "Chaos Marsh",
              strMap: "chaosmarsh",
              strType: "F",
              strDesc: "Released in March 27, 2009.",
              strPrev: "http://i.imgur.com/dtrSdSO.png"
            },
            {
              strName: "Relativity",
              strMap: "relativity",
              strType: "F",
              strDesc: "Released in May 08, 2009.\nThe area that leads to the unskippable and long annoying cutscene of /sneek.",
              strPrev: "http://i.imgur.com/ZvW8x0I.png"
            },
            {
              strName: "Upper Dwarfhold",
              strMap: "uppercity",
              strType: "F",
              strDesc: "Released in August 07, 2009.\nThere are some great Drow gear being sold on this map.",
              strPrev: "http://i.imgur.com/2yIDQCR.png"
            },
            {
              strName: "Old King Coal",
              strMap: "kingcoal",
              strType: "F",
              strDesc: "Released in December 18, 2009.\nLots of people did solo videos at this place. Especially during the first PTR with DoomKnight and Necromancer.",
              strPrev: "http://i.imgur.com/T4F8lKD.png"
            },
            {
              strName: "Theater",
              strMap: "theater",
              strType: "F",
              strDesc: "Released in January 09, 2009.\nThe place where people recorded with their unregistered hypercams 2",
              strPrev: "https://i.imgur.com/8yKewgY.png"
            },
            {
              strName: "Newbie",
              strMap: "newbie",
              strType: "F",
              strDesc: "Released in January 23, 2009.\nThe first tutorial in the game where the Platinum Axe of Destiny was given for free.\n\nUnvisited and forgotten.",
              strPrev: "http://i.imgur.com/9LkKTNe.png"
            },
            {
              strName: "Ballyhoo",
              strMap: "ballyhoo",
              strType: "F",
              strDesc: "Released in October 24, 2009.\nA chance to get free ACs.",
              strPrev: "http://i.imgur.com/VMvByx0.png"
            },
            {
              strName: "Ruins",
              strMap: "ruins",
              strType: "F",
              strDesc: "A very, very old map.",
              strPrev: "http://i.imgur.com/Q7JqnEl.png"
            },
            {
              strName: "Evil Marsh",
              strMap: "evilmarsh",
              strType: "F",
              strDesc: "A very, very old map.",
              strPrev: "https://i.imgur.com/jurTVxm.png"
            },
            {
              strName: "Graveyard",
              strMap: "graveyard",
              strType: "F",
              strDesc: "A very, very old map.\nJacksprat.",
              strPrev: "http://i.imgur.com/4EYsddP.png"
            },
            {
              strName: "Guru Forest",
              strMap: "guru",
              strType: "F",
              strDesc: "A very, very old map.\nForgotten.",
              strPrev: "http://i.imgur.com/K8ChhAh.png"
            },
            {
              strName: "Swordhaven Bridge",
              strMap: "swordhavenbridge",
              strType: "F",
              strDesc: "Replaced the very old map known as /bridge that had undead on it.",
              strPrev: "https://i.imgur.com/yQf0VS7.png"
            },
            {
              strName: "Sewer",
              strMap: "sewer",
              strType: "F",
              strDesc: "Underneath Swordhaven",
              strPrev: "http://i.imgur.com/oQI8oX4.png"
            },
            {
              strName: "Forest",
              strMap: "forest",
              strType: "F",
              strDesc: "Zards everywhere.",
              strPrev: "http://i.imgur.com/418tsbY.png"
            },
            {
              strName: "Noobshire",
              strMap: "noobshire",
              strType: "F",
              strDesc: "Old newbie place.",
              strPrev: "http://i.imgur.com/zyRCae4.png"
            },
            {
              strName: "Marsh",
              strMap: "marsh",
              strType: "F",
              strDesc: "The first ever look at a Necromancer armor in AQW worn by an NPC.",
              strPrev: "http://i.imgur.com/OC6DgF6.png"
            },
            {
              strName: "Marsh2",
              strMap: "marsh2",
              strType: "F",
              strDesc: "Thrax's ironhide sword was the cool kid's weapon.",
              strPrev: "http://i.imgur.com/rkF3kLT.png"
            },
            {
              strName: "Farm",
              strMap: "farm",
              strType: "F",
              strDesc: "People did music videos here... yeah...",
              strPrev: "https://i.imgur.com/2mUxiYm.png"
            },
            {
              strName: "Shallows",
              strMap: "shallow",
              strType: "F",
              strDesc: "Water elemental's map",
              strPrev: "https://i.imgur.com/1CwzzoI.png"
            },
            {
              strName: "Horc Fort",
              strMap: "orctown",
              strType: "F",
              strDesc: "Unregistered Hypercam 2 solos big green orc",
              strPrev: "http://i.imgur.com/V8vC5WB.png"
            },
            {
              strName: "Lolosia",
              strMap: "pirates",
              strType: "F",
              strDesc: "Was a simple map to get a cool blue wave sword and the pirate class before it got hella expanded to make room for more $pirate naval content$.",
              strPrev: "https://i.imgur.com/yQqM3NL.png"
            },
            {
              strName: "Nulgath",
              strMap: "nulgath",
              strType: "M",
              strDesc: "Released in April 23, 2010.\nSecret Map.\nUsed to be /miltonius.",
              strPrev: "https://i.imgur.com/9DIEPT1.png"
            },
            {
              strName: "Pencil Puddle",
              strMap: "j6",
              strType: "F",
              strDesc: "Released in June 04, 2010.\nThe start of J6's saga.\n\nSome cool sketch items, I guess?",
              strPrev: "http://i.imgur.com/LNZgPTo.png"
            },
            {
              strName: "Hollowsoul Castle",
              strMap: "hollowcastle",
              strType: "M",
              strDesc: "Released in July 02, 2010.\nWeird ghosts, but a cool knight armor.",
              strPrev: "http://i.imgur.com/zxOT7RJ.png"
            },
            {
              strName: "Haunted Halls",
              strMap: "hollowhalls",
              strType: "M",
              strDesc: "Released in November 12, 2010.\nConfusing.",
              strPrev: "http://i.imgur.com/yoYOwNu.png"
            },
            {
              strName: "Giant Tale",
              strMap: "giant",
              strType: "F",
              strDesc: "Released in July 09, 2010.",
              strPrev: "https://i.imgur.com/jQYrz8I.png"
            },
            {
              strName: "Smuurvil",
              strMap: "smuurvil",
              strType: "F",
              strDesc: "Released in July 16, 2010.\nThe Smurfs parody.",
              strPrev: "http://i.imgur.com/tnm6aaZ.png"
            },
            {
              strName: "Andre",
              strMap: "andre",
              strType: "F",
              strDesc: "Released in July 30, 2010.\nCool storm armor.",
              strPrev: "http://i.imgur.com/76JbP2q.png"
            },
            {
              strName: "Airship",
              strMap: "airship",
              strType: "F",
              strDesc: "Released in November 19, 2010.\nCool dragon weapon set drops.",
              strPrev: "http://i.imgur.com/zCZ5CfW.png"
            },
            {
              strName: "Void",
              strMap: "void",
              strType: "F",
              strDesc: "Released in December 10, 2010.",
              strPrev: "http://i.imgur.com/8657T99.png"
            },
            {
              strName: "Tunnel",
              strMap: "tunnel",
              strType: "M",
              strDesc: "Released in March 26, 2010.",
              strPrev: "https://i.imgur.com/rlOPR9K.png"
            },
            {
              strName: "Fear War",
              strMap: "creepy",
              strType: "M",
              strDesc: "Released in April 08, 2011.",
              strPrev: "http://i.imgur.com/HMy3Zaf.png"
            },
            {
              strName: "Concert",
              strMap: "concert",
              strType: "M",
              strDesc: "Released in April 15, 2011.",
              strPrev: "http://i.imgur.com/AqO7xdF.png"
            },
            {
              strName: "DragonPlane",
              strMap: "dragonplane",
              strType: "F",
              strDesc: "Released in November 11, 2011.",
              strPrev: "https://i.imgur.com/mGP0bdb.png"
            },
            {
              strName: "GameHaven",
              strMap: "gamehaven",
              strType: "M",
              strDesc: "Released in January 28, 2011.",
              strPrev: "http://i.imgur.com/TzXZVl0.png"
            },
            {
              strName: "Glow Map",
              strMap: "glowmap",
              strType: "F",
              strDesc: "Released in November 01, 2013.",
              strPrev: "http://i.imgur.com/AVBw3NQ.png"
            },
            {
              strName: "Ravenscar",
              strMap: "ravenscar",
              strType: "F",
              strDesc: "Released in May 03, 2013.",
              strPrev: "http://i.imgur.com/dxK9aPG.png"
            },
            {
              strName: "Battle Wedding",
              strMap: "battlewedding",
              strType: "F",
              strDesc: "Released in December 13, 2013.",
              strPrev: "http://i.imgur.com/Dwr2TL6.png"
            },
            {
              strName: "Shadow Gates",
              strMap: "shadowgates",
              strType: "F",
              strDesc: "Released in January 10, 2014.",
              strPrev: "http://i.imgur.com/uMQHVfq.png"
            },
            {
              strName: "Chaos North",
              strMap: "chaosnorth",
              strType: "M",
              strDesc: "Released in June 27, 2014.",
              strPrev: "http://i.imgur.com/s2tSzDE.png"
            },
            {
              strName: "Chaos Beast Gauntlet",
              strMap: "chaosbeast",
              strType: "F",
              strDesc: "Released in July 03, 2014.",
              strPrev: "http://i.imgur.com/Ku0trGW.png"
            },
            {
              strName: "Bloodrun",
              strMap: "bloodrun",
              strType: "F",
              strDesc: "Released in October 24, 2014.",
              strPrev: "http://i.imgur.com/Gh6KtIN.png"
            },
            {
              strName: "Horde",
              strMap: "horde",
              strType: "F",
              strDesc: "Released in October 24, 2014.",
              strPrev: "http://i.imgur.com/v3BJmDZ.png"
            },
            {
              strName: "Mortis",
              strMap: "mortis",
              strType: "F",
              strDesc: "Released in October 24, 2014.",
              strPrev: "http://i.imgur.com/pDYG1rh.png"
            },
            {
              strName: "Nyx",
              strMap: "nyx",
              strType: "F",
              strDesc: "Released in October 24, 2014.",
              strPrev: "http://i.imgur.com/woeSyGc.png"
            },
            {
              strName: "Umbral",
              strMap: "umbral",
              strType: "F",
              strDesc: "Released in October 24, 2014.",
              strPrev: "http://i.imgur.com/41vTUrm.png"
            },
            {
              strName: "Eternal Night",
              strMap: "eternalnight",
              strType: "F",
              strDesc: "Released in October 17, 2014.",
              strPrev: "http://i.imgur.com/CZzSLbk.png"
            },
            {
              strName: "Lair Cross",
              strMap: "laircross",
              strType: "F",
              strDesc: "Released in November 21, 2014.",
              strPrev: "https://i.imgur.com/qrBvkzE.png"
            },
            {
              strName: "Dark Dungeon",
              strMap: "darkdungeon",
              strType: "F",
              strDesc: "Released in May 16, 2014.",
              strPrev: "http://i.imgur.com/oFdhFvq.png"
            },
            {
              strName: "Za'Nar Lobby",
              strMap: "zanarlobby",
              strType: "F",
              strDesc: "Released in January 16, 2015.",
              strPrev: "http://i.imgur.com/4vB2wUm.png"
            },
            {
              strName: "Shipwreck",
              strMap: "shipwreck",
              strType: "F",
              strDesc: "Released in August 07, 2015.",
              strPrev: "http://i.imgur.com/CtZrzIM.png"
            },
            {
              strName: "Goose",
              strMap: "goose",
              strType: "F",
              strDesc: "Released in July 31, 2015.",
              strPrev: "http://i.imgur.com/NxexYZn.png"
            },
            {
              strName: "Hero Lobby",
              strMap: "herolobby",
              strType: "F",
              strDesc: "Released in June 05, 2015.",
              strPrev: "http://i.imgur.com/80ruGBJ.png"
            },
            {
              strName: "Hero Tournament",
              strMap: "herotournament",
              strType: "F",
              strDesc: "Released in June 05, 2015.",
              strPrev: "http://i.imgur.com/NffrGGy.png"
            },
            {
              strName: "Collection",
              strMap: "collection",
              strType: "F",
              strDesc: "Released in July 10, 2015.",
              strPrev: "http://i.imgur.com/29tpBgG.png"
            },
            {
              strName: "Evil War",
              strMap: "evilwar",
              strType: "F",
              strDesc: "Released in July 10, 2015.",
              strPrev: "http://i.imgur.com/BnxxEkj.png"
            },
            {
              strName: "On the Run",
              strMap: "ontherun",
              strType: "F",
              strDesc: "Released in August 07, 2015.",
              strPrev: "http://i.imgur.com/UPmipYO.png"
            },
            {
              strName: "Starsinc Fortress",
              strMap: "starsinc",
              strType: "F",
              strDesc: "Released in August 14, 2015.",
              strPrev: "http://i.imgur.com/GLptiIm.png"
            },
            {
              strName: "Bright Fortress",
              strMap: "brightfortress",
              strType: "F",
              strDesc: "Released in August 21, 2015.",
              strPrev: "http://i.imgur.com/7NzuJ53.png"
            },
            {
              strName: "Third Spell",
              strMap: "thirdspell",
              strType: "F",
              strDesc: "Released in August 28, 2015.",
              strPrev: "http://i.imgur.com/pq1RsVM.png"
            },
            {
              strName: "Dragon Road",
              strMap: "dragonroad",
              strType: "F",
              strDesc: "Released in September 25, 2015.\nThe home of the Starswords.\n\nUpholder badge required to access.",
              strPrev: "http://i.imgur.com/Fh22Git.png"
            },
            {
              strName: "Darkovia Horde",
              strMap: "darkoviahorde",
              strType: "F",
              strDesc: "Released in October 23, 2015.\nKill 100 zombies to get the Zombie Slayer badge.",
              strPrev: "http://i.imgur.com/eEwQqMJ.png"
            },
            {
              strName: "ShadowBlast Arena",
              strMap: "shadowblast",
              strType: "F",
              strDesc: "Released in January 08, 2016.",
              strPrev: "http://i.imgur.com/4ZOInrc.png"
            },
            {
              strName: "Battle Fowl",
              strMap: "battlefowl",
              strType: "F",
              strDesc: "Released in February 17, 2016.\nChickencows.",
              strPrev: "http://i.imgur.com/oOPK1PM.png"
            },
            {
              strName: "Delta V Core",
              strMap: "deltavcore",
              strType: "F",
              strDesc: "Released in February 26, 2016.",
              strPrev: "http://i.imgur.com/4Z2NrQA.png"
            },
            {
              strName: "Delta V Lab",
              strMap: "deltavlab",
              strType: "F",
              strDesc: "Released in February 26, 2016.",
              strPrev: "https://i.imgur.com/zlUp5Ks.png"
            },
            {
              strName: "HeroMart",
              strMap: "heromart",
              strType: "F",
              strDesc: "Released in July 15, 2016.",
              strPrev: "http://i.imgur.com/6pCC1Cb.png"
            },
            {
              strName: "Castle Tunnels",
              strMap: "castletunnels",
              strType: "F",
              strDesc: "Released in July 22, 2016.",
              strPrev: "http://i.imgur.com/qUuv846.png"
            },
            {
              strName: "Dragon Town",
              strMap: "dragontown",
              strType: "F",
              strDesc: "Released in August 05, 2016.\nEvolved Dragonslayer Class and gear!",
              strPrev: "http://i.imgur.com/wXIaJYH.png"
            },
            {
              strName: "Draco Con",
              strMap: "dracocon",
              strType: "F",
              strDesc: "Released in September 02, 2016.",
              strPrev: "http://i.imgur.com/uxLAbnD.png"
            },
            {
              strName: "Laken",
              strMap: "laken",
              strType: "F",
              strDesc: "Released in January 20, 2017.",
              strPrev: "http://i.imgur.com/YODR7ZT.png"
            },
            {
              strName: "Djinn Guard",
              strMap: "djinnguard",
              strType: "F",
              strDesc: "Released in January 20, 2017.",
              strPrev: "https://i.imgur.com/v0aAIla.png"
            },
            {
              strName: "Djinn Gate",
              strMap: "djinngate",
              strType: "F",
              strDesc: "Released in January 20, 2017.",
              strPrev: "https://i.imgur.com/ERCuzkd.png"
            },
            {
              strName: "World Soul",
              strMap: "worldsoul",
              strType: "F",
              strDesc: "Released in March 23, 2018.",
              strPrev: "https://i.imgur.com/mHUQzTX.png"
            },
            {
              strName: "Fire War",
              strMap: "firewar",
              strType: "F",
              strDesc: "Released in May 11, 2018.",
              strPrev: "https://i.imgur.com/0ZyiXua.png"
            },
            {
              strName: "Drakonnan",
              strMap: "drakonnan",
              strType: "F",
              strDesc: "Released in May 25, 2018.",
              strPrev: "https://i.imgur.com/vVicNDQ.png"
            },
            {
              strName: "North Mountain",
              strMap: "northmountain",
              strType: "F",
              strDesc: "Released in May 18, 2018.",
              strPrev: "https://i.imgur.com/JDVdRkC.png"
            },
            {
              strName: "Scarsgarde Keep",
              strMap: "scarsgarde",
              strType: "F",
              strDesc: "Released in June 08, 2018.",
              strPrev: "https://i.imgur.com/0LUxpSc.png"
            },
            {
              strName: "Valley of Doom",
              strMap: "valleyofdoom",
              strType: "F",
              strDesc: "Released in June 15, 2018.",
              strPrev: "https://i.imgur.com/84Bn9fP.png"
            },
            {
              strName: "Valen's Choice",
              strMap: "valenschoice",
              strType: "F",
              strDesc: "Released in June 22, 2018.",
              strPrev: "https://i.imgur.com/WrFzNix.png"
            },
            {
              strName: "Guardian Tower B",
              strMap: "guardiantowerb",
              strType: "F",
              strDesc: "Released in June 29, 2018.",
              strPrev: "https://i.imgur.com/YsFG0ZR.png"
            },
            {
              strName: "NibbleOn",
              strMap: "nibbleon",
              strType: "F",
              strDesc: "Released in February 16, 2018.",
              strPrev: "https://i.imgur.com/3caJ4uy.png"
            },
            {
              strName: "Infernal Spire",
              strMap: "infernalspire",
              strType: "F",
              strDesc: "Released in September 09, 2016.",
              strPrev: "http://i.imgur.com/zgSgjMN.png"
            },
            {
              strName: "SkyTower Aegis",
              strMap: "skytower",
              strType: "F",
              strDesc: "Released in March 11, 2016.",
              strPrev: "http://i.imgur.com/U8CU1RT.png"
            },
            {
              strName: "White Map",
              strMap: "whitemap",
              strType: "F",
              strDesc: "White Map.",
              strPrev: "https://i.imgur.com/Nf2zPVJ.png"
            },
            {
              strName: "Green Screen",
              strMap: "greenscreen",
              strType: "F",
              strDesc: "Green Screen.",
              strPrev: "https://i.imgur.com/OVxBuwh.png"
            },
            {
              strName: "Pink Map",
              strMap: "pinkmap",
              strType: "F",
              strDesc: "Pink Map.",
              strPrev: "http://i.imgur.com/ovp4aeS.png"
            },
            {
              strName: "White Mob",
              strMap: "whitemob",
              strType: "F",
              strDesc: "White Mob.",
              strPrev: "https://i.imgur.com/WoUq4G7.png"
            },
            {
              strName: "Party",
              strMap: "party",
              strType: "F",
              strDesc: "Party.",
              strPrev: "http://i.imgur.com/nNpmv2T.png"
            },
            {
              strName: "Chess Map",
              strMap: "chessmap",
              strType: "F",
              strDesc: "Chess.",
              strPrev: "http://i.imgur.com/CsWs8UV.png"
            },
            {
              strName: "Artist Alley",
              strMap: "artistalley",
              strType: "F",
              strDesc: "Really good gear. Worth looking into.",
              strPrev: "http://i.imgur.com/jCkZWQG.png"
            },
            {
              strName: "Vendor Booths",
              strMap: "vendorbooths",
              strType: "F",
              strDesc: "Really good gear based off of AE's other games. Worth looking into.",
              strPrev: "http://i.imgur.com/1mgt4KL.png"
            },
            {
              strName: "HeroSmash World Premiere",
              strMap: "hsmovie",
              strType: "F",
              strDesc: "Forgotten, but still here!",
              strPrev: "http://i.imgur.com/wnGRg5l.png"
            },
            {
              strName: "Nursery",
              strMap: "nursery",
              strType: "F",
              strDesc: "Released in June 14, 2019.\nQuest for Sepulchure himself and see Gravelyn as a baby.",
              strPrev: "https://i.imgur.com/N4pVLAJ.png"
            }
         ];
         Len = questsGet.length;
         questsGet.sortOn("strName");
         i = 0;
         while(i < Len)
         {
            quest = questsGet[i];
            questListItem = new listQuestItem();
            questListItem.QuestName.text = quest.strName;
            if(quest.strType != "M")
            {
               questListItem.MemberIcon.visible = false;
            }
            if(quest.strMap != null)
            {
               questListItem.strMap = quest.strMap;
               questListItem.strPrev = quest.strPrev;
               questListItem.strName = quest.strName;
               questListItem.strDesc = quest.strDesc;
               questListItem.addEventListener(MouseEvent.CLICK,onQuestsClick,false,0,true);
               questListItem.buttonMode = true;
            }
            questListItem.x = 400;
            questListItem.y = (-35) + (70 * i);
            questList.addChild(questListItem);
            i++;
         }
         questList.mask = cntMask;
         mDown = false;
         hRun = SBar.bar.b.height - SBar.h.height;
         dRun = questList.height - cntMask.height + 5;
         oy = questList.y;
         SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,onScrDown,false,0,true);
         main._stage.addEventListener(MouseEvent.MOUSE_UP,onScrUp,false,0,true);
         main._stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
         questList.addEventListener(Event.ENTER_FRAME,hEF,false,0,true);
         questList.addEventListener(Event.ENTER_FRAME,dEF,false,0,true);

         activeMap = questsGet[0].strMap;
         txtZoneName.text = questsGet[0].strName;
         txtZoneDesc.text = questsGet[0].strDesc;
         zPrev = questsGet[0].strPrev;
      }
      
      var zPrev:String;
      var activeMap:String;
      public function onQuestsClick(param1:MouseEvent) : void
      {
         trace(param1.currentTarget.strMap);
         activeMap = param1.currentTarget.strMap;
         txtZoneName.text = param1.currentTarget.strName;
         txtZoneDesc.text = param1.currentTarget.strDesc;
         zPrev = param1.currentTarget.strPrev;
      }

      function onComplete(e:Event):void {
         var movie:* = e.currentTarget.content;
         preview.imgMask.addChild(movie);
         preview.imgMask.mask = preview.imgMaskMask;
         preview.imgMask.visible = true;
         preview.imgMaskMask.visible = true;
      }

      public function onWheel(e:MouseEvent):void{
        var _local2:*;
        _local2 = SBar;
        _local2.h.y = int(SBar.h.y) + (e.delta * -1);
        if (((_local2.h.y + 4.75) + _local2.h.height) > (_local2.bar.b.height + 4.75)){
          _local2.h.y = int(((_local2.bar.b.height + 4.75) - _local2.h.height));
        };
        if (_local2.h.y < 4.75){
          _local2.h.y = 4.75;
        };
      }
      
      var sDown:Boolean;
      public function onScrDown(param1:MouseEvent) : *
      {
         mbY = int(mouseY);
         mhY = int(SBar.h.y);
         mDown = true;
      }
      
      public function onScrUp(param1:MouseEvent) : void
      {
         mDown = false;
      }
      
      public function hEF(_arg1:Event){
         var _local2:*;
         if (mDown){
               _local2 = SBar;
               mbD = (int(mouseY) - mbY);
               _local2.h.y = (mhY + mbD);
               if (((_local2.h.y + 4.75) + _local2.h.height) > (_local2.bar.b.height + 4.75)){
                  _local2.h.y = int(((_local2.bar.b.height + 4.75) - _local2.h.height));
               };
               if (_local2.h.y < 4.75){
                  _local2.h.y = 4.75;
               };
         };
      }

      public function dEF(_arg1:Event){
         var _local2:* = SBar;
         var _local3:* = questList;
         var _local4:* = (-((_local2.h.y - 4.75)) / hRun);
         var _local5:* = (int((_local4 * dRun)) + oy);
         if (Math.abs((_local5 - _local3.y)) > 0.2){
               _local3.y = (_local3.y + ((_local5 - _local3.y) / 4));
         } else {
               _local3.y = _local5;
         };
      }
   }
}

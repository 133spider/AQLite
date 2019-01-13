package net.spider{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import net.spider.handlers.modules;
	import net.spider.handlers.dropmenu;

	public class main extends MovieClip{
		public static var Game:Object;
		
		var sURL = "https://game.aq.com/game/";
		var gameFile = "gameversion.asp";
		
		var sFile;
		
		var versionLoader:URLLoader;
		var swfLoader:Loader;
		var swfRequest:URLRequest;
		
		var titleDomain:ApplicationDomain;
		var loginURL:String = "https://game.aq.com/game/cf-userlogin.asp";
		var sBG:String;
		
		public function main(){
			this.addEventListener(Event.ADDED_TO_STAGE, stageHandler);
		}
		
		private function stageHandler(e:Event):void{
			addFrameScript(0, frame1);
		}
		
		public function frame1():void {
			Security.allowDomain("*");
			Security.loadPolicyFile("https://game.aq.com/crossdomain.xml");
			stop();
			GetVersion();
		}
		
		function LoadGame()
		{
			swfLoader = new Loader();
			swfRequest = new URLRequest(sURL + "gamefiles/" + sFile);
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onGameComplete);
			swfLoader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
			swfLoader.load(swfRequest, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private var waitForLogin:Timer = new Timer(0);
		function onGameComplete(loadEvent:Event)
		{
			stage.addChildAt(MovieClip(loadEvent.currentTarget.content), 0);
			loadEvent.currentTarget.content.y = 0.0;
			loadEvent.currentTarget.content.x = 0.0;
			Game = Object(loadEvent.currentTarget.content);
			for (var v:* in root.loaderInfo.parameters)
            {
                trace(((v + ": ") + root.loaderInfo.parameters[v]));
                Game.params[v] = root.loaderInfo.parameters[v];
            };
			Game.params.sURL = sURL;
			Game.params.sTitle = "AQLite";
			Game.params.isWeb = false;
			Game.params.doSignup = false;
			Game.params.loginURL = loginURL;
			Game.params.sBG = this.sBG;
			Game.titleDomain = this.titleDomain;
			waitForLogin.addEventListener(TimerEvent.TIMER, onWait);
			waitForLogin.start();
		}
		
		function onWait(e:TimerEvent):void{
			if(Game.sfc.isConnected){
				if(Game.world.actions.active != null && !Game.world.mapLoadInProgress){
					if(Game.world.myAvatar.invLoaded && Game.world.myAvatar.pMC.artLoaded()){
						waitForLogin.reset();
						waitForLogin.removeEventListener(TimerEvent.TIMER, onWait);
						waitForLogin.addEventListener(TimerEvent.TIMER, onLogout);
						waitForLogin.start();
						modules.create();
					}
				}
			}
		}
		
		function onLogout(e:TimerEvent):void{
			if(!Game.sfc.isConnected){
				waitForLogin.reset();
				waitForLogin.addEventListener(TimerEvent.TIMER, onWait);
				waitForLogin.start();
			}
		}
		
		function GetVersion()
		{
			versionLoader = new URLLoader();
			versionLoader.addEventListener(Event.COMPLETE, onVersionComplete);
			versionLoader.load(new URLRequest(sURL + gameFile));
		}
		
		function onProgress(arg1:flash.events.ProgressEvent):void
		{
			var loc1:*=arg1.currentTarget.bytesLoaded / arg1.currentTarget.bytesTotal * 100;
			if(loc1 == 100)
				_loader.visible = false;
			return;
		}
		
		function onVersionComplete(param1:Event)
		{
			var vars:URLVariables;
			vars = new URLVariables(param1.target.data);
			if (vars.status == "success")
			{
				sFile = vars.sFile;
				sBG = vars.sBG;
				this.titleDomain = new ApplicationDomain();
				LoadGame();
			}
		}
	}
	
}

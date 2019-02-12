package net.spider.handlers{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
    import net.spider.modules.*;
	import net.spider.handlers.*;

	public class modules extends MovieClip{

		public static function create():void{
			drops.onCreate();
			skillanim.onCreate();
			hideplayers.onCreate();
			monstype.onCreate();
			qrates.onCreate();
			qprev.onCreate();
			qlog.onCreate();
			untarget.onCreate();
			chatfilter.onCreate();
			untargetself.onCreate();
			diswepanim.onCreate();
			detaildrops.onCreate();
			detailquests.onCreate();

			options.events.dispatchEvent(new ClientEvent(ClientEvent.onEnable));
		}
	}
	
}

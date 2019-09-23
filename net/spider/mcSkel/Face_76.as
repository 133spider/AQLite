package net.spider.mcSkel {
	
	import flash.display.MovieClip;
	
	
	public class Face_76 extends MovieClip {
		
		
		public function Face_76()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         try{
			 MovieClip(this.parent).pAV.pMC.setColor(this, "a", "Skin", "Dark");
         }
         catch(e:Error){}
      }
	}
	
}

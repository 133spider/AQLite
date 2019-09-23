package net.spider.mcSkel {
	
	import flash.display.MovieClip;
	
	
	public class Face_75 extends MovieClip {
		
		
		public function Face_75()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         try{
			 MovieClip(this.parent).pAV.pMC.setColor(this, "a", "Skin", "None");
         }
         catch(e:Error){}
      }
	}
	
}

package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class shadowstrike extends SpellW {
		
		
		public function shadowstrike() {
			addFrameScript(0, this.frame1, 28, this.frame29);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame29()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

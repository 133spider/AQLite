package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class bloodball extends SpellW {
		
		
		public function bloodball() {
			addFrameScript(0, this.frame1, 56, this.frame57);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame57()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

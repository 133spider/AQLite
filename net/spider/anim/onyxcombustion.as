package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class onyxcombustion extends SpellW {
		
		
		public function onyxcombustion() {
            MovieClip(this).scaleX *= .7;
            MovieClip(this).scaleY *= .7;
			addFrameScript(0, this.frame1, 40, this.frame41);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame41()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

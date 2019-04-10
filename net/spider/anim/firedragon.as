package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class firedragon extends SpellW {
		
        public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;
		
		public function firedragon() {
            MovieClip(this).scaleX *= .7;
            MovieClip(this).scaleY *= .7;
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
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

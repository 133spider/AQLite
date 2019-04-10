package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class toxicabomination extends SpellW {
		
        public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;
		
		public function toxicabomination() {
            MovieClip(this).scaleX *= .5;
            MovieClip(this).scaleY *= .5;
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 203, this.frame204);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame204()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

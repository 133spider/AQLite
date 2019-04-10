package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class dragonstrike extends SpellW {
		
		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;

		public function dragonstrike() {
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 9, this.frame10);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame10()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

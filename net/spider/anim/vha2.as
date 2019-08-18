package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class vha2 extends SpellW {
		
		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;

		public function vha2() {
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 19, this.frame27);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame27()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

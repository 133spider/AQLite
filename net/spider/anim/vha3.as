package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class vha3 extends SpellW {
		
		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;

		public function vha3() {
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 26, this.frame27);
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

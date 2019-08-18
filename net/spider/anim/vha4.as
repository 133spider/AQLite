package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class vha4 extends SpellW {
		
        public var w1:MovieClip;
        public var w2:MovieClip;
        public var w3:MovieClip;
        public var w4:MovieClip;
        public var w5:MovieClip;
        public var w7:MovieClip;

		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;

		public function vha4() {
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 62, this.frame27);
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

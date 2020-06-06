package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.handlers.modules;
	
	
	dynamic public class floatingrocks extends SpellW {
		
		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;
		
		public function floatingrocks() {
			modules.relCombatMC.groundRupture = true;
			if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			MovieClip(this).scaleX *= .5;
            MovieClip(this).scaleY *= .5;

			addFrameScript(0, this.frame1);
            return;
		}

        function frame1()
        {
            init();
        }
	}
	
}

package net.spider.anim {
	
	import flash.display.MovieClip;
    import net.spider.anim.SpellW;
	
	dynamic public class healthdragon extends SpellW {
		
		
		public function healthdragon() {
			addFrameScript(0, this.frame1, 47, this.frame48);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame48()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

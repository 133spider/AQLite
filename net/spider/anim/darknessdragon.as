package net.spider.anim {
	
	import flash.display.MovieClip;
    import net.spider.anim.SpellW;
	
	dynamic public class darknessdragon extends SpellW {
		
		
		public function darknessdragon() {
			addFrameScript(0, this.frame1, 46, this.frame47);
            return;
		}

        function frame1()
        {
            init();
        }// end function

        function frame47()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

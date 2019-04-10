package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class manadragon extends SpellW {
		
		
		public function manadragon() {
			addFrameScript(0, this.frame1, 47, this.frame48);
            return;
		}

        function frame1()
        {
            
        }// end function

        function frame48()
        {
            //MovieClip(parent).removeChild(this);
            //stop();
            killSpell();
        }// end function
	}
	
}

package net.spider.anim {
	
	import flash.display.MovieClip;
	import net.spider.anim.SpellW;
	
	dynamic public class vhaa extends SpellW {
		
        public var w1:MovieClip;
        public var w2:MovieClip;
        public var w3:MovieClip;
        public var w4:MovieClip;
        public var w5:MovieClip;
        public var w7:MovieClip;
        public var w8:MovieClip;

		public var trueTarget:MovieClip;
        public var trueSelf:MovieClip;

		public function vhaa() {
            MovieClip(this).scaleX *= .7;
            MovieClip(this).scaleY *= .7;
            if(trueTarget != null){
                if(trueTarget.x < trueSelf.x)
                {
                    MovieClip(this).scaleX *= -1;
                }
            }
			addFrameScript(0, this.frame1, 25, this.frame27);
            return;
		}

        function rand(min:Number, max:Number):Number 
        {
            return (Math.floor(Math.random() * (max - min + 1)) + min);
        }

        function frame1()
        {
            w1.visible = false;
            w2.visible = false;
            w3.visible = false;
            w4.visible = false;
            w5.visible = false;
            w6.visible = false;
            w7.visible = false;
            w8.visible = false;
            switch(rand(1,8)){
                case 1:
                    w1.visible = true;
                    break;
                case 2:
                    w2.visible = true;
                    break;
                case 3:
                    w3.visible = true;
                    break;
                case 4:
                    w4.visible = true;
                    break;
                case 5:
                    w5.visible = true;
                    break;
                case 6:
                    w6.visible = true;
                    break;
                case 7:
                    w7.visible = true;
                    break;
                case 8:
                    w8.visible = true;
                    break;
                default: 
                    w5.visible = true;
                    break;
            }
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

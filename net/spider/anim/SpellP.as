package net.spider.anim
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class SpellP extends MovieClip
    {
        public var isSpell:Boolean = true;
        public var sp:int = 20;
        public var dir:int = 1;
        public var world:MovieClip = null;
        public var tMC:MovieClip = null;
        public var strl:String = "";
        public var spellDur:int = 0;

        public function SpellP()
        {
            return;
        }// end function

        public function init()
        {
            if (this.dir > 0)
            {
                this.turn("right");
            }
            else
            {
                this.turn("left");
            }
            addEventListener(Event.ENTER_FRAME, this.moveMe, false, 0, true);
            return;
        }// end function

        public function turn(param1:String) : void
        {
            if (param1 == "right" && MovieClip(this).scaleX < 0 || param1 == "left" && MovieClip(this).scaleX > 0)
            {
                MovieClip(this).scaleX = MovieClip(this).scaleX * -1;
            }
            return;
        }// end function

        public function moveMe(event:Event)
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:* = undefined;
            var _loc_7:* = undefined;
            var _loc_8:* = undefined;
            var _loc_9:* = undefined;
            var _loc_10:* = undefined;
            var _loc_11:* = undefined;
            if (parent != null)
            {
                _loc_2 = MovieClip(event.currentTarget);
                if (this.tMC != null && this.tMC.parent != null)
                {
                    _loc_3 = this.tMC.x;
                    _loc_4 = _loc_3 - _loc_2.x >= 0 ? ((-_loc_2.width) / 2) : (_loc_2.width / 2);
                    _loc_5 = (-this.tMC.mcChar.height) * 0.5;
                    _loc_6 = _loc_3 - _loc_2.x >= 0 ? (1) : (-1);
                    _loc_7 = new Point(_loc_3 + _loc_4, this.tMC.y + _loc_5);
                    _loc_8 = new Point(_loc_2.x, _loc_2.y);
                    _loc_9 = Point.distance(_loc_7, _loc_8);
                    this.sp = this.sp * 1.1;
                    _loc_10 = this.sp / _loc_9;
                    if (_loc_9 > this.sp && this.dir == _loc_6)
                    {
                        _loc_11 = Point.interpolate(_loc_7, _loc_8, _loc_10);
                        _loc_2.x = _loc_11.x;
                        _loc_2.y = _loc_11.y;
                    }
                    else
                    {
                        _loc_2.x = _loc_7.x;
                        _loc_2.y = _loc_7.y;
                        //this.world.showSpellFXHit({typ:MovieClip(this).constructor, tMC:this.tMC, strl:this.strl});
                        MovieClip(parent).removeChild(this);
                        removeEventListener(Event.ENTER_FRAME, this.moveMe);
                    }
                }
                else
                {
                    stop();
                    MovieClip(parent).removeChild(this);
                    removeEventListener(Event.ENTER_FRAME, this.moveMe);
                }
            }
            return;
        }// end function

    }
}

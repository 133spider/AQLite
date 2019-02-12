package net.spider.handlers
{
    import flash.events.*;

    public class DrawEvent extends Event
    {
        public var params:Object;
        public var data:Object;
        public static const onBtPreview:String = "onBtPreview";
        public static const onBtNo:String = "onBtNo";

        public function DrawEvent(param1:String, item:Object)
        {
            super(param1);
            this.data = item;
            return;
        }
    }
}

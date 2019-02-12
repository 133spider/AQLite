package net.spider.handlers
{
    import flash.events.*;

    public class ClientEvent extends Event
    {
        public var params:Object;
        public static const onToggle:String = "onToggle";
        public static const onShow:String = "onShow";
        public static const onEnable:String = "onEnable";
        public static const onUpdate:String = "onUpdate";

        public function ClientEvent(param1:String)
        {
            super(param1);
            return;
        }
    }
}

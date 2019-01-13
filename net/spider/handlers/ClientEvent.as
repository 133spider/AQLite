package net.spider.handlers
{
    import flash.events.*;

    public class ClientEvent extends Event
    {
        public var params:Object;
        public static const onToggle:String = "onToggle";

        public function ClientEvent(param1:String)
        {
            super(param1);
            return;
        }
    }
}

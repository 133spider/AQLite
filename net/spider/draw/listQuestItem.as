package net.spider.draw
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class listQuestItem extends MovieClip
   {
       
      
      public var QuestName:TextField;
      
      public var MemberIcon:SimpleButton;
      
      public var QuestPercent:TextField;
      
      public var btn:SimpleButton;
      
      public var strMap:String;
      
      public function listQuestItem()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
      }
   }
}

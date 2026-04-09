package pvz.registration.view.panel.module
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import utils.TextFilter;
   
   public class TabPanelItem
   {
      
      public var btnTitle:DisplayObject;
      
      public var content:DisplayObject;
      
      public var id:uint;
      
      public var name:String;
      
      public var selected:Boolean;
      
      public var tag:*;
      
      public function TabPanelItem(param1:DisplayObject = null, param2:DisplayObject = null, param3:uint = 0, param4:String = null, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.btnTitle = param1;
         this.content = param2;
         this.id = param3;
         this.name = param4;
         this.selected = param5;
         if(param6 && param1 is MovieClip)
         {
            try
            {
               (param1 as MovieClip).tf.text = param4;
               TextFilter.MiaoBian((param1 as MovieClip).tf,1118481);
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}


package pvz.registration.view.panel.module
{
   import flash.display.DisplayObject;
   
   public interface IScrollableObject
   {
      
      function get content() : DisplayObject;
      
      function set content(param1:DisplayObject) : void;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function get contentHeight() : uint;
      
      function get scrollHeight() : Number;
      
      function get contentWidth() : uint;
      
      function get scrollWidth() : Number;
      
      function get scrollType() : String;
      
      function get scrollBar() : ScrollBar;
      
      function get scrollBarH() : ScrollBar;
      
      function scrollTo(param1:Number, param2:Boolean = true, param3:Boolean = true, param4:String = "") : void;
   }
}


package core.ui.tips
{
   import com.res.IDestroy;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CTextField extends TextField implements IDestroy
   {
      
      public function CTextField()
      {
         super();
      }
      
      public function setFont(param1:String) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.font = param1;
         defaultTextFormat = _loc2_;
      }
      
      public function setColor(param1:uint) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.color = param1;
         defaultTextFormat = _loc2_;
      }
      
      public function setSize(param1:int) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.size = param1;
         defaultTextFormat = _loc2_;
      }
      
      public function setAlign(param1:String) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.align = param1;
         defaultTextFormat = _loc2_;
      }
      
      public function destroy() : void
      {
         this.filters = null;
      }
   }
}


package core.ui.tips
{
   import com.res.IDestroy;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import utils.TextFilter;
   
   public class TipsItem1 extends Sprite implements IDestroy
   {
      
      public function TipsItem1(param1:String, param2:Vector.<String>, param3:Number)
      {
         var _loc6_:CTextField = null;
         super();
         var _loc4_:CTextField = new CTextField();
         _loc4_.width = 100;
         _loc4_.height = 18;
         _loc4_.setSize(14);
         _loc4_.setColor(16777215);
         _loc4_.text = param1;
         addChild(_loc4_);
         TextFilter.MiaoBian(_loc4_,0);
         var _loc5_:int = int(param2.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = new CTextField();
            _loc6_.width = param3;
            _loc6_.height = 18;
            _loc6_.setSize(14);
            _loc6_.setAlign(TextFormatAlign.CENTER);
            _loc6_.setColor(16777215);
            _loc6_.text = param2[_loc7_];
            addChild(_loc6_);
            TextFilter.MiaoBian(_loc6_,0);
            _loc6_.y = this.height;
            _loc7_++;
         }
      }
      
      public function destroy() : void
      {
         while(this.numChildren > 0)
         {
            if(this.getChildAt(0) is DisplayObject)
            {
               (this.getChildAt(0) as DisplayObject).filters = null;
            }
            this.removeChildAt(0);
         }
         parent.removeChild(this);
      }
   }
}


package pvz.help
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class HelpTextfield extends Sprite
   {
      
      public function HelpTextfield(param1:String = "", param2:Number = 200)
      {
         var _loc3_:TextField = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         _loc3_ = new TextField();
         var _loc4_:TextFormat = _loc3_.defaultTextFormat;
         _loc4_.size = 14;
         _loc4_.align = TextFormatAlign.LEFT;
         _loc3_.condenseWhite = true;
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         var _loc5_:Array = [];
         var _loc6_:int = param1.length;
         var _loc7_:int = 0;
         var _loc8_:String = "";
         while(_loc9_ <= _loc6_)
         {
            _loc3_.text = param1.substring(_loc7_,_loc9_);
            if(_loc3_.width >= param2)
            {
               _loc5_.push(param1.substring(_loc7_,_loc9_) + "\n");
               _loc7_ = _loc9_;
               _loc3_.text = "";
            }
            _loc9_++;
         }
         _loc5_.push(_loc3_.text);
         for each(_loc10_ in _loc5_)
         {
            _loc8_ += _loc10_;
         }
         _loc3_.text = _loc8_;
         addChild(_loc3_);
      }
   }
}


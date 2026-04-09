package pvz.copy.ui.tips
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import node.Icon;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class TipsItem extends Sprite
   {
      
      public function TipsItem(param1:String, param2:Array, param3:Boolean = false)
      {
         var _loc4_:TextField = null;
         var _loc5_:DisplayObject = null;
         var _loc7_:Tool = null;
         var _loc8_:TextFormat = null;
         super();
         if(param2 == null || param2.length == 0)
         {
            return;
         }
         if(param1 != "")
         {
            _loc4_ = new TextField();
            _loc4_.width = 100;
            _loc4_.height = 20;
            _loc8_ = _loc4_.defaultTextFormat;
            _loc8_.color = 16777215;
            _loc4_.defaultTextFormat = _loc8_;
            addChild(_loc4_);
            _loc4_.text = param1;
            _loc4_.y = 10;
            TextFilter.MiaoBian(_loc4_,0);
         }
         var _loc6_:int = 0;
         for each(_loc7_ in param2)
         {
            _loc5_ = GetDomainRes.getSprite("stone.tipsItem");
            _loc5_.name = "item";
            _loc5_["_txt"].text = _loc7_.getName() + "×" + _loc7_.getNum();
            _loc5_["_txt"].y = 16;
            _loc5_["starstr"].y = 14;
            if(param3)
            {
               if(this.getShowBM(_loc7_.getName()) == 2)
               {
                  _loc5_["starstr"].gotoAndStop(1);
                  _loc5_["starstr"].visible = true;
               }
               else if(this.getShowBM(_loc7_.getName()) == 3)
               {
                  _loc5_["starstr"].gotoAndStop(2);
                  _loc5_["starstr"].visible = true;
               }
               else
               {
                  _loc5_["starstr"].gotoAndStop(1);
                  _loc5_["starstr"].visible = false;
               }
            }
            else
            {
               _loc5_["starstr"].gotoAndStop(1);
               _loc5_["starstr"].visible = false;
            }
            Icon.setJewelIcon(_loc5_["_node"],_loc7_.getOrderId(),0.8);
            FuncKit.sharpenDisplay(_loc5_["_node"]);
            TextFilter.MiaoBian(_loc5_["_txt"],0);
            addChild(_loc5_);
            if(_loc4_)
            {
               _loc5_.y = 20 + _loc6_ * 31.4;
            }
            else
            {
               _loc5_.y = _loc6_ * 31.4;
            }
            _loc6_++;
            _loc5_.x = 10;
         }
      }
      
      private function getShowBM(param1:String) : int
      {
         if(param1.indexOf("2") >= 0)
         {
            return 2;
         }
         if(param1.indexOf("3") >= 0)
         {
            return 3;
         }
         return 1;
      }
      
      public function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(this.numChildren > 0)
         {
            if(this.getChildAt(0) is DisplayObject)
            {
               _loc1_ = this.getChildAt(0) as DisplayObject;
               if(_loc1_.name == "item")
               {
                  _loc1_["_node"].filters = null;
                  _loc1_["_txt"].filters = null;
               }
               this.removeChildAt(0);
            }
         }
      }
   }
}


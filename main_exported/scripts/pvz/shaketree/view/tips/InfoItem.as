package pvz.shaketree.view.tips
{
   import com.res.IDestroy;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import node.Icon;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class InfoItem extends Sprite implements IDestroy
   {
      
      public function InfoItem(param1:String, param2:Array)
      {
         var _loc3_:TextField = null;
         var _loc4_:MovieClip = null;
         var _loc6_:Tool = null;
         var _loc7_:TextFormat = null;
         super();
         if(param2 == null || param2.length <= 0)
         {
            return;
         }
         if(param1 != "")
         {
            _loc3_ = new TextField();
            _loc3_.width = 100;
            _loc3_.height = 20;
            _loc7_ = _loc3_.defaultTextFormat;
            _loc7_.color = 16777215;
            _loc3_.defaultTextFormat = _loc7_;
            addChild(_loc3_);
            _loc3_.text = param1;
            _loc3_.y = 10;
            TextFilter.MiaoBian(_loc3_,0);
         }
         var _loc5_:int = 0;
         for each(_loc6_ in param2)
         {
            _loc4_ = GetDomainRes.getMoveClip("pvz.zombiesInfoitem");
            _loc4_.name = "item";
            _loc4_["_txt"].text = _loc6_.getName() + "×" + _loc6_.getNum();
            Icon.setJewelIcon(_loc4_["_node"],_loc6_.getOrderId(),0.8);
            _loc4_["_txt"].y = _loc4_.height / 2 - _loc4_["_txt"].height / 2;
            FuncKit.sharpenDisplay(_loc4_["_node"]);
            TextFilter.MiaoBian(_loc4_["_txt"],0);
            addChild(_loc4_);
            if(_loc3_)
            {
               if(_loc6_.getOrderId() >= 1002 && _loc6_.getOrderId() <= 1005)
               {
                  _loc4_.y = 30 + _loc5_ * (_loc4_.height - 5);
               }
               else
               {
                  _loc4_.y = 20 + _loc5_ * (_loc4_.height - 15);
               }
            }
            else if(_loc6_.getOrderId() >= 1002 && _loc6_.getOrderId() <= 1005)
            {
               _loc4_.y = _loc5_ * (_loc4_.height - 5);
            }
            else
            {
               _loc4_.y = _loc5_ * (_loc4_.height - 15);
            }
            _loc5_++;
            _loc4_.x = 10;
         }
      }
      
      public function destroy() : void
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


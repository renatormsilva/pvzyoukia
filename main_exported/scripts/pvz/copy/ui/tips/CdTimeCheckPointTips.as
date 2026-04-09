package pvz.copy.ui.tips
{
   import com.res.IDestroy;
   import core.ui.tips.TipsItem2;
   import entity.Tool;
   import flash.display.DisplayObject;
   import manager.LangManager;
   import pvz.genius.tips.BaseSectionsTips;
   import utils.TextFilter;
   
   public class CdTimeCheckPointTips extends BaseSectionsTips
   {
      
      public function CdTimeCheckPointTips()
      {
         super("pvz.activtyCopy.tips1",false);
      }
      
      public function initTips(param1:Array, param2:String = "") : void
      {
         var _loc4_:Tool = null;
         var _loc5_:TipsItem2 = null;
         this.destroy();
         createTips();
         _ui["_label"].text = param2;
         TextFilter.MiaoBian(_ui["_label"],0);
         var _loc3_:Vector.<String> = new Vector.<String>();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_.getName());
         }
         _loc5_ = new TipsItem2(LangManager.getInstance().getLanguage("activtyCopy001"),_loc3_,176);
         _bg.addChild(_loc5_);
         _layout.addDisToGroup(_loc5_);
         reLayout();
      }
      
      override public function destroy() : void
      {
         TextFilter.removeFilter(_ui["_label"]);
         while(_bg.numChildren > 0)
         {
            if(_bg.getChildAt(0) is IDestroy)
            {
               (_bg.getChildAt(0) as IDestroy).destroy();
            }
            _bg.getChildAt(0).filters = null;
            _bg.removeChild(_bg.getChildAt(0) as DisplayObject);
         }
      }
   }
}


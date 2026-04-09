package pvz.copy.ui.tips
{
   import core.ui.tips.BaseTips;
   import manager.LangManager;
   import pvz.copy.models.stone.StoneSceneIconData;
   import utils.TextFilter;
   
   public class StoneSceneTips extends BaseTips
   {
      
      public function StoneSceneTips()
      {
         super("scentips",false);
         this.maobian();
      }
      
      private function maobian() : void
      {
         TextFilter.MiaoBian(_ui._name1,0);
         TextFilter.MiaoBian(_ui._name2,0);
         TextFilter.MiaoBian(_ui._name3,0);
         TextFilter.MiaoBian(_ui._name4,0);
         TextFilter.MiaoBian(_ui._name5,0);
      }
      
      override public function show(param1:Object) : void
      {
         var _loc2_:StoneSceneIconData = param1 as StoneSceneIconData;
         _ui._name1.text = _loc2_.getName();
         _ui._name2.htmlText = _loc2_.getDesc();
         _ui._name3.text = LangManager.getInstance().getLanguage("copy002");
         _ui._name4.htmlText = _loc2_.getStonesInfo();
         _ui._name5.htmlText = _loc2_.getCondition();
      }
      
      override public function clear() : void
      {
         TextFilter.removeFilter(_ui._name1);
         TextFilter.removeFilter(_ui._name2);
         TextFilter.removeFilter(_ui._name3);
         TextFilter.removeFilter(_ui._name4);
         TextFilter.removeFilter(_ui._name5);
         this.hideTips();
      }
   }
}


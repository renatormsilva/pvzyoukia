package pvz.genius.tips
{
   import core.ui.tips.BaseTips;
   import flash.display.DisplayObject;
   import pvz.genius.vo.SoulData;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class RankingPlantsSoulTips extends BaseTips
   {
      
      public function RankingPlantsSoulTips()
      {
         super("GeniusSystem.RankingSoulTips",false,15722371,12,0);
         this.MiaoBian();
      }
      
      private function MiaoBian() : void
      {
         TextFilter.MiaoBian(_ui._txt1,0);
         TextFilter.MiaoBian(_ui._txt2,0);
         TextFilter.MiaoBian(_ui._txt3,0);
         TextFilter.MiaoBian(_ui._txt4,0);
         TextFilter.MiaoBian(_ui._txt5,0);
         TextFilter.MiaoBian(_ui._txt6,0);
         TextFilter.MiaoBian(_ui._txt7,0);
         TextFilter.MiaoBian(_ui._name2,0);
         TextFilter.MiaoBian(_ui._name3,0);
         TextFilter.MiaoBian(_ui._name4,0);
         TextFilter.MiaoBian(_ui._name5,0);
         TextFilter.MiaoBian(_ui._name6,0);
         TextFilter.MiaoBian(_ui._name7,0);
         TextFilter.MiaoBian(_ui._name1,0);
      }
      
      override public function show(param1:Object) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:SoulData = null;
         var _loc2_:int = int(param1);
         this.changeTextColor(_loc2_);
         if(_loc2_ < 1)
         {
            _loc3_ = FuncKit.getNumEffect("no");
            _ui._section._node.addChild(_loc3_);
            _loc3_.y = -_loc3_.height / 2;
         }
         else
         {
            _loc4_ = FuncKit.getStarDisBySoulLevel(_loc2_);
            _ui._section._node.addChild(_loc4_);
            _loc4_.y = -_loc4_.height / 2;
            _loc5_ = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(_loc2_);
            _ui._txt1.text = _loc5_.addHP + "%";
            _ui._txt2.text = _loc5_.addAttack + "%";
            _ui._txt3.text = _loc5_.addHit + "%";
            _ui._txt4.text = _loc5_.addMiss + "%";
            _ui._txt5.text = _loc5_.addSpeed + "%";
            _ui._txt6.text = _loc5_.addHurt + "%";
            _ui._txt7.text = _loc5_.reduceHurt + "%";
         }
         _ui._section.x = _ui.width / 2 - _ui._section.width / 2;
      }
      
      public function changeTextColor(param1:int) : void
      {
         var _loc2_:int = 1;
         while(_loc2_ <= 7)
         {
            _ui["_txt" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_name" + _loc2_].textColor = getSoulColorByLevel(param1);
            _loc2_++;
         }
      }
   }
}


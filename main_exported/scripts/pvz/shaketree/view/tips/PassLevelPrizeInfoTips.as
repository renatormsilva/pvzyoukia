package pvz.shaketree.view.tips
{
   import core.ui.components.VGroupLayout;
   import flash.geom.Point;
   import pvz.genius.tips.BaseSectionsTips;
   
   public class PassLevelPrizeInfoTips extends BaseSectionsTips
   {
      
      public function PassLevelPrizeInfoTips()
      {
         super("pvz.passLevelInfoTips",false);
      }
      
      override protected function createTips() : void
      {
         _layout = new VGroupLayout(new Point(0,0),10);
         _layout.addDisToGroup(_ui);
         _layout.tipsLayout();
         _bg.draw(_layout.getLayoutWidth() + _leftgap,_layout.getLayoutHeight() + _upgap);
         layout();
      }
      
      public function showTipss(param1:Array) : void
      {
         var _loc2_:InfoItem = new InfoItem("",param1);
         _bg.addChild(_loc2_);
         _layout.addDisToGroup(_loc2_);
         _layout.tipsLayout();
         _bg.draw(_layout.getLayoutWidth() + _leftgap,_layout.getLayoutHeight());
         layout();
      }
   }
}


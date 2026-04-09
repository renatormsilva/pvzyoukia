package pvz.genius.tips
{
   import core.ui.components.VGroupLayout;
   import core.ui.tips.BaseTips;
   import flash.geom.Point;
   import utils.FuncKit;
   
   public class BaseSectionsTips extends BaseTips
   {
      
      protected var _layout:VGroupLayout;
      
      public function BaseSectionsTips(param1:String, param2:Boolean)
      {
         super(param1,param2,15722382,12,0);
         this.createTips();
      }
      
      protected function createTips() : void
      {
         if(this._layout == null)
         {
            this._layout = new VGroupLayout(new Point(0,0),10);
         }
         FuncKit.clearAllChildrens(_bg);
         _bg.addChild(_ui);
         this._layout.clearGroup();
         this._layout.addDisToGroup(_ui);
         this._layout.tipsLayout();
         _bg.draw(this._layout.getLayoutWidth() + _leftgap,this._layout.getLayoutHeight() + _upgap);
         layout();
      }
      
      protected function reLayout() : void
      {
         this._layout.tipsLayout();
         _bg.draw(this._layout.getLayoutWidth() + _leftgap,this._layout.getLayoutHeight() + _upgap);
         layout();
      }
   }
}


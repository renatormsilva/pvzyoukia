package pvz.copy.ui.windows
{
   import core.ui.panel.BaseActionWindow;
   import entity.Tool;
   import utils.FuncKit;
   
   public class AddLimitCopyTimesWindow extends BaseActionWindow
   {
      
      private var _price:Number;
      
      public function AddLimitCopyTimesWindow(param1:Function = null, param2:int = 10, param3:Tool = null, param4:Number = 10)
      {
         this._price = param4;
         super(param1,param2,param3);
      }
      
      override protected function updateTipConent() : void
      {
         _window.text1.htmlText = "是否花费" + FuncKit.getColorHtmlStr(_currentTimes * this._price + "金券") + "购买" + FuncKit.getColorHtmlStr(_currentTimes + "次") + "挑战次数?";
      }
   }
}


package pvz.copy.ui.windows
{
   import core.ui.panel.BaseActionWindow;
   import entity.Tool;
   import utils.FuncKit;
   
   public class AddTimesByUseingTool extends BaseActionWindow
   {
      
      public function AddTimesByUseingTool(param1:Function = null, param2:int = 10, param3:Tool = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function updateTipConent() : void
      {
         if(_useTool)
         {
            _window.text1.htmlText = "你确定使用 " + FuncKit.getColorHtmlStr(_currentTimes + "本 ") + _useTool.getName() + "增加 " + FuncKit.getColorHtmlStr(_currentTimes + "次") + " 挑战次数?";
         }
      }
   }
}


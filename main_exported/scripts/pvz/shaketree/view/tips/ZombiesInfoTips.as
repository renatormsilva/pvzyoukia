package pvz.shaketree.view.tips
{
   import com.res.IDestroy;
   import flash.display.DisplayObject;
   import manager.LangManager;
   import pvz.genius.tips.BaseSectionsTips;
   import utils.TextFilter;
   
   public class ZombiesInfoTips extends BaseSectionsTips
   {
      
      public function ZombiesInfoTips()
      {
         super("pvz.zombiesInfoTips",false);
      }
      
      public function showTipss(param1:Boolean, param2:String, param3:Array, param4:Array) : void
      {
         this.destroy();
         createTips();
         var _loc5_:InfoItem = new InfoItem(LangManager.getInstance().getLanguage("shakeTree007"),param3);
         var _loc6_:InfoItem = new InfoItem(LangManager.getInstance().getLanguage("shakeTree008"),param4);
         if(param1)
         {
            _ui.name_txt.text = param2;
         }
         else
         {
            _ui.name_txt.htmlText = "<font color=\'#ffffff\' size=\'15\'><center>" + param2 + "</center></font>";
         }
         TextFilter.MiaoBian(_ui.name_txt,0);
         _ui.isBoss.visible = param1;
         _bg.addChild(_loc5_);
         _bg.addChild(_loc6_);
         _layout.addDisToGroup(_loc5_);
         _layout.addDisToGroup(_loc6_);
         _layout.tipsLayout();
         _bg.draw(_layout.getLayoutWidth() + _leftgap,_layout.getLayoutHeight());
         layout();
      }
      
      override public function destroy() : void
      {
         while(_bg.numChildren > 0)
         {
            if(_bg.getChildAt(0) is IDestroy)
            {
               (_bg.getChildAt(0) as IDestroy).destroy();
            }
            _bg.removeChild(_bg.getChildAt(0) as DisplayObject);
         }
      }
   }
}


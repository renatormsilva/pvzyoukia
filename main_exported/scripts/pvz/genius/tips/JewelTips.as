package pvz.genius.tips
{
   import core.ui.tips.BaseTips;
   import entity.Tool;
   import utils.TextFilter;
   
   public class JewelTips extends BaseTips
   {
      
      private var _jewel:Tool;
      
      public function JewelTips()
      {
         super("JewelSystem.JewelTips",true);
         this.miaobian();
      }
      
      public function setInfo(param1:Tool) : void
      {
         this._jewel = param1;
         if(!param1)
         {
            return;
         }
         _ui["name_txt"].text = param1.getName();
         _ui["use_intro_txt"].text = param1.getUse_condition();
         _ui["info_txt"].text = param1.getUse_result();
      }
      
      public function Layout(param1:Number, param2:Number) : void
      {
         this.x = param1 + 128;
         this.y = param2 - 147;
         if(x > 300)
         {
            this.x = param1 - 130;
         }
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(_ui["name_txt"],1118481);
         TextFilter.MiaoBian(_ui["use_intro_txt"],1118481);
         TextFilter.MiaoBian(_ui["info_txt"],1118481);
      }
   }
}


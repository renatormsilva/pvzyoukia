package pvz.serverbattle.tip
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import manager.LangManager;
   import pvz.serverbattle.entity.MedalGoods;
   import tip.Tips;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class MedalGoodsTips extends Tips
   {
      
      private var _label:MovieClip;
      
      public function MedalGoodsTips()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("medalTips");
         this._label = new _loc1_();
         this.miaobian();
         this.addChild(this._label);
      }
      
      public function setInfo(param1:MedalGoods) : void
      {
         if(!param1)
         {
            return;
         }
         this._label["name_txt"].text = param1.getName();
         this._label["use_intro_txt"].text = param1.getUse_condition();
         this._label["info_txt"].text = param1.getUse_result();
         this._label["left_num_txt"].text = LangManager.getInstance().getLanguage("severBattle016",param1.getNum());
      }
      
      public function setLocation(param1:DisplayObject) : void
      {
         this.x = param1.x - 85 + param1.width + 10;
         this.y = param1.y - 100;
         if(param1.x >= 260)
         {
            this.x = -85 + param1.width + 10;
         }
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._label["name_txt"],1118481);
         TextFilter.MiaoBian(this._label["use_intro_txt"],1118481);
         TextFilter.MiaoBian(this._label["info_txt"],1118481);
         TextFilter.MiaoBian(this._label["left_num_txt"],1118481);
      }
   }
}


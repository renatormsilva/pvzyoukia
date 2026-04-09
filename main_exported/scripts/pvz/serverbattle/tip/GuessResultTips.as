package pvz.serverbattle.tip
{
   import entity.Tool;
   import flash.display.MovieClip;
   import tip.Tips;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class GuessResultTips extends Tips
   {
      
      private var _label:MovieClip;
      
      public function GuessResultTips()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("toolstip");
         this._label = new _loc1_();
         TextFilter.MiaoBian(this._label._name,0);
         TextFilter.MiaoBian(this._label._use_condition,0);
         TextFilter.MiaoBian(this._label._use_result,0);
         this.addChild(this._label);
      }
      
      public function update(param1:Tool) : void
      {
         this._label._name.text = param1.getName();
         this._label._use_condition.text = param1.getUse_condition();
         this._label._use_result.text = param1.getUse_result();
      }
   }
}


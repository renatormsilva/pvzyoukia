package pvz.possession.tip
{
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import pvz.genius.vo.GeniusSystemConst;
   import tip.Tips;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class PossessionOrgTip extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      private var _org:Organism;
      
      public function PossessionOrgTip()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("_mc_possession_org_tip");
         this._background = new _loc1_();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
      
      override public function destroy() : void
      {
         this.clearAllEvent();
         FuncKit.clearAllChildrens(this);
         this._org = null;
      }
      
      public function setTip(param1:InteractiveObject, param2:Organism, param3:DisplayObjectContainer) : void
      {
         this._o = param1;
         this._org = param2;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            param3.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.setText();
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function setText() : void
      {
         var _loc2_:DisplayObject = null;
         this._background._txt_name.textColor = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
         this._background._txt_quality.textColor = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
         this._background["_txt_name"].text = this._org.getName();
         this._background["_txt_grade"].text = "lv." + this._org.getGrade();
         this._background["_txt_quality"].text = this._org.getQuality_name();
         var _loc1_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(this._org.getBattleE(),16748544,12,true);
         this._background["_txt_battle"].addChild(_loc1_);
         _loc1_.x = 2;
         if(GeniusSystemConst.checkSoulValid(this._org.getSoulLevel()))
         {
            FuncKit.clearAllChildrens(this._background._soulLevelNode);
            _loc2_ = FuncKit.getStarDisBySoulLevel(this._org.getSoulLevel());
            this._background._soulLevelNode.addChild(_loc2_);
            _loc2_.y = -_loc2_.height / 2;
         }
         else
         {
            this._background._staus_txt.text = LangManager.getInstance().getLanguage("tip012");
         }
         this._background.visible = true;
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._txt_name,1118481);
         TextFilter.MiaoBian(this._background._txt_grade,1118481);
         TextFilter.MiaoBian(this._background._txt_quality,1118481);
         TextFilter.MiaoBian(this._background._quality_title,1118481);
         TextFilter.MiaoBian(this._background._grade_title,1118481);
         TextFilter.MiaoBian(this._background._battle_title,1118481);
         TextFilter.MiaoBian(this._background._staus_txt,1118481);
         TextFilter.MiaoBian(this._background._soulLevelTxt,1118481);
      }
   }
}


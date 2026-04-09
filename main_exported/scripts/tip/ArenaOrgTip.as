package tip
{
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   import zmyth.ui.TextFilter;
   
   public class ArenaOrgTip extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      private var _temp_class:Class;
      
      public function ArenaOrgTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("arenatip");
         this._background = new this._temp_class();
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
         this._o = null;
         FuncKit.clearAllChildrens(this);
      }
      
      public function setTooltipText(param1:InteractiveObject, param2:String, param3:String, param4:String, param5:Organism) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:DisplayObject = null;
         var _loc6_:Organism = param5;
         this._o = param1;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._background["_name"].text = param2;
         this._background._use_condition.text = param3;
         var _loc7_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(Number(param4),16748544,12,true);
         this._background._battle.addChild(_loc7_);
         this._background._battle.addChild(this._background._battle_txt);
         _loc7_.x = -(_loc7_.width / 2 - this._background._battle_txt.width / 2) - 2;
         this._background._battle_txt.x = -(_loc7_.width + this._background._battle_txt.width) / 2 + 2;
         this._background._battle_txt.y = -2;
         if(param5.getQuality_name() != "")
         {
            _loc8_ = XmlQualityConfig.getInstance().getColor(param5.getQuality_name());
            this.changeColor(_loc8_);
         }
         if(GeniusSystemConst.checkSoulValid(_loc6_.getSoulLevel()))
         {
            this._background._section._staus_txt.width = 0;
            FuncKit.clearAllChildrens(this._background._section._soullevelnode);
            _loc9_ = FuncKit.getStarDisBySoulLevel(_loc6_.getSoulLevel());
            this._background._section._soullevelnode.addChild(_loc9_);
            _loc9_.y = -_loc9_.height / 2;
         }
         else
         {
            this._background._section._staus_txt.width = 44.5;
            this._background._section._staus_txt.text = LangManager.getInstance().getLanguage("tip012");
         }
         this._background._section.x = 54 - this._background._section.width / 2;
      }
      
      private function changeColor(param1:uint) : void
      {
         this._background["_name"].textColor = param1;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background["_name"],1118481);
         TextFilter.MiaoBian(this._background._use_condition,1118481);
         TextFilter.MiaoBian(this._background._battle_txt,1118481);
         TextFilter.MiaoBian(this._background._section._staus_txt,1118481);
         TextFilter.MiaoBian(this._background._section._soulleveltxt,1118481);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
   }
}


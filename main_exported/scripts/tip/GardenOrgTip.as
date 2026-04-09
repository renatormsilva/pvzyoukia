package tip
{
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class GardenOrgTip extends Tips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _background:MovieClip;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _org:Organism;
      
      private var _timer:Timer;
      
      public function GardenOrgTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("gardenorgtip");
         this._background = new this._temp_class();
         TextFilter.MiaoBian(this._background._time,1118481);
         TextFilter.MiaoBian(this._background._owner,1118481);
         TextFilter.MiaoBian(this._background["_name"],1118481);
         TextFilter.MiaoBian(this._background._grade,1118481);
         TextFilter.MiaoBian(this._background["_quality"],1118481);
         TextFilter.MiaoBian(this._background._purse,1118481);
         TextFilter.MiaoBian(this._background._purse_title,1118481);
         TextFilter.MiaoBian(this._background._grade_title,1118481);
         TextFilter.MiaoBian(this._background._quality_title,1118481);
         TextFilter.MiaoBian(this._background._owner_title,1118481);
         TextFilter.MiaoBian(this._background._battle_title,0);
         TextFilter.MiaoBian(this._background._staus_txt,1118481);
         TextFilter.MiaoBian(this._background._soulLevelTitle,1118481);
         this.visible = false;
         this.addChild(this._background);
      }
      
      public function setOrgtip(param1:InteractiveObject, param2:Organism) : void
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
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.setText();
      }
      
      private function setText() : void
      {
         var _loc2_:DisplayObject = null;
         if(this._org == null)
         {
            return;
         }
         this.setTimer(this._org.getGainTime());
         this._background["_quality"].textColor = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
         this._background["_name"].textColor = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
         this._background["_name"].text = this._org.getName();
         this._background._owner.text = this._org.getOwner();
         this._background._grade.text = this._org.getGrade();
         this._background["_quality"].text = this._org.getQuality_name();
         this._background._purse.text = this._org.getPurse_amount();
         var _loc1_:DisplayObject = ArtWordsManager.instance.artWordsDisplay(this._org.getBattleE(),16748544,12,true);
         this._background._battle.addChild(_loc1_);
         _loc1_.x = 4;
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
      
      private function setTimer(param1:int) : void
      {
         var h:int = 0;
         var m:int = 0;
         var onTimer:Function = null;
         var i:int = param1;
         onTimer = function(param1:TimerEvent):void
         {
            if(i < 0)
            {
               _background._time.text = LangManager.getInstance().getLanguage("tip002");
               return;
            }
            --i;
            h = i / 3600;
            m = i / 60 - h * 60;
            _background._time.text = h + LangManager.getInstance().getLanguage("hunting008") + m + LangManager.getInstance().getLanguage("hunting009");
         };
         if(this._timer != null)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,onTimer);
            this._timer.stop();
            this._timer = null;
         }
         h = i / 3600;
         m = i / 60 - h * 60;
         if(i <= 0)
         {
            this._background._time.text = LangManager.getInstance().getLanguage("tip002");
            return;
         }
         this._background._time.text = h + LangManager.getInstance().getLanguage("hunting008") + m + LangManager.getInstance().getLanguage("hunting009");
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,onTimer);
         this._timer.start();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
   }
}


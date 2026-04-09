package tip
{
   import entity.Hole;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import utils.FuncKit;
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   import zlib.utils.DomainAccess;
   
   public class HuntingHoleTips extends Tips
   {
      
      private static var BEGIN_X:int = 10;
      
      private static var GRADE:int = 9;
      
      internal var b:Boolean;
      
      private var _background:MovieClip;
      
      private var _h:Hole;
      
      private var _o:InteractiveObject;
      
      private var _temp_class:Class;
      
      private var nowheight:int = 0;
      
      private var nowwidth:int;
      
      public function HuntingHoleTips(param1:Hole, param2:Boolean)
      {
         super();
         if(param1.getType() == Hole.ARRIVE_NO || !param2)
         {
            this._temp_class = DomainAccess.getClass("holeTip2");
         }
         else
         {
            this._temp_class = DomainAccess.getClass("holeTip");
         }
         this._background = new this._temp_class();
         this.visible = false;
         this.b = param2;
         this.miaobian();
         FuncKit.clearAllChildrens(this);
         this.addChild(this._background);
         this.cacheAsBitmap = true;
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2;
      }
      
      public function setTooltip(param1:InteractiveObject, param2:Hole) : void
      {
         this._o = param1;
         this._h = param2;
         if(this._h.getType() == Hole.OPEN_NO)
         {
            this._background.gotoAndStop(1);
         }
         else if(this._h.getType() == Hole.ARRIVE_NO || !this.b)
         {
            this._background.gotoAndStop(1);
         }
         else if(this._h.getType() == Hole.ARRIVE)
         {
            this._background.gotoAndStop(2);
         }
         else
         {
            this._background.gotoAndStop(1);
         }
         this.setText();
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
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function getPrizeName(param1:Object) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(param1.type == "tool")
         {
            return XmlToolsConfig.getInstance().getToolAttribute(param1.id).getName();
         }
         return XmlOrganismConfig.getInstance().getOrganismAttribute(param1.id).getName();
      }
      
      private function getPrizesName(param1:int) : String
      {
         if(param1 > 3)
         {
            return "";
         }
         var _loc2_:String = "";
         return this.getPrizeName(this._h.getAwards()[2 * (param1 - 1)]) + " " + this.getPrizeName(this._h.getAwards()[2 * param1 - 1]);
      }
      
      private function getTimeInfo() : String
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(this.b)
         {
            _loc4_ = this._h.getCome_time();
         }
         else
         {
            _loc4_ = this._h.getMasterTime();
         }
         var _loc1_:String = "";
         var _loc2_:int = _loc4_ / 3600;
         if(_loc2_ > 0)
         {
            _loc5_ = _loc2_ + LangManager.getInstance().getLanguage("hunting008");
         }
         else
         {
            _loc5_ = "";
         }
         var _loc3_:int = (_loc4_ - _loc2_ * 3600) / 60;
         if(_loc3_ > 0)
         {
            _loc6_ = _loc3_ + LangManager.getInstance().getLanguage("hunting009");
         }
         else
         {
            _loc6_ = 1 + LangManager.getInstance().getLanguage("hunting009");
         }
         return _loc5_ + _loc6_;
      }
      
      private function miaobian() : void
      {
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function setText() : void
      {
         this._background._name.text = this._h.getHoleName();
         this._background._grade.text = "lv" + this._h.getOpen_level() + " - lv" + (this._h.getOpen_level() + GRADE);
         if(this._h.getType() == Hole.OPEN_NO)
         {
            this.setTextVisible(false);
            this._background._info1.text = LangManager.getInstance().getLanguage("tip003") + this._h.getOpen_money();
            this._background._info1.visible = true;
         }
         else if(this._h.getType() == Hole.ARRIVE_NO)
         {
            this._background.visible = true;
            this._background._info1_title.text = LangManager.getInstance().getLanguage("tip004");
            this._background._info1.text = this.getTimeInfo();
            this._background._info2.text = this._h.getLastAttackName();
            this._background._info2_title.text = LangManager.getInstance().getLanguage("tip005");
            this._background._info3.text = LangManager.getInstance().getLanguage("tip006") + this._h.getPlayMoney();
         }
         else if(this._h.getType() == Hole.ARRIVE)
         {
            if(!this.b)
            {
               this._background.visible = true;
               this._background._info1_title.text = LangManager.getInstance().getLanguage("tip007");
               this._background._info1.text = this.getTimeInfo();
               this._background._info2.text = this._h.getLastAttackName();
               this._background._info3.text = LangManager.getInstance().getLanguage("tip006") + this._h.getPlayMoney();
               return;
            }
            this.setTextVisible(false);
            this._background._info1.text = LangManager.getInstance().getLanguage("tip008");
            this._background._info2.text = this.getPrizesName(1);
            this._background._info3.text = this.getPrizesName(2);
            this._background._info4.text = this.getPrizesName(3);
            this._background._info5.text = LangManager.getInstance().getLanguage("tip006") + this._h.getPlayMoney();
            this.setTextVisible(true);
         }
      }
      
      private function setTextVisible(param1:Boolean) : void
      {
         this._background._info1.visible = param1;
         this._background._info2.visible = param1;
         this._background._info3.visible = param1;
         this._background._info4.visible = param1;
         this._background._info5.visible = param1;
         if(!param1)
         {
            this._background._info1.text = "";
            this._background._info2.text = "";
            this._background._info3.text = "";
            this._background._info4.text = "";
            this._background._info5.text = "";
         }
      }
   }
}


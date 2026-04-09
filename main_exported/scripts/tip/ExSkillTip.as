package tip
{
   import entity.ExSkill;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SkillManager;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class ExSkillTip extends Tips
   {
      
      private var _class:Class;
      
      private var _mc:MovieClip;
      
      private var _o:InteractiveObject;
      
      private var _s:ExSkill;
      
      public function ExSkillTip()
      {
         super();
         this._class = DomainAccess.getClass("skilltip");
         this._mc = new this._class();
         this.miaobian();
         this.addChild(this._mc);
      }
      
      public function setOrgtip(param1:InteractiveObject, param2:ExSkill) : void
      {
         this._o = param1;
         this._s = param2;
         if(this._s != null)
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
      
      public function setText(param1:String, param2:int) : void
      {
         this._mc._tittle.htmlText = "LV" + this._s.getGrade() + " " + this._s.getName();
         this._mc._info.htmlText = LangManager.getInstance().getLanguage("tip010") + SkillManager.getInstance.getExSkillById(this._s.getId()).getInfo();
         if(SkillManager.getInstance.getNextExSkillById(this._s.getId()) != null)
         {
            this._mc._info2_tittle.htmlText = LangManager.getInstance().getLanguage("tip011") + "(lv" + SkillManager.getInstance.getNextExSkillById(this._s.getId()).getLearnGrade() + "可学)";
            this._mc._info2.htmlText = SkillManager.getInstance.getNextExSkillById(this._s.getId()).getInfo();
            this._mc._toolInfo.htmlText = LangManager.getInstance().getLanguage("window157",param1);
            this._mc._suc.htmlText = LangManager.getInstance().getLanguage("window154",param2);
         }
         else
         {
            this._mc._info2_tittle.htmlText = "";
            this._mc._info2.htmlText = "";
            this._mc._toolInfo.htmlText = "";
            this._mc._suc.htmlText = "";
         }
         this._mc.visible = true;
         this.changeColor();
      }
      
      private function changeColor() : void
      {
         if(this._s.getGrade() < 6)
         {
            this._mc._tittle.textColor = 16777215;
         }
         else if(this._s.getGrade() < 11)
         {
            this._mc._tittle.textColor = 10092288;
         }
         else if(this._s.getGrade() < 21)
         {
            this._mc._tittle.textColor = 16711935;
         }
         else
         {
            this._mc._tittle.textColor = 16720418;
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._mc._tittle,0);
         TextFilter.MiaoBian(this._mc._info,0);
         TextFilter.MiaoBian(this._mc._info2_tittle,0);
         TextFilter.MiaoBian(this._mc._info2,0);
         TextFilter.MiaoBian(this._mc._toolInfo,0);
         TextFilter.MiaoBian(this._mc._suc,0);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}


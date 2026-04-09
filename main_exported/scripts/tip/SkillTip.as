package tip
{
   import entity.Skill;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SkillManager;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class SkillTip extends Tips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _background:MovieClip;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _s:Skill;
      
      public function SkillTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("skilltip");
         this._background = new this._temp_class();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      public function setOrgtip(param1:InteractiveObject, param2:Skill) : void
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
         this._background._tittle.htmlText = "LV" + this._s.getGrade() + " " + this._s.getName();
         this._background._info.htmlText = LangManager.getInstance().getLanguage("tip010") + SkillManager.getInstance.getSkillById(this._s.getId()).getInfo();
         if(SkillManager.getInstance.getNextSkillById(this._s.getId()) != null)
         {
            this._background._info2_tittle.htmlText = LangManager.getInstance().getLanguage("tip011") + "(lv" + SkillManager.getInstance.getNextSkillById(this._s.getId()).getLearnGrade() + "可学)";
            this._background._info2.htmlText = SkillManager.getInstance.getNextSkillById(this._s.getId()).getInfo();
            this._background._toolInfo.htmlText = LangManager.getInstance().getLanguage("window157",param1);
            this._background._suc.htmlText = LangManager.getInstance().getLanguage("window154",param2);
         }
         else
         {
            this._background._info2_tittle.htmlText = "";
            this._background._info2.htmlText = "";
            this._background._toolInfo.htmlText = "";
            this._background._suc.htmlText = "";
         }
         this._background.visible = true;
         this.changeColor();
      }
      
      private function changeColor() : void
      {
         if(this._s.getGrade() < 6)
         {
            this._background._tittle.textColor = 16777215;
         }
         else if(this._s.getGrade() < 11)
         {
            this._background._tittle.textColor = 10092288;
         }
         else if(this._s.getGrade() < 21)
         {
            this._background._tittle.textColor = 16711935;
         }
         else
         {
            this._background._tittle.textColor = 16720418;
         }
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._tittle,0);
         TextFilter.MiaoBian(this._background._info,0);
         TextFilter.MiaoBian(this._background._info2_tittle,0);
         TextFilter.MiaoBian(this._background._info2,0);
         TextFilter.MiaoBian(this._background._toolInfo,0);
         TextFilter.MiaoBian(this._background._suc,0);
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
         this.x = param1;
         this.y = param2;
      }
   }
}


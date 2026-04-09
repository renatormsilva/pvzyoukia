package tip
{
   import entity.ExSkill;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SkillManager;
   import pvz.registration.view.panel.module.HtmlUtil;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class Ex_Unstudy_Tip extends Tips
   {
      
      private var _mc:MovieClip;
      
      private var _class:Class;
      
      private var _o:InteractiveObject;
      
      private var _s:ExSkill;
      
      public function Ex_Unstudy_Tip()
      {
         super();
         this._class = DomainAccess.getClass("ex_unstudy_tip");
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
         this.setText();
      }
      
      public function setText() : void
      {
         var _loc1_:String = "LV" + this._s.getGrade() + " " + this._s.getName();
         this._mc._tittle.htmlText = HtmlUtil.font(_loc1_,this.changeColor(),12) + HtmlUtil.font("(未学习)","#ff0000",12);
         this._mc._info.htmlText = LangManager.getInstance().getLanguage("tip010") + SkillManager.getInstance.getExSkillById(this._s.getId()).getInfo();
         this._mc._info2.htmlText = "去合成屋学习技能";
         this._mc.visible = true;
      }
      
      private function changeColor() : String
      {
         if(this._s.getGrade() < 6)
         {
            return "#ffffff";
         }
         if(this._s.getGrade() < 11)
         {
            return "#99ff00";
         }
         if(this._s.getGrade() < 21)
         {
            return "#ff00ff";
         }
         return "#ff2222";
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
         TextFilter.MiaoBian(this._mc._info2,0);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}


package pvz.compose
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Skill;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SkillManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class ChooseSkillWindow extends BaseWindow
   {
      
      internal var okBackFunction:Function;
      
      internal var _window:MovieClip;
      
      internal var _id:int;
      
      internal var _skill:Skill;
      
      internal var _org:Organism;
      
      internal var _skills:Array;
      
      public function ChooseSkillWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("delSkillWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         this._window.tittle.gotoAndStop(2);
         this._window._info.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         var _loc2_:int = 1;
         while(_loc2_ <= 4)
         {
            this._window["skill" + _loc2_].addEventListener(MouseEvent.CLICK,this.onChoose);
            this._window["skill" + _loc2_].skilltext.mouseEnabled = false;
            this._window["skill" + _loc2_].bt.mouseEnabled = false;
            this._window["skill" + _loc2_].bt.gotoAndStop(1);
            this._window["skill" + _loc2_].visible = false;
            _loc2_++;
         }
      }
      
      private function showSuccess(param1:int) : void
      {
         if(this._window["p"] != null)
         {
            FuncKit.clearAllChildrens(this._window["p"]);
         }
         this._window["p"].addChild(FuncKit.getNumEffect(param1 + "p","Feared"));
      }
      
      private function onChoose(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.substring(5));
         this._id = this._org.getSkill(_loc2_ - 1).getId();
         var _loc3_:int = 1;
         while(_loc3_ <= 4)
         {
            this._window["skill" + _loc3_].bt.gotoAndStop(1);
            _loc3_++;
         }
         this._window["skill" + _loc2_].bt.gotoAndStop(2);
         this._skill = this._skills[_loc2_ - 1];
         this.showSuccess(SkillManager.getInstance.getNextSkillById(this._skill.getId()).getLearnProbability());
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            this.okBackFunction(this._org,this._skill);
         }
         this.hidden();
      }
      
      private function showSkills() : void
      {
         var _loc2_:int = 0;
         if(this._skills == null || this._skills.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._skills.length)
         {
            _loc2_ = _loc1_ + 1;
            this._window["skill" + _loc2_].visible = true;
            this._window["skill" + _loc2_].skilltext.text = "lv." + this._skills[_loc1_].getGrade() + " " + this._skills[_loc1_].getName();
            _loc1_++;
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      public function show(param1:Organism, param2:Array, param3:Function) : void
      {
         var _loc4_:int = 1;
         while(_loc4_ <= 4)
         {
            this._window["skill" + _loc4_].bt.gotoAndStop(1);
            this._window["skill" + _loc4_].visible = false;
            _loc4_++;
         }
         this.showSuccess(0);
         this._id = 0;
         this._org = param1;
         this.okBackFunction = param3;
         this._skills = param2;
         this.showSkills();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}


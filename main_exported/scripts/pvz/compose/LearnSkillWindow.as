package pvz.compose
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SkillManager;
   import manager.ToolType;
   import zlib.utils.DomainAccess;
   
   public class LearnSkillWindow extends BaseWindow
   {
      
      internal var okBackFunction:Function;
      
      internal var _window:MovieClip;
      
      internal var _org:Organism;
      
      internal var _t:Tool;
      
      internal var delSkillWindow:DelSkillWindow;
      
      public function LearnSkillWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("learnSkillWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._window["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         this.hidden();
         if(param1.currentTarget.name == "ok")
         {
            if(!(int(this._t.getType()) >= ToolType.TOOL_TYPE64 && int(this._t.getType()) <= ToolType.TOOL_TYPE71))
            {
               if(this._org.getInitiativeSkill(SkillManager.getInstance) != null && SkillManager.getInstance.getLearnSkill(this._t.getLotteryName()).getTouchOff() == Skill.INITIATIVE)
               {
                  this.delSkillWindow = new DelSkillWindow();
                  _loc2_ = new Array();
                  _loc2_.push(this._org.getInitiativeSkill(SkillManager.getInstance));
                  this.delSkillWindow.show(this._org,this._t,_loc2_,this.okBackFunction,DelSkillWindow.INFO1);
                  return;
               }
               if(SkillManager.getInstance.isLearnSkillFull(this._org))
               {
                  this.delSkillWindow = new DelSkillWindow();
                  _loc3_ = this._org.getQuality_name() + DelSkillWindow.INFO2_1 + this._org.getAllSkills().length + DelSkillWindow.INFO2_2;
                  this.delSkillWindow.show(this._org,this._t,this._org.getAllSkills(),this.okBackFunction,_loc3_);
                  return;
               }
            }
            this.okBackFunction(this._org,this._t);
         }
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      public function show(param1:Organism, param2:Tool, param3:Function) : void
      {
         this._org = param1;
         this.okBackFunction = param3;
         this._t = param2;
         if(int(param2.getType()) >= ToolType.TOOL_TYPE64 && int(param2.getType()) <= ToolType.TOOL_TYPE71)
         {
            this._window._text.text = LangManager.getInstance().getLanguage("exskill03",this._org.getName(),SkillManager.getInstance.getExSkillByTool(int(this._t.getType())).getName());
         }
         else
         {
            this._window._text.text = LangManager.getInstance().getLanguage("window063",this._org.getName(),SkillManager.getInstance.getLearnSkill(this._t.getLotteryName()).getName());
         }
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}


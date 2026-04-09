package pvz.compose
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import manager.LangManager;
   import manager.SkillManager;
   import node.Icon;
   import windows.ActionWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.firstPage.XmlDelSkill;
   import zlib.utils.DomainAccess;
   
   public class DelSkillWindow extends BaseWindow
   {
      
      public static var INFO1:String = LangManager.getInstance().getLanguage("window053");
      
      public static var INFO2_1:String = LangManager.getInstance().getLanguage("window054");
      
      public static var INFO2_2:String = LangManager.getInstance().getLanguage("window055");
      
      internal var okBackFunction:Function;
      
      internal var _window:MovieClip;
      
      internal var _id:int;
      
      internal var _t:Tool;
      
      internal var _org:Organism;
      
      internal var skills:Array;
      
      public function DelSkillWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("delSkillWindow");
         this._window = new _loc1_();
         this._window.visible = false;
         PlantsVsZombies._node.addChild(this._window);
         this._window.tittle.gotoAndStop(1);
         this._window.p_tittle.visible = false;
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
      
      private function onChoose(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.substring(5));
         this._id = this.skills[_loc2_ - 1].getId();
         var _loc3_:int = 1;
         while(_loc3_ <= 4)
         {
            this._window["skill" + _loc3_].bt.gotoAndStop(1);
            _loc3_++;
         }
         this._window["skill" + _loc2_].bt.gotoAndStop(2);
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._window);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "ok")
         {
            if(this._id == 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window056"));
               return;
            }
            PlantsVsZombies.showDataLoading(true);
            this._window["ok"].mouseEnabled = false;
            this.delSkill();
         }
         else if(param1.currentTarget.name == "cancel")
         {
            this.hidden();
         }
      }
      
      private function delSkill() : void
      {
         var ul:URLLoader = null;
         var onLoad:Function = null;
         onLoad = function(param1:Event):void
         {
            var _loc3_:ActionWindow = null;
            ul.removeEventListener(Event.COMPLETE,onLoad);
            var _loc2_:XmlDelSkill = new XmlDelSkill(ul.data);
            if(_loc2_.isSuccess())
            {
               _org.removeSkill(SkillManager.getInstance.getSkillById(_id));
               if(okBackFunction != null)
               {
                  okBackFunction(_org,_t);
               }
               hidden();
               _window["ok"].mouseEnabled = true;
            }
            else
            {
               if(_loc2_.errorType() == XmlBaseReader.CONNECT_ERROR1)
               {
                  PlantsVsZombies.showRushLoading();
                  return;
               }
               _loc3_ = new ActionWindow();
               _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window057"),_loc2_.error(),null,false);
            }
         };
         ul = new URLLoader();
         ul.load(new URLRequest(PlantsVsZombies.getURL("/organism/removeskill/id/" + this._id + "/organism_id/" + this._org.getId())));
         ul.addEventListener(Event.COMPLETE,onLoad);
      }
      
      private function showSkills(param1:Array) : void
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = _loc2_ + 1;
            this._window["skill" + _loc3_].visible = true;
            this._window["skill" + _loc3_].skilltext.text = "lv." + param1[_loc2_].getGrade() + " " + param1[_loc2_].getName();
            _loc2_++;
         }
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      public function show(param1:Organism, param2:Tool, param3:Array, param4:Function, param5:String) : void
      {
         var _loc6_:int = 1;
         while(_loc6_ <= 4)
         {
            this._window["skill" + _loc6_].bt.gotoAndStop(1);
            this._window["skill" + _loc6_].visible = false;
            _loc6_++;
         }
         this._id = 0;
         this._org = param1;
         this._t = param2;
         this.okBackFunction = param4;
         this.skills = param3;
         this.showSkills(param3);
         this._window._info.text = param5;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._window.visible = true;
         this.setLoction();
         onShowEffect(this._window);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
      }
   }
}


package pvz.battle.node
{
   import com.res.IDestroy;
   import entity.Organism;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import node.Icon;
   import tip.OrgUpInfoTips;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class OrgUpPrizesNode extends Sprite implements IDestroy
   {
      
      private var _pic:MovieClip;
      
      private var _tipOrgUp:OrgUpInfoTips;
      
      private var _baseOrg:Organism;
      
      private var _mc:MovieClip;
      
      private var _nowGrade:int = 0;
      
      private var _org:Organism;
      
      public function OrgUpPrizesNode(param1:Organism, param2:Organism)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("orgUpPrizesNode");
         this._mc = new _loc3_();
         this._baseOrg = param1;
         this._org = param2;
         this._pic = this._mc["pic"];
         this._mc["exp2"].visible = false;
         Icon.setUrlIcon(this._mc["pic"],param2.getPicId(),Icon.ORGANISM_1);
         this._mc["_name"].text = param2.getName();
         this._nowGrade = param1.getGrade();
         this._mc["_grade"].text = "Lv." + this._nowGrade;
         this.addChild(this._mc);
         this.setStart();
         this.exp(this.getUpPercent());
         this.setUpMcVisible();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._pic.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
      }
      
      private function removeEvent() : void
      {
         this._pic.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         if(this._org.getGrade() > this._baseOrg.getGrade())
         {
            if(this._tipOrgUp)
            {
               this._tipOrgUp.destroy();
               this._tipOrgUp = null;
            }
            this._tipOrgUp = new OrgUpInfoTips();
            this._tipOrgUp.setOrgTip(param1.currentTarget as InteractiveObject,this._baseOrg,this._org);
         }
      }
      
      private function setUpMcVisible() : void
      {
         this._mc["up_mc"].visible = this._org.getGrade() > this._baseOrg.getGrade() ? true : false;
      }
      
      public function exp(param1:int) : void
      {
         var t:Timer = null;
         var onTimer:Function = null;
         var onPlay:Function = null;
         var p:int = param1;
         onTimer = function(param1:TimerEvent):void
         {
            --p;
            if(p < 0)
            {
               t.removeEventListener(TimerEvent.TIMER,onTimer);
               t.stop();
            }
            if(_mc["exp"].scaleX >= 1)
            {
               ++_nowGrade;
               _mc["_grade"].text = "Lv." + _nowGrade;
               _mc["exp"].scaleX = 0;
               _mc["exp"].visible = false;
               _mc["exp2"].visible = true;
               t.removeEventListener(TimerEvent.TIMER,onTimer);
               t.stop();
               _mc["exp2"].gotoAndPlay(1);
               _mc["exp2"].addEventListener(Event.ENTER_FRAME,onPlay);
            }
            _mc["exp"].scaleX += 0.01;
         };
         onPlay = function(param1:Event):void
         {
            if(_mc["exp2"].totalFrames == _mc["exp2"].currentFrame)
            {
               _mc["exp2"].stop();
               _mc["exp2"].visible = false;
               _mc["exp2"].removeEventListener(Event.ENTER_FRAME,onPlay);
               exp(p);
            }
         };
         t = new Timer(30);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.start();
         this._mc["exp"].visible = true;
         this._mc["exp2"].visible = false;
      }
      
      private function addExp(param1:int) : void
      {
         var t:Timer = null;
         var onTimer:Function = null;
         var onComp:Function = null;
         var p:int = param1;
         onTimer = function(param1:TimerEvent):void
         {
            if(_mc["exp"].scaleX > 1)
            {
               _mc["exp"].scaleX = 0;
            }
            _mc["exp"].scaleX += 0.01;
         };
         onComp = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         };
         t = new Timer(30,p);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         t.start();
      }
      
      private function getUpPercent() : int
      {
         var _loc1_:int = this._org.getGrade() - this._baseOrg.getGrade();
         return int(_loc1_ * 100 + int(((this._org.getExp() - this._org.getExp_min()) / (this._org.getExp_max() - this._org.getExp_min() + 1) - (this._baseOrg.getExp() - this._baseOrg.getExp_min()) / (this._baseOrg.getExp_max() - this._baseOrg.getExp_min() + 1)) * 100));
      }
      
      private function setStart() : void
      {
         this._mc["exp"].scaleX = (this._baseOrg.getExp() - this._baseOrg.getExp_min()) / (1 + this._baseOrg.getExp_max() - this._baseOrg.getExp_min());
      }
      
      public function destroy() : void
      {
         this.removeEvent();
         if(this._tipOrgUp)
         {
            this._tipOrgUp.destroy();
            this._tipOrgUp = null;
         }
         FuncKit.clearAllChildrens(this);
      }
   }
}


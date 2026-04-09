package pvz.battle.window
{
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import manager.SoundManager;
   import manager.VersionManager;
   import pvz.battle.node.OrgUpPrizesNode;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class OrgsPrizesWindow extends BaseWindow
   {
      
      public static var NUM:int = 6;
      
      private var _backFun:Function;
      
      private var _baseNode:DisplayObjectContainer;
      
      private var _orgsPrizeWindow:MovieClip;
      
      private var _upOrgs:Array;
      
      private var _orgNodesArr:Array = [];
      
      public function OrgsPrizesWindow(param1:Function, param2:DisplayObjectContainer)
      {
         super();
         this._baseNode = param2;
         var _loc3_:Class = DomainAccess.getClass("orgsPrizeWindow");
         this._orgsPrizeWindow = new _loc3_();
         this.setVersionButton();
         this._backFun = param1;
         this.setLoaction();
         this.addClickEvent();
         this._orgsPrizeWindow.visible = false;
         this._baseNode.addChild(this._orgsPrizeWindow);
      }
      
      public function show(param1:Array, param2:Array, param3:int, param4:Function) : void
      {
         var _loc9_:Organism = null;
         var _loc10_:Organism = null;
         var _loc11_:OrgUpPrizesNode = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(param2 == null)
         {
            return;
         }
         super.showBG(this._baseNode);
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            _loc9_ = this.getOrgById(param1,param2[_loc6_]);
            if(_loc9_ != null)
            {
               _loc5_.push(param2[_loc6_]);
            }
            _loc6_++;
         }
         var _loc7_:Array = _loc5_.slice((param3 - 1) * NUM,param3 * NUM);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            if(_loc7_[_loc8_] != null)
            {
               _loc10_ = this.getOrgById(param1,_loc7_[_loc8_]);
               if(_loc10_ != null)
               {
                  _loc11_ = new OrgUpPrizesNode(_loc10_,_loc7_[_loc8_]);
                  _loc12_ = _loc8_ % 2;
                  _loc13_ = _loc8_ / 2;
                  _loc11_.x = _loc12_ * (_loc11_.width + 3) + 15;
                  _loc11_.y = _loc13_ * (_loc11_.height + 10) + 10;
                  this._orgNodesArr.push(_loc11_);
                  this._orgsPrizeWindow["matter"].addChild(_loc11_);
               }
            }
            _loc8_++;
         }
         this._orgsPrizeWindow.visible = true;
         onShowEffect(this._orgsPrizeWindow,param4);
         this._baseNode.setChildIndex(this._orgsPrizeWindow,this._baseNode.numChildren - 1);
      }
      
      private function addClickEvent() : void
      {
         this._orgsPrizeWindow["ok"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function clearOrgsNodes() : void
      {
         var _loc1_:int = 0;
         if(this._orgsPrizeWindow["matter"] != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._orgNodesArr.length)
            {
               (this._orgNodesArr[_loc1_] as OrgUpPrizesNode).destroy();
               _loc1_++;
            }
            this._orgNodesArr = null;
            FuncKit.clearAllChildrens(this._orgsPrizeWindow["matter"]);
         }
      }
      
      private function destory() : void
      {
         var t:Timer = null;
         var onTimer:Function = null;
         onTimer = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.stop();
            _baseNode.removeChild(_orgsPrizeWindow);
         };
         t = new Timer(1000);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.start();
      }
      
      private function getOrgById(param1:Array, param2:Organism) : Organism
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Organism).getId() == param2.getId())
            {
               return param1[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function hidden() : void
      {
         onHiddenEffect(this._orgsPrizeWindow);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.removeClickEvent();
         if(param1.currentTarget.name == "ok")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.clearOrgsNodes();
            if(this._backFun != null)
            {
               this._backFun();
            }
            this.hidden();
            this.destory();
         }
      }
      
      private function removeClickEvent() : void
      {
         this._orgsPrizeWindow["ok"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setLoaction() : void
      {
         this._orgsPrizeWindow.x = PlantsVsZombies.WIDTH - this._orgsPrizeWindow.width + 34;
         this._orgsPrizeWindow.y = PlantsVsZombies.HEIGHT - this._orgsPrizeWindow.height + 110;
      }
      
      private function setVersionButton() : void
      {
         if(GlobalConstants.PVZ_VERSION == VersionManager.KAIXIN_VERSION)
         {
         }
      }
   }
}


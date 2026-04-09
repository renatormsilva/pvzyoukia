package pvz.garden.window
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.garden.manager.MapManager;
   import pvz.garden.node.GardenOrgNode;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class GardenGridsWindow extends BaseWindow
   {
      
      public static var FRIEND:int = 2;
      
      public static var FRIEND_NUM:int = 12;
      
      public static var MINE:int = 1;
      
      public static var MINE_NUM:int = 6;
      
      internal var _garden:MovieClip;
      
      internal var _isAlign:Boolean = false;
      
      internal var _alignX:int = 0;
      
      internal var _alignY:int = 0;
      
      internal var _mapManager:MapManager;
      
      internal var _org:Organism;
      
      internal var _grid_id:int = 0;
      
      internal var _intoFun:Function;
      
      internal var _backFun:Function;
      
      internal var _num:int = 0;
      
      internal var _type:int = 0;
      
      internal var _window:MovieClip;
      
      internal var org_mc:GardenOrgNode;
      
      public function GardenGridsWindow(param1:MovieClip, param2:int, param3:MapManager, param4:Function, param5:Function)
      {
         var onOut:Function = null;
         var onCancel:Function = null;
         var onCancelOver:Function = null;
         var onCancelOut:Function = null;
         var onMove:Function = null;
         var temp:Class = null;
         var garden:MovieClip = param1;
         var type:int = param2;
         var _mapManager:MapManager = param3;
         var intoFun:Function = param4;
         var backFun:Function = param5;
         super();
         onOut = function(param1:MouseEvent):void
         {
            _isAlign = false;
         };
         onCancel = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            hidden();
         };
         onCancelOver = function(param1:MouseEvent):void
         {
            org_mc.visible = false;
         };
         onCancelOut = function(param1:MouseEvent):void
         {
            org_mc.visible = true;
         };
         onMove = function(param1:MouseEvent):void
         {
            if(org_mc == null)
            {
               return;
            }
            org_mc.mouseChildren = false;
            org_mc.mouseEnabled = false;
            if(_isAlign)
            {
               org_mc.mouseEnabled = true;
               org_mc.x = _alignX;
               org_mc.y = _alignY;
               if(isIntoGrid())
               {
                  org_mc.setGridType(GardenOrgNode.CAN);
               }
               else
               {
                  org_mc.setGridType(GardenOrgNode.CANNOT);
               }
            }
            else
            {
               org_mc.x = param1.stageX - _window.x;
               org_mc.y = param1.stageY - _window.y;
               org_mc.setGridType(GardenOrgNode.CANNOT);
            }
         };
         this._type = type;
         this._garden = garden;
         this._mapManager = _mapManager;
         this._intoFun = intoFun;
         this._backFun = backFun;
         if(this._type == FRIEND)
         {
            temp = DomainAccess.getClass("garden_gridsWindow_friend");
         }
         else if(this._type == MINE)
         {
            temp = DomainAccess.getClass("garden_gridsWindow_mine");
         }
         this._window = new temp();
         this._window.visible = false;
         this._window.addEventListener(MouseEvent.ROLL_OUT,onOut);
         this._window["cancel"].y = -PlantsVsZombies._node["draw"].y - 215 + 400;
         if(type == FRIEND)
         {
            this._window["cancel"].x = -PlantsVsZombies._node["draw"].x - 120 + 660;
         }
         else
         {
            this._window["cancel"].x = -PlantsVsZombies._node["draw"].x - 550 + 660;
         }
         this._window["cancel"].addEventListener(MouseEvent.CLICK,onCancel);
         this._window["cancel"].addEventListener(MouseEvent.ROLL_OVER,onCancelOver);
         this._window["cancel"].addEventListener(MouseEvent.ROLL_OUT,onCancelOut);
         this.setLoction();
         PlantsVsZombies._node.addChild(this._window);
         this._window.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      private function isIntoGrid() : Boolean
      {
         if(this._mapManager == null)
         {
            return false;
         }
         return this._mapManager.isInMap(this._grid_id,this._org);
      }
      
      public function show(param1:Organism) : void
      {
         var into:Function = null;
         var org:Organism = param1;
         into = function(param1:MouseEvent):void
         {
            if(_isAlign && isIntoGrid())
            {
               if(_type == MINE)
               {
                  _intoFun(org,true,_grid_id,hidden);
               }
               else
               {
                  _intoFun(org,false,_grid_id,hidden);
               }
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window084"));
            }
         };
         this._num = this._mapManager._num;
         this.addGridsMouseEvent();
         this._window.visible = true;
         this.showGrids();
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.setChildIndex(this._window,PlantsVsZombies._node.numChildren - 1);
         this._org = org;
         this.org_mc = new GardenOrgNode(org,null,"",0);
         this.org_mc.setState(GardenOrgNode.PUTING);
         this.org_mc.addEventListener(MouseEvent.CLICK,into);
         this._window.addChild(this.org_mc);
         if(this._isAlign)
         {
            this.org_mc.x = this._alignX;
            this.org_mc.y = this._alignY;
            if(this.isIntoGrid())
            {
               this.org_mc.setGridType(GardenOrgNode.CAN);
            }
            else
            {
               this.org_mc.setGridType(GardenOrgNode.CANNOT);
            }
         }
         else
         {
            this.org_mc.x = mouseX - this._window.x;
            this.org_mc.y = mouseY - this._window.y;
            this.org_mc.setGridType(GardenOrgNode.CANNOT);
         }
      }
      
      private function addGridsMouseEvent() : void
      {
         var _loc1_:int = 0;
         if(this._type == FRIEND)
         {
            _loc1_ = FRIEND_NUM;
         }
         else if(this._type == MINE)
         {
            _loc1_ = MINE_NUM;
         }
         var _loc2_:int = 1;
         while(_loc2_ <= _loc1_)
         {
            this._window["g" + _loc2_].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc2_++;
         }
      }
      
      private function removeGridsMouseEvent() : void
      {
         var _loc1_:int = 0;
         if(this._type == FRIEND)
         {
            _loc1_ = FRIEND_NUM;
         }
         else if(this._type == MINE)
         {
            _loc1_ = MINE_NUM;
         }
         var _loc2_:int = 1;
         while(_loc2_ < _loc1_ + 1)
         {
            this._window["g" + _loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc2_++;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._isAlign = true;
         this._alignX = param1.target.x + param1.target.parent.x - this._window.x;
         this._alignY = param1.target.y + param1.target.parent.y - this._window.y;
         this._grid_id = param1.currentTarget.name.substring(1);
      }
      
      private function hidden() : void
      {
         this.removeGridsMouseEvent();
         this._window.visible = false;
         super.removeBG();
         FuncKit.clearAllChildrens(this.org_mc);
         this._backFun();
      }
      
      private function setLoction() : void
      {
         this._window.y = 160 + PlantsVsZombies._node["draw"].y;
         if(this._type == FRIEND)
         {
            this._window.x = 140 + PlantsVsZombies._node["draw"].x;
         }
         else if(this._type == MINE)
         {
            this._window.x = 570 + PlantsVsZombies._node["draw"].x;
         }
      }
      
      private function showGrids() : void
      {
         var _loc1_:int = 0;
         if(this._type == FRIEND)
         {
            _loc1_ = FRIEND_NUM;
         }
         else if(this._type == MINE)
         {
            _loc1_ = MINE_NUM;
         }
         var _loc2_:int = 1;
         while(_loc2_ <= _loc1_)
         {
            if(_loc2_ > this._num)
            {
               this._window["g" + _loc2_].gotoAndStop(2);
            }
            else
            {
               this._window["g" + _loc2_].gotoAndStop(1);
            }
            _loc2_++;
         }
      }
   }
}


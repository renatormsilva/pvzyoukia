package core.ui.panel
{
   import com.greensock.TweenLite;
   import com.res.IDestroy;
   import core.interfaces.IPanel;
   import core.interfaces.IView;
   import core.managers.DistributionLoaderManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import zlib.utils.DomainAccess;
   
   public class BaseWindow extends Sprite implements IPanel, IView, IDestroy
   {
      
      protected static var PANEL_TYPE_1:String = "PANEL_TYPE_1";
      
      protected static var PANEL_TYPE_2:String = "PANEL_TYPE_2";
      
      public var _bg:MovieClip;
      
      public var _base:DisplayObjectContainer;
      
      protected var showType:String = "";
      
      protected var onBackCall:Function = null;
      
      public function BaseWindow(param1:String = "publicResouce")
      {
         var end:Function;
         var winName:String = param1;
         super();
         if(winName == "publicResouce")
         {
            this.initWindowUI();
         }
         else
         {
            end = function():void
            {
               initWindowUI();
            };
            DistributionLoaderManager.I.loadUIByFunctionType(winName,end);
         }
      }
      
      protected function initWindowUI() : void
      {
      }
      
      public function destroy() : void
      {
      }
      
      public function onShow() : void
      {
         this.showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this);
         if(this.showType == PANEL_TYPE_1)
         {
            this.onShowEffectBig(this,this.onBackCall);
         }
         else if(this.showType == PANEL_TYPE_2)
         {
            this.onShowEffect(this,this.onBackCall);
         }
      }
      
      public function onHide() : void
      {
         var display:Sprite = null;
         var close:Function = null;
         close = function():void
         {
            removeBG();
            parent.removeChild(display);
            if(onBackCall != null)
            {
               onBackCall();
            }
         };
         if(this.showType == PANEL_TYPE_1)
         {
            this.onHiddenEffectBig(this,close);
         }
         else if(this.showType == PANEL_TYPE_2)
         {
            this.onHiddenEffect(this,close);
         }
         display = this;
      }
      
      public function showBG(param1:DisplayObjectContainer, param2:int = 0) : void
      {
         this.removeBG();
         var _loc3_:Class = DomainAccess.getClass("showbg");
         this._bg = new _loc3_();
         this._bg.alpha = param2;
         this._base = param1;
         this._base.addChild(this._bg);
         this._base.setChildIndex(this._bg,param1.numChildren - 1);
      }
      
      public function removeBG() : void
      {
         try
         {
            if(this._base != null && this._base.numChildren > 0 && this._bg != null)
            {
               this._base.removeChild(this._bg);
            }
         }
         catch(e:ArgumentError)
         {
         }
         this._bg = null;
      }
      
      public function onShowEffectSamll(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var func:Function = null;
         var disc:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         func = function():void
         {
            if(backFun != null)
            {
               backFun();
            }
         };
         disc.scaleX = 0.01;
         disc.scaleY = 0.01;
         disc.alpha = 0.01;
         TweenLite.to(disc,0.5,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1,
            "onComplete":func
         });
      }
      
      public function onHideEffectSamll(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var func:Function = null;
         var disc:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         func = function():void
         {
            if(backFun != null)
            {
               backFun();
            }
         };
         disc.scaleX = 1;
         disc.scaleY = 1;
         disc.alpha = 1;
         TweenLite.to(disc,0.5,{
            "scaleX":0.01,
            "scaleY":0.01,
            "alpha":0.01,
            "onComplete":func
         });
      }
      
      public function onHiddenEffect(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var times:int = 0;
         var max:int = 0;
         var onPlay:Function = null;
         var disc:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         onPlay = function(param1:Event):void
         {
            ++times;
            if(times < 3)
            {
               disc.scaleX += 0.025;
               disc.scaleY += 0.025;
            }
            else
            {
               disc.scaleX -= 0.025;
               disc.scaleY -= 0.025;
               disc.alpha -= 0.2;
            }
            if(times == max)
            {
               PlantsVsZombies._node.stage.removeEventListener(Event.ENTER_FRAME,onPlay);
               disc.visible = false;
               disc.scaleX = 1;
               disc.scaleY = 1;
               if(backFun != null)
               {
                  backFun();
               }
               removeBG();
            }
         };
         PlantsVsZombies._node.stage.addEventListener(Event.ENTER_FRAME,onPlay);
         times = 0;
         max = 4;
      }
      
      public function onShowEffect(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var max:int = 0;
         var times:int = 0;
         var onPlay:Function = null;
         var _dis:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         onPlay = function(param1:Event):void
         {
            ++times;
            if(times < 3)
            {
               _dis.alpha += 0.5;
               _dis.scaleX += 0.025;
               _dis.scaleY += 0.025;
            }
            else
            {
               _dis.scaleX -= 0.025;
               _dis.scaleY -= 0.025;
            }
            if(max == times)
            {
               PlantsVsZombies._node.stage.removeEventListener(Event.ENTER_FRAME,onPlay);
               if(backFun != null)
               {
                  backFun();
               }
            }
         };
         PlantsVsZombies._node.stage.addEventListener(Event.ENTER_FRAME,onPlay);
         _dis.visible = true;
         max = 4;
         times = 0;
         _dis.alpha = 0;
      }
      
      public function onShowEffectBig(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var times:int = 0;
         var max:int = 0;
         var onPlay:Function = null;
         var _dis:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         onPlay = function(param1:Event):void
         {
            ++times;
            if(times < 9)
            {
               _dis.y += PlantsVsZombies.HEIGHT / 8;
            }
            else if(times < 11)
            {
               _dis.y -= 3;
            }
            else
            {
               _dis.y += 3;
            }
            if(times == max)
            {
               PlantsVsZombies._node.stage.removeEventListener(Event.ENTER_FRAME,onPlay);
               if(backFun != null)
               {
                  backFun();
               }
            }
         };
         _dis.alpha = 1;
         _dis.visible = true;
         PlantsVsZombies._node.stage.addEventListener(Event.ENTER_FRAME,onPlay);
         times = 0;
         max = 12;
         _dis.x = 0;
         _dis.y = -PlantsVsZombies.HEIGHT;
      }
      
      public function onHiddenEffectBig(param1:DisplayObjectContainer, param2:Function = null) : void
      {
         var times:int = 0;
         var max:int = 0;
         var onPlay:Function = null;
         var _dis:DisplayObjectContainer = param1;
         var backFun:Function = param2;
         onPlay = function(param1:Event):void
         {
            ++times;
            _dis.y += _dis.height / 8;
            if(times > 4)
            {
               _dis.alpha -= 0.1;
            }
            if(times == max)
            {
               PlantsVsZombies._node.stage.removeEventListener(Event.ENTER_FRAME,onPlay);
               _dis.visible = false;
               removeBG();
               if(backFun != null)
               {
                  backFun();
               }
            }
         };
         PlantsVsZombies._node.stage.addEventListener(Event.ENTER_FRAME,onPlay);
         times = 0;
         max = 8;
      }
   }
}


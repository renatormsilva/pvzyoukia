package pvz.firstpage.otherhelp
{
   import core.managers.GameManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import utils.GetDomainRes;
   
   public class AddButtonEffectMC extends Sprite
   {
      
      private var _mc:MovieClip;
      
      public function AddButtonEffectMC(param1:int)
      {
         super();
         if(param1 == 1)
         {
            this._mc = GetDomainRes.getMoveClip("addButtonEffectB");
         }
         else if(param1 == 2)
         {
            this._mc = GetDomainRes.getMoveClip("addButtonEffectS");
         }
      }
      
      public function show(param1:DisplayObject) : void
      {
         var gobalPoint:Point;
         var time:int = 0;
         var onEnterFrame:Function = null;
         var dis:DisplayObject = param1;
         onEnterFrame = function(param1:Event):void
         {
            if(_mc.currentFrame >= _mc.totalFrames)
            {
               ++time;
               if(time >= 2)
               {
                  _mc.stop();
                  GameManager.getInstance().pvzNode.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
                  PlantsVsZombies._node.removeChild(_mc);
               }
               else
               {
                  _mc.gotoAndPlay(1);
               }
            }
         };
         time = 0;
         PlantsVsZombies._node.addChild(this._mc);
         gobalPoint = dis.localToGlobal(new Point(0,0));
         this._mc.x = gobalPoint.x;
         this._mc.y = gobalPoint.y;
         GameManager.getInstance().pvzNode.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
   }
}


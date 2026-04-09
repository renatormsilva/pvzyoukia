package node
{
   import com.display.CMovieClip;
   import entity.Organism;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   import manager.EffectManager;
   import manager.OrganismManager;
   import tip.OrgTip;
   import utils.GlowTween;
   import zmyth.res.IDestroy;
   
   public class OrganismNode extends Sprite implements IDestroy
   {
      
      public static const BATTLE_READY:int = 1;
      
      public static const CHECKPOINT_READY:int = 2;
      
      internal var _o:Organism = null;
      
      public var _sp:OrgLoader;
      
      private var type:int = 0;
      
      private var _loc:int = 0;
      
      private var tips:OrgTip;
      
      private var lightC:CMovieClip = null;
      
      public function OrganismNode(param1:Organism, param2:int, param3:int, param4:Boolean = true)
      {
         super();
         this._sp = new OrgLoader(param1.getPicId(),param2,this.setOrgLoction,param1.getSize(),param4);
         this._sp.buttonMode = true;
         this._o = param1;
         this._loc = param2;
         this.addEvent();
         if(param1.getBlood() == OrganismManager.ZOMBIE || param1.getBlood() == OrganismManager.COPY_ZOMBIE)
         {
            this.setGlowTween();
         }
         else
         {
            new GlowTween(this._sp,16777113);
         }
         this.type = param3;
         this.addChild(this._sp);
         this.setLightEffect();
      }
      
      private function setLightEffect() : void
      {
         this.lightC = EffectManager.getQualityEffect(this._o);
         if(this.lightC != null)
         {
            this.lightC.mouseChildren = false;
            this.lightC.mouseEnabled = false;
            addChild(this.lightC);
         }
      }
      
      private function changeLightLoc() : void
      {
      }
      
      public function destroy() : void
      {
         if(this.tips != null)
         {
            this.tips.destroy();
         }
         this.removeEvent();
         this.setGlowTween(true);
         this._sp.destroy();
         this._sp.filters = null;
      }
      
      private function setOrgLoction() : void
      {
         this._sp.x = 0;
         this._sp.y = 0;
         this.changeLightLoc();
      }
      
      private function setGlowTween(param1:Boolean = false) : void
      {
         var _toggle:Boolean;
         var t:Timer = null;
         var _blur:Number = NaN;
         var onTimer:Function = null;
         var stop:Boolean = param1;
         onTimer = function(param1:TimerEvent):void
         {
            var _loc3_:uint = 0;
            if(_o.getDifficulty() == 1)
            {
               _loc3_ = 13434777;
            }
            else if(_o.getDifficulty() == 2)
            {
               _loc3_ = 13158600;
            }
            else
            {
               _loc3_ = 16728642;
            }
            var _loc2_:GlowFilter = new GlowFilter(_loc3_,1,_blur,_blur,5,2);
            _sp.filters = [_loc2_];
         };
         if(t != null)
         {
            t.stop();
            t.removeEventListener(TimerEvent.TIMER,onTimer);
         }
         if(stop)
         {
            return;
         }
         t = new Timer(800);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.start();
         _blur = 2;
         _toggle = true;
      }
      
      private function addEvent() : void
      {
         this._sp.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
      }
      
      private function removeEvent() : void
      {
         this._sp.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new OrgTip();
         }
         this.tips.setOrgtip(this._sp,this._o);
         this.tips.showTips();
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      public function getPositionX() : int
      {
         if(this.type == BATTLE_READY)
         {
            return this._sp.parent.x + this._sp.parent.parent.x + this._sp.parent.parent.parent.x + this._sp.parent.parent.parent.parent.x - this._sp.getWidth() / 2 - this.tips.width;
         }
         if(this.type == CHECKPOINT_READY)
         {
            return this.x + this._sp.getWidth() / 2;
         }
         return 0;
      }
      
      public function getPositionY() : int
      {
         if(this.type == BATTLE_READY)
         {
            return this._sp.parent.y + this._sp.parent.parent.y + this._sp.parent.parent.parent.y + this._sp.parent.parent.parent.parent.y - 140;
         }
         if(this.type == CHECKPOINT_READY)
         {
            return this.y - 120;
         }
         return 0;
      }
   }
}


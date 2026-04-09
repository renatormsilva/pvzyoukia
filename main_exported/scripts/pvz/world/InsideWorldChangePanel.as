package pvz.world
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class InsideWorldChangePanel extends Sprite implements IDestroy
   {
      
      private var _panelLabel:MovieClip = null;
      
      private var _infos:Array = null;
      
      private var _nowId:int = 0;
      
      private var sp:Sprite = null;
      
      public function InsideWorldChangePanel(param1:int)
      {
         super();
         this._nowId = param1;
         this.initUI();
         this.addEvent();
      }
      
      public function update(param1:Array) : void
      {
         var _loc4_:InsideWorldNode = null;
         this.clearInfos();
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         if(param1.length == 1)
         {
            this.visible = false;
            return;
         }
         this.visible = true;
         this._infos = new Array();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new InsideWorldNode(param1[_loc3_],this._nowId);
            _loc4_.addEventListener(InsideWorldEvent.CHANGE,this.onClick);
            _loc4_.endX = _loc2_;
            _loc4_.alpha = 0;
            this._infos.push(_loc4_);
            _loc2_ += _loc4_.width;
            _loc3_++;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:InsideWorldNode = param1.currentTarget as InsideWorldNode;
         _loc2_.x += 60;
         _loc2_.alpha += 0.2;
         _loc2_.y = 30;
         if(_loc2_.x >= _loc2_.endX)
         {
            _loc2_.x = _loc2_.endX;
            _loc2_.alpha = 1;
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onClick(param1:InsideWorldEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         dispatchEvent(new InsideWorldEvent(InsideWorldEvent.CHANGE,param1.id));
      }
      
      private function clearInfos() : void
      {
         if(this._infos == null || this._infos.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._infos.length)
         {
            (this._infos[_loc1_] as InsideWorldNode).destroy();
            this._infos[_loc1_] = null;
            _loc1_++;
         }
         this._infos = null;
      }
      
      private function resetNodesLoc() : void
      {
         if(this._infos == null || this._infos.length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._infos.length)
         {
            (this._infos[_loc1_] as InsideWorldNode).x = 0;
            (this._infos[_loc1_] as InsideWorldNode).y = 0;
            _loc1_++;
         }
      }
      
      public function destroy() : void
      {
         this.removeEvent();
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("ui.world.changeInsideworld");
         this._panelLabel = new _loc1_();
         this._panelLabel.x = this._panelLabel.width + 2;
         this._panelLabel.y = PlantsVsZombies.HEIGHT - this._panelLabel.height - 4;
         addChild(this._panelLabel);
         this.visible = false;
      }
      
      private function addEvent() : void
      {
         this._panelLabel.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._panelLabel.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         this._panelLabel.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._panelLabel.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._infos == null || this._infos.length < 1)
         {
            return;
         }
         this.sp = new Sprite();
         var _loc2_:int = 0;
         while(_loc2_ < this._infos.length)
         {
            this._infos[_loc2_].addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.sp.addChildAt(this._infos[_loc2_],0);
            _loc2_++;
         }
         this._panelLabel.addChildAt(this.sp,0);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._panelLabel.removeChild(this.sp);
         if(this.sp != null)
         {
            FuncKit.clearAllChildrens(this.sp);
         }
         this.sp = null;
         this.resetNodesLoc();
      }
      
      private function getArrivedArray() : Array
      {
         return this._infos;
      }
   }
}


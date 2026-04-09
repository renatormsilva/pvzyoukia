package pvz.copy.ui.windows
{
   import core.managers.GameManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class StoneScaleButton extends Sprite implements IDestroy
   {
      
      private var _scaledis:DisplayObject = null;
      
      private var scaleInfos:Array = null;
      
      private var _panel:MovieClip = null;
      
      private var _index:int = -1;
      
      private var m_backCall:Function;
      
      public function StoneScaleButton(param1:DisplayObject, param2:int = 3, param3:Function = null)
      {
         super();
         this._scaledis = param1;
         this.m_backCall = param3;
         this.initUI();
         this.initScales(param2);
      }
      
      public function destroy() : void
      {
         this.removeEvent();
      }
      
      private function initScales(param1:int) : void
      {
         this.scaleInfos = new Array();
         var _loc2_:Number = PlantsVsZombies.WIDTH / this._scaledis.width;
         var _loc3_:Number = PlantsVsZombies.HEIGHT / this._scaledis.height;
         var _loc4_:Number = Math.max(_loc2_,_loc3_);
         var _loc5_:Number = (1 - _loc4_) / (param1 - 1);
         var _loc6_:int = 0;
         while(_loc6_ < param1 - 1)
         {
            this.scaleInfos.push(_loc4_ + _loc5_ * _loc6_);
            _loc6_++;
         }
         this.scaleInfos.push(1);
         this._index = this.scaleInfos.length - 1;
         this.changeColor();
      }
      
      private function initUI() : void
      {
         var _loc1_:Class = DomainAccess.getClass("copy.stone.scaletack");
         this._panel = new _loc1_();
         this.initEvent();
         this.addChild(this._panel);
      }
      
      private function initEvent() : void
      {
         this._panel["_bt_add"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_dec"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._panel["_bt_add"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_dec"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_bt_add")
         {
            if(this._index == this.scaleInfos.length - 1)
            {
               return;
            }
            ++this._index;
            this.changeScale();
         }
         else if(param1.currentTarget.name == "_bt_dec")
         {
            if(this._index == 0)
            {
               return;
            }
            --this._index;
            this.changeScale();
         }
         this.changeColor();
      }
      
      private function changeColor() : void
      {
         this._panel["_bt_add_noColor"].visible = false;
         this._panel["_bt_dec_noColor"].visible = false;
         FuncKit.clearNoColorState(this._panel["_bt_dec"]);
         if(this._index == 0)
         {
            this._panel["_bt_dec_noColor"].visible = true;
         }
         else if(this._index == this.scaleInfos.length - 1)
         {
            this._panel["_bt_add_noColor"].visible = true;
         }
      }
      
      private function changeScale() : void
      {
         this._scaledis.scaleX = this.scaleInfos[this._index];
         this._scaledis.scaleY = this.scaleInfos[this._index];
         if(this.m_backCall != null)
         {
            this.m_backCall(GameManager.m_gameWidth / 2,GameManager.m_gameHeight / 2);
         }
      }
      
      public function reset() : void
      {
         this._index = this.scaleInfos.length - 1;
         this._scaledis.scaleX = this.scaleInfos[this.scaleInfos.length - 1];
         this._scaledis.scaleY = this.scaleInfos[this.scaleInfos.length - 1];
         if(this.m_backCall != null)
         {
            this.m_backCall(GameManager.m_gameWidth / 2,GameManager.m_gameHeight / 2);
         }
      }
   }
}


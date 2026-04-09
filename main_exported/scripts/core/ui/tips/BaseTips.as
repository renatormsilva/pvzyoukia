package core.ui.tips
{
   import com.res.IDestroy;
   import core.managers.GameManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.GetDomainRes;
   
   public class BaseTips extends Sprite implements IDestroy
   {
      
      protected var _ui:MovieClip;
      
      protected var _bg:TipBg;
      
      protected var _leftgap:Number = 12;
      
      protected var _upgap:Number = 12;
      
      protected var _col:uint;
      
      public function BaseTips(param1:String = "", param2:Boolean = false, param3:uint = 15722382, param4:Number = 12, param5:Number = 12)
      {
         this._col = param3;
         super();
         if(param1 == "")
         {
            return;
         }
         this._ui = GetDomainRes.getMoveClip(param1);
         if(!param2)
         {
            this._bg = new TipBg();
            addChild(this._bg);
            this._bg.draw(this._ui.width + param5,this._ui.height + param4,param3);
         }
         if(this._ui)
         {
            if(!param2)
            {
               this._bg.addChild(this._ui);
            }
            else
            {
               addChild(this._ui);
            }
         }
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._leftgap = param5;
         this._upgap = param4;
      }
      
      public function show(param1:Object) : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function showTips(param1:MouseEvent = null) : void
      {
         GameManager.getInstance().showTips(this,param1);
      }
      
      public function hideTips() : void
      {
         GameManager.getInstance().hideTips();
      }
      
      protected function layout() : void
      {
         this._ui.x = this._leftgap / 2;
         this._ui.y = this._upgap / 2;
      }
      
      public function setLocation(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function destroy() : void
      {
         throw new Error("此方法必须重写");
      }
      
      public function clear() : void
      {
      }
      
      protected function getColorByLevel(param1:int) : uint
      {
         if(param1 == 0)
         {
            return 16777215;
         }
         if(param1 >= 1 && param1 <= 4)
         {
            return 16776960;
         }
         if(param1 >= 5 && param1 <= 8)
         {
            return 13109453;
         }
         if(param1 >= 9)
         {
            return 16646144;
         }
         return 10066329;
      }
      
      protected function getSoulColorByLevel(param1:int) : uint
      {
         if(param1 == 1)
         {
            return 16777215;
         }
         if(param1 == 2)
         {
            return 9621584;
         }
         if(param1 == 3)
         {
            return 1943295;
         }
         if(param1 == 4)
         {
            return 2646180;
         }
         if(param1 == 5)
         {
            return 6684927;
         }
         if(param1 == 6)
         {
            return 16724940;
         }
         if(param1 == 7)
         {
            return 16776960;
         }
         if(param1 == 8)
         {
            return 16225862;
         }
         if(param1 == 9 || param1 == 10)
         {
            return 16711680;
         }
         return 12566463;
      }
   }
}

import flash.display.Sprite;

class TipBg extends Sprite
{
   
   public function TipBg()
   {
      super();
   }
   
   public function draw(param1:Number = 0, param2:Number = 0, param3:uint = 15722382) : void
   {
      this.graphics.clear();
      this.graphics.lineStyle(2,param3);
      this.graphics.beginFill(922887,0.85);
      this.graphics.drawRoundRect(0,0,param1,param2,10,10);
      this.graphics.endFill();
   }
}

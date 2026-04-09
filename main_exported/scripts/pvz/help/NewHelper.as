package pvz.help
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Rectangle;
   import utils.FuncKit;
   
   public class NewHelper
   {
      
      private static var _I:NewHelper;
      
      public static const ARROW_UP:int = 0;
      
      public static const ARROW_DOWN:int = 1;
      
      public static const ARROW_LEFT:int = 2;
      
      public static const ARROW_RIGHT:int = 3;
      
      public static const ARROW_GAP:int = 20;
      
      private var _layer:DisplayObjectContainer;
      
      private var _currentTeachSprite:HelpMaskSprite;
      
      private var helpPanel:HelpPanel;
      
      private var _isOff:Boolean = false;
      
      public function NewHelper(param1:PrivateClass)
      {
         super();
      }
      
      public static function get I() : NewHelper
      {
         if(_I == null)
         {
            _I = new NewHelper(new PrivateClass());
         }
         return _I;
      }
      
      public function set isOff(param1:Boolean) : void
      {
         this._isOff = param1;
      }
      
      public function showHelpForIndeedPoint(param1:DisplayObjectContainer = null, param2:Rectangle = null, param3:String = "", param4:int = 0, param5:Number = 200, param6:String = "", param7:Function = null, param8:Rectangle = null) : void
      {
         if(this._isOff)
         {
            return;
         }
         this.closeHelp();
         this._layer = param1;
         if(!this._layer)
         {
            this._layer = PlantsVsZombies._node;
         }
         this._currentTeachSprite = new HelpMaskSprite(param2,param8);
         if(this._layer)
         {
            this._layer.addChild(this._currentTeachSprite);
         }
         this.helpPanel = new HelpPanel();
         this.helpPanel.createPanel(param3,param4,param5,param7,param6);
         this._currentTeachSprite.addChild(this.helpPanel);
         this.location(this.helpPanel,param2,param4);
      }
      
      private function location(param1:DisplayObject, param2:Rectangle, param3:int) : void
      {
         if(param3 == ARROW_UP)
         {
            param1.x = param2.x + param2.width / 2;
            param1.y = param2.y + param2.height + param1.height / 2 + ARROW_GAP;
         }
         else if(param3 == ARROW_DOWN)
         {
            param1.x = param2.x + param2.width / 2;
            param1.y = param2.y - param1.height / 2 - ARROW_GAP;
         }
         else if(param3 == ARROW_LEFT)
         {
            param1.x = param2.x + param2.width + param1.width / 2 + ARROW_GAP;
            param1.y = param2.y + param2.height / 2;
         }
         else if(param3 == ARROW_RIGHT)
         {
            param1.x = param2.x - param1.width / 2 - ARROW_GAP;
            param1.y = param2.y + param2.height / 2;
         }
      }
      
      public function closeHelp() : void
      {
         if(this.helpPanel)
         {
            this.helpPanel.destory();
         }
         if(this._currentTeachSprite)
         {
            FuncKit.clearAllChildrens(this._currentTeachSprite);
         }
         if(Boolean(this._layer) && this._layer.contains(this._currentTeachSprite))
         {
            this._layer.removeChild(this._currentTeachSprite);
         }
      }
   }
}

import core.managers.GameManager;
import flash.display.Sprite;
import flash.geom.Rectangle;

class HelpMaskSprite extends Sprite
{
   
   public function HelpMaskSprite(param1:Rectangle, param2:Rectangle)
   {
      super();
      this.graphics.clear();
      this.graphics.beginFill(0,0.7);
      this.graphics.drawRect(0,0,GameManager.pvzStage.stageWidth,GameManager.pvzStage.stageHeight);
      this.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
      if(param2)
      {
         this.graphics.drawRect(param2.x,param2.y,param2.width,param2.height);
      }
      this.graphics.endFill();
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}

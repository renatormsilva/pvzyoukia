package pvz.serverbattle.knockout.scene
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class LineAndPlayerNodeManager
   {
      
      public static const red:uint = 16736256;
      
      public static const green:uint = 58623;
      
      public static const yellow:uint = 16771378;
      
      public static const b:uint = 4;
      
      public var w:uint = 30;
      
      public var h:uint = 30;
      
      public var w_span:uint = 176;
      
      public var h_span:uint = 85;
      
      private var _node:Sprite;
      
      private var linesp:Shape;
      
      private var playerSp:Sprite;
      
      private var _winerbaseui:WinerPanel;
      
      private var judgeloser:Boolean = false;
      
      private var references:Array;
      
      private var hasWiner:Boolean = false;
      
      public function LineAndPlayerNodeManager(param1:Sprite, param2:Array)
      {
         var _loc4_:int = 0;
         this.references = [[0,0,1,0,1,1,2.5,1,2.5,3,3.6,3,3.6,7,6.8,7,6.8,5],[0,2,1,2,1,1,2.5,1,2.5,3,3.6,3,3.6,7,6.8,7,6.8,5],[0,4,1,4,1,5,2.5,5,2.5,3,3.6,3,3.6,7,6.8,7,6.8,5],[0,6,1,6,1,5,2.5,5,2.5,3,3.6,3,3.6,7,6.8,7,6.8,5],[0,8,1,8,1,9,2.5,9,2.5,11,3.6,11,3.6,7,6.8,7,6.8,5],[0,10,1,10,1,9,2.5,9,2.5,11,3.6,11,3.6,7,6.8,7,6.8,5],[0,12,1,12,1,13,2.5,13,2.5,11,3.6,11,3.6,7,6.8,7,6.8,5],[0,14,1,14,1,13,2.5,13,2.5,11,3.6,11,3.6,7,6.8,7,6.8,5]];
         super();
         this._node = param1;
         this.linesp = new Shape();
         this.playerSp = new Sprite();
         this._node.addChildAt(this.linesp,1);
         this._node.addChild(this.playerSp);
         var _loc3_:int = int(param2.length);
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ < 8)
            {
               this.initData(this.references[_loc4_],0,param2[_loc4_]);
            }
            else
            {
               this.initData(this.references[_loc4_ - 8],1,param2[_loc4_]);
            }
            _loc4_++;
         }
         this.showWinerNode(null);
         var _loc5_:GlowFilter = new GlowFilter();
         _loc5_.color = 0;
         _loc5_.strength = 3.5;
         _loc5_.quality = 3;
         _loc5_.blurX = _loc5_.blurY = 10;
         this.linesp.filters = [_loc5_];
      }
      
      private function initData(param1:Array, param2:int = 0, param3:Pothunter = null) : void
      {
         var _loc4_:Point = null;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc5_:Array = [];
         var _loc6_:int = int(param1.length);
         if(param3.getwin4() == 1)
         {
            this.showWinerNode(param3);
         }
         while(_loc7_ < _loc6_)
         {
            if(_loc7_ % 2 == 0)
            {
               if(param1[_loc7_ + 1] == null)
               {
                  return;
               }
               _loc4_ = new Point();
               if(param2 == 1)
               {
                  _loc4_.x = PlantsVsZombies.WIDTH - (param1[_loc7_] * this.w + this.w_span);
               }
               else
               {
                  _loc4_.x = param1[_loc7_] * this.w + this.w_span;
               }
               _loc4_.y = param1[_loc7_ + 1] * this.h + this.h_span;
               if(_loc7_ == 0)
               {
                  if(param2 == 1)
                  {
                     param3.x = _loc4_.x;
                  }
                  else
                  {
                     param3.x = _loc4_.x - param3.width;
                  }
                  param3.y = _loc4_.y - 13;
                  this.playerSp.addChild(param3);
               }
               _loc5_.push(_loc4_);
            }
            _loc7_++;
         }
         var _loc8_:uint = 1;
         while(_loc9_ < _loc5_.length - 1)
         {
            if(param3.getwin4() == 1)
            {
               _loc10_ = this.setColor(4);
            }
            else if(_loc9_ >= 0 && _loc9_ < 2)
            {
               _loc10_ = this.setColor(param3.getwin1());
            }
            else if(_loc9_ >= 2 && _loc9_ < 4)
            {
               _loc10_ = this.setColor(param3.getwin2());
            }
            else if(_loc9_ >= 4 && _loc9_ < 6)
            {
               _loc10_ = this.setColor(param3.getwin3());
            }
            else if(_loc9_ >= 6 && _loc9_ < 9)
            {
               _loc10_ = this.setColor(param3.getwin4());
            }
            if(_loc5_[_loc9_].x == 380 && this.hasWiner)
            {
               break;
            }
            this.drawLine(_loc5_[_loc9_],_loc5_[_loc9_ + 1],_loc10_);
            if(_loc5_[_loc9_].x == 380 && param3.getwin4() == 1)
            {
               this.hasWiner = true;
            }
            if(_loc10_ == green && this.judgeloser)
            {
               if(_loc8_ == 2)
               {
                  break;
               }
               _loc8_++;
            }
            _loc9_++;
         }
      }
      
      private function setColor(param1:int) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = red;
               this.judgeloser = false;
               break;
            case 2:
               _loc2_ = green;
               this.judgeloser = false;
               break;
            case 3:
               _loc2_ = green;
               this.judgeloser = true;
               break;
            case 4:
               _loc2_ = yellow;
               this.judgeloser = false;
         }
         return _loc2_;
      }
      
      public function drawLine(param1:Point, param2:Point, param3:uint) : void
      {
         this.linesp.graphics.lineStyle(b,param3,0.9);
         this.linesp.graphics.moveTo(param1.x,param1.y);
         this.linesp.graphics.lineTo(param2.x,param2.y);
      }
      
      private function showWinerNode(param1:Pothunter = null) : void
      {
         if(this._winerbaseui == null)
         {
            this._winerbaseui = new WinerPanel();
         }
         this._winerbaseui.initUi(param1);
         this._node.addChild(this._winerbaseui);
         this._winerbaseui.x = 288;
         this._winerbaseui.y = 135;
      }
      
      public function destroy() : void
      {
         var _loc1_:Pothunter = null;
         while(this.playerSp.numChildren > 0)
         {
            _loc1_ = this.playerSp.getChildAt(0) as Pothunter;
            _loc1_.destroy();
         }
         this.linesp.filters = null;
         this.linesp.graphics.clear();
         this._node.removeChild(this.linesp);
         this._node.removeChild(this.playerSp);
         this.hasWiner = false;
      }
   }
}


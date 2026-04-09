package core.ui.tips
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import manager.LangManager;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class BaseHelpTips extends Sprite
   {
      
      protected var _bg:TipBg;
      
      protected var _gap:int;
      
      protected var _tfSprite:Sprite;
      
      private var _txts:Array;
      
      protected var _row:int;
      
      protected var _frefixName:String;
      
      public function BaseHelpTips(param1:Number)
      {
         super();
         this._gap = param1;
         this._bg = new TipBg();
         this._tfSprite = new Sprite();
         addChild(this._bg);
      }
      
      public function createTips() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 1;
         this._txts = [];
         while(_loc2_ <= this._row)
         {
            _loc1_ = GetDomainRes.getMoveClip("Flashpro_TextField");
            this._tfSprite.addChild(_loc1_);
            _loc1_.y = (_loc2_ - 1) * (_loc1_.height + 2);
            _loc2_++;
            this._txts.push(_loc1_);
         }
         var _loc3_:Number = this._tfSprite.width + 2 * this._gap;
         var _loc4_:Number = this._tfSprite.height + 2 * this._gap;
         this._bg.draw(_loc3_,_loc4_);
         this._bg.addChild(this._tfSprite);
         this._tfSprite.x = this._tfSprite.y = this._gap;
         this.setTipsText();
      }
      
      private function setTipsText() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TextFormat = null;
         var _loc4_:int = 1;
         while(_loc4_ <= this._row)
         {
            _loc1_ = LangManager.getInstance().getLanguage(this._frefixName + _loc4_);
            _loc3_ = _loc1_.indexOf("0x");
            if(_loc3_ != -1)
            {
               _loc2_ = uint(_loc1_.slice(_loc3_,_loc3_ + 8));
               _loc5_ = _loc1_.indexOf("size:");
               if(_loc5_ != -1)
               {
                  _loc6_ = (this._txts[_loc4_ - 1]._txt as TextField).defaultTextFormat;
                  _loc6_.size = _loc1_.slice(_loc5_ + 5,_loc5_ + 7);
                  (this._txts[_loc4_ - 1]._txt as TextField).defaultTextFormat = _loc6_;
               }
               FuncKit.changeTextFieldColor(this._txts[_loc4_ - 1]._txt as TextField,_loc2_);
               this._txts[_loc4_ - 1]._txt.text = _loc1_.slice(0,_loc3_ - 1);
               this._txts[_loc4_ - 1]._txt.width = this._txts[_loc4_ - 1]._txt.textWidth + 20;
            }
            else
            {
               this._txts[_loc4_ - 1]._txt.text = _loc1_;
            }
            _loc4_++;
         }
      }
      
      public function setLocation(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
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
   
   public function draw(param1:Number, param2:Number) : void
   {
      this.graphics.clear();
      this.graphics.lineStyle(2,15722382);
      this.graphics.beginFill(922887,0.85);
      this.graphics.drawRoundRect(0,0,param1,param2,10,10);
      this.graphics.endFill();
   }
}

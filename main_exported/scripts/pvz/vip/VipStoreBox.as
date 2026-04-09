package pvz.vip
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class VipStoreBox extends Sprite
   {
      
      private var _index:int;
      
      private var _status:int;
      
      private var max_vip_exp:int;
      
      private var min_vip_exp:int;
      
      private var tool_id:int;
      
      private var _box:MovieClip;
      
      public function VipStoreBox(param1:Object, param2:int)
      {
         super();
         this._index = param2;
         this._status = param1.status;
         this.max_vip_exp = param1.max_exp;
         this.min_vip_exp = param1.min_exp;
         this.tool_id = param1.daily_awards;
         this.buttonMode = true;
         this.initBoxStyle();
         this.changeStoreHouseStatus();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set status(param1:int) : void
      {
         this._status = param1;
         this.changeStoreHouseStatus();
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function get vipMinExp() : int
      {
         return this.min_vip_exp;
      }
      
      public function get id() : int
      {
         return this.tool_id;
      }
      
      private function changeStoreHouseStatus() : void
      {
         if(this._status == 1)
         {
            this._box.gotoAndStop(2);
         }
         else if(this._status == -1)
         {
            this._box.gotoAndStop(1);
         }
         else if(this._status == -2)
         {
            this._box.gotoAndStop(3);
         }
      }
      
      private function initBoxStyle() : void
      {
         this._box = this.getRewardBox();
         this._box.mouseChildren = false;
         this._box.mouseEnabled = true;
         this.addChild(this._box);
         this.setNum();
      }
      
      private function getRewardBox() : MovieClip
      {
         var _loc1_:Class = DomainAccess.getClass("vipbox" + this._index);
         return new _loc1_();
      }
      
      private function setNum() : void
      {
         FuncKit.clearAllChildrens(this._box["num"]);
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.min_vip_exp.toString());
         _loc1_.x = -_loc1_.width / 2;
         this._box["num"].addChild(_loc1_);
         this._box["num"].mouseChildren = false;
         this._box["num"].mouseEnabled = false;
      }
   }
}


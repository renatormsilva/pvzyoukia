package pvz.possession
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.PlayerManager;
   import pvz.shop.ShopWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.StringMovieClip;
   import windows.PlayerInfoWindow;
   import zlib.utils.DomainAccess;
   
   public class PlayerInfoPanel
   {
      
      internal var _panel:MovieClip = null;
      
      internal var _container:DisplayObjectContainer;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function PlayerInfoPanel(param1:DisplayObjectContainer)
      {
         super();
         this._container = param1;
         this.init();
      }
      
      public function upDate() : void
      {
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         var _loc8_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc10_:DisplayObject = null;
         this._panel["player_info"]["player_name"].text = this.playerManager.getPlayer().getNickname();
         this.clearNum();
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.playerManager.getPlayer().getOccupyNum() + "");
         _loc1_.x = -_loc1_.width / 2;
         this._panel["num_occupy"].addChild(_loc1_);
         if(this.playerManager.getPlayer().getMoney() >= 100000)
         {
            _loc5_ = DomainAccess.getClass("wan");
            _loc6_ = new _loc5_();
            _loc7_ = Math.floor(this.playerManager.getPlayer().getMoney() / 10000);
            _loc8_ = FuncKit.getNumEffect(_loc7_ + "");
            if(_loc7_ <= 100)
            {
               this._panel["num_money"].x = -40;
            }
            else
            {
               this._panel["num_money"].x = -30;
            }
            _loc6_.addChild(_loc8_);
            _loc8_.x = -_loc8_.width - 2;
            _loc8_.y = _loc8_.height - 4;
            this._panel["num_money"].addChild(_loc6_);
            _loc6_.x = 200;
            _loc6_.y = -10;
         }
         else
         {
            _loc9_ = this.playerManager.getPlayer().getMoney();
            _loc10_ = FuncKit.getNumEffect(_loc9_ + "");
            this._panel["num_money"].x = 120;
            this._panel["num_money"].addChild(_loc10_);
         }
         var _loc2_:DisplayObject = FuncKit.getNumEffect(this.playerManager.getPlayer().getHonour() + "");
         _loc2_.x = -_loc2_.width / 2;
         this._panel["num_honor"].addChild(_loc2_);
         if(this.playerManager.getPlayer().getExp() > this.playerManager.getPlayer().getExp_max())
         {
            this._panel["exp"].exp.text = this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min() + "/" + (this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min());
         }
         else
         {
            this._panel["exp"].exp.text = this.playerManager.getPlayer().getExp() - this.playerManager.getPlayer().getExp_min() + "/" + (this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min());
         }
         this._panel["exp"].exp_mask.scaleX = (this.playerManager.getPlayer().getExp() - this.playerManager.getPlayer().getExp_min()) / (this.playerManager.getPlayer().getExp_max() - this.playerManager.getPlayer().getExp_min());
         if(this._panel["num_level"] != null)
         {
            FuncKit.clearAllChildrens(this._panel["num_level"]);
         }
         var _loc3_:Class = DomainAccess.getClass("gradeLev");
         var _loc4_:MovieClip = new _loc3_();
         _loc4_["num"].addChild(StringMovieClip.getStringImage(this.playerManager.getPlayer().getGrade() + "","Lev"));
         this._panel["num_level"].addChild(_loc4_);
         this._panel["num_level"].x = this._panel["num_level_loc"].x + (54 - _loc4_.width) / 2;
      }
      
      private function clearNum() : void
      {
         if(this._panel["num_occupy"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["num_occupy"]);
         }
         if(this._panel["num_money"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["num_money"]);
         }
         if(this._panel["num_honor"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this._panel["num_honor"]);
         }
      }
      
      private function init() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_playerInfo");
         this._panel = new _loc1_();
         this._panel.x = 15;
         this._panel.y = 6;
         this._container.addChild(this._panel);
         this.addEvent();
         PlantsVsZombies.setHeadPic(this._panel["pic"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
         this.upDate();
      }
      
      private function addEvent() : void
      {
         this._panel["_bt_info"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_gold"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_occupy"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._panel["_bt_info"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_gold"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._panel["_bt_occupy"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_bt_info")
         {
            new PlayerInfoWindow().show();
         }
         else if(param1.currentTarget.name == "_bt_gold")
         {
            new ShopWindow(null);
         }
         else if(param1.currentTarget.name == "_bt_occupy")
         {
            new PossessionUseAddWindow(this.upDate);
         }
      }
      
      private function destory() : void
      {
         this.removeEvent();
         this._container.removeChild(this._panel);
      }
   }
}


package pvz.registration.view.panel
{
   import com.res.IDestroy;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import pvz.registration.control.RegistrationMgr;
   import pvz.registration.data.PrizeNeedInfoVo;
   import pvz.registration.data.RegistrationVo;
   import pvz.registration.data.RewardData;
   import pvz.registration.data.SignDataVo;
   import pvz.registration.view.panel.module.HtmlUtil;
   import pvz.registration.view.panel.module.Scale9Image;
   import utils.GetDomainRes;
   import windows.PrizesWindow;
   
   public class RegPanel extends Sprite implements IDestroy
   {
      
      private var _vo:RegistrationVo;
      
      private var bg:Scale9Image;
      
      private var _calendar:Calendar;
      
      private var lbl:TextField;
      
      private var lblImg:Bitmap;
      
      private var _rewardTabPanel:RewardTabPanel;
      
      public function RegPanel()
      {
         super();
         this.initUi();
      }
      
      private function initUi() : void
      {
         var _loc1_:Bitmap = GetDomainRes.getBitmap("pvz.reg.titleBg");
         this.addChild(_loc1_);
         var _loc2_:Bitmap = GetDomainRes.getBitmap("pvz.reg.titleReg");
         this.addChild(_loc2_);
         var _loc3_:Rectangle = new Rectangle(7,7,5,5);
         this.bg = new Scale9Image(GetDomainRes.getBitmapData("pvz.reg.panelBg"),_loc3_);
         this.bg.repeatFillLeft = this.bg.repeatFillRight = this.bg.repeatFillCenter = false;
         this.bg.width = 310;
         this.bg.height = 410;
         this.bg.y = 33;
         this.addChild(this.bg);
         _loc1_.x = (310 - _loc1_.width) * 0.5;
         _loc2_.x = _loc1_.x + (_loc1_.width - _loc2_.width) * 0.5;
         _loc2_.y = 4;
         this._calendar = new Calendar({
            "lblMonth":"month_",
            "btnSign":"btnSign",
            "btnBg0":"btn_0",
            "btnBg1":"btn_1",
            "btnBg2":"btn_2",
            "btnMask":"btn_mask",
            "num":"num_"
         },270,215);
         this.addChild(this._calendar);
         this._calendar.x = 20;
         this._calendar.y = 35;
         this._calendar.addEventListener("onSign",this.sign);
         this.lblImg = GetDomainRes.getBitmap("pvz.reg.txt1");
         this.lblImg.x = 95;
         this.lblImg.y = 255;
         this.addChild(this.lblImg);
         this.lbl = new TextField();
         this.lbl.width = 30;
         this.lbl.height = 18;
         this.lbl.x = 190;
         this.lbl.y = this.lblImg.y - 2;
         this.lbl.selectable = false;
         this.addChild(this.lbl);
         this._rewardTabPanel = new RewardTabPanel();
         this._rewardTabPanel.x = 3;
         this._rewardTabPanel.y = 274;
         this.addChild(this._rewardTabPanel);
         this.upData();
      }
      
      public function upData() : void
      {
         this._vo = RegistrationMgr.getInstance().ctrl.vo;
         var _loc1_:Date = new Date(this._vo.time * 1000);
         this._calendar.setDateDate(_loc1_);
         this.lbl.htmlText = HtmlUtil.font(this._vo.signcount + "","#ff0000");
         this._rewardTabPanel.upData(this._vo.signreward,"签到","次",this.getPrize);
      }
      
      private function getPrize(param1:PrizeNeedInfoVo) : void
      {
         var prize:Function = null;
         var obj:PrizeNeedInfoVo = param1;
         prize = function(param1:Object):void
         {
            var _loc2_:PrizesWindow = null;
            var _loc3_:Array = null;
            var _loc4_:RewardData = null;
            if(param1)
            {
               _loc2_ = new PrizesWindow(back,PlantsVsZombies._node);
               _loc3_ = [];
               for each(_loc4_ in obj.rewards)
               {
                  _loc3_.push(_loc4_.data());
               }
               _loc2_.show(_loc3_);
               RegistrationMgr.getInstance().addPrize(_loc3_);
            }
         };
         RegistrationMgr.getInstance().reqGetReward(prize,obj.id,1);
      }
      
      private function back() : void
      {
         RegistrationMgr.getInstance().upData();
      }
      
      private function sign(param1:Event) : void
      {
         RegistrationMgr.getInstance().reqSetSign(this.signprize);
      }
      
      private function signprize(param1:Object) : void
      {
         var _loc2_:SignDataVo = null;
         var _loc3_:PrizesWindow = null;
         var _loc4_:Array = null;
         if(param1)
         {
            _loc2_ = RegistrationMgr.getInstance().getCurrentDaySign();
            _loc3_ = new PrizesWindow(this.back,PlantsVsZombies._node);
            _loc4_ = [];
            _loc4_.push(_loc2_.reward.data());
            _loc3_.show(_loc4_);
            RegistrationMgr.getInstance().addPrize(_loc4_);
         }
      }
      
      public function destroy() : void
      {
      }
   }
}


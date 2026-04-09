package pvz.registration.view.panel
{
   import com.res.IDestroy;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import pvz.registration.control.RegistrationMgr;
   import pvz.registration.data.MissionVo;
   import pvz.registration.data.PrizeNeedInfoVo;
   import pvz.registration.data.RegistrationVo;
   import pvz.registration.data.RewardData;
   import pvz.registration.view.panel.module.HtmlUtil;
   import pvz.registration.view.panel.module.ProgressBar;
   import pvz.registration.view.panel.module.Scale9Image;
   import pvz.registration.view.panel.module.ScrollPanel;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import windows.PrizesWindow;
   
   public class ActPanel extends Sprite implements IDestroy
   {
      
      private var _vo:RegistrationVo;
      
      private var bg:Scale9Image;
      
      private var panelBg:MovieClip;
      
      private var panel:Sprite;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _progress:ProgressBar;
      
      private var lbl:TextField;
      
      private var lblImg:Bitmap;
      
      private var _rewardTabPanel:RewardTabPanel;
      
      public function ActPanel()
      {
         super();
         this.initUi();
      }
      
      private function initUi() : void
      {
         var _loc1_:Bitmap = GetDomainRes.getBitmap("pvz.reg.titleBg");
         this.addChild(_loc1_);
         var _loc2_:Bitmap = GetDomainRes.getBitmap("pvz.reg.titleAct");
         this.addChild(_loc2_);
         var _loc3_:Rectangle = new Rectangle(7,7,5,5);
         this.bg = new Scale9Image(GetDomainRes.getBitmapData("pvz.reg.panelBg"),_loc3_);
         this.bg.repeatFillLeft = this.bg.repeatFillRight = this.bg.repeatFillCenter = false;
         this.bg.width = 314;
         this.bg.height = 410;
         this.bg.y = 33;
         this.addChild(this.bg);
         _loc1_.x = (310 - _loc1_.width) * 0.5;
         _loc2_.x = _loc1_.x + (_loc1_.width - _loc2_.width) * 0.5;
         _loc2_.y = 4;
         this.panelBg = GetDomainRes.getMoveClip("pvz.reg.panelBg1");
         this.panelBg.x = 5;
         this.panelBg.y = 40;
         this.addChild(this.panelBg);
         this.panel = new Sprite();
         this._scrollPanel = new ScrollPanel(295,150,new Sprite());
         this._scrollPanel.x = 10;
         this._scrollPanel.y = 63;
         this._scrollPanel.padding = 5;
         this.addChild(this._scrollPanel);
         this.lblImg = GetDomainRes.getBitmap("pvz.reg.txt2");
         this.lblImg.x = 120;
         this.lblImg.y = 250;
         this.addChild(this.lblImg);
         this.lbl = new TextField();
         this.lbl.width = 50;
         this.lbl.height = 18;
         this.lbl.x = 170;
         this.lbl.y = this.lblImg.y - 2;
         this.lbl.selectable = false;
         this._rewardTabPanel = new RewardTabPanel();
         this._rewardTabPanel.x = 5;
         this._rewardTabPanel.y = 274;
         this.upData();
         this.addChild(this.lbl);
         this.addChild(this._rewardTabPanel);
      }
      
      public function upData() : void
      {
         var _loc1_:MissionVo = null;
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         this._vo = RegistrationMgr.getInstance().ctrl.vo;
         if(!this._progress)
         {
            this._progress = new ProgressBar(235,0,this._vo.activemax);
            this._progress.x = 39;
            this._progress.y = 225;
            this.addChild(this._progress);
         }
         this._progress.progress = this._vo.active;
         this.lbl.htmlText = HtmlUtil.font(this._vo.active + "","#ff0000");
         FuncKit.clearAllChildrens(this.panel);
         for each(_loc1_ in this._vo.missions)
         {
            _loc2_ = GetDomainRes.getMoveClip("pvz.reg.missionItem");
            _loc3_ = _loc1_.count >= _loc1_.countmax ? "#000000" : "#ff0000";
            _loc2_.tf1.htmlText = HtmlUtil.font(_loc1_.dis,"#000000") + HtmlUtil.font("(" + _loc1_.count + "/" + _loc1_.countmax + ")",_loc3_);
            _loc2_.tf2.text = "+" + _loc1_.active;
            _loc2_.data = _loc1_;
            _loc2_.btngo.addEventListener(MouseEvent.CLICK,this.gotoSance);
            this.panel.addChild(_loc2_);
         }
         this.layoutVectical(this.panel,2);
         this._scrollPanel.removeAllObjects();
         this._scrollPanel.addObject(this.panel);
         this._rewardTabPanel.upData(this._vo.activereward,"活跃","",this.getPrize);
      }
      
      private function gotoSance(param1:MouseEvent) : void
      {
         if(Boolean(param1.currentTarget.parent) && Boolean(param1.currentTarget.parent.data))
         {
            RegistrationMgr.getInstance().closeSystem();
            PlantsVsZombies.firstpage.gotoScence(param1.currentTarget.parent.data.gotoId);
         }
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
         RegistrationMgr.getInstance().reqGetReward(prize,obj.id,2);
      }
      
      private function back() : void
      {
         RegistrationMgr.getInstance().upData();
      }
      
      public function layoutVectical(param1:DisplayObjectContainer, param2:Number = 0, param3:Number = 0) : void
      {
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:int = param1.numChildren;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:int = param3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc7_.y = _loc5_;
            _loc5_ = _loc7_.height + _loc7_.y + param2;
            _loc6_++;
         }
      }
      
      public function destroy() : void
      {
      }
   }
}


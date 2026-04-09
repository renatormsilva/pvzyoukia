package labels
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import com.res.IDestroy;
   import constants.URLConnectionConstants;
   import entity.FriendPrizeInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import utils.FuncKit;
   import xmlReader.XmlBaseReader;
   import xmlReader.firstPage.XmlInvitePrizeInvite;
   import zlib.utils.DomainAccess;
   
   public class InvitePrizeKindsFriendLabel extends Sprite implements IURLConnection, IDestroy
   {
      
      internal var label:MovieClip;
      
      internal var _fp:FriendPrizeInfo;
      
      internal var _backFun:Function;
      
      public function InvitePrizeKindsFriendLabel()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("kindsFriendPrize");
         this.label = new _loc1_();
         this.label.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.label.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.label._draw.addEventListener(MouseEvent.CLICK,this.onClick);
         this.label._draw_no.addEventListener(MouseEvent.CLICK,this.onClick);
         this.label.gotoAndStop(1);
         this.addChild(this.label);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function destroy() : void
      {
         this.label.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.label.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.label._draw.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.label._draw_no.removeEventListener(MouseEvent.CLICK,this.onClick);
         FuncKit.clearAllChildrens(this);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var xmlloader:XmlInvitePrizeInvite;
         var showStr:Function;
         var money:int = 0;
         var charm:int = 0;
         var str:String = null;
         var type:int = param1;
         var re:Object = param2;
         PlantsVsZombies.showDataLoading(false);
         xmlloader = new XmlInvitePrizeInvite(re as String);
         if(xmlloader.isSuccess())
         {
            showStr = function():void
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node006",_fp.getNickName(),money));
            };
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            money = xmlloader.getFriendMoney();
            charm = xmlloader.getFriendCharm();
            LangManager.getInstance().getLanguage("node006",this._fp.getNickName(),money);
            str = LangManager.getInstance().getLanguage("node006",this._fp.getNickName(),money);
            PlantsVsZombies.changeMoneyOrExp(money);
            PlantsVsZombies.showInviteWindow(str,showStr);
            this._fp.setStarts(0);
         }
         else
         {
            if(xmlloader.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            PlantsVsZombies.showSystemErrorInfo(xmlloader.error());
         }
         if(this._backFun != null)
         {
            this._backFun();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_draw_no")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node007"));
         }
         else if(param1.currentTarget.name == "_draw")
         {
            PlantsVsZombies.showDataLoading(true);
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_INVITE_FRIEND + this._fp.getId()),0);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.label.gotoAndStop(2);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.label.gotoAndStop(1);
      }
      
      public function setInfo(param1:FriendPrizeInfo, param2:Function, param3:int) : void
      {
         this._backFun = param2;
         this.setBtVisibleFalse();
         this._fp = param1;
         if(param1.getStarts() == 0)
         {
            this.label._drawed.visible = true;
         }
         else if(param1.getStarts() == 1)
         {
            this.label._draw.visible = true;
         }
         else
         {
            this.label._draw_no.visible = true;
         }
         if(this.label._rankpic != null && this.label._rankpic.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.label._rankpic);
         }
         this.label._rankpic.addChild(FuncKit.getNumEffect(param3 + "","Small"));
         PlantsVsZombies.setHeadPic(this.label["_headpic"],param1.getBigFace(),PlantsVsZombies.HEADPIC_SMALL,param1.getVipTime(),param1.getVipLevel());
         this.label._nickname.text = param1.getNickName();
         this.setGrade(param1.getGrade());
      }
      
      private function setGrade(param1:int) : void
      {
         if(this.label._gradepic == null && this.label._gradepic.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.label._gradepic);
         }
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + param1));
         this.label._gradepic.addChild(_loc3_);
      }
      
      private function setBtVisibleFalse() : void
      {
         this.label._drawed.visible = false;
         this.label._draw_no.visible = false;
         this.label._draw.visible = false;
      }
   }
}


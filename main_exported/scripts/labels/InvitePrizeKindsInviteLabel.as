package labels
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import com.res.IDestroy;
   import constants.URLConnectionConstants;
   import entity.InvitePrize;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.invitePrizes.InvitePrizeActionWindow;
   import pvz.invitePrizes.InvitePrizeWindow;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.PrizesWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlToolsConfig;
   import xmlReader.firstPage.XmlInvitePrizeInvite;
   import zlib.utils.DomainAccess;
   
   public class InvitePrizeKindsInviteLabel extends Sprite implements IURLConnection, IDestroy
   {
      
      internal var label:MovieClip;
      
      internal var cost:int = 0;
      
      internal var id:int = 0;
      
      internal var _backFun:Function;
      
      internal var tips:ToolsTip;
      
      internal var tips2:ToolsTip;
      
      internal var _o1:Object;
      
      internal var _o2:Object;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var num:int = 0;
      
      public function InvitePrizeKindsInviteLabel()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("kindsInvitePrize");
         this.label = new _loc1_();
         this.label.gotoAndStop(1);
         this.label.addEventListener(MouseEvent.ROLL_OVER,this.onLabelOver);
         this.label.addEventListener(MouseEvent.ROLL_OUT,this.onLabelOut);
         this.label._draw.addEventListener(MouseEvent.CLICK,this.onClick);
         TextFilter.MiaoBian(this.label.str2,16777164,1,5,5);
         TextFilter.MiaoBian(this.label.str3,16777164,1,5,5);
         this.addChild(this.label);
      }
      
      public function destroy() : void
      {
         this.label.removeEventListener(MouseEvent.ROLL_OVER,this.onLabelOver);
         this.label.removeEventListener(MouseEvent.ROLL_OUT,this.onLabelOut);
         this.label._draw.removeEventListener(MouseEvent.CLICK,this.onClick);
         FuncKit.clearAllChildrens(this);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:XmlInvitePrizeInvite = new XmlInvitePrizeInvite(param2 as String);
         if(_loc3_.isSuccess())
         {
            this.playerManager.getPlayer().setUseInviteNum(this.playerManager.getPlayer().getUseInviteNum() + this.cost);
            this.playerManager.getPlayer().setMaxUseInviteNum(this.playerManager.getPlayer().getMaxUseInviteNum() - this.cost);
            if(this._backFun != null)
            {
               this._backFun();
            }
            this.showPrizes(_loc3_.getInvitePrizes());
         }
         else
         {
            if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
         }
      }
      
      private function onLabelOver(param1:MouseEvent) : void
      {
         this.label.gotoAndStop(2);
      }
      
      private function onLabelOut(param1:MouseEvent) : void
      {
         this.label.gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.playerManager.getPlayer().getInviteAmount() - this.playerManager.getPlayer().getUseInviteNum() < this.cost && this.playerManager.getPlayer().getUseInviteNum() != InvitePrizeWindow.INVITE_MAXNUM)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node008"));
            return;
         }
         if(this.playerManager.getPlayer().getMaxUseInviteNum() < this.cost)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this.playerManager.getPlayer().getMaxUseInviteNum() == 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node009"));
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node010"));
            }
            return;
         }
         var _loc2_:InvitePrizeActionWindow = new InvitePrizeActionWindow(this.changePrizes);
         _loc2_.show(this.cost);
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
      }
      
      public function setInfo(param1:InvitePrize, param2:Function) : void
      {
         var _loc3_:int = 0;
         this.cost = param1.getCost();
         this.id = param1.getId();
         this._backFun = param2;
         this.addCostNumPic();
         if(param1.getOrgs() != null && param1.getOrgs().length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.getOrgs().length)
            {
               if(_loc3_ == 0)
               {
                  if(this.num == 1)
                  {
                     this.num = 0;
                     this.addPicNew(this.label._pic_1,(param1.getOrgs()[_loc3_] as Organism).getPicId(),param1.getOrgs()[_loc3_]);
                  }
                  else
                  {
                     this.addPicNew(this.label._pic_0,(param1.getOrgs()[_loc3_] as Organism).getPicId(),param1.getOrgs()[_loc3_]);
                     ++this.num;
                  }
               }
               else if(_loc3_ == 1)
               {
                  this.addPicNew(this.label._pic_1,(param1.getOrgs()[_loc3_] as Organism).getPicId(),param1.getOrgs()[_loc3_]);
               }
               _loc3_++;
            }
         }
         if(param1.getTools() != null && param1.getTools().length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.getTools().length)
            {
               if(_loc3_ == 0)
               {
                  if(this.num == 1)
                  {
                     this.num = 0;
                     this.addPicNew(this.label._pic_1,(param1.getTools()[_loc3_] as Tool).getPicId(),param1.getTools()[_loc3_]);
                  }
                  else
                  {
                     this.addPicNew(this.label._pic_0,(param1.getTools()[_loc3_] as Tool).getPicId(),param1.getTools()[_loc3_]);
                     ++this.num;
                  }
               }
               else if(_loc3_ == 1)
               {
                  this.addPicNew(this.label._pic_1,(param1.getTools()[_loc3_] as Tool).getPicId(),param1.getTools()[_loc3_]);
               }
               _loc3_++;
            }
         }
         this.label._pic_0.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.label._pic_1.addEventListener(MouseEvent.ROLL_OVER,this.onOver2);
      }
      
      private function addPicNew(param1:MovieClip, param2:int, param3:Object) : void
      {
         if(param1.name == "_pic_0")
         {
            this._o1 = param3;
            if(param3 is Organism)
            {
               Icon.setUrlIcon(param1,param2,Icon.ORGANISM_1);
               this.label.str2.text = (param3 as Organism).getName();
            }
            else
            {
               Icon.setUrlIcon(param1,param2,Icon.TOOL_1);
               this.label.str2.text = XmlToolsConfig.getInstance().getToolAttribute((param3 as Tool).getOrderId()).getName();
            }
            return;
         }
         if(param1.name == "_pic_1")
         {
            this._o2 = param3;
            if(param3 is Organism)
            {
               Icon.setUrlIcon(param1,param2,Icon.ORGANISM_1);
               this.label.str3.text = (param3 as Organism).getName();
            }
            else
            {
               Icon.setUrlIcon(param1,param2,Icon.TOOL_1);
               this.label.str3.text = (param3 as Tool).getName();
            }
            return;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new ToolsTip();
         }
         this.tips.setTooltip(this.label._pic_0,this._o1);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      public function getPositionY() : int
      {
         return this.y + 88;
      }
      
      private function getPositionX() : int
      {
         if(this.parent.x + this.parent.parent.x + this.parent.parent.parent.x + this.x > 500)
         {
            return this.x - 200;
         }
         return this.x + 120;
      }
      
      private function onOver2(param1:MouseEvent) : void
      {
         this.tips2 = new ToolsTip();
         this.tips2.setTooltip(this.label._pic_1,this._o2);
         this.tips2.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      private function addCostNumPic() : void
      {
         if(this.label._pic_num != null && this.label._pic_num.numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.label._pic_num);
         }
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this.cost + "","Small");
         _loc1_.x = -_loc1_.width / 2;
         this.label._pic_num.addChild(_loc1_);
      }
      
      private function addPic(param1:int, param2:Object) : void
      {
         if(this.label._pic_0.numChildren == 0)
         {
            this._o1 = param2;
            if(param2 is Organism)
            {
               Icon.setUrlIcon(this.label._pic_0,param1,Icon.ORGANISM_1);
               this.label.str2.text = (param2 as Organism).getName();
            }
            else
            {
               Icon.setUrlIcon(this.label._pic_0,param1,Icon.TOOL_1);
               this.label.str2.text = (param2 as Tool).getName();
            }
            return;
         }
         if(this.label._pic_1.numChildren == 0)
         {
            this._o2 = param2;
            if(param2 is Organism)
            {
               Icon.setUrlIcon(this.label._pic_1,param1,Icon.ORGANISM_1);
               this.label.str3.text = (param2 as Organism).getName();
            }
            else
            {
               Icon.setUrlIcon(this.label._pic_1,param1,Icon.TOOL_1);
               this.label.str3.text = (param2 as Tool).getName();
            }
            return;
         }
      }
      
      private function changePrizes() : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_INVITE_AMOUNT + this.id),0);
      }
      
      private function showPrizes(param1:InvitePrize) : void
      {
         var _loc2_:PrizesWindow = new PrizesWindow(this.invite,PlantsVsZombies._node as MovieClip);
         _loc2_.show(this.changePrizesInfos(param1));
      }
      
      private function invite() : void
      {
         PlantsVsZombies.showInviteWindow(LangManager.getInstance().getLanguage("node011"),null);
      }
      
      private function changePrizesInfos(param1:InvitePrize) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         if(param1.getOrgs() != null && param1.getOrgs().length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.getOrgs().length)
            {
               _loc2_.push(param1.getOrgs()[_loc3_]);
               _loc3_++;
            }
         }
         if(param1.getTools() != null && param1.getTools().length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.getTools().length)
            {
               _loc2_.push(param1.getTools()[_loc4_]);
               _loc4_++;
            }
         }
         return _loc2_;
      }
   }
}


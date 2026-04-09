package pvz.copy.ui.sprites
{
   import core.interfaces.IVo;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.copy.models.stone.StoneCData;
   import pvz.copy.models.stone.StoneGateData;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.M_ClipMotion;
   import utils.TextFilter;
   
   public class StoneGateIcon extends Sprite
   {
      
      private var background:MovieClip;
      
      private var zombies:Array;
      
      private var idata:StoneGateData;
      
      private var pre_star:int;
      
      private var onGetPrizes:Function;
      
      private var onEenterGate:Function;
      
      private var m_prizes:MovieClip;
      
      public function StoneGateIcon(param1:Function, param2:Function)
      {
         super();
         this.background = GetDomainRes.getMoveClip("stone.icon");
         this.background.gotoAndStop(1);
         this.background.mouseEnabled = false;
         this.background.mouseChildren = false;
         TextFilter.MiaoBian(this.background["cname"],0);
         this.m_prizes = GetDomainRes.getMoveClip("stone.ui.prizesmc");
         this.m_prizes.gotoAndStop(1);
         this.m_prizes.x = 50;
         this.m_prizes.y = 50;
         this.addChild(this.background);
         this.addChild(this.m_prizes);
         this.m_prizes.visible = false;
         this.buttonMode = true;
         this.onGetPrizes = param2;
         this.onEenterGate = param1;
         this.addEventListener(MouseEvent.CLICK,this.onGateClickHandler);
         this.m_prizes.addEventListener(MouseEvent.CLICK,this.GetPrizes);
      }
      
      private function GetPrizes(param1:MouseEvent) : void
      {
         this.onGetPrizes(this);
      }
      
      private function onGateClickHandler(param1:MouseEvent) : void
      {
         if(param1.target != this)
         {
            return;
         }
         if(this.idata.getActive() == StoneCData.closing)
         {
            return;
         }
         this.onEenterGate(this.idata);
      }
      
      public function getIconData() : StoneGateData
      {
         return this.idata;
      }
      
      public function upData(param1:IVo) : void
      {
         this.idata = param1 as StoneGateData;
         this.pre_star = this.idata.getPreStar();
         this.background["cname"].text = this.idata.getName();
         this.changeIcon(this.idata.getImgId());
         this.gateCloing(false);
         this.showStarsAndBoss();
         if(this.idata.getActive() == StoneCData.closing)
         {
            this.gateCloing(true);
            return;
         }
         this.setPrizeMc();
      }
      
      private function changeIcon(param1:int) : void
      {
         FuncKit.clearAllChildrens(this.background["bg"]);
         var _loc2_:DisplayObject = GetDomainRes.getDisplayObject("pvz.avatar" + param1);
         _loc2_.x = -35;
         _loc2_.y = -35;
         this.background["bg"].addChild(_loc2_);
      }
      
      private function canLightStar() : Boolean
      {
         return this.idata.getStar() - this.pre_star > 0 ? true : false;
      }
      
      private function playLightStar() : void
      {
         var _loc1_:MovieClip = null;
         if(this.idata.getStar() == 0)
         {
            return;
         }
         if(this.canLightStar())
         {
            ++this.pre_star;
            _loc1_ = this.background["star"]["star_" + this.pre_star];
            M_ClipMotion.playStarEffect(_loc1_,this.playLightStar);
         }
         else
         {
            this.background["star"]["star_" + this.idata.getStar()].gotoAndStop(30);
         }
      }
      
      private function showStarsAndBoss() : void
      {
         if(this.idata.getPreStar() == 0)
         {
            this.background["star"]["star_1"].gotoAndStop(1);
            this.background["star"]["star_2"].gotoAndStop(1);
            this.background["star"]["star_3"].gotoAndStop(1);
         }
         else if(this.idata.getPreStar() == 1)
         {
            this.background["star"]["star_1"].gotoAndStop(30);
            this.background["star"]["star_2"].gotoAndStop(1);
            this.background["star"]["star_3"].gotoAndStop(1);
         }
         else if(this.idata.getPreStar() == 2)
         {
            this.background["star"]["star_1"].gotoAndStop(30);
            this.background["star"]["star_2"].gotoAndStop(30);
            this.background["star"]["star_3"].gotoAndStop(1);
         }
         else if(this.idata.getPreStar() == 3)
         {
            this.background["star"]["star_1"].gotoAndStop(30);
            this.background["star"]["star_2"].gotoAndStop(30);
            this.background["star"]["star_3"].gotoAndStop(30);
         }
         this.playLightStar();
         this.background["boss"].visible = this.idata.getBoss();
      }
      
      private function setPrizeMc() : void
      {
         if(this.idata.getThroughPrize() == 1)
         {
            this.m_prizes.visible = true;
            if(this.idata.getActive() == StoneCData.openned)
            {
               this.m_prizes.gotoAndStop(this.m_prizes.totalFrames);
            }
         }
         else if(this.idata.getThroughPrize() == 3)
         {
            this.m_prizes.visible = true;
            M_ClipMotion.playStarEffect(this.m_prizes,null);
         }
         else
         {
            this.m_prizes.visible = false;
         }
      }
      
      private function gateCloing(param1:Boolean) : void
      {
         if(param1)
         {
            this.m_prizes.visible = false;
            FuncKit.setNoColor(this);
            this.mouseChildren = param1;
         }
         else
         {
            this.filters = null;
         }
      }
      
      public function setFilters(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.idata.getActive() != StoneCData.closing)
            {
               TextFilter.MiaoBian(this.background["bg"],16776960,0.6,6,6);
            }
         }
         else if(this.idata.getActive() != StoneCData.closing)
         {
            this.background["bg"].filters = null;
         }
      }
      
      public function setPrizesVisible() : void
      {
         this.m_prizes.gotoAndStop(1);
         this.m_prizes.visible = false;
      }
      
      public function clear() : void
      {
         if(this.m_prizes.hasEventListener(MouseEvent.CLICK))
         {
            this.m_prizes.removeEventListener(MouseEvent.CLICK,this.GetPrizes);
         }
         this.removeEventListener(MouseEvent.CLICK,this.onGateClickHandler);
         this.buttonMode = false;
         this.filters = null;
         FuncKit.clearAllChildrens(this);
         this.zombies = null;
         this.idata = null;
         this.background = null;
      }
   }
}


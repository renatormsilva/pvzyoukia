package pvz.serverbattle.knockout.guess
{
   import core.ui.panel.BaseWindow;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.serverbattle.fport.GuessPatternFPort;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.ReBuidBitmap;
   import utils.Singleton;
   
   public class GuessPatternPanel extends BaseWindow
   {
      
      private static const COMMEN_PRIZE:int = 1;
      
      private static const DOUBULE_4X_PRIZE:int = 2;
      
      private static const DOUBULE_8X_PRIZE:int = 3;
      
      private var backGround:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var prizepattern:int;
      
      private var _groupid:int;
      
      private var _playerid:int;
      
      private var _boxid:int;
      
      private var guessPanelFPort:GuessPatternFPort;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public var _cost4:int;
      
      public var _cost8:int;
      
      private var prizeTips:ToolsTip;
      
      private var _func:Function;
      
      private var _succ:Boolean;
      
      private var _guesstype:int;
      
      public function GuessPatternPanel(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Function)
      {
         super();
         if(this.backGround == null)
         {
            this.backGround = GetDomainRes.getMoveClip("serverbattle.knockout.guess.guesspattern");
         }
         if(this.closeBtn == null)
         {
            this.closeBtn = GetDomainRes.getSimpleButton("pvz.button.close");
         }
         if(this.guessPanelFPort == null)
         {
            this.guessPanelFPort = new GuessPatternFPort(this);
         }
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this.backGround);
         this.backGround.visible = false;
         this.closeBtn.x = 150;
         this.closeBtn.y = -100;
         this.backGround.addChild(this.closeBtn);
         this._groupid = param1;
         this._playerid = param2;
         this._boxid = param3;
         this._cost4 = param4;
         this._cost8 = param5;
         this._func = param6;
         this.initData();
         this.addMouseEvent();
         this.setLoction();
      }
      
      private function getStore(param1:int) : ReBuidBitmap
      {
         return new ReBuidBitmap("serverbattle.knockout.guess.guessstore" + param1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         switch(param1.currentTarget.name)
         {
            case "commonguess":
               this.guessPanelFPort.initPanelData(GuessPatternFPort.COMPETE_GUESS_PATTERN,this._groupid,this._playerid,COMMEN_PRIZE);
               return;
            case "guess4double":
               if(this.playerManager.getPlayer().getRMB() >= this._cost4)
               {
                  this.guessPanelFPort.initPanelData(GuessPatternFPort.COMPETE_GUESS_PATTERN,this._groupid,this._playerid,DOUBULE_4X_PRIZE,this._cost4);
                  return;
               }
               PlantsVsZombies.showRechargeWindow(LangManager.getInstance().getLanguage("window074"));
               break;
            case "guess8double":
               if(this.playerManager.isVip(this.playerManager.getPlayer().getVipTime()) != null)
               {
                  if(this.playerManager.getPlayer().getVipLevel() >= 2)
                  {
                     if(this.playerManager.getPlayer().getRMB() >= this._cost8)
                     {
                        this.guessPanelFPort.initPanelData(GuessPatternFPort.COMPETE_GUESS_PATTERN,this._groupid,this._playerid,DOUBULE_8X_PRIZE,this._cost8);
                        return;
                     }
                     PlantsVsZombies.showRechargeWindow(LangManager.getInstance().getLanguage("window074"));
                  }
                  else
                  {
                     new SpecilGuessTipPanel();
                  }
               }
               else
               {
                  new SpecilGuessTipPanel();
               }
         }
         this.close();
      }
      
      private function addMouseEvent() : void
      {
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.backGround["commonguess"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["guess4double"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["guess8double"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["box0"].addEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
         this.backGround["box1"].addEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
         this.backGround["box2"].addEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
      }
      
      private function removeMouseEvent() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.close);
         this.backGround["commonguess"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["guess4double"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["guess8double"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.backGround["box0"].removeEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
         this.backGround["box1"].removeEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
         this.backGround["box2"].removeEventListener(MouseEvent.ROLL_OVER,this.onPrizeOver);
      }
      
      private function initData() : void
      {
         var _loc1_:Tool = new Tool(this._boxid);
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            this.backGround["box" + _loc2_]["boxpic"].addChild(this.getBoxByPicID(_loc1_.getPicId()));
            if(_loc2_ == 1)
            {
               this.backGround["box" + _loc2_]["num"].addChild(FuncKit.getNumEffect((this._cost4 + "x").toString(),"White"));
            }
            else if(_loc2_ == 2)
            {
               this.backGround["box" + _loc2_]["num"].addChild(FuncKit.getNumEffect((this._cost8 + "x").toString(),"White"));
            }
            _loc2_++;
         }
         this.backGround.visible = true;
         onShowEffect(this.backGround);
      }
      
      private function getBoxByPicID(param1:int) : Sprite
      {
         return GetDomainRes.getSprite("box_" + param1);
      }
      
      private function onPrizeOver(param1:MouseEvent) : void
      {
         if(this.prizeTips == null)
         {
            this.prizeTips = new ToolsTip();
         }
         else
         {
            this.prizeTips.visible = true;
         }
         var _loc2_:Tool = new Tool(this._boxid);
         this.prizeTips.setTooltipText(param1.currentTarget as MovieClip,_loc2_.getName(),_loc2_.getUse_condition(),_loc2_.getUse_result());
         this.prizeTips.setLoction(param1.currentTarget.x + 380,160);
      }
      
      public function close(param1:MouseEvent = null, param2:Boolean = false, param3:int = 0) : void
      {
         this._succ = param2;
         this._guesstype = param3;
         if(param1 != null)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         onHiddenEffect(this.backGround,this.destroy);
      }
      
      override public function destroy() : void
      {
         this.removeMouseEvent();
         FuncKit.clearAllChildrens(this.backGround["box0"]["boxpic"]);
         FuncKit.clearAllChildrens(this.backGround["box1"]["boxpic"]);
         FuncKit.clearAllChildrens(this.backGround["box2"]["boxpic"]);
         FuncKit.clearAllChildrens(this.backGround["box1"]["num"]);
         FuncKit.clearAllChildrens(this.backGround["box2"]["num"]);
         PlantsVsZombies._node.removeChild(this.backGround);
         this.backGround = null;
         this.closeBtn = null;
         this.prizeTips = null;
         this.playerManager = null;
         this.guessPanelFPort = null;
         if(this._succ && this._func != null)
         {
            this._func(true,this._playerid,this._guesstype);
         }
         this._func = null;
         this._succ = false;
      }
      
      private function setLoction() : void
      {
         this.backGround.x = PlantsVsZombies.WIDTH / 2;
         this.backGround.y = PlantsVsZombies.HEIGHT / 2;
      }
   }
}


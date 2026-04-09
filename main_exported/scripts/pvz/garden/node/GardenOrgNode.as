package pvz.garden.node
{
   import com.display.CMovieClip;
   import constants.UINameConst;
   import core.managers.DistributionLoaderManager;
   import effect.flap.FlapManager;
   import entity.Organism;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import manager.EffectManager;
   import manager.OrganismManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.OrgLoader;
   import pvz.garden.rpc.GardenMonster;
   import pvz.hunting.window.BattleReadyWindow;
   import tip.GardenMonsterTip;
   import tip.GardenOrgTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.GlowTween;
   import utils.Singleton;
   import utils.StringMovieClip;
   import windows.ChallengePropWindow;
   import zlib.utils.DomainAccess;
   
   public class GardenOrgNode extends Sprite
   {
      
      public static const BOLIVAR:int = 0;
      
      public static const CAN:int = 1;
      
      public static const CANNOT:int = 2;
      
      public static const GEM:int = 2;
      
      public static const GOLD:int = 1;
      
      public static const NORMAL:int = 0;
      
      public static const PUT:int = 2;
      
      public static const PUTING:int = 1;
      
      internal var _gardenMaster:String = "";
      
      internal var _gardenMasterId:Number = 0;
      
      public var _mc:MovieClip;
      
      internal var _gainFun:Function;
      
      internal var onode:Sprite;
      
      internal var _o:Organism;
      
      internal var gridType:int = 0;
      
      internal var state:int = 0;
      
      internal var strTimer:Timer;
      
      internal var tips:*;
      
      internal var type:int = 0;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var mouseMc:MovieClip;
      
      private var _mon:GardenMonster;
      
      private var _call:Function;
      
      public function GardenOrgNode(param1:Organism, param2:Function, param3:String, param4:int)
      {
         super();
         this._mc = this.getNode(param1);
         this._mc.mouseEnabled = false;
         this.mouseEnabled = false;
         this.onode = new OrgLoader(param1.getPicId(),0,this.setOrgLoction);
         this.onode.mouseChildren = false;
         this.onode.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.onode.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         this.onode.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         this._mc["money"].mouseChildren = false;
         this._mc["money"].mouseEnabled = false;
         this._mc["org"].addChild(this.onode);
         this.setOrgLoction();
         this._mc["light"].visible = false;
         this._mc["light"].gotoAndStop(1);
         this._o = param1;
         new GlowTween(this.onode,16777113);
         this.setMoney();
         this._gainFun = param2;
         this._gardenMaster = param3;
         this._gardenMasterId = param4;
         this.type = param1.getGardenType();
         this.showBlood();
         this._mc["str"].visible = false;
         this.mouseMc = GetDomainRes.getMoveClip("gardenMouse");
         this.mouseMc.mouseEnabled = this.mouseMc.mouseChildren = false;
         this.addChild(this._mc);
      }
      
      public function getOrg() : Organism
      {
         return this._o;
      }
      
      private function setOrgLoction() : void
      {
      }
      
      public function getPositionX() : int
      {
         if(this._mc.parent.x > 500)
         {
            return this._mc.parent.x + this._mc.parent.parent.parent.parent.x - this.tips.width;
         }
         return this._mc.parent.x + this._mc.parent.parent.parent.parent.x + this.tips.width - 20;
      }
      
      public function getPositionY() : int
      {
         return this._mc.parent.y + this._mc.parent.parent.parent.parent.y;
      }
      
      public function playLight() : void
      {
         var onPlay:Function = null;
         onPlay = function(param1:Event):void
         {
            if(_mc["light"].totalFrames == _mc["light"].currentFrame)
            {
               _mc["light"].removeEventListener(Event.ENTER_FRAME,onPlay);
               _mc["light"].visible = false;
               _mc["light"].stop();
               setLightEffect();
            }
         };
         if(this._mc == null)
         {
            return;
         }
         this._mc["light"].visible = true;
         this._mc["light"].addEventListener(Event.ENTER_FRAME,onPlay);
         this._mc["light"].gotoAndPlay(1);
      }
      
      private function setLightEffect() : void
      {
         if(this._mc["lightEffect"].numChildren != 0)
         {
            return;
         }
         var _loc1_:CMovieClip = EffectManager.getQualityEffect(this._o);
         if(_loc1_ != null)
         {
            this._mc["lightEffect"].mouseEnabled = false;
            this._mc["lightEffect"].mouseChildren = false;
            this._mc["lightEffect"].addChild(_loc1_);
         }
      }
      
      private function closeLightEffect() : void
      {
         if(this._mc["lightEffect"].numChildren == 0)
         {
            return;
         }
         this._mc["lightEffect"].gotoAndStop(1);
         this._mc["lightEffect"].visible = false;
         FuncKit.clearAllChildrens(this._mc["lightEffect"]);
      }
      
      public function playOrg() : void
      {
         if(this._mc["org"].numChildren < 1)
         {
            return;
         }
         (this._mc["org"].getChildAt(0) as MovieClip).org.play();
      }
      
      public function setGridType(param1:int) : void
      {
         this._mc["grid"].gotoAndStop(param1);
      }
      
      public function setState(param1:int) : void
      {
         this.state = param1;
         this._mc["type"].visible = false;
         this._mc["type"].gotoAndStop(1);
         this._mc["hand"].visible = true;
         if(this.state == PUT)
         {
            this._mc["hand"].visible = false;
            this.showType();
            this._mc["grid"].gotoAndStop(1);
            this._mc["grid"].visible = false;
            this.setLightEffect();
         }
      }
      
      public function setGardenMonster(param1:GardenMonster, param2:Function = null) : void
      {
         this._mon = param1;
         this._call = param2;
         this._mc.mouseEnabled = true;
         this.addClickEvent();
      }
      
      public function showBlood() : void
      {
         if(this._o == null || this._o.getBlood() == 2)
         {
            this._mc["blood"].mouseEnabled = this._mc["blood"].mouseChildren = false;
            return;
         }
         var _loc1_:Number = this._o.getHp().toNumber() / this._o.getHp_max().toNumber();
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         this._mc["blood"].scaleX = _loc1_;
      }
      
      public function showDoWorksEffect(param1:int, param2:int, param3:int, param4:MovieClip) : void
      {
         var effect_mc:MovieClip = null;
         var onPlay:Function = null;
         var type:int = param1;
         var money:int = param2;
         var exp:int = param3;
         var baseMc:MovieClip = param4;
         onPlay = function(param1:Event):void
         {
            var timer:Timer = null;
            var onTimer:Function = null;
            var e:Event = param1;
            if(effect_mc["work"].currentFrame == effect_mc["work"].totalFrames)
            {
               onTimer = function(param1:TimerEvent):void
               {
                  showExpEffect(exp,0,0,baseMc);
                  timer.removeEventListener(TimerEvent.TIMER,onTimer);
                  timer.stop();
               };
               effect_mc["work"].stop();
               effect_mc["work"].removeEventListener(Event.ENTER_FRAME,onPlay);
               FuncKit.clearAllChildrens(_mc["work"]);
               showEffect(getMoneyEffect(GOLD,money),money,baseMc);
               timer = new Timer(500);
               timer.addEventListener(TimerEvent.TIMER,onTimer);
               timer.start();
            }
         };
         this.clearState();
         if(type == OrganismManager.GAIN)
         {
            this.showGainEffect(money,exp,baseMc);
            return;
         }
         effect_mc = this.getWorkEffect(type);
         this._mc["work"].addChild(effect_mc);
         effect_mc["work"].gotoAndPlay(1);
         effect_mc["work"].addEventListener(Event.ENTER_FRAME,onPlay);
      }
      
      public function showGainEffect(param1:int, param2:int, param3:MovieClip) : void
      {
         var flyExp:Function = null;
         var money:int = param1;
         var exp:int = param2;
         var baseMc:MovieClip = param3;
         flyExp = function():void
         {
            var t:Timer = null;
            var onExp:Function = null;
            onExp = function(param1:TimerEvent):void
            {
               t.removeEventListener(TimerEvent.TIMER,onExp);
               t.stop();
            };
            showExpEffect(exp,0,0,baseMc);
            t = new Timer(450);
            t.addEventListener(TimerEvent.TIMER,onExp);
            t.start();
         };
         if(this._mc["money"] == null)
         {
            return;
         }
         this.closeLightEffect();
         this.flyMoney(money,0,0,flyExp,baseMc);
      }
      
      public function showStealEffect(param1:int, param2:int, param3:MovieClip) : void
      {
         var flyExp:Function = null;
         var money:int = param1;
         var exp:int = param2;
         var baseMc:MovieClip = param3;
         flyExp = function():void
         {
            var t:Timer = null;
            var onExp:Function = null;
            onExp = function(param1:TimerEvent):void
            {
               t.removeEventListener(TimerEvent.TIMER,onExp);
               t.stop();
            };
            showExpEffect(exp,0,0,baseMc);
            t = new Timer(450);
            t.addEventListener(TimerEvent.TIMER,onExp);
            t.start();
         };
         if(this._mc["money"] == null)
         {
            return;
         }
         this.flyMoney(money,0,0,flyExp,baseMc);
         this.showType();
      }
      
      public function showText(param1:String) : void
      {
         var onTimer:Function = null;
         var str:String = param1;
         onTimer = function(param1:TimerEvent):void
         {
            strTimer.removeEventListener(TimerEvent.TIMER,onTimer);
            strTimer.stop();
            strTimer = null;
            _mc["str"]._str.text = "";
            _mc["str"].visible = false;
         };
         if(this._o.getBlood() == 2)
         {
            return;
         }
         if(this.strTimer != null)
         {
            this.strTimer.removeEventListener(TimerEvent.TIMER,onTimer);
            this.strTimer.stop();
            this.strTimer = null;
         }
         this._mc["str"]._str.text = str;
         this._mc["str"].visible = true;
         this.strTimer = new Timer(3000);
         this.strTimer.addEventListener(TimerEvent.TIMER,onTimer);
         this.strTimer.start();
      }
      
      public function showType() : void
      {
         if(this._o.getBlood() == 2)
         {
            this._mc["type"].visible = false;
            return;
         }
         if(this.type == OrganismManager.WATER)
         {
            this._mc["type"].gotoAndStop(2);
         }
         else if(this.type == OrganismManager.FERTILISER)
         {
            this._mc["type"].gotoAndStop(3);
         }
         else if(this.type == OrganismManager.GAIN)
         {
            if(this._o.getGainTime() > 0)
            {
               this._mc["type"].visible = false;
               return;
            }
            if(this.playerManager.getPlayer().getId() != this._o.getGardenId() && this.playerManager.getPlayer().getId() != this._gardenMasterId)
            {
               this._mc["type"].visible = false;
               return;
            }
            this._mc["type"].gotoAndStop(1);
         }
         else if(this.type == OrganismManager.NULL)
         {
            this._mc["type"].visible = false;
            return;
         }
         this._mc["type"].visible = true;
      }
      
      public function stopOrg() : void
      {
         if(this._mc["org"].numChildren < 1)
         {
            return;
         }
         (this._mc["org"].getChildAt(0) as MovieClip).org.stop();
      }
      
      private function addClickEvent() : void
      {
         var onClick:Function = null;
         onClick = function(param1:MouseEvent):void
         {
            var end:Function = null;
            var e:MouseEvent = param1;
            end = function():void
            {
               var _loc1_:BattleReadyWindow = null;
               if(playerManager.getPlayer().getGardenChaCount() > 0)
               {
                  _loc1_ = new BattleReadyWindow(BattleReadyWindow.GARDEN_BATTLE);
                  _loc1_.gardenMonster = _mon;
                  _loc1_.show(_mon.id,_mon.monsters,huntingUpdate,"",effectOpen,0);
               }
               else
               {
                  new ChallengePropWindow(ChallengePropWindow.TYPE_GARDEN);
               }
            };
            PlantsVsZombies.playSounds(SoundManager.ZOMBIES);
            DistributionLoaderManager.I.loadUIByFunctionType(UINameConst.UI_BATTLE_READY_WINDOW,end);
            if(type == 0)
            {
               return;
            }
         };
         this._mc.addEventListener(MouseEvent.CLICK,onClick);
      }
      
      private function huntingUpdate() : void
      {
         this._call.call();
      }
      
      private function effectOpen() : void
      {
      }
      
      private function addGainEvent() : void
      {
         var onClick:Function = null;
         onClick = function(param1:MouseEvent):void
         {
            if(_gainFun != null && type == OrganismManager.GAIN)
            {
               _gainFun(type,_o);
            }
         };
         this._mc["money"].addEventListener(MouseEvent.CLICK,onClick);
      }
      
      private function clearState() : void
      {
         this._o.setGardenType(OrganismManager.NULL);
         this.type = OrganismManager.NULL;
         this.showType();
         this.setMoney();
      }
      
      private function flyMoney(param1:int, param2:int, param3:int, param4:Function, param5:MovieClip) : void
      {
         var i:int = 0;
         var t:Timer = null;
         var onTimer:Function = null;
         var onComp:Function = null;
         var money:int = param1;
         var x:int = param2;
         var y:int = param3;
         var backFunction:Function = param4;
         var baseMc:MovieClip = param5;
         onTimer = function(param1:TimerEvent):void
         {
            if(_mc["money"].numChildren < 1)
            {
               return;
            }
            showEffect(getMoneyEffectByMoney(money),money / i,baseMc);
         };
         onComp = function(param1:TimerEvent):void
         {
            t.removeEventListener(TimerEvent.TIMER,onTimer);
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,onComp);
            t.stop();
            if(backFunction != null)
            {
               backFunction();
            }
         };
         if(this._mc["money"].numChildren < 1)
         {
            if(backFunction != null)
            {
               backFunction();
            }
            return;
         }
         i = int(this._mc["money"].numChildren);
         FuncKit.clearAllChildrens(this._mc["money"]);
         this.showEffect(this.getMoneyEffectByMoney(money),money / i,baseMc);
         t = new Timer(450,i);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.addEventListener(TimerEvent.TIMER_COMPLETE,onComp);
         t.start();
      }
      
      private function getCombinationMoney(param1:int) : void
      {
         var temp:MovieClip = null;
         var temp2:MovieClip = null;
         var temp3:MovieClip = null;
         var money:int = param1;
         var getRandom:Function = function(param1:int, param2:Number):Number
         {
            if(param2 == 1)
            {
               return FuncKit.getRandom(0,param1);
            }
            return FuncKit.getRandom(0,param1) * param2 / param1;
         };
         if(money == 0)
         {
            return;
         }
         if(money < 21)
         {
            temp = this.getMoneyEffect(BOLIVAR);
            this._mc["money"].addChild(temp);
         }
         else if(money < 41)
         {
            temp = this.getMoneyEffect(BOLIVAR);
            temp2 = this.getMoneyEffect(BOLIVAR);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            temp2.x = temp2["coin"].width * getRandom(100,2);
            temp2.y = temp2["coin"].width * getRandom(100,0.5);
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
         }
         else if(money < 61)
         {
            temp = this.getMoneyEffect(BOLIVAR);
            temp2 = this.getMoneyEffect(BOLIVAR);
            temp3 = this.getMoneyEffect(BOLIVAR);
            temp2.x = temp2["coin"].width * getRandom(100,2);
            temp3.x = temp3["coin"].width * getRandom(100,2);
            temp2.y = temp2["coin"].width * getRandom(100,0.5);
            temp3.y = temp3["coin"].width * getRandom(100,0.5);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            temp3.gotoAndPlay(getRandom(temp3.totalFrames,1));
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
            this._mc["money"].addChild(temp3);
         }
         else if(money < 81)
         {
            temp = this.getMoneyEffect(GOLD);
            this._mc["money"].addChild(temp);
         }
         else if(money < 101)
         {
            temp = this.getMoneyEffect(GOLD);
            temp2 = this.getMoneyEffect(GOLD);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            temp2.x = temp2["coin"].width * getRandom(100,2);
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
         }
         else if(money < 121)
         {
            temp = this.getMoneyEffect(GOLD);
            temp2 = this.getMoneyEffect(GOLD);
            temp3 = this.getMoneyEffect(GOLD);
            temp2.x = temp2["coin"].width * getRandom(100,2);
            temp3.x = temp2["coin"].width * getRandom(100,2);
            temp2.y = temp2["coin"].width * getRandom(100,0.5);
            temp3.y = temp2["coin"].width * getRandom(100,0.5);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            temp3.gotoAndPlay(getRandom(temp3.totalFrames,1));
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
            this._mc["money"].addChild(temp3);
         }
         else if(money < 141)
         {
            temp = this.getMoneyEffect(GEM);
            this._mc["money"].addChild(temp);
         }
         else if(money < 161)
         {
            temp = this.getMoneyEffect(GEM);
            temp2 = this.getMoneyEffect(GEM);
            temp2.x = temp2["coin"].width * getRandom(100,2);
            temp.x = temp["coin"].width * getRandom(100,0.5);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
         }
         else
         {
            temp = this.getMoneyEffect(GEM);
            temp2 = this.getMoneyEffect(GEM);
            temp3 = this.getMoneyEffect(GEM);
            temp2.x = temp2["coin"].width * getRandom(100,2);
            temp3.x = temp3["coin"].width * getRandom(100,2);
            temp2.y = temp2["coin"].width * getRandom(100,0.5);
            temp3.y = temp3["coin"].width * getRandom(100,0.5);
            temp2.gotoAndPlay(getRandom(temp2.totalFrames,1));
            temp3.gotoAndPlay(getRandom(temp3.totalFrames,1));
            this._mc["money"].addChild(temp);
            this._mc["money"].addChild(temp2);
            this._mc["money"].addChild(temp3);
         }
      }
      
      private function getExpEffect(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("exp");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(StringMovieClip.getStringImage(param1 + "","Exp"));
         return _loc3_;
      }
      
      private function getMoneyEffect(param1:int, param2:int = 0) : MovieClip
      {
         var _loc3_:Class = DomainAccess.getClass("money_" + param1);
         var _loc4_:MovieClip = new _loc3_();
         _loc4_["num"].visible = true;
         if(param2 == 0)
         {
            _loc4_["num"].visible = false;
         }
         else
         {
            _loc4_["num"].addChild(StringMovieClip.getStringImage(param2 + "","Small"));
         }
         return _loc4_;
      }
      
      private function getMoneyEffectByMoney(param1:int) : MovieClip
      {
         if(param1 < 80)
         {
            return this.getMoneyEffect(BOLIVAR,param1);
         }
         if(param1 < 140)
         {
            return this.getMoneyEffect(GOLD,param1);
         }
         return this.getMoneyEffect(GEM,param1);
      }
      
      private function getNode(param1:Organism) : MovieClip
      {
         var _loc2_:int = param1.getWidth() * param1.getHeight();
         var _loc3_:Class = DomainAccess.getClass("gardenOrgNode_" + _loc2_);
         if(param1.getBlood() == 2)
         {
            _loc3_ = DomainAccess.getClass("gardenMonNode_" + 1);
         }
         return new _loc3_();
      }
      
      private function getWorkEffect(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("work_" + param1);
         return new _loc2_();
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.state == PUT)
         {
            if(this._o.getBlood() != 2)
            {
               if(this.tips == null || this.tips is GardenMonsterTip)
               {
                  this.tips = new GardenOrgTip();
               }
               this.tips.setOrgtip(this._mc,this._o);
               this.tips.setLoction(this.getPositionX(),this.getPositionY());
            }
            else
            {
               Mouse.hide();
               this.mouseMc.x = param1.localX + 30;
               this.mouseMc.y = param1.localY + 80;
               this.addChild(this.mouseMc);
               if(this.tips == null || this.tips is GardenOrgTip)
               {
                  this.tips = new GardenMonsterTip();
               }
               this.tips.setTooltip(this._mc,this._mon);
               this.tips.setLoction(this.getPositionX(),this.getPositionY());
            }
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         Mouse.show();
         if(this.mouseMc.parent)
         {
            this.mouseMc.parent.removeChild(this.mouseMc);
         }
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         if(this.mouseMc.parent)
         {
            this.mouseMc.x = param1.localX + 30;
            this.mouseMc.y = param1.localY + 80;
         }
      }
      
      private function setMoney() : void
      {
         if(this._o.getGardenType() != OrganismManager.GAIN || this._o.getGainTime() > 0)
         {
            FuncKit.clearAllChildrens(this._mc["money"]);
            return;
         }
         if(this._o.getIsSteal() == 1 && this._o.getGardenId() != this.playerManager.getPlayer().getId())
         {
            this.showMoney(this._o.getPurse_amount() / 10);
            return;
         }
         if(this._o.getGardenId() == this.playerManager.getPlayer().getId())
         {
            this.showMoney(this._o.getPurse_amount());
            return;
         }
         FuncKit.clearAllChildrens(this._mc["money"]);
      }
      
      private function showEffect(param1:MovieClip, param2:int, param3:MovieClip) : void
      {
         param1["coin"].gotoAndStop(1);
         param1["num"].visible = true;
         if(this._mc.parent == null || this._mc.parent.parent == null)
         {
            return;
         }
         var _loc4_:int = this._mc.parent.x + this._mc.parent.parent.x;
         var _loc5_:int = this._mc.parent.y + this._mc.parent.parent.y;
         FlapManager.flapInfos(_loc4_,_loc5_,param3,param1,2);
      }
      
      private function showExpEffect(param1:int, param2:int, param3:int, param4:MovieClip) : void
      {
         this.showEffect(this.getExpEffect(param1),param1,param4);
      }
      
      private function showMoney(param1:int) : void
      {
         this.getCombinationMoney(param1);
      }
   }
}


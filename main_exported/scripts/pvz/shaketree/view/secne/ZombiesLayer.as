package pvz.shaketree.view.secne
{
   import com.res.IDestroy;
   import core.interfaces.IHelp;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import manager.LangManager;
   import pvz.help.NewHelper;
   import pvz.shaketree.event.HandleDataCompleteEvent;
   import pvz.shaketree.net.ShakeTreeFPort;
   import pvz.shaketree.rpc.ShakeTreeAttackRpc;
   import pvz.shaketree.view.ZombiesSprite;
   import pvz.shaketree.view.windows.PassLevelWindow;
   import pvz.shaketree.vo.PassData;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import pvz.shaketree.vo.ZombiesVo;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import windows.PrizesWindow;
   
   public class ZombiesLayer implements IDestroy, IHelp
   {
      
      private var _scene:ShakeTreeScene;
      
      private var _layberNode:MovieClip;
      
      private var _isAttacking:Boolean = false;
      
      public function ZombiesLayer(param1:ShakeTreeScene)
      {
         super();
         this._scene = param1;
         this._layberNode = param1.ui.zombiesLayer;
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.createZombies();
         if(ShakeTreeSystermData.I.getHelpStaus() == 1)
         {
            this.showHelp(1);
         }
         else if(ShakeTreeSystermData.I.getHelpStaus() == 2)
         {
            this.showHelp(5);
         }
      }
      
      private function onAttack(param1:MouseEvent) : void
      {
         var tempZomibeSprite:ZombiesSprite = null;
         var port:ShakeTreeFPort = null;
         var onHandleDataComplete:Function = null;
         var event:MouseEvent = param1;
         onHandleDataComplete = function(param1:HandleDataCompleteEvent):void
         {
            var attackRpc:ShakeTreeAttackRpc = null;
            var showPrizes:Function = null;
            var e:HandleDataCompleteEvent = param1;
            showPrizes = function():void
            {
               var end:Function = null;
               end = function():void
               {
                  showPrizesWindow(attackRpc);
                  _scene.getEffectLayer().clearLayer();
                  _isAttacking = false;
               };
               tempZomibeSprite.updateBloodBar();
               _scene.getEffectLayer().showJewelPrizeLabels(attackRpc.getAttackPrizes(),new Point(tempZomibeSprite.x,tempZomibeSprite.y));
               setTimeout(end,1000);
            };
            port.removeEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onHandleDataComplete);
            attackRpc = new ShakeTreeAttackRpc();
            attackRpc.parseAttackData(e._data,tempZomibeSprite.getId());
            ShakeTreeSystermData.I.setChanllgeTime(ShakeTreeSystermData.I.getChanllgeTimes() - 1);
            _scene.getUILayer().updateAttackTimes();
            _scene.getEffectLayer().showExplosionEffect(new Point(tempZomibeSprite.x,tempZomibeSprite.y),attackRpc.baojiBeishi(),showPrizes);
         };
         if(ShakeTreeSystermData.I.getChanllgeTimes() <= 0)
         {
            this._scene.getUILayer().toBuyChallengeTimes();
            return;
         }
         if(this._isAttacking == true)
         {
            return;
         }
         if(!this._isAttacking)
         {
            this._isAttacking = true;
         }
         if(ShakeTreeSystermData.I.getHelpStaus() == 1 || ShakeTreeSystermData.I.getHelpStaus() == 2)
         {
            this.showHelp(2);
         }
         tempZomibeSprite = event.currentTarget as ZombiesSprite;
         port = new ShakeTreeFPort();
         port.requestSever(ShakeTreeFPort.ATTACK,tempZomibeSprite.getId());
         port.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,onHandleDataComplete);
      }
      
      private function showPrizesWindow(param1:ShakeTreeAttackRpc) : void
      {
         var showEnd:Function = null;
         var attckrpc:ShakeTreeAttackRpc = param1;
         showEnd = function():void
         {
            var passData:PassData;
            var playPassAnimationEnd:Function;
            var passLevelAnimation:MovieClip = null;
            if(ShakeTreeSystermData.I.getHelpStaus() == 1)
            {
               showHelp(4);
               ShakeTreeSystermData.I.setHelpStaus(2);
            }
            else if(ShakeTreeSystermData.I.getHelpStaus() == 2)
            {
               showHelp(6);
               ShakeTreeSystermData.I.setHelpStaus(3);
            }
            passData = ShakeTreeSystermData.I.currentPassData();
            if(passData.getIsPassLevel())
            {
               playPassAnimationEnd = function():void
               {
                  var closeCallback:Function = null;
                  closeCallback = function():void
                  {
                     var _loc1_:MovieClip = GetDomainRes.getMoveClip("pvz.nextZomibeComing");
                     FuncKit.PlayFlashAnimation(_loc1_,null,reflashZomibes);
                     _scene.getUILayer().updateBaoJiBar();
                  };
                  var passLevelWindow:PassLevelWindow = new PassLevelWindow(closeCallback);
                  passLevelWindow.show(attckrpc.getUpPrizes());
               };
               _scene.getUILayer().showHundred();
               passLevelAnimation = GetDomainRes.getMoveClip("pvz.passLevelAnimation");
               FuncKit.PlayFlashAnimation(passLevelAnimation,null,playPassAnimationEnd);
            }
            else
            {
               _scene.getUILayer().updateBaoJiBar();
            }
            if(ShakeTreeSystermData.I.getChanllgeTimes() <= 0)
            {
               _scene.getUILayer().toBuyChallengeTimes();
            }
         };
         var tools:Array = attckrpc.getAttackPrizes();
         var prizeWindows:PrizesWindow = new PrizesWindow(showEnd,PlantsVsZombies._node as DisplayObjectContainer);
         prizeWindows.show(tools);
         if(ShakeTreeSystermData.I.getHelpStaus() == 1 || ShakeTreeSystermData.I.getHelpStaus() == 2)
         {
            this.showHelp(3);
         }
      }
      
      private function reflashZomibes() : void
      {
         var dataEnd:Function = null;
         dataEnd = function(param1:HandleDataCompleteEvent):void
         {
            _scene.getUILayer().updatePassLevel();
            initUI();
         };
         var port:ShakeTreeFPort = new ShakeTreeFPort();
         port.requestSever(ShakeTreeFPort.INIT);
         port.addEventListener(HandleDataCompleteEvent.HANDLE_DATA_COMPLETE,dataEnd);
      }
      
      private function createZombies() : void
      {
         var _loc2_:ZombiesSprite = null;
         var _loc3_:ZombiesVo = null;
         this.clearAllZomibes();
         var _loc1_:Vector.<ZombiesVo> = ShakeTreeSystermData.I.currentPassData().getZombies();
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = new ZombiesSprite();
            _loc2_.createZomeies(_loc3_.getId());
            _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onAttack);
            this._layberNode.addChild(_loc2_);
            _loc2_.x = _loc3_.position().x;
            _loc2_.y = _loc3_.position().y;
         }
      }
      
      private function clearAllZomibes() : void
      {
         var _loc1_:ZombiesSprite = null;
         while(this._layberNode.numChildren)
         {
            _loc1_ = this._layberNode.getChildAt(0) as ZombiesSprite;
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.onAttack);
            _loc1_.destroy();
            this._layberNode.removeChild(_loc1_);
         }
      }
      
      public function destroy() : void
      {
         this.clearAllZomibes();
      }
      
      public function showHelp(param1:int = 0, ... rest) : void
      {
         var callback:Function;
         var callback1:Function;
         var str:String = null;
         var type:int = param1;
         var args:Array = rest;
         if(type == 1)
         {
            str = LangManager.getInstance().getLanguage("helpGuide001");
            NewHelper.I.showHelpForIndeedPoint(null,new Rectangle(192,305,100,100),str,NewHelper.ARROW_LEFT);
         }
         else if(type == 2)
         {
            NewHelper.I.closeHelp();
         }
         else if(type == 3)
         {
            str = LangManager.getInstance().getLanguage("helpGuide002");
            NewHelper.I.showHelpForIndeedPoint(null,new Rectangle(333,416,100,30),str,NewHelper.ARROW_UP,200,"",null,new Rectangle(166,87,446,328));
         }
         else if(type == 4)
         {
            callback = function():void
            {
               showHelp(5);
            };
            str = LangManager.getInstance().getLanguage("helpGuide003");
            NewHelper.I.showHelpForIndeedPoint(null,new Rectangle(143,100,480,40),str,NewHelper.ARROW_UP,180,"确定",callback);
         }
         else if(type == 5)
         {
            str = LangManager.getInstance().getLanguage("helpGuide004");
            NewHelper.I.showHelpForIndeedPoint(null,new Rectangle(320,285,100,100),str,NewHelper.ARROW_LEFT);
         }
         else if(type == 6)
         {
            callback1 = function():void
            {
               NewHelper.I.closeHelp();
            };
            str = LangManager.getInstance().getLanguage("helpGuide005");
            NewHelper.I.showHelpForIndeedPoint(null,new Rectangle(143,100,480,40),str,NewHelper.ARROW_UP,220,"确定",callback1);
         }
      }
   }
}


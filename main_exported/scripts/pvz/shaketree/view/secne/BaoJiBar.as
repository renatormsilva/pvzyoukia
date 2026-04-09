package pvz.shaketree.view.secne
{
   import effect.flap.FlapManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pvz.shaketree.view.tips.PassLevelPrizeInfoTips;
   import pvz.shaketree.view.windows.UpGradeVipWindow;
   import pvz.shaketree.vo.PassData;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.LightUp;
   import utils.StringMovieClip;
   
   public class BaoJiBar
   {
      
      private var _baoji:MovieClip;
      
      private var _parent:DisplayObjectContainer;
      
      private var _baojiEnough:MovieClip;
      
      private var _faguang:LightUp;
      
      private var _tips:PassLevelPrizeInfoTips;
      
      private var _fisrtEnter:Boolean = true;
      
      private var m_comppre:int;
      
      private var m_baojpre:int;
      
      public function BaoJiBar(param1:DisplayObjectContainer)
      {
         super();
         this._baoji = GetDomainRes.getMoveClip("pvz.shakeTree.bar");
         param1["baojiLayerNode"].addChild(this._baoji);
         this._baoji.x = (param1.width - this._baoji.width) / 2 - 25;
         this._baoji.y = 65;
         this._parent = param1;
         this.updateBaojiShu();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._baoji["checkInfo_btn"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._baoji["checkInfo_btn"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._tips = new PassLevelPrizeInfoTips();
         this._tips.showTipss(ShakeTreeSystermData.I.currentPassData().getPassLevelPrize());
         this._parent.addChild(this._tips);
         this._tips.x = 560;
         this._tips.y = 110;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._parent.removeChild(this._tips);
      }
      
      public function updatabar() : void
      {
         this.updataCompBar();
         this.updataBaoJiBar();
      }
      
      public function showHundred() : void
      {
         var _loc1_:String = 100 + "Per";
         var _loc2_:int = 100 - this.m_comppre;
         this.flapAddedNum(_loc2_,"complete");
         var _loc3_:DisplayObject = FuncKit.getNumEffect(_loc1_,"baoji",-2);
         _loc3_.x = -_loc3_.width / 2;
         FuncKit.clearAllChildrens(this._baoji["comp"]["per"]);
         this._baoji["comp"]["per"].addChild(_loc3_);
         this.playBarScale(this._baoji["comp"]["compbar"],100,"complete");
      }
      
      private function updataCompBar() : void
      {
         var _loc1_:PassData = ShakeTreeSystermData.I.currentPassData() as PassData;
         var _loc2_:String = _loc1_.getRete().toString() + "Per";
         var _loc3_:int = _loc1_.getRete() - this.m_comppre;
         this.flapAddedNum(_loc3_,"complete");
         var _loc4_:DisplayObject = FuncKit.getNumEffect(_loc2_,"baoji",-2);
         _loc4_.x = -_loc4_.width / 2;
         FuncKit.clearAllChildrens(this._baoji["comp"]["per"]);
         this._baoji["comp"]["per"].addChild(_loc4_);
         this.playBarScale(this._baoji["comp"]["compbar"],_loc1_.getRete(),"complete");
         this.m_comppre = _loc1_.getRete();
      }
      
      private function updataBaoJiBar() : void
      {
         var _loc1_:PassData = ShakeTreeSystermData.I.currentPassData() as PassData;
         var _loc2_:String = _loc1_.getBaojiOdds().toString() + "Per";
         var _loc3_:int = _loc1_.getBaojiOdds() - this.m_baojpre;
         this.flapAddedNum(_loc3_,"baoji");
         var _loc4_:DisplayObject = FuncKit.getNumEffect(_loc2_,"baoji",-2);
         _loc4_.x = -_loc4_.width / 2;
         FuncKit.clearAllChildrens(this._baoji["baoj"]["per"]);
         this._baoji["baoj"]["per"].addChild(_loc4_);
         this.playBarScale(this._baoji["baoj"]["baojbar"],_loc1_.getBaojiOdds(),"baoji");
         this.m_baojpre = _loc1_.getBaojiOdds();
      }
      
      private function playBarScale(param1:MovieClip, param2:int, param3:String) : void
      {
         var target_frame:int = 0;
         var cframe:int = 0;
         var playBarMc:Function = null;
         var target:MovieClip = param1;
         var num:int = param2;
         var type:String = param3;
         playBarMc = function(param1:Event):void
         {
            if(param1.currentTarget.currentFrame == target_frame)
            {
               target.stop();
               target.removeEventListener(Event.ENTER_FRAME,playBarMc);
               target = null;
            }
         };
         target_frame = num;
         if(this._fisrtEnter)
         {
            if(target_frame == 0)
            {
               target.gotoAndStop(1);
            }
            else
            {
               target.gotoAndStop(target_frame);
            }
            target = null;
            if(type == "baoji")
            {
               this._fisrtEnter = false;
            }
            return;
         }
         if(target_frame == 0)
         {
            target.gotoAndStop(1);
            return;
         }
         if(type == "complete")
         {
            cframe = this.m_comppre == 0 ? 1 : this.m_comppre;
         }
         else if(type == "baoji")
         {
            cframe = this.m_baojpre == 0 ? 1 : this.m_baojpre;
         }
         target.gotoAndStop(cframe);
         target.addEventListener(Event.ENTER_FRAME,playBarMc);
         target.play();
      }
      
      private function flapAddedNum(param1:int, param2:String) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1 <= 0 || this._fisrtEnter)
         {
            return;
         }
         var _loc5_:Sprite = GetDomainRes.getSprite("jia");
         var _loc6_:String = param1.toString() + "Per";
         var _loc7_:DisplayObject = StringMovieClip.getStringImage(_loc6_ + "","baoji");
         _loc7_.y = 3;
         _loc5_["num"].addChild(_loc7_);
         this._parent["baojiLayerNode"].addChild(_loc5_);
         if(param2 == "complete")
         {
            _loc3_ = this._baoji["comp"].x + this._baoji["comp"].width;
            _loc4_ = this._baoji["comp"].y + this._baoji["comp"].height * 2;
         }
         else if(param2 == "baoji")
         {
            _loc3_ = this._baoji["baoj"].x + this._baoji["baoj"].width;
            _loc4_ = this._baoji["baoj"].y + this._baoji["baoj"].height * 2;
         }
         FlapManager.flapInfos(_loc3_,_loc4_,this._parent["baojiLayerNode"],_loc5_ as DisplayObject,1);
      }
      
      private function updateBaojiShu() : void
      {
         FuncKit.clearAllChildrens(this._parent["beishuNode"]);
         var _loc1_:int = ShakeTreeSystermData.I.currentPassData().getBaojiMult();
         if(_loc1_ >= 8)
         {
            this._parent["upgrade_btn"].visible = false;
            if(this._faguang)
            {
               this._faguang.closeLightUp();
               this._faguang = null;
            }
         }
         else
         {
            this._faguang = new LightUp(this._parent["upgrade_btn"],16763904);
            this._parent["upgrade_btn"].addEventListener(MouseEvent.MOUSE_UP,this.baojiMouseUpHandle);
         }
         this._parent["beishuNode"].addChild(FuncKit.getNumEffect(_loc1_ + "","baojic"));
      }
      
      private function baojiMouseUpHandle(param1:MouseEvent) : void
      {
         var back:Function = null;
         var e:MouseEvent = param1;
         back = function():void
         {
            if(PlantsVsZombies.playerManager.isVip(PlantsVsZombies.playerManager.getPlayer().getVipTime()) != null)
            {
               if(PlantsVsZombies.playerManager.getPlayer().getVipLevel() >= 1 && PlantsVsZombies.playerManager.getPlayer().getVipLevel() <= 3)
               {
                  ShakeTreeSystermData.I.currentPassData().setBaojiMult(4);
               }
               else if(PlantsVsZombies.playerManager.getPlayer().getVipLevel() == 4)
               {
                  ShakeTreeSystermData.I.currentPassData().setBaojiMult(8);
               }
               updateBaojiShu();
            }
         };
         new UpGradeVipWindow(back);
      }
      
      public function destroy() : void
      {
         if(this._faguang)
         {
            this._faguang.closeLightUp();
            this._faguang = null;
         }
         this._parent["upgrade_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.baojiMouseUpHandle);
         this._baoji["checkInfo_btn"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._baoji["checkInfo_btn"].removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._parent = null;
         this._baoji = null;
      }
   }
}


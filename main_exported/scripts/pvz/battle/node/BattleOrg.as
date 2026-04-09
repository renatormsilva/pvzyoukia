package pvz.battle.node
{
   import com.display.BitmapDateSourseManager;
   import com.display.BitmapFrameInfo;
   import com.display.BitmapFrameInfos;
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import effect.flap.FlapManager;
   import entity.GeniusSkill;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import manager.EffectManager;
   import manager.OrganismManager;
   import pvz.battle.battleMode.Battle;
   import pvz.battle.entity.BattleNaturalVo;
   import pvz.battle.entity.BuffVo;
   import pvz.battle.fore.BattleScenceShow;
   import utils.BigInt;
   import utils.FuncKit;
   import xmlReader.config.XmlGeniusDataConfig;
   import zlib.utils.DomainAccess;
   
   public class BattleOrg extends Sprite
   {
      
      public static const ATTACK:String = "_attack_0";
      
      public static const ATTACK_OVER:String = "_attackover_0";
      
      public static const NORMAL:String = "_0";
      
      public static const ORG:String = "org_";
      
      public var _backFunc:Function;
      
      public var _damage:BigInt;
      
      public var _exdamage:BigInt;
      
      public var _exRallydamage:BigInt;
      
      public var _o:Organism = null;
      
      private var _attack:CMovieClip = null;
      
      private var _attackPoint:Point = null;
      
      private var _attack_over:CMovieClip = null;
      
      private var _campType:int = 0;
      
      private var _loc:int = 0;
      
      private var _normal:CMovieClip = null;
      
      private var geniusEffectNode:Sprite;
      
      private var exclusiveSkillsNode:Sprite;
      
      private var buffNode:Sprite;
      
      private var dizzNode:CMovieClip;
      
      private var shieldNode:CMovieClip;
      
      private var genius_type:Boolean = false;
      
      private var _exclusiveSkills:Array;
      
      private var curBuff:Array = [];
      
      public function BattleOrg(param1:Organism, param2:int, param3:int)
      {
         super();
         this._o = param1;
         this._loc = param2;
         this._campType = param3;
         this.initOrg(this._o.getPicId(),param1.getSize());
         this._normal.play();
         addChild(this._normal);
         this._attack.visible = false;
         addChild(this._attack);
         this.geniusEffectNode = new Sprite();
         this.addChild(this.geniusEffectNode);
         this.exclusiveSkillsNode = new Sprite();
         this.addChild(this.exclusiveSkillsNode);
         this.buffNode = new Sprite();
         this.dizzNode = BattleScenceShow.getBuffEffect(4,1);
         this.dizzNode.gotoAndStop(1);
         this.dizzNode.x = 0;
         this.dizzNode.y = this._normal.height > 120 ? -120 : -this._normal.height;
         this.dizzNode.visible = false;
         this.addChild(this.dizzNode);
         this.shieldNode = BattleScenceShow.getBuffEffect(81,1);
         this.shieldNode.gotoAndStop(1);
         this.shieldNode.x = 0;
         this.shieldNode.y = this._normal.height > 120 ? -120 : -this._normal.height;
         this.shieldNode.visible = false;
         this.addChild(this.shieldNode);
         this.addChild(this.buffNode);
         this.buffNode.x = -23;
         this.buffNode.y = 3;
         if(this._attack_over != null)
         {
            this._attack_over.visible = false;
            addChild(this._attack_over);
         }
         this.setLightEffect(this._o);
         this.setGlowTween(this._o);
      }
      
      public static function layoutHorizontal(param1:DisplayObjectContainer, param2:Number = 0, param3:int = 0) : void
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
            _loc7_.x = _loc5_;
            _loc5_ = _loc7_.width + _loc7_.x + param2;
            _loc6_++;
         }
      }
      
      private function getOrgCMovieClip(param1:String, param2:MovieClip, param3:int, param4:Number = 1) : CMovieClip
      {
         var _loc5_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(param2,param1,param4);
         var _loc6_:CMovieClip = new CMovieClip(_loc5_,12);
         if(param3 == 1)
         {
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param4;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param4;
            }
            else
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param4;
            }
         }
         else
         {
            _loc6_.bitmap.x = _loc5_.getBaseMcTransform().matrix.tx * param4;
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param4;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
            }
         }
         return _loc6_;
      }
      
      public function attacked() : void
      {
         var t:CTimer = null;
         var onTimer:Function = null;
         var onComp:Function = null;
         onTimer = function(param1:CTimerEvent):void
         {
            if(_normal)
            {
               if(_normal.visible)
               {
                  _normal.visible = false;
               }
               else
               {
                  _normal.visible = true;
               }
            }
         };
         onComp = function(param1:CTimerEvent):void
         {
            t.removeEventListener(CTimerEvent.TIMER,onTimer);
            t.removeEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
            t.stop();
            if(_normal)
            {
               _normal.visible = true;
            }
         };
         t = new CTimer(80,2);
         t.addEventListener(CTimerEvent.TIMER,onTimer);
         t.addEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
         t.start();
      }
      
      public function dodgeEf(param1:Boolean, param2:int, param3:int, param4:DisplayObjectContainer) : void
      {
         var _loc5_:CMovieClip = null;
         if(param1)
         {
            _loc5_ = BattleScenceShow.getAttackedEffect(15);
            _loc5_.gotoAndStop(1);
            FlapManager.flapInfos(param2 - _loc5_.width / 2,param3,param4,_loc5_,1);
         }
      }
      
      public function clearGeiusEffect() : void
      {
         FuncKit.clearAllChildrens(this.geniusEffectNode);
         this._backFunc = null;
      }
      
      public function clearLightDongEffect() : void
      {
         var _loc2_:CMovieClip = null;
         var _loc1_:* = this.geniusEffectNode.numChildren;
         while(_loc1_ > 0)
         {
            _loc1_--;
            _loc2_ = this.geniusEffectNode.getChildAt(0) as CMovieClip;
            _loc2_.stop();
            this.geniusEffectNode.removeChild(_loc2_);
         }
      }
      
      public function clearExclusiveSkillsEffect() : void
      {
         var _loc2_:CMovieClip = null;
         var _loc1_:* = this.exclusiveSkillsNode.numChildren;
         while(_loc1_ > 0)
         {
            _loc1_--;
            _loc2_ = this.exclusiveSkillsNode.getChildAt(0) as CMovieClip;
            _loc2_.stop();
            this.exclusiveSkillsNode.removeChild(_loc2_);
         }
      }
      
      public function clearBuffEffect() : void
      {
         var _loc2_:CMovieClip = null;
         var _loc1_:* = this.buffNode.numChildren;
         this.shieldNode.visible = false;
         this.shieldNode.gotoAndStop(1);
         while(_loc1_ > 0)
         {
            _loc1_--;
            _loc2_ = this.buffNode.getChildAt(0) as CMovieClip;
            _loc2_.stop();
            this.buffNode.removeChild(_loc2_);
         }
      }
      
      public function clearDizzNodeEffect() : void
      {
         this.dizzNode.visible = false;
         this.dizzNode.gotoAndStop(1);
      }
      
      public function doAttack(param1:Function) : void
      {
         var onComp:Function = null;
         var onAttackComp:Function = null;
         var end:Function = param1;
         onComp = function(param1:CMovieClipEvent):void
         {
            _normal.visible = false;
            _normal.stop();
            _normal.removeEventListener(CMovieClipEvent.COMPLETE,onComp);
            _attack.visible = true;
            _attack.gotoAndPlay(1);
            _attack.addEventListener(CMovieClipEvent.COMPLETE,onAttackComp);
         };
         onAttackComp = function(param1:CMovieClipEvent):void
         {
            _attack.removeEventListener(CMovieClipEvent.COMPLETE,onAttackComp);
            _attack.visible = false;
            _attack.stop();
            if(end != null)
            {
               end();
            }
            doAttackOver();
         };
         this.clearDizzNodeEffect();
         this._normal.addEventListener(CMovieClipEvent.COMPLETE,onComp);
      }
      
      public function doAttackClose(param1:Function) : void
      {
         var onAttackComp:Function = null;
         var end:Function = param1;
         onAttackComp = function(param1:CMovieClipEvent):void
         {
            _attack.visible = false;
            _normal.visible = true;
            _attack.removeEventListener(CMovieClipEvent.COMPLETE,onAttackComp);
            _attack.gotoAndStop(1);
            if(end != null)
            {
               end();
            }
         };
         this._normal.visible = false;
         this._attack.visible = true;
         this._attack.gotoAndPlay(1);
         this._attack.addEventListener(CMovieClipEvent.COMPLETE,onAttackComp);
      }
      
      public function doAttackOver() : void
      {
         var onAttackOverComp:Function = null;
         onAttackOverComp = function(param1:CMovieClipEvent):void
         {
            _attack_over.removeEventListener(CMovieClipEvent.COMPLETE,onAttackOverComp);
            _attack_over.visible = false;
            _attack_over.stop();
            _normal.visible = true;
            _normal.gotoAndPlay(1);
         };
         this._attack_over.visible = true;
         this._attack_over.addEventListener(CMovieClipEvent.COMPLETE,onAttackOverComp);
         this._attack_over.gotoAndPlay(1);
      }
      
      public function get geniusType() : Boolean
      {
         return this.genius_type;
      }
      
      public function getAttackPoint() : Point
      {
         return this._attackPoint;
      }
      
      public function getLoc() : int
      {
         return this._loc;
      }
      
      public function getOrg() : Organism
      {
         return this._o;
      }
      
      public function getOrgNormal() : CMovieClip
      {
         return this._normal;
      }
      
      public function getOrgNormalHeight() : int
      {
         return (this._normal.getBitmapdateInfos().getBitmapFrames()[0] as BitmapFrameInfo).date.height;
      }
      
      public function getOrgNormalWidth() : int
      {
         return (this._normal.getBitmapdateInfos().getBitmapFrames()[0] as BitmapFrameInfo).date.width;
      }
      
      public function setGeiusEffect(param1:Array, param2:Function = null) : void
      {
         var _loc3_:GeniusSkill = null;
         var _loc4_:String = null;
         var _loc5_:BigInt = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.gAcceptId == this._o.getId())
            {
               this.genius_type = _loc3_.attackedOrNot;
               _loc4_ = _loc3_.attackNum;
               _loc5_ = new BigInt(_loc4_);
               this._damage = _loc5_;
               this.ClipMotion(_loc3_.geniusSkillId,param2);
            }
         }
      }
      
      private function ClipMotion(param1:String, param2:Function = null) : void
      {
         var _loc3_:CMovieClip = BattleScenceShow.getGeniusEffect(param1,1);
         _loc3_.gotoAndPlay(1);
         this.geniusEffectNode.addChild(_loc3_);
         switch(param1)
         {
            case XmlGeniusDataConfig.LIGHT_DEFFENCE:
               _loc3_.addEventListener(Event.ENTER_FRAME,this.playLight);
               break;
            case XmlGeniusDataConfig.POISON:
               if(param2 != null)
               {
                  param2();
               }
               _loc3_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
         }
      }
      
      public function setExclusiveSkillsData(param1:Array) : void
      {
         this._exclusiveSkills = param1;
      }
      
      public function getExclusiveSkillsData() : Array
      {
         return this._exclusiveSkills;
      }
      
      public function setExclusiveSkillsDamage(param1:Array, param2:Function = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:BigInt = null;
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ is BattleNaturalVo && _loc3_.actionId == this._o.getId().toString())
               {
                  _loc4_ = BattleNaturalVo(_loc3_).attackNum.toString();
                  _loc5_ = new BigInt(_loc4_);
                  if(BattleNaturalVo(_loc3_).skill_type == 5)
                  {
                     this._exRallydamage = _loc5_;
                  }
                  else
                  {
                     this._exdamage = _loc5_;
                  }
               }
            }
         }
      }
      
      public function setExclusiveSkillsEffect(param1:Array, param2:Function = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:BigInt = null;
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ is BattleNaturalVo && _loc3_.actionId == this._o.getId().toString())
               {
                  _loc4_ = BattleNaturalVo(_loc3_).attackNum.toString();
                  _loc5_ = new BigInt(_loc4_);
                  if(BattleNaturalVo(_loc3_).skill_type == 5)
                  {
                     this._exRallydamage = _loc5_;
                  }
                  else
                  {
                     this._exdamage = _loc5_;
                  }
                  this.ClipExclusiveSkills(int(BattleNaturalVo(_loc3_).movieType),param2,_loc3_);
               }
            }
         }
      }
      
      private function ClipExclusiveSkills(param1:int, param2:Function = null, param3:Object = null) : void
      {
         var _loc4_:CMovieClip = BattleScenceShow.getExclusiveSkillsEffect(param1,1);
         _loc4_.gotoAndPlay(1);
         this.exclusiveSkillsNode.addChild(_loc4_);
         switch(param1)
         {
            case 1:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 2:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 3:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 4:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 5:
               if(param2 != null)
               {
                  param2(param3);
               }
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 6:
               if(param2 != null)
               {
                  param2(param3);
               }
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 7:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
               break;
            case 8:
               _loc4_.addEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
         }
      }
      
      public function setExclusiveSkillsHp(param1:Array, param2:Function = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:BigInt = null;
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ is BattleNaturalVo && BattleNaturalVo(_loc3_).actionId == this._o.getId().toString())
               {
                  _loc4_ = BattleNaturalVo(_loc3_).attackNum.toString();
                  _loc5_ = new BigInt(_loc4_);
                  if(BattleNaturalVo(_loc3_).skill_type == 5)
                  {
                     this._exRallydamage = _loc5_;
                  }
                  else
                  {
                     this._exdamage = _loc5_;
                  }
                  if(param2 != null && _loc4_ != "0")
                  {
                     param2(_loc3_,this);
                  }
               }
            }
         }
      }
      
      public function refBuff(param1:Array) : void
      {
         var _loc2_:BuffVo = null;
         var _loc3_:CMovieClip = null;
         this.clearBuffEffect();
         this.curBuff.length = 0;
         for each(_loc2_ in param1)
         {
            if(this._o.getId() == _loc2_.targetId && _loc2_.state == 2 && this.cleckSame(_loc2_))
            {
               this.curBuff.push(_loc2_);
               if(_loc2_.buffId != 4)
               {
                  _loc3_ = BattleScenceShow.getBuffEffect(_loc2_.buffId,1);
                  _loc3_.gotoAndStop(1);
                  this.buffNode.addChild(_loc3_);
                  if(_loc2_.buffId == 8)
                  {
                     this.shieldNode.visible = true;
                     this.shieldNode.gotoAndPlay(1);
                  }
               }
               else
               {
                  this.dizzNode.visible = true;
                  this.dizzNode.gotoAndPlay(1);
               }
            }
         }
         layoutHorizontal(this.buffNode);
      }
      
      public function addBuff(param1:Array) : void
      {
         var _loc2_:BuffVo = null;
         var _loc3_:CMovieClip = null;
         for each(_loc2_ in param1)
         {
            if(this._o.getId() == _loc2_.targetId && _loc2_.state == 1 && this.cleckSame(_loc2_))
            {
               this.curBuff.push(_loc2_);
               if(_loc2_.buffId != 4)
               {
                  _loc3_ = BattleScenceShow.getBuffEffect(_loc2_.buffId,1);
                  _loc3_.gotoAndStop(1);
                  this.buffNode.addChild(_loc3_);
                  if(_loc2_.buffId == 8)
                  {
                     this.shieldNode.visible = true;
                     this.shieldNode.gotoAndPlay(1);
                  }
               }
               else
               {
                  this.dizzNode.visible = true;
                  this.dizzNode.gotoAndPlay(1);
               }
            }
         }
         layoutHorizontal(this.buffNode);
      }
      
      private function isFirstBuff(param1:Array, param2:Object) : int
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.actionId == param2.targetId && _loc3_.skill_type == param2.buffId)
            {
               return 1;
            }
         }
         return 2;
      }
      
      private function cleckSame(param1:BuffVo) : Boolean
      {
         var _loc2_:BuffVo = null;
         for each(_loc2_ in this.curBuff)
         {
            if(_loc2_.targetId == param1.targetId && _loc2_.buffId == param1.buffId)
            {
               return false;
            }
         }
         return true;
      }
      
      private function getOrgMc(param1:String) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         return new _loc2_() as MovieClip;
      }
      
      private function initOrg(param1:int, param2:Number = 1) : void
      {
         var _loc3_:MovieClip = this.getOrgMc(ORG + param1 + NORMAL);
         var _loc4_:MovieClip = this.getOrgMc(ORG + param1 + ATTACK);
         if(_loc4_["hit"] != null)
         {
            this._attackPoint = new Point(_loc4_["hit"].x,_loc4_["hit"].y);
         }
         var _loc5_:MovieClip = this.getOrgMc(ORG + param1 + ATTACK_OVER);
         this._normal = this.getOrgCMovieClip(ORG + param1 + NORMAL,_loc3_["org"],this._loc,param2);
         this._normal.stop();
         this._attack = this.getOrgCMovieClip(ORG + param1 + ATTACK,_loc4_["org"],this._loc,param2);
         this._attack.stop();
         if(_loc5_ != null)
         {
            this._attack_over = this.getOrgCMovieClip(ORG + param1 + ATTACK_OVER,_loc5_["org"],this._loc,param2);
            this._attack_over.stop();
         }
         Battle.getBulletBlastCMovieClip(param1,0,param2);
         Battle.getBulletCMovieClip(param1,0,param2);
      }
      
      private function playEnd(param1:CMovieClipEvent) : void
      {
         var _loc2_:CMovieClip = param1.currentTarget as CMovieClip;
         _loc2_.visible = false;
         _loc2_.stop();
         _loc2_.removeEventListener(CMovieClipEvent.COMPLETE,this.playEnd);
         if(_loc2_.parent != null)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function playLight(param1:Event) : void
      {
         var _loc2_:CMovieClip = param1.currentTarget as CMovieClip;
         if(_loc2_.currentFrameIndex == 37)
         {
            _loc2_.gotoAndPlay(9);
         }
      }
      
      private function setGlowTween(param1:Organism) : void
      {
         var _loc4_:uint = 0;
         if(param1.getBlood() == OrganismManager.PLANT)
         {
            return;
         }
         var _loc2_:Number = 2;
         if(param1.getDifficulty() == 1)
         {
            _loc4_ = 13434777;
         }
         else if(param1.getDifficulty() == 2)
         {
            _loc4_ = 13158600;
         }
         else
         {
            _loc4_ = 16728642;
         }
         var _loc3_:GlowFilter = new GlowFilter(_loc4_,1,_loc2_,_loc2_,5,2);
         this._normal.filters = [_loc3_];
         this._attack.filters = [_loc3_];
         if(this._attack_over != null)
         {
            this._attack_over.filters = [_loc3_];
         }
      }
      
      private function setLightEffect(param1:Organism) : void
      {
         var _loc2_:CMovieClip = EffectManager.getQualityEffect(param1);
         if(_loc2_ != null)
         {
            addChild(_loc2_);
         }
      }
      
      public function destroy() : void
      {
         if(this._normal != null)
         {
            this._normal.destroy();
         }
         if(this._attack_over != null)
         {
            this._attack_over.destroy();
         }
         if(this._attack != null)
         {
            this._attack.destroy();
         }
         this._normal = null;
         this._attack = null;
         this._attack_over = null;
         this._backFunc = null;
         parent.removeChild(this);
         FuncKit.clearAllChildrens(this.buffNode);
         FuncKit.clearAllChildrens(this.exclusiveSkillsNode);
      }
   }
}


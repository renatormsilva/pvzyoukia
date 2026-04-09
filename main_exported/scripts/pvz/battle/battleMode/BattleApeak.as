package pvz.battle.battleMode
{
   import com.display.BitmapFrameInfo;
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   
   public class BattleApeak extends Battle
   {
      
      private var attack_org:BattleOrg;
      
      private var attackedOrg_arr:Array;
      
      private var background:MovieClip;
      
      private var is_allAttack:Boolean;
      
      private var m_attackedFunc:Function;
      
      private var m_campType:int;
      
      private var m_counter:int;
      
      private var m_counterBol:Boolean;
      
      private var m_leng:int;
      
      private var m_showSkill:Function;
      
      private var m_skills:Array;
      
      private var m_skillsed:Array;
      
      private var m_speed:int;
      
      public function BattleApeak()
      {
         super();
      }
      
      public function ApeakAttack(param1:MovieClip, param2:BattleOrg, param3:Array, param4:int, param5:Function, param6:Array, param7:Array, param8:Function, param9:int) : void
      {
         this.background = param1;
         this.attack_org = param2;
         this.attackedOrg_arr = param3;
         this.m_speed = param4;
         this.m_attackedFunc = param5;
         this.m_skills = param6;
         this.m_leng = this.attackedOrg_arr.length;
         this.m_skillsed = param7;
         this.m_showSkill = param8;
         this.m_campType = param9;
         param8(this.attack_org,param6);
         this.attack_org.doAttack(this.backFunc);
      }
      
      public function getApeakOrgAttackPoint(param1:BattleOrg) : Point
      {
         var _loc2_:Point = new Point();
         _loc2_.x = param1.x + param1.getAttackPoint().x;
         _loc2_.y = param1.y + param1.getAttackPoint().y;
         return _loc2_;
      }
      
      private function backFunc() : void
      {
         var _loc1_:AttackedOrg = null;
         this.is_allAttack = getIsAllAttack(this.m_skills);
         for each(_loc1_ in this.attackedOrg_arr)
         {
            _loc1_.getBattleOrg().setGeiusEffect(_loc1_.getEgeniusSkill());
            _loc1_.getBattleOrg().setExclusiveSkillsEffect(_loc1_.getExclusiveSkills());
            this.backFunction(_loc1_);
         }
      }
      
      private function backFunction(param1:AttackedOrg) : void
      {
         var timesUp:int;
         var buffer:int;
         var timesDown:int;
         var commonAttackNum:String = null;
         var bulletMc:CMovieClip = null;
         var allHit:int = 0;
         var hit:int = 0;
         var attackTimer:CTimer = null;
         var upT:CTimer = null;
         var bufferT:CTimer = null;
         var downT:CTimer = null;
         var onUp:Function = null;
         var onUpOver:Function = null;
         var onBufferOver:Function = null;
         var onDown:Function = null;
         var onDownOver:Function = null;
         var onAttacked:Function = null;
         var attackedOrg:AttackedOrg = param1;
         onUp = function(param1:CTimerEvent):void
         {
            bulletMc.y -= m_speed;
         };
         onUpOver = function(param1:CTimerEvent):void
         {
            upT.removeEventListener(CTimerEvent.TIMER,onUp);
            upT.removeEventListener(CTimerEvent.TIMER_COMPLETE,onUpOver);
            upT.stop();
            upT = null;
            bufferT.start();
         };
         onBufferOver = function(param1:CTimerEvent):void
         {
            bufferT.removeEventListener(CTimerEvent.TIMER_COMPLETE,onBufferOver);
            bufferT.stop();
            bufferT = null;
            bulletMc.rotation = -180;
            var _loc2_:Point = getAttackedOrgStart(attackedOrg.getBattleOrg(),bulletMc,m_campType);
            bulletMc.x = _loc2_.x;
            bulletMc.y = _loc2_.y;
            downT.start();
         };
         onDown = function(param1:CTimerEvent):void
         {
            bulletMc.y += m_speed;
         };
         onDownOver = function(param1:CTimerEvent):void
         {
            var bulletBlastMc:CMovieClip = null;
            var onBlast:Function = null;
            var e:CTimerEvent = param1;
            onBlast = function(param1:CMovieClipEvent):void
            {
               bulletBlastMc.stop();
               bulletBlastMc.destroy();
               bulletBlastMc.removeEventListener(CMovieClipEvent.COMPLETE,onBlast);
               background.removeChild(bulletBlastMc);
            };
            downT.removeEventListener(CTimerEvent.TIMER,onDown);
            downT.removeEventListener(CTimerEvent.TIMER_COMPLETE,onDownOver);
            downT.stop();
            downT = null;
            attackTimer.start();
            bulletMc.visible = false;
            bulletBlastMc = getBulletBlastCMovieClip(attack_org.getOrg().getPicId(),m_campType,attack_org.getOrg().getSize());
            if(bulletBlastMc != null)
            {
               background.removeChild(bulletMc);
               bulletBlastMc.x = getOrgattackedPoint(attackedOrg.getBattleOrg(),m_campType).x;
               bulletBlastMc.y = getOrgattackedPoint(attackedOrg.getBattleOrg(),m_campType).y;
               background.addChild(bulletBlastMc);
               bulletBlastMc.addEventListener(CMovieClipEvent.COMPLETE,onBlast);
            }
            else
            {
               background.removeChild(bulletMc);
            }
         };
         onAttacked = function(param1:CTimerEvent):void
         {
            ++hit;
            if(hit >= allHit)
            {
               attackTimer.removeEventListener(CTimerEvent.TIMER,onAttacked);
               attackTimer.stop();
               attackTimer = null;
               attack_org.setExclusiveSkillsEffect(attack_org.getExclusiveSkillsData());
            }
            if(is_allAttack)
            {
               ++m_counter;
               if(m_counter == m_leng * allHit)
               {
                  m_counterBol = true;
               }
            }
            var _loc2_:BigInt = getAttackNum(commonAttackNum,allHit,hit);
            m_attackedFunc(attackedOrg,getAttEffectType(attack_org,m_skills),allHit,hit,m_campType,m_skillsed,attackedOrg.getFear(),_loc2_,m_counterBol,is_allAttack,false,attackedOrg.getDodge(),attack_org);
         };
         commonAttackNum = attackedOrg.getAttackNormal();
         bulletMc = getBulletCMovieClip(this.attack_org.getOrg().getPicId(),this.m_campType,this.attack_org.getOrg().getSize());
         allHit = getAttackTimes(this.attack_org.getOrg());
         hit = 0;
         attackTimer = new CTimer(150,allHit);
         attackTimer.addEventListener(CTimerEvent.TIMER,onAttacked);
         timesUp = int((this.getApeakOrgAttackPoint(this.attack_org).y + (bulletMc.getBitmapdateInfos().getBitmapFrames()[0] as BitmapFrameInfo).date.height * 1.5) / this.m_speed);
         buffer = 600;
         timesDown = int((attackedOrg.getBattleOrg().y / 2 - this.getAttackedOrgStart(attackedOrg.getBattleOrg(),bulletMc,this.m_campType).y / 2) / this.m_speed);
         upT = new CTimer(40,timesUp);
         upT.addEventListener(CTimerEvent.TIMER,onUp);
         upT.addEventListener(CTimerEvent.TIMER_COMPLETE,onUpOver);
         bufferT = new CTimer(buffer,1);
         bufferT.addEventListener(CTimerEvent.TIMER,onBufferOver);
         downT = new CTimer(40,timesDown);
         downT.addEventListener(CTimerEvent.TIMER,onDown);
         downT.addEventListener(CTimerEvent.TIMER_COMPLETE,onDownOver);
         upT.start();
         bulletMc.x = this.getApeakOrgAttackPoint(this.attack_org).x;
         bulletMc.y = this.getApeakOrgAttackPoint(this.attack_org).y;
         this.background.addChildAt(bulletMc,this.background.numChildren);
      }
      
      private function getAttackedOrgStart(param1:BattleOrg, param2:CMovieClip, param3:int) : Point
      {
         var _loc4_:Point = new Point();
         if(param2 == null)
         {
            return _loc4_;
         }
         _loc4_.y = 0;
         _loc4_.x = param1.x;
         return _loc4_;
      }
      
      private function getOrgattackedPoint(param1:BattleOrg, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param1.x;
         _loc3_.y = param1.y - BattleMapManager.HEIGHT_GRID / 2;
         return _loc3_;
      }
   }
}


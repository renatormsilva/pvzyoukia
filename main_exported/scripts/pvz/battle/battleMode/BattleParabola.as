package pvz.battle.battleMode
{
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   
   public class BattleParabola extends Battle
   {
      
      public static const F:Number = 0.0015;
      
      public static const G:Number = 45000;
      
      public static const MULTIPLE:int = 1000;
      
      private var backGround:DisplayObjectContainer;
      
      private var bulletArr:Array = [];
      
      private var judgeAttack:Boolean;
      
      private var m_allHit:int;
      
      private var m_attackOrg:BattleOrg;
      
      private var m_attackedArr:Array;
      
      private var m_attackedFuc:Function;
      
      private var m_attackedOrg:Object;
      
      private var m_campType:int;
      
      private var m_counter:int;
      
      private var m_counterBol:Boolean;
      
      private var m_leng:int;
      
      private var m_showSkillFuc:Function;
      
      private var m_skills:Array;
      
      private var m_skillsed:Array;
      
      public function BattleParabola()
      {
         super();
      }
      
      public function parabolaAttack(param1:DisplayObjectContainer, param2:BattleOrg, param3:Array, param4:Function, param5:Array, param6:Array, param7:Function, param8:int) : void
      {
         this.backGround = param1;
         this.m_attackOrg = param2;
         this.m_attackedArr = param3;
         this.m_leng = param3.length;
         this.m_attackedFuc = param4;
         this.m_skills = param5;
         this.m_skillsed = param6;
         this.m_showSkillFuc = param7;
         this.m_campType = param8;
         param7(this.m_attackOrg,param5);
         param2.doAttack(this.backFunction);
      }
      
      private function attacker(param1:AttackedOrg) : void
      {
         var commonAttackNum:String = null;
         var nowTimes:int = 0;
         var hit:int = 0;
         var attackTimer:CTimer = null;
         var vx_s:Number = NaN;
         var vy_s:Number = NaN;
         var bulletMc:CMovieClip = null;
         var rot:Number = NaN;
         var m_timer:CTimer = null;
         var onTimer:Function = null;
         var onComp:Function = null;
         var attackedOrg:AttackedOrg = param1;
         onTimer = function(param1:CTimerEvent):void
         {
            var _loc2_:Number = vy_s + G / (100 * 100) * nowTimes;
            rot = Math.atan(_loc2_ / vx_s) / Math.PI * 180;
            bulletMc.rotation = rot;
            ++nowTimes;
            bulletMc.x = getOrgAttackPoint(m_attackOrg,m_campType).x + vx_s * nowTimes;
            bulletMc.y = getOrgAttackPoint(m_attackOrg,m_campType).y + (2 * vy_s + G / (100 * 100) * nowTimes) * nowTimes / 2;
         };
         onComp = function(param1:CTimerEvent):void
         {
            var bulletBlastMc:CMovieClip = null;
            var onBlast:Function = null;
            var onAttacked:Function = null;
            var e:CTimerEvent = param1;
            onBlast = function(param1:CMovieClipEvent):void
            {
               bulletBlastMc.stop();
               bulletBlastMc.destroy();
               bulletBlastMc.removeEventListener(CMovieClipEvent.COMPLETE,onBlast);
               backGround.removeChild(bulletBlastMc);
            };
            onAttacked = function(param1:CTimerEvent):void
            {
               ++hit;
               if(hit >= m_allHit)
               {
                  attackTimer.removeEventListener(CTimerEvent.TIMER,onAttacked);
                  attackTimer.stop();
                  attackTimer = null;
                  m_attackOrg.setExclusiveSkillsEffect(m_attackOrg.getExclusiveSkillsData());
               }
               if(judgeAttack)
               {
                  ++m_counter;
                  if(m_counter == m_leng * m_allHit)
                  {
                     m_counterBol = true;
                  }
               }
               var _loc2_:BigInt = getAttackNum(commonAttackNum,m_allHit,hit);
               m_attackedFuc(attackedOrg,getAttEffectType(attackedOrg.getBattleOrg(),m_skills),m_allHit,hit,m_campType,m_skillsed,attackedOrg.getFear(),_loc2_,m_counterBol,judgeAttack,false,attackedOrg.getDodge(),m_attackOrg);
            };
            m_timer.removeEventListener(CTimerEvent.TIMER,onTimer);
            m_timer.removeEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
            m_timer.stop();
            m_timer = null;
            bulletMc.visible = false;
            bulletBlastMc = getBulletBlastCMovieClip(m_attackOrg.getOrg().getPicId(),m_campType,m_attackOrg.getOrg().getSize());
            if(bulletBlastMc != null)
            {
               bulletBlastMc.x = bulletMc.x;
               bulletBlastMc.y = bulletMc.y;
               bulletBlastMc.rotation = bulletMc.rotation;
               backGround.removeChild(bulletMc);
               backGround.addChild(bulletBlastMc);
               bulletBlastMc.addEventListener(CMovieClipEvent.COMPLETE,onBlast);
            }
            else
            {
               backGround.removeChild(bulletMc);
            }
            if(m_attackedFuc != null)
            {
               attackTimer.addEventListener(CTimerEvent.TIMER,onAttacked);
               attackTimer.start();
            }
         };
         commonAttackNum = attackedOrg.getAttackNormal();
         nowTimes = 0;
         hit = 0;
         attackTimer = new CTimer(150,this.m_allHit);
         var times:int = this.getTimeParabola(getOrgAttackPoint(this.m_attackOrg,this.m_campType),this.getOrgattackedPoint(attackedOrg.getBattleOrg(),this.m_campType));
         var disX:Number = this.getOrgattackedPoint(attackedOrg.getBattleOrg(),this.m_campType).x - getOrgAttackPoint(this.m_attackOrg,this.m_campType).x;
         var disY:Number = this.getOrgattackedPoint(attackedOrg.getBattleOrg(),this.m_campType).y - getOrgAttackPoint(this.m_attackOrg,this.m_campType).y;
         vx_s = disX / times;
         vy_s = (disY - G / (100 * 100) * times * times / 2) / times;
         bulletMc = getBulletCMovieClip(this.m_attackOrg.getOrg().getPicId(),this.m_campType,this.m_attackOrg.getOrg().getSize());
         rot = Math.atan(vy_s / vx_s) / Math.PI * 180;
         bulletMc.rotation = rot;
         bulletMc.x = getOrgAttackPoint(this.m_attackOrg,this.m_campType).x;
         bulletMc.y = getOrgAttackPoint(this.m_attackOrg,this.m_campType).y;
         this.backGround.addChild(bulletMc);
         m_timer = new CTimer(40,times);
         m_timer.addEventListener(CTimerEvent.TIMER,onTimer);
         m_timer.addEventListener(CTimerEvent.TIMER_COMPLETE,onComp);
         m_timer.start();
      }
      
      private function backFunction() : void
      {
         var _loc1_:AttackedOrg = null;
         this.m_allHit = getAttackTimes(this.m_attackOrg.getOrg());
         this.judgeAttack = getIsAllAttack(this.m_skills);
         for each(_loc1_ in this.m_attackedArr)
         {
            _loc1_.getBattleOrg().setGeiusEffect(_loc1_.getEgeniusSkill());
            _loc1_.getBattleOrg().setExclusiveSkillsEffect(_loc1_.getExclusiveSkills());
            this.attacker(_loc1_);
         }
      }
      
      private function getOrgattackedPoint(param1:BattleOrg, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param1.x;
         _loc3_.y = param1.y - BattleMapManager.HEIGHT_GRID / 2;
         return _loc3_;
      }
      
      private function getTimeParabola(param1:Point, param2:Point) : int
      {
         return int(Math.sqrt(Math.pow(param1.x * MULTIPLE - param2.x * MULTIPLE,2) + Math.pow(param1.y * MULTIPLE - param2.y * MULTIPLE,2)) * F / MULTIPLE * 100 / 4);
      }
   }
}


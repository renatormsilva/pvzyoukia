package pvz.battle.battleMode
{
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import com.motion.ChangeManager;
   import com.motion.change.move.UniLineMoveChange;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   
   public class BattleLine extends Battle
   {
      
      private var judgeAttack:Boolean;
      
      private var leng:int;
      
      private var m_attackOrg:BattleOrg;
      
      private var m_attackedArr:Array;
      
      private var m_attackedFuc:Function;
      
      private var m_backGround:DisplayObjectContainer;
      
      private var m_campType:int;
      
      private var m_cm:ChangeManager;
      
      private var m_counter:int;
      
      private var m_counterBol:Boolean;
      
      private var m_pointA:Point;
      
      private var m_showSkill:Function;
      
      private var m_skilled:Array;
      
      private var m_skills:Array;
      
      private var m_speed:int;
      
      private var m_startX:int;
      
      private var m_startY:int;
      
      private var m_times:int;
      
      public function BattleLine()
      {
         super();
      }
      
      public function blast(param1:CMovieClip, param2:int, param3:int) : void
      {
         var onBlast:Function = null;
         var bulletBlastMc:CMovieClip = param1;
         var x:int = param2;
         var y:int = param3;
         onBlast = function(param1:CMovieClipEvent):void
         {
            bulletBlastMc.visible = false;
            bulletBlastMc.stop();
            bulletBlastMc.removeEventListener(CMovieClipEvent.COMPLETE,onBlast);
            m_backGround.removeChild(bulletBlastMc);
         };
         if(bulletBlastMc == null)
         {
            return;
         }
         bulletBlastMc.x = x;
         bulletBlastMc.y = y;
         this.m_backGround.addChildAt(bulletBlastMc,this.m_backGround.numChildren);
         bulletBlastMc.gotoAndPlay(1);
         bulletBlastMc.addEventListener(CMovieClipEvent.COMPLETE,onBlast);
      }
      
      public function lineAttack(param1:DisplayObjectContainer, param2:BattleOrg, param3:Array, param4:int, param5:Function, param6:Array, param7:Array, param8:Function, param9:int, param10:ChangeManager) : void
      {
         this.m_backGround = param1;
         this.m_attackOrg = param2;
         this.m_attackedArr = param3;
         this.m_speed = param4;
         this.m_attackedFuc = param5;
         this.m_skills = param6;
         this.m_skilled = param7;
         this.m_showSkill = param8;
         this.m_campType = param9;
         this.m_cm = param10;
         this.m_backGround = param1;
         param8(param2,param6);
         param2.doAttack(this.battleBegin);
      }
      
      private function battle(param1:AttackedOrg) : void
      {
         var hit:int = 0;
         var commonAttackNum:String = null;
         var num_timer:CTimer = null;
         var onAttack:Function = null;
         var onAttackComp:Function = null;
         var attackedOrg:AttackedOrg = param1;
         onAttack = function(param1:CTimerEvent):void
         {
            var bulletMc:CMovieClip = null;
            var onComp:Function = null;
            var e:CTimerEvent = param1;
            onComp = function():void
            {
               var _loc2_:BigInt = null;
               ++hit;
               var _loc1_:CMovieClip = getBulletBlastCMovieClip(m_attackOrg.getOrg().getPicId(),m_campType,m_attackOrg.getOrg().getSize());
               blast(_loc1_,bulletMc.x,bulletMc.y);
               bulletMc.destroy();
               m_backGround.removeChild(bulletMc);
               if(m_attackedFuc != null)
               {
                  if(judgeAttack)
                  {
                     ++m_counter;
                     if(m_counter == leng * m_times)
                     {
                        m_counterBol = true;
                     }
                  }
                  _loc2_ = getAttackNum(commonAttackNum,m_times,hit);
                  m_attackedFuc(attackedOrg,getAttEffectType(m_attackOrg,m_skills),hit,m_times,m_campType,m_skilled,attackedOrg.getFear(),_loc2_,m_counterBol,judgeAttack,false,attackedOrg.getDodge(),m_attackOrg);
                  if(hit >= m_times)
                  {
                     attackedOrg.getBattleOrg().setExclusiveSkillsEffect(attackedOrg.getExclusiveSkills());
                  }
               }
            };
            bulletMc = getBulletCMovieClip(m_attackOrg.getOrg().getPicId(),m_campType,m_attackOrg.getOrg().getSize());
            var p2:Point = getOrgattackedPoint(m_attackOrg,attackedOrg.getBattleOrg(),m_campType);
            var endX:int = p2.x;
            var endY:int = p2.y;
            var angle:Number = Math.atan2(endY - m_startY,endX - m_startX) * 180 / Math.PI;
            angle += m_campType * 180;
            bulletMc.rotation = angle;
            bulletMc.x = m_startX;
            bulletMc.y = m_startY;
            m_backGround.addChildAt(bulletMc,m_backGround.numChildren);
            m_cm.add(new UniLineMoveChange(bulletMc,endX,endY,0.4,onComp));
         };
         onAttackComp = function(param1:CTimerEvent):void
         {
            num_timer.removeEventListener(CTimerEvent.TIMER,onAttack);
            num_timer.removeEventListener(CTimerEvent.TIMER_COMPLETE,onAttackComp);
            num_timer.stop();
            num_timer = null;
            m_attackOrg.setExclusiveSkillsEffect(m_attackOrg.getExclusiveSkillsData());
         };
         this.m_times = getAttackTimes(this.m_attackOrg.getOrg());
         this.m_pointA = getOrgAttackPoint(this.m_attackOrg,this.m_campType);
         this.m_startX = this.m_pointA.x;
         this.m_startY = this.m_pointA.y;
         hit = 0;
         commonAttackNum = attackedOrg.getAttackNormal();
         num_timer = new CTimer(225,this.m_times);
         num_timer.addEventListener(CTimerEvent.TIMER,onAttack);
         num_timer.addEventListener(CTimerEvent.TIMER_COMPLETE,onAttackComp);
         num_timer.start();
      }
      
      private function battleBegin() : void
      {
         var _loc1_:AttackedOrg = null;
         this.leng = this.m_attackedArr.length;
         this.judgeAttack = getIsAllAttack(this.m_skills);
         for each(_loc1_ in this.m_attackedArr)
         {
            _loc1_.getBattleOrg().setGeiusEffect(_loc1_.getEgeniusSkill());
            this.battle(_loc1_);
         }
      }
      
      private function getOrgattackedPoint(param1:BattleOrg, param2:BattleOrg, param3:int) : Point
      {
         var _loc4_:Number = param1.getAttackPoint().y / param1.getOrgNormalHeight();
         var _loc5_:Point = new Point();
         _loc5_.x = param2.x;
         _loc5_.y = param2.y + BattleMapManager.HEIGHT_GRID * _loc4_;
         return _loc5_;
      }
   }
}


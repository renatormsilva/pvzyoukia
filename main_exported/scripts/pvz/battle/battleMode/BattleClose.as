package pvz.battle.battleMode
{
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   
   public class BattleClose extends Battle
   {
      
      private static const HIT_POINT_X:int = 380;
      
      private static const HIT_POINT_Y:int = 200;
      
      private var isAllHit:Boolean;
      
      private var judgeAttack:Boolean;
      
      private var m_counter:int;
      
      private var m_counterBol:Boolean;
      
      private var m_leng:int;
      
      public function BattleClose()
      {
         super();
      }
      
      public function closeAttack(param1:BattleOrg, param2:Array, param3:DisplayObject, param4:Array, param5:Array, param6:Function, param7:Function, param8:int) : void
      {
         var baseX:int = 0;
         var baseY:int = 0;
         var basebloodX:int = 0;
         var basebloodY:int = 0;
         var baseIndex:int = 0;
         var backFunction:Function = null;
         var attackedO:AttackedOrg = null;
         var centerPoint:Point = null;
         var endX:int = 0;
         var endY:int = 0;
         var t:CTimer = null;
         var startAttacker:Function = null;
         var attackedOrg:AttackedOrg = null;
         var commonAttackNum:String = null;
         var att_rotation:Number = NaN;
         var end_X:int = 0;
         var end_Y:int = 0;
         var t_single:CTimer = null;
         var startAttack:Function = null;
         var g:BattleOrg = param1;
         var attackedArr:Array = param2;
         var blood:DisplayObject = param3;
         var skills:Array = param4;
         var skillsed:Array = param5;
         var showSkill:Function = param6;
         var showblood:Function = param7;
         var campType:int = param8;
         backFunction = function():void
         {
            g.x = baseX;
            g.y = baseY;
            blood.x = basebloodX;
            blood.y = basebloodY;
            if(g.parent != null)
            {
               g.parent.setChildIndex(g,baseIndex);
            }
            g.setExclusiveSkillsEffect(g.getExclusiveSkillsData());
         };
         var attacked:Function = function(param1:AttackedOrg, param2:int, param3:int, param4:Array, param5:Boolean = false, param6:String = ""):void
         {
            var ii:int = 0;
            var onShow:Function = null;
            var org:AttackedOrg = param1;
            var times:int = param2;
            var attackEffect:int = param3;
            var skillsed:Array = param4;
            var isAll:Boolean = param5;
            var attackNum:String = param6;
            onShow = function(param1:CTimerEvent):void
            {
               var _loc2_:BigInt = null;
               var _loc3_:BigInt = null;
               ++ii;
               if(isAll)
               {
                  if(ii == times)
                  {
                     ++m_counter;
                     if(m_counter == m_leng)
                     {
                        m_counterBol = true;
                        m_counter = 0;
                     }
                     else
                     {
                        m_counterBol = false;
                     }
                     _loc2_ = getAttackNum(attackNum,1,1);
                     showblood(org,attackEffect,1,times,campType,skillsed,org.getFear(),_loc2_,m_counterBol,isAllHit,isAll,org.getDodge(),g);
                  }
               }
               else
               {
                  _loc3_ = getAttackNum(attackNum,times,ii);
                  showblood(org,attackEffect,ii,times,campType,skillsed,org.getFear(),_loc3_,m_counterBol,isAllHit,isAll,org.getDodge(),g);
               }
            };
            var tt:CTimer = new CTimer(150,times);
            tt.addEventListener(CTimerEvent.TIMER,onShow);
            tt.start();
            ii = 0;
         };
         baseX = g.x;
         baseY = g.y;
         basebloodX = blood.x;
         basebloodY = blood.y;
         baseIndex = g.parent.getChildIndex(g);
         this.m_leng = attackedArr.length;
         g.clearDizzNodeEffect();
         g.parent.setChildIndex(g,g.parent.numChildren - 1);
         this.judgeAttack = getIsAllAttack(skills);
         if(this.judgeAttack)
         {
            startAttacker = function(param1:CTimerEvent):void
            {
               var _loc2_:AttackedOrg = null;
               var _loc3_:String = null;
               t.removeEventListener(CTimerEvent.TIMER_COMPLETE,startAttacker);
               t.stop();
               t = null;
               (g as BattleOrg).doAttackClose(backFunction);
               for each(_loc2_ in attackedArr)
               {
                  _loc3_ = _loc2_.getAttackNormal();
                  attacked(_loc2_,getAttackTimes((g as BattleOrg).getOrg()),getAttEffectType(g,skills),skillsed,true,_loc3_);
               }
            };
            for each(attackedO in attackedArr)
            {
               attackedO.getBattleOrg().setGeiusEffect(attackedO.getEgeniusSkill());
               attackedO.getBattleOrg().setExclusiveSkillsEffect(attackedO.getExclusiveSkills());
            }
            this.isAllHit = true;
            centerPoint = new Point(HIT_POINT_X,HIT_POINT_Y);
            endX = centerPoint.x;
            endY = centerPoint.y;
            g.y = endY;
            g.x = endX;
            blood.x = g.x - blood.width / 2;
            blood.y = g.y;
            showSkill(g,skills);
            t = new CTimer(200,1);
            t.addEventListener(CTimerEvent.TIMER_COMPLETE,startAttacker);
            t.start();
         }
         else
         {
            for each(attackedOrg in attackedArr)
            {
               startAttack = function(param1:CTimerEvent):void
               {
                  t_single.removeEventListener(CTimerEvent.TIMER_COMPLETE,startAttack);
                  t_single.stop();
                  t_single = null;
                  (g as BattleOrg).doAttackClose(backFunction);
                  attacked(attackedOrg,getAttackTimes((g as BattleOrg).getOrg()),getAttEffectType(g,skills),skillsed,false,commonAttackNum);
               };
               attackedOrg.getBattleOrg().setGeiusEffect(attackedOrg.getEgeniusSkill());
               attackedOrg.getBattleOrg().setExclusiveSkillsEffect(attackedOrg.getExclusiveSkills());
               commonAttackNum = attackedOrg.getAttackNormal();
               att_rotation = -1;
               if(g.x > attackedOrg.getBattleOrg().x)
               {
                  att_rotation = 1;
               }
               end_X = 0;
               end_Y = 0;
               end_X = attackedOrg.getBattleOrg().x + att_rotation * BattleMapManager.WIDE_GRID;
               end_Y = attackedOrg.getBattleOrg().y;
               g.x = end_X;
               g.y = end_Y;
               blood.x = g.x + -blood.width / 2;
               blood.y = g.y;
               showSkill(g,skills);
               t_single = new CTimer(200,1);
               t_single.addEventListener(CTimerEvent.TIMER_COMPLETE,startAttack);
               t_single.start();
            }
         }
      }
   }
}


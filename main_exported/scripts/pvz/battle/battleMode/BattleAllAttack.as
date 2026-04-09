package pvz.battle.battleMode
{
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import pvz.battle.entity.AttackedOrg;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   
   public class BattleAllAttack extends Battle
   {
      
      public function BattleAllAttack()
      {
         super();
      }
      
      public function allAttack(param1:BattleOrg, param2:Array, param3:Array, param4:Array, param5:int, param6:Function, param7:Function) : void
      {
         var attackedOrg:AttackedOrg = null;
         var time:CTimer = null;
         var times:int = 0;
         var hit:int = 0;
         var m_counter:int = 0;
         var islastCount:Boolean = false;
         var attackedLength:int = 0;
         var startAttacker:Function = null;
         var doWithBulletEffect:Function = null;
         var attackOrg:BattleOrg = param1;
         var attackedArr:Array = param2;
         var skills:Array = param3;
         var skilled:Array = param4;
         var campType:int = param5;
         var showSkill:Function = param6;
         var attacked:Function = param7;
         startAttacker = function(param1:CTimerEvent):void
         {
            time.removeEventListener(CTimerEvent.TIMER_COMPLETE,startAttacker);
            time.stop();
            time = null;
            showSkill(attackOrg,skills);
            (attackOrg as BattleOrg).doAttackClose(doWithBulletEffect);
            attackOrg.setExclusiveSkillsEffect(attackOrg.getExclusiveSkillsData());
         };
         doWithBulletEffect = function():void
         {
            var _loc1_:int = 0;
            while(_loc1_ < attackedLength)
            {
               doWithAttackMode(attackedArr[_loc1_]);
               _loc1_++;
            }
         };
         var doWithAttackMode:Function = function(param1:AttackedOrg):void
         {
            var _loc2_:String = param1.getAttackNormal();
            ++m_counter;
            if(m_counter == attackedLength * times)
            {
               islastCount = true;
            }
            var _loc3_:BigInt = getAttackNum(_loc2_,times,hit);
            param1.getBattleOrg().setExclusiveSkillsEffect(param1.getExclusiveSkills());
            attacked(param1,getAttEffectType(attackOrg,skills),hit,times,campType,skilled,param1.getFear(),_loc3_,true,islastCount,false,param1.getDodge(),attackOrg);
         };
         for each(attackedOrg in attackedArr)
         {
            attackedOrg.getBattleOrg().setGeiusEffect(attackedOrg.getEgeniusSkill());
         }
         time = new CTimer(200,1);
         times = getAttackTimes(attackOrg.getOrg());
         hit = 1;
         islastCount = false;
         attackedLength = int(attackedArr.length);
         attackOrg.clearDizzNodeEffect();
         attackOrg.parent.setChildIndex(attackOrg,attackOrg.parent.numChildren - 1);
         time.addEventListener(CTimerEvent.TIMER_COMPLETE,startAttacker);
         time.start();
      }
   }
}


package manager
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import utils.GetDomainRes;
   
   public class TeachHelpManager
   {
      
      private static var _I:TeachHelpManager;
      
      public static const TASK_TYPE_STORAGE:int = 1;
      
      public static const TASK_TYPE_COMPONSE:int = 2;
      
      public static const TASK_TYPE_POSSESSION:int = 3;
      
      public static const TASK_TYPE_ARENA:int = 4;
      
      public static const TASK_TYPE_GAREN:int = 5;
      
      public static const TASK_TYPE_FUBEN:int = 6;
      
      public static const TASK_TYPE_TREE:int = 7;
      
      public static const TASK_TYPE_DRAK:int = 8;
      
      public static const TASK_TYPE_PUBLIC:int = 9;
      
      public static const TASK_TYPE_PERSONAL:int = 10;
      
      public static const ARROW_UP:int = 1;
      
      public static const ARROW_DOWN:int = 2;
      
      public static const ARROW_LEFT:int = 3;
      
      public static const ARROW_RIGHT:int = 4;
      
      private var _arrow:MovieClip;
      
      private var _tipsArrow:MovieClip;
      
      private const LOCATION_AND_DIRECTION:Array = [[610,90,ARROW_UP],[692,90,ARROW_UP],[520,370,ARROW_DOWN],[598,370,ARROW_DOWN],[680,370,ARROW_DOWN],[90,462,ARROW_LEFT],[60,285,ARROW_LEFT],[165,206,ARROW_RIGHT],[165,285,ARROW_RIGHT],[165,375,ARROW_RIGHT]];
      
      public function TeachHelpManager(param1:privateClass)
      {
         super();
         this._arrow = GetDomainRes.getMoveClip("taskHelpArrow");
         this._tipsArrow = GetDomainRes.getMoveClip("tipsArrow");
      }
      
      public static function get I() : TeachHelpManager
      {
         if(_I == null)
         {
            _I = new TeachHelpManager(new privateClass());
         }
         return _I;
      }
      
      public function showArrowByTaskType(param1:int) : void
      {
         if(param1 <= 0 || param1 > this.LOCATION_AND_DIRECTION.length)
         {
            return;
         }
         var _loc2_:Array = this.LOCATION_AND_DIRECTION[param1 - 1] as Array;
         PlantsVsZombies._node.addChildAt(this._arrow,PlantsVsZombies._node.numChildren - 2);
         this._arrow.x = _loc2_[0];
         this._arrow.y = _loc2_[1];
         this._arrow.gotoAndStop(_loc2_[2]);
      }
      
      public function hideArrow() : void
      {
         if(PlantsVsZombies._node.contains(this._arrow))
         {
            PlantsVsZombies._node.removeChild(this._arrow);
         }
         if(PlantsVsZombies._node.contains(this._tipsArrow))
         {
            PlantsVsZombies._node.removeChild(this._tipsArrow);
         }
      }
      
      public function showArrowAtBattleReadyWindow(param1:DisplayObject = null, param2:int = 3) : void
      {
         PlantsVsZombies._node.addChild(this._tipsArrow);
         this._tipsArrow.x = param1.x + 150;
         this._tipsArrow.y = param1.y + 60;
         this._tipsArrow.gotoAndStop(param2);
      }
   }
}

class privateClass
{
   
   public function privateClass()
   {
      super();
   }
}

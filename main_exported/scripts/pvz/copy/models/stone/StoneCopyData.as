package pvz.copy.models.stone
{
   public class StoneCopyData
   {
      
      private static var currentCp:StoneGateData;
      
      private static var challageTimes:int;
      
      public function StoneCopyData()
      {
         super();
      }
      
      public static function setCurrentaCp(param1:StoneGateData) : void
      {
         currentCp = param1;
      }
      
      public static function getCurrentCp() : StoneGateData
      {
         return currentCp;
      }
      
      public static function setChallageTimes(param1:int) : void
      {
         challageTimes = param1;
      }
      
      public static function getChallageTimes() : int
      {
         return challageTimes;
      }
      
      public static function getEmamysByCurrentStarLevel(param1:int) : Array
      {
         if(param1 == 1 || param1 == 0)
         {
            return currentCp.getNormalZombies();
         }
         if(param1 == 2)
         {
            return currentCp.getMiddleZombies();
         }
         if(param1 == 3)
         {
            return currentCp.getHardZombies();
         }
         return null;
      }
   }
}


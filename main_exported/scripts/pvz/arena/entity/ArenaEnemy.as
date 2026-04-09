package pvz.arena.entity
{
   public class ArenaEnemy
   {
      
      internal var arenaRank:int = 0;
      
      internal var nickname:String = "";
      
      internal var orgs:Array = null;
      
      internal var userId:Number = 0;
      
      internal var platform_user_id:int = 0;
      
      internal var grade:int = 0;
      
      internal var faceUrl:String = "";
      
      internal var viplevel:int = 0;
      
      internal var viptime:int = 0;
      
      public function ArenaEnemy()
      {
         super();
      }
      
      public function setVipLevel(param1:int) : void
      {
         this.viplevel = param1;
      }
      
      public function getVipLevel() : int
      {
         return this.viplevel;
      }
      
      public function setVipTime(param1:int) : void
      {
         this.viptime = param1;
      }
      
      public function getVipTime() : int
      {
         return this.viptime;
      }
      
      public function getFaceUrl() : String
      {
         return this.faceUrl;
      }
      
      public function setFaceUrl(param1:String) : void
      {
         this.faceUrl = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this.grade = param1;
      }
      
      public function getGrade() : int
      {
         return this.grade;
      }
      
      public function setPlatformUserId(param1:int) : void
      {
         this.platform_user_id = param1;
      }
      
      public function getPlatformUserId() : int
      {
         return this.platform_user_id;
      }
      
      public function getArenaOrgs() : Array
      {
         return this.orgs;
      }
      
      public function getArenaRank() : int
      {
         return this.arenaRank;
      }
      
      public function getNickName() : String
      {
         return this.nickname;
      }
      
      public function getUserId() : Number
      {
         return this.userId;
      }
      
      public function setArenaOrgs(param1:Array) : void
      {
         this.orgs = param1;
      }
      
      public function setArenaRank(param1:int) : void
      {
         this.arenaRank = param1;
      }
      
      public function setNickName(param1:String) : void
      {
         this.nickname = param1;
      }
      
      public function setUserId(param1:Number) : void
      {
         this.userId = param1;
      }
   }
}


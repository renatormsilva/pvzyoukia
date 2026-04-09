package entity
{
   public class FriendPrizeInfo
   {
      
      internal var big_face:String = "";
      
      internal var grade:int = 0;
      
      internal var id:int = 0;
      
      internal var nickname:String = "";
      
      internal var small_face:String = "";
      
      internal var viplevel:int = 0;
      
      internal var vipTime:int = 0;
      
      internal var starts:int = 0;
      
      public function FriendPrizeInfo()
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
         this.vipTime = param1;
      }
      
      public function getVipTime() : int
      {
         return this.vipTime;
      }
      
      public function getBigFace() : String
      {
         return this.big_face;
      }
      
      public function getGrade() : int
      {
         return this.grade;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getNickName() : String
      {
         return this.nickname;
      }
      
      public function getSmallFace() : String
      {
         return this.small_face;
      }
      
      public function getStarts() : int
      {
         return this.starts;
      }
      
      public function setBigFace(param1:String) : void
      {
         this.big_face = param1;
      }
      
      public function setGrade(param1:int) : void
      {
         this.grade = param1;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function setNickName(param1:String) : void
      {
         this.nickname = param1;
      }
      
      public function setSmallFace(param1:String) : void
      {
         this.small_face = param1;
      }
      
      public function setStarts(param1:int) : void
      {
         this.starts = param1;
      }
   }
}


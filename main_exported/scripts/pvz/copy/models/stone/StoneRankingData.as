package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   
   public class StoneRankingData implements IVo
   {
      
      protected var _face_url:String;
      
      protected var _nickname:String;
      
      protected var _vip_end_time:int;
      
      protected var _vip_grade:int;
      
      private var _star_num:int;
      
      private var _rank:int = 1;
      
      public function StoneRankingData()
      {
         super();
      }
      
      public function getStarNum() : int
      {
         return this._star_num;
      }
      
      public function getRank() : int
      {
         return this._rank;
      }
      
      public function getFaceURL() : String
      {
         return this._face_url;
      }
      
      public function getNickName() : String
      {
         return this._nickname;
      }
      
      public function getVipGrade() : int
      {
         return this._vip_grade;
      }
      
      public function getVipTime() : int
      {
         return this._vip_end_time;
      }
      
      public function decode(param1:Object) : void
      {
         this._face_url = param1.face;
         this._nickname = param1.nickname;
         this._vip_end_time = param1.vip_etime;
         this._vip_grade = param1.vip_grade;
         this._star_num = param1.star;
         this._rank = param1.order;
      }
   }
}


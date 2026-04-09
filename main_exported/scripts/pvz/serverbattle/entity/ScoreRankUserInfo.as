package pvz.serverbattle.entity
{
   public class ScoreRankUserInfo extends User
   {
      
      private var _score:int;
      
      private var _rank:int;
      
      public function ScoreRankUserInfo()
      {
         super();
      }
      
      override public function decodeData(param1:Object) : void
      {
         this._face_url = param1.face_url;
         this._score = param1.integral;
         this._new_id = param1.new_id;
         this._nickname = param1.nickname;
         this._rank = param1.rank;
         this._server_name = param1.server_name;
         this._vip_end_time = param1.vip_etime;
         this._vip_grade = param1.vip_grade;
      }
      
      public function getScore() : int
      {
         return this._score;
      }
      
      public function getRank() : int
      {
         return this._rank;
      }
   }
}


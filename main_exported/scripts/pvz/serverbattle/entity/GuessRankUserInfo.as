package pvz.serverbattle.entity
{
   public class GuessRankUserInfo extends User
   {
      
      private var _box:int;
      
      private var _rank:int;
      
      public function GuessRankUserInfo()
      {
         super();
      }
      
      override public function decodeData(param1:Object) : void
      {
         this._face_url = param1.face_url;
         this._box = param1.amount;
         this._new_id = param1.new_id;
         this._nickname = param1.nickname;
         this._rank = param1.rank;
         this._server_name = param1.server_name;
         this._vip_end_time = param1.vip_etime;
         this._vip_grade = param1.vip_grade;
      }
      
      public function getBox() : int
      {
         return this._box;
      }
      
      public function getRank() : int
      {
         return this._rank;
      }
   }
}


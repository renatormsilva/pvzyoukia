package pvz.serverbattle.entity
{
   public class User
   {
      
      protected var _face_url:String;
      
      protected var _grade:int;
      
      protected var _new_id:int;
      
      protected var _nickname:String;
      
      protected var _server_name:String;
      
      protected var _vip_end_time:int;
      
      protected var _vip_grade:int;
      
      public function User()
      {
         super();
      }
      
      public function decodeData(param1:Object) : void
      {
         this._face_url = param1.face_url;
         this._grade = param1.grade;
         this._new_id = param1.new_id;
         this._nickname = param1.nickname;
         this._server_name = param1.serverName;
         this._vip_end_time = param1.vip_etime;
         this._vip_grade = param1.vip_grade;
      }
      
      public function getFaceURL() : String
      {
         return this._face_url;
      }
      
      public function getGrade() : int
      {
         return this._grade;
      }
      
      public function getNewId() : int
      {
         return this._new_id;
      }
      
      public function getNickName() : String
      {
         return this._nickname;
      }
      
      public function getSeverName() : String
      {
         return this._server_name;
      }
      
      public function getVipEtime() : int
      {
         return this._vip_end_time;
      }
      
      public function getVIPGrade() : int
      {
         return this._vip_grade;
      }
   }
}


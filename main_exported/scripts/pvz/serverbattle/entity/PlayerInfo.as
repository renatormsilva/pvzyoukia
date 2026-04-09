package pvz.serverbattle.entity
{
   public class PlayerInfo
   {
      
      public static const QUALITYING:String = "QUALITYING";
      
      public static const KNOCKOUT:String = "KNOCKOUT";
      
      private var _firstplayer:Contestant;
      
      private var _secondPlayer:Contestant;
      
      private var _type:String;
      
      private var _id:int;
      
      private var _cost4:int;
      
      private var _cost8:int;
      
      public function PlayerInfo()
      {
         super();
      }
      
      public function set prizeCost4(param1:int) : void
      {
         this._cost4 = param1;
      }
      
      public function get prizeCost4() : int
      {
         return this._cost4;
      }
      
      public function set prizeCost8(param1:int) : void
      {
         this._cost8 = param1;
      }
      
      public function get prizeCost8() : int
      {
         return this._cost8;
      }
      
      public function set prizeId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get prizeId() : int
      {
         return this._id;
      }
      
      public function set firstPlayer(param1:Contestant) : void
      {
         this._firstplayer = param1;
      }
      
      public function get firstPlayer() : Contestant
      {
         return this._firstplayer;
      }
      
      public function set secondPlayer(param1:Contestant) : void
      {
         this._secondPlayer = param1;
      }
      
      public function get secondPlayer() : Contestant
      {
         return this._secondPlayer;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}


package pvz.serverbattle.entity
{
   public class Guess
   {
      
      private var _id:int;
      
      private var _lucky:int;
      
      private var _my_guess:int;
      
      private var _type:int;
      
      private var _user1:User;
      
      private var _user2:User;
      
      private var _winner:int;
      
      private var _stage:int;
      
      private var _rewardId:int;
      
      private var _isGotten:int;
      
      public function Guess()
      {
         super();
      }
      
      public function decodeData(param1:Object) : void
      {
         this._id = param1.id;
         this._lucky = param1.lucky;
         this._my_guess = param1.my_guess;
         this._type = param1.type;
         this._user1 = new User();
         this._user2 = new User();
         this._user1.decodeData(param1.user_a);
         this._user2.decodeData(param1.user_b);
         this._winner = param1.winner;
         this._stage = param1.stage;
         this._rewardId = param1.reward;
         this._isGotten = param1.award;
      }
      
      public function getID() : int
      {
         return this._id;
      }
      
      public function getLucky() : int
      {
         return this._lucky;
      }
      
      public function getMyGuessId() : int
      {
         return this._my_guess;
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function getUser1() : User
      {
         return this._user1;
      }
      
      public function getUser2() : User
      {
         return this._user2;
      }
      
      public function getWinner() : int
      {
         return this._winner;
      }
      
      public function getStage() : int
      {
         return this._stage;
      }
      
      public function getRewardId() : int
      {
         return this._rewardId;
      }
      
      public function getIsGotten() : int
      {
         return this._isGotten;
      }
      
      public function setMyGuess(param1:int) : void
      {
         this._my_guess = param1;
      }
      
      public function setIsGotten(param1:int) : void
      {
         this._isGotten = param1;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
      }
   }
}


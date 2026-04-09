package pvz.shaketree.vo
{
   public class PassData
   {
      
      private var _passLevel:int;
      
      private var _zombies:Vector.<ZombiesVo>;
      
      private var _baojiOdds:Number;
      
      private var _baojiMult:int;
      
      private var _isPassLevel:int;
      
      private var _messages:Array;
      
      private var _passLevelPrizes:Array;
      
      private var _rate:uint;
      
      public function PassData()
      {
         super();
         this._zombies = new Vector.<ZombiesVo>();
      }
      
      public function setRate(param1:uint) : void
      {
         this._rate = param1;
      }
      
      public function getRete() : uint
      {
         return this._rate;
      }
      
      public function setPassLevelPrizes(param1:Array) : void
      {
         this._passLevelPrizes = param1;
      }
      
      public function getPassLevelPrize() : Array
      {
         return this._passLevelPrizes;
      }
      
      public function setMessage(param1:Array) : void
      {
         this._messages = param1;
      }
      
      public function getMessage() : Array
      {
         return this._messages;
      }
      
      public function addZomies(param1:ZombiesVo) : void
      {
         this._zombies.push(param1);
      }
      
      public function getZombies() : Vector.<ZombiesVo>
      {
         return this._zombies;
      }
      
      public function setPassLevel(param1:int) : void
      {
         this._passLevel = param1;
      }
      
      public function getPassLevel() : int
      {
         return this._passLevel;
      }
      
      public function setBaojiOdds(param1:Number) : void
      {
         this._baojiOdds = param1;
      }
      
      public function getBaojiOdds() : Number
      {
         return this._baojiOdds;
      }
      
      public function setBaojiMult(param1:Number) : void
      {
         this._baojiMult = param1;
      }
      
      public function getBaojiMult() : Number
      {
         return this._baojiMult;
      }
      
      public function setIsPassLevel(param1:int) : void
      {
         this._isPassLevel = param1;
      }
      
      public function getIsPassLevel() : Boolean
      {
         return this._isPassLevel > 0;
      }
      
      public function getZombiesVoByid(param1:int) : ZombiesVo
      {
         var _loc2_:ZombiesVo = null;
         for each(_loc2_ in this._zombies)
         {
            if(_loc2_.getId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}


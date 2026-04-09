package manager
{
   import entity.Organism;
   import entity.Player;
   import utils.FuncKit;
   import utils.Singleton;
   
   public class PlayerManager extends Singleton
   {
      
      public static const LOADING_RATE:Number = 0.4;
      
      public static const ARENA_NUM:int = 5;
      
      public static const ARENA_ORG_NUM:int = 10;
      
      private var player:Player;
      
      private var player_other:Player;
      
      public function PlayerManager()
      {
         super();
      }
      
      public function isVip(param1:int) : Object
      {
         var _loc5_:int = 0;
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         if(this.player == null)
         {
            return null;
         }
         var _loc4_:int = param1 - FuncKit.currentTimeMillis() * 0.001;
         if(_loc4_ < 0)
         {
            return null;
         }
         if(_loc4_ > 60 * 60 * 24)
         {
            _loc2_.type = 1;
            _loc2_.time = _loc4_ / (60 * 60 * 24);
         }
         else
         {
            _loc2_.type = 2;
            _loc5_ = _loc4_ / (60 * 60);
            if(_loc5_ < 1)
            {
               _loc5_ = 1;
            }
            _loc2_.time = _loc5_;
         }
         return _loc2_;
      }
      
      public function getFriendIndex(param1:Player) : int
      {
         if(this.player.getFriends() == null)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.player.getFriends().length)
         {
            if(param1 == this.player.getFriends()[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getFriendById(param1:Number) : Player
      {
         if(this.player.getFriends() == null)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.player.getFriends().length)
         {
            if(param1 == this.player.getFriends()[_loc2_].getId())
            {
               return this.player.getFriends()[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getFriendByIndex(param1:int) : Player
      {
         if(this.player.getFriends() == null || this.player.getFriends().length < 1 || this.player.getFriends().length < param1)
         {
            return null;
         }
         return this.player.getFriends()[param1];
      }
      
      public function addOrganism(param1:Organism) : void
      {
         if(this.player.organisms == null)
         {
            this.player.organisms = new Array();
         }
         this.player.organisms.push(param1);
      }
      
      public function isLoadFriend(param1:Player) : Boolean
      {
         var _loc2_:Boolean = true;
         if(param1 == null || this.player.getFriends() == null || this.player.getFriends().length < 1)
         {
            return true;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.player.getFriends().length)
         {
            if(param1 == this.player.getFriends()[_loc4_])
            {
               _loc3_ = _loc4_ + 1;
            }
            _loc4_++;
         }
         if(_loc3_ > this.player.getFriendsPagenum() * LOADING_RATE && _loc3_ > this.player.getFriends().length * LOADING_RATE)
         {
            return true;
         }
         return false;
      }
      
      public function getOrganism(param1:Player, param2:int) : Organism
      {
         if(param1.getAllOrganism() == null)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.getAllOrganism().length)
         {
            if((param1.getAllOrganism()[_loc3_] as Organism).getId() == param2)
            {
               return param1.getAllOrganism()[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getOrganismByIndex(param1:int) : Organism
      {
         if(this.player.getAllOrganism() == null || this.player.getAllOrganism().length < 1 || param1 > this.player.getAllOrganism().length)
         {
            return null;
         }
         return this.player.getAllOrganism()[param1];
      }
      
      public function getOrganismIndex(param1:Organism) : int
      {
         if(this.player.getAllOrganism() == null || this.player.getAllOrganism().length < 1)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.player.getAllOrganism().length)
         {
            if(param1 == this.player.getAllOrganism()[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function changeNowFlowers(param1:Player) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.getAllOrganism().length)
         {
            if((param1.getAllOrganism()[_loc3_] as Organism).getGardenId() != 0)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         param1.setNowflowerpotNum(_loc2_);
      }
      
      public function getPlayer() : Player
      {
         return this.player;
      }
      
      public function getPlayerOther() : Player
      {
         return this.player_other;
      }
      
      public function setPlayer(param1:Player) : void
      {
         this.player = param1;
      }
      
      public function setPlayerOther(param1:Player) : void
      {
         this.player_other = param1;
      }
      
      public function removeOrganism(param1:Organism) : void
      {
         var _loc3_:Organism = null;
         if(param1 == null || this.player.organisms == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.player.organisms.length)
         {
            if(param1 == this.player.organisms[_loc2_])
            {
               _loc3_ = this.player.organisms[0];
               this.player.organisms[0] = param1;
               this.player.organisms[_loc2_] = _loc3_;
               this.player.organisms.shift();
            }
            _loc2_++;
         }
      }
   }
}


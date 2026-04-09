package pvz.battle.fore
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Organism;
   import entity.Tool;
   import manager.PlayerManager;
   import pvz.serverbattle.entity.PlayerInfo;
   import utils.Singleton;
   
   public class BattleScence
   {
      
      private var _awards:Array = null;
      
      private var _gameMoney:GameMoney;
      
      private var _exp:Exp;
      
      private var _upinfos:Array;
      
      private var _myBaseOrg:Array = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var battlersInfo:PlayerInfo = null;
      
      public function BattleScence()
      {
         super();
      }
      
      public function addPlayerTool(param1:Array) : void
      {
         var _loc3_:Tool = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         this.setAwards(param1);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is Tool)
            {
               _loc3_ = this.playerManager.getPlayer().getTool((param1[_loc2_] as Tool).getOrderId());
               if(_loc3_ == null)
               {
                  _loc3_ = new Tool((param1[_loc2_] as Tool).getOrderId());
               }
               this.playerManager.getPlayer().updateTool((param1[_loc2_] as Tool).getOrderId(),_loc3_.getNum() + (param1[_loc2_] as Tool).getNum());
            }
            _loc2_++;
         }
      }
      
      public function addUpinfos(param1:Array) : void
      {
         this._upinfos = param1;
      }
      
      public function getUpInfos() : Array
      {
         if(this._upinfos == null)
         {
            this._upinfos = new Array();
         }
         return this._upinfos;
      }
      
      public function addPlayerGameMoney(param1:GameMoney) : void
      {
         this._gameMoney = param1;
         if(this._gameMoney)
         {
            PlantsVsZombies.changeMoneyOrExp(this._gameMoney.getMoneyValue());
         }
      }
      
      public function addPlayerExp(param1:Exp) : void
      {
         this._exp = param1;
         if(this._exp)
         {
            PlantsVsZombies.changeMoneyOrExp(this._exp.getExpValue(),1,true,true,true);
         }
      }
      
      public function getGameMoneyPrize() : GameMoney
      {
         return this._gameMoney;
      }
      
      public function getExpPrize() : Exp
      {
         return this._exp;
      }
      
      public function setBattlePlayerInfo(param1:PlayerInfo) : void
      {
         this.battlersInfo = param1;
      }
      
      public function getBattlePlayerInfo() : PlayerInfo
      {
         return this.battlersInfo;
      }
      
      public function getAwards() : Array
      {
         return this._awards;
      }
      
      public function getBaseOrg() : Array
      {
         return this._myBaseOrg;
      }
      
      public function getExpUpOrgs() : Array
      {
         var _loc3_:Organism = null;
         if(this._myBaseOrg == null || this._myBaseOrg.length < 1)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.playerManager.getPlayer().getAllOrganism().length)
         {
            _loc3_ = this.playerManager.getPlayer().getAllOrganism()[_loc2_];
            if(this.getOrgById(this._myBaseOrg,_loc3_) != null && _loc3_.getExp() > this.getOrgById(this._myBaseOrg,_loc3_).getExp())
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLifeOrgs() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.playerManager.getPlayer().getAllOrganism().length)
         {
            if((this.playerManager.getPlayer().getAllOrganism()[_loc2_] as Organism).getHp().toNumber() > 0)
            {
               _loc1_.push(this.playerManager.getPlayer().getAllOrganism()[_loc2_]);
            }
            _loc2_++;
         }
         this.orderOrgById(_loc1_);
         return _loc1_;
      }
      
      public function getOrgById(param1:Array, param2:Organism) : Organism
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Organism).getId() == param2.getId())
            {
               return param1[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getToolsAwards() : Array
      {
         if(this._awards == null)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this._awards.length)
         {
            if(this._awards[_loc2_][0] == "tool" || this._awards[_loc2_][0] == "organism")
            {
               _loc1_.push(this._awards[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getUpOrgs() : Array
      {
         var _loc3_:Organism = null;
         if(this._myBaseOrg == null || this._myBaseOrg.length < 1)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.playerManager.getPlayer().getAllOrganism().length)
         {
            _loc3_ = this.playerManager.getPlayer().getAllOrganism()[_loc2_];
            if(this.getOrgById(this._myBaseOrg,_loc3_) != null && _loc3_.getGrade() > this.getOrgById(this._myBaseOrg,_loc3_).getGrade())
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function orderOrg(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getWidth() * param1[_loc4_ - 1].getHeight() < _loc3_.getWidth() * _loc3_.getHeight())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function saveOrgsInfo(param1:Array) : void
      {
         var _loc3_:Organism = null;
         if(param1 == null)
         {
            return;
         }
         this._myBaseOrg = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Organism();
            _loc3_.setOrderId((param1[_loc2_] as Organism).getOrderId());
            _loc3_.setId((param1[_loc2_] as Organism).getId());
            _loc3_.setGrade((param1[_loc2_] as Organism).getGrade());
            _loc3_.setAttack((param1[_loc2_] as Organism).getAttack());
            _loc3_.setHp_max((param1[_loc2_] as Organism).getHp_max().toString());
            _loc3_.setExp((param1[_loc2_] as Organism).getExp());
            _loc3_.setExp_max((param1[_loc2_] as Organism).getExp_max());
            _loc3_.setExp_min((param1[_loc2_] as Organism).getExp_min());
            _loc3_.setMiss((param1[_loc2_] as Organism).getMiss());
            _loc3_.setPrecision((param1[_loc2_] as Organism).getPrecision());
            _loc3_.setNewMiss((param1[_loc2_] as Organism).getNewMiss());
            _loc3_.setNewPrecision((param1[_loc2_] as Organism).getNewPrecision());
            _loc3_.setSpeed((param1[_loc2_] as Organism).getSpeed());
            this._myBaseOrg.push(_loc3_);
            _loc2_++;
         }
         this.orderOrgById(this._myBaseOrg);
      }
      
      public function setAwards(param1:Array) : void
      {
         this._awards = param1;
      }
      
      private function orderOrgById(param1:Array) : Array
      {
         var _loc3_:Organism = null;
         var _loc4_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = _loc2_;
            while(_loc4_ > 0 && param1[_loc4_ - 1].getId() < _loc3_.getId())
            {
               param1[_loc4_] = param1[_loc4_ - 1];
               _loc4_--;
            }
            param1[_loc4_] = _loc3_;
            _loc2_++;
         }
         return param1;
      }
      
      public function destory() : void
      {
         this._awards = null;
         this._gameMoney = null;
         this._exp = null;
         this._upinfos = null;
         this._myBaseOrg = null;
         this.playerManager = null;
         this.battlersInfo = null;
      }
   }
}


package pvz.copy.models.limit
{
   import core.interfaces.IVo;
   import entity.Organism;
   import entity.Skill;
   
   public class LimitCheckPointVo implements IVo
   {
      
      private var _id:int;
      
      private var _picId:int;
      
      private var _isBossCp:int;
      
      private var _name:String;
      
      private var _emamys:Array;
      
      private var _jewelsForSure:Array;
      
      private var _jewelForMaybe:Array;
      
      private var _challageTimes:int;
      
      private var _status:int = 0;
      
      private var _prizeMoney:Number;
      
      private var _prizeExp:int;
      
      private var _exptimes:String = "";
      
      public function LimitCheckPointVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._id = param1.id;
         this._isBossCp = param1.boss;
         this._picId = param1.img_id;
         this._challageTimes = param1.lcc;
         this._status = param1.state;
         this._name = param1.name;
         this._prizeMoney = param1.money;
         this._prizeExp = param1.user_exp;
         this._exptimes = param1.exptimes;
         if(param1.reward_tools)
         {
            this._jewelsForSure = param1.reward_tools.sure;
            this._jewelForMaybe = param1.reward_tools.maybe;
         }
         this.setEmamys(param1.monsters);
      }
      
      public function getExpTimes() : String
      {
         return this._exptimes;
      }
      
      public function getChallageTimes() : int
      {
         return this._challageTimes;
      }
      
      public function getPrizeMoney() : Number
      {
         return this._prizeMoney;
      }
      
      public function getPrizeExp() : int
      {
         return this._prizeExp;
      }
      
      public function getPicid() : int
      {
         return this._picId;
      }
      
      public function getNameStr() : String
      {
         return this._name;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getEmamys() : Array
      {
         return this._emamys;
      }
      
      private function setEmamys(param1:Array) : void
      {
         var _loc2_:Organism = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Skill = null;
         this._emamys = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = new Organism();
            _loc2_.setId(_loc3_.id);
            _loc2_.setOrderId(_loc3_.pi);
            _loc2_.setAttack(_loc3_.ak);
            _loc2_.setGrade(_loc3_.gd);
            _loc2_.setMiss(_loc3_.mi);
            _loc2_.setHp(_loc3_.hp);
            _loc2_.setHp_max(_loc3_.hp);
            _loc2_.setPrecision(_loc3_.ps);
            _loc2_.setIsCopyBoss(_loc3_.boss);
            _loc2_.setSpeed(_loc3_.sp);
            _loc2_.setSize(_loc3_.size);
            _loc2_.setQuality_name(_loc3_.quality_name);
            for each(_loc4_ in _loc3_.skill)
            {
               _loc5_ = new Skill();
               _loc5_.setId(_loc4_.id);
               _loc5_.setGrade(_loc4_.grade);
               _loc5_.setName(_loc4_.name);
               _loc2_.addSkill(_loc5_);
            }
            this._emamys.push(_loc2_);
         }
      }
      
      public function getToolsForSure() : Array
      {
         return this._jewelsForSure;
      }
      
      public function getToolsForMaybe() : Array
      {
         return this._jewelForMaybe;
      }
      
      public function getStaus() : int
      {
         return this._status;
      }
      
      public function isBossCp() : Boolean
      {
         return this._isBossCp > 0;
      }
   }
}


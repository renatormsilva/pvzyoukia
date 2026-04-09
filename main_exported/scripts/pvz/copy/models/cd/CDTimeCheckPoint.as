package pvz.copy.models.cd
{
   import core.interfaces.IVo;
   import entity.Organism;
   import entity.Tool;
   
   public class CDTimeCheckPoint implements IVo
   {
      
      private var _id:int;
      
      private var _name:String;
      
      private var _challageTimes:int;
      
      private var _enemyOrgs:Array;
      
      private var _picid:int;
      
      private var _cdtime:Number;
      
      private var _rewards:Array;
      
      public function CDTimeCheckPoint()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._id = param1.id;
         this._name = param1.name;
         this._challageTimes = param1.lcc;
         this._cdtime = param1.cd_time;
         this.setEmamys(param1.monsters);
         this._picid = param1.img_id;
         this.setRewards(param1.reward_tools);
      }
      
      private function setRewards(param1:Array) : void
      {
         var _loc2_:Tool = null;
         var _loc3_:Object = null;
         this._rewards = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = new Tool(int(_loc3_));
            this._rewards.push(_loc2_);
         }
      }
      
      private function setEmamys(param1:Array) : void
      {
         var _loc2_:Organism = null;
         var _loc3_:Object = null;
         this._enemyOrgs = new Array();
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
            this._enemyOrgs.push(_loc2_);
         }
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getEnemyOrgs() : Array
      {
         return this._enemyOrgs;
      }
      
      public function getPicid() : int
      {
         return this._picid;
      }
      
      public function getChallageTime() : int
      {
         return this._challageTimes;
      }
      
      public function getCDTime() : Number
      {
         return this._cdtime;
      }
      
      public function getRewards() : Array
      {
         return this._rewards;
      }
   }
}


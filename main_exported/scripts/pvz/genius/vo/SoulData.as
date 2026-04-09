package pvz.genius.vo
{
   import core.interfaces.IVo;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class SoulData implements IVo
   {
      
      private var _level:int;
      
      private var _addHP:Number = 0;
      
      private var _addHit:Number = 0;
      
      private var _addSpeed:Number = 0;
      
      private var _addAttack:Number = 0;
      
      private var _addMiss:Number = 0;
      
      private var _addHurt:Number = 0;
      
      private var _reduceHurt:Number = 0;
      
      private var _storm:int;
      
      private var _strong:int;
      
      private var _carzy:int;
      
      private var _focus:int;
      
      private var _phantom:int;
      
      private var _lightDefence:int;
      
      private var _maskLevel:int;
      
      private var _poison:int;
      
      private var _clear:int;
      
      public function SoulData()
      {
         super();
      }
      
      public function get addMiss() : Number
      {
         return this._addMiss;
      }
      
      public function get clear() : int
      {
         return this._clear;
      }
      
      public function get poison() : int
      {
         return this._poison;
      }
      
      public function get maskLevel() : int
      {
         return this._maskLevel;
      }
      
      public function get lightDefence() : int
      {
         return this._lightDefence;
      }
      
      public function get phantom() : int
      {
         return this._phantom;
      }
      
      public function get focus() : int
      {
         return this._focus;
      }
      
      public function get carzy() : int
      {
         return this._carzy;
      }
      
      public function get strong() : int
      {
         return this._strong;
      }
      
      public function get storm() : int
      {
         return this._storm;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get reduceHurt() : Number
      {
         return this._reduceHurt;
      }
      
      public function get addHurt() : Number
      {
         return this._addHurt;
      }
      
      public function get addAttack() : Number
      {
         return this._addAttack;
      }
      
      public function get addSpeed() : Number
      {
         return this._addSpeed;
      }
      
      public function get addHit() : Number
      {
         return this._addHit;
      }
      
      public function get addHP() : Number
      {
         return this._addHP;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function decode(param1:Object) : void
      {
         if(param1.tals.tal[0])
         {
            this._storm = param1.tals.tal[0].@level;
         }
         if(param1.tals.tal[1])
         {
            this._strong = param1.tals.tal[1].@level;
         }
         if(param1.tals.tal[2])
         {
            this._focus = param1.tals.tal[2].@level;
         }
         if(param1.tals.tal[3])
         {
            this._phantom = param1.tals.tal[3].@level;
         }
         if(param1.tals.tal[4])
         {
            this._carzy = param1.tals.tal[4].@level;
         }
         if(param1.tals.tal[5])
         {
            this._lightDefence = param1.tals.tal[5].@level;
         }
         if(param1.tals.tal[6])
         {
            this._maskLevel = param1.tals.tal[6].@level;
         }
         if(param1.tals.tal[7])
         {
            this._poison = param1.tals.tal[7].@level;
         }
         if(param1.tals.tal[8])
         {
            this._clear = param1.tals.tal[8].@level;
         }
         if(param1.add_prop.prop[0])
         {
            this._addHP = param1.add_prop.prop[0].@vaule;
         }
         if(param1.add_prop.prop[1])
         {
            this._addAttack = param1.add_prop.prop[1].@vaule;
         }
         if(param1.add_prop.prop[2])
         {
            this._addHit = param1.add_prop.prop[2].@vaule;
         }
         if(param1.add_prop.prop[3])
         {
            this._addMiss = param1.add_prop.prop[3].@vaule;
         }
         if(param1.add_prop.prop[4])
         {
            this._addSpeed = param1.add_prop.prop[4].@vaule;
         }
         if(param1.add_prop.prop[5])
         {
            this._addHurt = param1.add_prop.prop[5].@vaule;
         }
         if(param1.add_prop.prop[6])
         {
            this._reduceHurt = param1.add_prop.prop[6].@vaule;
         }
      }
      
      public function getArriveGeniusLevelByName(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case XmlGeniusDataConfig.STRONG:
               _loc2_ = this._strong;
               break;
            case XmlGeniusDataConfig.STROM_ATTACK:
               _loc2_ = this._storm;
               break;
            case XmlGeniusDataConfig.POISON:
               _loc2_ = this._poison;
               break;
            case XmlGeniusDataConfig.PHANTOM:
               _loc2_ = this._phantom;
               break;
            case XmlGeniusDataConfig.LIGHT_DEFFENCE:
               _loc2_ = this._lightDefence;
               break;
            case XmlGeniusDataConfig.FOCUS:
               _loc2_ = this._focus;
               break;
            case XmlGeniusDataConfig.DEFEAT:
               _loc2_ = this._maskLevel;
               break;
            case XmlGeniusDataConfig.CLEAR:
               _loc2_ = this._clear;
               break;
            case XmlGeniusDataConfig.CAZRY_WIND:
               _loc2_ = this._carzy;
         }
         return _loc2_;
      }
   }
}


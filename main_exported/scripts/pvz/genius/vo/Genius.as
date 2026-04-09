package pvz.genius.vo
{
   import core.interfaces.IVo;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class Genius implements IVo
   {
      
      private var _storm:int;
      
      private var _strong:int;
      
      private var _carzy:int;
      
      private var _focus:int;
      
      private var _phantom:int;
      
      private var _lightDefence:int;
      
      private var _maskLevel:int;
      
      private var _poison:int;
      
      private var _clear:int;
      
      public function Genius()
      {
         super();
      }
      
      public function decodeXml(param1:Object) : void
      {
         var _loc2_:XML = new XML(param1[0]);
         this._storm = _loc2_.tal[0].@level;
         this._strong = _loc2_.tal[1].@level;
         this._focus = _loc2_.tal[2].@level;
         this._phantom = _loc2_.tal[3].@level;
         this._carzy = _loc2_.tal[4].@level;
         this._lightDefence = _loc2_.tal[5].@level;
         this._maskLevel = _loc2_.tal[6].@level;
         this._poison = _loc2_.tal[7].@level;
         this._clear = _loc2_.tal[8].@level;
      }
      
      public function decode(param1:Object) : void
      {
         var _loc2_:Object = param1;
         this._storm = _loc2_[0].level;
         this._strong = _loc2_[1].level;
         this._focus = _loc2_[2].level;
         this._phantom = _loc2_[3].level;
         this._carzy = _loc2_[4].level;
         this._lightDefence = _loc2_[5].level;
         this._maskLevel = _loc2_[6].level;
         this._poison = _loc2_[7].level;
         this._clear = _loc2_[8].level;
      }
      
      public function decodeByArr(param1:Array) : void
      {
         if(!param1 || param1.length <= 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_][0] == 1)
            {
               this._storm = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 2)
            {
               this._strong = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 3)
            {
               this._focus = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 4)
            {
               this._phantom = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 5)
            {
               this._carzy = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 6)
            {
               this._lightDefence = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 7)
            {
               this._maskLevel = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 8)
            {
               this._poison = param1[_loc2_][1];
            }
            else if(param1[_loc2_][0] == 9)
            {
               this._clear = param1[_loc2_][1];
            }
            _loc2_++;
         }
         param1 = null;
      }
      
      public function get storm() : int
      {
         return this._storm;
      }
      
      public function get strong() : int
      {
         return this._strong;
      }
      
      public function get carzy() : int
      {
         return this._carzy;
      }
      
      public function get focus() : int
      {
         return this._focus;
      }
      
      public function get phantom() : int
      {
         return this._phantom;
      }
      
      public function get lightDefence() : int
      {
         return this._lightDefence;
      }
      
      public function get maskLevel() : int
      {
         return this._maskLevel;
      }
      
      public function get poison() : int
      {
         return this._poison;
      }
      
      public function get clear() : int
      {
         return this._clear;
      }
      
      public function getParaGeniusLevelByName(param1:String) : int
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


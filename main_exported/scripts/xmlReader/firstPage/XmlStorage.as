package xmlReader.firstPage
{
   import entity.ExSkill;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlStorage extends XmlBaseReader
   {
      
      public function XmlStorage(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getOrgGridsGrade() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.open_info.organism.@grade;
      }
      
      public function getOrgGridsMoney() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.open_info.organism.@money;
      }
      
      public function getOrgGridsNum() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.@organism_grid_amount;
      }
      
      public function getToolGridsGrade() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.open_info.tool.@grade;
      }
      
      public function getToolGridsMoney() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.open_info.tool.@money;
      }
      
      public function getToolGridsNum() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.warehouse.@tool_grid_amount;
      }
      
      public function getTools() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Tool = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.warehouse.tools.item.@id)
         {
            _loc3_ = new Tool(_xml.warehouse.tools.item[_loc2_].@id);
            _loc3_.setNum(_xml.warehouse.tools.item[_loc2_].@amount);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      private function isArena(param1:int) : Boolean
      {
         var _loc2_:String = _xml.warehouse.organisms.organisms_arena.@ids;
         var _loc3_:Array = _loc2_.split(",");
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc4_])
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function isPossession(param1:int) : Boolean
      {
         var _loc2_:String = _xml.warehouse.organisms.organisms_territory.@ids;
         var _loc3_:Array = _loc2_.split(",");
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc4_])
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function isSeverBattle(param1:int) : Boolean
      {
         var _loc2_:String = _xml.warehouse.organisms.organisms_serverbattle.@ids;
         var _loc3_:Array = _loc2_.split(",");
         if(_loc3_ == null || _loc3_.length < 1)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc4_])
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function getArenaOrgs() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Organism = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Skill = null;
         var _loc7_:ExSkill = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.warehouse.organisms.item.@id)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_xml.warehouse.organisms.item[_loc2_].@id);
            _loc3_.setIsArena(this.isArena(_loc3_.getId()));
            if(this.isArena(_loc3_.getId()))
            {
               _loc3_.setOrderId(_xml.warehouse.organisms.item[_loc2_].@pid);
               _loc3_.setAttack(_xml.warehouse.organisms.item[_loc2_].@at);
               _loc3_.setMiss(_xml.warehouse.organisms.item[_loc2_].@mi);
               _loc3_.setSpeed(_xml.warehouse.organisms.item[_loc2_].@sp);
               _loc3_.setHp(_xml.warehouse.organisms.item[_loc2_].@hp);
               _loc3_.setHp_max(_xml.warehouse.organisms.item[_loc2_].@hm);
               _loc3_.setNewMiss(_xml.warehouse.organisms.item[_loc2_].@new_miss);
               _loc3_.setNewPrecision(_xml.warehouse.organisms.item[_loc2_].@new_precision);
               _loc3_.setGrade(_xml.warehouse.organisms.item[_loc2_].@gr);
               _loc3_.setExp(_xml.warehouse.organisms.item[_loc2_].@ex);
               _loc3_.setExp_max(_xml.warehouse.organisms.item[_loc2_].@ema);
               _loc3_.setExp_min(_xml.warehouse.organisms.item[_loc2_].@emi);
               _loc3_.setPrecision(_xml.warehouse.organisms.item[_loc2_].@pr);
               _loc3_.setQuality_name(_xml.warehouse.organisms.item[_loc2_].@qu);
               _loc3_.setGardenId(_xml.warehouse.organisms.item[_loc2_].@gi);
               _loc3_.setPullulation(_xml.warehouse.organisms.item[_loc2_].@ma);
               _loc3_.setCompAtt(_xml.warehouse.organisms.item[_loc2_].@sa);
               _loc3_.setCompHp(_xml.warehouse.organisms.item[_loc2_].@sh);
               _loc3_.setCompMiss(_xml.warehouse.organisms.item[_loc2_].@sm);
               _loc3_.setCompPre(_xml.warehouse.organisms.item[_loc2_].@spr);
               _loc3_.setCompSpeed(_xml.warehouse.organisms.item[_loc2_].@ss);
               _loc3_.setCompNewPre(_xml.warehouse.organisms.item[_loc2_].@new_syn_precision);
               _loc3_.setCompNewMiss(_xml.warehouse.organisms.item[_loc2_].@new_syn_miss);
               _loc3_.setIsPossession(this.isPossession(_loc3_.getId()));
               for(_loc4_ in _xml.warehouse.organisms.item[_loc2_].sk.item)
               {
                  _loc6_ = new Skill();
                  _loc6_.setName(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@na);
                  _loc6_.setGrade(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@gr);
                  _loc6_.setId(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@id);
                  _loc6_.setEffect(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@oa);
                  _loc3_.addSkill(_loc6_);
               }
               for(_loc5_ in _xml.warehouse.organisms.item[_loc2_].ssk.item)
               {
                  _loc7_ = new ExSkill();
                  _loc7_.setName(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@name);
                  _loc7_.setGrade(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@grade);
                  _loc7_.setId(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@id);
                  _loc7_.setType(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@type);
                  _loc3_.addExSkill(_loc7_);
               }
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function getOrganisms() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Organism = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Skill = null;
         var _loc7_:ExSkill = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.warehouse.organisms.item.@id)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_xml.warehouse.organisms.item[_loc2_].@id);
            _loc3_.setBattleE(_xml.warehouse.organisms.item[_loc2_].@fight);
            _loc3_.setOrderId(_xml.warehouse.organisms.item[_loc2_].@pid);
            _loc3_.setAttack(_xml.warehouse.organisms.item[_loc2_].@at);
            _loc3_.setMiss(_xml.warehouse.organisms.item[_loc2_].@mi);
            _loc3_.setSpeed(_xml.warehouse.organisms.item[_loc2_].@sp);
            _loc3_.setNewMiss(_xml.warehouse.organisms.item[_loc2_].@new_miss);
            _loc3_.setNewPrecision(_xml.warehouse.organisms.item[_loc2_].@new_precision);
            _loc3_.setHp(_xml.warehouse.organisms.item[_loc2_].@hp);
            _loc3_.setHp_max(_xml.warehouse.organisms.item[_loc2_].@hm);
            _loc3_.setGrade(_xml.warehouse.organisms.item[_loc2_].@gr);
            _loc3_.setExp(_xml.warehouse.organisms.item[_loc2_].@ex);
            _loc3_.setExp_max(_xml.warehouse.organisms.item[_loc2_].@ema);
            _loc3_.setExp_min(_xml.warehouse.organisms.item[_loc2_].@emi);
            _loc3_.setPrecision(_xml.warehouse.organisms.item[_loc2_].@pr);
            _loc3_.setQuality_name(_xml.warehouse.organisms.item[_loc2_].@qu);
            _loc3_.setGardenId(_xml.warehouse.organisms.item[_loc2_].@gi);
            _loc3_.setPullulation(_xml.warehouse.organisms.item[_loc2_].@ma);
            _loc3_.setCompAtt(_xml.warehouse.organisms.item[_loc2_].@sa);
            _loc3_.setIsAcceptInherited(_xml.warehouse.organisms.item[_loc2_].@ec);
            _loc3_.setCompHp(_xml.warehouse.organisms.item[_loc2_].@sh);
            _loc3_.setCompMiss(_xml.warehouse.organisms.item[_loc2_].@sm);
            _loc3_.setCompPre(_xml.warehouse.organisms.item[_loc2_].@spr);
            _loc3_.setCompSpeed(_xml.warehouse.organisms.item[_loc2_].@ss);
            _loc3_.setCompNewPre(_xml.warehouse.organisms.item[_loc2_].@new_syn_precision);
            _loc3_.setCompNewMiss(_xml.warehouse.organisms.item[_loc2_].@new_syn_miss);
            _loc3_.setGiftData(_xml.warehouse.organisms.item[_loc2_].tals);
            _loc3_.setSoulLevel(_xml.warehouse.organisms.item[_loc2_].soul);
            _loc3_.setSoulHp(_xml.warehouse.organisms.item[_loc2_].soul_add.@hp);
            _loc3_.setSoulAtt(_xml.warehouse.organisms.item[_loc2_].soul_add.@attack);
            _loc3_.setSoulMiss(_xml.warehouse.organisms.item[_loc2_].soul_add.@miss);
            _loc3_.setSoulSpeed(_xml.warehouse.organisms.item[_loc2_].soul_add.@speed);
            _loc3_.setSoulPre(_xml.warehouse.organisms.item[_loc2_].soul_add.@precision);
            _loc3_.setGeniusHp(_xml.warehouse.organisms.item[_loc2_].tal_add.@hp);
            _loc3_.setGeniusAtt(_xml.warehouse.organisms.item[_loc2_].tal_add.@attack);
            _loc3_.setGeniusMiss(_xml.warehouse.organisms.item[_loc2_].tal_add.@miss);
            _loc3_.setGeniusSpeed(_xml.warehouse.organisms.item[_loc2_].tal_add.@speed);
            _loc3_.setGeniusPre(_xml.warehouse.organisms.item[_loc2_].tal_add.@precision);
            _loc3_.setMorphHp(_xml.warehouse.organisms.item[_loc2_].tal_add.@hp);
            _loc3_.setMorphAtt(_xml.warehouse.organisms.item[_loc2_].tal_add.@attack);
            _loc3_.setMorphMiss(_xml.warehouse.organisms.item[_loc2_].tal_add.@miss);
            _loc3_.setMorphSpeed(_xml.warehouse.organisms.item[_loc2_].tal_add.@speed);
            _loc3_.setMorphPre(_xml.warehouse.organisms.item[_loc2_].tal_add.@precision);
            _loc3_.setIsArena(this.isArena(_loc3_.getId()));
            _loc3_.setIsPossession(this.isPossession(_loc3_.getId()));
            _loc3_.setIsSeverBattle(this.isSeverBattle(_loc3_.getId()));
            for(_loc4_ in _xml.warehouse.organisms.item[_loc2_].sk.item)
            {
               _loc6_ = new Skill();
               _loc6_.setName(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@na);
               _loc6_.setGrade(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@gr);
               _loc6_.setId(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@id);
               _loc6_.setEffect(_xml.warehouse.organisms.item[_loc2_].sk.item[_loc4_].@oa);
               _loc3_.addSkill(_loc6_);
            }
            for(_loc5_ in _xml.warehouse.organisms.item[_loc2_].ssk.item)
            {
               _loc7_ = new ExSkill();
               _loc7_.setName(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@name);
               _loc7_.setGrade(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@grade);
               _loc7_.setId(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@id);
               _loc7_.setType(_xml.warehouse.organisms.item[_loc2_].ssk.item[_loc5_].@type);
               _loc3_.addExSkill(_loc7_);
            }
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getSeverBattleOrgs() : Array
      {
         var _loc4_:Organism = null;
         var _loc1_:Array = [];
         var _loc2_:String = _xml.warehouse.organisms.organisms_serverbattle.@ids;
         var _loc3_:Array = _loc2_.split(",");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] != "")
            {
               _loc4_ = PlantsVsZombies.playerManager.getOrganism(PlantsVsZombies.playerManager.getPlayer(),int(_loc3_[_loc5_]));
               _loc1_.push(_loc4_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
   }
}


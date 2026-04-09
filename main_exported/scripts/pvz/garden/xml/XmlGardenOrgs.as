package pvz.garden.xml
{
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   import manager.OrganismManager;
   import manager.PlayerManager;
   import pvz.garden.fore.Garden;
   import pvz.garden.rpc.GardenMonster;
   import utils.Singleton;
   import xmlReader.XmlBaseReader;
   
   public class XmlGardenOrgs extends XmlBaseReader
   {
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function XmlGardenOrgs(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function setInfos(param1:Array, param2:Array, param3:Number) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Organism = null;
         var _loc8_:Organism = null;
         this.playerManager.getPlayer().setGardenChaCount(int(_xml.garden.@cn));
         for(_loc4_ in _xml.garden.ors.or.@id)
         {
            _loc5_ = _xml.garden.ors.or[_loc4_].@ow;
            _loc6_ = Number(_xml.garden.ors.or[_loc4_].@owid);
            if(_loc6_ == this.playerManager.getPlayer().getId())
            {
               if(_loc6_ == param3)
               {
                  _loc7_ = this.playerManager.getOrganism(this.playerManager.getPlayer(),_xml.garden.ors.or[_loc4_].@id);
                  _loc7_.setX(_xml.garden.ors.or[_loc4_].position.@lx - Garden.MY_TEMP_X);
                  _loc7_.setY(_xml.garden.ors.or[_loc4_].position.@ly);
                  _loc7_.setOwner(_loc5_);
                  _loc7_.setGardenId(_loc6_);
                  _loc7_.setTypeTime(_xml.garden.ors.or[_loc4_].state.@ti);
                  _loc7_.setNextType(_xml.garden.ors.or[_loc4_].state.@ty);
                  _loc7_.setHp(_xml.garden.ors.or[_loc4_].@hp);
                  _loc7_.setHp_max(_xml.garden.ors.or[_loc4_].@hm);
                  _loc7_.setIsSteal(_xml.garden.ors.or[_loc4_].@it);
                  _loc7_.setSoulLevel(_xml.garden.ors.or[_loc4_].@soul);
                  _loc7_.setBattleE(_xml.garden.ors.or[_loc4_].@ft);
                  if(_loc7_.getTypeTime() < 0)
                  {
                     _loc7_.setGardenType(_loc7_.getNextType());
                  }
                  _loc7_.setGainTime(_xml.garden.ors.or[_loc4_].@rt);
                  param1.push(_loc7_);
               }
               else
               {
                  _loc7_ = this.playerManager.getOrganism(this.playerManager.getPlayer(),_xml.garden.ors.or[_loc4_].@id);
                  _loc7_.setX(_xml.garden.ors.or[_loc4_].position.@lx);
                  _loc7_.setY(_xml.garden.ors.or[_loc4_].position.@ly);
                  _loc7_.setOwner(_loc5_);
                  _loc7_.setGardenId(_loc6_);
                  _loc7_.setTypeTime(_xml.garden.ors.or[_loc4_].state.@ti);
                  _loc7_.setNextType(_xml.garden.ors.or[_loc4_].state.@ty);
                  _loc7_.setHp(_xml.garden.ors.or[_loc4_].@hp);
                  _loc7_.setHp_max(_xml.garden.ors.or[_loc4_].@hm);
                  _loc7_.setIsSteal(_xml.garden.ors.or[_loc4_].@it);
                  _loc7_.setSoulLevel(_xml.garden.ors.or[_loc4_].@soul);
                  _loc7_.setBattleE(_xml.garden.ors.or[_loc4_].@ft);
                  if(_loc7_.getTypeTime() < 0)
                  {
                     _loc7_.setGardenType(_loc7_.getNextType());
                  }
                  _loc7_.setGainTime(_xml.garden.ors.or[_loc4_].@rt);
                  param2.push(_loc7_);
               }
            }
            else if(_loc6_ == param3)
            {
               _loc8_ = new Organism();
               _loc8_.setOrderId(_xml.garden.ors.or[_loc4_].@pid);
               _loc8_.setOwner(_loc5_);
               _loc8_.setId(_xml.garden.ors.or[_loc4_].@id);
               _loc8_.setX(_xml.garden.ors.or[_loc4_].position.@lx - Garden.MY_TEMP_X);
               _loc8_.setY(_xml.garden.ors.or[_loc4_].position.@ly);
               _loc8_.setTypeTime(_xml.garden.ors.or[_loc4_].state.@ti);
               _loc8_.setNextType(_xml.garden.ors.or[_loc4_].state.@ty);
               _loc8_.setHp(_xml.garden.ors.or[_loc4_].@hp);
               _loc8_.setHp_max(_xml.garden.ors.or[_loc4_].@hm);
               _loc8_.setGrade(_xml.garden.ors.or[_loc4_].@gr);
               _loc8_.setQuality_name(_xml.garden.ors.or[_loc4_].@qu);
               _loc8_.setIsSteal(_xml.garden.ors.or[_loc4_].@it);
               _loc8_.setSoulLevel(_xml.garden.ors.or[_loc4_].@soul);
               _loc8_.setBattleE(_xml.garden.ors.or[_loc4_].@ft);
               if(_loc8_.getTypeTime() < 0)
               {
                  _loc8_.setGardenType(_loc8_.getNextType());
               }
               _loc8_.setGainTime(_xml.garden.ors.or[_loc4_].@rt);
               param1.push(_loc8_);
            }
            else
            {
               _loc8_ = new Organism();
               _loc8_.setOrderId(_xml.garden.ors.or[_loc4_].@pid);
               _loc8_.setOwner(_loc5_);
               _loc8_.setId(_xml.garden.ors.or[_loc4_].@id);
               _loc8_.setX(_xml.garden.ors.or[_loc4_].position.@lx);
               _loc8_.setY(_xml.garden.ors.or[_loc4_].position.@ly);
               _loc8_.setTypeTime(_xml.garden.ors.or[_loc4_].state.@ti);
               _loc8_.setNextType(_xml.garden.ors.or[_loc4_].state.@ty);
               _loc8_.setHp(_xml.garden.ors.or[_loc4_].@hp);
               _loc8_.setHp_max(_xml.garden.ors.or[_loc4_].@hm);
               _loc8_.setGrade(_xml.garden.ors.or[_loc4_].@gr);
               _loc8_.setQuality_name(_xml.garden.ors.or[_loc4_].@qu);
               _loc8_.setIsSteal(_xml.garden.ors.or[_loc4_].@it);
               _loc8_.setSoulLevel(_xml.garden.ors.or[_loc4_].@soul);
               _loc8_.setBattleE(_xml.garden.ors.or[_loc4_].@ft);
               if(_loc8_.getTypeTime() < 0)
               {
                  _loc8_.setGardenType(_loc8_.getNextType());
               }
               _loc8_.setGainTime(_xml.garden.ors.or[_loc4_].@rt);
               param2.push(_loc8_);
            }
         }
      }
      
      public function getMosterInfo() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:XML = null;
         var _loc4_:GardenMonster = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Tool = null;
         var _loc11_:XML = null;
         var _loc12_:Organism = null;
         var _loc13_:XML = null;
         var _loc14_:XMLList = null;
         var _loc15_:Array = null;
         var _loc16_:Skill = null;
         var _loc1_:Array = [];
         for each(_loc2_ in _xml.garden.monster.mon)
         {
            _loc3_ = null;
            _loc3_ = _loc2_ as XML;
            _loc4_ = new GardenMonster();
            _loc4_.id = _loc3_.@id;
            _loc4_.monid = _loc3_.@monid;
            _loc4_.pid = _loc3_.@pid;
            _loc4_.owid = _loc3_.@owid;
            _loc4_.name = _loc3_.@name;
            _loc4_.grade_max = _loc3_.@grade_max;
            _loc4_.grade_min = _loc3_.@grade_min;
            _loc5_ = _loc3_.@reward;
            _loc6_ = [];
            for each(_loc7_ in _loc5_.split(","))
            {
               _loc10_ = new Tool(int(_loc7_));
               _loc10_.setNum(0);
               _loc6_.push(_loc10_);
            }
            _loc4_.rewardTools = _loc6_;
            _loc4_.position = new Point(Number(_loc3_.position.@lx),Number(_loc3_.position.@ly));
            _loc8_ = new Array();
            for each(_loc9_ in _loc3_.read.org)
            {
               _loc11_ = _loc9_ as XML;
               _loc12_ = new Organism();
               _loc12_.setBlood(OrganismManager.ZOMBIE);
               _loc12_.setId(_loc11_.@id);
               _loc12_.setOrderId(_loc11_.pi);
               _loc12_.setAttack(_loc11_.ak);
               _loc12_.setMiss(_loc11_.mi);
               _loc12_.setHp(_loc11_.hp);
               _loc12_.setHp_max(_loc11_.hp);
               _loc12_.setGrade(_loc11_.gd);
               _loc12_.setPrecision(_loc11_.ps);
               _loc12_.setNewMiss(_loc11_.new_miss);
               _loc12_.setNewPrecision(_loc11_.new_precision);
               _loc13_ = null;
               _loc14_ = _loc11_.talent.item;
               _loc15_ = [];
               for each(_loc13_ in _loc14_)
               {
                  _loc15_.push(Number(_loc13_));
               }
               _loc12_.setFadeGeinus(_loc15_);
               _loc13_ = null;
               _loc14_ = _loc11_.skill.item;
               for each(_loc13_ in _loc14_)
               {
                  _loc16_ = new Skill();
                  _loc16_.setId(_loc13_.id);
                  _loc16_.setName(_loc13_.name);
                  _loc16_.setGrade(_loc13_.grade);
                  _loc12_.addSkill(_loc16_);
               }
               _loc8_.push(_loc12_);
            }
            _loc4_.monsters = _loc8_;
            _loc1_.push(_loc4_);
         }
         return _loc1_;
      }
      
      public function getFriendLandNum() : int
      {
         return _xml.garden.@am;
      }
      
      public function getBoxId() : int
      {
         return _xml.garden.@bt;
      }
      
      public function getBoxAmount() : int
      {
         return _xml.garden.@ba;
      }
   }
}


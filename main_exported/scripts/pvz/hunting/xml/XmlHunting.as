package pvz.hunting.xml
{
   import entity.Hole;
   import entity.Organism;
   import entity.Skill;
   import flash.utils.getQualifiedClassName;
   import manager.OrganismManager;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlHolePrizesConfig;
   
   public class XmlHunting extends XmlBaseReader
   {
      
      internal var lastId:int = 0;
      
      private var userlastid:int;
      
      public function XmlHunting(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getLastId() : int
      {
         return this.lastId;
      }
      
      public function getUserLastId() : int
      {
         return this.userlastid;
      }
      
      public function getHoles() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Hole = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Organism = null;
         var _loc7_:XML = null;
         var _loc8_:XMLList = null;
         var _loc9_:Array = null;
         var _loc10_:Skill = null;
         var _loc1_:Array = new Array();
         this.userlastid = _xml.hunting.user.@my_id;
         for(_loc2_ in _xml.hunting.h)
         {
            _loc3_ = new Hole();
            _loc3_.setOpenId(_xml.hunting.h[_loc2_].oi);
            _loc3_.setHoleName(_xml.hunting.h[_loc2_].na);
            _loc3_.setId(_xml.hunting.h[_loc2_].@id);
            _loc3_.setType(_xml.hunting.h[_loc2_].t);
            if(_xml.hunting.h[_loc2_].t != Hole.OPEN_NO)
            {
               this.lastId = _xml.hunting.h[_loc2_].@id;
            }
            _loc3_.setCome_time(_xml.hunting.h[_loc2_].ct);
            _loc3_.setOpen_level(_xml.hunting.h[_loc2_].og);
            _loc3_.setOpen_money(_xml.hunting.h[_loc2_].oc);
            _loc3_.setPlayMoney(_xml.hunting.h[_loc2_].bm);
            _loc3_.setLastAttackName(_xml.hunting.h[_loc2_].la.nk);
            _loc3_.setMasterTime(_xml.hunting.h[_loc2_].lt);
            _loc4_ = new Array();
            for(_loc5_ in _xml.hunting.h[_loc2_].orgs.org.@id)
            {
               _loc6_ = new Organism();
               _loc6_.setBlood(OrganismManager.ZOMBIE);
               _loc6_.setId(_xml.hunting.h[_loc2_].orgs.org[_loc5_].@id);
               _loc6_.setOrderId(_xml.hunting.h[_loc2_].orgs.org[_loc5_].pi);
               _loc6_.setAttack(_xml.hunting.h[_loc2_].orgs.org[_loc5_].ak);
               _loc6_.setMiss(_xml.hunting.h[_loc2_].orgs.org[_loc5_].mi);
               _loc6_.setHp(_xml.hunting.h[_loc2_].orgs.org[_loc5_].hp);
               _loc6_.setHp_max(_xml.hunting.h[_loc2_].orgs.org[_loc5_].hp);
               _loc6_.setGrade(_xml.hunting.h[_loc2_].orgs.org[_loc5_].gd);
               _loc6_.setPrecision(_xml.hunting.h[_loc2_].orgs.org[_loc5_].ps);
               _loc6_.setNewMiss(_xml.hunting.h[_loc2_].orgs.org[_loc5_].new_miss);
               _loc6_.setNewPrecision(_xml.hunting.h[_loc2_].orgs.org[_loc5_].new_precision);
               _loc7_ = null;
               _loc8_ = _xml.hunting.h[_loc2_].orgs.org[_loc5_].talent.item;
               _loc9_ = [];
               for each(_loc7_ in _loc8_)
               {
                  _loc9_.push(Number(_loc7_));
               }
               _loc6_.setFadeGeinus(_loc9_);
               _loc7_ = null;
               _loc8_ = _xml.hunting.h[_loc2_].orgs.org[_loc5_].skill.item;
               for each(_loc7_ in _loc8_)
               {
                  _loc10_ = new Skill();
                  _loc10_.setId(_loc7_.id);
                  _loc10_.setName(_loc7_.name);
                  _loc10_.setGrade(_loc7_.grade);
                  _loc6_.addSkill(_loc10_);
               }
               _loc4_.push(_loc6_);
            }
            _loc3_.setAwards(XmlHolePrizesConfig.getInstance().getHolePrizes(_loc3_.getId()));
            _loc3_.setAwardsInfo("");
            _loc3_.setOrganisms(_loc4_);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
   }
}


package xmlReader.firstPage
{
   import entity.Organism;
   import entity.Skill;
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlEvolution extends XmlBaseReader
   {
      
      public function XmlEvolution(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function get getUseCoin() : Number
      {
         return _xml.user.@money;
      }
      
      public function get getUseGold() : Number
      {
         return _xml.user.@rmb_money;
      }
      
      public function getOrg() : Organism
      {
         var _loc2_:String = null;
         var _loc3_:Skill = null;
         if(_xml == null)
         {
            return null;
         }
         var _loc1_:Organism = new Organism();
         _loc1_.setId(_xml.org.@id);
         _loc1_.setOrderId(_xml.org.picid);
         _loc1_.setAttack(_xml.org.attack);
         _loc1_.setMiss(_xml.org.miss);
         _loc1_.setHp(_xml.org.hp);
         _loc1_.setHp_max(_xml.org.maxhp);
         _loc1_.setGrade(_xml.org.grade);
         _loc1_.setExp(_xml.org.xml);
         _loc1_.setExp_max(_xml.org.maxexp);
         _loc1_.setPullulation(_xml.org.pullulation);
         _loc1_.setPrecision(_xml.org.precision);
         _loc1_.setNewMiss(_xml.org.new_miss);
         _loc1_.setNewPrecision(_xml.org.new_precision);
         _loc1_.setQuality_name(_xml.org.quality);
         _loc1_.setGardenId(_xml.org.gardenid);
         for(_loc2_ in _xml.org.skills.item)
         {
            _loc3_ = new Skill();
            _loc3_.setName(_xml.org.skills.item[_loc2_].@name);
            _loc3_.setGrade(_xml.org.skills.item[_loc2_].@grade);
            _loc3_.setId(_xml.org.skills.item[_loc2_].@id);
            _loc3_.setEffect(_xml.org.skills.item[_loc2_].@organism_attr);
            _loc1_.addSkill(_loc3_);
         }
         return _loc1_;
      }
   }
}


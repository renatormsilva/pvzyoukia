package xmlReader
{
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.utils.getQualifiedClassName;
   
   public class XmlNewUserHelp extends XmlBaseReader
   {
      
      public function XmlNewUserHelp(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getTools() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Tool = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.tools.tool.@id)
         {
            _loc3_ = new Tool(_xml.tools.tool[_loc2_].@id);
            _loc3_.setNum(_xml.tools.tool[_loc2_].num);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getOrgs() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Organism = null;
         var _loc4_:String = null;
         var _loc5_:Skill = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.warehouse.organisms.item.@id)
         {
            _loc3_ = new Organism();
            _loc3_.setId(_xml.organisms.item[_loc2_].@id);
            _loc3_.setAttack(_xml.organisms.item[_loc2_].@attack);
            _loc3_.setMiss(_xml.organisms.item[_loc2_].@miss);
            _loc3_.setHp(_xml.organisms.item[_loc2_].@hp);
            _loc3_.setHp_max(_xml.organisms.item[_loc2_].@hp_max);
            _loc3_.setGrade(_xml.organisms.item[_loc2_].@grade);
            _loc3_.setExp(_xml.organisms.item[_loc2_].@exp);
            _loc3_.setExp_max(_xml.organisms.item[_loc2_].@exp_max);
            _loc3_.setPrecision(_xml.organisms.item[_loc2_].@mature);
            _loc3_.setQuality_name(_xml.organisms.item[_loc2_].@quality);
            _loc3_.setGardenId(_xml.organisms.item[_loc2_].@gardenid);
            for(_loc4_ in _xml.organisms.item[_loc2_].skills.item)
            {
               _loc5_ = new Skill();
               _loc5_.setName(_xml.organisms.item[_loc2_].skills.item[_loc4_].@name);
               _loc5_.setGrade(_xml.organisms.item[_loc2_].skills.item[_loc4_].@grade);
               _loc5_.setId(_xml.organisms.item[_loc2_].skills.item[_loc4_].@id);
               _loc5_.setEffect(_xml.organisms.item[_loc2_].skills.item[_loc4_].@organism_attr);
               _loc3_.addSkill(_loc5_);
            }
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getMoney() : int
      {
         return _xml.money;
      }
   }
}


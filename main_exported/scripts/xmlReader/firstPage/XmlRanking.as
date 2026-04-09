package xmlReader.firstPage
{
   import entity.Organism;
   import entity.Player;
   import entity.Skill;
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlRanking extends XmlBaseReader
   {
      
      public function XmlRanking(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getNowTypeRanking() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Player = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.users.item.@id)
         {
            _loc3_ = new Player();
            _loc3_.setId(Number(_xml.users.item[_loc2_].@id));
            _loc3_.setNickname(_xml.users.item[_loc2_].@nickname);
            _loc3_.setGrade(_xml.users.item[_loc2_].@grade);
            _loc3_.setCharm(_xml.users.item[_loc2_].@charm);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getOrgRankingInfo() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Player = null;
         var _loc6_:Organism = null;
         var _loc7_:String = null;
         var _loc8_:Skill = null;
         var _loc1_:int = 1;
         var _loc2_:Array = new Array();
         for(_loc3_ in _xml.fighting.organisms.item.@id)
         {
            _loc4_ = new Array();
            _loc5_ = new Player();
            _loc5_.setNickname(_xml.fighting.organisms.item[_loc3_].@nickname);
            _loc5_.setFaceUrl2(_xml.fighting.organisms.item[_loc3_].@face);
            _loc5_.setVipLevel(_xml.fighting.organisms.item[_loc3_].@vip_grade);
            _loc5_.setVipTime(_xml.fighting.organisms.item[_loc3_].@vip_etime);
            _loc6_ = new Organism();
            _loc6_.setBattleE(Number(_xml.fighting.organisms.item[_loc3_].@fighting));
            _loc6_.setId(_xml.fighting.organisms.item[_loc3_].@id);
            _loc6_.setGrade(_xml.fighting.organisms.item[_loc3_].@grade);
            _loc6_.setOrderId(_xml.fighting.organisms.item[_loc3_].@prototype_id);
            _loc6_.setQuality_name(_xml.fighting.organisms.item[_loc3_].@quality);
            _loc6_.setGiftData(_xml.fighting.organisms.item[_loc3_].tals);
            _loc6_.setSoulLevel(_xml.fighting.organisms.item[_loc3_].soul);
            for(_loc7_ in _xml.fighting.organisms.item[_loc3_].skills.item)
            {
               _loc8_ = new Skill();
               _loc8_.setName(_xml.fighting.organisms.item[_loc3_].skills.item[_loc7_].@name);
               _loc8_.setGrade(_xml.fighting.organisms.item[_loc3_].skills.item[_loc7_].@grade);
               _loc8_.setId(_xml.fighting.organisms.item[_loc3_].skills.item[_loc7_].@id);
               _loc8_.setEffect(_xml.fighting.organisms.item[_loc3_].skills.item[_loc7_].@organism_attr);
               _loc6_.addSkill(_loc8_);
            }
            _loc4_.push(_loc6_);
            _loc4_.push(_loc5_);
            _loc4_.push(_loc1_);
            _loc2_.push(_loc4_);
            _loc1_++;
         }
         return _loc2_;
      }
   }
}


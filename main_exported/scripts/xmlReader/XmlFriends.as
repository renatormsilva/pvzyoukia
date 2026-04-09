package xmlReader
{
   import entity.Player;
   import flash.utils.getQualifiedClassName;
   
   public class XmlFriends extends XmlBaseReader
   {
      
      public function XmlFriends(param1:String)
      {
         super();
         super.init(param1,getQualifiedClassName(this));
      }
      
      public function getNowPage() : int
      {
         return _xml.friends.@current;
      }
      
      public function getMaxPage() : int
      {
         return _xml.friends.@page_count;
      }
      
      public function getPageNum() : int
      {
         return _xml.friends.@page_size;
      }
      
      public function getFriends() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Player = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.friends.item.@id)
         {
            _loc3_ = new Player();
            _loc3_.setId(Number(_xml.friends.item[_loc2_].@id));
            _loc3_.setNickname(_xml.friends.item[_loc2_].@name);
            _loc3_.setGrade(_xml.friends.item[_loc2_].@grade);
            _loc3_.setCharm(_xml.friends.item[_loc2_].@charm);
            _loc3_.setIsGardenOrg(_xml.friends.item[_loc2_].@is_use_garden);
            _loc3_.setFaceUrl2(_xml.friends.item[_loc2_].@face);
            _loc3_.setVipLevel(_xml.friends.item[_loc2_].@vip_grade);
            _loc3_.setVipTime(_xml.friends.item[_loc2_].@vip_etime);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
   }
}


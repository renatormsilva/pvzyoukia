package xmlReader.firstPage
{
   import entity.FriendPrizeInfo;
   import entity.InvitePrize;
   import entity.Organism;
   import entity.Tool;
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlInvitePrizeInvite extends XmlBaseReader
   {
      
      public function XmlInvitePrizeInvite(param1:String)
      {
         super();
         super.init(param1,getQualifiedClassName(this));
      }
      
      public function getInviteRule() : Array
      {
         var _loc2_:String = null;
         var _loc3_:InvitePrize = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Organism = null;
         var _loc9_:Tool = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.invite_reward.item.@id)
         {
            _loc3_ = new InvitePrize();
            _loc3_.setId(_xml.invite_reward.item[_loc2_].@id);
            _loc3_.setCost(_xml.invite_reward.item[_loc2_].@num);
            _loc4_ = new Array();
            _loc5_ = new Array();
            for(_loc6_ in _xml.invite_reward.item[_loc2_].organisms.item.@id)
            {
               _loc8_ = new Organism();
               _loc8_.setOrderId(_xml.invite_reward.item[_loc2_].organisms.item[_loc6_].@id);
               _loc4_.push(_loc8_);
            }
            _loc3_.setOrgs(_loc4_);
            for(_loc7_ in _xml.invite_reward.item[_loc2_].tools.item.@id)
            {
               _loc9_ = new Tool(_xml.invite_reward.item[_loc2_].tools.item[_loc7_].@id);
               _loc9_.setNum(_xml.invite_reward.item[_loc2_].tools.item[_loc7_].@amount);
               _loc5_.push(_loc9_);
            }
            _loc3_.setTools(_loc5_);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getInvitePrizes() : InvitePrize
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Organism = null;
         var _loc7_:Tool = null;
         var _loc1_:InvitePrize = new InvitePrize();
         _loc1_.setId(_xml.invite_reward.@id);
         _loc1_.setCost(_xml.invite_reward.@num);
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         for(_loc4_ in _xml.invite_reward.organisms.item.@id)
         {
            _loc6_ = new Organism();
            _loc6_.setOrderId(_xml.invite_reward.organisms.item[_loc4_].@id);
            _loc2_.push(_loc6_);
         }
         _loc1_.setOrgs(_loc2_);
         for(_loc5_ in _xml.invite_reward.tools.item.@id)
         {
            _loc7_ = new Tool(_xml.invite_reward.tools.item[_loc5_].@id);
            _loc7_.setNum(_xml.invite_reward.tools.item[_loc5_].@amount);
            _loc3_.push(_loc7_);
         }
         _loc1_.setTools(_loc3_);
         return _loc1_;
      }
      
      public function getFriendPrizeGrade() : int
      {
         return _xml.reward.@grade;
      }
      
      public function getFriendPrizeMoney() : int
      {
         return _xml.reward.@money;
      }
      
      public function getFriendPrizeCharm() : int
      {
         return _xml.reward.@charm;
      }
      
      public function getFriendPrizeFriends() : Array
      {
         var _loc2_:String = null;
         var _loc3_:FriendPrizeInfo = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.down_line.item.@id)
         {
            _loc3_ = new FriendPrizeInfo();
            _loc3_.setId(_xml.down_line.item[_loc2_].@id);
            _loc3_.setNickName(_xml.down_line.item[_loc2_].@nickname);
            _loc3_.setGrade(_xml.down_line.item[_loc2_].@grade);
            _loc3_.setBigFace(_xml.down_line.item[_loc2_].@big_face);
            _loc3_.setSmallFace(_xml.down_line.item[_loc2_].@small_face);
            _loc3_.setStarts(_xml.down_line.item[_loc2_].@starts);
            _loc3_.setVipTime(_xml.down_line.item[_loc2_].@vip_etime);
            _loc3_.setVipLevel(_xml.down_line.item[_loc2_].@vip_grade);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function getFriendMoney() : int
      {
         return _xml.invite_up_raward.@money;
      }
      
      public function getFriendCharm() : int
      {
         return _xml.invite_up_raward.@charm;
      }
   }
}


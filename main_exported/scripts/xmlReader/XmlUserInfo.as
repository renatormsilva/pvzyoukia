package xmlReader
{
   import entity.Player;
   import flash.utils.getQualifiedClassName;
   import manager.PlayerManager;
   
   public class XmlUserInfo extends XmlBaseReader
   {
      
      public function XmlUserInfo(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getPlayer() : Player
      {
         var _loc1_:Player = new Player();
         _loc1_.setId(Number(_xml.user.@id));
         _loc1_.setNickname(_xml.user.@name);
         _loc1_.setMoney(_xml.user.@money);
         _loc1_.setRMB(_xml.user.@rmb_money);
         _loc1_.setHonour(_xml.user.@honor);
         _loc1_.setCharm(_xml.user.@charm);
         _loc1_.setGrade(_xml.user.grade.@id);
         _loc1_.setExp(_xml.user.grade.@exp);
         _loc1_.setWins(_xml.user.@wins);
         _loc1_.setLastArenaDate(_xml.user.arena_rank_date.@old_start + "-" + _xml.user.arena_rank_date.@old_end);
         _loc1_.setArenaDate(_xml.user.arena_rank_date.@the_start + "-" + _xml.user.arena_rank_date.@the_end);
         _loc1_.setEveryDayPrize(_xml.user.@date_award);
         _loc1_.setKey(_xml.user.@lottery_key);
         _loc1_.setBannerNum(_xml.user.@banner_num);
         _loc1_.setBannerUrl(_xml.user.@banner_url);
         if(_xml.user.@state == 1)
         {
            _loc1_.setIsActivity(false);
         }
         else
         {
            _loc1_.setIsActivity(true);
         }
         _loc1_.setInviteAmount(_xml.user.@invite_amount);
         _loc1_.setUseInviteNum(_xml.user.@use_invite_num);
         _loc1_.setMaxUseInviteNum(_xml.user.@max_use_invite_num);
         _loc1_.setFaceUrl1(_xml.user.@face_url);
         _loc1_.setFaceUrl2(_xml.user.@face);
         _loc1_.setTreeHeight(_xml.user.tree.@height);
         _loc1_.setTreeTimes(_xml.user.tree.@today_max - _xml.user.tree.@today);
         _loc1_.setFriendsNum(_xml.user.friends.@amount);
         _loc1_.setFriendsMaxpage(_xml.user.friends.@page_count);
         _loc1_.setFriendsNowpage(_xml.user.friends.@current);
         _loc1_.setFriendsPagenum(_xml.user.friends.@page_size);
         if(_xml.user.@is_new == 1)
         {
            _loc1_.setIsNew(true);
         }
         else
         {
            _loc1_.setIsNew(false);
         }
         _loc1_.setExp_max(_xml.user.grade.@exp_max);
         _loc1_.setHunts(_xml.user.cave.@max_amount);
         _loc1_.setNowHunts(_xml.user.cave.@amount);
         _loc1_.setBattleOpenGrade(_xml.user.cave.@open_grid_grade);
         _loc1_.setBattleOpenMoney(_xml.user.cave.@open_grid_money);
         _loc1_.setExp_min(_xml.user.grade.@exp_min);
         _loc1_.setToadyMaxExp(_xml.user.grade.@today_exp_max);
         _loc1_.setTodayExp(_xml.user.grade.@today_exp);
         _loc1_.setFriendLands(_xml.user.garden.@amount);
         _loc1_.setBattle_num(_xml.user.@open_cave_grid);
         _loc1_.setNowflowerpotNum(_xml.user.garden.@garden_organism_amount);
         _loc1_.setFlowerpotNum(_xml.user.garden.@organism_amount);
         _loc1_.setFirstLogin(_xml.user.@login_reward == 0 ? false : true);
         _loc1_.setVipTime(_xml.user.@vip_etime);
         _loc1_.setVipAutoGain(_xml.user.@is_auto);
         _loc1_.setVipLevel(_xml.user.@vip_grade);
         _loc1_.setVipEXP(_xml.user.@vip_exp);
         _loc1_.setVipAutoRevert(_xml.user.@vip_restore_hp);
         _loc1_.setHonour(_xml.user.territory.@honor);
         _loc1_.setOccupyNum(_xml.user.territory.@amount);
         _loc1_.setOccupyMaxNum(_xml.user.territory.@max_amount);
         _loc1_.setRewardDaily(_xml.user.@reward_daily);
         _loc1_.setHasActiveAreward(_xml.user.@has_reward_once);
         _loc1_.setHasActiveBreward(_xml.user.@has_reward_sum);
         _loc1_.setHasConsumeBreward(_xml.user.@has_reward_cus);
         _loc1_.setWorldTimes(_xml.user.fuben.@fuben_lcc);
         _loc1_.setFirstRecharge(_xml.user.@has_reward_first);
         _loc1_.setActivtyBtnStaus(_xml.user.@hasActivitys);
         _loc1_.setSeverBattleStaus(_xml.user.@serverbattle_status);
         if(_loc1_.getBattle_num() > PlayerManager.ARENA_ORG_NUM)
         {
            _loc1_.setArenaOrgNum(PlayerManager.ARENA_ORG_NUM);
         }
         else
         {
            _loc1_.setArenaOrgNum(_loc1_.getBattle_num());
         }
         _loc1_.setStoneChaCount(_xml.user.@stone_cha_count);
         _loc1_.setCopyActiveState(_xml.user.copy_active.@state);
         _loc1_.setShakeDefy(_xml.user.copy_zombie.@state);
         _loc1_.setIsRegistration(Boolean(int(_xml.user.@registrationReward)));
         if(int(_xml.user.@IsNewTaskSystem) == 1)
         {
            _loc1_.IsNewTaskSystem = true;
         }
         else
         {
            _loc1_.IsNewTaskSystem = false;
         }
         return _loc1_;
      }
      
      public function getFirstLogin() : int
      {
         return _xml.user.@login_reward;
      }
      
      public function getFriends(param1:Player) : Array
      {
         var _loc3_:String = null;
         var _loc4_:Player = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in _xml.user.friends.item.@id)
         {
            _loc4_ = new Player();
            _loc4_.setCharm(_xml.user.friends.item[_loc3_].@charm);
            _loc4_.setId(Number(_xml.user.friends.item[_loc3_].@id));
            _loc4_.setNickname(_xml.user.friends.item[_loc3_].@name);
            _loc4_.setGrade(_xml.user.friends.item[_loc3_].@grade);
            _loc4_.setIsGardenOrg(_xml.user.friends.item[_loc3_].@is_use_garden);
            _loc4_.setVipLevel(_xml.user.friends.item[_loc3_].@vip_grade);
            _loc4_.setVipTime(_xml.user.friends.item[_loc3_].@vip_etime);
            _loc4_.setFaceUrl2(_xml.user.friends.item[_loc3_].@face);
            _loc2_.push(_loc4_);
            param1.addFriend(_loc4_);
         }
         return _loc2_;
      }
   }
}


package pvz.registration.data
{
   public class SignDataVo
   {
      
      public var day:int;
      
      public var state:int;
      
      public var reward:RewardData;
      
      public function SignDataVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.day = param1.id;
         this.state = param1.state;
         this.reward = new RewardData();
         this.reward.setData(param1.rewards[0]);
      }
   }
}


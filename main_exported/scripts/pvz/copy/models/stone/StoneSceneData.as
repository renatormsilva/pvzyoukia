package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   
   public class StoneSceneData implements IVo
   {
      
      private var sIcons:Vector.<StoneSceneIconData> = null;
      
      private var challege_count:int;
      
      private var buy_max_cout:int;
      
      private var time:Number;
      
      public function StoneSceneData()
      {
         super();
      }
      
      public function getSIconData() : Vector.<StoneSceneIconData>
      {
         return this.sIcons;
      }
      
      public function getChallegeCount() : int
      {
         return this.challege_count;
      }
      
      public function getBuyMaxChallegeCount() : int
      {
         return this.buy_max_cout;
      }
      
      public function setBuyMaxChallegeCount(param1:int) : void
      {
         this.buy_max_cout = param1;
      }
      
      public function getNextTime() : Number
      {
         return this.time;
      }
      
      public function decode(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:StoneSceneIconData = null;
         var _loc2_:Object = param1.chap_info;
         this.challege_count = param1.cha_count;
         this.time = param1.next_time;
         this.buy_max_cout = param1.buy_max_count;
         PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(this.challege_count);
         this.sIcons = new Vector.<StoneSceneIconData>();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new StoneSceneIconData();
            _loc4_.decode(_loc3_);
            this.sIcons.push(_loc4_);
         }
      }
   }
}


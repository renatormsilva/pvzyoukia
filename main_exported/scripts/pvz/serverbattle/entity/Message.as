package pvz.serverbattle.entity
{
   public class Message
   {
      
      private var _name1:SubMessage;
      
      private var _name2:SubMessage;
      
      private var _winStats:SubMessage;
      
      private var _propName:SubMessage;
      
      private var _battleStaus:SubMessage;
      
      public function Message()
      {
         super();
      }
      
      public function decodeData(param1:Object) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = param1 as Array;
         this._name1 = new SubMessage();
         this._name1.color = Number(_loc2_[0].c);
         this._name1.txt = _loc2_[0].sub;
         this._winStats = new SubMessage();
         this._winStats.color = Number(_loc2_[1].c);
         this._winStats.txt = _loc2_[1].sub;
         this._name2 = new SubMessage();
         this._name2.color = Number(_loc2_[2].c);
         this._name2.txt = _loc2_[2].sub;
         this._propName = new SubMessage();
         this._propName.color = Number(_loc2_[3].c);
         this._propName.txt = _loc2_[3].sub;
         this._battleStaus = new SubMessage();
         this._battleStaus.color = Number(_loc2_[4].c);
         this._battleStaus.txt = _loc2_[4].sub;
      }
      
      public function getName1() : SubMessage
      {
         return this._name1;
      }
      
      public function getName2() : SubMessage
      {
         return this._name2;
      }
      
      public function getWinStats() : SubMessage
      {
         return this._winStats;
      }
      
      public function getPropName() : SubMessage
      {
         return this._propName;
      }
      
      public function getBattleStaus() : SubMessage
      {
         return this._battleStaus;
      }
   }
}


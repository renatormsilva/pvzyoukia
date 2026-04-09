package pvz.registration.data
{
   import entity.GameMoney;
   import entity.Rmb;
   import entity.Tool;
   
   public class RewardData
   {
      
      public var type:int;
      
      public var tool:Tool;
      
      public var gameMoney:GameMoney;
      
      public var rmb:Rmb;
      
      public function RewardData()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
         this.type = param1.type;
         switch(this.type)
         {
            case 1:
               if(!this.tool)
               {
                  this.tool = new Tool(0);
               }
               if("object" != typeof param1.data)
               {
                  this.tool.setOrderId(param1.data);
                  this.tool.setNum(1);
               }
               else
               {
                  this.tool.setOrderId(param1.data.id);
                  this.tool.setNum(param1.data.num);
               }
               break;
            case 2:
               if(!this.rmb)
               {
                  this.rmb = new Rmb();
               }
               if("object" != typeof param1.data)
               {
                  this.rmb.setValue(param1.data);
               }
               else
               {
                  this.rmb.setValue(param1.data.num);
               }
               break;
            case 3:
               if(!this.gameMoney)
               {
                  this.gameMoney = new GameMoney();
               }
               if("object" != typeof param1.data)
               {
                  this.gameMoney.decode(param1.data);
               }
               else
               {
                  this.gameMoney.decode(param1.data.num);
               }
         }
         param1 = null;
      }
      
      public function data() : *
      {
         var _loc1_:* = undefined;
         switch(this.type)
         {
            case 1:
               _loc1_ = this.tool;
               break;
            case 2:
               _loc1_ = this.rmb;
               break;
            case 3:
               _loc1_ = this.gameMoney;
         }
         return _loc1_;
      }
      
      public function destroy() : void
      {
         this.tool = null;
         this.gameMoney = null;
         this.rmb = null;
      }
   }
}


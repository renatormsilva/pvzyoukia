package entity
{
   import xmlReader.config.XmlToolsConfig;
   
   public class Tool
   {
      
      internal var _num:int = 0;
      
      internal var _orderId:int = 0;
      
      internal var ihandbook:int = 0;
      
      public function Tool(param1:int)
      {
         super();
         this.setOrderId(param1);
      }
      
      public function getUseLevel() : uint
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"use_level").use_level;
      }
      
      public function getExpl() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"expl").expl;
      }
      
      public function getIHandbook() : int
      {
         return this.ihandbook;
      }
      
      public function getLotteryName() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"lottery_name").lottery_name;
      }
      
      public function getName() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"name").name;
      }
      
      public function getNum() : Number
      {
         return this._num;
      }
      
      public function getOrderId() : int
      {
         return this._orderId;
      }
      
      public function getPicId() : int
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"picId").picId;
      }
      
      public function getQuality() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"quality").quality;
      }
      
      public function getSell_price() : int
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"sell_price").sell_price;
      }
      
      public function getType() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"type").type;
      }
      
      public function getTypeName() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"typeName").typeName;
      }
      
      public function getUse_condition() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"use_condition").use_condition;
      }
      
      public function getUse_result() : String
      {
         return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"use_result").use_result;
      }
      
      public function setIHandbook(param1:int) : void
      {
         this.ihandbook = param1;
      }
      
      public function setNum(param1:int) : void
      {
         this._num = param1;
      }
      
      public function setOrderId(param1:int) : void
      {
         this._orderId = param1;
      }
   }
}


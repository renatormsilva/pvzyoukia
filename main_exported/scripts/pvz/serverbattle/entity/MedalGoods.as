package pvz.serverbattle.entity
{
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   
   public class MedalGoods
   {
      
      private var _id:int;
      
      private var _orderId:int;
      
      private var _num:int;
      
      private var _type:String;
      
      private var _cost:int;
      
      private var _seq_id:int;
      
      private var _des_type:String;
      
      public function MedalGoods()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._id = param1.id;
         this._type = param1.type;
         this._seq_id = param1.seq;
         this._num = param1.num;
         this._orderId = param1.p_id;
         this._cost = param1.price;
      }
      
      public function getSeqId() : int
      {
         return this._seq_id;
      }
      
      public function getOrderId() : int
      {
         return this._orderId;
      }
      
      public function getNum() : int
      {
         return this._num;
      }
      
      public function setNum(param1:int) : void
      {
         this._num = param1;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getName() : String
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this._orderId,"name").name;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this._orderId,"name").orgname;
      }
      
      public function getCost() : int
      {
         return this._cost;
      }
      
      public function getUse_result() : String
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"use_result").use_result;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"use_result").use_result;
      }
      
      public function getType() : int
      {
         if(this._type == "tool")
         {
            return 2;
         }
         return 1;
      }
      
      public function getPicid() : int
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"picId").picId;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"picId").picId;
      }
      
      public function getDesType() : String
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"typeName").typeName;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"type").type;
      }
      
      public function getExpl() : String
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"expl").expl;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"expl").expl;
      }
      
      public function getUse_condition() : String
      {
         if(this._type == "tool")
         {
            return XmlToolsConfig.getInstance().getBaseToolAttribute(this.getOrderId(),"use_condition").use_condition;
         }
         return XmlOrganismConfig.getInstance().getBaseOrganismAttribute(this.getOrderId(),"use_condition").use_condition;
      }
   }
}


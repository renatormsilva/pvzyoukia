package entity
{
   public class Goods
   {
      
      internal var change_id:int = 0;
      
      internal var change_num:int = 0;
      
      internal var expl:String = "";
      
      internal var goodsId:int = 0;
      
      internal var id:int = 0;
      
      internal var max_num:int = 0;
      
      internal var name:String = "";
      
      internal var picType:String = "";
      
      internal var pic_id:int = 0;
      
      internal var purchase_price:int = 0;
      
      internal var type:String = "";
      
      internal var use_condition:String = "";
      
      internal var use_result:String = "";
      
      internal var goodsDiscount:int = 0;
      
      internal var seq_Id:int = 0;
      
      public function Goods()
      {
         super();
      }
      
      public function getSeqId() : int
      {
         return this.seq_Id;
      }
      
      public function setSeqId(param1:int) : void
      {
         this.seq_Id = param1;
      }
      
      public function getGoodsDiscount() : int
      {
         return this.goodsDiscount;
      }
      
      public function setGoodsDiscount(param1:int) : void
      {
         this.goodsDiscount = param1;
      }
      
      public function getChangeId() : int
      {
         return this.change_id;
      }
      
      public function getChangeNum() : int
      {
         return this.change_num;
      }
      
      public function getExpl() : String
      {
         return this.expl;
      }
      
      public function getGoodsId() : int
      {
         return this.goodsId;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getMaxNum() : int
      {
         return this.max_num;
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function getPicId() : int
      {
         return this.pic_id;
      }
      
      public function getPicType() : String
      {
         return this.picType;
      }
      
      public function getPurchasePrice() : int
      {
         return this.purchase_price;
      }
      
      public function getType() : String
      {
         return this.type;
      }
      
      public function getUseCondition() : String
      {
         return this.use_condition;
      }
      
      public function getUseResult() : String
      {
         return this.use_result;
      }
      
      public function setChangeId(param1:int) : void
      {
         this.change_id = param1;
      }
      
      public function setChangeNum(param1:int) : void
      {
         this.change_num = param1;
      }
      
      public function setExpl(param1:String) : void
      {
         this.expl = param1;
      }
      
      public function setGoodsId(param1:int) : void
      {
         this.goodsId = param1;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function setMaxNum(param1:int) : void
      {
         this.max_num = param1;
      }
      
      public function setName(param1:String) : void
      {
         this.name = param1;
      }
      
      public function setPicId(param1:int) : void
      {
         this.pic_id = param1;
      }
      
      public function setPicType(param1:String) : void
      {
         this.picType = param1;
      }
      
      public function setPurchasePrice(param1:int) : void
      {
         this.purchase_price = param1;
      }
      
      public function setType(param1:String) : void
      {
         this.type = param1;
      }
      
      public function setUseCondition(param1:String) : void
      {
         this.use_condition = param1;
      }
      
      public function setUseResult(param1:String) : void
      {
         this.use_result = param1;
      }
   }
}


package pvz.shop.rpc
{
   import entity.Goods;
   import entity.Organism;
   import pvz.shop.ShopWindow;
   import xmlReader.config.XmlToolsConfig;
   
   public class Shop_rpc
   {
      
      public function Shop_rpc()
      {
         super();
      }
      
      public function getGood(param1:int, param2:Object) : Goods
      {
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(this.getShopGoods(param2[_loc4_]).getId() == param1)
            {
               return this.getShopGoods(param2[_loc4_]);
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getShopArray(param1:Object) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.getShopGoods(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getShopGoods(param1:Object) : Goods
      {
         var _loc3_:Organism = null;
         var _loc2_:Goods = new Goods();
         if(param1.type == ShopWindow.ORG)
         {
            _loc3_ = new Organism();
            _loc3_.setOrderId(param1.p_id);
            _loc2_.setId(param1.p_id);
            _loc2_.setSeqId(param1.seq);
            _loc2_.setGoodsDiscount(param1.discount);
            _loc2_.setPicId(_loc3_.getPicId());
            _loc2_.setName(_loc3_.getName());
            _loc2_.setType(_loc3_.getType());
            _loc2_.setPurchasePrice(param1.price);
            _loc2_.setMaxNum(param1.num);
            _loc2_.setUseCondition(_loc3_.getUse_condition());
            _loc2_.setUseResult(_loc3_.getUse_result());
            _loc2_.setExpl(_loc3_.getExpl());
            _loc2_.setPicType(param1.type);
            _loc2_.setGoodsId(param1.id);
            _loc2_.setChangeId(param1.exchange_tool_id);
            _loc2_.setChangeNum(param1.num);
         }
         else if(param1.type == ShopWindow.TOOL)
         {
            _loc2_.setId(param1.p_id);
            _loc2_.setGoodsDiscount(param1.discount);
            _loc2_.setSeqId(param1.seq);
            _loc2_.setPicId(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getPicId());
            _loc2_.setName(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getName());
            _loc2_.setType(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getTypeName());
            _loc2_.setPurchasePrice(param1.price);
            _loc2_.setMaxNum(param1.num);
            _loc2_.setUseCondition(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getUse_condition());
            _loc2_.setUseResult(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getUse_result());
            _loc2_.setExpl(XmlToolsConfig.getInstance().getToolAttribute(param1.p_id).getExpl());
            _loc2_.setPicType(param1.type);
            _loc2_.setGoodsId(param1.id);
            _loc2_.setChangeId(param1.exchange_tool_id);
            _loc2_.setChangeNum(param1.num);
         }
         return _loc2_;
      }
   }
}


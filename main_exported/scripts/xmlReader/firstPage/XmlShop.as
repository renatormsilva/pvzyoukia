package xmlReader.firstPage
{
   import entity.Goods;
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlOrganismConfig;
   import xmlReader.config.XmlToolsConfig;
   
   public class XmlShop extends XmlBaseReader
   {
      
      public static var ORG:String = "organisms";
      
      public static var TOOL:String = "tool";
      
      public function XmlShop(param1:String)
      {
         super();
         init(param1,getQualifiedClassName(this));
      }
      
      public function getCharges() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.shop.money;
      }
      
      public function getRushTime() : int
      {
         if(_xml == null)
         {
            return 0;
         }
         return _xml.shop.time;
      }
      
      public function getAllGoods() : Array
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.shop.goods.@id)
         {
            _loc3_ = _xml.shop.goods[_loc2_].type;
            _loc4_ = int(_xml.shop.goods[_loc2_].id);
            _loc5_ = int(_xml.shop.goods[_loc2_].@id);
            _loc6_ = int(_xml.shop.goods[_loc2_].price);
            _loc7_ = int(_xml.shop.goods[_loc2_].num);
            _loc1_.push(this.getGoods(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_));
         }
         return _loc1_;
      }
      
      public function getGoods(param1:String, param2:int, param3:int, param4:int, param5:int = 1) : Goods
      {
         var _loc6_:Array = new Array(9);
         var _loc7_:Goods = new Goods();
         if(param1 == ORG)
         {
            _loc7_.setId(param2);
            _loc7_.setName(XmlOrganismConfig.getInstance().getOrganismAttribute(param2).getName());
            _loc7_.setType(XmlOrganismConfig.getInstance().getOrganismAttribute(param2).getType());
            _loc7_.setPurchasePrice(param4);
            _loc7_.setMaxNum(1);
            _loc7_.setUseCondition(XmlOrganismConfig.getInstance().getOrganismAttribute(param2).getUse_condition());
            _loc7_.setUseResult(XmlOrganismConfig.getInstance().getOrganismAttribute(param2).getUse_result());
            _loc7_.setExpl(XmlOrganismConfig.getInstance().getOrganismAttribute(param2).getExpl());
            _loc7_.setPicType(param1);
            _loc7_.setGoodsId(param3);
         }
         else if(param1 == TOOL)
         {
            _loc7_.setId(param2);
            _loc7_.setName(XmlToolsConfig.getInstance().getToolAttribute(param2).getName());
            _loc7_.setType(XmlToolsConfig.getInstance().getToolAttribute(param2).getTypeName());
            _loc7_.setPurchasePrice(param4);
            _loc7_.setMaxNum(param5);
            _loc7_.setUseCondition(XmlToolsConfig.getInstance().getToolAttribute(param2).getUse_condition());
            _loc7_.setUseResult(XmlToolsConfig.getInstance().getToolAttribute(param2).getUse_result());
            _loc7_.setExpl(XmlToolsConfig.getInstance().getToolAttribute(param2).getExpl());
            _loc7_.setPicType(param1);
            _loc7_.setGoodsId(param3);
         }
         return _loc7_;
      }
   }
}


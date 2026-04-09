package xmlReader
{
   import entity.Tool;
   import flash.utils.getQualifiedClassName;
   
   public class XmlTree extends XmlBaseReader
   {
      
      public function XmlTree(param1:String)
      {
         super();
         super.init(param1,getQualifiedClassName(this));
      }
      
      public function getTreeMessage() : String
      {
         return _xml.tree.@message;
      }
      
      public function getTreeHeight() : int
      {
         return _xml.tree.@height;
      }
      
      public function getTreeAwards() : Array
      {
         var _loc2_:String = null;
         var _loc3_:Tool = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in _xml.awards.tools.item.@id)
         {
            _loc3_ = new Tool(_xml.awards.tools.item[_loc2_].@id);
            _loc3_.setNum(_xml.awards.tools.item[_loc2_].@amount);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
   }
}


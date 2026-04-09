package xmlReader.firstPage
{
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlOpenStorage extends XmlBaseReader
   {
      
      public function XmlOpenStorage(param1:String)
      {
         super();
         super.init(param1,getQualifiedClassName(this));
      }
      
      public function getStorageOrgNum() : int
      {
         return _xml.warehouse.@organism;
      }
      
      public function getUserMoney() : int
      {
         return _xml.user.@money;
      }
      
      public function getStorageToolNum() : int
      {
         return _xml.warehouse.@tool;
      }
      
      public function getOpenGrade() : int
      {
         return _xml.next_open_info.@grade;
      }
      
      public function getOpenMoney() : int
      {
         return _xml.next_open_info.@money;
      }
   }
}


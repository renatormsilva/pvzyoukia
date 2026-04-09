package xmlReader.firstPage
{
   import flash.utils.getQualifiedClassName;
   import xmlReader.XmlBaseReader;
   
   public class XmlDelSkill extends XmlBaseReader
   {
      
      public function XmlDelSkill(param1:String)
      {
         super();
         super.init(param1,getQualifiedClassName(this));
      }
   }
}


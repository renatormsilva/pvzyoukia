package core.ui.panel
{
   import com.res.IDestroy;
   import flash.utils.Dictionary;
   
   public class BaseMediator
   {
      
      private var ui_dic:Dictionary;
      
      public function BaseMediator()
      {
         super();
         this.ui_dic = new Dictionary(true);
      }
      
      protected function getView(param1:Class) : Object
      {
         if(this.ui_dic[param1] == null)
         {
            this.ui_dic[param1] = new param1();
         }
         return this.ui_dic[param1];
      }
      
      protected function hasCreated(param1:Class) : Boolean
      {
         if(this.ui_dic[param1] == null)
         {
            return false;
         }
         return true;
      }
      
      protected function removeView(param1:Class) : void
      {
         if(this.ui_dic[param1] == null)
         {
            return;
         }
         (this.ui_dic[param1] as IDestroy).destroy();
         delete this.ui_dic[param1];
      }
      
      protected function clear() : void
      {
         this.ui_dic = null;
      }
   }
}


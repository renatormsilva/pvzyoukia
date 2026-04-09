package tip
{
   import com.res.IDestroy;
   import flash.display.Sprite;
   
   public class Tips extends Sprite implements IDestroy
   {
      
      public function Tips()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      public function destroy() : void
      {
      }
   }
}


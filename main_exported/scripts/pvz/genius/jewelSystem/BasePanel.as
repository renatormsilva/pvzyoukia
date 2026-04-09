package pvz.genius.jewelSystem
{
   import com.res.IDestroy;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import utils.GetDomainRes;
   
   public class BasePanel extends Sprite implements IDestroy
   {
      
      protected var _ui:MovieClip;
      
      public function BasePanel(param1:String)
      {
         super();
         if(param1 == "")
         {
            return;
         }
         this._ui = GetDomainRes.getMoveClip(param1);
         if(this._ui)
         {
            addChild(this._ui);
         }
      }
      
      public function destroy() : void
      {
      }
   }
}


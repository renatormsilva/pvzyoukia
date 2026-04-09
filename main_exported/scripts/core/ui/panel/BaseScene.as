package core.ui.panel
{
   import com.res.IDestroy;
   import core.interfaces.IScene;
   import flash.display.Sprite;
   
   public class BaseScene extends Sprite implements IScene, IDestroy
   {
      
      public function BaseScene()
      {
         super();
      }
      
      public function onShow() : void
      {
         PlantsVsZombies._node.addChild(this);
      }
      
      public function onHide() : void
      {
         PlantsVsZombies._node.removeChild(this);
      }
      
      public function destroy() : void
      {
      }
   }
}


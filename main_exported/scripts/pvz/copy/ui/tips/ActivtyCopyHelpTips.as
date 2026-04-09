package pvz.copy.ui.tips
{
   import core.ui.tips.CHtmlTextField;
   import flash.display.Sprite;
   
   public class ActivtyCopyHelpTips extends Sprite
   {
      
      private var _ctf:CHtmlTextField;
      
      public function ActivtyCopyHelpTips()
      {
         super();
         this._ctf = new CHtmlTextField(300,5);
         addChild(this._ctf);
      }
      
      public function showTips(param1:String) : void
      {
         this._ctf.setText(param1);
         PlantsVsZombies._node.addChild(this);
         this._ctf.x = 250;
         this._ctf.y = 90;
      }
      
      public function hideTips() : void
      {
         this._ctf.destory();
         PlantsVsZombies._node.removeChild(this);
      }
   }
}


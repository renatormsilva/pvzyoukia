package pvz.copy.ui.sprites
{
   import core.interfaces.IVo;
   import flash.display.SimpleButton;
   import pvz.copy.models.stone.StoneCData;
   import pvz.copy.models.stone.StoneSceneIconData;
   import utils.FuncKit;
   
   public class StoneSceneIcon
   {
      
      private var sid:int;
      
      private var background:SimpleButton;
      
      private var m_sceneIconData:StoneSceneIconData;
      
      private var closing:Boolean = false;
      
      public var localizerCall:Function;
      
      public function StoneSceneIcon(param1:SimpleButton, param2:int)
      {
         super();
         this.sid = param2;
         this.background = param1;
      }
      
      public function getId() : int
      {
         return this.sid;
      }
      
      public function getClosingAttr() : Boolean
      {
         return this.closing;
      }
      
      public function getIconData() : StoneSceneIconData
      {
         return this.m_sceneIconData;
      }
      
      public function upData(param1:IVo) : void
      {
         this.m_sceneIconData = param1 as StoneSceneIconData;
         if(this.m_sceneIconData.getActive() == StoneCData.closing)
         {
            this.gateCloing();
            return;
         }
         if(this.m_sceneIconData.getActive() == StoneCData.openning)
         {
            this.gateLighting();
         }
      }
      
      private function gateLighting() : void
      {
         this.background.filters = null;
         this.closing = false;
         var _loc1_:Number = this.background.x + this.background.width / 2;
         var _loc2_:Number = this.background.y + this.background.width / 2;
         this.localizerCall(_loc1_,_loc2_);
      }
      
      private function gateCloing() : void
      {
         this.closing = true;
         FuncKit.setNoColor(this.background);
      }
      
      public function clearAll() : void
      {
         this.background.filters = null;
         this.background = null;
         this.m_sceneIconData = null;
      }
   }
}


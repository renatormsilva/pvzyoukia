package pvz.shaketree.view
{
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import node.Icon;
   
   public class JewelPrizeLabel extends Sprite
   {
      
      public function JewelPrizeLabel(param1:Tool)
      {
         super();
         Icon.setJewelIcon(this as DisplayObjectContainer,param1.getOrderId(),1);
      }
   }
}


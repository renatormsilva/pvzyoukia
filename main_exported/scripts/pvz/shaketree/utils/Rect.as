package pvz.shaketree.utils
{
   import flash.display.Sprite;
   
   public class Rect extends Sprite
   {
      
      public function Rect(param1:Number, param2:Number, param3:uint = 65280, param4:Number = 1)
      {
         super();
         this.graphics.beginFill(param3,param4);
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
      }
   }
}


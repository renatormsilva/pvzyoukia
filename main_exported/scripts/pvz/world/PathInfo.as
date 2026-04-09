package pvz.world
{
   import flash.geom.Point;
   
   public class PathInfo
   {
      
      public var start:Point = null;
      
      public var end:Point = null;
      
      public var now:Point = null;
      
      public function PathInfo(param1:Point, param2:Point, param3:Point)
      {
         super();
         this.start = param1;
         this.end = param2;
         this.now = param3;
      }
   }
}


package utils
{
   import flash.display.DisplayObject;
   
   public class StringMovieClip
   {
      
      public static var picNames:Array = ["0","1","2","3","4","5","6","7","8","9","x","c","p","w","h","d","y","a","lb","rb","star","Plus","no","Per"];
      
      public function StringMovieClip()
      {
         super();
      }
      
      public static function getStringImage(param1:String, param2:String, param3:Number = 0) : DisplayObject
      {
         var _loc4_:MovieClipManagement = new MovieClipManagement(picNames,param2,param1.toString());
         _loc4_.transfor(param3);
         return _loc4_.outputObject as DisplayObject;
      }
   }
}


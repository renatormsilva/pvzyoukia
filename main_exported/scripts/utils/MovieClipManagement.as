package utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import zlib.utils.DomainAccess;
   
   public class MovieClipManagement extends BaseObjectManagement
   {
      
      public function MovieClipManagement(param1:Array, param2:String, param3:String = "", param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function transfor(param1:Number = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(picNames.length > 0)
         {
            outputObject = new MovieClip();
            _loc2_ = 0;
            while(_loc2_ < str.length)
            {
               _loc3_ = this.findObject(str.substr(_loc2_,1));
               if(_loc3_ != null)
               {
                  if(_loc2_ == str.length - 1 && outputObject.numChildren == 0)
                  {
                     outputObject = _loc3_;
                  }
                  else
                  {
                     outputObject.addChild(_loc3_);
                     doLayout(param1);
                  }
               }
               _loc2_++;
            }
            return;
         }
         throw new Error("图形对象不能为空!");
      }
      
      private function createSpace() : MovieClip
      {
         var _loc1_:BitmapData = new BitmapData(3,32,true,0);
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         var _loc3_:MovieClip = new MovieClip();
         _loc3_.addChild(_loc2_);
         return _loc3_;
      }
      
      private function findObject(param1:String) : MovieClip
      {
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         if(param1.length > 1)
         {
            throw new Error("字符格式错误!");
         }
         if(specialStr.hasOwnProperty(param1))
         {
            param1 = specialStr[param1];
         }
         if(param1 == " ")
         {
            return this.createSpace();
         }
         this.tempStr += param1;
         param1 = tempStr;
         _loc2_ = 0;
         while(_loc2_ < picNames.length)
         {
            if(picNames[_loc2_].toString() == param1)
            {
               _loc3_ = DomainAccess.getClass(PREFIX + projectName + picNames[_loc2_].toString());
               tempStr = "";
               return new _loc3_();
            }
            _loc2_++;
         }
         return null;
      }
   }
}


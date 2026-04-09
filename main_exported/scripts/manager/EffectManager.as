package manager
{
   import com.display.BitmapDateSourseManager;
   import com.display.CMovieClip;
   import entity.Organism;
   import flash.display.MovieClip;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class EffectManager
   {
      
      public function EffectManager()
      {
         super();
      }
      
      public static function getQualityEffect(param1:Organism, param2:Number = 1) : CMovieClip
      {
         var _loc3_:String = "";
         if(param1.getWidth() * param1.getHeight() == 1)
         {
            _loc3_ = "lightEffect_1_";
         }
         else
         {
            _loc3_ = "lightEffect_2_";
         }
         var _loc4_:int = XmlQualityConfig.getInstance().getID(param1.getQuality_name());
         if(_loc4_ < 3)
         {
            return null;
         }
         if(_loc4_ < 5)
         {
            _loc3_ += 1 + "";
         }
         else if(_loc4_ < 8)
         {
            _loc3_ += 2 + "";
         }
         else if(_loc4_ < 11)
         {
            _loc3_ += 3 + "";
         }
         else if(_loc4_ < 13)
         {
            _loc3_ += 4 + "";
         }
         else if(_loc4_ < 16)
         {
            _loc3_ += 5 + "";
         }
         else
         {
            if(_loc4_ >= 19)
            {
               throw new Error("找不到品质类型!!!");
            }
            _loc3_ += 6 + "";
         }
         var _loc5_:Class = DomainAccess.getClass(_loc3_);
         var _loc6_:MovieClip = new _loc5_();
         var _loc7_:CMovieClip = new CMovieClip(BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc6_.getChildAt(0) as MovieClip,_loc3_ + param2,param2),12);
         _loc7_.bitmap.x = _loc7_.getBitmapdateInfos().getBaseMcTransform().matrix.tx * param2;
         _loc7_.bitmap.y = _loc7_.getBitmapdateInfos().getBaseMcTransform().matrix.ty * param2;
         return _loc7_;
      }
      
      public static function getSoulEffect(param1:int, param2:Number = 1) : CMovieClip
      {
         var _loc3_:String = "";
         _loc3_ = "soul_level_" + param1;
         var _loc4_:Class = DomainAccess.getClass(_loc3_);
         var _loc5_:MovieClip = new _loc4_();
         var _loc6_:CMovieClip = new CMovieClip(BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc5_.getChildAt(0) as MovieClip,_loc3_ + param2,param2),12);
         _loc6_.bitmap.x = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.tx * param2;
         _loc6_.bitmap.y = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.ty * param2;
         return _loc6_;
      }
      
      public static function getGeniusEffect(param1:int, param2:Number = 1) : CMovieClip
      {
         var _loc3_:String = "";
         _loc3_ = "genius_level_" + param1;
         var _loc4_:Class = DomainAccess.getClass(_loc3_);
         var _loc5_:MovieClip = new _loc4_();
         var _loc6_:CMovieClip = new CMovieClip(BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc5_.getChildAt(0) as MovieClip,_loc3_ + param2,param2),12);
         _loc6_.bitmap.x = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.tx * param2;
         _loc6_.bitmap.y = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.ty * param2;
         return _loc6_;
      }
      
      public static function getUpgradeEffect(param1:String, param2:Number = 1) : CMovieClip
      {
         var _loc3_:String = param1;
         var _loc4_:Class = DomainAccess.getClass(_loc3_);
         var _loc5_:MovieClip = new _loc4_();
         var _loc6_:CMovieClip = new CMovieClip(BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc5_.getChildAt(0) as MovieClip,_loc3_ + param2,param2),12);
         _loc6_.bitmap.x = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.tx * param2;
         _loc6_.bitmap.y = _loc6_.getBitmapdateInfos().getBaseMcTransform().matrix.ty * param2;
         return _loc6_;
      }
   }
}


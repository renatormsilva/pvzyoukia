package pvz.shaketree.utils
{
   import com.display.BitmapDateSourseManager;
   import com.display.CMovieClip;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import node.OrgLoader;
   import utils.GetDomainRes;
   
   public class ShakeTree_Kit
   {
      
      private static const POSTIONS:Array = [new Point(232,340),new Point(102,427),new Point(197,490),new Point(321,520),new Point(464,496),new Point(570,446),new Point(592,321),new Point(480,325),new Point(370,376),new Point(705,500),new Point(235,393),new Point(521,390),new Point(391,470),new Point(437,374),new Point(302,347),new Point(395,300)];
      
      private static var animationDic:Dictionary = new Dictionary();
      
      public function ShakeTree_Kit()
      {
         super();
      }
      
      public static function getZombiesCMovieClip(param1:int, param2:int) : OrgLoader
      {
         return new OrgLoader(param1,param2);
      }
      
      public static function getPositionByZomibesPositionId(param1:int) : Point
      {
         return POSTIONS[param1 - 1];
      }
      
      public static function getBigExplosionEffect(param1:int, param2:Number = 1) : CMovieClip
      {
         var _loc4_:MovieClip = null;
         var _loc3_:String = "";
         _loc3_ = "pvz.effect_explosion" + param1;
         if(animationDic[_loc3_])
         {
            _loc4_ = animationDic[_loc3_];
         }
         else
         {
            _loc4_ = GetDomainRes.getMoveClip(_loc3_);
            animationDic[_loc3_] = _loc4_;
         }
         var _loc5_:CMovieClip = new CMovieClip(BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc4_.getChildAt(0) as MovieClip,_loc3_ + param2,param2),12);
         _loc5_.bitmap.x = _loc5_.getBitmapdateInfos().getBaseMcTransform().matrix.tx * param2;
         _loc5_.bitmap.y = _loc5_.getBitmapdateInfos().getBaseMcTransform().matrix.ty * param2;
         return _loc5_;
      }
      
      public static function getBaojiBeiShuMoiveClip(param1:int) : MovieClip
      {
         var _loc2_:String = "pvz.baoji" + param1;
         if(animationDic[_loc2_])
         {
            return animationDic[_loc2_];
         }
         var _loc3_:MovieClip = GetDomainRes.getMoveClip(_loc2_);
         animationDic[_loc2_] = _loc3_;
         return _loc3_;
      }
   }
}


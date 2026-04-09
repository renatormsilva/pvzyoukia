package pvz.battle.battleMode
{
   import com.display.BitmapDateSourseManager;
   import com.display.BitmapFrameInfos;
   import com.display.CMovieClip;
   import entity.Organism;
   import entity.Skill;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import pvz.battle.node.BattleOrg;
   import utils.BigInt;
   import zlib.utils.DomainAccess;
   
   public class Battle
   {
      
      public static var BATTLE_ALL_ATTACK:int = 5;
      
      public static var BATTLE_APEAK:int = 4;
      
      public static var BATTLE_CLOSE:int = 2;
      
      public static var BATTLE_LINE:int = 1;
      
      public static var BATTLE_PARABOLA:int = 3;
      
      public function Battle()
      {
         super();
      }
      
      public static function getBulletBlastCMovieClip(param1:int, param2:int, param3:Number = 1) : CMovieClip
      {
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc4_:String = "org_" + param1 + "_bulletBlast_0";
         var _loc5_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc4_,param3);
         if(_loc5_ == null)
         {
            _loc7_ = getBulletBlastClass(param1,0);
            if(_loc7_ == null)
            {
               return null;
            }
            _loc8_ = new _loc7_();
            if(_loc8_.numChildren < 1)
            {
               return null;
            }
            _loc5_ = BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc8_.getChildAt(0) as MovieClip,_loc4_,param3);
         }
         var _loc6_:CMovieClip = new CMovieClip(_loc5_,12);
         if(param2 == 1)
         {
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param3;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param3;
            }
            else
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param3;
            }
         }
         else
         {
            _loc6_.bitmap.x = _loc5_.getBaseMcTransform().matrix.tx * param3;
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param3;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
            }
         }
         return _loc6_;
      }
      
      public static function getBulletBlastClass(param1:int, param2:int) : Class
      {
         return DomainAccess.getClass("org_" + param1 + "_bulletBlast_" + param2);
      }
      
      public static function getBulletCMovieClip(param1:int, param2:int, param3:Number = 1) : CMovieClip
      {
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc4_:String = "org_" + param1 + "_bullet_0";
         var _loc5_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc4_,param3);
         if(_loc5_ == null)
         {
            _loc7_ = getBulletClass(param1,0);
            if(_loc7_ == null)
            {
               return null;
            }
            _loc8_ = new _loc7_();
            if(_loc8_.numChildren < 1)
            {
               return null;
            }
            _loc5_ = BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc8_.getChildAt(0) as MovieClip,_loc4_,param3);
         }
         var _loc6_:CMovieClip = new CMovieClip(_loc5_,12);
         if(param2 == 1)
         {
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param3;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param3;
            }
            else
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
               _loc6_.bitmap.x -= _loc5_.getBaseMcTransform().matrix.tx * param3;
            }
         }
         else
         {
            _loc6_.bitmap.x = _loc5_.getBaseMcTransform().matrix.tx * param3;
            _loc6_.bitmap.y = _loc5_.getBaseMcTransform().matrix.ty * param3;
            if(_loc5_.getBaseMcTransform().matrix.a < 0)
            {
               BitmapDateSourseManager.flipHorizontal(_loc6_);
            }
         }
         if(_loc6_ == null)
         {
            throw new Error("bulletMc is null,org pid:" + param1);
         }
         return _loc6_;
      }
      
      public static function getBulletClass(param1:int, param2:int) : Class
      {
         return DomainAccess.getClass("org_" + param1 + "_bullet_" + param2);
      }
      
      public static function getTime(param1:Number, param2:Number, param3:Number, param4:Number, param5:int) : int
      {
         var _loc6_:Point = new Point(param1,param2);
         var _loc7_:Point = new Point(param3,param4);
         var _loc8_:Number = Point.distance(_loc6_,_loc7_);
         return int(_loc8_ / param5);
      }
      
      public function getAttEffectType(param1:BattleOrg, param2:Array) : int
      {
         if(param2 == null || param2.length < 1)
         {
            return 0;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if((param2[_loc3_] as Skill).getEffect() != 0)
            {
               return (param2[_loc3_] as Skill).getEffect();
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getAttackNum(param1:String, param2:int = 0, param3:int = 0) : BigInt
      {
         var _loc6_:BigInt = null;
         var _loc7_:BigInt = null;
         var _loc4_:BigInt = new BigInt(param1);
         var _loc5_:BigInt = BigInt.divide(_loc4_,param2);
         if(param2 == param3)
         {
            _loc6_ = BigInt.mod(_loc4_,param2);
            return BigInt.plus(_loc5_,_loc6_);
         }
         return _loc5_;
      }
      
      public function getAttackTimes(param1:Organism) : int
      {
         return param1.getAttackTimes();
      }
      
      public function getIsAllAttack(param1:Array) : Boolean
      {
         if(param1 == null || param1.length < 1)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if((param1[_loc2_] as Skill).getAllAttack() == true)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getOrgAttackPoint(param1:BattleOrg, param2:int) : Point
      {
         var _loc3_:Point = new Point();
         _loc3_.y = param1.y + param1.getAttackPoint().y;
         if(param2 == 0)
         {
            _loc3_.x = param1.x + param1.getAttackPoint().x;
         }
         else
         {
            _loc3_.x = param1.x - param1.getAttackPoint().x;
         }
         return _loc3_;
      }
      
      public function printOutZhanBao(param1:Organism, param2:Organism, param3:String) : void
      {
      }
   }
}


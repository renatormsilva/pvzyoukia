package pvz.serverbattle.ranking
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.serverbattle.entity.GuessRankUserInfo;
   import pvz.serverbattle.entity.ScoreRankUserInfo;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import zlib.utils.DomainAccess;
   
   public class RankBar extends Sprite
   {
      
      private var _bar:MovieClip;
      
      public function RankBar()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("infoBar");
         this._bar = new _loc1_();
         this._bar.mouseChildren = false;
         this._bar.mouseEnabled = true;
         this._bar["_specil"].visible = false;
         this.addChild(this._bar);
         this.addEvent();
      }
      
      public function updateBar(param1:Object) : void
      {
         var _loc2_:ScoreRankUserInfo = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:GuessRankUserInfo = null;
         var _loc5_:DisplayObject = null;
         this._bar["_specil"].visible = false;
         this._bar["_pic"].visible = true;
         FuncKit.clearAllChildrens(this._bar["_ranknum"]);
         FuncKit.clearAllChildrens(this._bar["_pic"]);
         FuncKit.clearAllChildrens(this._bar["_num"]);
         if(param1 is ScoreRankUserInfo)
         {
            _loc2_ = param1 as ScoreRankUserInfo;
            this._bar["_ranknum"].addChild(StringMovieClip.getStringImage(_loc2_.getRank() + "","Small"));
            PlantsVsZombies.setHeadPic(this._bar["_pic"],PlantsVsZombies.getHeadPicUrl(_loc2_.getFaceURL()),PlantsVsZombies.HEADPIC_MIDDLE,_loc2_.getVipEtime(),_loc2_.getVIPGrade());
            this._bar["_pic"].visible = true;
            this._bar["_txt1"].text = _loc2_.getNickName();
            this._bar["_txt2"].text = _loc2_.getSeverName();
            _loc3_ = StringMovieClip.getStringImage(_loc2_.getScore() + "","Exp");
            this._bar["_num"].addChild(_loc3_);
            _loc3_.x = -_loc3_.width / 2;
            if(_loc2_.getRank() <= 4)
            {
               this._bar["_specil"].visible = true;
               this._bar["_specil"].gotoAndStop(_loc2_.getRank());
            }
         }
         else if(param1 is GuessRankUserInfo)
         {
            _loc4_ = param1 as GuessRankUserInfo;
            this._bar["_ranknum"].addChild(StringMovieClip.getStringImage(_loc4_.getRank() + "","Small"));
            PlantsVsZombies.setHeadPic(this._bar["_pic"],PlantsVsZombies.getHeadPicUrl(_loc4_.getFaceURL()),PlantsVsZombies.HEADPIC_MIDDLE,_loc4_.getVipEtime(),_loc4_.getVIPGrade());
            this._bar["_txt1"].text = _loc4_.getNickName();
            this._bar["_txt2"].text = _loc4_.getSeverName();
            _loc5_ = StringMovieClip.getStringImage(_loc4_.getBox() + "","Exp");
            this._bar["_num"].addChild(_loc5_);
            _loc5_.x = -_loc5_.width / 2;
         }
      }
      
      private function addEvent() : void
      {
         this._bar.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._bar.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._bar.gotoAndStop(1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._bar.gotoAndStop(2);
      }
      
      public function destory() : void
      {
         this._bar.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._bar.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
   }
}


package pvz.copy.ui.sprites
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.copy.models.stone.StoneRankingData;
   import utils.FuncKit;
   import utils.StringMovieClip;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class StoneRankBar extends Sprite
   {
      
      private var _bar:MovieClip;
      
      public function StoneRankBar()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("stone.infoBar");
         this._bar = new _loc1_();
         TextFilter.MiaoBian(this._bar["_txt1"],0);
         this._bar.mouseChildren = false;
         this._bar.mouseEnabled = true;
         this._bar["_specil"].visible = false;
         this.addChild(this._bar);
         this.addEvent();
      }
      
      public function updateBar(param1:Object) : void
      {
         var _loc2_:StoneRankingData = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         this._bar["_specil"].visible = false;
         this._bar["_pic"].visible = true;
         FuncKit.clearAllChildrens(this._bar["_ranknum"]);
         FuncKit.clearAllChildrens(this._bar["_pic"]);
         FuncKit.clearAllChildrens(this._bar["_num"]);
         if(param1 is StoneRankingData)
         {
            _loc2_ = param1 as StoneRankingData;
            _loc3_ = StringMovieClip.getStringImage(_loc2_.getRank() + "","Small");
            _loc3_.x = -_loc3_.width / 2 + 8;
            this._bar["_ranknum"].addChild(_loc3_);
            PlantsVsZombies.setHeadPic(this._bar["_pic"],PlantsVsZombies.getHeadPicUrl(_loc2_.getFaceURL()),PlantsVsZombies.HEADPIC_MIDDLE,_loc2_.getVipTime(),_loc2_.getVipGrade());
            this._bar["_pic"].visible = true;
            this._bar["_txt1"].text = _loc2_.getNickName();
            _loc4_ = StringMovieClip.getStringImage(_loc2_.getStarNum() + "","Exp");
            this._bar["_num"].addChild(_loc4_);
            _loc4_.x = -_loc4_.width / 2;
            if(_loc2_.getRank() <= 4)
            {
               this._bar["_specil"].visible = true;
               this._bar["_specil"].gotoAndStop(_loc2_.getRank());
            }
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
         FuncKit.clearAllChildrens(this);
         this._bar.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._bar.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
   }
}


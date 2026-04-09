package pvz.world.repetition.ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import utils.FuncKit;
   import utils.ReBuidBitmap;
   
   public class RankingBar extends Sprite
   {
      
      public static const FIRST_ATTACK_BAR:int = 1;
      
      public static const COMPLETE_DEGREE_BAR:int = 2;
      
      public static const HONOR_RANKING_BAR:int = 3;
      
      private var backDefault:ReBuidBitmap;
      
      private var backOver:ReBuidBitmap;
      
      private var barType:int;
      
      private var rankBack:ReBuidBitmap;
      
      public function RankingBar(param1:int)
      {
         super();
         switch(param1)
         {
            case FIRST_ATTACK_BAR:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.FirstRankingDefault");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.FirstRankingOver");
               this.barType = FIRST_ATTACK_BAR;
               break;
            case COMPLETE_DEGREE_BAR:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.RankingBarDefalut");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.RankingBarOver");
               this.barType = COMPLETE_DEGREE_BAR;
               break;
            case HONOR_RANKING_BAR:
               this.backDefault = new ReBuidBitmap("pvz.ectype.ranking.RankingBarDefalut");
               this.backOver = new ReBuidBitmap("pvz.ectype.ranking.RankingBarOver");
               this.barType = HONOR_RANKING_BAR;
         }
         this.backOver.visible = false;
         this.addChild(this.backOver);
         this.addChild(this.backDefault);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onBtnOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onBtnOut,false,0,true);
      }
      
      public function distroy() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onBtnOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onBtnOut);
         this.backDefault.dispose();
         this.backOver.dispose();
         if(this.rankBack != null)
         {
            this.rankBack.dispose();
            this.rankBack.parent.removeChild(this.rankBack);
         }
         this.removeChild(this.backOver);
         this.removeChild(this.backDefault);
         this.parent.removeChild(this);
      }
      
      public function upData(param1:Object) : void
      {
         var _loc8_:String = null;
         var _loc9_:TextField = null;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc12_:int = 0;
         var _loc13_:DisplayObject = null;
         var _loc2_:int = int(param1.order);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:String = param1.nickname;
         var _loc5_:Sprite = new Sprite();
         var _loc6_:TextField = new TextField();
         _loc6_.htmlText = "<font><b>" + _loc4_ + "</b></font>";
         _loc6_.height = _loc6_.textHeight + 2;
         _loc6_.width = 50;
         _loc6_.selectable = false;
         var _loc7_:DisplayObject = FuncKit.getNumEffect(_loc2_ + "","Small");
         this.addChild(_loc5_);
         if(_loc2_ == 1)
         {
            this.rankBack = new ReBuidBitmap("pvz.ectype.ranking.FirstIcon");
            _loc5_.addChild(this.rankBack);
            this.rankBack.x = -3;
         }
         else if(_loc2_ == 2)
         {
            this.rankBack = new ReBuidBitmap("pvz.ectype.ranking.SecondIcon");
            _loc5_.addChild(this.rankBack);
            this.rankBack.x = -1;
         }
         else if(_loc2_ == 3)
         {
            this.rankBack = new ReBuidBitmap("pvz.ectype.ranking.ThirdIcon");
            _loc5_.addChild(this.rankBack);
            this.rankBack.x = -1;
         }
         PlantsVsZombies.setHeadPic(_loc3_,PlantsVsZombies.getHeadPicUrl(param1.face),PlantsVsZombies.HEADPIC_SMALL,param1.vip_etime,param1.vip_grade);
         _loc7_.x = 29;
         _loc7_.y = 5;
         _loc6_.y = 10;
         _loc5_.addChild(_loc7_);
         this.addChild(_loc6_);
         this.addChild(_loc3_);
         switch(this.barType)
         {
            case FIRST_ATTACK_BAR:
               _loc3_.x = 140;
               _loc3_.y = 3;
               _loc8_ = param1.pass;
               _loc9_ = new TextField();
               _loc9_.htmlText = "<font><b>" + _loc8_ + "</b></font>";
               _loc9_.height = _loc9_.textHeight + 2;
               _loc9_.width = 40;
               _loc9_.selectable = false;
               this.addChild(_loc9_);
               _loc9_.x = 380;
               _loc9_.y = 10;
               _loc6_.x = 250;
               _loc9_.autoSize = TextFieldAutoSize.CENTER;
               break;
            case COMPLETE_DEGREE_BAR:
               _loc3_.x = 215;
               _loc3_.y = 6;
               _loc10_ = int(param1.integral);
               _loc11_ = FuncKit.getNumEffect(_loc10_ + "");
               this.addChild(_loc11_);
               _loc11_.x = 580;
               _loc11_.y = 10;
               _loc6_.x = 390;
               _loc5_.x = 5;
               _loc5_.y = 3;
               break;
            case HONOR_RANKING_BAR:
               _loc3_.x = 215;
               _loc3_.y = 6;
               _loc12_ = int(param1.amount);
               _loc13_ = FuncKit.getNumEffect(_loc12_ + "");
               this.addChild(_loc13_);
               _loc13_.x = 580;
               _loc13_.y = 10;
               _loc6_.x = 390;
               _loc5_.x = 5;
               _loc5_.y = 3;
         }
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
      }
      
      private function onBtnOver(param1:MouseEvent) : void
      {
         this.backOver.visible = true;
         this.backDefault.visible = false;
      }
      
      private function onBtnOut(param1:MouseEvent) : void
      {
         this.backOver.visible = false;
         this.backDefault.visible = true;
      }
   }
}


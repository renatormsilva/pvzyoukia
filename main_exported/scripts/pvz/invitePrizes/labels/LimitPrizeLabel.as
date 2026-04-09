package pvz.invitePrizes.labels
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.invitePrizes.events.LimitPrizeEvent;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class LimitPrizeLabel extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _id:int;
      
      private var _data:Object = new Object();
      
      private var _type:int = 1;
      
      private var _isGet:Boolean;
      
      private var _isGoten:Boolean;
      
      public function LimitPrizeLabel(param1:int)
      {
         super();
         this._id = param1;
         this.buttonMode = true;
         this.getMc("consume" + param1);
         this.addEventListener(MouseEvent.CLICK,this.onCardClick);
      }
      
      public function get isGet() : Boolean
      {
         return this._isGet;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function setType(param1:int = 1) : void
      {
         switch(param1)
         {
            case 1:
               this._mc.gotoAndStop(1);
               this._mc["jian"].visible = false;
               break;
            case 2:
               this._mc.gotoAndStop(1);
               this._mc["jian"].visible = true;
               break;
            case 3:
               this._mc.gotoAndStop(2);
               this._mc["jian"].visible = false;
               break;
            case 4:
               this._mc.gotoAndStop(2);
               this._mc["jian"].visible = true;
               break;
            case 5:
               this._mc.gotoAndStop(3);
               this.mouseEnabled = false;
               this.buttonMode = false;
               this.removeEventListener(MouseEvent.CLICK,this.onCardClick);
         }
      }
      
      private function getMc(param1:String) : void
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         this._mc = new _loc2_();
         this.addChild(this._mc);
         this._mc.gotoAndStop(1);
      }
      
      public function setData(param1:Array) : void
      {
         this._data["data"] = param1;
      }
      
      public function setLabelStats(param1:Object) : void
      {
         this._isGoten = param1.is_rewarded;
         if(param1.is_rewarded <= 0)
         {
            this._isGet = param1.can_reward > 0 ? true : false;
            if(this._isGet)
            {
               this.setType(2);
            }
            else
            {
               this.setType(1);
            }
         }
         else if(param1.is_rewarded >= 1)
         {
            this.setType(5);
         }
      }
      
      public function isGetton() : Boolean
      {
         return this._isGoten >= 1;
      }
      
      private function onCardClick(param1:MouseEvent) : void
      {
         this.dispatchEvent(new LimitPrizeEvent(LimitPrizeEvent.PRIZE_EVENT,this._data,this._id));
      }
      
      public function setNum(param1:int) : void
      {
         this._mc["num"].addChild(FuncKit.getNumEffect((param1 + "x").toString(),"White"));
      }
   }
}


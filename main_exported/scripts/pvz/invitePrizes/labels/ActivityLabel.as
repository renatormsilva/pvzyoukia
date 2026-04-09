package pvz.invitePrizes.labels
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.invitePrizes.events.PrizeEvent;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class ActivityLabel extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _id:String;
      
      private var _data:Object = new Object();
      
      public function ActivityLabel(param1:String)
      {
         super();
         this._id = param1;
         this.buttonMode = true;
         this.getMc("active" + param1);
         this.addEventListener(MouseEvent.CLICK,this.onCardClick);
      }
      
      public function getId() : String
      {
         return this._id;
      }
      
      public function setType(param1:int) : void
      {
         this._mc.gotoAndStop(param1);
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
         this._data["id"] = this._id;
      }
      
      private function onCardClick(param1:MouseEvent) : void
      {
         this.dispatchEvent(new PrizeEvent(PrizeEvent.PRIZE_EVENT,this._data));
      }
      
      public function setNum(param1:int) : void
      {
         this._mc["num"].addChild(FuncKit.getNumEffect((param1 + "x").toString(),"White"));
      }
   }
}


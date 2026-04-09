package pvz.invitePrizes.labels
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.invitePrizes.events.PrizeEvent;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class ConsumeLabel extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _data:Array = [];
      
      private var _id:int;
      
      public var preType:int;
      
      private var _canget:Boolean;
      
      public function ConsumeLabel(param1:int)
      {
         super();
         this._id = param1;
         this.getMc("consume" + param1);
         this.buttonMode = true;
         this.addChild(this._mc);
         this.addEventListener(MouseEvent.CLICK,this.onCardClick);
      }
      
      private function onCardClick(param1:MouseEvent) : void
      {
         this.dispatchEvent(new PrizeEvent(PrizeEvent.PRIZE_EVENT,this._data));
      }
      
      private function getMc(param1:String) : void
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         this._mc = new _loc2_();
         this.addChild(this._mc);
         this._mc.gotoAndStop(1);
         this._mc["jian"].visible = false;
      }
      
      public function setNum(param1:int) : void
      {
         this._mc["num"].addChild(FuncKit.getNumEffect((param1 + "x").toString(),"White"));
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function setData(param1:Array) : void
      {
         this._data["data"] = param1;
         this._data["id"] = this._id;
      }
      
      public function get isCanGet() : Boolean
      {
         return this._canget;
      }
      
      public function changeThisState(param1:int) : void
      {
         if(this.preType == 2)
         {
            this._canget = true;
         }
         else
         {
            this._canget = false;
         }
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
   }
}


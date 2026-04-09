package pvz.serverbattle.knockout.rankingRewards
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import pvz.serverbattle.entity.BoxRewarsInfo;
   
   public class RewardsBox
   {
      
      private var _data:BoxRewarsInfo;
      
      private var _box:MovieClip;
      
      private var _isCanbeGotten:Boolean;
      
      private var _isGotten:Boolean;
      
      private var _callback:Function;
      
      private var _callback2:Function;
      
      public function RewardsBox(param1:MovieClip, param2:Function, param3:Function)
      {
         super();
         this._box = param1;
         this._box.gotoAndStop(1);
         this._box.buttonMode = true;
         this._callback = param2;
         this._callback2 = param3;
         this._box["jian"].visible = false;
         this._box.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._box.currentFrame == 3)
         {
            return;
         }
         this._callback2();
         this._box.gotoAndStop(2);
         if(this._callback != null)
         {
            this._callback(this._data.getPrizeInfo());
         }
      }
      
      public function setData(param1:BoxRewarsInfo) : void
      {
         this._data = param1;
      }
      
      public function setIsGotten() : void
      {
         this._isCanbeGotten = false;
         this._isGotten = true;
         this._box.gotoAndStop(3);
         this._box.buttonMode = false;
      }
      
      private function setCanGotten() : void
      {
         this._box.gotoAndStop(1);
         this._isCanbeGotten = true;
      }
      
      public function setDefault() : void
      {
         this._box.gotoAndStop(1);
      }
      
      private function setCheck() : void
      {
         this._box["jian"].visible = false;
         this._box.gotoAndStop(2);
      }
      
      public function updateBoxStats(param1:int, param2:int) : void
      {
         if(param1 == 0)
         {
            return;
         }
         if(param2 == 0)
         {
            if(param1 <= this._data.getRank())
            {
               if(!this._isGotten)
               {
                  this.setCanGotten();
               }
            }
         }
         else if(param2 > 0)
         {
            if(param1 <= this._data.getRank() && this._data.getRank() < param2)
            {
               if(!this._isGotten)
               {
                  this.setCanGotten();
               }
            }
            else if(param1 <= this._data.getRank() && this._data.getRank() >= param2)
            {
               this.setIsGotten();
            }
         }
      }
      
      public function getIsCanbeGotten() : Boolean
      {
         return this._isCanbeGotten;
      }
      
      public function getIsGotten() : Boolean
      {
         return this._isGotten;
      }
      
      public function getBoxData() : BoxRewarsInfo
      {
         return this._data;
      }
      
      public function destory() : void
      {
         this._box.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function setJiantouVisibleisTrue() : void
      {
         this._box["jian"].visible = true;
         this._box.gotoAndStop(2);
      }
   }
}


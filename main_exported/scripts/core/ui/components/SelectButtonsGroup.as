package core.ui.components
{
   import flash.display.DisplayObjectContainer;
   import zmyth.res.IDestroy;
   
   public class SelectButtonsGroup implements IDestroy
   {
      
      private var _resouce:DisplayObjectContainer;
      
      private var _callback:Function;
      
      private var _selectbtns:Array;
      
      private var _clickBtnName:String;
      
      public function SelectButtonsGroup(param1:DisplayObjectContainer, param2:Function)
      {
         var _loc4_:SelectButton = null;
         this._selectbtns = [];
         super();
         this._resouce = param1;
         this._callback = param2;
         var _loc3_:int = param1.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = new SelectButton(param1.getChildAt(_loc5_),this.click);
            this._selectbtns.push(_loc4_);
            _loc5_++;
         }
      }
      
      private function click(param1:String) : void
      {
         if(param1 == this._clickBtnName)
         {
            return;
         }
         this._clickBtnName = param1;
         this.setALlButtonsStaus();
         this._callback(this._clickBtnName);
      }
      
      private function setALlButtonsStaus() : void
      {
         var _loc1_:SelectButton = null;
         for each(_loc1_ in this._selectbtns)
         {
            if(_loc1_.getBtnName() != this._clickBtnName)
            {
               _loc1_.setIsClicked(false);
            }
         }
      }
      
      public function setButtonIsClickByBtnName(param1:String) : void
      {
         var _loc2_:SelectButton = null;
         for each(_loc2_ in this._selectbtns)
         {
            if(_loc2_.getBtnName() == param1)
            {
               _loc2_.setIsClicked(true);
               this._clickBtnName = param1;
            }
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:SelectButton = null;
         this._clickBtnName = "";
         for each(_loc1_ in this._selectbtns)
         {
            _loc1_.destory();
         }
         this._selectbtns = [];
      }
   }
}


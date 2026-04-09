package pvz.genius.jewelSystem.componets
{
   import pvz.genius.jewelSystem.BasePanel;
   import pvz.genius.jewelSystem.event.DropDownSelectEvent;
   import pvz.genius.vo.GeniusSystemConst;
   
   public class DropDownListPanel extends BasePanel
   {
      
      private var _nodes:Array;
      
      public function DropDownListPanel()
      {
         super("jewel.DrapDownListPanel");
         this._nodes = [];
         this.createList();
         _ui.addEventListener(DropDownSelectEvent.SELECT,this.onSelect);
      }
      
      private function onSelect(param1:DropDownSelectEvent) : void
      {
         this.setFaultAllNode(param1._stype);
      }
      
      private function createList() : void
      {
         var _loc1_:DropDownListNode = null;
         var _loc2_:int = 0;
         while(_loc2_ < GeniusSystemConst.DROP_DOWN_LIST.length)
         {
            _loc1_ = new DropDownListNode();
            _loc1_.setType(GeniusSystemConst.DROP_DOWN_LIST[_loc2_]);
            _ui._listnode.addChild(_loc1_);
            _loc1_.y = (_loc1_.height - 2) * _loc2_;
            this._nodes.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function setFaultAllNode(param1:int) : void
      {
         var _loc2_:DropDownListNode = null;
         for each(_loc2_ in this._nodes)
         {
            if(_loc2_.type == param1)
            {
               _loc2_.setIsSelect(true);
            }
            else
            {
               _loc2_.setIsSelect(false);
            }
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:DropDownListNode = null;
         for each(_loc1_ in this._nodes)
         {
            _loc1_.destroy();
         }
         _ui.removeEventListener(DropDownSelectEvent.SELECT,this.onSelect);
      }
   }
}


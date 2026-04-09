package pvz.newTask.view
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import pvz.newTask.data.TaskVo;
   import pvz.newTask.view.item.ItemRenderer;
   import pvz.registration.view.panel.module.ScrollPanel;
   import utils.FuncKit;
   
   public class NewTaskPanel extends Sprite
   {
      
      private var _scrollPanel:ScrollPanel;
      
      private var panel:Sprite;
      
      public function NewTaskPanel()
      {
         super();
         this._scrollPanel = new ScrollPanel(638,328,new Sprite());
         this._scrollPanel.x = 0;
         this._scrollPanel.y = 0;
         this._scrollPanel.padding = 5;
         this.addChild(this._scrollPanel);
         this.panel = new Sprite();
      }
      
      public function upData(param1:Array) : void
      {
         var _loc2_:TaskVo = null;
         var _loc3_:ItemRenderer = null;
         FuncKit.clearAllChildrens(this.panel);
         this._scrollPanel.removeAllObjects();
         for each(_loc2_ in param1)
         {
            _loc3_ = new ItemRenderer();
            _loc3_.setData(_loc2_);
            this.panel.addChild(_loc3_);
         }
         this.layoutVectical(this.panel,2);
         this._scrollPanel.addObject(this.panel);
      }
      
      public function layoutVectical(param1:DisplayObjectContainer, param2:Number = 0, param3:Number = 0) : void
      {
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:int = param1.numChildren;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:int = param3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc7_.y = _loc5_;
            _loc5_ = _loc7_.height + _loc7_.y + param2;
            _loc6_++;
         }
      }
   }
}


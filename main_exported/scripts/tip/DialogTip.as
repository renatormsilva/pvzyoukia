package tip
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import manager.LangManager;
   import utils.TextFilter;
   
   public class DialogTip extends Sprite
   {
      
      private var _loc:TextField;
      
      private var _loc_1:TextField;
      
      private var _loc_2:TextField;
      
      private var _o:InteractiveObject;
      
      public function DialogTip()
      {
         super();
         if(!this._loc)
         {
            this._loc = new TextField();
         }
         if(!this._loc_1)
         {
            this._loc_1 = new TextField();
         }
         if(!this._loc_2)
         {
            this._loc_2 = new TextField();
         }
         this.miaobian();
         this.drawBack();
      }
      
      private function drawBack() : void
      {
         this.graphics.beginFill(0,0.8);
         this.graphics.drawRoundRect(0,0,120,50,20,20);
         this.graphics.endFill();
      }
      
      public function setTip(param1:InteractiveObject, param2:String) : void
      {
         this._o = param1;
         this._loc.text = param2;
         this._loc.textColor = 16777215;
         this._loc.width = this._loc.textWidth + 4;
         this._loc.height = this._loc.textHeight + 2;
         this._loc.x = 10;
         this._loc.y = 10;
         this.addChild(this._loc);
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         param1.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setColorTip(param1:InteractiveObject, param2:String) : void
      {
         this._o = param1;
         this._loc_1.htmlText = "<font size=\'12\' color=\'#ffffff\'>" + LangManager.getInstance().getLanguage("newTip001") + this.setTipColor(param2);
         this._loc_1.width = this._loc_1.textWidth + 4;
         this._loc_1.height = this._loc_1.textHeight + 2;
         this._loc_1.x = 10;
         this._loc_1.y = 8;
         this._loc_2.htmlText = "<font size=\'12\' color=\'#ffffff\'>" + LangManager.getInstance().getLanguage("newTip002") + "</font>";
         this._loc_2.textColor = 16777215;
         this._loc_2.width = this._loc_2.textWidth + 4;
         this._loc_2.height = this._loc_2.textHeight + 2;
         this._loc_2.x = 10;
         this._loc_2.y = this._loc_1.y + this._loc_1.height;
         this.addChild(this._loc_1);
         this.addChild(this._loc_2);
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         param1.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function setTipColor(param1:String) : String
      {
         var _loc2_:String = param1;
         if(param1 == LangManager.getInstance().getLanguage("quality001"))
         {
            _loc2_ = "</font><font size=\'12\' color=\'#99ff00\'><b>" + param1 + "</b></font>";
         }
         else if(param1 == LangManager.getInstance().getLanguage("quality002"))
         {
            _loc2_ = "</font><font size=\'12\' color=\'#660099\'><b>" + param1 + "</b></font>";
         }
         else if(param1 == LangManager.getInstance().getLanguage("quality003"))
         {
            _loc2_ = "</font><font size=\'12\' color=\'#ff6600\'><b>" + param1 + "</b></font>";
         }
         return _loc2_;
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._loc,0);
         TextFilter.MiaoBian(this._loc_1,0);
         TextFilter.MiaoBian(this._loc_2,0);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = param1 + 170;
         this.y = param2 + 290;
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         parent.removeChild(this);
      }
   }
}


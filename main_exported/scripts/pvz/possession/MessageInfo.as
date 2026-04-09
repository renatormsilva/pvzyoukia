package pvz.possession
{
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import manager.SoundManager;
   
   public class MessageInfo extends Sprite
   {
      
      private var _name:String = "";
      
      private var nameTxt:TextField = null;
      
      private var _click:Function = null;
      
      public function MessageInfo(param1:String, param2:Function, param3:Point)
      {
         super();
         this._click = param2;
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.size = 12;
         this.nameTxt = new TextField();
         this.nameTxt.height = 20;
         this.nameTxt.width = 450;
         this.nameTxt.selectable = false;
         this.nameTxt.defaultTextFormat = _loc4_;
         this.nameTxt.addEventListener(TextEvent.LINK,this.onClick);
         this.doMessage(param1);
         this.x = param3.x;
         this.y = param3.y;
      }
      
      private function onClick(param1:TextEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._click != null)
         {
            this._click(param1.text);
         }
      }
      
      private function doLayout() : void
      {
         addChild(this.nameTxt);
      }
      
      private function doMessage(param1:String) : void
      {
         var _loc2_:RegExp = /<|>/g;
         var _loc3_:Array = param1.replace(_loc2_,"|").split("|");
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ += this.getInfoText(_loc3_[_loc5_]);
            _loc5_++;
         }
         this.nameTxt.htmlText = _loc4_;
         this.doLayout();
      }
      
      private function getInfoText(param1:String) : String
      {
         if(param1.search("@") > -1)
         {
            return "<a href=\'event:" + this.getIdByInfo(param1) + "\'><font color=\'#FF0000\'><u>" + this.getNameByInfo(param1) + "</u></font></a>";
         }
         return param1;
      }
      
      private function getNameByInfo(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("@");
         return param1.slice(_loc2_ + 1);
      }
      
      private function getIdByInfo(param1:String) : Number
      {
         var _loc2_:int = param1.indexOf("@");
         return Number(param1.slice(0,_loc2_));
      }
   }
}


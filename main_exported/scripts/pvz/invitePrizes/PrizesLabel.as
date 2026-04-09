package pvz.invitePrizes
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import node.Icon;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class PrizesLabel extends MovieClip
   {
      
      private var _mc:MovieClip;
      
      public function PrizesLabel(param1:Tool)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("prizesNode");
         this._mc = new _loc2_();
         Icon.setUrlIcon(this._mc["pic"],param1.getPicId(),Icon.TOOL_1);
         var _loc3_:DisplayObject = FuncKit.getNumEffect(param1.getNum() + "");
         this._mc["num"].addChild(_loc3_);
         this._mc["num"].x = 60 - _loc3_.width;
         this._mc["t"].text = param1.getName();
         this.addChild(this._mc);
      }
   }
}


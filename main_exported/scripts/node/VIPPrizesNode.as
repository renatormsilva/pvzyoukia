package node
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import manager.LangManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class VIPPrizesNode extends Sprite
   {
      
      private var _mc:MovieClip;
      
      public function VIPPrizesNode(param1:Object)
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         super();
         var _loc2_:Class = DomainAccess.getClass("prizesNode");
         this._mc = new _loc2_();
         if(param1 is Tool)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Tool).getPicId(),Icon.TOOL_1);
            _loc3_ = FuncKit.getNumEffect((param1 as Tool).getNum() + "");
            _loc3_.x = this._mc["pic"].width - _loc3_.width;
            _loc3_.y = this._mc["pic"].height - _loc3_.height;
            this._mc["pic"].addChild(_loc3_);
            this._mc["t"].text = (param1 as Tool).getName();
         }
         else
         {
            this._mc["pic"].addChild(Icon.getIcon(Icon.EMPIRISM,Icon.SYSTEM));
            _loc4_ = FuncKit.getNumEffect(param1 + "");
            _loc4_.x = this._mc["pic"].width - _loc4_.width;
            _loc4_.y = this._mc["pic"].height - _loc4_.height;
            this._mc["pic"].addChild(_loc4_);
            this._mc["t"].text = LangManager.getInstance().getLanguage("VIPPrezesNode001");
         }
         this.addChild(this._mc);
      }
   }
}


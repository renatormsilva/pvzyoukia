package labels
{
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import node.Icon;
   import zlib.utils.DomainAccess;
   
   public class PlayerUpGradeToolLabel extends Sprite
   {
      
      internal var _mc:MovieClip;
      
      public function PlayerUpGradeToolLabel(param1:Tool)
      {
         super();
         this._mc = this._mc;
         var _loc2_:Class = DomainAccess.getClass("playerUpGradeToolLabel");
         this._mc = new _loc2_();
         this._mc._num.text = param1.getName();
         Icon.setUrlIcon(this._mc._pic,param1.getPicId(),Icon.TOOL_1);
         this.addChild(this._mc);
      }
   }
}


package pvz.shaketree.view
{
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import node.Icon;
   import tip.ToolsTip;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class PassPrizeLabel extends Sprite
   {
      
      private var _mc:MovieClip;
      
      internal var _t:Tool;
      
      internal var tips:ToolsTip;
      
      public function PassPrizeLabel(param1:Tool)
      {
         super();
         this._t = param1;
         this.getMc("pvz.prizeLabel1");
         Icon.setUrlIcon(this._mc["picNode"],param1.getPicId(),Icon.TOOL_1);
         this.setName(param1.getName());
         this.setNum(param1.getNum());
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new ToolsTip();
         }
         this.tips.setTooltip(this._mc,this._t);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      private function getMc(param1:String) : void
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         this._mc = new _loc2_();
         this.addChild(this._mc);
      }
      
      private function setName(param1:String) : void
      {
         this._mc["txt"].text = param1;
      }
      
      private function setNum(param1:int) : void
      {
         this._mc["numNode"].addChild(FuncKit.getNumEffect(("x" + param1).toString()));
      }
      
      public function getPositionX() : int
      {
         return this.x + this.width;
      }
      
      public function getPositionY() : int
      {
         return this.y + 280;
      }
   }
}


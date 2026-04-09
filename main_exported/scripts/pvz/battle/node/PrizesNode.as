package pvz.battle.node
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Honor;
   import entity.Organism;
   import entity.Rmb;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import node.Icon;
   import utils.FuncKit;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class PrizesNode extends Sprite
   {
      
      private var _mc:MovieClip;
      
      public function PrizesNode(param1:Object)
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         super();
         var _loc2_:Class = DomainAccess.getClass("prizesNode");
         this._mc = new _loc2_();
         if(param1 is Tool)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Tool).getPicId(),Icon.TOOL_1);
            this._mc["t"].text = (param1 as Tool).getName();
            _loc3_ = FuncKit.getNumEffect((param1 as Tool).getNum() + "");
            this._mc["num"].addChild(_loc3_);
            this._mc["num"].x = 60 - _loc3_.width;
         }
         else if(param1 is Organism)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Organism).getPicId(),Icon.ORGANISM_1);
            _loc4_ = this.setQuality(XmlQualityConfig.getInstance().getID((param1 as Organism).getQuality_name()));
            this._mc.addChild(_loc4_);
            _loc4_.x = 0;
            _loc4_.y = this._mc.height - 2 * _loc4_.height - 3;
            this._mc["t"].text = (param1 as Organism).getName();
         }
         else if(param1 is Exp)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Exp).getPicId(),Icon.SYSTEM_1);
            this._mc["t"].text = (param1 as Exp).getName();
            _loc5_ = FuncKit.getNumEffect((param1 as Exp).getExpValue() + "");
            this._mc["num"].x = 60 - _loc5_.width;
            this._mc["num"].addChild(_loc5_);
         }
         else if(param1 is GameMoney)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as GameMoney).getPicId(),Icon.SYSTEM_1);
            this._mc["t"].text = (param1 as GameMoney).getName();
            _loc6_ = FuncKit.getMoneyArtDisplay((param1 as GameMoney).getMoneyValue());
            this._mc["num"].x = 60 - _loc6_.width;
            this._mc["num"].addChild(_loc6_);
         }
         else if(param1 is Rmb)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Rmb).getPicid(),Icon.TOOL_1);
            this._mc["t"].text = (param1 as Rmb).getName();
            _loc7_ = FuncKit.getMoneyArtDisplay((param1 as Rmb).getValue());
            this._mc["num"].x = 60 - _loc7_.width;
            this._mc["num"].addChild(_loc7_);
         }
         else if(param1 is Honor)
         {
            Icon.setUrlIcon(this._mc["pic"],(param1 as Honor).getPicId(),Icon.SYSTEM_1);
            this._mc["t"].text = (param1 as Honor).getName();
            _loc8_ = FuncKit.getNumEffect((param1 as Honor).getHonorValue() + "");
            this._mc["num"].x = 60 - _loc8_.width;
            this._mc["num"].addChild(_loc8_);
         }
         this.addChild(this._mc);
      }
      
      private function setQuality(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("_quality_small");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_.gotoAndStop(param1);
         return _loc3_;
      }
   }
}


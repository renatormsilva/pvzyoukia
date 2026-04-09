package pvz.arena.node
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import zlib.utils.DomainAccess;
   
   public class ArenaChooseRankNode extends Sprite
   {
      
      private var _backFun:Function = null;
      
      private var _mc:MovieClip = null;
      
      private var _type:int = 0;
      
      private var isSelected:Boolean = false;
      
      public function ArenaChooseRankNode(param1:int, param2:Function)
      {
         var _loc3_:Class = null;
         super();
         if(param1 != 0)
         {
            _loc3_ = DomainAccess.getClass("arena_rank_bt");
         }
         else
         {
            _loc3_ = DomainAccess.getClass("arena_rank_bt_all");
         }
         this._mc = new _loc3_();
         this._mc.gotoAndStop(1);
         this._mc.buttonMode = true;
         if(param1 != 0)
         {
            this._mc["levelshow"].gotoAndStop(1);
         }
         this._type = param1;
         this._backFun = param2;
         this.setTxtMc(param1);
         this.addEvent();
         addChild(this._mc);
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function setSelect(param1:Boolean) : void
      {
         this.isSelected = param1;
         if(param1)
         {
            this._mc.buttonMode = false;
            this._mc.gotoAndStop(3);
         }
         else
         {
            this._mc.buttonMode = true;
            this._mc.gotoAndStop(1);
         }
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._mc.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function getGradeMc(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + param1));
         return _loc3_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._backFun != null)
         {
            this._backFun(this._type);
         }
         this.setSelect(true);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this.isSelected)
         {
            return;
         }
         this._mc.gotoAndStop(1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.isSelected)
         {
            return;
         }
         this._mc.gotoAndStop(2);
      }
      
      private function setTxtMc(param1:int) : void
      {
         if(param1 < 1)
         {
            return;
         }
         if(param1 == 1)
         {
            this._mc["levelshow"]["_pic_lv1"].addChild(this.getGradeMc(10));
            this._mc["levelshow"]["_pic_lv2"].addChild(this.getGradeMc(19));
         }
         else if(param1 >= 10)
         {
            this._mc["levelshow"].gotoAndStop(2);
            this._mc["levelshow"].x = 5;
            this._mc["levelshow"].y = 4;
            this._mc["levelshow"].addChild(GetDomainRes.get100levelUpsp(param1 * 10));
         }
         else
         {
            this._mc["levelshow"]["_pic_lv1"].addChild(this.getGradeMc(param1 * 10));
            this._mc["levelshow"]["_pic_lv2"].addChild(this.getGradeMc((param1 + 1) * 10 - 1));
         }
      }
   }
}


package pvz.serverbattle.shop
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import node.Icon;
   import pvz.serverbattle.entity.MedalGoods;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class MedalGoodsLabel extends Sprite
   {
      
      private var _label:MovieClip = null;
      
      private var _goods:MedalGoods;
      
      private var _callback:Function;
      
      public function MedalGoodsLabel(param1:Function)
      {
         super();
         var _loc2_:Class = DomainAccess.getClass("madeGoodsLabel");
         this._label = new _loc2_();
         this._label.mouseChildren = false;
         this._label.mouseEnabled = true;
         this._label.buttonMode = true;
         addChild(this._label);
         this._callback = param1;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._label.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._label.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._label.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._label.gotoAndStop(2);
         MedalShopWindow._tips.setInfo(this._goods);
         MedalShopWindow._tips.setLocation(this);
         MedalShopWindow._tips.visible = true;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._label.gotoAndStop(1);
         MedalShopWindow._tips.visible = false;
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         if(this._callback != null)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this._callback(this._goods);
         }
      }
      
      public function setGoods(param1:MedalGoods) : void
      {
         this._goods = param1;
         if(this._goods)
         {
            FuncKit.clearAllChildrens(this._label["pic"]);
            if(this._goods.getType() == Icon.ORGANISM)
            {
               Icon.setUrlIcon(this._label["pic"],this._goods.getPicid(),Icon.ORGANISM_1);
               this._label["name_txt"].text = this._goods.getName();
               this._label["cost_txt"].text = this._goods.getCost() + "功勋";
            }
            else if(this._goods.getType() == Icon.TOOL)
            {
               Icon.setUrlIcon(this._label["pic"],this._goods.getPicid(),Icon.TOOL_1);
               this._label["name_txt"].text = this._goods.getName();
               this._label["cost_txt"].text = this._goods.getCost() + "功勋";
            }
         }
      }
      
      public function destory() : void
      {
         this._label.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._label.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         this._label.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this._goods = null;
         this._callback = null;
      }
   }
}


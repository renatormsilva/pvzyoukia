package pvz.possession
{
   import entity.Player;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import manager.LangManager;
   import manager.SoundManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class RecommenNode extends Sprite
   {
      
      private var _p:Player = null;
      
      private var _backFun:Function = null;
      
      private var _node:MovieClip = null;
      
      public function RecommenNode(param1:Player, param2:Function, param3:Point)
      {
         super();
         this._p = param1;
         this._backFun = param2;
         this.show();
         this.x = param3.x;
         this.y = param3.y;
         this.buttonMode = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._node["_bg"].gotoAndStop(2);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._node["_bg"].gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this._backFun(this._p);
      }
      
      private function show() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_recommenNode");
         if(_loc1_ == null)
         {
            throw new Error(LangManager.getInstance().getLanguage("possession026"));
         }
         this._node = new _loc1_();
         this._node["_bg"].gotoAndStop(1);
         addChild(this._node);
         this.addEvent();
         PlantsVsZombies.setHeadPic(this._node["_pic_head"],PlantsVsZombies.getHeadPicUrl(this._p.getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this._p.getVipTime(),this._p.getVipLevel());
         var _loc2_:Class = DomainAccess.getClass("grade");
         var _loc3_:MovieClip = new _loc2_();
         _loc3_["num"].addChild(FuncKit.getNumEffect("" + this._p.getGrade()));
         _loc3_.x = -_loc3_.width / 2;
         this._node["_pic_lv"].addChild(_loc3_);
         if(this._p.getNickname() != null)
         {
            this._node["_txt_name"].text = this._p.getNickname();
         }
      }
   }
}


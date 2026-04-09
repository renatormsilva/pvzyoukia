package pvz.registration.view.item
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import pvz.registration.control.RegistrationMgr;
   import pvz.registration.data.SignDataVo;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class RegItem extends Sprite
   {
      
      private var _id:int;
      
      private var _data:SignDataVo;
      
      private var icon:Sprite;
      
      private var stateB:Bitmap;
      
      private var trueB:Bitmap;
      
      private var _tooltip:ToolsTip;
      
      private var num:TextField;
      
      public function RegItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = GetDomainRes.getBitmap("pvz.reg.itemBg");
         this.addChild(_loc1_);
         this.icon = new Sprite();
         this.addChild(this.icon);
         this.stateB = new Bitmap();
         this.icon.addChild(this.stateB);
         this.trueB = GetDomainRes.getBitmap("pvz.reg.boxok");
         this.trueB.visible = false;
         this.addChild(this.trueB);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
         this.upData(this._id);
      }
      
      public function upData(param1:int) : void
      {
         this._data = RegistrationMgr.getInstance().getSignPz(param1);
         if(!this._data || param1 < 1)
         {
            if(this.stateB.parent)
            {
               this.stateB.parent.removeChild(this.stateB);
            }
            return;
         }
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         if(this._data.state == 0)
         {
            this.trueB.visible = false;
            this.stateB.bitmapData = GetDomainRes.getBitmapData("pvz.reg.box1");
         }
         else if(this._data.state == 1)
         {
            this.trueB.visible = false;
            this.stateB.bitmapData = GetDomainRes.getBitmapData("pvz.reg.box1");
         }
         else
         {
            this.stateB.bitmapData = GetDomainRes.getBitmapData("pvz.reg.box0");
            this.trueB.visible = true;
         }
         var _loc2_:Number = RegistrationMgr.getInstance().ctrl.vo.time;
         var _loc3_:Date = new Date(_loc2_ * 1000);
         if(param1 < _loc3_.date)
         {
            FuncKit.setNoColor(this.stateB);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._data.reward.data())
         {
            if(!this._tooltip)
            {
               this._tooltip = new ToolsTip();
            }
            this._tooltip.setTooltip(this,this._data.reward.data());
            this._tooltip.setLoction(this.getPositionX(),this.getPositionY());
         }
      }
      
      public function getPositionX() : int
      {
         return this.parent.x + this.width + 55;
      }
      
      public function getPositionY() : int
      {
         return this.parent.y + 55;
      }
   }
}


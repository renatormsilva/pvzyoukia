package pvz.newTask.view.item
{
   import entity.Exp;
   import entity.GameMoney;
   import entity.Honor;
   import entity.Organism;
   import entity.Rmb;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import tip.ToolsTip;
   import utils.GetDomainRes;
   import utils.TextFilter;
   import zlib.utils.Func;
   
   public class ItemReward extends Sprite
   {
      
      private var _vo:*;
      
      private var iocn:Sprite;
      
      private var tfnum:TextField;
      
      private var tooltip:ToolsTip;
      
      public function ItemReward()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.iocn = new Sprite();
         this.addChild(this.iocn);
         var _loc1_:TextFormat = new TextFormat(null,14,16776192,true,true,null,null,null,TextFormatAlign.LEFT);
         this.tfnum = new TextField();
         this.tfnum.selectable = false;
         this.tfnum.defaultTextFormat = _loc1_;
         this.tfnum.x = 33;
         this.tfnum.y = 15;
         this.tfnum.text = "x0";
         this.addChild(this.tfnum);
         this.addEventListener(MouseEvent.ROLL_OVER,this.over);
      }
      
      public function upData(param1:Object) : void
      {
         var iconBit:MovieClip = null;
         var obj:Object = param1;
         Func.clearAllChildrens(this.iocn);
         this.tfnum.text = "x0";
         this._vo = obj;
         if(this._vo is Tool)
         {
            try
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + this._vo.getPicId());
            }
            catch(e:Error)
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + 266);
            }
            this.iocn.addChild(iconBit);
            this.tfnum.text = "x" + this._vo.getNum();
         }
         else if(!(this._vo is Organism))
         {
            if(this._vo is Exp)
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + this._vo.getPicId());
               this.iocn.addChild(iconBit);
               this.tfnum.text = "x" + Exp(this._vo).getExpValue();
            }
            else if(this._vo is GameMoney)
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + this._vo.getPicId());
               this.iocn.addChild(iconBit);
               this.tfnum.text = "x" + GameMoney(this._vo).getMoneyValue();
            }
            else if(this._vo is Rmb)
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + this._vo.getPicid());
               this.iocn.addChild(iconBit);
               this.tfnum.text = "x" + Rmb(this._vo).getValue();
            }
            else if(this._vo is Honor)
            {
               iconBit = GetDomainRes.getMoveClip("pvz.newTask.icon_" + this._vo.getPicId());
               this.iocn.addChild(iconBit);
               this.tfnum.text = "x" + Honor(this._vo).getHonorValue();
            }
         }
         this.tfnum.width = this.tfnum.textWidth + 5;
         this.tfnum.height = this.tfnum.textHeight + 4;
         TextFilter.MiaoBian(this.tfnum,0);
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(!this.tooltip)
         {
            this.tooltip = new ToolsTip();
         }
         if(this._vo is Tool)
         {
            this.tooltip.setTooltip(this,this._vo);
            this.tooltip.setLoction(this.getPositionX(),param1.stageY);
         }
      }
      
      public function getPositionX() : int
      {
         if(this.parent.x + this.parent.parent.parent.x + this.width + 20 > 600)
         {
            return this.parent.x - 2 * this.width - 45;
         }
         return this.parent.x + this.width + 40;
      }
      
      public function getPositionY() : int
      {
         return this.parent.y + this.parent.parent.y;
      }
      
      public function remove() : void
      {
      }
   }
}


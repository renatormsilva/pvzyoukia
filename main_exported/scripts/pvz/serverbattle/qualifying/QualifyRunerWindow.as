package pvz.serverbattle.qualifying
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pvz.serverbattle.entity.Contestant;
   import pvz.serverbattle.tip.GuessPlantsTip;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.StringMovieClip;
   
   public class QualifyRunerWindow extends Sprite
   {
      
      private static const MAX:int = 6;
      
      private var plantsArea:Sprite;
      
      private var _type:int;
      
      private var nowPage:int = 1;
      
      private var labelWidth:Number = 68;
      
      private var plants:Array;
      
      private var maxPage:int;
      
      private var orgTip:GuessPlantsTip;
      
      public function QualifyRunerWindow(param1:int)
      {
         super();
         this._type = param1;
         if(param1 == 0)
         {
            this.plantsArea = GetDomainRes.getSprite("serverbattle.qualitying.plantsarealeft");
         }
         else if(param1 == 1)
         {
            this.plantsArea = GetDomainRes.getSprite("serverbattle.qualitying.plantsarearight");
         }
         this.addChild(this.plantsArea);
         this.addMouseEvent();
      }
      
      public function setArea(param1:Contestant) : void
      {
         FuncKit.clearAllChildrens(this.plantsArea["pic"]);
         FuncKit.clearAllChildrens(this.plantsArea["level"]);
         FuncKit.clearAllChildrens(this.plantsArea["level"]);
         PlantsVsZombies.setHeadPic(this.plantsArea["pic"],PlantsVsZombies.getHeadPicUrl(param1.getfaceUrl()),PlantsVsZombies.HEADPIC_BIG,param1.getVipTime(),param1.getVipGrade());
         var _loc2_:Sprite = GetDomainRes.getSprite("grade");
         _loc2_["num"].addChild(StringMovieClip.getStringImage(param1.getGrade() + "","Exp"));
         this.plantsArea["level"].addChild(_loc2_);
         this.plantsArea["names"].text = param1.getName();
         this.plantsArea["integral"].text = "积分：" + param1.getIntegral();
         this.plantsArea["integral"].selectable = false;
         this.plantsArea["servername"].text = param1.getServerName();
         this.plantsArea["servername"].selectable = false;
         this.setPlantArea(param1.getRunPlants());
      }
      
      public function setPlantArea(param1:Array) : void
      {
         this.clearPlantsnode();
         this.nowPage = 1;
         this.plants = param1;
         this.maxPage = (this.plants.length - 1) / MAX + 1;
         this.setPageButtonVisible(0);
         this.setPlants();
      }
      
      private function addMouseEvent() : void
      {
         this.plantsArea["right"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.plantsArea["left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.plantsArea["plantsnode"].addEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.plantsArea["plantsnode"].addEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
      }
      
      private function removeMouseEvent() : void
      {
         this.plantsArea["right"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.plantsArea["left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.plantsArea["plantsnode"].removeEventListener(MouseEvent.MOUSE_OVER,this.onPlantsOver);
         this.plantsArea["plantsnode"].removeEventListener(MouseEvent.MOUSE_OUT,this.onPlantsOut);
      }
      
      private function onPlantsOver(param1:MouseEvent) : void
      {
         var _loc2_:PlantsLabel = param1.target as PlantsLabel;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_._o == null)
         {
            return;
         }
         if(this.orgTip == null)
         {
            this.orgTip = new GuessPlantsTip(90,44);
         }
         this.orgTip.visible = true;
         this.orgTip.setInfo(_loc2_._o);
         PlantsVsZombies._node.addChild(this.orgTip);
         this.orgTip.x = this.x + this.plantsArea["plantsnode"].x + _loc2_.x - 15;
         this.orgTip.y = this.y + this.plantsArea["plantsnode"].y + _loc2_.y - this.orgTip.height;
      }
      
      private function onPlantsOut(param1:MouseEvent) : void
      {
         var _loc2_:PlantsLabel = param1.target as PlantsLabel;
         if(_loc2_ == null || this.orgTip == null)
         {
            return;
         }
         if(_loc2_._o == null)
         {
            return;
         }
         if(this.orgTip.visible)
         {
            this.orgTip.visible = false;
         }
         PlantsVsZombies._node.removeChild(this.orgTip);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "right")
         {
            if(this.nowPage >= this.maxPage)
            {
               return;
            }
            ++this.nowPage;
            this.setPlants();
         }
         else if(param1.currentTarget.name == "left")
         {
            if(this.nowPage <= 1)
            {
               return;
            }
            --this.nowPage;
            this.setPlants();
         }
      }
      
      private function setPageButtonVisible(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this.plantsArea["right"].visible = false;
               this.plantsArea["left"].visible = false;
               break;
            case 1:
               this.plantsArea["right"].visible = true;
               this.plantsArea["left"].visible = false;
               break;
            case 2:
               this.plantsArea["right"].visible = false;
               this.plantsArea["left"].visible = true;
               break;
            case 3:
               this.plantsArea["right"].visible = true;
               this.plantsArea["left"].visible = true;
         }
      }
      
      private function setPlants() : void
      {
         var _loc3_:Array = null;
         var _loc4_:PlantsLabel = null;
         var _loc5_:PlantsLabel = null;
         FuncKit.clearAllChildrens(this.plantsArea["plantsnode"]);
         if(this.nowPage * MAX >= this.plants.length)
         {
            if(this.nowPage >= 2)
            {
               this.setPageButtonVisible(2);
            }
            _loc3_ = this.plants.slice((this.nowPage - 1) * MAX,this.plants.length);
         }
         else
         {
            this.setPageButtonVisible(1);
            if(this.nowPage >= 2)
            {
               this.setPageButtonVisible(3);
            }
            _loc3_ = this.plants.slice((this.nowPage - 1) * MAX,this.nowPage * MAX);
         }
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc4_ = new PlantsLabel(_loc3_[_loc1_]);
            _loc4_.mouseChildren = false;
            if(this._type)
            {
               _loc4_.x = -(_loc1_ + 1) * this.labelWidth;
            }
            else
            {
               _loc4_.x = _loc1_ * this.labelWidth;
            }
            this.plantsArea["plantsnode"].addChild(_loc4_);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < MAX - _loc3_.length)
         {
            _loc5_ = new PlantsLabel(null);
            _loc5_.mouseChildren = false;
            _loc5_.mouseEnabled = false;
            if(this._type)
            {
               _loc5_.x = -(_loc2_ + _loc3_.length + 1) * this.labelWidth;
            }
            else
            {
               _loc5_.x = (_loc2_ + _loc3_.length) * this.labelWidth;
            }
            this.plantsArea["plantsnode"].addChild(_loc5_);
            _loc2_++;
         }
      }
      
      private function clearPlantsnode() : void
      {
         var _loc1_:PlantsLabel = null;
         while(this.plantsArea["plantsnode"].numChildren > 0)
         {
            _loc1_ = this.plantsArea["plantsnode"].getChildAt(0) as PlantsLabel;
            _loc1_.dispose();
         }
      }
      
      public function dispose() : void
      {
         FuncKit.clearAllChildrens(this.plantsArea["level"]);
         this.clearPlantsnode();
         FuncKit.clearAllChildrens(this);
         this.removeMouseEvent();
         this.plantsArea = null;
         this.plants = null;
      }
   }
}


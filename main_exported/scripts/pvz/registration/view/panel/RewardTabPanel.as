package pvz.registration.view.panel
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import manager.SoundManager;
   import pvz.registration.data.PrizeNeedInfoVo;
   import pvz.registration.data.RewardData;
   import pvz.registration.view.panel.module.Scale9Image;
   import pvz.registration.view.panel.module.TabPanel;
   import pvz.registration.view.panel.module.TabPanelItem;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class RewardTabPanel extends Sprite
   {
      
      private var bg:Scale9Image;
      
      private var _tabPanels:TabPanel;
      
      private var _tabs:Vector.<TabPanelItem>;
      
      private var _data:Object;
      
      private var _st:String;
      
      private var _st1:String;
      
      private var _prizeSp:Sprite;
      
      private var _currentVo:PrizeNeedInfoVo;
      
      private var _call:Function;
      
      private var btn:SimpleButton;
      
      private var btned:Bitmap;
      
      public function RewardTabPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._tabPanels = new TabPanel(300,155);
         this._tabPanels.marginTitle = 1;
         this._tabPanels.x = 7;
         this._tabPanels.y = 0.5;
         this._tabs = new Vector.<TabPanelItem>();
         this._tabPanels.addEventListener(TabPanel.EVENT_TAB_SELECT,this.onTabSelect);
         var _loc1_:Rectangle = new Rectangle(7,7,5,5);
         this.bg = new Scale9Image(GetDomainRes.getBitmapData("pvz.reg.panelBg"),_loc1_);
         this.bg.repeatFillLeft = this.bg.repeatFillRight = this.bg.repeatFillCenter = false;
         this.bg.width = 305;
         this.bg.height = 135;
         this.bg.y = 30;
         this.addChild(this.bg);
         this.addChild(this._tabPanels);
         this._prizeSp = new Sprite();
         this._prizeSp.x = 10;
         this._prizeSp.y = 40;
         this.addChild(this._prizeSp);
         this.btned = GetDomainRes.getBitmap("pvz.reg.btnGetPrizeed");
         this.btned.x = (305 - this.btned.width) * 0.5;
         this.btned.y = 118;
         this.btned.visible = false;
         this.addChild(this.btned);
         this.btn = GetDomainRes.getSimpleButton("pvz.reg.btnGetPrize");
         this.btn.x = (305 - this.btn.width) * 0.5;
         this.btn.y = 118;
         this.addChild(this.btn);
      }
      
      protected function onTabSelect(param1:Event) : void
      {
         if(this._currentVo)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         var _loc2_:String = param1.currentTarget.selectedTab.name;
         var _loc3_:int = int(_loc2_.slice(this._st.length,_loc2_.length - this._st1.length));
         this.select(_loc3_);
      }
      
      private function select(param1:int) : void
      {
         var _loc2_:RewardData = null;
         var _loc3_:prizeItem = null;
         FuncKit.clearAllChildrens(this._prizeSp);
         this._currentVo = this.getPrizes(param1);
         for each(_loc2_ in this._currentVo.rewards)
         {
            _loc3_ = new prizeItem();
            _loc3_.upData(_loc2_);
            this._prizeSp.addChild(_loc3_);
         }
         this.layoutHorizontal(this._prizeSp);
         this._prizeSp.x = 10 + (285 - this._prizeSp.width) * 0.5;
         if(this._currentVo.state == 1)
         {
            this.btn.mouseEnabled = this.btn.mouseChildren = true;
            FuncKit.clearNoColorState(this.btn);
            this.btn.addEventListener(MouseEvent.CLICK,this.click);
            this.btned.visible = false;
            this.btn.visible = true;
         }
         else if(this._currentVo.state == 2)
         {
            this.btn.mouseEnabled = this.btn.mouseChildren = false;
            this.btn.removeEventListener(MouseEvent.CLICK,this.click);
            FuncKit.setNoColor(this.btned);
            this.btn.visible = false;
            this.btned.visible = true;
         }
         else
         {
            this.btn.mouseEnabled = this.btn.mouseChildren = false;
            this.btn.removeEventListener(MouseEvent.CLICK,this.click);
            FuncKit.setNoColor(this.btn);
            this.btned.visible = false;
            this.btn.visible = true;
         }
      }
      
      public function upData(param1:Object, param2:String, param3:String, param4:Function) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TabPanelItem = null;
         if(param1 is Array)
         {
            this._st = param2;
            this._st1 = param3;
            this._data = param1;
            this._call = param4;
            this._currentVo = null;
            this._tabs.length = 0;
            this._tabPanels.dispose();
            _loc5_ = param1 as Array;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc9_ = new TabPanelItem(GetDomainRes.getMoveClip("pvz.reg.tab"),new Sprite(),0,param2 + _loc5_[_loc6_].count + this._st1,false,true);
               this._tabs.push(_loc9_);
               _loc6_++;
            }
            _loc7_ = 0;
            while(_loc7_ < this._tabs.length)
            {
               this._tabPanels.addTab(this._tabs[_loc7_]);
               _loc7_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(Boolean(_loc5_[_loc8_]) && Boolean(_loc5_[_loc8_].state == 1) || _loc5_[_loc8_].state == 0)
               {
                  this._tabPanels.setSelectedID(_loc8_);
                  this.select(_loc5_[_loc8_].count);
                  return;
               }
               _loc8_++;
            }
            this._tabPanels.setSelectedID(_loc5_.length - 1);
            this.select(_loc5_[_loc5_.length - 1].count);
         }
      }
      
      private function getPrizes(param1:int) : PrizeNeedInfoVo
      {
         var _loc2_:PrizeNeedInfoVo = null;
         for each(_loc2_ in this._data)
         {
            if(_loc2_.count == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function layoutHorizontal(param1:DisplayObjectContainer, param2:Number = 0, param3:int = 0) : void
      {
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:int = param1.numChildren;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:int = param3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc7_.x = _loc5_;
            _loc5_ = _loc7_.width + _loc7_.x + param2;
            _loc6_++;
         }
      }
      
      private function click(param1:MouseEvent) : void
      {
         this._call.call(null,this._currentVo);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import node.Icon;
import pvz.registration.data.RewardData;
import tip.ToolsTip;
import utils.FuncKit;

class prizeItem extends Sprite
{
   
   private var icon:Sprite;
   
   private var _tooltip:ToolsTip;
   
   private var _data:RewardData;
   
   public function prizeItem()
   {
      super();
      this.init();
   }
   
   private function init() : void
   {
      this.graphics.beginFill(0,0);
      this.graphics.drawRect(0,0,60,70);
      this.graphics.endFill();
      this.icon = new Sprite();
      this.addChild(this.icon);
   }
   
   public function upData(param1:RewardData) : void
   {
      var _loc2_:DisplayObject = null;
      this._data = param1;
      FuncKit.clearAllChildrens(this.icon);
      if(param1.type == 2)
      {
         Icon.setUrlIcon(this.icon,param1.rmb.getPicid(),Icon.TOOL_1);
         _loc2_ = FuncKit.getNumEffect("" + param1.rmb.getValue());
         _loc2_.y = 72 - _loc2_.height - 5;
         _loc2_.x = 60 - _loc2_.width - 5;
         this.addChild(_loc2_);
      }
      else if(param1.type == 3)
      {
         Icon.setUrlIcon(this.icon,param1.gameMoney.getPicId(),Icon.MONEY_1);
         _loc2_ = FuncKit.getNumEffect("" + param1.gameMoney.getMoneyValue());
         _loc2_.y = 72 - _loc2_.height - 5;
         _loc2_.x = 60 - _loc2_.width - 5;
         this.addChild(_loc2_);
      }
      else
      {
         Icon.setUrlIcon(this.icon,param1.tool.getPicId(),Icon.TOOL_1);
         _loc2_ = FuncKit.getNumEffect("" + param1.tool.getNum());
         _loc2_.y = 72 - _loc2_.height - 5;
         _loc2_.x = 60 - _loc2_.width - 5;
         this.addChild(_loc2_);
      }
      this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
      this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
   }
   
   private function onOver(param1:MouseEvent) : void
   {
      var _loc2_:Point = null;
      if(this._data.data())
      {
         if(!this._tooltip)
         {
            this._tooltip = new ToolsTip();
         }
         this._tooltip.setTooltip(this,this._data.data());
         _loc2_ = this.calculateTipPosition(param1.stageX - param1.target.x,param1.stageY);
         this._tooltip.setLoction(_loc2_.x,_loc2_.y);
      }
   }
   
   protected function calculateTipPosition(param1:Number, param2:Number) : Point
   {
      var _loc3_:Point = new Point();
      _loc3_.y = param2 + 0 - 50;
      _loc3_.x = param1 + 20 + 0;
      if(_loc3_.x + 175 > PlantsVsZombies.WIDTH)
      {
         _loc3_.x = _loc3_.x - 175 - 30;
      }
      if(_loc3_.y + 125 > PlantsVsZombies.HEIGHT)
      {
         _loc3_.y = PlantsVsZombies.HEIGHT - 125;
      }
      if(_loc3_.y < 0)
      {
         _loc3_.y = 0;
      }
      if(_loc3_.y > -1)
      {
         _loc3_.y = -1 > 0 ? -1 : _loc3_.y;
      }
      return _loc3_;
   }
}

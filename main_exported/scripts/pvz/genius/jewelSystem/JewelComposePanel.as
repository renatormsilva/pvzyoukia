package pvz.genius.jewelSystem
{
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.genius.fport.JewelSystermFPort;
   import pvz.genius.jewelSystem.event.UpdateJewelStorageEvent;
   import utils.FuncKit;
   import xmlReader.config.XmlChangeJewelConfig;
   
   public class JewelComposePanel extends BasePanel
   {
      
      private var _callback:Function;
      
      private var _costJewel:Tool;
      
      private var _targetJewel:Tool;
      
      private var _composeNum:int = 1;
      
      private var _ratio:int = 1;
      
      private var _moneyRatio:Number = 1;
      
      private var _maxComposeNum:int;
      
      private var playerManager:PlayerManager;
      
      private var _fport:JewelSystermFPort;
      
      public function JewelComposePanel()
      {
         super("jewel.JewelComposePanel");
         this.playerManager = PlantsVsZombies.playerManager;
         _ui._toGetJewel.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         this._fport = new JewelSystermFPort();
         this.setDefault();
      }
      
      public function setNoteWordsInfo(param1:Tool) : void
      {
         if(param1)
         {
            _ui._note_txt.htmlText = LangManager.getInstance().getLanguage("genius033") + "<font color=\'#ff0000\' size=\'15\'><center>" + param1.getName() + "</center></font>" + LangManager.getInstance().getLanguage("genius034");
         }
         else
         {
            _ui._note_txt.text = LangManager.getInstance().getLanguage("genius032");
         }
      }
      
      private function setDefault() : void
      {
         _ui._txt1.mouseEnabled = false;
         _ui._txt2.mouseEnabled = false;
         _ui._txt4.mouseEnabled = false;
         _ui._numNode1.visible = false;
         _ui._numNode2.visible = false;
         _ui._txt1.visible = _ui._txt2.visible = _ui._prebtn1.visible = _ui._nextbtn1.visible = false;
         _ui._txt1.text = _ui._txt2.text = _ui._txt3.text = _ui._txt4.text = 0;
         this.clearAllEvent();
      }
      
      private function addEvent() : void
      {
         _ui._prebtn1.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._nextbtn1.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._prebtn2.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._nextbtn2.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._componseBtn.addEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._txt3.addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         _ui._txt3.addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         _ui._node1.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui._node1.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui._node2.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui._node2.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(param1.target.name == "_node1")
         {
            if(this._costJewel)
            {
               JewelComposeWindow.jewelTips.setInfo(this._costJewel);
               JewelComposeWindow.jewelTips.visible = true;
               JewelComposeWindow.jewelTips.Layout(param1.target.x - 365,param1.target.y);
            }
         }
         else if(param1.target.name == "_node2")
         {
            if(this._targetJewel)
            {
               JewelComposeWindow.jewelTips.setInfo(this._targetJewel);
               JewelComposeWindow.jewelTips.visible = true;
               JewelComposeWindow.jewelTips.Layout(param1.target.x - 375,param1.target.y);
            }
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         JewelComposeWindow.jewelTips.visible = false;
      }
      
      private function onPanelClick(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "_prebtn1":
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               this.selectPreLevelJewel();
               break;
            case "_nextbtn1":
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               this.selectNextLevelJewel();
               break;
            case "_prebtn2":
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               this.reduceJewelNum();
               break;
            case "_nextbtn2":
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               this.addJewelNum();
               break;
            case "_componseBtn":
               PlantsVsZombies.playSounds(SoundManager.BUTTON1);
               this.toCompose();
               break;
            case "_toGetJewel":
               PlantsVsZombies.playSounds(SoundManager.BUTTON1);
               this.toGetJewel();
         }
      }
      
      private function toGetJewel() : void
      {
         var callback:Function = null;
         callback = function():void
         {
            var _loc1_:UpdateJewelStorageEvent = new UpdateJewelStorageEvent(true);
            _ui.dispatchEvent(_loc1_);
         };
         new GetJewelWindow(null,callback);
      }
      
      private function toCompose() : void
      {
         var end:Function = null;
         end = function(param1:Object):void
         {
            _ui._componseBtn.addEventListener(MouseEvent.MOUSE_UP,onPanelClick);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("genius016",_targetJewel.getName(),_composeNum));
            PlantsVsZombies.changeMoneyOrExp(-_composeNum * _moneyRatio,PlantsVsZombies.MONEY,true,false);
            playerManager.getPlayer().updateTool(_costJewel.getOrderId(),_costJewel.getNum() - _composeNum * _ratio);
            playerManager.getPlayer().updateTool(_targetJewel.getOrderId(),int(param1));
            if(_costJewel.getNum() <= 0)
            {
               FuncKit.clearAllChildrens(_ui._node1);
               FuncKit.clearAllChildrens(_ui._node2);
               setDefault();
            }
            else
            {
               _maxComposeNum = Math.floor(_costJewel.getNum() / _ratio);
               if(_maxComposeNum == 0)
               {
                  _maxComposeNum = 1;
               }
               _composeNum = _maxComposeNum;
               updateComposeNum();
            }
            if(_callback != null)
            {
               _callback();
            }
         };
         if(this._composeNum * this._moneyRatio > PlantsVsZombies.playerManager.getPlayer().getMoney())
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("genius029"));
            return;
         }
         if(this._composeNum * this._ratio > PlantsVsZombies.playerManager.getPlayer().getTool(this._costJewel.getOrderId()).getNum())
         {
            new GetJewelWindow(this._costJewel,null,GetJewelWindow.OPEN_IN_LACK);
            return;
         }
         _ui._componseBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         this._fport.requestSever(JewelSystermFPort.COMPONSE,end,this._targetJewel.getOrderId(),this._costJewel.getOrderId(),this._composeNum);
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(_ui._txt3.text == "")
         {
            this._composeNum = 1;
         }
         else
         {
            this._composeNum = int(_ui._txt3.text);
         }
         if(this._composeNum > this._maxComposeNum)
         {
            this._composeNum = this._maxComposeNum;
         }
         else if(this._composeNum <= 1)
         {
            this._composeNum = 1;
         }
         this.updateComposeNum();
         this.showRightJewelInfo();
      }
      
      private function selectPreLevelJewel() : void
      {
         if(this._targetJewel.getOrderId() == XmlChangeJewelConfig.getInstance().getNextLevelJewelId(this._costJewel.getOrderId()))
         {
            return;
         }
         this._targetJewel = new Tool(XmlChangeJewelConfig.getInstance().getPreLevelJewelId(this._targetJewel.getOrderId()));
         this.getRatio();
         this._maxComposeNum = Math.floor(this._costJewel.getNum() / this._ratio);
         if(this._maxComposeNum == 0)
         {
            this._maxComposeNum = 1;
         }
         this._composeNum = this._maxComposeNum;
         this.updateComposeNum();
         this.showRightJewelInfo();
      }
      
      private function selectNextLevelJewel() : void
      {
         if(!XmlChangeJewelConfig.getInstance().isUseToExchanged(this._targetJewel.getOrderId()))
         {
            return;
         }
         this._targetJewel = new Tool(XmlChangeJewelConfig.getInstance().getNextLevelJewelId(this._targetJewel.getOrderId()));
         this.getRatio();
         this._maxComposeNum = Math.floor(this._costJewel.getNum() / this._ratio);
         if(this._maxComposeNum == 0)
         {
            this._maxComposeNum = 1;
         }
         this._composeNum = this._maxComposeNum;
         this.updateComposeNum();
         this.showRightJewelInfo();
      }
      
      private function addJewelNum() : void
      {
         if(this._composeNum >= this._maxComposeNum)
         {
            return;
         }
         ++this._composeNum;
         this.updateComposeNum();
      }
      
      private function reduceJewelNum() : void
      {
         if(this._composeNum <= 1)
         {
            return;
         }
         --this._composeNum;
         this.updateComposeNum();
      }
      
      public function initUI(param1:int, param2:Function) : void
      {
         this._callback = param2;
         FuncKit.clearAllChildrens(_ui._numNode1);
         FuncKit.clearAllChildrens(_ui._numNode2);
         _ui._numNode1.visible = true;
         _ui._numNode2.visible = true;
         _ui._txt1.visible = _ui._txt2.visible = _ui._prebtn1.visible = _ui._nextbtn1.visible = true;
         this._costJewel = this.playerManager.getPlayer().getTool(param1);
         this._targetJewel = new Tool(XmlChangeJewelConfig.getInstance().getNextLevelJewelId(param1));
         this.getRatio();
         this._maxComposeNum = Math.floor(this._costJewel.getNum() / this._ratio);
         if(this._maxComposeNum == 0)
         {
            this._maxComposeNum = 1;
         }
         this._composeNum = this._maxComposeNum;
         this.updateComposeNum();
         this.showLeftJewelInfo();
         this.showRightJewelInfo();
         this.addEvent();
      }
      
      private function updateComposeNum() : void
      {
         var _loc1_:DisplayObject = FuncKit.getNumEffect(this._composeNum * this._ratio + "");
         var _loc2_:DisplayObject = FuncKit.getNumEffect(this._composeNum + "");
         FuncKit.clearAllChildrens(_ui._numNode1);
         FuncKit.clearAllChildrens(_ui._numNode2);
         _ui["_numNode1"].addChild(_loc1_);
         _ui["_numNode2"].addChild(_loc2_);
         _loc1_.x = -_loc1_.width;
         _loc2_.x = -_loc2_.width;
         _ui["_txt3"].text = this._composeNum;
         _ui["_txt4"].text = this._composeNum * this._moneyRatio;
      }
      
      private function showLeftJewelInfo() : void
      {
         Icon.setUrlIcon(_ui["_node1"],this._costJewel.getPicId(),Icon.TOOL_1);
         _ui["_txt1"].text = this._costJewel.getName();
      }
      
      private function showRightJewelInfo() : void
      {
         Icon.setUrlIcon(_ui["_node2"],this._targetJewel.getPicId(),Icon.TOOL_1);
         _ui["_txt2"].text = this._targetJewel.getName();
      }
      
      private function getRatio() : void
      {
         this._ratio = XmlChangeJewelConfig.getInstance().getExchangeRatio(this._costJewel.getOrderId(),this._targetJewel.getOrderId());
         this._moneyRatio = XmlChangeJewelConfig.getInstance().getCostMoneyByTargetId(this._costJewel.getOrderId(),this._targetJewel.getOrderId());
      }
      
      private function clearAllEvent() : void
      {
         _ui._prebtn1.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._nextbtn1.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._prebtn2.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._nextbtn2.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._componseBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
         _ui._txt3.removeEventListener(KeyboardEvent.KEY_UP,this.setNum);
         _ui._txt3.removeEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         _ui._node1.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui._node1.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         _ui._node2.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         _ui._node2.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      override public function destroy() : void
      {
         this.clearAllEvent();
         _ui._toGetJewel.removeEventListener(MouseEvent.MOUSE_UP,this.onPanelClick);
      }
   }
}


package pvz.serverbattle.knockout.guessResult
{
   import effect.flip.IEffectFlipDisplayObject;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.invitePrizes.PrizeWindow;
   import pvz.serverbattle.entity.Guess;
   import pvz.serverbattle.entity.User;
   import pvz.serverbattle.fport.GuessResultFPort;
   import pvz.serverbattle.knockout.guess.GuessPanel;
   import pvz.serverbattle.tip.GuessResultTips;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class GuessResultNode extends Sprite implements IEffectFlipDisplayObject
   {
      
      private static const BOX_URL:String = "box_";
      
      private var _label:MovieClip;
      
      private var _data:Guess;
      
      private var _fport:GuessResultFPort;
      
      private var _tool:Tool;
      
      private var _tips:GuessResultTips;
      
      public function GuessResultNode()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("guessingPanelNode");
         this._label = new _loc1_();
         this.addChild(this._label);
         this.initUI();
         this.hideAllmc();
         this.addEvent();
         this._fport = new GuessResultFPort(this);
         this._tips = new GuessResultTips();
         this.addChild(this._tips);
         this._tips.visible = false;
      }
      
      private function initUI() : void
      {
         this._label["_guessMc1"].visible = false;
         this._label["_guessMc1"].mouseEnabled = false;
         this._label["_guessMc1"].mouseChildren = false;
         this._label["_winMc1"].mouseEnabled = false;
         this._label["_winMc1"].mouseChildren = false;
         this._label["_guessMc2"].mouseEnabled = false;
         this._label["_guessMc2"].mouseChildren = false;
         this._label["_winMc2"].mouseEnabled = false;
         this._label["_winMc2"].mouseChildren = false;
         this._label["_box_pos"]["_baoji"].mouseEnabled = false;
         this._label["_box_pos"]["_baoji"].mouseChildren = false;
         this._label["_bgmc"].mouseEnabled = false;
         this._label["_bgmc"].mouseChildren = false;
      }
      
      private function addEvent() : void
      {
         this._label["_btn"].addEventListener(MouseEvent.MOUSE_UP,this.buttonClick);
      }
      
      private function buttonClick(param1:MouseEvent) : void
      {
         if((this._label["_btn"] as MovieClip).currentFrame == 1)
         {
            this.toGuess();
         }
         else if((this._label["_btn"] as MovieClip).currentFrame == 2)
         {
            this.onGetReward();
         }
      }
      
      private function onGetReward() : void
      {
         this._fport.requestSever(GuessResultFPort.GUESS_GET,this._data.getID());
      }
      
      private function toGuess() : void
      {
         var back:Function = null;
         back = function(param1:int, param2:int):void
         {
            _label["_btn"].visible = false;
            _label["_guessing_result"].gotoAndStop(3);
            _data.setMyGuess(param1);
            _data.setType(param2);
            setPrizeTimes(param2);
            ++GuessResultWindow._guesstime;
            GuessResultWindow.updateGuessTimes(GuessResultWindow._guesstime + "/" + GuessResultWindow._maxGuessTime,false);
            if(param1 == _data.getUser1().getNewId())
            {
               _label["_guessMc1"].visible = true;
            }
            else if(param1 == _data.getUser2().getNewId())
            {
               _label["_guessMc2"].visible = true;
            }
         };
         if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 18)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle012"));
            return;
         }
         new GuessPanel(this._data.getID(),back);
      }
      
      public function update(param1:Object) : void
      {
         this._data = param1 as Guess;
         this.hideAllmc();
         this.updateInfo();
      }
      
      private function hideAllmc() : void
      {
         this._label["_btn"].visible = false;
         this._label["_guessMc1"].visible = false;
         this._label["_winMc1"].visible = false;
         this._label["_guessMc2"].visible = false;
         this._label["_winMc2"].visible = false;
         this._label["_box_pos"]["_baoji"].visible = false;
      }
      
      private function updateInfo() : void
      {
         this.setProcess(this._data.getStage());
         this.setPrizeTimes(this._data.getType());
         this.setReslut();
         this.setBgStats();
         this.setButtonsSutaus();
         this.setPlayer1Info(this._data.getUser1());
         this.setPlayer2Info(this._data.getUser2());
         this.setBoxInfo();
         this.setGuessBei();
      }
      
      private function setGuessBei() : void
      {
         this._label["_box_pos"]["_baoji"].visible = this._data.getLucky() > 0 ? true : false;
      }
      
      private function setBgStats() : void
      {
         if(this._data.getMyGuessId() != 0 && this._data.getWinner() != 0)
         {
            if(this._data.getMyGuessId() == this._data.getWinner())
            {
               this._label["_bgmc"].gotoAndStop(2);
            }
         }
         else
         {
            this._label["_bgmc"].gotoAndStop(1);
         }
      }
      
      private function setBoxInfo() : void
      {
         FuncKit.clearAllChildrens(this._label["_box_pos"]["_box_node"]);
         if(this._tool != null)
         {
            this._tool = null;
         }
         this._tool = new Tool(this._data.getRewardId());
         var _loc1_:Class = DomainAccess.getClass(BOX_URL + this._tool.getPicId());
         var _loc2_:DisplayObject = new _loc1_() as DisplayObject;
         this._label["_box_pos"]["_box_node"].addChild(_loc2_);
         (this._label["_box_pos"] as MovieClip).mouseChildren = true;
         (this._label["_box_pos"] as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         (this._label["_box_pos"] as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         this._tips.visible = false;
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         this._tips.update(this._tool);
         this._tips.visible = true;
         this._tips.x = this._label["_box_pos"].x - 12;
         this._tips.y = this._label["_box_pos"].y - this._label["_box_pos"].height - 50;
      }
      
      private function setProcess(param1:uint) : void
      {
         this._label["_game_process"].gotoAndStop(param1);
      }
      
      private function setPrizeTimes(param1:uint) : void
      {
         this._label["_prize_times"].gotoAndStop(param1);
      }
      
      private function setReslut() : void
      {
         if(this._data.getMyGuessId() == 0 && this._data.getWinner() == 0)
         {
            this._label["_guessing_result"].gotoAndStop(4);
         }
         else if(this._data.getMyGuessId() == 0 && this._data.getWinner() != 0)
         {
            this._label["_guessing_result"].gotoAndStop(5);
         }
         else if(this._data.getWinner() == 0)
         {
            this._label["_guessing_result"].gotoAndStop(3);
         }
         else if(this._data.getMyGuessId() == this._data.getWinner())
         {
            this._label["_guessing_result"].gotoAndStop(1);
         }
         else if(this._data.getMyGuessId() != this._data.getWinner() && this._data.getMyGuessId() != 0)
         {
            this._label["_guessing_result"].gotoAndStop(2);
         }
      }
      
      private function setIsBaoji() : void
      {
         if(this._data.getLucky() == 1)
         {
            this._label["_box_pos"]["_baoji"].visible = true;
         }
      }
      
      private function setButtonsSutaus() : void
      {
         if(this._data.getMyGuessId() == 0 && this._data.getWinner() == 0 && GuessResultWindow._isCanbeGuess == true)
         {
            this._label["_btn"].visible = true;
            this._label["_btn"].gotoAndStop(1);
         }
         else if(this._data.getMyGuessId() != 0)
         {
            if(this._data.getMyGuessId() == this._data.getWinner())
            {
               if(this._data.getIsGotten() == 1)
               {
                  this._label["_btn"].visible = true;
                  this._label["_btn"].gotoAndStop(3);
               }
               else
               {
                  this._label["_btn"].visible = true;
                  this._label["_btn"].gotoAndStop(2);
               }
            }
            else if(this._data.getMyGuessId() != this._data.getWinner())
            {
               this._label["_btn"].visible = false;
            }
         }
      }
      
      private function setPlayer1Info(param1:User) : void
      {
         if(param1.getNickName())
         {
            this._label["user1_name_txt"].text = param1.getNickName();
         }
         if(param1.getSeverName())
         {
            this._label["sever1_name_txt"].text = param1.getSeverName();
         }
         PlantsVsZombies.setHeadPic(this._label["pic1"],PlantsVsZombies.getHeadPicUrl(param1.getFaceURL()),PlantsVsZombies.HEADPIC_BIG,param1.getVipEtime(),param1.getVIPGrade());
         if(this._data.getMyGuessId() == param1.getNewId())
         {
            this._label["_guessMc1"].visible = true;
         }
         if(this._data.getWinner() == param1.getNewId())
         {
            this._label["_winMc1"].visible = true;
         }
      }
      
      private function setPlayer2Info(param1:User) : void
      {
         if(param1.getNickName())
         {
            this._label["user2_name_txt"].text = param1.getNickName();
         }
         if(param1.getSeverName())
         {
            this._label["sever2_name_txt"].text = param1.getSeverName();
         }
         PlantsVsZombies.setHeadPic(this._label["pic2"],PlantsVsZombies.getHeadPicUrl(param1.getFaceURL()),PlantsVsZombies.HEADPIC_BIG,param1.getVipEtime(),param1.getVIPGrade());
         if(this._data.getMyGuessId() == param1.getNewId())
         {
            this._label["_guessMc2"].visible = true;
         }
         if(this._data.getWinner() == param1.getNewId())
         {
            this._label["_winMc2"].visible = true;
         }
      }
      
      public function showToolsPrizes(param1:Object) : void
      {
         var back:Function = null;
         var re:Object = param1;
         back = function():void
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("severBattle013"));
            _label["_btn"].gotoAndStop(3);
            _data.setIsGotten(1);
         };
         var toolsWindow:PrizeWindow = new PrizeWindow(PlantsVsZombies._node as MovieClip);
         toolsWindow.show(this.getToolsByPrezes(re),back);
      }
      
      private function getToolsByPrezes(param1:Object) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Tool = new Tool(param1.tool_id);
         _loc3_.setNum(param1.amount);
         _loc2_.push(_loc3_);
         return _loc2_;
      }
      
      public function destory() : void
      {
         this._label["_btn"].removeEventListener(MouseEvent.MOUSE_UP,this.buttonClick);
         (this._label["_box_pos"] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         (this._label["_box_pos"] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
   }
}


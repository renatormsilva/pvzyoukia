package pvz.copy
{
   import constants.UINameConst;
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import pvz.copy.mediators.StoneMediator;
   import pvz.copy.ui.windows.ActivtyCopyEnteranceWindow;
   import pvz.world.WorldFore;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class CopyWindow extends BaseWindow
   {
      
      private var m_select_window:Sprite;
      
      private var closeBtn:SimpleButton;
      
      public function CopyWindow()
      {
         super(UINameConst.UI_COPY_WINDOW);
      }
      
      override protected function initWindowUI() : void
      {
         this.showType = PANEL_TYPE_2;
         this.m_select_window = GetDomainRes.getSprite("copy.ui.selectwindow");
         this.closeBtn = GetDomainRes.getSimpleButton("pvz.close");
         this.closeBtn.name = "close";
         this.closeBtn.x = this.m_select_window.width - this.closeBtn.width - 20;
         this.closeBtn.y = 20;
         this.setAllLabelType();
         this.m_select_window["copy1"].buttonMode = true;
         this.m_select_window["copy2"].buttonMode = true;
         this.m_select_window["copy3"].buttonMode = true;
         this.m_select_window["copy4"].buttonMode = true;
         this.addChild(this.m_select_window);
         this.addChild(this.closeBtn);
         this.addEvents();
         this.setLoction();
         this.onShow();
      }
      
      private function setAllLabelType() : void
      {
         FuncKit.setNoColor(this.m_select_window["copy1"]);
         this.m_select_window["layer1"].gotoAndStop(3);
         this.m_select_window["copy1"].mouseEnabled = false;
         this.m_select_window["layer2"].visible = false;
         if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 20)
         {
            if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 9)
            {
               this.m_select_window["layer2"].visible = true;
               FuncKit.setNoColor(this.m_select_window["copy2"]);
               this.m_select_window["layer2"].gotoAndStop(4);
            }
            else
            {
               this.m_select_window["layer2"].visible = true;
               this.addBattleNum(this.m_select_window["layer2"],PlantsVsZombies.playerManager.getPlayer().getWorldTimes());
            }
            FuncKit.setNoColor(this.m_select_window["copy3"]);
            this.m_select_window["layer3"].gotoAndStop(4);
            FuncKit.setNoColor(this.m_select_window["copy4"]);
            this.m_select_window["layer4"].gotoAndStop(4);
            this.m_select_window["copy4"].mouseEnabled = false;
         }
         else
         {
            if(PlantsVsZombies.playerManager.getPlayer().getCopyActiveState() == 1)
            {
               FuncKit.setNoColor(this.m_select_window["copy4"]);
               this.m_select_window["layer4"].gotoAndStop(3);
               this.m_select_window["copy4"].mouseEnabled = false;
            }
            else if(PlantsVsZombies.playerManager.getPlayer().getCopyActiveState() == 2)
            {
               this.m_select_window["layer4"].gotoAndStop(6);
            }
            else if(PlantsVsZombies.playerManager.getPlayer().getCopyActiveState() == 3)
            {
               this.m_select_window["layer4"].gotoAndStop(5);
            }
            this.m_select_window["layer2"].visible = true;
            this.addBattleNum(this.m_select_window["layer2"],PlantsVsZombies.playerManager.getPlayer().getWorldTimes());
            this.addBattleNum(this.m_select_window["layer3"],PlantsVsZombies.playerManager.getPlayer().getStoneChaCount());
         }
      }
      
      private function addBattleNum(param1:MovieClip, param2:int) : void
      {
         var _loc3_:DisplayObject = FuncKit.getNumEffect(String(param2),"Exp",-2);
         _loc3_.x = -_loc3_.width / 2;
         param1.gotoAndStop(1);
         FuncKit.clearAllChildrens(param1["num"]);
         param1["num"].addChild(_loc3_);
      }
      
      private function addEvents() : void
      {
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy1"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy2"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy3"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy4"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function removeEvents() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy1"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy2"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy3"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.m_select_window["copy4"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function clearAll() : void
      {
         FuncKit.clearAllChildrens(this);
         this.closeBtn = null;
         this.m_select_window = null;
         this.onHide();
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.removeEvents();
         this.clearAll();
         switch(param1.currentTarget.name)
         {
            case "copy1":
               break;
            case "copy2":
               if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 9)
               {
                  return;
               }
               if(PlantsVsZombies._node["draw"].numChildren > 0)
               {
                  PlantsVsZombies._node["draw"].removeChildAt(0);
               }
               PlantsVsZombies._node.stage.frameRate = 12;
               PlantsVsZombies.setWindowsButtonsVisible();
               PlantsVsZombies.setPlayerInfoVisible();
               new WorldFore(PlantsVsZombies._node["draw"]);
               break;
            case "copy3":
               if(PlantsVsZombies.playerManager.getPlayer().getGrade() < 20)
               {
                  _loc2_ = LangManager.getInstance().getLanguage("copy012");
                  PlantsVsZombies.showSystemErrorInfo(_loc2_);
                  return;
               }
               new StoneMediator();
               break;
            case "copy4":
               new ActivtyCopyEnteranceWindow();
         }
      }
      
      private function setLoction() : void
      {
         this.x = (PlantsVsZombies.WIDTH - this.width) / 2;
         this.y = (PlantsVsZombies.HEIGHT - this.height) / 2;
      }
   }
}


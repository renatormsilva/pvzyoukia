package pvz.rank
{
   import core.ui.panel.BaseWindow;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.SoundManager;
   import utils.FuncKit;
   import zlib.utils.DomainAccess;
   
   public class RankingWindow extends BaseWindow
   {
      
      private static var FRIENDS:int = 2;
      
      private static var ORG:int = 1;
      
      private var nowType:int = 0;
      
      internal var _rankWindow:MovieClip;
      
      public function RankingWindow()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("rankingWindow");
         this._rankWindow = new _loc1_();
         this._rankWindow.visible = false;
         this.addBtEvent();
      }
      
      public function show() : void
      {
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies._node.addChild(this._rankWindow);
         this._rankWindow.visible = true;
         onShowEffectBig(this._rankWindow);
         this.changePanel();
      }
      
      private function addBtEvent() : void
      {
         this._rankWindow["_close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._rankWindow["_friendsBt"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._rankWindow["_orgBt"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function changePanel(param1:int = 1) : void
      {
         if(this.nowType == param1)
         {
            return;
         }
         this.clearPanel();
         this.nowType = param1;
         this.setBtVisible(param1);
         switch(param1)
         {
            case ORG:
               this._rankWindow["_panel"].addChild(new OrgRankingPanel(6,72));
               return;
            case FRIENDS:
               this._rankWindow["_panel"].addChild(new FriendsRankingPanel(0,0));
               return;
            default:
               return;
         }
      }
      
      private function setBtVisible(param1:int) : void
      {
         this._rankWindow["_orgBtSelected"].visible = false;
         this._rankWindow["_friendsBtSelected"].visible = false;
         switch(param1)
         {
            case ORG:
               this._rankWindow["_orgBtSelected"].visible = true;
               return;
            case FRIENDS:
               this._rankWindow["_friendsBtSelected"].visible = true;
               return;
            default:
               return;
         }
      }
      
      private function clearPanel() : void
      {
         if(this._rankWindow["_panel"].numChildren == 0)
         {
            return;
         }
         if(this._rankWindow["_panel"].getChildAt(0) is FriendsRankingPanel)
         {
            (this._rankWindow["_panel"].getChildAt(0) as FriendsRankingPanel).destroy();
         }
         else if(this._rankWindow["_panel"].getChildAt(0) is OrgRankingPanel)
         {
            (this._rankWindow["_panel"].getChildAt(0) as OrgRankingPanel).destroy();
         }
         FuncKit.clearAllChildrens(this._rankWindow["_panel"]);
      }
      
      private function hidden() : void
      {
         this.clearPanel();
         this.nowType = 0;
         onHiddenEffectBig(this._rankWindow);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(param1.currentTarget.name == "_close")
         {
            this.hidden();
         }
         else if(param1.currentTarget.name == "_friendsBt")
         {
            this.changePanel(FRIENDS);
         }
         else if(param1.currentTarget.name == "_orgBt")
         {
            this.changePanel(ORG);
         }
      }
      
      private function removeBtEvent() : void
      {
         this._rankWindow["_close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._rankWindow["_friendsBt"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._rankWindow["_orgBt"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}


package pvz.copy.ui.scene
{
   import core.ui.panel.BaseScene;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import manager.LangManager;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class ActvityCopySence extends BaseScene
   {
      
      private var _window:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _challagePanel:MovieClip;
      
      private var _chpaterNode:Sprite;
      
      private var _checkPointNode:Sprite;
      
      private var _backBtn:SimpleButton;
      
      public function ActvityCopySence()
      {
         super();
         this.initWindowUI();
      }
      
      private function initWindowUI() : void
      {
         this._window = GetDomainRes.getMoveClip("pvz.actityCopyWindow");
         addChild(this._window);
         var _loc1_:DisplayObject = GetDomainRes.getDisplayObject("pvz.copybg.bg1");
         this._window.bgnode.addChild(_loc1_);
         this._closeBtn = GetDomainRes.getSimpleButton("pvz.button.back");
         this._window["close"].addChild(this._closeBtn);
         this._challagePanel = GetDomainRes.getMoveClip("pvz.addTimes.Panel3");
         this._window["challagePanelNode"].addChild(this._challagePanel);
         this._backBtn = GetDomainRes.getSimpleButton("pvz.button.back3");
         this._window["back"].addChild(this._backBtn);
         this._chpaterNode = new Sprite();
         this._window.addChild(this._chpaterNode);
         this._checkPointNode = new Sprite();
         this._window.addChild(this._checkPointNode);
         this._window.activty_time.mouseEnabled = false;
         this._window.help.buttonMode = true;
         TextFilter.MiaoBian(this._window.activty_time,17895697);
      }
      
      public function get chpaterNode() : Sprite
      {
         return this._chpaterNode;
      }
      
      public function get closeBtn() : SimpleButton
      {
         return this._closeBtn;
      }
      
      public function updateChallageTimes(param1:int) : void
      {
         FuncKit.clearAllChildrens(this._challagePanel["times"]);
         this._challagePanel["times"].addChild(FuncKit.getNumEffect(param1 + "","AttackNum"));
      }
      
      public function updateActivtyTime(param1:Number, param2:Number) : void
      {
         this._window.activty_time.text = LangManager.getInstance().getLanguage("activtyCopy015") + FuncKit.getFullYearAndTime(param1) + "-" + FuncKit.getFullYearAndTime(param2);
      }
      
      public function get checkPointNode() : Sprite
      {
         return this._checkPointNode;
      }
      
      public function get backBtn() : SimpleButton
      {
         return this._backBtn;
      }
      
      public function get addTimesButton() : SimpleButton
      {
         return this._challagePanel.addTimebtn;
      }
      
      public function get buyTimesButton() : SimpleButton
      {
         return this._challagePanel.buy;
      }
      
      public function getChallagePanel() : MovieClip
      {
         return this._challagePanel;
      }
      
      public function get helpButton() : MovieClip
      {
         return this._window.help;
      }
   }
}


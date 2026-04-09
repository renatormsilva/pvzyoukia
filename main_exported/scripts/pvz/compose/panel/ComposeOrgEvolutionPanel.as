package pvz.compose.panel
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.GlobalConstants;
   import constants.URLConnectionConstants;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.ComposePicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.compose.EvolutionPrizeWindow;
   import pvz.help.HelpNovice;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.Singleton;
   import utils.TextFilter;
   import windows.ShortcutComposeWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlToolsConfig;
   import xmlReader.firstPage.XmlEvolution;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ComposeOrgEvolutionPanel extends Sprite implements IDestroy, IURLConnection
   {
      
      private static const ORG_EVOLUTION:int = 2;
      
      private static var SHORTCUT_PRIZE:int = 1;
      
      private static const SCHEDULE_COMMENT:int = 2;
      
      private static const SCHEDULE_SHORTCUT:int = 1;
      
      private var changeMaterial:Function = null;
      
      private var clearMask:Function = null;
      
      private var evo_money:int = 0;
      
      private var evo_org:Organism = null;
      
      private var evolPrizeWindow:EvolutionPrizeWindow = null;
      
      private var panel:MovieClip = null;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var needPrize:int;
      
      private var btnId:int;
      
      private var _shortcutTip:MovieClip;
      
      private var btnArr:Array = [];
      
      private var _prizeO:Object;
      
      public function ComposeOrgEvolutionPanel(param1:Function, param2:Function, param3:Function, param4:int = 0, param5:int = 0)
      {
         super();
         var _loc6_:Class = DomainAccess.getClass("evolutionPanel");
         this.panel = new _loc6_();
         this.panel.visible = false;
         this.panel.gotoAndStop(1);
         this.addBtEvent();
         this.clearMask = param1;
         this.changeMaterial = param2;
         param3(false);
         this.addChild(this.panel);
         this.setLoction(param4,param5);
         this.show();
      }
      
      public function add(param1:Object, param2:Object = null) : Boolean
      {
         if(GlobalConstants.NEW_PLAYER)
         {
            PlantsVsZombies.helpN.show(HelpNovice.COMP_GET_EVOLUTION,PlantsVsZombies._node as DisplayObjectContainer);
         }
         if(this.clearMask != null)
         {
            this.clearMask();
         }
         if(!param1 is Organism)
         {
            return false;
         }
         this.clear();
         this._prizeO = param2;
         var _loc3_:ComposePicLabel = new ComposePicLabel(param1,null,true,ComposeWindowNew.TYPE_ORG_EVOLUTION);
         this.panel["base_org"].addChild(_loc3_);
         this.panel["btEvolution1"].visible = false;
         this.panel["btEvolution2"].visible = false;
         var _loc4_:int = 1;
         while(_loc4_ < param1.getEvolution().length + 1)
         {
            this.setEvolution(param1,param1.getEvolution()[_loc4_ - 1],_loc4_);
            _loc4_++;
         }
         return true;
      }
      
      public function clear(param1:Object = null) : void
      {
         this._prizeO = null;
         this.removeEvoluEvents();
         this.clearEvolutionError();
         FuncKit.clearAllChildrens(this.panel["base_org"]);
         FuncKit.clearAllChildrens(this.panel["tool1"]);
         FuncKit.clearAllChildrens(this.panel["tool2"]);
         FuncKit.clearAllChildrens(this.panel["evolution_org1"]);
         FuncKit.clearAllChildrens(this.panel["evolution_org2"]);
         this.panel["btEvolution1"].visible = true;
         this.panel["btEvolution2"].visible = true;
         this.panel["evolutionMoeny1"].text = "";
         this.panel["evolutionMoeny1"].visible = false;
         this.panel["evolutionMoeny2"].text = "";
         this.panel["evolutionMoeny2"].visible = false;
      }
      
      public function destroy() : void
      {
         if(this._shortcutTip != null)
         {
            if(PlantsVsZombies._node.contains(this._shortcutTip))
            {
               PlantsVsZombies._node.removeChild(this._shortcutTip);
            }
         }
         this.clear();
         this.removeBtEvent();
         FuncKit.clearAllChildrens(this.panel);
         this.removeChild(this.panel);
         this.btnArr = null;
         this.panel = null;
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc4_:Organism = null;
         var _loc3_:XmlEvolution = new XmlEvolution(param2 as String);
         if(!_loc3_.isSuccess())
         {
            PlantsVsZombies.showDataLoading(false);
            if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            if(_loc3_.error() == LangManager.getInstance().getLanguage("window173"))
            {
               PlantsVsZombies.showRechargeWindow(_loc3_.error());
            }
            else
            {
               PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
            }
         }
         else
         {
            PlantsVsZombies.playSounds(SoundManager.GRADE);
            PlantsVsZombies.playFireworks(6);
            this.playerManager.getPlayer().setMoney(_loc3_.getUseCoin);
            this.playerManager.getPlayer().setRMB(_loc3_.getUseGold);
            PlantsVsZombies.setUserInfos();
            _loc4_ = _loc3_.getOrg();
            this.showOrgChange(ORG_EVOLUTION,this.evo_org,_loc4_);
            PlantsVsZombies.storageInfo(this.reset);
         }
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      private function addBtEvent() : void
      {
         this.panel["btEvolution1"].addEventListener(MouseEvent.CLICK,this.onEvolutionClick);
         this.panel["btEvolution2"].addEventListener(MouseEvent.CLICK,this.onEvolutionClick);
      }
      
      private function clearEvolutionError() : void
      {
         this.panel["fail1"].visible = false;
         this.panel["fail2"].visible = false;
      }
      
      private function evolution(param1:Organism, param2:int, param3:int, param4:int) : void
      {
         PlantsVsZombies.showDataLoading(true);
         this.evo_money = param3;
         this.evo_org = param1;
         if(GlobalConstants.NEW_PLAYER)
         {
            this.evolutionHelp(param1,param3);
         }
         else
         {
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_EVOLUTION + param1.getId() + URLConnectionConstants.URL_EVOLUTION_SEC + param2 + URLConnectionConstants.URL_EVOLUTION_SHORTCUT + param4),ORG_EVOLUTION);
         }
      }
      
      private function evolutionHelp(param1:Organism, param2:int) : void
      {
         PlantsVsZombies.playSounds(SoundManager.GRADE);
         PlantsVsZombies.playFireworks(6);
         param2 = this.evo_money;
         this.playerManager.getPlayer().setMoney(this.playerManager.getPlayer().getMoney() - param2);
         PlantsVsZombies.setUserInfos();
         var _loc3_:Organism = PlantsVsZombies.helpN.getOrgAfterEvo();
         this.showOrgChange(ORG_EVOLUTION,this.evo_org,_loc3_);
         PlantsVsZombies.helpN.show(HelpNovice.COMP_CLOSE_EVOLUTION,PlantsVsZombies._node as DisplayObjectContainer);
         PlantsVsZombies.storageInfo(this.reset);
         PlantsVsZombies.showDataLoading(false);
      }
      
      private function getToolsNum(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerManager.getPlayer().getAllTools().length)
         {
            if((this.playerManager.getPlayer().getAllTools()[_loc2_] as Tool).getOrderId() == param1)
            {
               return (this.playerManager.getPlayer().getAllTools()[_loc2_] as Tool).getNum();
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function onEvolutionClick(param1:MouseEvent) : void
      {
         var _loc6_:int = 0;
         if(this.panel["base_org"].numChildren == 0)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window020"));
            return;
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         var _loc2_:int = int(param1.target.name.substring(11));
         var _loc3_:ComposePicLabel = this.panel["base_org"].getChildAt(0) as ComposePicLabel;
         var _loc4_:Organism = _loc3_.getO() as Organism;
         if((_loc4_ as Organism).getHp().toNumber() < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window021"));
            return;
         }
         var _loc5_:int = int(_loc4_.getAllSkills().length);
         if(_loc2_ == 1)
         {
            _loc6_ = int(_loc4_.getEvolution()[0].id);
         }
         else
         {
            _loc6_ = int(_loc4_.getEvolution()[1].id);
         }
         if(param1.currentTarget.name == "btEvolution" + _loc2_)
         {
            this.evolution(_loc4_,_loc6_,_loc4_.getEvolution()[_loc2_ - 1].money,2);
         }
         else if(param1.currentTarget.name == "btEvolutiom" + _loc2_)
         {
            this.evolution(_loc4_,_loc6_,this.needPrize,1);
         }
      }
      
      private function removeBtEvent() : void
      {
         this.panel["btEvolution1"].removeEventListener(MouseEvent.CLICK,this.onEvolutionClick);
         this.panel["btEvolution2"].removeEventListener(MouseEvent.CLICK,this.onEvolutionClick);
      }
      
      private function reset() : void
      {
         this.clear();
         ShortcutComposeWindow.getShortcutComposeInstance.connection();
         this.changeMaterial(ComposeWindowNew.MATERIAL_ORG);
      }
      
      private function setEvolution(param1:Object, param2:Object, param3:int) : void
      {
         var _loc4_:int = int(param2.toolid);
         var _loc5_:int = int(param2.evoId);
         var _loc6_:int = int(param2.grade);
         var _loc7_:Organism = new Organism();
         _loc7_.setOrderId(_loc5_);
         var _loc8_:ComposePicLabel = new ComposePicLabel(_loc7_,null,true,ComposeWindowNew.TYPE_ORG_EVOLUTION);
         var _loc9_:ComposePicLabel = new ComposePicLabel(new Tool(_loc4_),null,true,ComposeWindowNew.TYPE_ORG_EVOLUTION);
         var _loc10_:int = this.getToolsNum(_loc4_);
         var _loc11_:int = int(param2.money);
         this.panel["fail" + param3].visible = false;
         if((param1 as Organism).getGrade() < _loc6_)
         {
            this.setshortcutBtn(param3,false);
            FuncKit.setNoColor(_loc9_);
            FuncKit.setNoColor(_loc8_);
            this.panel["fail" + param3].visible = true;
            this.panel["fail" + param3].gotoAndStop(1);
            this.panel["evolutionMoeny" + param3].visible = true;
            this.panel["evolutionMoeny" + param3].text = LangManager.getInstance().getLanguage("window022") + _loc6_;
         }
         else if(_loc10_ < 1)
         {
            this.setshortcutBtn(param3,true);
            FuncKit.setNoColor(_loc9_);
            FuncKit.setNoColor(_loc8_);
            this.panel["fail" + param3].visible = true;
            this.panel["fail" + param3].gotoAndStop(2);
            this.panel["evolutionMoeny" + param3].visible = true;
            this.panel["evolutionMoeny" + param3].text = LangManager.getInstance().getLanguage("window023") + XmlToolsConfig.getInstance().getToolAttribute(_loc4_).getName();
         }
         else if(_loc11_ > this.playerManager.getPlayer().getMoney())
         {
            this.setshortcutBtn(param3,true);
            this.panel["fail" + param3].visible = true;
            this.panel["fail" + param3].gotoAndStop(3);
            this.panel["evolutionMoeny" + param3].visible = true;
            this.panel["evolutionMoeny" + param3].text = "缺少" + LangManager.getInstance().getLanguage("window024") + FuncKit.transformNum(_loc11_ - this.playerManager.getPlayer().getMoney(),1);
         }
         else
         {
            this.panel["btEvolution" + param3].visible = true;
            this.panel["evolutionMoeny" + param3].visible = true;
            this.panel["evolutionMoeny" + param3].text = LangManager.getInstance().getLanguage("window024") + FuncKit.transformNum(_loc11_);
         }
         this.panel["tool" + param3].addChild(_loc9_);
         this.panel["evolution_org" + param3].addChild(_loc8_);
      }
      
      private function setshortcutBtn(param1:int, param2:Boolean) : void
      {
         if(!param2)
         {
            return;
         }
         var _loc3_:SimpleButton = GetDomainRes.getSimpleButton("shortEvoluBtn");
         _loc3_.name = "btEvolutiom" + param1;
         this.panel.addChild(_loc3_);
         _loc3_.x = this.panel["fail" + param1].x;
         _loc3_.y = this.panel["fail" + param1].y + 66;
         this.btnArr[param1] = _loc3_;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onEvolutionClick);
         _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.onShortEvoluOver);
         _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.onShortEvoluOut);
      }
      
      private function onShortEvoluOut(param1:MouseEvent) : void
      {
         if(this._shortcutTip == null)
         {
            return;
         }
         if(this._shortcutTip.visible)
         {
            this._shortcutTip.visible = false;
         }
      }
      
      private function onShortEvoluOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         this.btnId = param1.currentTarget.name.substring(11);
         if(this._prizeO == null)
         {
            return;
         }
         if(this._shortcutTip == null)
         {
            this._shortcutTip = GetDomainRes.getMoveClip("shortcutTip");
            TextFilter.MiaoBian(this._shortcutTip["txt"],0);
         }
         else
         {
            this._shortcutTip.visible = true;
         }
         this._shortcutTip.x = this.panel["fail" + this.btnId].x + 140;
         this._shortcutTip.y = this.panel["fail" + this.btnId].y + 138;
         PlantsVsZombies._node.addChild(this._shortcutTip);
         this.needPrize = this._prizeO[this.btnId];
         if(this.needPrize == -1)
         {
            _loc2_ = LangManager.getInstance().getLanguage("window170");
            this._shortcutTip["txt"].htmlText = "<font size=\'13\'><b>" + _loc2_ + "</b></font>";
         }
         else
         {
            _loc2_ = "</b></font><font color=\'#00ff00\' size=\'13\'><b>" + this.needPrize + "</b></font><font color=\'#ffffff\' size=\'13\'><b>";
            this._shortcutTip["txt"].htmlText = "<font color=\'#ffffff\' size=\'13\'><b>" + LangManager.getInstance().getLanguage("window172",_loc2_) + "</b></font>";
         }
      }
      
      private function removeEvoluEvents() : void
      {
         var _loc1_:SimpleButton = null;
         if(this.btnArr == null)
         {
            return;
         }
         if(this.btnArr.length <= 0)
         {
            return;
         }
         for each(_loc1_ in this.btnArr)
         {
            if(_loc1_.hasEventListener(MouseEvent.CLICK))
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.onEvolutionClick);
            }
            if(_loc1_.hasEventListener(MouseEvent.ROLL_OVER))
            {
               _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.onShortEvoluOver);
            }
            if(_loc1_.hasEventListener(MouseEvent.ROLL_OUT))
            {
               _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.onShortEvoluOut);
            }
            _loc1_.parent.removeChild(_loc1_);
         }
         this.btnArr = [];
      }
      
      private function setLoction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      private function show() : void
      {
         this.clear();
         this.panel.visible = true;
      }
      
      private function showOrgChange(param1:int, param2:Organism, param3:Organism) : void
      {
         PlantsVsZombies.playFireworks(3);
         this.evolPrizeWindow = new EvolutionPrizeWindow();
         this.evolPrizeWindow.show(param1,param2,param3);
      }
   }
}


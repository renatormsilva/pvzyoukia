package pvz.compose.panel
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import entity.Goods;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import labels.ComposePicLabel;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.ToolType;
   import pvz.compose.ChangeToolsWindow;
   import pvz.shop.ShopWindow;
   import pvz.shop.rpc.Shop_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   
   public class ComposeToolsChangePanel extends Sprite implements IDestroy, IConnection
   {
      
      private static const INIT_CHANGETOOLS:int = 1;
      
      public static const TOOL_CHANGE_PANEL:String = "toolchangePanel";
      
      internal var changeMaterial:Function = null;
      
      internal var clearMask:Function = null;
      
      internal var panel:MovieClip = null;
      
      internal var labelvisible:Function = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function ComposeToolsChangePanel(param1:Function, param2:Function, param3:Function, param4:int = 0, param5:int = 0)
      {
         super();
         var _loc6_:Class = DomainAccess.getClass("toolsChangePanel");
         this.panel = new _loc6_();
         this.panel.visible = false;
         this.panel.gotoAndStop(1);
         this.addChild(this.panel);
         this.clearMask = param1;
         this.labelvisible = param3;
         this.changeMaterial = param2;
         this.addBtEvent();
         this.setLoction(param4,param5);
         this.show();
      }
      
      public function add(param1:Object) : Boolean
      {
         this.clear();
         if(this.clearMask != null)
         {
            this.clearMask();
         }
         if(param1 == null)
         {
            return false;
         }
         this.showChangeTools(param1,this.getChangeToolsRules((param1 as Tool).getOrderId()));
         return true;
      }
      
      public function clear(param1:Object = null) : void
      {
         FuncKit.clearAllChildrens(this.panel["tool1"]);
         FuncKit.clearAllChildrens(this.panel["tool2"]);
         FuncKit.clearAllChildrens(this.panel["changetool1"]);
         FuncKit.clearAllChildrens(this.panel["changetool2"]);
         FuncKit.clearAllChildrens(this.panel["num1"]);
         FuncKit.clearAllChildrens(this.panel["num2"]);
         FuncKit.clearAllChildrens(this.panel["changenum1"]);
         FuncKit.clearAllChildrens(this.panel["changenum2"]);
         this.panel["btToolChange1"].visible = true;
         this.panel["btToolChange2"].visible = true;
         this.panel["notChange1"].visible = false;
         this.panel["notChange2"].visible = false;
         this.panel["notEnough1"].visible = false;
         this.panel["notEnough2"].visible = false;
         this.panel["changetext1"].visible = false;
         this.panel["changetext2"].visible = false;
         this.panel["changetext1"].text = "";
         this.panel["changetext2"].text = "";
         if(param1 != null)
         {
            this.labelvisible(param1,false);
         }
      }
      
      public function destroy() : void
      {
         this.removeBtEvent();
         this.clear();
         FuncKit.clearAllChildrens(this.panel);
         this.removeChild(this.panel);
         this.panel = null;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == INIT_CHANGETOOLS)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callO(param2,param3,rest[0]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:Shop_rpc = new Shop_rpc();
         this.playerManager.getPlayer().setChangetools(_loc3_.getShopArray(param2));
         this.changeMaterial(ComposeWindowNew.MATERIAL_TOOL,TOOL_CHANGE_PANEL);
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      private function addBtEvent() : void
      {
         this.panel["btToolChange1"].addEventListener(MouseEvent.CLICK,this.onBtClick);
         this.panel["btToolChange2"].addEventListener(MouseEvent.CLICK,this.onBtClick);
      }
      
      private function checkChangToolNumEnough(param1:Object, param2:Goods) : Boolean
      {
         if(param2 == null || param1 == null)
         {
            return false;
         }
         var _loc3_:int = this.playerManager.getPlayer().getTool((param1 as Tool).getOrderId()).getNum();
         if(_loc3_ >= param2.getPurchasePrice())
         {
            return true;
         }
         return false;
      }
      
      private function checkToolChange() : Boolean
      {
         if(this.playerManager.getPlayer().getChangetools() == null || this.playerManager.getPlayer().getChangetools().length < 1)
         {
            return true;
         }
         return false;
      }
      
      private function getChangeToolsRules(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.playerManager.getPlayer().getChangetools().length)
         {
            if((this.playerManager.getPlayer().getChangetools()[_loc3_] as Goods).getChangeId() == param1)
            {
               _loc2_.push(this.playerManager.getPlayer().getChangetools()[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onBtClick(param1:MouseEvent) : void
      {
         var _loc7_:ChangeToolsWindow = null;
         var _loc2_:int = int(param1.target.name.substring(12));
         if(this.panel["changetool" + _loc2_].numChildren < 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window046"));
            return;
         }
         var _loc3_:ComposePicLabel = this.panel["changetool" + _loc2_].getChildAt(0) as ComposePicLabel;
         var _loc4_:Goods = _loc3_.getO() as Goods;
         var _loc5_:ComposePicLabel = this.panel["tool" + _loc2_].getChildAt(0) as ComposePicLabel;
         var _loc6_:Tool = _loc5_.getO() as Tool;
         if(ToolType.isBook(_loc6_))
         {
            _loc7_ = new ChangeToolsWindow(_loc6_,_loc4_,this.resets);
         }
         else
         {
            _loc7_ = new ChangeToolsWindow(_loc6_,_loc4_,this.reset);
         }
      }
      
      private function removeBtEvent() : void
      {
         this.panel["btToolChange1"].removeEventListener(MouseEvent.CLICK,this.onBtClick);
         this.panel["btToolChange2"].removeEventListener(MouseEvent.CLICK,this.onBtClick);
      }
      
      private function reset() : void
      {
         this.clear();
         this.clearMask();
         this.changeMaterial(ComposeWindowNew.MATERIAL_TOOL,TOOL_CHANGE_PANEL);
      }
      
      private function resets() : void
      {
         this.clear();
         this.clearMask();
         this.changeMaterial(ComposeWindowNew.MATERIAL_BOOK,TOOL_CHANGE_PANEL);
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
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_SHOP_GETMERCHANDISES,INIT_CHANGETOOLS,ShopWindow.SHOP_TOOLCHANGE);
      }
      
      private function showChangeTool(param1:Object, param2:Goods, param3:int) : void
      {
         this.panel["btToolChange" + param3].visible = false;
         this.panel["tool" + param3].addChild(new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_TOOLS_CHANGE));
         this.panel["changetool" + param3].addChild(new ComposePicLabel(param2,this.clear,true,ComposeWindowNew.TYPE_TOOLS_CHANGE));
         this.panel["num" + param3].addChild(FuncKit.getNumEffect(param2.getPurchasePrice() + "","Small"));
         this.panel["changenum" + param3].addChild(FuncKit.getNumEffect("1","Small"));
         if(!this.checkChangToolNumEnough(param1,param2))
         {
            this.panel["notEnough" + param3].visible = true;
            this.panel["changetext" + param3].visible = true;
            this.panel["changetext" + param3].text = LangManager.getInstance().getLanguage("window023") + (param1 as Tool).getName();
         }
         else
         {
            this.panel["btToolChange" + param3].visible = true;
         }
      }
      
      private function showChangeTools(param1:Object, param2:Array) : void
      {
         if(param2 == null || param2.length < 1)
         {
            this.panel["btToolChange1"].visible = false;
            this.panel["btToolChange2"].visible = false;
            this.panel["notChange1"].visible = true;
            this.panel["notChange2"].visible = true;
            this.panel["notEnough1"].visible = false;
            this.panel["notEnough2"].visible = false;
            this.panel["tool1"].addChild(new ComposePicLabel(param1,this.clear,true,ComposeWindowNew.TYPE_TOOLS_CHANGE));
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            this.showChangeTool(param1,param2[_loc3_],_loc3_ + 1);
            _loc3_++;
         }
         if(param2.length < 2)
         {
            this.panel["btToolChange2"].visible = false;
            this.panel["notChange2"].visible = true;
            this.panel["notEnough2"].visible = false;
         }
      }
   }
}


package pvz.storage
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import constants.AMFConnectionConstants;
   import constants.GlobalConstants;
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import manager.ToolManager;
   import manager.ToolType;
   import node.Icon;
   import pvz.genius.GeniusControl;
   import pvz.storage.rpc.GetPrizes_rpc;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import windows.PrizesWindow;
   import zlib.utils.DomainAccess;
   
   public class SellGoodsWindow extends BaseWindow implements IConnection
   {
      
      public static const SELL_TOOL:int = 1;
      
      private static const SELL:int = 1;
      
      private static const USE_SCROLL:int = 2;
      
      private static const USE_BOX:int = 3;
      
      private const MAX_OPEN_BOX_NUM:int = 10;
      
      internal var _mc:MovieClip;
      
      internal var _nownum:int = 0;
      
      internal var _tool:Tool;
      
      internal var _updateF:Function;
      
      internal var isDoing:Boolean = false;
      
      internal var prizes:Array = null;
      
      internal var toolsPrizePage:int = 0;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var _baseArray:Array = null;
      
      private var _callback:Function;
      
      public function SellGoodsWindow(param1:Function, param2:Array)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("goodsWindow");
         this._mc = new _loc3_();
         this._mc.visible = false;
         this._mc["buy"].visible = false;
         this._mc["addnum"].visible = false;
         this._mc["decnum"].visible = false;
         this._updateF = param1;
         this._baseArray = param2;
         if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
         {
            FuncKit.setNoColor(this._mc["_updateGenius"]);
         }
         this.addEvent();
         PlantsVsZombies._node.addChild(this._mc);
         this.addPageEvent();
      }
      
      private function getToolsAwards(param1:Array) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_][0] == "tool" || param1[_loc3_][0] == "organism")
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function hidden() : void
      {
         if(this._mc.visible)
         {
            this._mc.visible = false;
         }
         removeBG();
         this.destory();
      }
      
      private function isUsePossessionBattle() : Boolean
      {
         if(this.playerManager.getPlayer().getOccupyMaxNum() - this.playerManager.getPlayer().getOccupyNum() < 1)
         {
            return false;
         }
         return true;
      }
      
      private function isUseScroll() : Boolean
      {
         if(this.playerManager.getPlayer().getHunts() - this.playerManager.getPlayer().getNowHunts() < 1)
         {
            return false;
         }
         return true;
      }
      
      private function isUseArenaScroll() : Boolean
      {
         if(this.playerManager.getPlayer().getArenaNum() < PlayerManager.ARENA_NUM)
         {
            return true;
         }
         return false;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         if(param3 == USE_SCROLL)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOO(param2,param3,this._tool.getOrderId(),this._nownum);
         }
         else if(param3 == SELL)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOOO(param2,param3,SELL_TOOL,this._tool.getOrderId(),this._nownum);
         }
         else if(param3 == USE_BOX)
         {
            PlantsVsZombies.showDataLoading(true);
            _loc5_.callOO(param2,param3,rest[0],rest[1]);
         }
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var callback:Function;
         var tool:Tool = null;
         var strr:String = null;
         var count:int = 0;
         var namest:String = null;
         var str:String = null;
         var getprizes:GetPrizes_rpc = null;
         var type:int = param1;
         var re:Object = param2;
         if(type == USE_SCROLL)
         {
            this.playerManager.getPlayer().useTools(this._tool.getOrderId(),this._nownum);
            PlantsVsZombies.showDataLoading(false);
            if(re.name == 1)
            {
               this.playerManager.getPlayer().setNowHunts(this.playerManager.getPlayer().getNowHunts() + re.effect);
               PlantsVsZombies.ChangeUserHuntNum();
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window112",this._nownum,this._tool.getName(),re.effect));
               this.updateStorageFalse();
            }
            else if(re.name == 2)
            {
               this.playerManager.getPlayer().setArenaNum(this.playerManager.getPlayer().getArenaNum() + re.effect);
               PlantsVsZombies.ChangeUserHuntNum();
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window113",this._nownum,this._tool.getName(),re.effect));
               this.updateStorageFalse();
            }
            else if(re.name == 4)
            {
               this.playerManager.getPlayer().setOccupyNum(this.playerManager.getPlayer().getOccupyNum() + re.effect);
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window133",this._nownum,this._tool.getName(),re.effect));
               this.updateStorageFalse();
            }
            else if(re.name == 3)
            {
               if(this.playerManager.getPlayer().getVipTime() != 0)
               {
                  strr = this._tool.getName().charAt(3);
                  if(this._tool.getOrderId() == ToolManager.TOOL_VIP_SEASON)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow135",this._nownum * 3,strr));
                  }
                  else if(this._tool.getOrderId() == ToolManager.TOOL_VIP_MONTH)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow130",this._nownum,strr));
                  }
                  else if(this._tool.getOrderId() == ToolManager.TOOL_VIP_WEEK)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("vip020",this._nownum));
                  }
                  else if(this._tool.getOrderId() == ToolManager.TOOL_VIP_DAY)
                  {
                     PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("vip019",this._nownum * 3));
                  }
               }
               else
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("SellGoodsWindow131"));
               }
               this.updateStorageFalse();
               this.playerManager.getPlayer().setVipTime(re.append.vip_etime);
               this.playerManager.getPlayer().setVipLevel(re.append.vip_grade);
               this.playerManager.getPlayer().setToadyMaxExp(re.append.today_exp_max);
               PlantsVsZombies.setHeadPic(PlantsVsZombies._node["player"]["pic"],PlantsVsZombies.getHeadPicUrl(this.playerManager.getPlayer().getFaceUrl2()),PlantsVsZombies.HEADPIC_BIG,this.playerManager.getPlayer().getVipTime(),this.playerManager.getPlayer().getVipLevel());
            }
            else if(re.name == 5)
            {
               this.playerManager.getPlayer().setWorldTimes(this.playerManager.getPlayer().getWorldTimes() + re.effect);
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window150",re.effect));
               this.updateStorageFalse();
            }
            else if(re.name == 6)
            {
               count = PlantsVsZombies.playerManager.getPlayer().getStoneChaCount() + re.effect;
               PlantsVsZombies.playerManager.getPlayer().setStoneChaCount(count);
               namest = LangManager.getInstance().getLanguage("copy016",re.effect,re.effect);
               PlantsVsZombies.showSystemErrorInfo(namest);
               this.updateStorageFalse();
            }
            tool = this.playerManager.getPlayer().getTool(this._tool.getOrderId());
            if(tool == null)
            {
               this.hidden();
               return;
            }
         }
         else if(type == SELL)
         {
            this.playerManager.getPlayer().useTools(this._tool.getOrderId(),this._nownum);
            PlantsVsZombies.playSounds(SoundManager.MONEY);
            str = LangManager.getInstance().getLanguage("window114",this._nownum,this._tool.getName(),Number(re));
            PlantsVsZombies.changeMoneyOrExp(Number(re),PlantsVsZombies.MONEY);
            PlantsVsZombies.showSystemErrorInfo(str);
            this.updateStorageFalse();
         }
         else if(type == USE_BOX)
         {
            callback = function():void
            {
               _nownum = 1;
               prizes = new Array();
               toolsPrizePage = 1;
               playerManager.getPlayer().useTools(_tool.getOrderId(),re.openAmount);
               prizes = getprizes.getAllAwards(re);
               showToolsPrizes();
               updateTools(getprizes.getTools(re));
               addOrgs(getprizes.getOrganisms(re));
            };
            PlantsVsZombies.showDataLoading(false);
            getprizes = new GetPrizes_rpc();
            PlantsVsZombies.playSounds(SoundManager.GRADE);
            if(re.error)
            {
               PlantsVsZombies.showSystemErrorInfo(re.error,callback);
            }
            else
            {
               callback();
            }
         }
      }
      
      private function showToolsPrizes() : void
      {
         var _loc1_:PrizesWindow = null;
         if(this.prizes != null && this.prizes.length > 0)
         {
            _loc1_ = new PrizesWindow(this.updateStorage,PlantsVsZombies._node as MovieClip);
            _loc1_.show(this.prizes);
            ++this.toolsPrizePage;
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         var _loc3_:ActionWindow = null;
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
         else if(param2.code == AMFConnectionConstants.RPC_ERROR_AMFPHP_BUILD)
         {
            _loc3_ = new ActionWindow();
            _loc3_.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window115"),AMFConnectionConstants.getErrorInfo(param2.description),null,false);
         }
      }
      
      public function show(param1:Function = null) : void
      {
         this._callback = param1;
         super.showBG(PlantsVsZombies._node as DisplayObjectContainer);
         this._mc.visible = true;
         onShowEffect(this._mc);
         this.setLoction();
         PlantsVsZombies._node.setChildIndex(this._mc,PlantsVsZombies._node.numChildren - 1);
      }
      
      public function update(param1:Tool) : void
      {
         this._tool = param1;
         Icon.setUrlIcon(this._mc["pic"],this._tool.getPicId(),Icon.TOOL_1);
         this._mc["_number"].text = "NO." + this._tool.getOrderId();
         this._mc["_name"].text = "" + this._tool.getName();
         this._mc["_type"].text = "" + this._tool.getTypeName();
         this._mc["_quality"].text = "" + this._tool.getQuality();
         this._mc["_price_title"].text = LangManager.getInstance().getLanguage("window116");
         this._mc["_use_condition_title"].text = LangManager.getInstance().getLanguage("window117");
         this._mc["_price"].text = "" + this._tool.getSell_price();
         this._mc["_use_condition"].text = "" + this._tool.getUse_condition();
         this._mc["_use_result"].text = "" + this._tool.getUse_result();
         this._mc["_expl"].text = "" + this._tool.getExpl();
         this._mc["_num"].text = this._tool.getNum();
         this._nownum = this._tool.getNum();
         this._mc["addnum"].visible = false;
         this._mc["decnum"].visible = false;
         this._mc["doing"].visible = false;
         this._mc["sell"].visible = false;
         this._mc["addnum"].visible = true;
         this._mc["decnum"].visible = true;
         this._mc["_updateGenius"].visible = false;
         if(ToolType.isDoingTool(this._tool))
         {
            this._mc["doing"].visible = true;
            this._nownum = 1;
            this._mc["_num"].text = this._nownum;
            this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
            if(this._tool.getType() != ToolType.TOOL_TYPE3 + "")
            {
               this._mc["_num"].text = this._nownum;
            }
            else
            {
               if(this._tool.getNum() >= 10)
               {
                  this._nownum = this.MAX_OPEN_BOX_NUM;
               }
               else
               {
                  this._nownum = param1.getNum();
               }
               this._mc["_num"].text = this._nownum;
               this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
            }
         }
         else if(ToolType.isJewel(this._tool))
         {
            this._mc["_updateGenius"].visible = true;
            this._mc["left_num_txt"].visible = false;
            this._mc["left_label"].visible = false;
         }
         else
         {
            this._mc["sell"].visible = true;
            this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
         }
      }
      
      private function addEvent() : void
      {
         this._mc["cancel"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["sell"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["doing"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["addnum"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["decnum"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_num"].addEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._mc["_num"].addEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         this._mc["_updateGenius"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function addPageEvent() : void
      {
         this._mc["_left"].addEventListener(MouseEvent.CLICK,this.onLeft);
         this._mc["_right"].addEventListener(MouseEvent.CLICK,this.onRight);
      }
      
      private function destory() : void
      {
         this.removeEvent();
         PlantsVsZombies._node.removeChild(this._mc);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var timeT:Timer = null;
         var time:Function = null;
         var actionWindow:ActionWindow = null;
         var e:MouseEvent = param1;
         time = function(param1:TimerEvent):void
         {
            isDoing = false;
            timeT.removeEventListener(TimerEvent.TIMER,time);
            timeT.stop();
         };
         if(this.isDoing)
         {
            return;
         }
         if(e.currentTarget.name == "_updateGenius")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            if(this.playerManager.getPlayer().getAllOrganism().length == 0)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("geniusp001"));
               return;
            }
            if(this.playerManager.getPlayer().getGrade() < PlantsVsZombies.GENIUS_OPEN_LEVEL)
            {
               PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("error001"));
               return;
            }
            new GeniusControl((PlantsVsZombies.playerManager.getPlayer().getAllOrganism()[0] as Organism).getId());
            this.hidden();
            if(this._callback != null)
            {
               this._callback();
            }
         }
         else if(e.currentTarget.name == "cancel")
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            this.hidden();
         }
         else if(e.currentTarget.name == "addnum")
         {
            if(this._nownum >= this._tool.getNum())
            {
               return;
            }
            ++this._nownum;
            if(this._tool.getType() == ToolType.TOOL_TYPE3 + "")
            {
               if(this._nownum > this.MAX_OPEN_BOX_NUM)
               {
                  this._nownum = this.MAX_OPEN_BOX_NUM;
               }
            }
            this._mc["_num"].text = this._nownum;
            this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
         }
         else if(e.currentTarget.name == "decnum")
         {
            if(this._nownum < 2)
            {
               return;
            }
            --this._nownum;
            this._mc["_num"].text = this._nownum;
            this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
         }
         else if(e.currentTarget.name == "sell")
         {
            this.isDoing = true;
            actionWindow = new ActionWindow();
            actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window118"),LangManager.getInstance().getLanguage("window119",this._tool.getSell_price() * this._nownum,this._nownum,this._tool.getName()),this.sell,true);
         }
         else if(e.currentTarget.name == "doing")
         {
            if(this._tool.getType() == ToolType.TOOL_TYPE4 + "")
            {
               if(this.isUseScroll())
               {
                  actionWindow = new ActionWindow();
                  actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               }
               else
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window121"));
               }
               return;
            }
            if(this._tool.getType() == ToolType.TOOL_TYPE7 + "")
            {
               if(this.isUseArenaScroll())
               {
                  actionWindow = new ActionWindow();
                  actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               }
               else
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window121"));
               }
               return;
            }
            if(this._tool.getType() == ToolType.TOOL_TYPE57 + "")
            {
               actionWindow = new ActionWindow();
               actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               return;
            }
            if(this._tool.getType() == ToolType.TOOL_TYPE8 + "")
            {
               if(this.isUsePossessionBattle())
               {
                  actionWindow = new ActionWindow();
                  actionWindow.init(1,Icon.SYSTEM,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               }
               else
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("window132"));
               }
               return;
            }
            if(ToolType.isVip(this._tool))
            {
               actionWindow = new ActionWindow();
               actionWindow.init(this._tool.getPicId(),Icon.TOOL,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               return;
            }
            if(this._tool.getType() == ToolManager.TOOL_WORLD_WORLD + "")
            {
               actionWindow = new ActionWindow();
               actionWindow.init(this._tool.getPicId(),Icon.TOOL,LangManager.getInstance().getLanguage("window120"),LangManager.getInstance().getLanguage("window122",this._nownum,this._tool.getName()),this.useScroll,true);
               return;
            }
            PlantsVsZombies.playSounds(SoundManager.BUTTON1);
            this.hidden();
            this.prizes = new Array();
            this.toolsPrizePage = 1;
            if(GlobalConstants.NEW_PLAYER)
            {
               this.prizes = PlantsVsZombies.helpN.getMyPriezs();
               this.showToolsPrizes();
               this.playerManager.getPlayer().useTools(this._tool.getOrderId(),this._nownum);
               return;
            }
            this.isDoing = true;
            PlantsVsZombies.showDataLoading(true);
            this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STORAGE_USEBOX,USE_BOX,this._tool.getOrderId(),this._nownum);
         }
         timeT = new Timer(1500);
         timeT.addEventListener(TimerEvent.TIMER,time);
         timeT.start();
      }
      
      private function updateTools(param1:Array) : void
      {
         var _loc3_:Tool = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = this.playerManager.getPlayer().getTool((param1[_loc2_] as Tool).getOrderId());
            if(_loc3_ == null)
            {
               _loc3_ = new Tool((param1[_loc2_] as Tool).getOrderId());
            }
            this.playerManager.getPlayer().updateTool((param1[_loc2_] as Tool).getOrderId(),_loc3_.getNum() + (param1[_loc2_] as Tool).getNum());
            _loc2_++;
         }
      }
      
      private function addOrgs(param1:Array) : void
      {
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.playerManager.addOrganism(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function onLeft(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:int = this.getToolIndex(this._tool);
         var _loc3_:Tool = this.getToolByIndex(_loc2_ - 1);
         if(_loc3_ != null)
         {
            this.update(_loc3_);
         }
      }
      
      private function onRight(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:int = this.getToolIndex(this._tool);
         var _loc3_:Tool = this.getToolByIndex(_loc2_ + 1);
         if(_loc3_ != null)
         {
            this.update(_loc3_);
         }
      }
      
      public function getToolByIndex(param1:int) : Tool
      {
         if(this._baseArray == null || this._baseArray.length < 1 || param1 > this._baseArray.length)
         {
            return null;
         }
         return this._baseArray[param1];
      }
      
      private function getToolIndex(param1:Tool) : int
      {
         if(this._baseArray == null || this._baseArray.length < 1)
         {
            return -1;
         }
         var _loc2_:int = int(this._baseArray.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this._baseArray[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function removeEvent() : void
      {
         this._mc["cancel"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["sell"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["doing"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["addnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["decnum"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["_num"].removeEventListener(KeyboardEvent.KEY_UP,this.setNum);
         this._mc["_num"].removeEventListener(KeyboardEvent.KEY_DOWN,this.setNum);
         this._mc["_updateGenius"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setNum(param1:KeyboardEvent) : void
      {
         if(this._mc["_num"].text == "")
         {
            this._nownum = 1;
         }
         else
         {
            this._nownum = int(this._mc["_num"].text);
         }
         if(this._nownum > this._tool.getNum())
         {
            this._nownum = this._tool.getNum();
         }
         else if(this._nownum <= 1)
         {
            this._nownum = 1;
         }
         if(this._tool.getType() == ToolType.TOOL_TYPE3 + "")
         {
            if(this._nownum > this.MAX_OPEN_BOX_NUM)
            {
               this._nownum = this.MAX_OPEN_BOX_NUM;
            }
         }
         this._mc["_num"].text = this._nownum;
         this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
      }
      
      private function sell() : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON1);
         PlantsVsZombies.showDataLoading(true);
         this.hidden();
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_STORAGE_SELL,SELL);
      }
      
      private function setLoction() : void
      {
         this._mc.x = PlantsVsZombies.WIDTH - this._mc.width + 42;
         this._mc.y = PlantsVsZombies.HEIGHT - this._mc.height + 100;
      }
      
      private function updateStorageFalse() : void
      {
         if(this._updateF != null)
         {
            this._updateF(StorageWindow.TYPE_TOOL,this._tool.getOrderId(),true,false);
            if(this._tool.getNum() < this._nownum)
            {
               this._nownum = this._tool.getNum();
               this._mc["_num"].text = this._nownum;
               this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
            }
            else
            {
               this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
            }
         }
      }
      
      private function updateStorage() : void
      {
         if(this._updateF != null)
         {
            this._updateF(StorageWindow.TYPE_TOOL,this._tool.getOrderId(),true);
            if(this._tool.getNum() < this._nownum)
            {
               this._mc["left_num_txt"].text = this._tool.getNum();
               this._nownum = this._tool.getNum();
               this._mc["_num"].text = this._nownum;
            }
            else
            {
               this._mc["left_num_txt"].text = this._tool.getNum() - this._nownum;
            }
         }
      }
      
      private function useScroll() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_TOOLS_USE,USE_SCROLL);
      }
   }
}


package labels
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import entity.Organism;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.genius.windows.ChangePlantsWindow;
   import pvz.storage.OrganismWindow;
   import pvz.storage.StorageLabelEvent;
   import pvz.storage.StorageWindow;
   import utils.FuncKit;
   import utils.Singleton;
   import windows.ActionWindow;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlQualityConfig;
   import xmlReader.firstPage.XmlOpenStorage;
   import zlib.utils.DomainAccess;
   
   public class StorageLabel extends Sprite implements IURLConnection
   {
      
      public static const NULL:int = 10;
      
      public static const LOCKED:int = 11;
      
      private static var GRADE_WIDTH:int = 54;
      
      public var _goods:MovieClip;
      
      internal var _node:Object;
      
      internal var _notnull:Boolean;
      
      internal var _type:int;
      
      internal var _kinds:int;
      
      public var _o:Object;
      
      internal var _openBackFun:Function;
      
      internal var _str:String = "";
      
      internal var bg:MovieClip;
      
      internal var orgWindow:OrganismWindow;
      
      internal var _p_icon:MovieClip = null;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function StorageLabel()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("label");
         this._goods = new _loc1_();
         this._goods["_mask"].visible = false;
         this._goods.gotoAndStop(1);
         this._goods.cacheAsBitmap = true;
         this._goods.bg.visible = false;
         this._goods.bg.gotoAndStop(1);
         this._goods.mouseChildren = false;
         this._goods.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addPossessionIcon();
         this.selectedEvent();
         this._goods["light"].visible = false;
         this._goods["_mc_arena"].visible = false;
         this._goods["_isInSeverbattle"].visible = false;
         this.addChild(this._goods);
         this.show(true);
      }
      
      private function addPossessionIcon() : void
      {
         var _loc1_:Class = DomainAccess.getClass("_mc_possession_icon");
         this._p_icon = new _loc1_();
         this._p_icon.visible = false;
         this._p_icon.x = 12;
         this._p_icon.y = 12;
         this._goods.addChild(this._p_icon);
      }
      
      private function selectedEvent() : void
      {
         this._goods.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._goods.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:XmlOpenStorage = new XmlOpenStorage(param2 as String);
         if(_loc3_.isSuccess())
         {
            _loc4_ = _loc3_.getStorageOrgNum();
            _loc5_ = _loc3_.getStorageToolNum();
            if(this._kinds == StorageWindow.TYPE_ORG)
            {
               PlantsVsZombies.changeMoneyOrExp(-this.playerManager.getPlayer().getStorageOrgMoney());
               this.playerManager.getPlayer().setStorageOrgGrade(_loc3_.getOpenGrade());
               this.playerManager.getPlayer().setStorageOrgMoney(_loc3_.getOpenMoney());
            }
            else if(this._kinds == StorageWindow.TYPE_TOOL || this._kinds == StorageWindow.TYPE_BOX || this._kinds == StorageWindow.TYPE_BOOK || this._kinds == StorageWindow.TYPE_MATERIAL || this._kinds == StorageWindow.TYPE_JEWEL)
            {
               PlantsVsZombies.changeMoneyOrExp(-this.playerManager.getPlayer().getStorageToolMoney());
               this.playerManager.getPlayer().setStorageToolGrade(_loc3_.getOpenGrade());
               this.playerManager.getPlayer().setStorageToolMoney(_loc3_.getOpenMoney());
            }
            this.playerManager.getPlayer().setStorageOrgNum(_loc4_);
            this.playerManager.getPlayer().setStorageToolNum(_loc5_);
            if(this._openBackFun != null)
            {
               this._openBackFun(this._str);
            }
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node014"));
         }
         else
         {
            if(_loc3_.errorType() == XmlBaseReader.CONNECT_ERROR1)
            {
               PlantsVsZombies.showRushLoading();
               return;
            }
            PlantsVsZombies.showSystemErrorInfo(_loc3_.error());
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionWindow = null;
         if(this._type == ChangePlantsWindow.JEWEL_ORG)
         {
            if(this._openBackFun != null)
            {
               this._openBackFun(this._o);
            }
            return;
         }
         if(this._type == StorageWindow.TYPE_ORG)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            dispatchEvent(new StorageLabelEvent(StorageLabelEvent.STORAGELABEL_CLICK,this._o));
         }
         else if(this._type == StorageWindow.TYPE_TOOL || this._type == StorageWindow.TYPE_BOX || this._type == StorageWindow.TYPE_BOOK || this._type == StorageWindow.TYPE_MATERIAL || this._kinds == StorageWindow.TYPE_JEWEL)
         {
            dispatchEvent(new StorageLabelEvent(StorageLabelEvent.STORAGELABEL_CLICK,this._o));
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         }
         else if(this._type == LOCKED)
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _loc2_ = new ActionWindow();
            if(this._kinds == StorageWindow.TYPE_TOOL || this._kinds == StorageWindow.TYPE_BOX || this._kinds == StorageWindow.TYPE_BOOK || this._kinds == StorageWindow.TYPE_MATERIAL || this._kinds == StorageWindow.TYPE_JEWEL)
            {
               if(this.playerManager.getPlayer().getStorageToolGrade() == 0 && this.playerManager.getPlayer().getStorageToolMoney() == 0)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node015"));
                  return;
               }
               if(this.playerManager.getPlayer().getGrade() < this.playerManager.getPlayer().getStorageToolGrade())
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node016",this.playerManager.getPlayer().getStorageToolGrade()));
               }
               else if(this.playerManager.getPlayer().getMoney() < this.playerManager.getPlayer().getStorageToolMoney())
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node017",this.playerManager.getPlayer().getStorageToolMoney()));
               }
               else
               {
                  _loc2_.init(1,Icon.SYSTEM,"",LangManager.getInstance().getLanguage("node018",this.playerManager.getPlayer().getStorageToolMoney()),this.open,true);
               }
            }
            else
            {
               if(this._kinds != StorageWindow.TYPE_ORG)
               {
                  return;
               }
               PlantsVsZombies.playSounds(SoundManager.BUTTON2);
               if(this.playerManager.getPlayer().getStorageOrgMoney() == 0 && this.playerManager.getPlayer().getStorageOrgGrade() == 0)
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node015"));
                  return;
               }
               if(this.playerManager.getPlayer().getGrade() < this.playerManager.getPlayer().getStorageOrgGrade())
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node016",this.playerManager.getPlayer().getStorageOrgGrade()));
               }
               else if(this.playerManager.getPlayer().getMoney() < this.playerManager.getPlayer().getStorageOrgMoney())
               {
                  PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node017",this.playerManager.getPlayer().getStorageOrgMoney()));
               }
               else
               {
                  _loc2_.init(1,Icon.SYSTEM,"",LangManager.getInstance().getLanguage("node018",this.playerManager.getPlayer().getStorageOrgMoney()),this.open,true);
               }
            }
         }
      }
      
      private function open() : void
      {
         var _loc1_:String = null;
         if(this._kinds == StorageWindow.TYPE_ORG)
         {
            _loc1_ = "organism";
         }
         else
         {
            if(!(this._kinds == StorageWindow.TYPE_TOOL || this._kinds == StorageWindow.TYPE_BOX || this._kinds == StorageWindow.TYPE_BOOK || this._kinds == StorageWindow.TYPE_MATERIAL || this._kinds == StorageWindow.TYPE_JEWEL))
            {
               return;
            }
            _loc1_ = "tool";
         }
         this._str = _loc1_;
         this.urlloaderSend(PlantsVsZombies.getURL("Warehouse/opengrid/type/" + _loc1_),0);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this._notnull && !(this._o is Organism))
         {
            this._goods.gotoAndStop(2);
         }
         if(this._o is Organism)
         {
            this.bg.gotoAndStop(2);
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._notnull && !(this._o is Organism))
         {
            this._goods.gotoAndStop(1);
         }
         if(this._o is Organism)
         {
            this.bg.gotoAndStop(1);
         }
      }
      
      private function setOrgBg(param1:Organism) : void
      {
         var _loc2_:Class = DomainAccess.getClass("label_bg" + XmlQualityConfig.getInstance().getCardQualityId(param1.getQuality_name()));
         this.bg = new _loc2_();
         this.bg.gotoAndStop(1);
         this._goods.bg.addChild(this.bg);
         this._goods.bg.visible = true;
      }
      
      public function update(param1:Object, param2:int, param3:int, param4:Function) : void
      {
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         this._o = param1;
         this._type = param2;
         this._kinds = param3;
         FuncKit.clearAllChildrens(this._goods["pic"]);
         FuncKit.clearAllChildrens(this._goods["grade"]);
         FuncKit.clearAllChildrens(this._goods["bg"]);
         this._goods["str"].text = "";
         this._goods["str2"].text = "";
         this._goods["blood"].visible = false;
         this._goods["blood_bg"].visible = false;
         this._goods["light"].visible = false;
         this._goods["_mc_arena"].visible = false;
         this._goods["_isInSeverbattle"].visible = false;
         this._p_icon.visible = false;
         this._goods.buttonMode = true;
         this._openBackFun = param4;
         if(param1 != null)
         {
            if(this._o is Organism)
            {
               Icon.setUrlIcon(this._goods["pic"],(this._o as Organism).getPicId(),Icon.ORGANISM_1);
               _loc5_ = DomainAccess.getClass("grade");
               _loc6_ = new _loc5_();
               _loc6_["num"].addChild(FuncKit.getNumEffect("" + (this._o as Organism).getGrade()));
               this._goods["grade"].addChild(_loc6_);
               this._goods["grade"].x = this._goods["grade_loc"].x + (GRADE_WIDTH - _loc6_.width) / 2;
               this._goods["_mc_arena"].visible = (this._o as Organism).getIsArena();
               this._goods["blood"].visible = true;
               this._goods["blood_bg"].visible = true;
               _loc7_ = (this._o as Organism).getHp().toNumber() / (this._o as Organism).getHp_max().toNumber();
               if(_loc7_ > 1)
               {
                  _loc7_ = 1;
               }
               this._goods["blood"].scaleX = _loc7_;
               if((this._o as Organism).getGardenId() != 0)
               {
                  this._goods["light"].visible = true;
               }
               this.setOrgBg(this._o as Organism);
               this._p_icon.visible = (this._o as Organism).getIsPossession();
               this._goods["_isInSeverbattle"].visible = (this._o as Organism).getIsSeverBattle();
            }
            else
            {
               Icon.setUrlIcon(this._goods["pic"],(this._o as Tool).getPicId(),Icon.TOOL_1);
               this._goods["str"].text = (this._o as Tool).getName();
               this._goods["str2"].text = this._o.getNum() + "个";
            }
            this._goods["str"].visible = true;
            this._notnull = true;
            this._goods.gotoAndStop(1);
         }
         else
         {
            if(this._type == NULL)
            {
               this._goods.gotoAndStop(3);
               this._goods.buttonMode = false;
            }
            else
            {
               this._goods.gotoAndStop(4);
            }
            this._goods["str"].visible = false;
            this._notnull = false;
         }
         this.show(true);
      }
      
      private function show(param1:Boolean = false) : void
      {
         this._goods.visible = param1;
      }
      
      public function setLoction(param1:int) : void
      {
         var _loc2_:int = param1 % 4;
         var _loc3_:int = param1 / 4;
         this._goods.x = (this._goods.width + 4) * _loc2_;
         this._goods.y = (this._goods.height + 4) * _loc3_;
      }
      
      public function clearAllEvent() : void
      {
         this._goods.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this._goods.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         this._goods.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function getObjData() : Object
      {
         return this._o;
      }
   }
}


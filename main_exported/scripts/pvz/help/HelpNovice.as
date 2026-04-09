package pvz.help
{
   import com.display.BitmapDateSourseManager;
   import com.display.BitmapFrameInfos;
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import entity.Hole;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.OrganismManager;
   import manager.PlayerManager;
   import pvz.firstpage.otherhelp.MenuButtonManager;
   import utils.Singleton;
   import zlib.utils.DomainAccess;
   
   public class HelpNovice implements IURLConnection
   {
      
      public static var BATTLEREADY_CHOOSE_ORG:int = 3;
      
      public static var BATTLEREADY_ENTER_BATTLE:int = 4;
      
      public static var BATTLE_CHOOSE_PRIZES:int = 5;
      
      public static var BATTLE_GET_PRIZES:int = 6;
      
      public static var BATTLE_OK:int = 11;
      
      public static var BATTLE_ORGS_PRIZE:int = 7;
      
      public static var BATTLE_ORG_PRIZE:int = 8;
      
      public static var BATTLE_PLAY_CARTOON:int = 10;
      
      public static var BATTLE_SHOW_PRIZES:int = 9;
      
      public static var FIRST_ENTER_GARDEN:int = 13;
      
      public static var FIRST_ENTER_HUNTING:int = 1;
      
      public static var GARDEN_CHOOSE_ORG:int = 15;
      
      public static var GARDEN_DOWORK_FERTILISER:int = 18;
      
      public static var GARDEN_DOWORK_GAIN:int = 19;
      
      public static var GARDEN_GOTO_FRIEND:int = 20;
      
      public static var GARDEN_GOTO_FIRST:int = 21;
      
      public static var GARDEN_DOWORK_WATER:int = 17;
      
      public static var GARDEN_ENTER_CHOOSEORG:int = 14;
      
      public static var GARDEN_INTO_ORG:int = 16;
      
      public static var HUNTING_ENTER_BATTLEREADY:int = 2;
      
      public static var HUNTING_ENTER_FIRST:int = 12;
      
      public static var FIRST_OPEN_COMP:int = 22;
      
      public static var COMP_CHOOSE_ORG:int = 23;
      
      public static var COMP_GET_EVOLUTION:int = 24;
      
      public static var COMP_CLOSE_EVOLUTION:int = 25;
      
      public static var COMP_ENTER_FIRST:int = 26;
      
      public static var INIT_MONEY:int = 30000;
      
      internal static const BATTLEURL:String = "config/helpBattleInfo.xml";
      
      internal static const BATTLEURL_SEC:String = "config/helpBattleInfoSec.xml";
      
      internal static var battleInfo:String = "";
      
      internal static var battleInfoSec:String = "";
      
      private static const URL_BATTLEINFO:int = 1;
      
      private static const URL_BATTLEINFO_SEC:int = 2;
      
      private const ORGS:Array = [38,65,107];
      
      private const ORGS2:Array = [55,71,5];
      
      private const ORGS3:Array = [58,63,40];
      
      private const ORGS4:Array = [4,5,2];
      
      public var nowType:int = 0;
      
      internal var _baseNode:DisplayObjectContainer;
      
      internal var _mc:MovieClip;
      
      internal var awards:Array;
      
      internal var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      public function HelpNovice(param1:String = "")
      {
         super();
         this.urlloaderSend(param1 + BATTLEURL,URL_BATTLEINFO);
         this.urlloaderSend(param1 + BATTLEURL_SEC,URL_BATTLEINFO_SEC);
      }
      
      private function initBattleOrgsBitmap(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.initOrg(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function initOrg(param1:int) : void
      {
         this.initBitmap("org_" + param1 + "_0");
         this.initBitmap("org_" + param1 + "_attack_0");
         this.initBitmap("org_" + param1 + "_attackover_0");
         this.initBitmap("org_" + param1 + "_bulletBlast_0");
         this.initBitmap("org_" + param1 + "_bullet_0");
      }
      
      private function initBitmap(param1:String) : void
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:MovieClip = new _loc2_();
         if(_loc3_.numChildren < 1)
         {
            return;
         }
         var _loc4_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc3_.getChildAt(0) as MovieClip,param1);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         if(param1 == URL_BATTLEINFO)
         {
            battleInfo = param2 as String;
         }
         else if(param1 == URL_BATTLEINFO_SEC)
         {
            battleInfoSec = param2 as String;
         }
      }
      
      private function changeOrg() : void
      {
         var _loc1_:Organism = this.playerManager.getOrganism(this.playerManager.getPlayer(),1);
         _loc1_.setGardenType(OrganismManager.NULL);
         _loc1_.setNextType(OrganismManager.WATER);
         _loc1_.setTypeTime(3);
         _loc1_.setGainTime(10000);
         _loc1_.setGardenId(this.playerManager.getPlayer().getId());
      }
      
      private function changeOrgAfterF() : void
      {
         var _loc1_:Organism = this.playerManager.getOrganism(this.playerManager.getPlayer(),1);
         _loc1_.setGardenType(OrganismManager.NULL);
         _loc1_.setNextType(OrganismManager.GAIN);
         _loc1_.setGainTime(3);
         _loc1_.setIsSteal(0);
         _loc1_.setGainTime(3);
      }
      
      private function changeOrgAfterWater() : void
      {
         var _loc1_:Organism = this.playerManager.getOrganism(this.playerManager.getPlayer(),1);
         _loc1_.setGardenType(OrganismManager.NULL);
         _loc1_.setNextType(OrganismManager.FERTILISER);
         _loc1_.setTypeTime(3);
      }
      
      private function changeOrgAfterGain() : void
      {
         var _loc1_:Organism = this.playerManager.getOrganism(this.playerManager.getPlayer(),1);
         _loc1_.setGardenType(OrganismManager.NULL);
         _loc1_.setNextType(OrganismManager.NULL);
         _loc1_.setGardenId(0);
         _loc1_.setHp("60");
         _loc1_.setHp_max("60");
         _loc1_.setAttack(30);
         _loc1_.setMiss(3);
         _loc1_.setPrecision(9);
         _loc1_.setGrade(1);
         _loc1_.setTypeTime(0);
         _loc1_.setPullulation(3);
      }
      
      private function changeOrgClear() : void
      {
         var _loc1_:Organism = this.playerManager.getOrganism(this.playerManager.getPlayer(),1);
         _loc1_.setGardenType(OrganismManager.NULL);
         _loc1_.setNextType(OrganismManager.NULL);
         _loc1_.setGainTime(3600);
      }
      
      public function getOrgAfterEvo() : Organism
      {
         var _loc1_:Organism = new Organism();
         _loc1_.setOrderId(110);
         _loc1_.setHp("60");
         _loc1_.setHp_max("420");
         _loc1_.setAttack(210);
         _loc1_.setPrecision(21);
         _loc1_.setMiss(63);
         _loc1_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc1_.setGrade(1);
         _loc1_.setPullulation(7);
         return _loc1_;
      }
      
      public function getAllOrgAfterEvo() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setOrderId(110);
         _loc2_.setHp("60");
         _loc2_.setHp_max("420");
         _loc2_.setAttack(210);
         _loc2_.setPrecision(21);
         _loc2_.setMiss(63);
         _loc2_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc2_.setGrade(1);
         _loc1_.push(_loc2_);
         var _loc3_:Organism = new Organism();
         _loc3_.setId(2);
         _loc3_.setGardenId(0);
         _loc3_.setOrderId(19);
         _loc3_.setHp("500");
         _loc3_.setHp_max("500");
         _loc3_.setAttack(75);
         _loc3_.setMiss(31);
         _loc3_.setPrecision(21);
         _loc3_.setPullulation(5);
         _loc3_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc3_.setGrade(1);
         _loc1_.push(_loc3_);
         return _loc1_;
      }
      
      public function clear() : void
      {
         if(this._mc != null && this._baseNode != null)
         {
            this._baseNode.removeChild(this._mc);
         }
         this._mc = null;
         this._baseNode = null;
      }
      
      public function getAwards() : Array
      {
         this.awards = new Array();
         var _loc1_:Organism = new Organism();
         _loc1_.setOrderId(109);
         this.awards.push(_loc1_);
         var _loc2_:Tool = new Tool(3);
         _loc2_.setNum(1);
         this.awards.push(_loc2_);
         var _loc3_:Tool = new Tool(4);
         _loc3_.setNum(1);
         this.awards.push(_loc3_);
         var _loc4_:Tool = new Tool(5);
         _loc4_.setNum(1);
         this.awards.push(_loc4_);
         var _loc5_:Tool = new Tool(97);
         _loc5_.setNum(1);
         this.awards.push(_loc5_);
         return this.awards;
      }
      
      public function getHuntingHoles() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Hole = new Hole();
         _loc2_.setOpenId(2);
         _loc2_.setHoleName(LangManager.getInstance().getLanguage("help004"));
         _loc2_.setId(1);
         _loc2_.setType(2);
         _loc2_.setCome_time(-1);
         _loc2_.setOpen_level(1);
         _loc2_.setOpen_money(0);
         _loc2_.setPlayMoney(0);
         var _loc3_:Array = new Array();
         var _loc4_:Object = new Object();
         _loc4_.type = "organism";
         _loc4_.id = 4;
         _loc3_.push(_loc4_);
         var _loc5_:Object = new Object();
         _loc5_.type = "organism";
         _loc5_.id = 2;
         _loc3_.push(_loc5_);
         var _loc6_:Object = new Object();
         _loc6_.type = "organism";
         _loc6_.id = 3;
         _loc3_.push(_loc6_);
         var _loc7_:Object = new Object();
         _loc7_.type = "organism";
         _loc7_.id = 1;
         _loc3_.push(_loc7_);
         var _loc8_:Object = new Object();
         _loc8_.type = "organism";
         _loc8_.id = 6;
         _loc3_.push(_loc8_);
         var _loc9_:Object = new Object();
         _loc9_.type = "organism";
         _loc9_.id = 5;
         _loc3_.push(_loc9_);
         _loc2_.setAwards(_loc3_);
         _loc1_.push(_loc2_);
         return _loc1_;
      }
      
      public function getBattleInfo() : String
      {
         return battleInfo;
      }
      
      public function getBattleInfoSec() : String
      {
         return battleInfoSec;
      }
      
      public function getEnemy() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setOrderId(2021);
         _loc2_.setId(1);
         _loc2_.setHp("450");
         _loc2_.setHp_max("450");
         _loc2_.setGrade(1);
         _loc1_.push(_loc2_);
         var _loc3_:Organism = new Organism();
         _loc3_.setId(2);
         _loc3_.setOrderId(2023);
         _loc3_.setHp("440");
         _loc3_.setHp_max("440");
         _loc3_.setGrade(1);
         _loc1_.push(_loc3_);
         var _loc4_:Organism = new Organism();
         _loc4_.setId(3);
         _loc4_.setOrderId(2041);
         _loc4_.setHp("550");
         _loc4_.setHp_max("550");
         _loc4_.setGrade(32);
         _loc1_.push(_loc4_);
         var _loc5_:Organism = new Organism();
         _loc5_.setId(4);
         _loc5_.setOrderId(2055);
         _loc5_.setHp("240");
         _loc5_.setHp_max("240");
         _loc5_.setGrade(1);
         _loc1_.push(_loc5_);
         var _loc6_:Organism = new Organism();
         _loc6_.setId(5);
         _loc6_.setOrderId(2077);
         _loc6_.setHp("440");
         _loc6_.setHp_max("440");
         _loc6_.setGrade(1);
         _loc1_.push(_loc6_);
         var _loc7_:Organism = new Organism();
         _loc7_.setId(6);
         _loc7_.setOrderId(2095);
         _loc7_.setHp("210");
         _loc7_.setHp_max("210");
         _loc7_.setGrade(1);
         _loc1_.push(_loc7_);
         return _loc1_;
      }
      
      public function getEnemySec() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setOrderId(2107);
         _loc2_.setId(10);
         _loc2_.setHp("200000");
         _loc2_.setHp_max("200000");
         _loc2_.setGrade(99);
         _loc1_.push(_loc2_);
         return _loc1_;
      }
      
      public function getFirstAfterBattleOrgs() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setId(1);
         _loc2_.setOrderId(19);
         _loc2_.setGrade(1);
         _loc2_.setExp(15);
         _loc2_.setExp_max(20);
         _loc2_.setHp("600");
         _loc2_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc2_.setHp_max("600");
         _loc2_.setAttack(90);
         _loc2_.setMiss(56);
         _loc2_.setPrecision(36);
         _loc2_.setPullulation(5);
         _loc1_.push(_loc2_);
         var _loc3_:Organism = new Organism();
         _loc3_.setId(2);
         _loc3_.setOrderId(7);
         _loc3_.setGrade(1);
         _loc3_.setExp(15);
         _loc3_.setExp_max(20);
         _loc3_.setQuality_name(LangManager.getInstance().getLanguage("help007"));
         _loc3_.setHp("1520");
         _loc3_.setHp_max("1520");
         _loc3_.setAttack(228);
         _loc3_.setMiss(166);
         _loc3_.setPrecision(96);
         _loc1_.push(_loc3_);
         var _loc4_:Organism = new Organism();
         _loc4_.setId(3);
         _loc4_.setOrderId(111);
         _loc4_.setGrade(2);
         _loc4_.setExp(20);
         _loc4_.setQuality_name(LangManager.getInstance().getLanguage("help009"));
         _loc4_.setExp_max(84);
         _loc4_.setHp("696");
         _loc4_.setHp_max("696");
         _loc4_.setAttack(290);
         _loc4_.setMiss(62);
         _loc4_.setPrecision(122);
         _loc1_.push(_loc4_);
         var _loc5_:Organism = new Organism();
         _loc5_.setId(4);
         _loc5_.setOrderId(169);
         _loc5_.setGrade(1);
         _loc5_.setExp(15);
         _loc5_.setExp_max(20);
         _loc5_.setHp("1520");
         _loc5_.setQuality_name(LangManager.getInstance().getLanguage("help007"));
         _loc5_.setHp_max("1520");
         _loc5_.setAttack(380);
         _loc5_.setMiss(198);
         _loc5_.setPrecision(183);
         _loc1_.push(_loc5_);
         return _loc1_;
      }
      
      public function getMyOrgAfterBattle() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setId(2);
         _loc2_.setOrderId(19);
         _loc2_.setGardenId(0);
         _loc2_.setHp("500");
         _loc2_.setHp_max("500");
         _loc2_.setAttack(75);
         _loc2_.setMiss(31);
         _loc2_.setPrecision(21);
         _loc2_.setPullulation(5);
         _loc2_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc2_.setGrade(1);
         var _loc3_:Organism = new Organism();
         _loc3_.setId(1);
         _loc3_.setOrderId(109);
         _loc3_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc3_.setGardenId(0);
         _loc3_.setHp("60");
         _loc3_.setHp_max("60");
         _loc3_.setGrade(1);
         _loc3_.setAttack(30);
         _loc3_.setPrecision(9);
         _loc3_.setPullulation(3);
         _loc3_.setMiss(3);
         _loc1_.push(_loc3_);
         _loc1_.push(_loc2_);
         return _loc1_;
      }
      
      public function getMyOrgBeforeBattle() : Organism
      {
         var _loc1_:Organism = new Organism();
         _loc1_.setId(1);
         _loc1_.setGardenId(0);
         _loc1_.setOrderId(19);
         _loc1_.setHp("500");
         _loc1_.setHp_max("500");
         _loc1_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc1_.setGrade(1);
         _loc1_.setAttack(75);
         _loc1_.setMiss(31);
         _loc1_.setPrecision(21);
         _loc1_.setPullulation(5);
         return _loc1_;
      }
      
      public function getMyOrgs() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Organism = new Organism();
         _loc2_.setId(1);
         _loc2_.setOrderId(19);
         _loc2_.setGrade(1);
         _loc2_.setExp(0);
         _loc2_.setExp_max(20);
         _loc2_.setHp("500");
         _loc2_.setHp_max("500");
         _loc2_.setQuality_name(LangManager.getInstance().getLanguage("help001"));
         _loc2_.setAttack(75);
         _loc2_.setMiss(31);
         _loc2_.setPrecision(21);
         _loc2_.setPullulation(5);
         _loc1_.push(_loc2_);
         var _loc3_:Organism = new Organism();
         _loc3_.setId(2);
         _loc3_.setOrderId(7);
         _loc3_.setGrade(1);
         _loc3_.setExp(0);
         _loc3_.setExp_max(20);
         _loc3_.setQuality_name(LangManager.getInstance().getLanguage("help007"));
         _loc3_.setHp("1100");
         _loc3_.setHp_max("1100");
         _loc3_.setAttack(165);
         _loc3_.setMiss(61);
         _loc3_.setPrecision(33);
         _loc1_.push(_loc3_);
         var _loc4_:Organism = new Organism();
         _loc4_.setId(3);
         _loc4_.setOrderId(111);
         _loc4_.setGrade(1);
         _loc4_.setExp(0);
         _loc4_.setExp_max(20);
         _loc4_.setQuality_name(LangManager.getInstance().getLanguage("help009"));
         _loc4_.setHp("540");
         _loc4_.setHp_max("540");
         _loc4_.setAttack(225);
         _loc4_.setMiss(30);
         _loc4_.setPrecision(29);
         _loc1_.push(_loc4_);
         var _loc5_:Organism = new Organism();
         _loc5_.setId(4);
         _loc5_.setOrderId(169);
         _loc5_.setGrade(1);
         _loc5_.setExp(0);
         _loc5_.setExp_max(20);
         _loc5_.setQuality_name(LangManager.getInstance().getLanguage("help007"));
         _loc5_.setAttack(240);
         _loc5_.setMiss(58);
         _loc5_.setPrecision(43);
         _loc5_.setHp("960");
         _loc5_.setHp_max("960");
         _loc1_.push(_loc5_);
         var _loc6_:Organism = new Organism();
         _loc6_.setId(6);
         _loc6_.setOrderId(165);
         _loc6_.setGrade(1);
         _loc6_.setExp(0);
         _loc6_.setExp_max(20);
         _loc6_.setQuality_name(LangManager.getInstance().getLanguage("help009"));
         _loc6_.setAttack(200);
         _loc6_.setMiss(50);
         _loc6_.setPrecision(37);
         _loc6_.setHp("800");
         _loc6_.setHp_max("800");
         _loc1_.push(_loc6_);
         var _loc7_:Organism = new Organism();
         _loc7_.setId(5);
         _loc7_.setOrderId(109);
         _loc7_.setGrade(1);
         _loc7_.setExp(0);
         _loc7_.setExp_max(20);
         _loc6_.setAttack(150);
         _loc6_.setMiss(30);
         _loc6_.setPrecision(29);
         _loc7_.setHp("360");
         _loc7_.setHp_max("360");
         _loc1_.push(_loc7_);
         return _loc1_;
      }
      
      public function getMyOrgsSec() : Array
      {
         return this.getFirstAfterBattleOrgs();
      }
      
      public function getMyPriezs() : Array
      {
         this.awards = new Array();
         var _loc1_:Array = new Array(2);
         _loc1_[0] = "tool";
         _loc1_[1] = "146";
         this.awards.push(_loc1_);
         var _loc2_:Array = new Array(2);
         _loc2_[0] = "tool";
         _loc2_[1] = "254";
         this.awards.push(_loc2_);
         var _loc3_:Array = new Array(2);
         _loc3_[0] = "tool";
         _loc3_[1] = "308";
         this.awards.push(_loc3_);
         var _loc4_:Array = new Array(2);
         _loc4_[0] = "organism";
         _loc4_[1] = "163";
         this.awards.push(_loc4_);
         return this.awards;
      }
      
      public function getMyTools() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Tool = new Tool(3);
         _loc2_.setNum(1);
         var _loc3_:Tool = new Tool(4);
         _loc3_.setNum(1);
         var _loc4_:Tool = new Tool(5);
         _loc4_.setNum(1);
         var _loc5_:Tool = new Tool(97);
         _loc5_.setNum(1);
         var _loc6_:Tool = new Tool(254);
         _loc6_.setNum(1);
         _loc1_.push(_loc2_);
         _loc1_.push(_loc3_);
         _loc1_.push(_loc4_);
         _loc1_.push(_loc5_);
         _loc1_.push(_loc6_);
         return _loc1_;
      }
      
      public function show(param1:int, param2:DisplayObjectContainer) : void
      {
         var onClick:Function = null;
         var onPlay:Function = null;
         var onClick2:Function = null;
         var type:int = param1;
         var baseNode:DisplayObjectContainer = param2;
         if(type == 9)
         {
            this.nowType = 10;
         }
         else if(type != this.nowType + 1)
         {
            return;
         }
         if(this._mc != null && this._baseNode != null)
         {
            this.clear();
         }
         if(type == 13)
         {
            MenuButtonManager.instance.setButtonVisibleByName("toGarden",true);
         }
         if(type == 14)
         {
            MenuButtonManager.instance.setButtonVisibleByName("toGarden",false);
         }
         if(type == 22)
         {
            MenuButtonManager.instance.setButtonVisibleByName("compound",true);
         }
         if(type == 23)
         {
            MenuButtonManager.instance.setButtonVisibleByName("compound",false);
         }
         if(type == 1)
         {
            this.initBattleOrgsBitmap(this.ORGS);
         }
         else if(type == 2)
         {
            this.initBattleOrgsBitmap(this.ORGS2);
         }
         else if(type == 3)
         {
            this.initBattleOrgsBitmap(this.ORGS3);
         }
         else if(type == 4)
         {
            this.initBattleOrgsBitmap(this.ORGS4);
         }
         this.nowType = type;
         if(baseNode == null)
         {
            return;
         }
         this._mc = this.getHelpFore(type);
         this._baseNode = baseNode;
         this._baseNode.addChild(this._mc);
         if(this.nowType <= GARDEN_DOWORK_GAIN && this.nowType >= GARDEN_DOWORK_WATER)
         {
            onClick = function(param1:MouseEvent):void
            {
               if(nowType == GARDEN_DOWORK_WATER)
               {
                  changeOrg();
               }
               if(nowType == GARDEN_DOWORK_FERTILISER)
               {
                  changeOrgAfterWater();
               }
               if(nowType == GARDEN_DOWORK_GAIN)
               {
                  changeOrgAfterF();
               }
               _mc.bt.removeEventListener(MouseEvent.CLICK,onClick);
               _mc.clock.visible = true;
               _mc.clock.addEventListener(Event.ENTER_FRAME,onPlay);
               _mc.clock.gotoAndPlay(1);
               _mc.bt.visible = false;
               _mc.gotoAndStop(2);
            };
            onPlay = function(param1:Event):void
            {
               if(_mc.clock.currentFrame != _mc.clock.totalFrames)
               {
                  return;
               }
               _mc.clock.removeEventListener(Event.ENTER_FRAME,onPlay);
               _mc.clock.visible = false;
               _mc.gotoAndStop(3);
            };
            this.changeOrgClear();
            this._mc.bt.addEventListener(MouseEvent.CLICK,onClick);
            this._mc.gotoAndStop(1);
            this._mc.clock.gotoAndStop(1);
            this._mc.clock.visible = false;
         }
         if(this.nowType == GARDEN_GOTO_FRIEND)
         {
            onClick2 = function(param1:MouseEvent):void
            {
               _mc.bt.visible = false;
               _mc.bt.removeEventListener(MouseEvent,onClick2);
               _mc.gotoAndStop(2);
            };
            this.changeOrgAfterGain();
            this._mc.bt.addEventListener(MouseEvent.CLICK,onClick2);
            this._mc.gotoAndStop(1);
         }
      }
      
      private function getHelpFore(param1:int) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass("help_" + param1);
         return new _loc2_();
      }
   }
}


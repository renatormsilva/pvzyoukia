package pvz.genius.scene
{
   import effect.flap.FlapManager;
   import entity.Organism;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import manager.LangManager;
   import manager.PlayerManager;
   import manager.SoundManager;
   import pvz.genius.events.GeniusUpEvent;
   import pvz.genius.fport.PlantGeniusResetFPort;
   import pvz.genius.jewelSystem.JewelComposeWindow;
   import pvz.genius.scene.ceil.GeniusCeil;
   import pvz.genius.scene.ceil.OrganismSoulCeil;
   import pvz.genius.tips.GeniusBallTips;
   import pvz.genius.tips.GeniusSystemHelpTips;
   import pvz.genius.vo.Genius;
   import pvz.genius.vo.GeniusData;
   import pvz.genius.windows.ChangePlantsWindow;
   import pvz.genius.windows.GeniusResetWindow;
   import pvz.genius.windows.SoulLevelUpWindow;
   import pvz.serverbattle.qualifying.MovieMotion;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.M_ClipMotion;
   import utils.Singleton;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class GeniusScene extends Sprite
   {
      
      private static const TALENT_NUM:int = 9;
      
      private static var m_genius_coor:Array = [new Point(576.7,160),new Point(682.5,231.9),new Point(623.8,325.9),new Point(507.6,383.9),new Point(370,408),new Point(239,415),new Point(100,388.9),new Point(62,280),new Point(150,201)];
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      private var ceils:Dictionary = new Dictionary();
      
      private var _bg:Sprite;
      
      private var plants:Array;
      
      private var _index:int = 0;
      
      private var _leftButton:SimpleButton;
      
      private var _rightButton:SimpleButton;
      
      private var cPlantSoulLevel:int;
      
      private var plantsLen:int;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      private var current_plant:Organism;
      
      private var _single_show_plant:OrganismSoulCeil;
      
      private var __tips:GeniusBallTips;
      
      public var backFuncDestory:Function;
      
      private var _upFport:PlantGeniusResetFPort;
      
      private var _oid:int;
      
      private var m_plant_battleNum:Number;
      
      private var m_attack_added_num:Number = 0;
      
      private var m_geniusHelpTip:GeniusSystemHelpTips;
      
      public function GeniusScene(param1:int = 0)
      {
         super();
         this._oid = param1;
         this.reset();
         this.initGameBg();
         this.initGeniusUI();
         this.initGeniusScene(this._oid,true);
         this.addEvents();
      }
      
      private function onBackToFirstpage(param1:MouseEvent) : void
      {
         if(this.backFuncDestory != null)
         {
            this.backFuncDestory();
         }
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         var _loc2_:SimpleButton = param1.currentTarget as SimpleButton;
         switch(_loc2_.name)
         {
            case "cplants":
               new ChangePlantsWindow(this.changePlantsInChangeWindow);
               break;
            case "greset":
               new GeniusResetWindow(this.PlantGeniusResetRequest);
               break;
            case "jcompose":
               new JewelComposeWindow();
         }
      }
      
      private function PlantGeniusResetRequest() : void
      {
         if(this._upFport == null)
         {
            this._upFport = new PlantGeniusResetFPort(this);
         }
         this._upFport.requestSever(PlantGeniusResetFPort.RESET_GENIUS,this.current_plant.getId());
      }
      
      public function PlantGeniusReset() : void
      {
         this.reset();
         this.changePlantsInChangeWindow(this._oid);
         this.renewBattleAttack();
      }
      
      private function initGeniusScene(param1:int = 0, param2:Boolean = false) : void
      {
         if(this.ceils == null || this.plants == null)
         {
            return;
         }
         if(param2)
         {
            this._bg["cplants"].y = this._bg["greset"].y = this._bg["jcompose"].y = PlantsVsZombies.HEIGHT;
         }
         else
         {
            this.resetGeniusXY();
            this.clearAllGeniusEffect();
            if(param1 == 0)
            {
               this.current_plant = this.plants[this._index];
               this._oid = this.current_plant.getId();
            }
            else
            {
               this._oid = param1;
            }
         }
         this.beginMcPlantSetUp();
         this.cyclePlayGeniusMove(true,1);
      }
      
      private function clearAllGeniusEffect() : void
      {
         var _loc2_:GeniusCeil = null;
         var _loc1_:int = 0;
         while(_loc1_ < TALENT_NUM)
         {
            _loc2_ = this.ceils["talent_" + (_loc1_ + 1)] as GeniusCeil;
            _loc2_.clearGeniusEffect();
            _loc2_.setDefaultType(3);
            _loc1_++;
         }
      }
      
      private function resetGeniusXY() : void
      {
         var _loc2_:Sprite = null;
         var _loc1_:int = 0;
         while(_loc1_ < TALENT_NUM)
         {
            _loc2_ = this.getGeniusCeil("talent_" + (_loc1_ + 1));
            _loc2_.x = 360;
            _loc2_.y = 193;
            _loc2_.visible = false;
            _loc1_++;
         }
      }
      
      private function initGameBg() : void
      {
         if(this._bg == null)
         {
            this._bg = GetDomainRes.getSprite("geniusBG");
         }
         this.addChild(this._bg);
      }
      
      private function initGeniusUI() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:GeniusCeil = null;
         var _loc1_:int = 0;
         while(_loc1_ < TALENT_NUM)
         {
            _loc2_ = this.getGeniusCeil("talent_" + (_loc1_ + 1));
            _loc2_.visible = false;
            _loc3_ = new GeniusCeil(_loc2_,this._bg["tips"],"talent_" + (_loc1_ + 1));
            _loc3_.setDefaultType(1);
            this.ceils["talent_" + (_loc1_ + 1)] = _loc3_;
            _loc1_++;
         }
      }
      
      private function cyclePlayGeniusMove(param1:Boolean, param2:int) : void
      {
         var arr_index:int;
         var order_c:int = 0;
         var target_genius_box:Sprite = null;
         var orgGiftData:Genius = null;
         var myInterval:uint = 0;
         var targetX:Number = NaN;
         var targetY:Number = NaN;
         var target_point:Point = null;
         var move:Function = null;
         var control:Boolean = param1;
         var order:int = param2;
         move = function():void
         {
            var _loc2_:Boolean = false;
            target_genius_box.x += (targetX - target_genius_box.x) * 0.7;
            target_genius_box.y += (targetY - target_genius_box.y) * 0.7;
            target_genius_box.alpha += 0.1;
            var _loc1_:Point = new Point(target_genius_box.x,target_genius_box.y);
            if(Point.distance(target_point,_loc1_) <= 2)
            {
               clearInterval(myInterval);
               target_genius_box.x = targetX;
               target_genius_box.y = targetY;
               target_genius_box.alpha = 1;
               _loc2_ = updataSingleGeniusBall(orgGiftData,order_c);
               ++order_c;
               cyclePlayGeniusMove(_loc2_,order_c);
            }
         };
         if(!control || !order || order == XmlGeniusDataConfig.GENIUS_MAX_LEVEL)
         {
            this.buttonMoveCl(1);
            PlantsVsZombies.lockScreen(true);
            return;
         }
         if(order == 1)
         {
            PlantsVsZombies.lockScreen(false);
         }
         order_c = order;
         target_genius_box = this.getGeniusCeil("talent_" + order_c);
         target_genius_box.alpha = 0;
         orgGiftData = this.current_plant.getGiftData();
         arr_index = order_c - 1;
         target_point = m_genius_coor[arr_index];
         target_genius_box.visible = true;
         targetX = Number(m_genius_coor[arr_index].x);
         targetY = Number(m_genius_coor[arr_index].y);
         myInterval = setInterval(move,5);
      }
      
      private function updataSingleGeniusBall(param1:Genius, param2:int) : Boolean
      {
         if(param2 == XmlGeniusDataConfig.GENIUS_MAX_LEVEL)
         {
            return false;
         }
         var _loc3_:String = "talent_" + param2;
         var _loc4_:GeniusCeil = this.ceils[_loc3_] as GeniusCeil;
         var _loc5_:int = param1.getParaGeniusLevelByName(_loc3_);
         var _loc6_:int = _loc5_ + 1;
         _loc4_.setDefaultType(2);
         _loc4_.glevel = _loc5_;
         var _loc7_:Boolean = this.g_geniusCanUpGrade(XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(_loc3_,_loc6_));
         _loc4_.canUpgrade = _loc7_;
         _loc4_.slevel = this.cPlantSoulLevel;
         _loc4_.orgId = this._oid;
         if(!_loc4_.hasEventListener(GeniusUpEvent.GENIUS_UP_COMMAD))
         {
            _loc4_.addEventListener(GeniusUpEvent.GENIUS_UP_COMMAD,this.changeMotion);
         }
         if(_loc5_ == 0)
         {
            return false;
         }
         return true;
      }
      
      private function beginMcPlantSetUp() : void
      {
         this.updataCurrentPlant(this._oid);
         this.updataSinglePlant(this.current_plant);
         this.m_plant_battleNum = this.current_plant.getBattleE();
         this.cPlantSoulLevel = this.current_plant.getSoulLevel();
         this.showSoulInfomation();
         this.renewBattleAttack();
      }
      
      private function getGeniusCeil(param1:String) : Sprite
      {
         return this._bg[param1];
      }
      
      private function hide_all_geniusNode(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         while(_loc2_ < TALENT_NUM)
         {
            _loc3_ = this.getGeniusCeil("talent_" + (_loc2_ + 1));
            _loc3_.visible = param1;
            _loc2_++;
         }
      }
      
      private function updataAllGeniusAndSoul(param1:Genius, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:GeniusCeil = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Sprite = null;
         var _loc10_:Boolean = false;
         this.hide_all_geniusNode(false);
         var _loc4_:int = 0;
         while(_loc4_ < TALENT_NUM)
         {
            _loc5_ = "talent_" + (_loc4_ + 1);
            _loc6_ = this.ceils[_loc5_] as GeniusCeil;
            _loc7_ = param1.getParaGeniusLevelByName(_loc5_);
            _loc8_ = _loc7_ + 1;
            _loc9_ = this.getGeniusCeil(_loc5_);
            _loc9_.visible = true;
            _loc9_.x = m_genius_coor[_loc4_].x;
            _loc9_.y = m_genius_coor[_loc4_].y;
            _loc10_ = this.g_geniusCanUpGrade(XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(_loc5_,_loc8_));
            _loc6_.canUpgrade = _loc10_;
            _loc6_.setDefaultType(2);
            _loc6_.glevel = _loc7_;
            _loc6_.slevel = param2;
            _loc6_.orgId = param3;
            if(!_loc6_.hasEventListener(GeniusUpEvent.GENIUS_UP_COMMAD))
            {
               _loc6_.addEventListener(GeniusUpEvent.GENIUS_UP_COMMAD,this.changeMotion);
            }
            if(_loc7_ == 0)
            {
               break;
            }
            _loc4_++;
         }
      }
      
      private function changeMotion(param1:GeniusUpEvent) : void
      {
         var _loc2_:GeniusCeil = param1.currentTarget as GeniusCeil;
         var _loc3_:Boolean = _loc2_.soulUp;
         var _loc4_:Number = _loc2_.getGeilX();
         var _loc5_:Number = _loc2_.getGeilY();
         this.cPlantSoulLevel = _loc2_.slevel;
         this.m_attack_added_num = param1.attackNum;
         this.reset();
         this.updataCurrentPlant(this.current_plant.getId());
         if(_loc3_)
         {
            FuncKit.clearAllChildrens(this._bg["soulNode"]);
            M_ClipMotion.play_Up_GradeEffect(this._bg["soulNode"],M_ClipMotion.SOUL_UPGRADE_EFFECT,this.up_soul_back_Commad);
         }
         else
         {
            this.updataSinglePlant(this.current_plant);
            this.updataPlantGenius(this.current_plant);
         }
         this.orgGeniusMotion(_loc4_,_loc5_,_loc3_,this.renewBattleAttack);
      }
      
      private function orgGeniusMotion(param1:Number, param2:Number, param3:Boolean, param4:Function = null) : void
      {
         var myInterval:uint = 0;
         var targetX:Number = NaN;
         var targetY:Number = NaN;
         var lightbox:MovieClip = null;
         var target_p:Point = null;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var rota:Number = NaN;
         var radin:Number = NaN;
         var move:Function = null;
         var startX:Number = param1;
         var startY:Number = param2;
         var isSoul:Boolean = param3;
         var commendFunc:Function = param4;
         move = function():void
         {
            vx = targetX - lightbox.x;
            vy = targetY - lightbox.y;
            radin = Math.atan2(vy,vx);
            rota = radin * 180 / Math.PI;
            lightbox.rotation = rota;
            lightbox.x += vx * 0.2;
            lightbox.y += vy * 0.2;
            lightbox.alpha += 0.1;
            var _loc1_:Point = new Point(lightbox.x,lightbox.y);
            if(Point.distance(_loc1_,target_p) <= 2)
            {
               lightbox.gotoAndStop(1);
               _bg.removeChild(lightbox);
               clearInterval(myInterval);
               if(!isSoul)
               {
                  PlantsVsZombies.lockScreen(true);
               }
               if(commendFunc != null)
               {
                  commendFunc();
               }
            }
         };
         targetX = Number(this._bg["attackNum"].x);
         targetY = Number(this._bg["attackNum"].y);
         target_p = new Point(targetX,targetY);
         lightbox = GetDomainRes.getMoveClip("fly_light_effect");
         lightbox.alpha = 0;
         lightbox.x = startX;
         lightbox.y = startY;
         this._bg.addChild(lightbox);
         myInterval = setInterval(move,40);
         vx = 0;
         vy = 0;
         rota = 0;
         radin = 0;
      }
      
      private function up_soul_back_Commad() : void
      {
         this.updataSinglePlant(this.current_plant);
         this.updataPlantGenius(this.current_plant);
         this.m_plant_battleNum = this.current_plant.getBattleE();
         new SoulLevelUpWindow(this.cPlantSoulLevel,this.current_plant);
         PlantsVsZombies.lockScreen(true);
      }
      
      private function renewBattleAttack() : void
      {
         var _loc3_:Number = NaN;
         FuncKit.clearAllChildrens(this._bg["attackNum"]);
         var _loc1_:Number = this.current_plant.getBattleE();
         var _loc2_:DisplayObject = FuncKit.getNumDisplayObject(_loc1_,"NewBattle",-8);
         this._bg["attackNum"].addChild(_loc2_);
         if(this.m_attack_added_num)
         {
            _loc3_ = this.m_attack_added_num;
            this.M_add_battle_Motion(_loc3_);
            this.m_plant_battleNum = _loc1_;
         }
      }
      
      private function M_add_battle_Motion(param1:Number = 0) : void
      {
         var _loc2_:DisplayObject = FuncKit.getNumDisplayObject(param1,"NewBattle",-8,true);
         this._bg["attackNum"].addChild(_loc2_);
         FlapManager.flapInfos(_loc2_.x,_loc2_.y,this._bg["attackNum"] as MovieClip,_loc2_ as DisplayObject,1);
         this.m_attack_added_num = 0;
      }
      
      private function updataCurrentPlant(param1:int) : void
      {
         var _loc2_:Organism = null;
         for each(_loc2_ in this.plants)
         {
            if(_loc2_.getId() == param1)
            {
               this.current_plant = _loc2_;
               break;
            }
         }
         this._index = this.plants.indexOf(this.current_plant);
      }
      
      private function changePlantsInChangeWindow(param1:int) : void
      {
         this.initGeniusScene(param1);
      }
      
      private function updataSinglePlant(param1:Organism = null) : void
      {
         this.clearPlants();
         FuncKit.clearAllChildrens(this._bg["tips"]);
         this._single_show_plant = new OrganismSoulCeil(param1,1,this._bg["tips"],true);
         this._single_show_plant.x = this.centerX - 15;
         this._single_show_plant.y = this.centerY + 55;
         this._bg["plantsNode"].addChild(this._single_show_plant);
         this._single_show_plant.upOrgSoulLightEffect();
      }
      
      private function updataPlantGenius(param1:Organism) : void
      {
         var _loc2_:Genius = param1.getGiftData();
         var _loc3_:int = param1.getSoulLevel();
         var _loc4_:int = param1.getId();
         this.updataAllGeniusAndSoul(_loc2_,_loc3_,_loc4_);
         this.cPlantSoulLevel = param1.getSoulLevel();
         this.showSoulInfomation();
      }
      
      private function buttonMoveCl(param1:int) : void
      {
         if(this._bg["cplants"].y <= 445 || this._bg["greset"].y <= 445 || this._bg["jcompose"].y <= 445)
         {
            return;
         }
         var _loc2_:int = param1;
         switch(_loc2_)
         {
            case 1:
               MovieMotion.goButtonAnimate(this._bg["cplants"],442);
               break;
            case 2:
               MovieMotion.goButtonAnimate(this._bg["greset"],442);
               break;
            case 3:
               MovieMotion.goButtonAnimate(this._bg["jcompose"],440);
               break;
            default:
               return;
         }
         _loc2_++;
         this.buttonMoveCl(_loc2_);
      }
      
      private function showSoulInfomation() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.cPlantSoulLevel)
         {
            FuncKit.clearAllChildrens(this._bg["soul_level"]);
            this._bg["soul_level"].visible = true;
            this._bg["wjh"].visible = false;
            _loc1_ = FuncKit.getStarDisBySoulLevel(this.cPlantSoulLevel);
            this._bg["soul_level"].addChild(_loc1_);
            _loc1_.y = -_loc1_.height / 2;
         }
         else
         {
            FuncKit.clearAllChildrens(this._bg["soul_level"]);
            this._bg["wjh"].visible = true;
         }
      }
      
      private function g_geniusCanUpGrade(param1:GeniusData) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:int = param1.requiredUserGrade;
         var _loc3_:Tool = param1.requiredTool;
         var _loc4_:int = _loc3_.getOrderId();
         if(_loc2_ > this.playerManager.getPlayer().getGrade())
         {
            return false;
         }
         if(this.playerManager.getPlayer().getTool(_loc4_) == null)
         {
            return false;
         }
         return true;
      }
      
      private function clearGenius() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GeniusCeil = null;
         while(_loc1_ < this.ceils.length)
         {
            _loc2_ = this.ceils["talent_" + (_loc1_ + 1)] as GeniusCeil;
            if(_loc2_.hasEventListener(GeniusUpEvent.GENIUS_UP_COMMAD))
            {
               _loc2_.removeEventListener(GeniusUpEvent.GENIUS_UP_COMMAD,this.changeMotion);
            }
            _loc2_.dispose();
            _loc1_++;
         }
      }
      
      private function clearPlants() : void
      {
         var _loc1_:OrganismSoulCeil = null;
         while(this._bg["plantsNode"].numChildren > 0)
         {
            _loc1_ = this._bg["plantsNode"].getChildAt(0) as OrganismSoulCeil;
            _loc1_.destroy();
            this._bg["plantsNode"].removeChild(_loc1_);
         }
      }
      
      public function destroy() : void
      {
         this.plants = null;
         this.clearGenius();
         this.clearPlants();
         this.ceils = null;
         FuncKit.clearAllChildrens(this._bg["soul_level"]);
         FuncKit.clearAllChildrens(this._bg["tips"]);
         FuncKit.clearAllChildrens(this);
      }
      
      private function onRightClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._index >= this.plantsLen - 1)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("genius031"));
            return;
         }
         ++this._index;
         this.initGeniusScene();
      }
      
      private function onLeftClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         if(this._index <= 0)
         {
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("genius030"));
            return;
         }
         --this._index;
         this.initGeniusScene();
      }
      
      private function reset() : void
      {
         this.centerX = PlantsVsZombies.WIDTH / 2;
         this.centerY = PlantsVsZombies.HEIGHT / 2;
         this.plants = this.playerManager.getPlayer().getAllOrganism();
         this.plantsLen = this.plants.length;
      }
      
      private function addEvents() : void
      {
         this._bg["left"].addEventListener(MouseEvent.CLICK,this.onLeftClick);
         this._bg["right"].addEventListener(MouseEvent.CLICK,this.onRightClick);
         this._bg["cplants"].addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["greset"].addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["jcompose"].addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["back"].addEventListener(MouseEvent.CLICK,this.onBackToFirstpage);
         this._bg["information"].addEventListener(MouseEvent.ROLL_OVER,this.onBtnOver);
         this._bg["information"].addEventListener(MouseEvent.ROLL_OUT,this.onBtnOut);
      }
      
      private function removeEvents() : void
      {
         this._bg["left"].removeEventListener(MouseEvent.CLICK,this.onLeftClick);
         this._bg["right"].removeEventListener(MouseEvent.CLICK,this.onRightClick);
         this._bg["cplants"].removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["greset"].removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["jcompose"].removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._bg["information"].removeEventListener(MouseEvent.ROLL_OVER,this.onBtnOver);
         this._bg["information"].removeEventListener(MouseEvent.ROLL_OUT,this.onBtnOut);
      }
      
      private function onBtnOver(param1:MouseEvent) : void
      {
         if(this.m_geniusHelpTip == null)
         {
            this.m_geniusHelpTip = new GeniusSystemHelpTips();
            this.m_geniusHelpTip.x = 300;
            this.m_geniusHelpTip.y = 10;
         }
         this._bg.addChild(this.m_geniusHelpTip);
         this.m_geniusHelpTip.visible = true;
      }
      
      private function onBtnOut(param1:MouseEvent) : void
      {
         this.m_geniusHelpTip.visible = false;
         this._bg.removeChild(this.m_geniusHelpTip);
      }
   }
}


package pvz.battle.fore
{
   import com.display.BitmapDateSourseManager;
   import com.display.BitmapFrameInfos;
   import com.display.CMovieClip;
   import com.util.CTimer;
   import com.util.CTimerEvent;
   import effect.flap.FlapManager;
   import entity.Exp;
   import entity.Organism;
   import entity.Skill;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import manager.SkillManager;
   import node.Icon;
   import pvz.battle.manager.BattleMapManager;
   import pvz.battle.node.BattleOrg;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class BattleScenceShow
   {
      
      private static var battleEnd:MovieClip = null;
      
      private static var battleStart:MovieClip = null;
      
      private static var container:MovieClip = null;
      
      public function BattleScenceShow()
      {
         super();
      }
      
      public static function getAttackedEffect(param1:int = 1, param2:Number = 1) : CMovieClip
      {
         var _loc6_:Class = null;
         var _loc3_:String = "attackedEffect" + param1;
         var _loc4_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc3_,param2);
         if(_loc4_ == null)
         {
            _loc6_ = DomainAccess.getClass(_loc3_);
            _loc4_ = BitmapDateSourseManager.getBitmapDatesByMovieClip((new _loc6_() as MovieClip).getChildAt(0) as MovieClip,_loc3_,param2);
         }
         var _loc5_:CMovieClip = new CMovieClip(_loc4_,12);
         _loc5_.bitmap.x = _loc4_.getBaseMcTransform().matrix.tx;
         _loc5_.bitmap.y = _loc4_.getBaseMcTransform().matrix.ty;
         if(_loc4_.getBaseMcTransform().matrix.a < 0)
         {
            BitmapDateSourseManager.flipHorizontal(_loc5_);
         }
         return _loc5_;
      }
      
      public static function getExclusiveSkillsEffect(param1:int = 1, param2:Number = 1) : CMovieClip
      {
         var _loc6_:Class = null;
         var _loc3_:String = "exclusiveEffect" + param1;
         var _loc4_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc3_,param2);
         if(_loc4_ == null)
         {
            _loc6_ = DomainAccess.getClass(_loc3_);
            _loc4_ = BitmapDateSourseManager.getBitmapDatesByMovieClip((new _loc6_() as MovieClip).getChildAt(0) as MovieClip,_loc3_,param2);
         }
         var _loc5_:CMovieClip = new CMovieClip(_loc4_,12);
         _loc5_.bitmap.x = _loc4_.getBaseMcTransform().matrix.tx;
         _loc5_.bitmap.y = _loc4_.getBaseMcTransform().matrix.ty;
         if(_loc4_.getBaseMcTransform().matrix.a < 0)
         {
            BitmapDateSourseManager.flipHorizontal(_loc5_);
         }
         return _loc5_;
      }
      
      public static function getBuffEffect(param1:int = 1, param2:Number = 1) : CMovieClip
      {
         var _loc6_:Class = null;
         var _loc3_:String = "buffEffect" + param1;
         var _loc4_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc3_,param2);
         if(_loc4_ == null)
         {
            _loc6_ = DomainAccess.getClass(_loc3_);
            _loc4_ = BitmapDateSourseManager.getBitmapDatesByMovieClip((new _loc6_() as MovieClip).getChildAt(0) as MovieClip,_loc3_,param2);
         }
         var _loc5_:CMovieClip = new CMovieClip(_loc4_,12);
         _loc5_.bitmap.x = _loc4_.getBaseMcTransform().matrix.tx;
         _loc5_.bitmap.y = _loc4_.getBaseMcTransform().matrix.ty;
         if(_loc4_.getBaseMcTransform().matrix.a < 0)
         {
            BitmapDateSourseManager.flipHorizontal(_loc5_);
         }
         return _loc5_;
      }
      
      public static function getGeniusEffect(param1:String, param2:Number) : CMovieClip
      {
         var _loc6_:Class = null;
         var _loc3_:String = "effect_" + param1;
         var _loc4_:BitmapFrameInfos = BitmapDateSourseManager.getBitmapDatesByMovieClip(null,_loc3_,param2);
         if(_loc4_ == null)
         {
            _loc6_ = DomainAccess.getClass(_loc3_);
            _loc4_ = BitmapDateSourseManager.getBitmapDatesByMovieClip((new _loc6_() as MovieClip).getChildAt(0) as MovieClip,_loc3_,param2);
         }
         var _loc5_:CMovieClip = new CMovieClip(_loc4_,12);
         _loc5_.bitmap.x = _loc4_.getBaseMcTransform().matrix.tx;
         _loc5_.bitmap.y = _loc4_.getBaseMcTransform().matrix.ty;
         if(_loc4_.getBaseMcTransform().matrix.a < 0)
         {
            BitmapDateSourseManager.flipHorizontal(_loc5_);
         }
         return _loc5_;
      }
      
      public static function getAttackedPoint(param1:DisplayObject) : Point
      {
         var _loc2_:Point = new Point();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y - BattleMapManager.HEIGHT_GRID / 2;
         return _loc2_;
      }
      
      public static function getAwardMcType(param1:Object) : String
      {
         var _loc2_:String = "";
         if(param1 is Organism)
         {
            _loc2_ = Icon.ORGANISM_1;
         }
         else if(param1 is Tool)
         {
            _loc2_ = Icon.TOOL_1;
         }
         else if(param1 is Exp)
         {
            _loc2_ = Icon.SYSTEM_1;
         }
         return _loc2_;
      }
      
      public static function getAwardPicId(param1:Object) : int
      {
         if(param1 is Tool)
         {
            return (param1 as Tool).getPicId();
         }
         if(param1 is Organism)
         {
            return (param1 as Organism).getPicId();
         }
         if(param1 is Exp)
         {
            return (param1 as Exp).getPicId();
         }
         return 0;
      }
      
      public static function getBattleEnd() : MovieClip
      {
         var _loc1_:Class = null;
         if(battleEnd == null)
         {
            _loc1_ = DomainAccess.getClass("battle.battleField.end");
            battleEnd = new _loc1_();
         }
         battleEnd.gotoAndStop(1);
         battleEnd.visible = true;
         return battleEnd;
      }
      
      public static function getBattleField() : MovieClip
      {
         var _loc1_:Class = DomainAccess.getClass("battlefield");
         if(container == null)
         {
            container = new _loc1_();
            textMiaobian(container);
         }
         return container;
      }
      
      public static function getBattleStart() : MovieClip
      {
         var _loc1_:Class = null;
         if(battleStart == null)
         {
            _loc1_ = DomainAccess.getClass("battle.battleField.start");
            battleStart = new _loc1_();
         }
         battleStart.gotoAndStop(1);
         battleStart.visible = true;
         return battleStart;
      }
      
      public static function getBlood(param1:int, param2:int) : DisplayObject
      {
         if(container["blood_floor"].numChildren < 1)
         {
            return null;
         }
         return container["blood_floor"].getChildByName("blood_" + param1 + "_" + param2);
      }
      
      public static function removeBlood(param1:DisplayObject) : void
      {
         container["blood_floor"].removeChild(param1);
      }
      
      public static function lastBattleEffect(param1:BattleOrg, param2:Function) : void
      {
         var deadLightClass:Class;
         var deadLight:MovieClip = null;
         var onPlay:Function = null;
         var battlenode:BattleOrg = param1;
         var backFun:Function = param2;
         onPlay = function(param1:Event):void
         {
            battlenode.visible = true;
            if(deadLight.currentFrame == deadLight.totalFrames)
            {
               deadLight.removeEventListener(Event.ENTER_FRAME,onPlay);
               battlenode.removeChild(deadLight);
               battlenode.visible = false;
               backFun();
            }
         };
         if(battlenode == null)
         {
            return;
         }
         deadLightClass = DomainAccess.getClass("deadlight");
         deadLight = new deadLightClass();
         battlenode.addChild(deadLight);
         deadLight.gotoAndStop(1);
         deadLight.addEventListener(Event.ENTER_FRAME,onPlay);
         deadLight.gotoAndPlay(1);
      }
      
      public static function setSkillColor(param1:TextField, param2:int) : void
      {
         if(param2 < 6)
         {
            param1.textColor = 16777215;
         }
         else if(param2 < 11)
         {
            param1.textColor = 10092288;
         }
         else if(param2 < 21)
         {
            param1.textColor = 16711935;
         }
         else
         {
            param1.textColor = 16720418;
         }
      }
      
      public static function showPrizeFlap(param1:MovieClip, param2:DisplayObject, param3:DisplayObject, param4:int) : void
      {
         var timer:CTimer = null;
         var onTimer:Function = null;
         var t3:CTimer = null;
         var onTop:Function = null;
         var onTopComp:Function = null;
         var baseMc:MovieClip = param1;
         var flapMc:DisplayObject = param2;
         var effectMc:DisplayObject = param3;
         var t:int = param4;
         onTimer = function(param1:CTimerEvent):void
         {
            timer.removeEventListener(CTimerEvent.TIMER_COMPLETE,onTimer);
            timer.stop();
            timer = null;
            t3.start();
         };
         onTop = function(param1:CTimerEvent):void
         {
            flapMc.y -= 5;
         };
         onTopComp = function(param1:CTimerEvent):void
         {
            t3.removeEventListener(CTimerEvent.TIMER,onTop);
            t3.removeEventListener(CTimerEvent.TIMER_COMPLETE,onTopComp);
            t3.stop();
            t3 = null;
            baseMc.removeChild(flapMc);
         };
         timer = new CTimer(t,1);
         timer.addEventListener(CTimerEvent.TIMER_COMPLETE,onTimer);
         timer.start();
         t3 = new CTimer(50,20);
         t3.addEventListener(CTimerEvent.TIMER,onTop);
         t3.addEventListener(CTimerEvent.TIMER_COMPLETE,onTopComp);
         if(effectMc != null)
         {
            effectMc.visible = true;
         }
      }
      
      public static function showSkill(param1:Sprite, param2:Array) : void
      {
         var temp:Class;
         var i:int = 0;
         var skillT:CTimer = null;
         var onShowSkill:Function = null;
         var onShowSkillComp:Function = null;
         var g:Sprite = param1;
         var skills:Array = param2;
         onShowSkill = function(param1:CTimerEvent):void
         {
            var _loc2_:MovieClip = null;
            var _loc3_:String = null;
            if(SkillManager.getInstance.getSkillById((skills[i] as Skill).getId()).getTouchOff() == Skill.INITIATIVE)
            {
               showSkillLight(g as BattleOrg,(skills[i] as Skill).getGrade());
               _loc2_ = new temp();
               _loc3_ = "Lv" + (skills[i] as Skill).getGrade() + (skills[i] as Skill).getName();
               _loc2_["t"].text = _loc3_;
               setSkillColor(_loc2_["t"],(skills[i] as Skill).getGrade());
               FlapManager.flapInfos(getAttackedPoint(g).x,getAttackedPoint(g).y,container,_loc2_,1);
            }
            ++i;
         };
         onShowSkillComp = function(param1:CTimerEvent):void
         {
            skillT.stop();
            skillT.removeEventListener(CTimerEvent.TIMER,onShowSkill);
            skillT.removeEventListener(CTimerEvent.TIMER_COMPLETE,onShowSkillComp);
            skillT = null;
         };
         if(skills == null || skills.length < 1)
         {
            return;
         }
         temp = DomainAccess.getClass("skill");
         i = 0;
         skillT = new CTimer(200,skills.length);
         skillT.addEventListener(CTimerEvent.TIMER,onShowSkill);
         skillT.addEventListener(CTimerEvent.TIMER_COMPLETE,onShowSkillComp);
         skillT.start();
      }
      
      public static function showSkillLight(param1:BattleOrg, param2:int) : void
      {
         var light:MovieClip = null;
         var onPlay:Function = null;
         var g:BattleOrg = param1;
         var grade:int = param2;
         onPlay = function(param1:Event):void
         {
            if(light["light"].currentFrame == light["light"].totalFrames)
            {
               light["light"].removeEventListener(Event.ENTER_FRAME,onPlay);
               container["effect_floor"].removeChild(light);
            }
         };
         var temp:Class = null;
         if(grade < -6)
         {
            temp = DomainAccess.getClass("skill_light_" + 1);
         }
         else if(grade < -11)
         {
            temp = DomainAccess.getClass("skill_light_" + 2);
         }
         else
         {
            temp = DomainAccess.getClass("skill_light_" + 3);
         }
         light = new temp();
         light.name = "light";
         light["light"].gotoAndStop(1);
         light.x = g.x;
         light.y = g.y - BattleMapManager.HEIGHT_GRID / 2;
         container["effect_floor"].addChild(light);
         light["light"].addEventListener(Event.ENTER_FRAME,onPlay);
         light["light"].gotoAndPlay(1);
      }
      
      private static function textMiaobian(param1:MovieClip) : void
      {
         TextFilter.MiaoBian(param1["_title1"]["_grade1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_grade2"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title1"]["_title1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_title2"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title1"]["_name1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_name2"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title1"]["_appellation1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_appellation2"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title1"]["_rank1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_rank2"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title1"]["_wins1"],16777164,1,5,5);
         TextFilter.MiaoBian(param1["_title2"]["_wins2"],16777164,1,5,5);
      }
   }
}


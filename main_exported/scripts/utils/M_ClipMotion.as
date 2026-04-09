package utils
{
   import com.display.CMovieClip;
   import com.display.CMovieClipEvent;
   import core.managers.GameManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import manager.EffectManager;
   
   public class M_ClipMotion
   {
      
      public static const SOUL_UPGRADE_EFFECT:String = "soul_upgrade_effect";
      
      public static const GENIUS_UPGRADE_EFFECT:String = "genius_upgrade_effect";
      
      public function M_ClipMotion()
      {
         super();
      }
      
      public static function play_Up_GradeEffect(param1:Sprite, param2:String, param3:Function) : void
      {
         var playEnd:Function = null;
         var parent:Sprite = param1;
         var typename:String = param2;
         var backCommad:Function = param3;
         playEnd = function(param1:Event):void
         {
            var _loc2_:CMovieClip = param1.currentTarget as CMovieClip;
            _loc2_.visible = false;
            _loc2_.stop();
            _loc2_.removeEventListener(CMovieClipEvent.COMPLETE,playEnd);
            _loc2_.parent.removeChild(_loc2_);
            if(backCommad != null)
            {
               backCommad();
            }
         };
         var level_up_effect:CMovieClip = EffectManager.getUpgradeEffect(typename);
         parent.addChild(level_up_effect);
         level_up_effect.addEventListener(CMovieClipEvent.COMPLETE,playEnd);
      }
      
      public static function playUpQualityEffect(param1:Sprite, param2:Function) : void
      {
         var upEffect:MovieClip = null;
         var playEnd:Function = null;
         var parent:Sprite = param1;
         var backCommad:Function = param2;
         playEnd = function(param1:Event):void
         {
            if(upEffect.currentFrame == upEffect.totalFrames)
            {
               upEffect.removeEventListener(Event.ENTER_FRAME,playEnd);
               upEffect.gotoAndStop(1);
               parent.removeChild(upEffect);
               upEffect = null;
               if(backCommad != null)
               {
                  backCommad();
               }
               backCommad = null;
            }
         };
         upEffect = GetDomainRes.getMoveClip("quality_upgrade_effect");
         parent.addChild(upEffect);
         upEffect.addEventListener(Event.ENTER_FRAME,playEnd);
      }
      
      public static function playStarEffect(param1:MovieClip, param2:Function) : void
      {
         var playEnd:Function = null;
         var eff:MovieClip = param1;
         var backCommad:Function = param2;
         playEnd = function(param1:Event):void
         {
            if(eff.currentFrame == eff.totalFrames)
            {
               eff.removeEventListener(Event.ENTER_FRAME,playEnd);
               eff.gotoAndStop(eff.totalFrames);
               GameManager.getInstance().framerate = 12;
               if(backCommad != null)
               {
                  backCommad();
               }
               backCommad = null;
            }
         };
         GameManager.getInstance().framerate = 30;
         eff.addEventListener(Event.ENTER_FRAME,playEnd);
         eff.gotoAndPlay(1);
      }
      
      public static function playEffect(param1:MovieClip, param2:Function) : void
      {
         var playEnd:Function = null;
         var efft:MovieClip = param1;
         var backCommad:Function = param2;
         playEnd = function(param1:Event):void
         {
            if(efft.currentFrame == efft.totalFrames)
            {
               efft.removeEventListener(Event.ENTER_FRAME,playEnd);
               efft.gotoAndStop(efft.totalFrames);
               if(backCommad != null)
               {
                  backCommad();
               }
               backCommad = null;
            }
         };
         efft.addEventListener(Event.ENTER_FRAME,playEnd);
      }
   }
}


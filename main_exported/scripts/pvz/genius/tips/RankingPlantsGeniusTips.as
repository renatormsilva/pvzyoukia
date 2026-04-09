package pvz.genius.tips
{
   import core.ui.tips.BaseTips;
   import manager.LangManager;
   import pvz.genius.vo.Genius;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class RankingPlantsGeniusTips extends BaseTips
   {
      
      public function RankingPlantsGeniusTips()
      {
         super("GeniusSystem.RankingGeniusTips",false,15722382,12,0);
         this.MiaoBian();
      }
      
      private function MiaoBian() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 9)
         {
            TextFilter.MiaoBian(_ui["_skillName" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_level" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_effect" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_effectName" + _loc1_],0);
            _loc1_++;
         }
      }
      
      override public function show(param1:Object) : void
      {
         var _loc2_:Genius = param1.gift as Genius;
         if(!_loc2_)
         {
            return;
         }
         this.changeTxtColor(param1.level);
         _ui._level1.text = _loc2_.storm > 0 ? "Lv." + _loc2_.storm : LangManager.getInstance().getLanguage("tip012");
         _ui._level2.text = _loc2_.strong > 0 ? "Lv." + _loc2_.strong : LangManager.getInstance().getLanguage("tip012");
         _ui._level3.text = _loc2_.focus > 0 ? "Lv." + _loc2_.focus : LangManager.getInstance().getLanguage("tip012");
         _ui._level4.text = _loc2_.phantom > 0 ? "Lv." + _loc2_.phantom : LangManager.getInstance().getLanguage("tip012");
         _ui._level5.text = _loc2_.carzy > 0 ? "Lv." + _loc2_.carzy : LangManager.getInstance().getLanguage("tip012");
         _ui._level6.text = _loc2_.lightDefence > 0 ? "Lv." + _loc2_.lightDefence : LangManager.getInstance().getLanguage("tip012");
         _ui._level7.text = _loc2_.maskLevel > 0 ? "Lv." + _loc2_.maskLevel : LangManager.getInstance().getLanguage("tip012");
         _ui._level8.text = _loc2_.poison > 0 ? "Lv." + _loc2_.poison : LangManager.getInstance().getLanguage("tip012");
         _ui._level9.text = _loc2_.clear > 0 ? "Lv." + _loc2_.clear : LangManager.getInstance().getLanguage("tip012");
         if(_loc2_.storm > 0 && _loc2_.storm <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect1.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.STROM_ATTACK,_loc2_.storm).hurt;
         }
         if(_loc2_.strong > 0 && _loc2_.strong <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect2.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.STRONG,_loc2_.strong).hurt;
         }
         if(_loc2_.focus > 0 && _loc2_.focus <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect3.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.FOCUS,_loc2_.focus).hurt;
         }
         if(_loc2_.phantom > 0 && _loc2_.phantom <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect4.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.PHANTOM,_loc2_.phantom).hurt;
         }
         if(_loc2_.carzy > 0 && _loc2_.carzy <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect5.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.CAZRY_WIND,_loc2_.carzy).hurt;
         }
         if(_loc2_.lightDefence > 0 && _loc2_.lightDefence <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect6.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.LIGHT_DEFFENCE,_loc2_.lightDefence).triggerOdds + "%";
         }
         if(_loc2_.maskLevel > 0 && _loc2_.maskLevel <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect7.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.DEFEAT,_loc2_.maskLevel).triggerOdds + "%";
         }
         if(_loc2_.poison > 0 && _loc2_.poison <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect8.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.POISON,_loc2_.poison).hurt / 100 + "%";
         }
         if(_loc2_.clear > 0 && _loc2_.clear <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._effect9.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.CLEAR,_loc2_.clear).hurt / 100 + "%";
         }
      }
      
      private function changeTxtColor(param1:int) : void
      {
         _ui._skillName1.textColor = _ui._level1.textColor = _ui._effectName1.textColor = _ui._effect1.textColor = _ui._skillName2.textColor = _ui._level2.textColor = _ui._effectName2.textColor = _ui._effect2.textColor = _ui._skillName3.textColor = _ui._level3.textColor = _ui._effectName3.textColor = _ui._effect3.textColor = _ui._skillName4.textColor = _ui._level4.textColor = _ui._effectName4.textColor = _ui._effect4.textColor = _ui._skillName5.textColor = _ui._level5.textColor = _ui._effectName5.textColor = _ui._effect5.textColor = _ui._skillName6.textColor = _ui._level6.textColor = _ui._effectName6.textColor = _ui._effect6.textColor = _ui._skillName7.textColor = _ui._level7.textColor = _ui._effectName7.textColor = _ui._effect7.textColor = _ui._skillName8.textColor = _ui._level8.textColor = _ui._effectName8.textColor = _ui._effect8.textColor = _ui._skillName9.textColor = _ui._level9.textColor = _ui._effectName9.textColor = _ui._effect9.textColor = getSoulColorByLevel(param1);
      }
   }
}


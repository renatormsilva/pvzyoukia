package pvz.genius.tips
{
   import core.ui.tips.BaseTips;
   import flash.display.DisplayObject;
   import manager.LangManager;
   import pvz.genius.vo.Genius;
   import pvz.genius.vo.GeniusSystemConst;
   import pvz.genius.vo.SoulData;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class PlantsGeniusTips extends BaseTips
   {
      
      public function PlantsGeniusTips()
      {
         super("geniusSysterm.plantsGeniusTips",false,15722382,20,0);
         this.layout();
         this.MiaoBian();
      }
      
      private function MiaoBian() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 9)
         {
            TextFilter.MiaoBian(_ui["_section1"]["_level" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section1"]["_effect" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section1"]["_effectName" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section1"]["_skillName" + _loc1_],0);
            _loc1_++;
         }
         var _loc2_:int = 1;
         while(_loc2_ <= 7)
         {
            TextFilter.MiaoBian(_ui["_section2"]["_label" + _loc2_],0);
            TextFilter.MiaoBian(_ui["_section2"]["_num" + _loc2_],0);
            _loc2_++;
         }
         TextFilter.MiaoBian(_ui._name20,0);
      }
      
      override public function show(param1:Object) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:SoulData = null;
         var _loc5_:DisplayObject = null;
         var _loc2_:Genius = param1.gift as Genius;
         this.changeTxtColor(param1.soullevel);
         _ui._section1._level1.text = _loc2_.storm > 0 ? "Lv." + _loc2_.storm : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level2.text = _loc2_.strong > 0 ? "Lv." + _loc2_.strong : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level3.text = _loc2_.focus > 0 ? "Lv." + _loc2_.focus : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level4.text = _loc2_.phantom > 0 ? "Lv." + _loc2_.phantom : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level5.text = _loc2_.carzy > 0 ? "Lv." + _loc2_.carzy : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level6.text = _loc2_.lightDefence > 0 ? "Lv." + _loc2_.lightDefence : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level7.text = _loc2_.maskLevel > 0 ? "Lv." + _loc2_.maskLevel : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level8.text = _loc2_.poison > 0 ? "Lv." + _loc2_.poison : LangManager.getInstance().getLanguage("tip012");
         _ui._section1._level9.text = _loc2_.clear > 0 ? "Lv." + _loc2_.clear : LangManager.getInstance().getLanguage("tip012");
         if(_loc2_.storm > 0 && _loc2_.storm <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect1.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.STROM_ATTACK,_loc2_.storm).hurt;
         }
         if(_loc2_.strong > 0 && _loc2_.strong <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect2.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.STRONG,_loc2_.strong).hurt;
         }
         if(_loc2_.focus > 0 && _loc2_.focus <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect3.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.FOCUS,_loc2_.focus).hurt;
         }
         if(_loc2_.phantom > 0 && _loc2_.phantom <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect4.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.PHANTOM,_loc2_.phantom).hurt;
         }
         if(_loc2_.carzy > 0 && _loc2_.carzy <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect5.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.CAZRY_WIND,_loc2_.carzy).hurt;
         }
         if(_loc2_.lightDefence > 0 && _loc2_.lightDefence <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect6.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.LIGHT_DEFFENCE,_loc2_.lightDefence).triggerOdds + "%";
         }
         if(_loc2_.maskLevel > 0 && _loc2_.maskLevel <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect7.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.DEFEAT,_loc2_.maskLevel).triggerOdds + "%";
         }
         if(_loc2_.poison > 0 && _loc2_.poison <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect8.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.POISON,_loc2_.poison).hurt / 100 + "%";
         }
         if(_loc2_.clear > 0 && _loc2_.clear <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section1._effect9.text = ":" + XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.CLEAR,_loc2_.clear).hurt / 100 + "%";
         }
         if(param1.soullevel > 0)
         {
            _loc3_ = FuncKit.getStarDisBySoulLevel(param1.soullevel);
            _ui._starNode.addChild(_loc3_);
            _loc3_.y = -_loc3_.height / 2;
            _loc4_ = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(param1.soullevel);
            _ui._section2._num1.text = _loc4_.addHP + "%";
            _ui._section2._num2.text = _loc4_.addAttack + "%";
            _ui._section2._num3.text = _loc4_.addHit + "%";
            _ui._section2._num4.text = _loc4_.addMiss + "%";
            _ui._section2._num5.text = _loc4_.addSpeed + "%";
            _ui._section2._num6.text = _loc4_.addHurt + "%";
            _ui._section2._num7.text = _loc4_.reduceHurt + "%";
         }
         else
         {
            _loc5_ = FuncKit.getNumEffect("no");
            _ui._starNode.addChild(_loc5_);
            _loc5_.y = -_loc5_.height / 2;
         }
         this.layout();
      }
      
      private function changeTxtColor(param1:int) : void
      {
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            _ui["_section1"]["_skillName" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_section1"]["_level" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_section1"]["_effectName" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_section1"]["_effect" + _loc2_].textColor = getSoulColorByLevel(param1);
            _loc2_++;
         }
         var _loc3_:int = 1;
         while(_loc3_ <= 7)
         {
            _ui["_section2"]["_label" + _loc3_].textColor = getSoulColorByLevel(param1);
            _ui["_section2"]["_num" + _loc3_].textColor = getSoulColorByLevel(param1);
            _loc3_++;
         }
      }
      
      override protected function layout() : void
      {
         super.layout();
      }
   }
}


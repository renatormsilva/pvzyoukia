package pvz.genius.tips
{
   import entity.Organism;
   import flash.display.DisplayObject;
   import manager.LangManager;
   import pvz.genius.vo.Genius;
   import pvz.genius.vo.GeniusSystemConst;
   import pvz.genius.vo.SoulData;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class SoulTips extends BaseSectionsTips
   {
      
      private var _names:Array;
      
      public function SoulTips()
      {
         super("geniusSystem.soulsTips",false);
         this.maobian();
      }
      
      override protected function createTips() : void
      {
         _bg.draw(_ui.width + _leftgap,_ui.height + _upgap);
         this.layout();
      }
      
      override public function show(param1:Object) : void
      {
         var _loc5_:SoulData = null;
         var _loc6_:SoulData = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = null;
         var _loc2_:Organism = param1 as Organism;
         var _loc3_:int = _loc2_.getSoulLevel();
         var _loc4_:Genius = _loc2_.getGiftData();
         if(_loc3_ > 0 && _loc3_ <= GeniusSystemConst.SOUL_MAX_LEVEL)
         {
            _loc5_ = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(_loc3_);
         }
         if(_loc3_ >= 0 && _loc3_ < GeniusSystemConst.SOUL_MAX_LEVEL)
         {
            _loc6_ = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(_loc3_ + 1);
         }
         this.changeTextColor(_loc3_);
         FuncKit.clearAllChildrens(_ui._section1._node);
         if(_loc5_)
         {
            _loc7_ = FuncKit.getStarDisBySoulLevel(_loc3_);
            _ui._section1._node.addChild(_loc7_);
            _loc7_.y = -_loc7_.height / 2;
            _ui._section2._txt1.text = _loc5_.addHP + "%";
            _ui._section2._txt2.text = _loc5_.addAttack + "%";
            _ui._section2._txt3.text = _loc5_.addHit + "%";
            _ui._section2._txt4.text = _loc5_.addMiss + "%";
            _ui._section2._txt5.text = _loc5_.addSpeed + "%";
            _ui._section2._txt6.text = _loc5_.addHurt + "%";
            _ui._section2._txt7.text = _loc5_.reduceHurt + "%";
         }
         if(_loc6_)
         {
            _ui._section3._txt1.text = _loc6_.addHP + "%";
            _ui._section3._txt2.text = _loc6_.addAttack + "%";
            _ui._section3._txt3.text = _loc6_.addHit + "%";
            _ui._section3._txt4.text = _loc6_.addMiss + "%";
            _ui._section3._txt5.text = _loc6_.addSpeed + "%";
            _ui._section3._txt6.text = _loc6_.addHurt + "%";
            _ui._section3._txt7.text = _loc6_.reduceHurt + "%";
            this.lackLevels(_loc4_,_loc6_);
            this.showLacksLevelText(_loc6_);
         }
         else
         {
            _ui._section3.visible = false;
            _ui._section4.visible = false;
            _ui._section2.x = 40;
            _ui._section1.line.width = 180;
            _bg.draw(180,220,15722382);
            _ui.x = 0;
         }
         if(!_loc5_)
         {
            _loc8_ = FuncKit.getNumEffect("no");
            _ui._section1._node.addChild(_loc8_);
            _loc8_.y = -_loc8_.height / 2;
         }
      }
      
      private function showLacksLevelText(param1:SoulData) : void
      {
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            _ui["_section4"]["_txt" + _loc2_].text = "";
            _ui["_section4"]["_title" + _loc2_].text = "";
            _loc2_++;
         }
         var _loc3_:int = 1;
         while(_loc3_ <= this._names.length)
         {
            _ui["_section4"]["_txt" + _loc3_].text = "Lv." + this.getGeniusLevel(this._names[_loc3_ - 1],param1);
            _ui["_section4"]["_title" + _loc3_].text = this.getGeniusNameByString(this._names[_loc3_ - 1]);
            _loc3_++;
         }
      }
      
      private function getGeniusNameByString(param1:String) : String
      {
         if(param1 == "strong")
         {
            return LangManager.getInstance().getLanguage("genius037");
         }
         if(param1 == "storm")
         {
            return LangManager.getInstance().getLanguage("genius038");
         }
         if(param1 == "carzy")
         {
            return LangManager.getInstance().getLanguage("genius039");
         }
         if(param1 == "focus")
         {
            return LangManager.getInstance().getLanguage("genius040");
         }
         if(param1 == "phantom")
         {
            return LangManager.getInstance().getLanguage("genius041");
         }
         if(param1 == "lightDefence")
         {
            return LangManager.getInstance().getLanguage("genius042");
         }
         if(param1 == "maskLevel")
         {
            return LangManager.getInstance().getLanguage("genius043");
         }
         if(param1 == "poison")
         {
            return LangManager.getInstance().getLanguage("genius044");
         }
         if(param1 == "clear")
         {
            return LangManager.getInstance().getLanguage("genius045");
         }
         return "";
      }
      
      private function getGeniusLevel(param1:String, param2:SoulData) : int
      {
         if(param1 == "storm")
         {
            return param2.storm;
         }
         if(param1 == "strong")
         {
            return param2.strong;
         }
         if(param1 == "carzy")
         {
            return param2.carzy;
         }
         if(param1 == "focus")
         {
            return param2.focus;
         }
         if(param1 == "phantom")
         {
            return param2.phantom;
         }
         if(param1 == "lightDefence")
         {
            return param2.lightDefence;
         }
         if(param1 == "maskLevel")
         {
            return param2.maskLevel;
         }
         if(param1 == "poison")
         {
            return param2.poison;
         }
         if(param1 == "clear")
         {
            return param2.clear;
         }
         return 0;
      }
      
      private function lackLevels(param1:Genius, param2:SoulData) : void
      {
         this._names = [];
         if(param1.storm < param2.storm)
         {
            this._names.push("storm");
         }
         if(param1.strong < param2.strong)
         {
            this._names.push("strong");
         }
         if(param1.carzy < param2.carzy)
         {
            this._names.push("carzy");
         }
         if(param1.focus < param2.focus)
         {
            this._names.push("focus");
         }
         if(param1.phantom < param2.phantom)
         {
            this._names.push("phantom");
         }
         if(param1.lightDefence < param2.lightDefence)
         {
            this._names.push("lightDefence");
         }
         if(param1.maskLevel < param2.maskLevel)
         {
            this._names.push("maskLevel");
         }
         if(param1.poison < param2.poison)
         {
            this._names.push("poison");
         }
         if(param1.clear < param2.clear)
         {
            this._names.push("clear");
         }
      }
      
      override protected function layout() : void
      {
         super.layout();
         _ui._section1.x = _bg.width / 2 - _ui._section1.width / 2;
      }
      
      private function changeTextColor(param1:int) : void
      {
         var _loc2_:int = 1;
         while(_loc2_ <= 7)
         {
            _ui["_section2"]["_title" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_section2"]["_txt" + _loc2_].textColor = getSoulColorByLevel(param1);
            _ui["_section3"]["_title" + _loc2_].textColor = getSoulColorByLevel(param1 + 1);
            _ui["_section3"]["_txt" + _loc2_].textColor = getSoulColorByLevel(param1 + 1);
            _loc2_++;
         }
         _ui["_section2"]["_label1"].textColor = getSoulColorByLevel(param1);
         _ui["_section3"]["_label1"].textColor = getSoulColorByLevel(param1 + 1);
      }
      
      private function maobian() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            TextFilter.MiaoBian(_ui["_section2"]["_title" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section2"]["_txt" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section3"]["_title" + _loc1_],0);
            TextFilter.MiaoBian(_ui["_section3"]["_txt" + _loc1_],0);
            _loc1_++;
         }
         TextFilter.MiaoBian(_ui["_section2"]["_label1"],0);
         TextFilter.MiaoBian(_ui["_section3"]["_label1"],0);
         TextFilter.MiaoBian(_ui["_section4"]["_label1"],0);
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            TextFilter.MiaoBian(_ui["_section4"]["_title" + _loc2_],0);
            TextFilter.MiaoBian(_ui["_section4"]["_txt" + _loc2_],0);
            _loc2_++;
         }
      }
   }
}


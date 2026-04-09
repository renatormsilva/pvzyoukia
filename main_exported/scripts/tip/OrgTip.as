package tip
{
   import core.ui.tips.BaseTips;
   import entity.ExSkill;
   import entity.Organism;
   import entity.Skill;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import pvz.genius.vo.Genius;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   import xmlReader.config.XmlQualityConfig;
   import zlib.utils.DomainAccess;
   
   public class OrgTip extends BaseTips
   {
      
      private static var BEGIN_X:int = 10;
      
      private var _temp_class:Class;
      
      private var _background:MovieClip;
      
      private var nowwidth:int;
      
      private var nowheight:int = 0;
      
      private var _o:InteractiveObject;
      
      private var _org:Organism;
      
      public function OrgTip()
      {
         super();
         this._temp_class = DomainAccess.getClass("orgtip");
         this._background = new this._temp_class();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      public function setOrgtip(param1:InteractiveObject, param2:Organism) : void
      {
         this._o = param1;
         this._org = param2;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.setText();
      }
      
      override public function destroy() : void
      {
         this.hideTips();
         FuncKit.clearAllChildrens(this);
         this._org = null;
         this._o = null;
      }
      
      private function setText() : void
      {
         var wordsColor:uint;
         var genius:Genius;
         var m:int;
         var h:int;
         var sh:String;
         var sm:String;
         var color:uint = 0;
         var fadeArr:Array = null;
         var getStrtypeByQuality:Function = function(param1:int):String
         {
            return null;
         };
         this.clear();
         if(this._org == null)
         {
            return;
         }
         if(this._org.getQuality_name() != "")
         {
            color = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
            this.changeColor(color);
         }
         this._background["_name"].width = 125;
         this._background["_name"].text = this._org.getName();
         this._background._quality_name.text = this._org.getQuality_name();
         this._background._grade.text = this._org.getGrade();
         this._background._exp.text = int((this._org.getExp() - this._org.getExp_min()) / (this._org.getExp_max() - this._org.getExp_min() + 1) * 100) + "%";
         this._background._attribute_name.text = this._org.getAttribute_name();
         this._background._pullulation.text = this._org.getPullulation();
         wordsColor = 16777215;
         if(this._org.getQuality_name() != "")
         {
            wordsColor = XmlQualityConfig.getInstance().getColor(this._org.getQuality_name());
         }
         this._background._hp.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._org.getHp().toNumber(),this._org.getHp_max().toNumber(),wordsColor,wordsColor,13,2,true));
         this._background._attack.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getAttack(),wordsColor,13,true));
         this._background._precision.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getPrecision(),wordsColor,13,true));
         this._background._miss.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getMiss(),wordsColor,13,true));
         this._background._new_miss.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getNewMiss(),wordsColor,13,true));
         this._background._new_precision.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getNewPrecision(),wordsColor,13,true));
         this._background._speed.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getSpeed(),wordsColor,13,true));
         genius = this._org.getGiftData();
         if(genius)
         {
            if(genius.lightDefence > 0 && genius.lightDefence <= GeniusSystemConst.GENIUS_MAX_LEVEL)
            {
               this._background._genius_txt1.text = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.LIGHT_DEFFENCE,genius.lightDefence).triggerOdds + "%";
            }
            if(genius.maskLevel > 0 && genius.maskLevel <= GeniusSystemConst.GENIUS_MAX_LEVEL)
            {
               this._background._genius_txt2.text = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.DEFEAT,genius.maskLevel).triggerOdds + "%";
            }
            if(genius.poison > 0 && genius.poison <= GeniusSystemConst.GENIUS_MAX_LEVEL)
            {
               this._background._genius_txt3.text = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.POISON,genius.poison).hurt / 100 + "%";
            }
            if(genius.clear > 0 && genius.clear <= GeniusSystemConst.GENIUS_MAX_LEVEL)
            {
               this._background._genius_txt4.text = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(XmlGeniusDataConfig.CLEAR,genius.clear).hurt / 100 + "%";
            }
         }
         if(this._org.getFadeGeinus())
         {
            fadeArr = this._org.getFadeGeinus();
            this._background._genius_txt1.text = fadeArr[0] + "%";
            this._background._genius_txt2.text = fadeArr[1] + "%";
            this._background._genius_txt3.text = fadeArr[2] + "%";
            this._background._genius_txt4.text = fadeArr[3] + "%";
         }
         m = this._org.getPhotosynthesisTime() % 60;
         h = int(this._org.getPhotosynthesisTime() / 60);
         sh = "";
         sm = "";
         if(h != 0)
         {
            sh = h + LangManager.getInstance().getLanguage("hunting008");
         }
         if(m != 0)
         {
            sm = m + LangManager.getInstance().getLanguage("hunting009");
         }
         if(h != 0 || m != 0)
         {
            this._background._time.text = LangManager.getInstance().getLanguage("tip009") + sh + sm;
         }
         else
         {
            this._background._time.text = "";
         }
         if(this._org.getBattleE() != 0)
         {
            this._background._battlee.addChild(ArtWordsManager.instance.artWordsDisplay(this._org.getBattleE(),16748544,12,true));
         }
         this.showSkill();
         this.showExSkill();
         this._background.visible = true;
      }
      
      override public function clear() : void
      {
         this._background._genius_txt1.text = "0%";
         this._background._genius_txt2.text = "0%";
         this._background._genius_txt3.text = "0%";
         this._background._genius_txt4.text = "0%";
         FuncKit.clearAllChildrens(this._background._hp);
         FuncKit.clearAllChildrens(this._background._attack);
         FuncKit.clearAllChildrens(this._background._precision);
         FuncKit.clearAllChildrens(this._background._miss);
         FuncKit.clearAllChildrens(this._background._speed);
         FuncKit.clearAllChildrens(this._background._battlee);
         FuncKit.clearAllChildrens(this._background._new_precision);
         FuncKit.clearAllChildrens(this._background._new_miss);
      }
      
      private function changeColor(param1:uint) : void
      {
         this._background["_name"].textColor = param1;
         this._background._quality_name.textColor = param1;
         this._background._hp_title.textColor = param1;
         this._background._attack_title.textColor = param1;
         this._background._new_precision_title.textColor = param1;
         this._background._new_miss_title.textColor = param1;
         this._background._precision_title.textColor = param1;
         this._background._miss_title.textColor = param1;
         this._background._speed_title.textColor = param1;
         this._background._genius_title1.textColor = param1;
         this._background._genius_title2.textColor = param1;
         this._background._genius_title3.textColor = param1;
         this._background._genius_title4.textColor = param1;
         this._background._genius_txt1.textColor = param1;
         this._background._genius_txt2.textColor = param1;
         this._background._genius_txt3.textColor = param1;
         this._background._genius_txt4.textColor = param1;
      }
      
      private function showSkill() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 1;
         while(_loc1_ <= 4)
         {
            this._background["_skill" + _loc1_].text = "";
            _loc1_++;
         }
         if(this._org == null)
         {
            return;
         }
         if(this._org.getAllSkills() == null && this._org.getAllSkills().length < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._org.getAllSkills().length)
         {
            _loc3_ = _loc2_ + 1;
            this._background["_skill" + _loc3_].text = (this._org.getSkill(_loc2_) as Skill).getName() + " Lv " + (this._org.getSkill(_loc2_) as Skill).getGrade();
            this.showSkillColor(this._background["_skill" + _loc3_],(this._org.getSkill(_loc2_) as Skill).getGrade());
            _loc2_++;
         }
      }
      
      private function showExSkill() : void
      {
         var _loc2_:int = 0;
         this._background["_ex_skill1"].text = "";
         if(this._org == null)
         {
            return;
         }
         if(this._org.getAllExSkills() == null || this._org.getAllExSkills().length < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._org.getAllExSkills().length)
         {
            _loc2_ = _loc1_ + 1;
            this._background["_ex_skill" + _loc2_].text = (this._org.getExSkill(_loc1_) as ExSkill).getName() + " Lv " + (this._org.getExSkill(_loc1_) as ExSkill).getGrade();
            this.showSkillColor(this._background["_ex_skill" + _loc2_],(this._org.getExSkill(_loc1_) as ExSkill).getGrade());
            _loc1_++;
         }
      }
      
      private function showSkillColor(param1:TextField, param2:int) : void
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
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background["_name"],1118481);
         TextFilter.MiaoBian(this._background._quality_name,1118481);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.bold = true;
         this._background["_name"].setTextFormat(_loc1_);
         TextFilter.MiaoBian(this._background._grade_title,1118481);
         TextFilter.MiaoBian(this._background._grade,1118481);
         TextFilter.MiaoBian(this._background._attribute_title,1118481);
         TextFilter.MiaoBian(this._background._attribute_name,1118481);
         TextFilter.MiaoBian(this._background._exp_title,1118481);
         TextFilter.MiaoBian(this._background._exp,1118481);
         TextFilter.MiaoBian(this._background._pullulation_title,1118481);
         TextFilter.MiaoBian(this._background._pullulation,1118481);
         TextFilter.MiaoBian(this._background._battlePower,1118481);
         TextFilter.MiaoBian(this._background._hp_title,1118481);
         TextFilter.MiaoBian(this._background._attack_title,1118481);
         TextFilter.MiaoBian(this._background._speed_title,1118481);
         TextFilter.MiaoBian(this._background._new_precision_title,1118481);
         TextFilter.MiaoBian(this._background._new_miss_title,1118481);
         TextFilter.MiaoBian(this._background._precision_title,1118481);
         TextFilter.MiaoBian(this._background._miss_title,1118481);
         TextFilter.MiaoBian(this._background._time,1118481);
         TextFilter.MiaoBian(this._background._skill1,1118481);
         TextFilter.MiaoBian(this._background._skill2,1118481);
         TextFilter.MiaoBian(this._background._skill3,1118481);
         TextFilter.MiaoBian(this._background._skill4,1118481);
         TextFilter.MiaoBian(this._background._genius_title1,1118481);
         TextFilter.MiaoBian(this._background._genius_title2,1118481);
         TextFilter.MiaoBian(this._background._genius_title3,1118481);
         TextFilter.MiaoBian(this._background._genius_title4,1118481);
         TextFilter.MiaoBian(this._background._genius_txt1,1118481);
         TextFilter.MiaoBian(this._background._genius_txt2,1118481);
         TextFilter.MiaoBian(this._background._genius_txt3,1118481);
         TextFilter.MiaoBian(this._background._genius_txt4,1118481);
         TextFilter.MiaoBian(this._background._ex_skill1,1118481);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         var _loc3_:int = this._o.x + param1;
         var _loc4_:int = this._o.y + param2 - 100;
         this.x = _loc3_;
         if(_loc4_ < 5)
         {
            this.y = 5;
         }
         else if(_loc4_ > PlantsVsZombies.HEIGHT - this.height)
         {
            this.y = PlantsVsZombies.HEIGHT - this.height;
         }
         else
         {
            this.y = _loc4_;
         }
      }
   }
}


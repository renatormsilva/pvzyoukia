package pvz.genius.tips
{
   import core.ui.components.VGroupLayout;
   import entity.Organism;
   import entity.Tool;
   import flash.geom.Point;
   import manager.LangManager;
   import pvz.genius.vo.GeniusData;
   import pvz.genius.vo.GeniusSystemConst;
   import utils.FuncKit;
   import utils.TextFilter;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class GeniusBallTips extends BaseSectionsTips
   {
      
      public function GeniusBallTips()
      {
         super("geniusSystem.geniusBallTips",false);
         this.maobian();
      }
      
      private function maobian() : void
      {
         TextFilter.MiaoBian(_ui._section1._txt1,0);
         TextFilter.MiaoBian(_ui._section1._txt2,0);
         TextFilter.MiaoBian(_ui._section2._txt1,0);
         TextFilter.MiaoBian(_ui._section2._txt2,0);
         TextFilter.MiaoBian(_ui._section3._txt1,0);
         TextFilter.MiaoBian(_ui._section3._txt2,0);
         TextFilter.MiaoBian(_ui._section4._txt1,0);
         TextFilter.MiaoBian(_ui._section4._txt3,0);
         TextFilter.MiaoBian(_ui._section2._title1,0);
         TextFilter.MiaoBian(_ui._section2._title2,0);
         TextFilter.MiaoBian(_ui._section3._title1,0);
         TextFilter.MiaoBian(_ui._section3._title2,0);
         TextFilter.MiaoBian(_ui._section4._title1,0);
         TextFilter.MiaoBian(_ui._section4._title3,0);
      }
      
      override protected function createTips() : void
      {
         _layout = new VGroupLayout(new Point(0,0),15);
         _layout.addDisToGroup(_ui._section1);
         _layout.addDisToGroup(_ui._section2);
         _layout.addDisToGroup(_ui._section3);
         _layout.addDisToGroup(_ui._section4);
         _layout.tipsLayout();
         _bg.draw(_layout.getLayoutWidth() + _leftgap,_layout.getLayoutHeight() + _upgap);
         layout();
      }
      
      override public function show(param1:Object) : void
      {
         var _loc5_:GeniusData = null;
         var _loc6_:GeniusData = null;
         var _loc7_:Tool = null;
         _ui._section2.visible = true;
         _ui._section3.visible = true;
         _ui._section4.visible = true;
         var _loc2_:int = int(param1.level);
         this.changeTextColor(_loc2_);
         if(_loc2_ <= 0)
         {
            _ui._section2.visible = false;
         }
         if(_loc2_ >= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _ui._section3.visible = false;
            _ui._section4.visible = false;
         }
         var _loc3_:Organism = PlantsVsZombies.playerManager.getPlayer().getOrganismById(param1.orgid);
         var _loc4_:String = param1.type;
         if(_loc2_ > 0 && _loc2_ <= GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _loc5_ = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(_loc4_,_loc2_);
         }
         if(_loc2_ >= 0 && _loc2_ < GeniusSystemConst.GENIUS_MAX_LEVEL)
         {
            _loc6_ = XmlGeniusDataConfig.getInstance().getGeniusDataByIdAndLevel(_loc4_,_loc2_ + 1);
         }
         if(_loc5_)
         {
            _ui._section1._txt1.text = _loc5_.name;
            _ui._section1._txt2.text = _loc5_.info;
            _ui._section2._txt1.text = _loc2_;
            _ui._section2._title2.text = XmlGeniusDataConfig.getTitleByGeniusType(_loc4_);
            if(XmlGeniusDataConfig.isSpecilGeinius(_loc4_))
            {
               if(XmlGeniusDataConfig.isLightOrDefent(_loc4_))
               {
                  _ui._section2._txt2.text = _loc5_.triggerOdds + "%";
               }
               else
               {
                  _ui._section2._txt2.text = _loc5_.hurt / 100 + "%";
               }
            }
            else
            {
               _ui._section2._txt2.text = _loc5_.hurt;
            }
         }
         if(_loc6_)
         {
            _ui._section1._txt1.text = _loc6_.name;
            _ui._section1._txt2.text = _loc6_.info;
            _ui._section3._txt1.text = _loc2_ + 1;
            _ui._section3._title2.text = XmlGeniusDataConfig.getTitleByGeniusType(_loc4_);
            if(XmlGeniusDataConfig.isSpecilGeinius(_loc4_))
            {
               if(XmlGeniusDataConfig.isLightOrDefent(_loc4_))
               {
                  _ui._section3._txt2.text = _loc6_.triggerOdds + "%";
               }
               else
               {
                  _ui._section3._txt2.text = _loc6_.hurt / 100 + "%";
               }
            }
            else
            {
               _ui._section3._txt2.text = _loc6_.hurt;
            }
            if(PlantsVsZombies.playerManager.getPlayer().getGrade() < _loc6_.requiredUserGrade)
            {
               FuncKit.changeTextFieldColor(_ui._section4._txt1,16711680);
               _ui._section4._txt1.text = _loc6_.requiredUserGrade + LangManager.getInstance().getLanguage("genius028");
            }
            else
            {
               FuncKit.changeTextFieldColor(_ui._section4._txt1,16777215);
               _ui._section4._txt1.text = _loc6_.requiredUserGrade;
            }
            _loc7_ = PlantsVsZombies.playerManager.getPlayer().getTool(_loc6_.requiredTool.getOrderId());
            if(!_loc7_)
            {
               FuncKit.changeTextFieldColor(_ui._section4._txt3,16711680);
               _ui._section4._txt3.text = _loc6_.requiredTool.getName() + LangManager.getInstance().getLanguage("genius028");
            }
            else
            {
               FuncKit.changeTextFieldColor(_ui._section4._txt3,16777215);
               _ui._section4._txt3.text = _loc6_.requiredTool.getName();
            }
         }
         _layout.tipsLayout();
         _bg.draw(_layout.getLayoutWidth() + _leftgap,_layout.getLayoutHeight() + _upgap);
         layout();
      }
      
      private function changeTextColor(param1:int) : void
      {
         _ui._section1._txt1.textColor = _ui._section1._txt2.textColor = _ui._section2._txt1.textColor = _ui._section2._txt2.textColor = _ui._section2._title1.textColor = _ui._section2._title2.textColor = getSoulColorByLevel(param1);
         _ui._section3._txt1.textColor = _ui._section3._txt2.textColor = _ui._section3._title1.textColor = _ui._section3._title2.textColor = getSoulColorByLevel(param1 + 1);
      }
   }
}


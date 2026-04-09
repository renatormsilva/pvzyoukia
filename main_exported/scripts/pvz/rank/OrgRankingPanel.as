package pvz.rank
{
   import com.net.http.IURLConnection;
   import com.net.http.URLConnection;
   import constants.URLConnectionConstants;
   import entity.Organism;
   import entity.Player;
   import entity.Skill;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.EffectManager;
   import manager.SoundManager;
   import node.OrgLoader;
   import pvz.genius.tips.RankingPlantsGeniusTips;
   import pvz.genius.tips.RankingPlantsSoulTips;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import xmlReader.XmlBaseReader;
   import xmlReader.config.XmlQualityConfig;
   import xmlReader.firstPage.XmlRanking;
   import zlib.utils.DomainAccess;
   import zmyth.res.IDestroy;
   import zmyth.ui.TextFilter;
   
   public class OrgRankingPanel extends Sprite implements IURLConnection, IDestroy
   {
      
      private static const NUM:int = 8;
      
      internal var maxPage:int = 0;
      
      internal var nowArray:Array;
      
      internal var array:Array;
      
      internal var nowPage:int = 1;
      
      private var orgRank:Class;
      
      internal var panel:MovieClip = null;
      
      private var _curO:Organism;
      
      private var _soulTips:RankingPlantsSoulTips;
      
      private var _geniusTips:RankingPlantsGeniusTips;
      
      public function OrgRankingPanel(param1:int, param2:int)
      {
         super();
         var _loc3_:Class = DomainAccess.getClass("orgRankingPanel");
         this.panel = new _loc3_();
         this.panel.gotoAndStop(1);
         this.panel.visible = false;
         this.panel.x = param1;
         this.panel.y = param2;
         this.addMiaobian();
         this.addBtEvent();
         this.addChild(this.panel);
         PlantsVsZombies.showDataLoading(true);
         if(PlantsVsZombies.orgRankingArray == null)
         {
            this.urlloaderSend(PlantsVsZombies.getURL(URLConnectionConstants.URL_ORG_RANKING),0);
         }
         else
         {
            this.show();
         }
      }
      
      private function addMiaobian() : void
      {
         TextFilter.MiaoBian(this.panel["_pname"],0);
         TextFilter.MiaoBian(this.panel["_skill1"]["_skillinfo"],0);
         TextFilter.MiaoBian(this.panel["_skill2"]["_skillinfo"],0);
         TextFilter.MiaoBian(this.panel["_skill3"]["_skillinfo"],0);
         TextFilter.MiaoBian(this.panel["_skill4"]["_skillinfo"],0);
         TextFilter.MiaoBian(this.panel["_soulbtn"]["_txt"],0);
         TextFilter.MiaoBian(this.panel["_geniusbtn"]["_txt"],0);
      }
      
      private function removeMiaobian() : void
      {
         TextFilter.removeFilter(this.panel["_pname"]);
         TextFilter.removeFilter(this.panel["_skill1"]["_skillinfo"]);
         TextFilter.removeFilter(this.panel["_skill2"]["_skillinfo"]);
         TextFilter.removeFilter(this.panel["_skill3"]["_skillinfo"]);
         TextFilter.removeFilter(this.panel["_skill4"]["_skillinfo"]);
      }
      
      public function urlloaderSend(param1:String, param2:int) : void
      {
         var _loc3_:URLConnection = new URLConnection(param1,param2,this.onURLResult);
      }
      
      public function onURLResult(param1:int, param2:Object) : void
      {
         PlantsVsZombies.showDataLoading(false);
         var _loc3_:XmlRanking = new XmlRanking(param2 as String);
         if(_loc3_.isSuccess())
         {
            PlantsVsZombies.orgRankingArray = _loc3_.getOrgRankingInfo();
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
         this.show();
      }
      
      private function addBtEvent() : void
      {
         this.panel["_left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_right"].addEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_geniusbtn"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.panel["_soulbtn"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.panel["_soulbtn"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.panel["_geniusbtn"].addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_geniusbtn")
         {
            this._geniusTips = new RankingPlantsGeniusTips();
            this.panel.addChild(this._geniusTips);
            this._geniusTips.show({
               "gift":this._curO.getGiftData(),
               "level":this._curO.getSoulLevel()
            });
            this._geniusTips.setLocation(20,80);
         }
         else if(param1.currentTarget.name == "_soulbtn")
         {
            this._soulTips = new RankingPlantsSoulTips();
            this.panel.addChild(this._soulTips);
            this._soulTips.show(this._curO.getSoulLevel());
            this._soulTips.setLocation(40,115);
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_geniusbtn")
         {
            if(this._geniusTips)
            {
               this.panel.removeChild(this._geniusTips);
            }
         }
         else if(param1.currentTarget.name == "_soulbtn")
         {
            if(this._soulTips)
            {
               this.panel.removeChild(this._soulTips);
            }
         }
      }
      
      private function removeBtEvent() : void
      {
         this.panel["_left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this.panel["_right"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_left")
         {
            if(this.nowPage < 2)
            {
               return;
            }
            --this.nowPage;
            this.panel["_page"].text = this.nowPage + "/" + this.maxPage;
            this.nowArray = this.array.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
            this.doLayout();
         }
         else if(param1.currentTarget.name == "_right")
         {
            if(this.nowPage == this.maxPage)
            {
               return;
            }
            ++this.nowPage;
            this.panel["_page"].text = this.nowPage + "/" + this.maxPage;
            this.nowArray = this.array.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
            this.doLayout();
         }
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
      }
      
      private function doLayout() : void
      {
         var _loc2_:MovieClip = null;
         if(this.nowArray == null || this.nowArray.length < 1)
         {
            return;
         }
         this.clearInfo();
         var _loc1_:int = 0;
         while(_loc1_ < this.nowArray.length)
         {
            _loc2_ = this.getMc(this.nowArray[_loc1_][0] as Organism,this.nowArray[_loc1_][1] as Player,this.nowArray[_loc1_][2]);
            _loc2_.name = _loc1_ + "";
            this.panel["_info"].addChild(_loc2_);
            _loc2_.y = _loc1_ * (_loc2_.height + 1);
            _loc2_.mouseChildren = false;
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onMcClick);
            if(_loc1_ == 0)
            {
               this.setShowOrg(this.nowArray[_loc1_][0],this.nowArray[_loc1_][1],(this.nowPage - 1) * NUM + _loc1_ + 1);
               _loc2_.gotoAndStop(2);
            }
            _loc1_++;
         }
      }
      
      private function getMc(param1:Organism, param2:Player, param3:int) : MovieClip
      {
         var _loc6_:String = null;
         if(param2 == null)
         {
            return null;
         }
         if(this.orgRank == null)
         {
            this.orgRank = DomainAccess.getClass("_orgRank");
         }
         var _loc4_:MovieClip = new this.orgRank();
         _loc4_["_rankpic"].addChild(FuncKit.getNumEffect(param3 + "","Small"));
         var _loc5_:DisplayObject = null;
         if(param1.getBattleE() > 10 * 10000 * 10000 * 10000)
         {
            _loc5_ = FuncKit.getKexuejishufa(param1.getBattleE());
         }
         else
         {
            _loc6_ = GetDomainRes.getNumberSp(param1.getBattleE());
            _loc5_ = FuncKit.getNumEffect(_loc6_,"Exp");
         }
         _loc5_.x = -_loc5_.width / 2;
         _loc4_["_num"].addChild(_loc5_);
         PlantsVsZombies.setHeadPic(_loc4_["_headpic"],PlantsVsZombies.getHeadPicUrl(param2.getFaceUrl2()),PlantsVsZombies.HEADPIC_SMALL,param2.getVipTime(),param2.getVipLevel());
         _loc4_["_playerName"].text = param2.getNickname();
         _loc4_["_orgName"].text = param1.getName();
         _loc4_.gotoAndStop(1);
         return _loc4_;
      }
      
      private function changeOverType(param1:String) : void
      {
         if(this.panel["_info"] == null || this.panel["_info"].numChildren < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.panel["_info"].numChildren)
         {
            if(this.panel["_info"].getChildAt(_loc2_).name != param1)
            {
               this.panel["_info"].getChildAt(_loc2_).gotoAndStop(1);
            }
            else
            {
               this.panel["_info"].getChildAt(_loc2_).gotoAndStop(2);
            }
            _loc2_++;
         }
      }
      
      private function onMcClick(param1:MouseEvent) : void
      {
         PlantsVsZombies.playSounds(SoundManager.BUTTON2);
         this.changeOverType(param1.currentTarget.name);
         this.setShowOrg(this.nowArray[int(param1.currentTarget.name)][0],this.nowArray[int(param1.currentTarget.name)][1],this.nowArray[int(param1.currentTarget.name)][2]);
      }
      
      private function clearInfo() : void
      {
         if(this.panel["_info"] == null || this.panel["_info"].numChildren < 1)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.panel["_info"].numChildren)
         {
            this.panel["_info"].getChildAt(_loc1_).removeEventListener(MouseEvent.ROLL_OVER,this.onMcClick);
            _loc1_++;
         }
         FuncKit.clearAllChildrens(this.panel["_info"]);
      }
      
      public function destroy() : void
      {
         this.clearInfo();
         this.clearShowOrg();
         this.clearSkills();
         this.removeMiaobian();
         this.removeBtEvent();
         this.removeChild(this.panel);
      }
      
      private function show() : void
      {
         this.panel.visible = true;
         PlantsVsZombies.showDataLoading(false);
         this.clearSkills();
         this.nowArray = new Array();
         this.array = PlantsVsZombies.orgRankingArray;
         this.nowArray = this.array.slice((this.nowPage - 1) * NUM,this.nowPage * NUM);
         this.maxPage = (this.array.length - 1) / NUM + 1;
         this.panel["_page"].text = this.nowPage + "/" + this.maxPage;
         this.doLayout();
      }
      
      private function setShowOrg(param1:Organism, param2:Player, param3:int) : void
      {
         var temp:Class;
         var mc:MovieClip;
         var numMc:DisplayObject;
         var rankD:DisplayObject;
         var dis:DisplayObject = null;
         var o:Organism = param1;
         var p:Player = param2;
         var rank:int = param3;
         var showBattleE:Function = function(param1:int):void
         {
            var _loc3_:String = null;
            var _loc2_:DisplayObject = null;
            if(o.getBattleE() > 10 * 10000 * 10000 * 10000)
            {
               _loc2_ = FuncKit.getKexuejishufa(o.getBattleE());
            }
            else
            {
               _loc3_ = GetDomainRes.getNumberSp(o.getBattleE());
               _loc2_ = FuncKit.getNumEffect(_loc3_,"Exp");
            }
            _loc2_.x = -_loc2_.width / 2;
            panel["_battleE"].addChild(_loc2_);
         };
         var showQuality:Function = function():void
         {
            panel["_quality"].gotoAndStop(XmlQualityConfig.getInstance().getID(o.getQuality_name()));
         };
         var showSkills:Function = function(param1:Organism):void
         {
            clearSkills();
            if(param1.getAllSkills() == null || param1.getAllSkills().length < 1)
            {
               return;
            }
            var _loc2_:int = 0;
            while(_loc2_ < param1.getAllSkills().length)
            {
               showSkill(_loc2_ + 1,param1.getAllSkills()[_loc2_]);
               _loc2_++;
            }
         };
         var showSkill:Function = function(param1:int, param2:Skill):void
         {
            panel["_skill" + param1]["_skillinfo"].text = "";
            if(param2.getGrade() < 6)
            {
               panel["_skill" + param1].gotoAndStop(2);
               panel["_skill" + param1]["_skillinfo"].textColor = 16777215;
               panel["_skill" + param1]["_skillinfo"].text = "Lv." + param2.getGrade() + "  " + param2.getName();
            }
            else if(param2.getGrade() < 11)
            {
               panel["_skill" + param1].gotoAndStop(3);
               panel["_skill" + param1]["_skillinfo"].textColor = 10092288;
               if(param2.getGrade() == 10)
               {
                  panel["_skill" + param1]["_skillinfo"].text = "Lv." + param2.getGrade() + " " + param2.getName();
               }
               else
               {
                  panel["_skill" + param1]["_skillinfo"].text = "Lv." + param2.getGrade() + "  " + param2.getName();
               }
            }
            else if(param2.getGrade() < 21)
            {
               panel["_skill" + param1].gotoAndStop(4);
               panel["_skill" + param1]["_skillinfo"].textColor = 16711935;
               panel["_skill" + param1]["_skillinfo"].text = "Lv." + param2.getGrade() + " " + param2.getName();
            }
            else
            {
               panel["_skill" + param1].gotoAndStop(5);
               panel["_skill" + param1]["_skillinfo"].textColor = 16720418;
               panel["_skill" + param1]["_skillinfo"].text = "Lv." + param2.getGrade() + " " + param2.getName();
            }
            panel["_skill" + param1].visible = true;
         };
         this._curO = o;
         if(o == null || p == null)
         {
            return;
         }
         this.clearShowOrg();
         temp = DomainAccess.getClass("grade");
         mc = new temp();
         numMc = FuncKit.getNumEffect("" + o.getGrade(),"Small");
         numMc.y = -5;
         mc["num"].addChild(numMc);
         this.panel["_level"].addChild(mc);
         rankD = FuncKit.getNumEffect(rank + "","Small");
         rankD.x = -rankD.width / 2;
         this.panel["_rank"].addChild(rankD);
         if(o.getSoulLevel() <= 0)
         {
            this.panel["_soulbtn"].visible = this.panel["_geniusbtn"].visible = false;
         }
         else if(o.getSoulLevel() > 0)
         {
            this.panel["_soulbtn"].visible = this.panel["_geniusbtn"].visible = true;
            FuncKit.clearAllChildrens(this.panel["_soulbtn"]._node);
            FuncKit.clearAllChildrens(this.panel["_geniusbtn"]._node);
            FuncKit.changeTextFieldColor(this.panel["_soulbtn"]._txt,this.getColor(o.getSoulLevel()));
            FuncKit.changeTextFieldColor(this.panel["_geniusbtn"]._txt,this.getColor(o.getSoulLevel()));
            dis = EffectManager.getSoulEffect(o.getSoulLevel());
            dis.scaleX = 0.7;
            dis.scaleY = 0.7;
            this.panel["_soulbtn"]._node.addChild(dis);
            this.panel["_geniusbtn"]._node.addChild(EffectManager.getGeniusEffect(o.getSoulLevel(),0.7));
         }
         this.panel["_org"].addChild(new OrgLoader(o.getPicId(),0,null,1.7));
         this.panel["_pname"].text = p.getNickname();
         showSkills(o);
         showQuality();
         showBattleE(o.getBattleE());
      }
      
      private function clearSkills() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this.panel["_skill" + _loc1_].gotoAndStop(1);
            this.panel["_skill" + _loc1_]["_skillinfo"].text = "";
            this.panel["_skill" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function getColor(param1:int) : uint
      {
         if(param1 == 1)
         {
            return 16777215;
         }
         if(param1 == 2)
         {
            return 9621584;
         }
         if(param1 == 3)
         {
            return 45296;
         }
         if(param1 == 4)
         {
            return 3109571;
         }
         if(param1 == 5)
         {
            return 6684927;
         }
         if(param1 == 6)
         {
            return 16724940;
         }
         if(param1 == 7)
         {
            return 16776960;
         }
         if(param1 == 8)
         {
            return 16225862;
         }
         if(param1 == 9 || param1 == 10)
         {
            return 16711680;
         }
         return 1048575;
      }
      
      private function clearShowOrg() : void
      {
         if(this.panel["_org"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_org"]);
         }
         if(this.panel["_rank"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_rank"]);
         }
         if(this.panel["_battleE"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_battleE"]);
         }
         if(this.panel["_level"].numChildren > 0)
         {
            FuncKit.clearAllChildrens(this.panel["_level"]);
         }
      }
   }
}


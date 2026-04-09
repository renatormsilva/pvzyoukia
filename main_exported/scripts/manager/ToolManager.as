package manager
{
   import entity.Tool;
   import xmlReader.config.XmlChangeJewelConfig;
   
   public class ToolManager
   {
      
      public static const RMB:int = 2;
      
      public static const TOOL:int = 1;
      
      public static const WATER:int = 3;
      
      public static const FERTILISER:int = 4;
      
      public static const FLOWERPOT:int = 5;
      
      public static const CHALL_BOOK_ONE:int = 6;
      
      public static const CHALL_BOOK_FIVE:int = 7;
      
      public static const ARENA_BOOK:int = 8;
      
      public static const CHANGE:int = 1;
      
      public static const TIMES:int = 18;
      
      public static const TOOL_VIP_WEEK:int = 498;
      
      public static const TOOL_VIP_MONTH:int = 499;
      
      public static const TOOL_VIP_SEASON:int = 500;
      
      public static const TOOL_VIP_DAY:int = 775;
      
      public static const TOOL_COMP_PULLULATION:int = 17;
      
      public static const TOOL_COMP_QUALITY:int = 16;
      
      public static const TOOL_COMP_QUALITY_YAOSI:int = 834;
      
      public static const TOOL_COMP_QUALITY_BUXIU:int = 835;
      
      public static const TOOL_COMP_QUALITY_YONGHENG:int = 836;
      
      public static const TOOL_COMP_QUALITY_MOSHEN:int = 1071;
      
      public static const TOOL_COMP_SUPER_HP_BOOK:int = 1082;
      
      public static const TOOL_COMP_QUALITY_TAISHANG:int = 1061;
      
      public static const TOOL_COMP_QUALITY_HUNDUN:int = 1063;
      
      public static const TOOL_COMP_QUALITY_WUJI:int = 1065;
      
      public static const TOOL_WORLD_WORLD:int = 25;
      
      public static const TOOL_COMP_HP_1:int = 13;
      
      public static const TOOL_COMP_HP_2:int = 14;
      
      public static const TOOL_COMP_HP_3:int = 15;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_A:int = 614;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_B:int = 615;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_C:int = 616;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_D:int = 617;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_E:int = 1008;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_F:int = 1009;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_G:int = 1010;
      
      public static const TOOL_COMP_LIFE_INTENSIFY_BOOK_H:int = 1011;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_A:int = 618;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_B:int = 619;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_C:int = 620;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_D:int = 621;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_E:int = 1012;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_F:int = 1013;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_G:int = 1014;
      
      public static const TOOL_COMP_ATTACK_INTENSIFY_BOOK_H:int = 1015;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_A:int = 622;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_B:int = 623;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_C:int = 624;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_D:int = 625;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_E:int = 1016;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_F:int = 1017;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_G:int = 1018;
      
      public static const TOOL_COMP_DOOM_INTENSIFY_BOOK_H:int = 1019;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_A:int = 626;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_B:int = 627;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_C:int = 628;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_D:int = 629;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_E:int = 1020;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_F:int = 1021;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_G:int = 1022;
      
      public static const TOOL_COMP_DUCK_INTENSIFY_BOOK_H:int = 1023;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_A:int = 630;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_B:int = 631;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_C:int = 632;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_D:int = 633;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_E:int = 1024;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_F:int = 1025;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_G:int = 1026;
      
      public static const TOOL_COMP_SPEED_INTENSIFY_BOOK_H:int = 1027;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_A:int = 1095;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_B:int = 1096;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_C:int = 1097;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_D:int = 1098;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_E:int = 1099;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_F:int = 1100;
      
      public static const TOOL_COMP_NEW_MISS_INTENSIFY_BOOK_G:int = 1101;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_A:int = 1102;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_B:int = 1103;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_C:int = 1104;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_D:int = 1105;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_E:int = 1106;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_F:int = 1107;
      
      public static const TOOL_COMP_NEW_PRE_INTENSIFY_BOOK_G:int = 1108;
      
      public static const TOOL_COMP_HP:int = 445;
      
      public static const TOOL_COMP_ATT:int = 446;
      
      public static const TOOL_COMP_ATT_1078:int = 1078;
      
      public static const TOOL_COMP_MISS:int = 447;
      
      public static const TOOL_COMP_PRE:int = 448;
      
      public static const TOOL_COMP_SPEED:int = 449;
      
      public static const TOOL_COMP_NEW_MISS:int = 1093;
      
      public static const TOOL_COMP_NEW_PRECISION:int = 1094;
      
      public static const TOOL_COMP_CATALYST:int = 450;
      
      public static const TOOL_INHERIT_STRONGER_BOOK:int = 1139;
      
      public static const TOOL_POSSESSION_BATTLE:int = 507;
      
      public static const TOOL_POSSESSION_QUIT:int = 508;
      
      public static const TOOL_WORLD_ADDWORLD:int = 612;
      
      public static const TOOL_WORLD_ADDCHECKPOINT:int = 613;
      
      public static const TOOL_SERVER_MEDAL:int = 850;
      
      public static var compTools:Array = [12,18,48,74,613,634,463,471,833,837,1007,1028,1094,1109,1112,1121,2041,2050];
      
      public static var compToolsComp:Array = [444,450,1077,1079,1081,1083,1092,1095];
      
      public static var newQualityBook:Array = [1061,1063,1065];
      
      public static const GARDEN_BOOK:int = 2050;
      
      public function ToolManager()
      {
         super();
      }
      
      public static function checkMaterialTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Tool).getType() == ToolType.TOOL_TYPE1 + "")
            {
               if(!(param1[_loc3_].getOrderId() == ToolManager.TOOL_COMP_PULLULATION || param1[_loc3_].getOrderId() == ToolManager.TOOL_COMP_QUALITY || param1[_loc3_].getOrderId() == ToolManager.TOOL_COMP_QUALITY_MOSHEN))
               {
                  _loc2_.push(param1[_loc3_]);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function checkBoxTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((param1[_loc3_] as Tool).getType() == ToolType.TOOL_TYPE3 + "")
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function checkpointBookTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(ToolType.isBook(param1[_loc3_]))
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getJewelTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(ToolType.isJewel(param1[_loc3_]) && XmlChangeJewelConfig.getInstance().isUseToExchanged((param1[_loc3_] as Tool).getOrderId()))
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getAllJewelTools(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         if(param1 == null || param1.length < 1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(ToolType.isJewel(param1[_loc3_]))
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}


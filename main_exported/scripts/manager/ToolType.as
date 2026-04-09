package manager
{
   import entity.Tool;
   
   public class ToolType
   {
      
      public static const TOOL_TYPE:int = -1;
      
      public static const TOOL_TYPE1:int = 1;
      
      public static const TOOL_TYPE3:int = 3;
      
      public static const TOOL_TYPE4:int = 4;
      
      public static const TOOL_TYPE5:int = 5;
      
      public static const TOOL_TYPE6:int = 6;
      
      public static const TOOL_TYPE7:int = 7;
      
      public static const TOOL_TYPE8:int = 8;
      
      public static const TOOL_TYPE9:int = 9;
      
      public static const TOOL_TYPE11:int = 11;
      
      public static const TOOL_TYPE12:int = 12;
      
      public static const TOOL_TYPE13:int = 13;
      
      public static const TOOL_TYPE14:int = 14;
      
      public static const TOOL_TYPE15:int = 15;
      
      public static const TOOL_TYPE16:int = 16;
      
      public static const TOOL_TYPE21:int = 21;
      
      public static const TOOL_TYPE22:int = 22;
      
      public static const TOOL_TYPE23:int = 23;
      
      public static const TOOL_TYPE24:int = 24;
      
      public static const TOOL_TYPE25:int = 25;
      
      public static const TOOL_TYPE26:int = 26;
      
      public static const TOOL_TYPE27:int = 27;
      
      public static const TOOL_TYPE28:int = 28;
      
      public static const TOOL_TYPE29:int = 29;
      
      public static const TOOL_TYPE30:int = 30;
      
      public static const TOOL_TYPE31:int = 31;
      
      public static const TOOL_TYPE33:int = 33;
      
      public static const TOOL_TYPE34:int = 34;
      
      public static const TOOL_TYPE35:int = 35;
      
      public static const TOOL_TYPE36:int = 36;
      
      public static const TOOL_TYPE37:int = 37;
      
      public static const TOOL_TYPE38:int = 38;
      
      public static const TOOL_TYPE39:int = 39;
      
      public static const TOOL_TYPE40:int = 40;
      
      public static const TOOL_TYPE41:int = 41;
      
      public static const TOOL_TYPE42:int = 42;
      
      public static const TOOL_TYPE43:int = 43;
      
      public static const TOOL_TYPE44:int = 44;
      
      public static const TOOL_TYPE56:int = 56;
      
      public static const TOOL_TYPE57:int = 57;
      
      public static const TOOL_TYPE60:int = 60;
      
      public static const TOOL_TYPE61:int = 61;
      
      public static const TOOL_TYPE62:int = 62;
      
      public static const TOOL_TYPE63:int = 63;
      
      public static const TOOL_TYPE64:int = 64;
      
      public static const TOOL_TYPE65:int = 65;
      
      public static const TOOL_TYPE66:int = 66;
      
      public static const TOOL_TYPE67:int = 67;
      
      public static const TOOL_TYPE68:int = 68;
      
      public static const TOOL_TYPE69:int = 69;
      
      public static const TOOL_TYPE70:int = 70;
      
      public static const TOOL_TYPE71:int = 71;
      
      public static const TOOL_TYPE72:int = 72;
      
      public static const TOOL_TYPE73:int = 73;
      
      public static const TOOL_TYPE74:int = 74;
      
      public static const TOOL_TYPE75:int = 75;
      
      public static const TOOL_TYPE76:int = 76;
      
      public static const TOOL_TYPE77:int = 77;
      
      public static const TOOL_TYPE78:int = 78;
      
      public static const TOOL_TYPE79:int = 79;
      
      public static const TOOL_TYPE80:int = 80;
      
      public static const TOOL_TYPE81:int = 81;
      
      public static const TOOL_TYPE82:int = 82;
      
      public static const TOOL_TYPE83:int = 83;
      
      public function ToolType()
      {
         super();
      }
      
      public static function isJewel(param1:Tool) : Boolean
      {
         if(int(param1.getType()) >= TOOL_TYPE36 && int(param1.getType()) <= TOOL_TYPE44)
         {
            return true;
         }
         return false;
      }
      
      public static function isBook(param1:Tool) : Boolean
      {
         if(ToolManager.newQualityBook.indexOf(param1.getOrderId()) > -1 || param1.getType() == TOOL_TYPE4 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE5 + "" || param1.getType() == TOOL_TYPE6 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE7 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE8 + "" || param1.getType() == TOOL_TYPE9 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE21 + "" || param1.getType() == TOOL_TYPE22 + "" || param1.getType() == TOOL_TYPE23 + "" || param1.getType() == TOOL_TYPE24 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE25 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE27 + "" || param1.getType() == TOOL_TYPE28 + "" || param1.getType() == TOOL_TYPE29 + "" || param1.getType() == TOOL_TYPE30 + "" || param1.getType() == TOOL_TYPE31 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE11 + "" || param1.getType() == TOOL_TYPE12 + "" || param1.getType() == TOOL_TYPE13 + "" || param1.getType() == TOOL_TYPE14 + "" || param1.getType() == TOOL_TYPE15 + "" || param1.getType() == TOOL_TYPE16 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE33 + "" || param1.getType() == TOOL_TYPE34 + "" || param1.getType() == TOOL_TYPE35 + "")
         {
            return true;
         }
         if(param1.getOrderId() == ToolManager.TOOL_COMP_PULLULATION || param1.getOrderId() == ToolManager.TOOL_COMP_QUALITY || param1.getOrderId() == ToolManager.TOOL_COMP_QUALITY_MOSHEN)
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE57 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE56 + "")
         {
            return true;
         }
         if(param1.getOrderId() == ToolManager.TOOL_COMP_ATT_1078 || param1.getOrderId() == ToolManager.TOOL_COMP_SUPER_HP_BOOK)
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE60 + "" || param1.getType() == TOOL_TYPE61 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE62 + "" || param1.getType() == TOOL_TYPE63 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE64 + "" || param1.getType() == TOOL_TYPE65 + "" || param1.getType() == TOOL_TYPE66 + "" || param1.getType() == TOOL_TYPE67 + "" || param1.getType() == TOOL_TYPE68 + "" || param1.getType() == TOOL_TYPE69 + "" || param1.getType() == TOOL_TYPE70 + "" || param1.getType() == TOOL_TYPE71 + "" || param1.getType() == TOOL_TYPE72 + "")
         {
            return true;
         }
         if(int(param1.getType()) >= TOOL_TYPE73 && int(param1.getType()) <= TOOL_TYPE80)
         {
            return true;
         }
         return false;
      }
      
      public static function isDoingTool(param1:Tool) : Boolean
      {
         if(param1.getType() == TOOL_TYPE4 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE7 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE8 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE3 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE21 + "" || param1.getType() == TOOL_TYPE22 + "" || param1.getType() == TOOL_TYPE23 + "" || param1.getType() == TOOL_TYPE24 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE25 + "")
         {
            return true;
         }
         if(param1.getType() == TOOL_TYPE57 + "")
         {
            return true;
         }
         return false;
      }
      
      public static function isVip(param1:Tool) : Boolean
      {
         if(param1.getType() == TOOL_TYPE21 + "" || param1.getType() == TOOL_TYPE22 + "" || param1.getType() == TOOL_TYPE23 + "" || param1.getType() == TOOL_TYPE24 + "")
         {
            return true;
         }
         return false;
      }
      
      public static function isMorph(param1:Tool) : Boolean
      {
         if(int(param1.getType()) == TOOL_TYPE82 || int(param1.getType()) == TOOL_TYPE83)
         {
            return true;
         }
         return false;
      }
   }
}


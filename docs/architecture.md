┌─────────────────────────────┐
   QML UI             
   Speedometer, Settings,     
   Diagnostics, Music, Maps   
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
       C++ Backend Layer    
├─────────────────────────────┤
  Vehicle Data Manager       
  Settings Manager             
  Music Manager                
  Navigation Manager          
  Weather Manager              
  Diagnostics Manager         
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
  Communication Layer       
├─────────────────────────────┤
  CAN Manager                    
  UART Manager                   
  STM32 Protocol Parser      
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
  STM32 / Vehicle Controller  
└─────────────────────────────┘

+---------------------+
|     IDataSource     |
+---------------------+
           |
    ----------------
    |              |
    v              v

TelemetrySimulator  SerialManager

           |
           v

      VehicleData

           |
           v

          QML
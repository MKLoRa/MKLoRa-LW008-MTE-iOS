#
# Be sure to run `pod lib lint MKLoRaWAN-MTE.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaWAN-MTE'
  s.version          = '0.0.3'
  s.summary          = 'LW008-MT.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MKLoRa/LW008-MT-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MKLoRa/LW008-MT-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKLoRaWAN-MTE' => ['MKLoRaWAN-MTE/Assets/*.png']
  }
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaWAN-MTE/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'DatabaseManager' do |ss|
    
    ss.subspec 'SyncDatabase' do |sss|
      sss.source_files = 'MKLoRaWAN-MTE/Classes/DatabaseManager/SyncDatabase/**'
    end
    
    ss.subspec 'LogDatabase' do |sss|
      sss.source_files = 'MKLoRaWAN-MTE/Classes/DatabaseManager/LogDatabase/**'
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'FMDB'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaWAN-MTE/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaWAN-MTE/Classes/Target/**'
    
    ss.dependency 'MKLoRaWAN-MTE/Functions'
  end
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaWAN-MTE/Classes/ConnectModule/**'
    
    ss.dependency 'MKLoRaWAN-MTE/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Expand' do |ss|
    
    ss.subspec 'TextButtonCell' do |sss|
      sss.source_files = 'MKLoRaWAN-MTE/Classes/Expand/TextButtonCell/**'
    end
    
    ss.subspec 'FilterCell' do |sss|
      sss.subspec 'FilterBeaconCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Expand/FilterCell/FilterBeaconCell/**'
      end
      
      sss.subspec 'FilterByRawDataCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Expand/FilterCell/FilterByRawDataCell/**'
      end
      
      sss.subspec 'FilterEditSectionHeaderView' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Expand/FilterCell/FilterEditSectionHeaderView/**'
      end
      
      sss.subspec 'FilterNormalTextFieldCell' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Expand/FilterCell/FilterNormalTextFieldCell/**'
      end
      
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AuxiliaryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/AuxiliaryPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DownlinkPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/VibrationPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/ManDownPage/Controller'
      end
    end
    
    ss.subspec 'AxisSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/AxisSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/AxisSettingPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/AxisSettingPage/Model/**'
      end
    end
    
    ss.subspec 'BatteryConsumptionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BatteryConsumptionPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BatteryConsumptionPage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BatteryConsumptionPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BatteryConsumptionPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BatteryConsumptionPage/View/**'
      end
    end
    
    ss.subspec 'BleFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleFixPage/Controller/**'
      
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleFixPage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleFixPage/View'
      
        ssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleFixPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleFixPage/View/**'
      end
    end
    
    ss.subspec 'BleSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleSettingsPage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleSettingsPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleSettingsPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/BleSettingsPage/View/**'
      end
      
    end
    
    ss.subspec 'DebuggerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DebuggerPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DebuggerPage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DebuggerPage/View/**'
      end
      
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DeviceInfoPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DeviceInfoPage/Model'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/UpdatePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/SelftestPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DebuggerPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BatteryConsumptionPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DeviceInfoPage/Model/**'
      end
      
    end
    
    ss.subspec 'DeviceModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DeviceModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/StandbyModePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimingModePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/PeriodicModePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/MotionModePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimeSegmentedModePage/Controller'
      end
    end
    
    ss.subspec 'DeviceSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DeviceSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DeviceSettingPage/Model'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/SynDataPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/IndicatorSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DeviceInfoPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/OnOffSettingsPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DeviceSettingPage/Model/**'
      end
      
    end
    
    ss.subspec 'DownlinkPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/DownlinkPage/Controller/**'
      end
    end
    
    ss.subspec 'FilterPages' do |sss|
      
      sss.subspec 'FilterByAdvNamePage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByAdvNamePage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByAdvNamePage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByAdvNamePage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBeaconPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBeaconPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBeaconPage/Header'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBeaconPage/Model'
          
        end
        
        ssss.subspec 'Header' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBeaconPage/Header/**'
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBeaconPage/Model/**'
          
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBeaconPage/Header'
        end
      end
      
      sss.subspec 'FilterByMacPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByMacPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByMacPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByMacPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByOtherPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByOtherPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByOtherPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByOtherPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByPirPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByPirPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByPirPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByPirPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByRawDataPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByRawDataPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByRawDataPage/Model'
          
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBeaconPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByUIDPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByURLPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByTLMPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByTofPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBXPButtonPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBXPTagPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByOtherPage/Controller'
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByPirPage/Controller'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByRawDataPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByTofPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByTofPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByTofPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByTofPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByTLMPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByTLMPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByTLMPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByTLMPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByUIDPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByUIDPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByUIDPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByUIDPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByURLPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByURLPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByURLPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByURLPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBXPButtonPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBXPButtonPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBXPButtonPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBXPButtonPage/Model/**'
        end
      end
      
      sss.subspec 'FilterByBXPTagPage' do |ssss|
        ssss.subspec 'Controller' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBXPTagPage/Controller/**'
        
          sssss.dependency 'MKLoRaWAN-MTE/Functions/FilterPages/FilterByBXPTagPage/Model'
          
        end
      
        ssss.subspec 'Model' do |sssss|
          sssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/FilterPages/FilterByBXPTagPage/Model/**'
        end
      end
      
    end
    
    ss.subspec 'GeneralPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/GeneralPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/GeneralPage/Model'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DeviceModePage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/AuxiliaryPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleSettingsPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/AxisSettingPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/GeneralPage/Model/**'
      end
      
    end
    
    ss.subspec 'IndicatorSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/IndicatorSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/IndicatorSettingsPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/IndicatorSettingsPage/Model/**'
      end
      
    end
    
    ss.subspec 'LCGpsFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LCGpsFixPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LCGpsFixPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LCGpsFixPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaApplicationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaApplicationPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaApplicationPage/Model'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/MessageTypePage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaApplicationPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaPage/Model'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaSettingPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaApplicationPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaPage/Model/**'
      end
      
    end
    
    ss.subspec 'LoRaSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaSettingPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaSettingPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/LoRaSettingPage/Model/**'
      end
      
    end
    
    ss.subspec 'ManDownPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/ManDownPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/ManDownPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/ManDownPage/Model/**'
      end
    end
    
    ss.subspec 'MessageTypePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/MessageTypePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/MessageTypePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/MessageTypePage/Model/**'
      end
    end
    
    ss.subspec 'MotionModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/MotionModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/MotionModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/MotionModePage/Model/**'
      end
      
    end
    
    ss.subspec 'OnOffSettingsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/OnOffSettingsPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/OnOffSettingsPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/OnOffSettingsPage/Model/**'
      end
      
    end
    
    ss.subspec 'OutdoorFixPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/OutdoorFixPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/OutdoorFixPage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/OutdoorFixPage/Model/**'
      end
      
    end
    
    ss.subspec 'PeriodicModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/PeriodicModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/PeriodicModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/PeriodicModePage/Model/**'
      end
      
    end
    
    ss.subspec 'PositionPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/PositionPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/PositionPage/Model'
                
        ssss.dependency 'MKLoRaWAN-MTE/Functions/BleFixPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LCGpsFixPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/OutdoorFixPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/PositionPage/Model/**'
      end
      
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/ScanPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/ScanPage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/ScanPage/View'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TabBarPage/Controller'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/ScanPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/ScanPage/Model'
      end
    end
    
    ss.subspec 'SelftestPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/SelftestPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/SelftestPage/View'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/SelftestPage/Model'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/SelftestPage/View/**'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/SelftestPage/Model/**'
      end
    end
    
    ss.subspec 'StandbyModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/StandbyModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/StandbyModePage/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/StandbyModePage/Model/**'
      end
    end
    
    ss.subspec 'SynDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/SynDataPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/SynDataPage/View'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/SynDataPage/View/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/LoRaPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/PositionPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/GeneralPage/Controller'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/DeviceSettingPage/Controller'
      end
    end
    
    ss.subspec 'TimeSegmentedModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimeSegmentedModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimeSegmentedModePage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimeSegmentedModePage/View'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimeSegmentedModePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimeSegmentedModePage/View/**'
      end
    end
    
    ss.subspec 'TimingModePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimingModePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimingModePage/Model'
        ssss.dependency 'MKLoRaWAN-MTE/Functions/TimingModePage/View'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimingModePage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/TimingModePage/View/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/UpdatePage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/UpdatePage/Model'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.subspec 'VibrationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/VibrationPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-MTE/Functions/VibrationPage/Model'
        
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-MTE/Classes/Functions/VibrationPage/Model/**'
      end
    end
    
    ss.dependency 'MKLoRaWAN-MTE/SDK'
    ss.dependency 'MKLoRaWAN-MTE/DatabaseManager'
    ss.dependency 'MKLoRaWAN-MTE/CTMediator'
    ss.dependency 'MKLoRaWAN-MTE/ConnectModule'
    ss.dependency 'MKLoRaWAN-MTE/Expand'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary',   '4.13.0'
    
  end
  
end

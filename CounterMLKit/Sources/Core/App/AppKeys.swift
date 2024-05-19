//
//  AppKeys.swift
//  
//
//  Created by Daniil Shmoylov on 18.05.2024.
//

import Foundation

public enum AppKeys {
    private static func settingsKey(
      _ key: String
    ) -> String { "CounterML-iOS.appSettings.\(key)" }
    
    public enum Identifier {
        public static let bgTaskManager: String = "com.DaniilShmoylove.CounterML-iOS.CLASSIFICATION_DATA_DOWNLOAD"
    }
    
    public enum FPath {
        public static let gtmSessionUrl: String = "https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetID}"
    }
}

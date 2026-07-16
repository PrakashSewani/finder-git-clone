import Foundation
import os.log

public enum Log {
    private static let subsystem = "com.findergitclone.app"

    public static let general = Logger(subsystem: subsystem, category: "general")
    public static let git = Logger(subsystem: subsystem, category: "git")
    public static let detection = Logger(subsystem: subsystem, category: "detection")
    public static let editor = Logger(subsystem: subsystem, category: "editor")
    public static let ui = Logger(subsystem: subsystem, category: "ui")
}

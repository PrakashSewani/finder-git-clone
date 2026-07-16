import Cocoa
import FinderSync

class FinderSyncExtension: FIFinderSync {
    override init() {
        super.init()
        let home = FileManager.default.homeDirectoryForCurrentUser
        let downloads = home.appendingPathComponent("Downloads")
        let desktop = home.appendingPathComponent("Desktop")
        let documents = home.appendingPathComponent("Documents")
        let projects = home.appendingPathComponent("Projects")
        var dirs: Set<URL> = [home, downloads, desktop, documents, projects]

        if let volumes = try? FileManager.default.contentsOfDirectory(atPath: "/Volumes") {
            for vol in volumes where !vol.hasPrefix(".") {
                dirs.insert(URL(fileURLWithPath: "/Volumes/\(vol)"))
            }
        }

        FIFinderSyncController.default().directoryURLs = dirs
        NSLog("FinderGitClone: Monitoring directories: \(dirs.map(\.path))")
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForItems ||
              menuKind == .contextualMenuForContainer else {
            return nil
        }

        let menu = NSMenu(title: "")

        let cloneItem = NSMenuItem(
            title: "Clone Repository...",
            action: #selector(cloneRepository(_:)),
            keyEquivalent: ""
        )
        cloneItem.image = NSImage(
            systemSymbolName: "arrow.down.doc",
            accessibilityDescription: "Clone Repository"
        )
        cloneItem.target = self
        cloneItem.representedObject = menuKind
        menu.addItem(cloneItem)

        return menu
    }

    @objc private func cloneRepository(_ sender: NSMenuItem) {
        let targetPath: String

        if let menuKind = sender.representedObject as? FIMenuKind {
            switch menuKind {
            case .contextualMenuForItems:
                guard let items = FIFinderSyncController.default().selectedItemURLs(),
                      let firstItem = items.first else {
                    return
                }
                if firstItem.hasDirectoryPath {
                    targetPath = firstItem.deletingLastPathComponent().path
                } else {
                    targetPath = firstItem.deletingLastPathComponent().path
                }

            case .contextualMenuForContainer:
                guard let container = FIFinderSyncController.default().targetedURL() else {
                    return
                }
                targetPath = container.path

            default:
                return
            }
        } else {
            return
        }

        openHostApp(with: targetPath)
    }

    private func openHostApp(with targetPath: String) {
        guard let encodedPath = targetPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "findergitclone://clone?path=\(encodedPath)") else {
            return
        }

        NSWorkspace.shared.open(url)
    }
}

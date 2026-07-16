import Testing
@testable import FinderGitCloneCore

@Suite("GitProgress Tests")
struct GitProgressTests {
    @Test("Parse counting objects")
    func parseCounting() {
        let line = "Receiving objects:  45% (1234/2743)"
        let progress = GitProgress.parse(line: line)
        #expect(progress != nil)
        #expect(progress?.phase == .receiving)
        #expect(progress?.percentage == 45.0)
        #expect(progress?.objectCount == "1234")
        #expect(progress?.totalObjects == "2743")
    }

    @Test("Parse resolving deltas")
    func parseResolving() {
        let line = "Resolving deltas: 100% (500/500), done."
        let progress = GitProgress.parse(line: line)
        #expect(progress != nil)
        #expect(progress?.phase == .resolving)
        #expect(progress?.percentage == 100.0)
    }

    @Test("Parse counting without percentage")
    func parseCountingNoPercentage() {
        let line = "Counting objects: 100% (2743/2743), done."
        let progress = GitProgress.parse(line: line)
        #expect(progress != nil)
        #expect(progress?.phase == .counting)
    }

    @Test("Parse compressing objects")
    func parseCompressing() {
        let line = "Compressing objects: 100% (1234/1234), done."
        let progress = GitProgress.parse(line: line)
        #expect(progress != nil)
        #expect(progress?.phase == .compressing)
    }

    @Test("Empty line returns nil")
    func emptyLine() {
        let progress = GitProgress.parse(line: "")
        #expect(progress == nil)
    }

    @Test("Irrelevant line returns nil")
    func irrelevantLine() {
        let progress = GitProgress.parse(line: "remote: Enumerating objects: 1234, done.")
        #expect(progress == nil)
    }

    @Test("Progress value is normalized")
    func progressValue() {
        let progress = GitProgress(phase: .receiving, percentage: 45.0)
        #expect(progress.progressValue == 0.45)
    }

    @Test("Nil percentage gives zero progress")
    func nilPercentage() {
        let progress = GitProgress(phase: .counting)
        #expect(progress.progressValue == 0.0)
    }

    @Test("Display text includes percentage")
    func displayText() {
        let progress = GitProgress(phase: .receiving, percentage: 75.0)
        #expect(progress.displayText.contains("75%"))
    }

    @Test("Phase ordering")
    func phaseOrdering() {
        #expect(GitProgress.Phase.counting.order < GitProgress.Phase.compressing.order)
        #expect(GitProgress.Phase.compressing.order < GitProgress.Phase.receiving.order)
        #expect(GitProgress.Phase.receiving.order < GitProgress.Phase.resolving.order)
        #expect(GitProgress.Phase.resolving.order < GitProgress.Phase.done.order)
    }
}
